module Main exposing (main)

import Arena exposing (Arena, PlayerSpawnPoint)
import Array exposing (Array)
import BoundingBox exposing (BoundingBox)
import Browser
import Browser.Dom as Dom
import Browser.Events as E
import BspParser
import BspTree exposing (BspLeaf, BspTree(..))
import Camera exposing (Camera, Movement(..))
import Color
import Diagnostic
import Dict exposing (Dict)
import Fps
import Html as H exposing (Html, text)
import Html.Attributes as A
import Html.Events as E
import Http exposing (Response(..))
import Json.Decode as Decode exposing (Decoder, Value)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Process
import Scene exposing (Scene)
import Shaders.Pipeline as Pipeline exposing (ShaderPipeline, Vertex)
import Sky
import Task exposing (Task)
import Textures
import Time exposing (Posix)
import WebGL exposing (Entity, Mesh)
import WebGL.Texture as Texture exposing (Texture)


{-| Camera level from the ground.
-}
eyeLevel =
    30


fieldOfView =
    60


arenas =
    [ "q3dm1"
    , "q3dm2"
    , "q3dm3"

    -- , "q3dm4"
    -- , "q3dm5"
    -- , "q3dm6"
    -- , "q3dm7"
    -- , "q3dm8"
    -- , "q3dm9"
    -- , "q3dm10"
    ]


startupArena =
    "q3dm1"


zFar =
    8192



-- MODEL


type Model
    = Loading String
    | Compiling String
    | Ready World
    | Error String


type alias World =
    { movement : Movement
    , viewport : { width : Float, height : Float }
    , camera : Camera
    , arena : List ShaderPipeline
    , sky : List ShaderPipeline
    , tree : BspTree
    , textures : Dict String Texture
    , currentBspLeaf : Maybe BspLeaf
    , elapsedTime : Float
    , cameraDidMove : Bool
    , arenaName : String

    -- Diagnostics
    , fps : List Float
    , averageFps : Float
    , drawLeafBoundingBox : Bool
    , isTicking : Bool
    }


initialWorld name scene camera =
    { movement = Idle
    , viewport = { width = 0, height = 0 }
    , arena = scene.arena
    , sky = scene.sky
    , tree = scene.tree
    , currentBspLeaf = Nothing
    , elapsedTime = 0
    , textures = Dict.empty
    , camera = camera
    , cameraDidMove = False
    , arenaName = name
    , fps = []
    , averageFps = 0
    , drawLeafBoundingBox = False
    , isTicking = True
    }


init : ( Model, Cmd Msg )
init =
    ( Loading startupArena
    , loadArena startupArena
    )


type Msg
    = TextureLoaded String (Result Texture.Error Texture)
    | ArenaLoaded (Result String Arena)
    | ArenaCompiled Scene Camera
    | KeyChanged Bool Keys
    | Tick Float
    | GotViewport Dom.Viewport
    | Resized Int Int
    | SetArena String
      -- Diagnostics
    | ToggleLeafBoundingBoxDrawing Bool
    | ToggleTick Bool
    | RefreshFps Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        SetArena name ->
            ( Loading name, loadArena name )

        ToggleLeafBoundingBoxDrawing checked ->
            case model of
                Ready world ->
                    ( Ready { world | drawLeafBoundingBox = checked }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggleTick checked ->
            case model of
                Ready world ->
                    ( Ready { world | isTicking = checked }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        TextureLoaded name textureResult ->
            case model of
                Ready world ->
                    let
                        newTextures =
                            case textureResult of
                                Ok texture ->
                                    Dict.insert name texture world.textures

                                Err _ ->
                                    Debug.log ("Couldn't load texture " ++ name ++ ", skipped") world.textures
                    in
                    ( Ready
                        { world
                            | textures = newTextures
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        ArenaLoaded resultArena ->
            case model of
                Loading name ->
                    case resultArena of
                        Ok arena ->
                            let
                                _ =
                                    Debug.log
                                        ("Parsed arena: " ++ Arena.stats arena)
                                        True
                            in
                            ( Compiling name
                            , compileCmd arena
                            )

                        Err reason ->
                            ( Error reason, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ArenaCompiled scene camera ->
            case model of
                Compiling name ->
                    let
                        world =
                            initialWorld name scene camera

                        cmds =
                            [ loadTextures scene.textures
                            , loadLightmaps scene.lightmaps
                            ]
                                |> List.concat
                    in
                    ( Ready world
                    , Cmd.batch <| Task.perform GotViewport Dom.getViewport :: cmds
                    )

                _ ->
                    ( model, Cmd.none )

        KeyChanged on keys ->
            case model of
                Ready world ->
                    ( Ready
                        { world
                            | movement = movement on keys.altOn keys.keyCode
                            , cameraDidMove = True
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        RefreshFps _ ->
            case model of
                Ready world ->
                    ( Ready
                        { world
                            | averageFps = Fps.average world.fps
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        Tick dt ->
            case model of
                Ready world ->
                    let
                        -- Fractions of second, not millis
                        seconds =
                            dt / 1000

                        newCamera =
                            world.camera
                                |> Camera.update seconds world.movement

                        newLeaf =
                            -- Recalculate only if moved
                            if world.cameraDidMove then
                                BspTree.findLeaf world.tree newCamera.position

                            else
                                world.currentBspLeaf
                    in
                    ( Ready
                        { world
                            | camera = newCamera
                            , fps = Fps.update dt world.fps
                            , elapsedTime = world.elapsedTime + seconds
                            , currentBspLeaf = newLeaf
                            , cameraDidMove = False
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        GotViewport { viewport } ->
            case model of
                Ready world ->
                    ( Ready
                        { world
                            | viewport = { width = viewport.width, height = viewport.height }
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        Resized width height ->
            case model of
                Ready world ->
                    ( Ready
                        { world
                            | viewport = { width = toFloat width, height = toFloat height }
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )


compileCmd : Arena -> Cmd Msg
compileCmd arena =
    Process.sleep 0
        |> Task.perform
            (\_ ->
                let
                    -- Wrap all time-consuming generation functions here
                    scene =
                        Scene.compile arena

                    spawnPoints =
                        Arena.playerSpawnPoints arena

                    camera =
                        moveCameraAt (List.head spawnPoints)
                in
                ArenaCompiled scene camera
            )


moveCameraAt : Maybe PlayerSpawnPoint -> Camera
moveCameraAt maybeSpawnPoint =
    case maybeSpawnPoint of
        Just spawnPoint ->
            let
                position =
                    Vec3.add spawnPoint.origin (vec3 0 0 eyeLevel)
            in
            Camera.init position spawnPoint.angle

        Nothing ->
            Camera.default



-- VIEW


view : Model -> Html Msg
view model =
    let
        messageView message =
            H.div
                [ A.id "dashboard" ]
                [ text message
                ]
    in
    case model of
        Loading name ->
            messageView ("Loading arena " ++ name ++ "...")

        Compiling name ->
            messageView ("Compiling arena " ++ name ++ "...")

        Error message ->
            messageView message

        Ready world ->
            H.div []
                [ glView world
                , H.div
                    [ A.id "dashboard"
                    ]
                    (List.append readyMessage
                        [ selectView world.arenaName
                        , optionsView world
                        , Fps.view world.averageFps
                        ]
                    )
                ]


readyMessage =
    [ ( "Arrows", " Walk/turn" )
    , ( "Alt+Arrows", " Strafe" )
    , ( "A", " Look up" )
    , ( "Z", " Look down" )

    --, ( "R", " Respawn" )
    ]
        |> List.map
            (\( key, label ) ->
                H.span [ A.class "control" ] [ H.kbd [] [ text key ], text label ]
            )


glView : World -> Html Msg
glView ({ viewport, camera, textures, arena, sky, elapsedTime } as world) =
    let
        modelView =
            Camera.view camera

        -- Keep moving sky dome from origin to camera position, so it seems faraway
        skyModelView =
            Mat4.translate camera.position modelView

        projection =
            Mat4.makePerspective fieldOfView (viewport.width / viewport.height) 0.01 zFar

        leafBoundingBox accum =
            case ( world.currentBspLeaf, world.drawLeafBoundingBox ) of
                ( Just leaf, True ) ->
                    Diagnostic.drawBoundingBox leaf.boundingBox Color.blue modelView projection :: accum

                _ ->
                    accum

        -- originBoundingBox accum =
        --     (Diagnostic.drawBoundingBox
        --         (BoundingBox.fromExtrema -3 -3 -3  3 3 3)
        --         Color.red
        --         modelView
        --         projection) :: accum
        entities =
            []
                |> leafBoundingBox
                |> Scene.draw elapsedTime textures sky skyModelView projection
                |> Scene.draw elapsedTime textures arena modelView projection
    in
    WebGL.toHtmlWith
        [ WebGL.depth 1
        ]
        [ A.id "canvas"
        , A.width (round viewport.width)
        , A.height (round viewport.height)
        ]
        entities


selectView : String -> Html Msg
selectView current =
    H.label [ A.class "slot slot-arena" ]
        [ text "Arena "
        , H.select [ E.onInput SetArena ]
            (List.map
                (\name ->
                    H.option [ A.value name, A.selected (current == name) ] [ text name ]
                )
                arenas
            )
        ]


optionsView : { a | isTicking : Bool, drawLeafBoundingBox : Bool } -> Html Msg
optionsView options =
    H.details [ A.class "slot slot-options" ]
        [ H.summary [] [ text "Debug" ]
        , H.div [ A.class "slot-popup" ]
            [ H.label []
                [ H.input [ A.type_ "checkbox", A.checked options.isTicking, E.onCheck ToggleTick ] []
                , text " Run renderer"
                ]
            , H.label []
                [ H.input [ A.type_ "checkbox", A.checked options.drawLeafBoundingBox, E.onCheck ToggleLeafBoundingBoxDrawing ] []
                , text " Draw current BSP leaf bounding box"
                ]
            ]
        ]



-- ASSETS LOADING


baseUrl =
    "./baseq3/pak0/"


loadArena : String -> Cmd Msg
loadArena name =
    let
        didLoad response =
            case response of
                GoodStatus_ meta body ->
                    BspParser.parse body
                        |> Result.mapError (\_ -> "⚠️ Couldn't parse arena " ++ name)

                BadStatus_ meta body ->
                    Err ("⚠️ Server returned a " ++ String.fromInt meta.statusCode ++ " error for " ++ meta.url)

                _ ->
                    Err "⚠️ Couldn't complete request due to a network error"
    in
    Http.get
        { url = baseUrl ++ "maps/" ++ name ++ ".bsp"
        , expect = Http.expectBytesResponse ArenaLoaded didLoad
        }


loadTextures : List String -> List (Cmd Msg)
loadTextures textures =
    List.foldl
        (\name accum ->
            case Textures.find name of
                Just ( options, url ) ->
                    Task.attempt (TextureLoaded name) (Texture.loadWith options (baseUrl ++ url)) :: accum

                Nothing ->
                    Debug.log ("Couldn't lookup texture " ++ name ++ ", skipped") accum
        )
        []
        textures


loadLightmaps : List String -> List (Cmd Msg)
loadLightmaps lightmaps =
    lightmaps
        |> List.indexedMap
            (\index lightmap ->
                Task.attempt (TextureLoaded (String.fromInt index)) (Texture.load lightmap)
            )
        -- Load default textures too
        |> List.append
            [ Task.attempt (TextureLoaded "$whiteimage") (Texture.load Textures.defaultLightmap)
            , Task.attempt (TextureLoaded "$default") (Texture.load Textures.defaultTexture)
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Ready world ->
            Sub.batch
                [ animationFrameDelta world.isTicking
                , E.onKeyDown (Decode.map (KeyChanged True) keysDecoder)
                , E.onKeyUp (Decode.map (KeyChanged False) keysDecoder)
                , E.onResize Resized

                -- Recalculate average FPS every second
                , Time.every 1000 RefreshFps
                ]

        _ ->
            Sub.none


animationFrameDelta : Bool -> Sub Msg
animationFrameDelta isTicking =
    if isTicking then
        E.onAnimationFrameDelta Tick

    else
        Sub.none


type alias Keys =
    { keyCode : Int
    , altOn : Bool
    }


keysDecoder : Decoder Keys
keysDecoder =
    Decode.map2 Keys
        (Decode.field "keyCode" Decode.int)
        (Decode.field "altKey" Decode.bool)


movement : Bool -> Bool -> Int -> Movement
movement on altOn keyCode =
    case ( on, keyCode, altOn ) of
        -- ( True, 32, False ) ->
        --     Jump
        ( True, 37, False ) ->
            TurnLeft

        ( True, 39, False ) ->
            TurnRight

        ( True, 38, _ ) ->
            WalkForward

        ( True, 40, _ ) ->
            WalkBackward

        ( True, 65, False ) ->
            LookUp

        ( True, 90, False ) ->
            LookDown

        ( True, 37, True ) ->
            StrafeLeft

        ( True, 39, True ) ->
            StrafeRight

        _ ->
            Idle



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
