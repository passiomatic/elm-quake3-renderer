module Camera exposing
    ( Camera
    , Movement(..)
    , default
    , init
    , update
    , view
    )

{-| A camera with a position and a look direction given by a up-down Z axis and a left-right X axis.

Adapted from <https://learnopengl.com/Getting-started/Camera>

-}

import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)


type Movement
    = TurnLeft
    | TurnRight
    | StrafeLeft
    | StrafeRight
    | LookUp
    | LookDown
    | WalkForward
    | WalkBackward
    | Jump -- TODO
    | Idle


type alias Camera =
    { position : Vec3
    , direction : Vec3
    , xAngle : Float
    , zAngle : Float
    }


speed =
    250


lookSpeed =
    degrees 1.4


xAngleRange =
    degrees 70


zero =
    vec3 0 0 0


{-| A camera at the given position, looking towards direction given by zAngle
-}
init : Vec3 -> Float -> Camera
init position zAngle =
    Camera position Vec3.j 0 zAngle


{-| A camera at the origin position, looking towards the positive Y axis.
-}
default : Camera
default =
    Camera zero Vec3.j 0 0


view : Camera -> Mat4
view camera =
    Mat4.makeLookAt camera.position (Vec3.add camera.position camera.direction) Vec3.k


update : Float -> Movement -> Camera -> Camera
update dt movement ({ direction, xAngle, zAngle } as camera) =
    let
        xa =
            (case movement of
                LookUp ->
                    xAngle + lookSpeed

                LookDown ->
                    xAngle - lookSpeed

                _ ->
                    xAngle
            )
                |> clamp -xAngleRange xAngleRange

        za =
            case movement of
                TurnLeft ->
                    zAngle + lookSpeed

                TurnRight ->
                    zAngle - lookSpeed

                _ ->
                    zAngle

        newDirection =
            lookDirection xa za

        xDirection =
            case movement of
                StrafeLeft ->
                    Vec3.cross newDirection Vec3.k
                        |> Vec3.normalize
                        |> Vec3.scale -speed

                StrafeRight ->
                    Vec3.cross newDirection Vec3.k
                        |> Vec3.normalize
                        |> Vec3.scale speed

                _ ->
                    zero

        yDirection =
            case movement of
                WalkForward ->
                    Vec3.scale speed newDirection

                WalkBackward ->
                    Vec3.scale -speed newDirection

                _ ->
                    zero

        -- zDirection =
        --     case movement of
        --         Jump ->
        --             vec3 0 0 5
        --         _ ->
        --             zero
        velocity =
            Vec3.add xDirection yDirection

        --|> Vec3.add zDirection
    in
    { camera
        | position =
            Vec3.add camera.position (Vec3.scale dt velocity)
        , direction = newDirection
        , xAngle = xa
        , zAngle = za
    }


lookDirection : Float -> Float -> Vec3
lookDirection xAngle zAngle =
    let
        x =
            cos xAngle * cos zAngle

        y =
            cos xAngle * sin zAngle

        z =
            sin xAngle
    in
    Vec3.normalize (vec3 x y z)
