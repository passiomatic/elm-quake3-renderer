module BoundingBox exposing
    ( BoundingBox
    , centerPoint
    , dimensions
    , fromExtrema
    )

{-| Adapted from Ian Mackenzie's [Elm Geometry][1].

[1]: https://package.elm-lang.org/packages/ianmackenzie/elm-geometry/latest/

-}

import Math.Vector3 as Vec3 exposing (Vec3, vec3)


type alias BoundingBox =
    { min : Vec3
    , max : Vec3
    }


fromExtrema : Float -> Float -> Float -> Float -> Float -> Float -> BoundingBox
fromExtrema minX minY minZ maxX maxY maxZ =
    BoundingBox (vec3 minX minY minZ) (vec3 maxX maxY maxZ)


{-| Get the X, Y and Z dimensions (respectively width, depth and height) of a bounding box.
-}
dimensions : BoundingBox -> Vec3
dimensions boundingBox =
    Vec3.sub boundingBox.max boundingBox.min


{-| Get the point at the center of a bounding box.
-}
centerPoint : BoundingBox -> Vec3
centerPoint boundingBox =
    Vec3.scale 0.5 (dimensions boundingBox)
        |> Vec3.add boundingBox.min
