module PlaneTest exposing (suite)

import Expect
import Math.Vector3 exposing (vec3)
import Plane exposing (Plane, distance, isInFront)
import Test exposing (Test, describe, test)


{-| The plane x = 5, i.e. normal pointing along +x, 5 units from the origin.
-}
planeX5 : Plane
planeX5 =
    { normal = vec3 1 0 0, distance = 5 }


suite : Test
suite =
    describe "Plane"
        [ describe "distance"
            [ test "in front of the plane is positive" <|
                \_ ->
                    distance planeX5 (vec3 8 0 0)
                        |> Expect.within (Expect.Absolute 1.0e-6) 3

            , test "behind the plane is negative" <|
                \_ ->
                    distance planeX5 (vec3 2 0 0)
                        |> Expect.within (Expect.Absolute 1.0e-6) -3

            , test "on the plane is zero" <|
                \_ ->
                    distance planeX5 (vec3 5 7 -2)
                        |> Expect.within (Expect.Absolute 1.0e-6) 0
            ]
        , describe "isInFront"
            [ test "agrees with distance >= 0 in front" <|
                \_ ->
                    isInFront planeX5 (vec3 8 0 0)
                        |> Expect.equal True

            , test "agrees with distance >= 0 behind" <|
                \_ ->
                    isInFront planeX5 (vec3 2 0 0)
                        |> Expect.equal False

            , test "on the plane counts as in front" <|
                \_ ->
                    isInFront planeX5 (vec3 5 0 0)
                        |> Expect.equal True
            ]
        ]
