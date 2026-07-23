module Plane exposing (Plane, distance, isInFront)

import Math.Vector3 as Vec3 exposing (Vec3)


{-| A plane, defined as a normal and its distance from origin along that normal.
-}
type alias Plane =
    { normal : Vec3
    , distance : Float
    }


{-| Signed distance of a point from the plane: positive in front, negative behind, zero on it.
-}
distance : Plane -> Vec3 -> Float
distance plane position =
    Vec3.dot plane.normal position - plane.distance


isInFront : Plane -> Vec3 -> Bool
isInFront plane position =
    distance plane position >= 0
