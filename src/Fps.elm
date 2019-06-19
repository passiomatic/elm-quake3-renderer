module Fps exposing
    ( average
    , update
    , view
    )

{-| This module is used to show the FPS meter. We keep the last 50 time deltas and show the weighted average.

Adpated from <https://github.com/w0rm/elm-physics/blob/master/examples/Common/Fps.elm>

-}

import Html as H exposing (Html, text)
import Html.Attributes as A


update : Float -> List Float -> List Float
update dt fps =
    List.take 50 (dt :: fps)


average : List Float -> Float
average fps =
    averageHelp 1 0 0 fps


averageHelp currentWeight sumOfWeights weightedSum fps =
    case fps of
        [] ->
            weightedSum / sumOfWeights

        el :: rest ->
            averageHelp
                (currentWeight * 0.9)
                (currentWeight + sumOfWeights)
                (el * currentWeight + weightedSum)
                rest


view : Float -> Html msg
view averageFps =
    H.div [ A.id "fps", A.title "Frames Per Second" ]
        [ text (String.fromInt (round (1000 / averageFps)))
        ]
