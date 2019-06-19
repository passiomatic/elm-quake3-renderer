module Color exposing
    ( Color
    , adjustBrightness255
    , blue
    , green
    , red
    , teal
    , yellow
    )

import Bitwise exposing (shiftLeftBy)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)


type alias Color =
    Vec4


red =
    vec4 0.8 0 0 0


green =
    vec4 0 0.8 0 0


blue =
    vec4 0 0 0.8 0


yellow =
    vec4 0.8 0.8 0 0


teal =
    vec4 0 0.8 0.8 0


{-| Gamma ramp overbrightening for a 0-2 dynamic range.

See <https://community.khronos.org/t/quake3-overbright-lightmap/37634/3>

-}
adjustBrightness255 : Int -> Int -> Int -> Int -> ( Int, Int, Int )
adjustBrightness255 overbrightBits r g b =
    let
        gamma =
            2 - overbrightBits

        r_ =
            shiftLeftBy gamma r

        g_ =
            shiftLeftBy gamma g

        b_ =
            shiftLeftBy gamma b

        imax =
            max r_ (max g_ b_)
    in
    if imax > 255 then
        let
            factor =
                255 / toFloat imax
        in
        ( floor (toFloat r_ * factor)
        , floor (toFloat g_ * factor)
        , floor (toFloat b_ * factor)
        )

    else
        ( r_, g_, b_ )
