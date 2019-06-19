module Scene exposing
    ( Scene
    , compile
    , draw
    )

import Arena exposing (Arena, BrushLump, FaceLump, ModelLump)
import Array exposing (Array)
import Bezier
import BoundingBox exposing (BoundingBox)
import BspTree exposing (BspTree(..))
import Dict exposing (Dict)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vector2 exposing (Vec2)
import Math.Vector3 as Vector3 exposing (Vec3)
import Math.Vector4 as Vector4 exposing (Vec4)
import Plane exposing (Plane)
import Shaders.Pipeline as Pipeline exposing (ShaderPipeline, SortOrder(..), TextureDef(..), Vertex)
import Shaders.ShaderDef exposing (ShaderDef(..))
import Sky
import WebGL exposing (Entity, Mesh)
--import WebGL.Settings.DepthTest as DepthTest
import WebGL.Texture as Texture exposing (Texture)


draw : Float -> Dict String Texture -> List ShaderPipeline -> Mat4 -> Mat4 -> List Entity -> List Entity
draw time textures shaders modelView projection accum =
    List.foldr
        (\shader accum_ ->
            toEntities time textures shader modelView projection accum_
        )
        accum
        shaders


toEntities : Float -> Dict String Texture -> ShaderPipeline -> Mat4 -> Mat4 -> List Entity -> List Entity
toEntities time textures shader modelView projection accum =
    List.foldr
        (\stage accum_ ->
            let
                maybeMesh =
                    shader.mesh

                -- Resolve lightmap
                maybeLightmap =
                    Dict.get shader.lightmap textures

                -- Resolve texture
                maybeTexture =
                    (case stage.map of
                        Name name ->
                            Just name

                        Lightmap ->
                            Just shader.lightmap

                        Animation frequency names ->
                            let
                                index =
                                    modBy (Array.length names) (floor (time * frequency))
                            in
                            Array.get index names
                    )
                        |> Maybe.andThen (\name -> Dict.get name textures)
            in
            case ( maybeTexture, maybeLightmap, maybeMesh ) of
                ( Just texture, Just lightmap, Just mesh ) ->
                    WebGL.entityWith
                        stage.settings
                        stage.vertexShader
                        stage.fragmentShader
                        mesh
                        { texture = texture
                        , lightmap = lightmap
                        , projection = projection
                        , modelView = modelView
                        , time = time
                        }
                        :: accum_

                _ ->
                    -- For debug, if texture or lightmap lookup fails use vertex colors
                    -- WebGL.entityWith
                    --     [ DepthTest.default ]
                    --     ShaderPipeline.fallbackVertexShader
                    --     ShaderPipeline.fallbackFragmentShader
                    --     mesh
                    --     { projection = projection
                    --     , modelView = modelView
                    --     }
                    accum_
        )
        accum
        shader.stages


type alias Scene =
    { tree : BspTree
    , arena : List ShaderPipeline
    , sky : List ShaderPipeline
    , lightmaps : List String
    , textures : List String
    }


compile : Arena -> Scene
compile arena =
    let
        tree =
            Maybe.map3
                (\nodes leaves planes ->
                    BspTree.make nodes leaves planes
                )
                arena.nodes
                arena.leaves
                arena.planes
                -- Unable to create a valid BSP tree
                |> Maybe.withDefault Empty

        -- TODO
        -- brushes =
        --     makeBrushes arena.planes arena.brushSides arena.brushes
        ( newVertices, faces ) =
            makeFaces arena.vertices arena.meshIndices arena.faces

        -- _ =
        --     Debug.log "shaders" (Array.map .name arena.shaders)
        shaders =
            groupFaces faces
                |> makeShaders newVertices arena.shaders

        skyShaders =
            Sky.bindShader
                (Sky.findShader shaders)
                (Sky.makeMesh 50)

        -- TODO combine with lightmaps
        textures =
            List.map
                (\shader ->
                    Pipeline.textures shader
                )
                shaders
                |> List.concat

        arenaShaders =
            shaders
                |> removeSkyShader
                |> sortShaders
    in
    { tree = tree
    , arena = arenaShaders
    , sky = skyShaders
    , lightmaps = arena.lightmaps
    , textures = textures
    }


{-| Record describing the surfaces of the map. There are four types of faces: polygons (1), patches (2), meshes (3), and billboards (4). Several fields have different meanings depending on the face type.

  - Polygons, `firstMeshIndex` and `meshCount` describe a valid polygon triangulation. Every three mesh vertices describe a triangle. Each mesh vertex index is an offset from the first vertex of the face, given by `firstVertexIndex`.
  - Patches, `firstVertexIndex` and `vertexCount` describe a 2D rectangular grid of control vertices with dimensions given by `patchSize`. Within this rectangular grid, regions of 3×3 vertices represent biquadratic Bezier patches.
  - Meshes, `firstMeshIndex` and `meshCount` are used to describe the independent triangles that form the mesh. As with polygon faces, every three mesh vertices describe a triangle, and each mesh vertex is an offset from the first vertex of the face, given by `firstVertexIndex`.
  - Billboards, `firstVertexIndex` describes the single vertex that determines the location of the billboard. Billboards are used for effects such as flares.

-}
type alias Face =
    { type_ : Int
    , shaderIndex : Int
    , effectIndex : Int
    , lightmapIndex : Int
    , indices : List ( Int, Int, Int )
    , normal : Vec3
    }


{-| Make faces from faces' lump. Currently face type 1, 2, and 3 are redendered.
-}
makeFaces : Array Vertex -> Array Int -> Array FaceLump -> ( Array Vertex, List Face )
makeFaces vertices indices lumps =
    let
        toFace : FaceLump -> Face
        toFace lump =
            let
                newIndices =
                    Array.slice lump.firstMeshIndex (lump.firstMeshIndex + lump.meshCount) indices
                        |> Array.map (\index -> lump.firstVertexIndex + index)
                        |> Array.toList
                        |> chunk3
            in
            Face
                lump.type_
                lump.shaderIndex
                lump.effectIndex
                lump.lightmapIndex
                newIndices
                lump.normal

        ( newVertices, newFaces ) =
            Array.foldl
                (\lump ( vertices_, faces ) ->
                    case lump.type_ of
                        1 ->
                            -- Convex polygon
                            ( vertices_, toFace lump :: faces )

                        2 ->
                            -- Bezier patch
                            let
                                patchVertices =
                                    Array.slice lump.firstVertexIndex (lump.firstVertexIndex + lump.vertexCount) vertices

                                tessellationVertices =
                                    Bezier.tessellate tessellationLevel lump.patchSize patchVertices

                                indexOffset =
                                    Array.length vertices_

                                newIndices =
                                    Bezier.indices tessellationLevel lump.patchSize
                                        |> List.map (\( i, j, k ) -> ( i + indexOffset, j + indexOffset, k + indexOffset ))

                                face =
                                    Face
                                        lump.type_
                                        lump.shaderIndex
                                        lump.effectIndex
                                        lump.lightmapIndex
                                        newIndices
                                        lump.normal
                            in
                            ( Array.append vertices_ tessellationVertices, face :: faces )

                        3 ->
                            -- MD3 model merged into the BSP file
                            ( vertices_, toFace lump :: faces )

                        _ ->
                            ( vertices_, faces )
                )
                ( vertices, [] )
                lumps
    in
    ( newVertices, newFaces )


tessellationLevel =
    8


makeShaders : Array Vertex -> Array ShaderDef -> List ( ( Int, Int, Int ), List Face ) -> List ShaderPipeline
makeShaders vertices defs groupedFaces =
    List.map
        (\( ( shaderIndex, lightmapIndex, faceType ), faces ) ->
            let
                indices =
                    List.concatMap .indices faces

                mesh =
                    WebGL.indexedTriangles (Array.toList vertices) indices

                shader =
                    case Array.get shaderIndex defs of
                        Just ref ->
                            case ref of
                                Custom shader_ ->
                                    shader_
                                        |> Pipeline.setLightmap (lightmapName lightmapIndex)

                                UseTexture name ->
                                    if isModel faceType then
                                        Pipeline.model name

                                    else
                                        Pipeline.default name (lightmapName lightmapIndex)

                        Nothing ->
                            Pipeline.noShader
            in
            shader
                |> Pipeline.setMesh mesh
        )
        groupedFaces


isModel : Int -> Bool
isModel faceType =
    faceType == 3


lightmapName : Int -> String
lightmapName index =
    -- Use default lightmap?
    if index < 0 then
        "$whiteimage"

    else
        String.fromInt index


chunk3 : List Int -> List ( Int, Int, Int )
chunk3 indices =
    case indices of
        first :: second :: third :: rest ->
            ( first, second, third ) :: chunk3 rest

        _ ->
            []


{-| Sort shaders to correctly render opaque and transparent overlapping surfaces.
-}
sortShaders : List ShaderPipeline -> List ShaderPipeline
sortShaders shaders =
    List.sortBy
        (\shader ->
            case shader.sortOrder of
                Farthest ->
                    1

                -- Sky ->
                --     2
                Opaque ->
                    3

                Banner ->
                    6

                Underwater ->
                    8

                Transparent ->
                    9

                Nearest ->
                    16

                SortValue value ->
                    value
        )
        shaders


removeSkyShader : List ShaderPipeline -> List ShaderPipeline
removeSkyShader shaders =
    List.filter (\shader -> not (Pipeline.isSky shader)) shaders


{-| Group given faces by their shader and lightmap indices.
-}
groupFaces : List Face -> List ( ( Int, Int, Int ), List Face )
groupFaces faces =
    List.foldl
        (\face accum ->
            Dict.update ( face.shaderIndex, face.lightmapIndex, face.type_ )
                (\maybeV ->
                    case maybeV of
                        Just v ->
                            Just (face :: v)

                        Nothing ->
                            Just [ face ]
                )
                accum
        )
        Dict.empty
        faces
        |> Dict.toList
