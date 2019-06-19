module Plane exposing (Plane, isInFront)

import Math.Vector3 as Vec3 exposing (Vec3)


{-| A plane, defined as a normal and its distance from origin along that normal.
-}
type alias Plane =
    { normal : Vec3
    , distance : Float
    }


isInFront : Plane -> Vec3 -> Bool
isInFront plane position =
    (Vec3.dot plane.normal position) - plane.distance >= 0
