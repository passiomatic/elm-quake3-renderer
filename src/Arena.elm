module Arena exposing
    ( Arena
    , BrushLump
    , BspLeafLump
    , BspNodeLump
    , EffectLump
    , FaceLump
    , ModelLump
    , PlayerSpawnPoint
    , boundingBox
    , playerSpawnPoints
    , stats
    , worldInfo
    )

{-| Arena (.bsp) file data structures.
-}

import Array exposing (Array)
import BoundingBox exposing (BoundingBox)
import Dict exposing (Dict)
import GameParser exposing (GameEntity, Value(..))
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
--import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import Plane exposing (Plane)
import Shaders.Pipeline exposing (Vertex)
import Shaders.ShaderDef exposing (ShaderDef)


{-| A serialized Quake 3 Arena file.
-}
type alias Arena =
    { entities : List GameEntity
    , shaders : Array ShaderDef
    , planes : Maybe (Array Plane)
    , nodes : Maybe (Array BspNodeLump)
    , leaves : Maybe (Array BspLeafLump)
    , leafBrushIndices : Array Int
    , models : Array ModelLump
    , brushes : Array BrushLump
    , brushSides : Array Int
    , vertices : Array Vertex
    , meshIndices : Array Int
    , effects : Array EffectLump
    , faces : Array FaceLump
    , lightmaps : List String
    }


type alias FaceLump =
    { shaderIndex : Int
    , effectIndex : Int
    , type_ : Int
    , firstVertexIndex : Int
    , vertexCount : Int
    , firstMeshIndex : Int
    , meshCount : Int
    , lightmapIndex : Int
    , normal : Vec3
    , patchSize : ( Int, Int )
    }


type alias BspNodeLump =
    { planeIndex : Int
    , front : Int
    , back : Int
    }


type alias BspLeafLump =
    { clusterIndex : Int
    , boundingBox : BoundingBox

    -- , firstFaceIndex : Int
    -- , faceCount : Int
    , firstBrushIndex : Int
    , brushCount : Int
    }


type alias ModelLump =
    { boundingBox : BoundingBox
    , firstFaceIndex : Int
    , faceCount : Int
    , firstBrushIndex : Int
    , brushCount : Int
    }


type alias BrushLump =
    { firstSideIndex : Int
    , sideCount : Int
    , shaderIndex : Int
    }


-- type alias BrushSideLump =
--     { planeIndex : Int
--     , shaderIndex : Int
--     }


{-| Volumetric shaders (typically fog) which affect the rendering of a particular group of faces.
-}
type alias EffectLump =
    { name : String
    , brushIndex : Int
    }



-- GAME ENTITIES


{-| The `info_player_deathmatch` game entity.
-}
type alias PlayerSpawnPoint =
    { origin : Vec3
    , angle : Float

    --, flags: Int
    }


playerSpawnPoints : Arena -> List PlayerSpawnPoint
playerSpawnPoints arena =
    List.filterMap
        (\entity ->
            Maybe.map3
                (\_ origin angle ->
                    PlayerSpawnPoint origin angle
                )
                (withClassName "info_player_deathmatch" entity)
                (getOrigin entity)
                (getAngle entity)
        )
        arena.entities


{-| The `worldspawn` game entity.
-}
type alias WorldInfo =
    { message : String
    , music : String
    }


worldInfo : Arena -> List WorldInfo
worldInfo arena =
    List.filterMap
        (\entity ->
            let
                maybeMessage =
                    Dict.get "message" entity
                        |> Maybe.andThen toString

                maybeMusic =
                    Dict.get "music" entity
                        |> Maybe.andThen toString
                        |> Maybe.map fixPath
            in
            Maybe.map3
                (\_ message music ->
                    WorldInfo message music
                )
                (withClassName "worldspawn" entity)
                maybeMessage
                maybeMusic
        )
        arena.entities


withClassName : String -> GameEntity -> Maybe String
withClassName name entity =
    Dict.get "classname" entity
        |> Maybe.andThen toString
        |> Maybe.andThen
            (\value ->
                if value == name then
                    Just value

                else
                    Nothing
            )


getOrigin : GameEntity -> Maybe Vec3
getOrigin entity =
    Dict.get "origin" entity
        |> Maybe.andThen toVec3


getAngle : GameEntity -> Maybe Float
getAngle entity =
    Dict.get "angle" entity
        |> Maybe.andThen toFloat
        -- We speak radians here
        |> Maybe.map degrees


fixPath : String -> String
fixPath path =
    -- Fix Windows' paths in certain values
    String.replace "\\" "/" path


toFloat : Value -> Maybe Float
toFloat value =
    case value of
        Number value_ ->
            Just value_

        _ ->
            Nothing


toVec3 value =
    case value of
        Vector value_ ->
            Just value_

        _ ->
            Nothing


toString value =
    case value of
        Text value_ ->
            Just value_

        _ ->
            Nothing



-- MISC


boundingBox : Arena -> Maybe BoundingBox
boundingBox arena =
    -- Grab the first model, which correponds to the base portion of the map
    Array.get 0 arena.models
        |> Maybe.map (\model -> model.boundingBox)


{-| Printable arena stats.
-}
stats : Arena -> String
stats arena =
    [ String.fromInt (Array.length arena.vertices) ++ " vertices"
    , String.fromInt (Array.length arena.shaders) ++ " shaders"
    , String.fromInt (List.length arena.lightmaps) ++ " lightmaps"
    , String.fromInt (Array.length arena.faces) ++ " faces"
    , String.fromInt (Array.length arena.brushes) ++ " brushes"
    , String.fromInt (Array.length arena.models) ++ " models"
    , String.fromInt (Array.length arena.effects) ++ " effects"
    ]
        |> String.join ", "
