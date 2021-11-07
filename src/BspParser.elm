module BspParser exposing (parse)

{-| BSP file data structures and parsing.

File format reference at <http://www.mralligator.com/q3/>

-}

import Arena exposing (Arena, BrushLump, BspLeafLump, BspNodeLump, EffectLump, FaceLump, ModelLump)
import Array exposing (Array)
import Bitwise exposing (and, or, shiftLeftBy)
import BoundingBox exposing (BoundingBox)
import Bytes exposing (Bytes, Endianness(..))
import Bytes.Parser as P exposing (Parser)
import Color
import GameParser exposing (GameEntity)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import Plane exposing (Plane)
import Shaders.Pipeline as Pipeline exposing (Vertex)
import Shaders.ShaderDef as ShaderDef exposing (ShaderDef)
import Vendor.Image as Image
import Vendor.Image.BMP as BMP


{-| The BSP file header. Contains a directory which identifies the offset and length of each lump. Lumps are listed in the directory in this order:

0 Entities, game entities
1 Shaders, surface descriptions
2 Planes, used by BSP tree and brushes
3 Nodes, BSP tree nodes
4 Leafs, BSP tree leaves
5 Leaf faces, lists of face indices - one list per leaf
6 Leaf brushes, lists of brush indices - one list per leaf
7 Models, descriptions of rigid world geometry in map
8 Brushes, convex volume used to describe solid space
9 Brush sides, brush surfaces
10 Vertices, used to describe faces
11 Mesh indices, lists of offsets - one list per mesh
12 Effects, list of special map effects
13 Faces, surface geometry
14 Light maps, packed lightmap data
15 Light volumes, local illumination data
16 Visdata, cluster-cluster visibility data

-}
type alias Header =
    { magic : String
    , version : Int
    , lumpRefs : Array LumpRef
    }


type alias LumpRef =
    { offset : Int
    , length : Int
    }


type Error
    = UnsupportedVersion



-- PARSING


{-| Top function to parse the entire BSP file.
-}
parse : Bytes -> Result (P.Error c Error) Arena
parse data =
    P.run headerParser data
        |> Result.map
            (\header ->
                let
                    lump index =
                        Array.get index header.lumpRefs
                in
                Arena
                    (lump 0
                        |> Maybe.andThen (parseEntities data)
                        |> Maybe.withDefault []
                    )
                    (lump 1
                        |> Maybe.andThen (parseShaders data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 2
                        |> Maybe.andThen (parsePlanes data)
                    )
                    (lump 3
                        |> Maybe.andThen (parseNodes data)
                    )
                    (lump 4
                        |> Maybe.andThen (parseLeaves data)
                    )
                    (lump 6
                        |> Maybe.andThen (parseIndices data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 7
                        |> Maybe.andThen (parseModels data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 8
                        |> Maybe.andThen (parseBrushes data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 9
                        |> Maybe.andThen (parseBrushSides data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 10
                        |> Maybe.andThen (parseVertices data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 11
                        |> Maybe.andThen (parseIndices data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 12
                        |> Maybe.andThen (parseEffects data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 13
                        |> Maybe.andThen (parseFaces data)
                        |> Maybe.withDefault Array.empty
                    )
                    (lump 14
                        |> Maybe.andThen (parseLightmaps data)
                        |> Maybe.withDefault []
                    )
            )


headerParser : Parser c Error Header
headerParser =
    P.map3 Header
        (P.string 4)
        (P.signedInt32 LE)
        (P.repeat lumpRefParser 17
            |> P.map Array.fromList
        )



-- TODO check if valid
-- (P.map2 isValid
--     (P.string 4)
--     (P.signedInt32 LE))
-- |> P.andThen (\valid ->
--     if valid then
--         (P.repeat lumpRefParser 17
--             |> P.map Array.fromList
--         )
--     else
--         (P.fail UnsupportedVersion)
-- )


{-| Check magic string and version for BSP files distributed with Quake 3 Arena.
-}
isValid : String -> Int -> Bool
isValid magic version =
    magic == "IBSP" && version == 46


lumpRefParser : Parser c e LumpRef
lumpRefParser =
    P.succeed LumpRef
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)


parseEntities : Bytes -> LumpRef -> Maybe (List GameEntity)
parseEntities data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.string length)
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse entities lump, skipped." err)
        |> Result.map GameParser.run
        |> Result.toMaybe


parsePlanes : Bytes -> LumpRef -> Maybe (Array Plane)
parsePlanes data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat planeParser (length // 16)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse planes lump, skipped." err)
        |> Result.toMaybe


planeParser : Parser c e Plane
planeParser =
    P.succeed Plane
        |> P.keep vec3Parser
        |> P.keep (P.float32 LE)


parseVertices : Bytes -> LumpRef -> Maybe (Array Vertex)
parseVertices data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat vertexParser (length // 44))
            |> P.map Array.fromList
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse vertices lump, skipped." err)
        |> Result.toMaybe


vertexParser : Parser c e Vertex
vertexParser =
    P.succeed Vertex
        |> P.keep vec3Parser
        |> P.keep vec2ParserInv
        |> P.keep vec2ParserInv
        |> P.keep vec3Parser
        |> P.keep colorParser


parseShaders : Bytes -> LumpRef -> Maybe (Array ShaderDef)
parseShaders data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat shaderParser (length // 72)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse shaders lump, skipped." err)
        |> Result.toMaybe


shaderParser : Parser c e ShaderDef
shaderParser = 
    P.succeed ShaderDef.resolve
        |> P.keep (P.map trimNulls (P.string 64))
        |> P.skip 4
        |> P.skip 4


parseFaces : Bytes -> LumpRef -> Maybe (Array FaceLump)
parseFaces data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat faceParser (length // 104)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse faces lump, skipped." err)
        |> Result.toMaybe


faceParser : Parser c e FaceLump
faceParser =
    P.succeed FaceLump
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        -- Vertex
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        -- Mesh
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        -- Lightmap
        |> P.keep (P.signedInt32 LE)
        |> P.skip 52
        -- Normal
        |> P.keep vec3Parser
        -- Patch size
        |> P.keep
            (P.map2
                Tuple.pair
                (P.signedInt32 LE)
                (P.signedInt32 LE)
            )


parseNodes : Bytes -> LumpRef -> Maybe (Array BspNodeLump)
parseNodes data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat nodeParser (length // 36)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse BSP nodes lump, skipped." err)
        |> Result.toMaybe


nodeParser : Parser c e BspNodeLump
nodeParser =
    P.succeed BspNodeLump
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        --|> P.keep boundingBoxParser
        |> P.skip 24


parseLeaves : Bytes -> LumpRef -> Maybe (Array BspLeafLump)
parseLeaves data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat leafParser (length // 48)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse BSP leaves lump, skipped." err)
        |> Result.toMaybe


leafParser : Parser c e BspLeafLump
leafParser =
    P.succeed BspLeafLump
        |> P.keep (P.signedInt32 LE)
        |> P.skip 4
        |> P.keep boundingBoxFromIntsParser
        -- Skip faces
        |> P.skip 8
        -- Brushes
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)


parseModels : Bytes -> LumpRef -> Maybe (Array ModelLump)
parseModels data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat modelParser (length // 40)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse models lump, skipped." err)
        |> Result.toMaybe


modelParser : Parser c e ModelLump
modelParser =
    P.succeed ModelLump
        |> P.keep boundingBoxFromFloatsParser
        -- Faces
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        -- Brushes
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)


parseBrushes : Bytes -> LumpRef -> Maybe (Array BrushLump)
parseBrushes data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat brushParser (length // 12)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse brushes lump, skipped." err)
        |> Result.toMaybe


brushParser : Parser c e BrushLump
brushParser =
    P.succeed BrushLump
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)
        |> P.keep (P.signedInt32 LE)


parseBrushSides : Bytes -> LumpRef -> Maybe (Array Int)
parseBrushSides data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat brushSideParser (length // 8)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse brush planes lump, skipped." err)
        |> Result.toMaybe


brushSideParser : Parser c e Int
brushSideParser =
    P.succeed identity
        -- Store the plane index only
        |> P.keep (P.signedInt32 LE)
        |> P.skip 4


parseLightmaps : Bytes -> LumpRef -> Maybe (List String)
parseLightmaps data { offset, length } =
    -- This is an highly inefficient workaround to the fact that we cannot load a texture using "raw bytes" directly.
    -- Hopefully one fine day we'll have something like Texture.loadBytes.
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat lightmapParser (length // lightmapSizeInBytes))
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse lightmaps lump, skipped." err)
        |> Result.toMaybe


lightmapParser : Parser c e String
lightmapParser =
    P.repeat rgbParser (lightmapSizeInBytes // 3)
        |> P.map (BMP.encodeWith bmpOptions 128 128)


bmpOptions =
    { defaultColor = 0x00FFFF00
    , order = Image.RightDown
    , depth = Image.Bit24
    }


rgbParser : Parser c e Int
rgbParser =
    let
        helper r g b =
            let
                ( r_, g_, b_ ) =
                    Color.adjustBrightness255 0 r g b
            in
            -- Combine channels into a RGB value
            or (shiftLeftBy 16 r_) (shiftLeftBy 8 g_)
                |> or b_
    in
    P.succeed helper
        |> P.keep P.unsignedInt8
        |> P.keep P.unsignedInt8
        |> P.keep P.unsignedInt8


{-| Each lightmap is a 128x128 array where each entry holds a 3 bytes RGB value (0-255).
-}
lightmapSizeInBytes =
    128 * 128 * 3


parseEffects : Bytes -> LumpRef -> Maybe (Array EffectLump)
parseEffects data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat effectParser (length // 72)
                |> P.map Array.fromList
            )
        )
        data
        --|> Result.mapError (\err -> Debug.log "Failed to parse effects lump, skipped." err)
        |> Result.toMaybe


effectParser : Parser c e EffectLump
effectParser =
    P.succeed EffectLump
        |> P.keep (P.map trimNulls (P.string 64))
        |> P.keep (P.signedInt32 LE)
        |> P.skip 4



-- MISC PARSERS


boundingBoxFromIntsParser : Parser c e BoundingBox
boundingBoxFromIntsParser =
    P.succeed BoundingBox.fromExtrema
        |> P.keep (P.map toFloat (P.signedInt32 LE))
        |> P.keep (P.map toFloat (P.signedInt32 LE))
        |> P.keep (P.map toFloat (P.signedInt32 LE))
        |> P.keep (P.map toFloat (P.signedInt32 LE))
        |> P.keep (P.map toFloat (P.signedInt32 LE))
        |> P.keep (P.map toFloat (P.signedInt32 LE))


boundingBoxFromFloatsParser : Parser c e BoundingBox
boundingBoxFromFloatsParser =
    P.succeed BoundingBox.fromExtrema
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)


vec3Parser : Parser c e Vec3
vec3Parser =
    P.succeed vec3
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)


vec2Parser : Parser c e Vec2
vec2Parser =
    P.succeed vec2
        |> P.keep (P.float32 LE)
        |> P.keep (P.float32 LE)


vec2ParserInv : Parser c e Vec2
vec2ParserInv =
    P.succeed vec2
        |> P.keep (P.float32 LE)
        -- Invert t coordinate to match WebGL
        |> P.keep (P.map (\t -> 1 - t) (P.float32 LE))


colorParser : Parser c e Vec4
colorParser =
    let
        helper r g b a =
            let
                ( r_, g_, b_ ) =
                    Color.adjustBrightness255 0 r g b
            in
            vec4 (toFloat r_ / 255) (toFloat g_ / 255) (toFloat b_ / 255) (toFloat a / 255)
    in
    P.succeed helper
        |> P.keep P.unsignedInt8
        |> P.keep P.unsignedInt8
        |> P.keep P.unsignedInt8
        |> P.keep P.unsignedInt8


parseIndices : Bytes -> LumpRef -> Maybe (Array Int)
parseIndices data { offset, length } =
    P.run
        (P.randomAccess
            { offset = offset, relativeTo = P.startOfInput }
            (P.repeat (P.signedInt32 LE) (length // 4)
                |> P.map Array.fromList
            )
        )
        data
        |> Result.toMaybe


trimNulls string =
    String.replace "\u{0000}" "" string


boundingBox : Arena -> Maybe BoundingBox
boundingBox arena =
    -- Grab the first model, which correponds to the base portion of the map
    Array.get 0 arena.models
        |> Maybe.map (\model -> model.boundingBox)
