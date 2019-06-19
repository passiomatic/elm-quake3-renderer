module Sky exposing (makeMesh, bindShader, findShader)

{-| Sky functions.

Adapted from https://www.flipcode.com/archives/Sky_Domes.shtml
-}

import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import BoundingBox exposing (BoundingBox)
import Shaders.Pipeline as Pipeline exposing (ShaderPipeline, Vertex)
import WebGL.Texture as Texture exposing (Texture)
import WebGL exposing (Mesh)
import Array exposing (Array)
import Color 

domeSubdivisions = 
    8


{-| Return, if any, the first sky shader pipeline defined in the arena.
-}
findShader : List ShaderPipeline -> Maybe ShaderPipeline
findShader shaders =
    shaders
        |> List.filter Pipeline.isSky
        |> List.head



bindShader: Maybe ShaderPipeline -> List (Mesh Vertex) -> List ShaderPipeline 
bindShader maybeShader domeMeshes = 

    case maybeShader of 
        Just shader -> 
            domeMeshes
                |> List.map (\mesh -> 
                    shader
                        |> Pipeline.setMesh mesh
                ) 

        Nothing ->
            -- Just skip sky
            [ Pipeline.empty ]



makeMesh : Float -> List (Mesh Vertex)
makeMesh zSweep = 
    let
        -- Dome can be much smaller compared to the world since we trick the 
        -- viewer by always moving it together with the camera and rendering it
        -- outside the arena bounds using the depth buffer.
        radius = 
            64

        points =
            -- Place at the origin, will translate to the camera position at runtime
            domePoints domeSubdivisions zSweep radius (vec3 0 0 0)
    
        scale =
            1.0 / (radius * 2)

    in
    [ topDomeMesh domeSubdivisions scale points
    , bottomDomeMesh domeSubdivisions scale (Array.fromList points) 
    ]
    

{-| Top of the dome.
-}
topDomeMesh : Int -> Float -> List Vec3 -> Mesh Vertex
topDomeMesh subdivisions scale points =
    case points of
        first :: second :: rest ->
            -- First vertex staying on the center. The fan closes back to the second vertex
            List.append (first :: second :: List.take (subdivisions * 4 - 1) rest) [ second ]
                |> List.map (makeVertex scale)
                |> WebGL.triangleFan

        _ ->
            WebGL.triangleFan (List.map (makeVertex scale) points)


{-| Bottom dome rings. 

See here: http://www.corehtml5.com/trianglestripfundamentals.php
-}
bottomDomeMesh : Int -> Float -> Array Vec3 -> Mesh Vertex
bottomDomeMesh subdivisions scale points =
    let
        delta =
            -- Four quadrants
            subdivisions * 4

        newPoints =
            -- Start advancing vertically, skipping the top vertex
            List.range 1 (subdivisions - 1)
                |> List.foldl
                    (\j jj ->
                        let
                            start =
                                delta * j + 1

                            end =
                                start + delta

                            kk =
                                -- Advance horizontally, making a ring
                                List.range start (end - 1)
                                    |> List.foldl
                                        (\i ii ->
                                            let
                                                -- Emit two vertices for the quad
                                                maybeV0 =
                                                    Array.get (i - delta) points

                                                maybeV1 =
                                                    Array.get i points
                                            in
                                            case ( maybeV0, maybeV1 ) of
                                                ( Just v0, Just v1 ) ->
                                                    List.append ii [v0, v1]

                                                _ ->
                                                   ii
                                        )
                                        jj

                            -- Mark the end of the row with the degenerate triangles. We can do this
                            -- by repeating the last vertex of the previous row, and the first vertex 
                            -- of the this row. 

                            maybeV2 =
                                Array.get (start - delta) points

                            maybeV3 =
                                Array.get start points

                        in
                        case ( maybeV2, maybeV3 ) of
                            ( Just v2, Just v3 ) ->
                                List.append kk [v2, v3] 

                            _ ->
                                kk
                    )
                    []
    in
    newPoints
        |> List.map (makeVertex scale)
        |> WebGL.triangleStrip


makeVertex : Float -> Vec3 -> Vertex
makeVertex scale point =
    let
        s =
            Vec3.dot point (vec3 scale 0 0)

        t =
            Vec3.dot point (vec3 0 scale 0)
    in
    Vertex
        point
        (vec2 s t)
        (vec2 0 0) -- Unused
        (vec3 0 0 0) -- Unused
        Color.teal -- Assign a color for debug



domePoints : Int -> Float -> Float -> Vec3 -> List Vec3
domePoints subdivisions zSweep radius origin =
    let
        angle =
            degrees (90 - zSweep)

        -- Adjust the radius based on the z sweep
        radiusWithZSweep =
            radius / cos angle

        zAdjustment =
            radiusWithZSweep * sin angle

        -- The first point is the very top of the dome
        firstPoint =
            vec3 0 0 (radiusWithZSweep - zAdjustment)
                |> Vec3.add origin

        zSweepStep =
            degrees (zSweep / toFloat subdivisions)

        -- Compute the angular horizontal sweep of one quadrant of the dome
        sweep =
            degrees (90 / toFloat subdivisions)


        otherPoints =
            -- Starting from the top, populate with subdivisions number of rings
            List.range 0 (subdivisions - 1)
                |> List.foldr
                    (\i ii ->
                        let
                            -- Compute the point that will be rotated around to make a ring
                            matrix =
                                Mat4.identity
                                    -- Rotate around Y
                                    |> Mat4.rotate (zSweepStep * (toFloat i + 1)) Vec3.j

                            { x, y, z } =
                                Mat4.transform matrix (vec3 0 0 radiusWithZSweep)
                                    |> Vec3.toRecord

                            point =
                                vec3 x y (z - zAdjustment)
                        in
                        -- Loop through the ring creating the points
                        List.range 0 (subdivisions * 4 - 1)
                            |> List.foldr
                                (\j jj ->
                                    let
                                        matrix_ =
                                            Mat4.identity
                                                |> Mat4.rotate (sweep * toFloat j) Vec3.k
                                    in
                                    -- Rotate around Z
                                    (Mat4.transform matrix_ point
                                        |> Vec3.add origin
                                    )
                                        :: jj
                                )
                                ii
                    )
                    []
    in
    firstPoint :: otherPoints

