module BspTracerTest exposing (splitAtNodeSuite, suite, traceSuite)

import BoundingBox
import Brush exposing (Brush)
import BspTracer exposing (Side(..), checkBrush, splitAtNode, trace)
import BspTree exposing (BspTree(..))
import Expect
import Math.Vector3 exposing (vec3)
import Plane exposing (Plane)
import Test exposing (Test, describe, test)


{-| A single unbounded half-space brush: solid is x <= 0, outward normal +x.
-}
halfSpaceBrush : Brush
halfSpaceBrush =
    { contentFlags = 1
    , planes = [ { normal = vec3 1 0 0, distance = 0 } ]
    }


{-| An axis-aligned cube from (0,0,0) to (10,10,10), outward-facing normals.
-}
cubeBrush : Brush
cubeBrush =
    { contentFlags = 1
    , planes =
        [ { normal = vec3 1 0 0, distance = 10 }
        , { normal = vec3 -1 0 0, distance = 0 }
        , { normal = vec3 0 1 0, distance = 10 }
        , { normal = vec3 0 -1 0, distance = 0 }
        , { normal = vec3 0 0 1, distance = 10 }
        , { normal = vec3 0 0 -1, distance = 0 }
        ]
    }


suite : Test
suite =
    describe "BspTracer.checkBrush"
        [ test "segment fully in front of a single-plane brush: no collision" <|
            \_ ->
                checkBrush (vec3 5 0 0) (vec3 10 0 0) halfSpaceBrush
                    |> Expect.equal
                        { startFraction = -1
                        , endFraction = 1
                        , startsOut = True
                        , endsOut = True
                        , allSolid = False
                        , plane = Nothing
                        }

        , test "segment fully outside a multi-plane (box) brush: no collision" <|
            \_ ->
                checkBrush (vec3 20 5 5) (vec3 30 5 5) cubeBrush
                    |> Expect.equal
                        { startFraction = -1
                        , endFraction = 1
                        , startsOut = True
                        , endsOut = True
                        , allSolid = False
                        , plane = Nothing
                        }

        , test "segment straight through a box brush: fraction and clip plane match hand-calculation" <|
            \_ ->
                let
                    result =
                        checkBrush (vec3 -5 5 5) (vec3 15 5 5) cubeBrush
                in
                Expect.all
                    [ .startFraction >> Expect.within (Expect.Absolute 1.0e-6) 0.2484375
                    , .endFraction >> Expect.within (Expect.Absolute 1.0e-6) 0.7484375
                    , .startsOut >> Expect.equal True
                    , .endsOut >> Expect.equal True
                    , .allSolid >> Expect.equal False
                    , .plane >> Expect.equal (Just { normal = vec3 -1 0 0, distance = 0 })
                    ]
                    result

        , test "segment starting and ending embedded in solid: allSolid is True" <|
            \_ ->
                checkBrush (vec3 5 5 5) (vec3 6 5 5) cubeBrush
                    |> .allSolid
                    |> Expect.equal True
        ]


{-| The plane x = 0, outward normal +x (front is x > 0).
-}
planeX0 : Plane
planeX0 =
    { normal = vec3 1 0 0, distance = 0 }


splitAtNodeSuite : Test
splitAtNodeSuite =
    describe "BspTracer.splitAtNode"
        [ test "segment entirely in front: single Front visit, unchanged" <|
            \_ ->
                splitAtNode planeX0 0 1 (vec3 5 0 0) (vec3 10 0 0)
                    |> Expect.equal
                        [ { side = Front, start = vec3 5 0 0, end = vec3 10 0 0, startFraction = 0, endFraction = 1 } ]

        , test "segment entirely behind: single Back visit, unchanged" <|
            \_ ->
                splitAtNode planeX0 0 1 (vec3 -5 0 0) (vec3 -10 0 0)
                    |> Expect.equal
                        [ { side = Back, start = vec3 -5 0 0, end = vec3 -10 0 0, startFraction = 0, endFraction = 1 } ]

        , test "straddling front-to-back: visits overlap at the crossing, not gap" <|
            \_ ->
                case splitAtNode planeX0 0 1 (vec3 10 0 0) (vec3 -10 0 0) of
                    [ first, second ] ->
                        Expect.all
                            [ \_ -> Expect.equal Front first.side
                            , \_ -> Expect.equal Back second.side
                            , \_ -> first.endFraction |> Expect.within (Expect.Absolute 1.0e-6) 0.5015625
                            , \_ -> second.startFraction |> Expect.within (Expect.Absolute 1.0e-6) 0.4984375
                            , \_ -> Expect.greaterThan second.startFraction first.endFraction
                            ]
                            ()

                    visits ->
                        Expect.fail ("expected exactly 2 visits, got " ++ String.fromInt (List.length visits))

        , test "straddling back-to-front: visits overlap at the crossing, not gap" <|
            \_ ->
                case splitAtNode planeX0 0 1 (vec3 -10 0 0) (vec3 10 0 0) of
                    [ first, second ] ->
                        Expect.all
                            [ \_ -> Expect.equal Back first.side
                            , \_ -> Expect.equal Front second.side
                            , \_ -> first.endFraction |> Expect.within (Expect.Absolute 1.0e-6) 0.5015625
                            , \_ -> second.startFraction |> Expect.within (Expect.Absolute 1.0e-6) 0.4984375
                            , \_ -> Expect.greaterThan second.startFraction first.endFraction
                            ]
                            ()

                    visits ->
                        Expect.fail ("expected exactly 2 visits, got " ++ String.fromInt (List.length visits))

        , test "straddling sub-segment fractions are threaded through a non-trivial fraction range" <|
            \_ ->
                -- Same crossing as above, but nested inside an outer trace's [0.2, 0.6] slice
                -- (as would happen a couple of levels deep in a real recursive trace).
                case splitAtNode planeX0 0.2 0.6 (vec3 10 0 0) (vec3 -10 0 0) of
                    [ first, second ] ->
                        Expect.all
                            [ \_ -> first.startFraction |> Expect.within (Expect.Absolute 1.0e-6) 0.2
                            , \_ -> second.endFraction |> Expect.within (Expect.Absolute 1.0e-6) 0.6
                            , \_ -> Expect.greaterThan second.startFraction first.endFraction
                            ]
                            ()

                    visits ->
                        Expect.fail ("expected exactly 2 visits, got " ++ String.fromInt (List.length visits))
        ]


emptyBox : BoundingBox.BoundingBox
emptyBox =
    BoundingBox.fromExtrema 0 0 0 0 0 0


{-| A slab-shaped brush occupying x in [-10, 0] (unbounded in y/z), acting as a "wall".
-}
wallBrush : Brush
wallBrush =
    { contentFlags = 1
    , planes =
        [ { normal = vec3 1 0 0, distance = 0 }
        , { normal = vec3 -1 0 0, distance = 10 }
        ]
    }


{-| One splitting node at x = 5: front (x >= 5) is open air, back (x < 5) contains the
wall brush above.
-}
testTree : BspTree
testTree =
    Node
        { plane = { normal = vec3 1 0 0, distance = 5 }
        , front = Leaf { clusterIndex = 0, boundingBox = emptyBox, brushes = [] }
        , back = Leaf { clusterIndex = 1, boundingBox = emptyBox, brushes = [ wallBrush ] }
        }


traceSuite : Test
traceSuite =
    describe "BspTracer.trace"
        [ test "segment entirely in open air: no collision" <|
            \_ ->
                trace testTree (vec3 20 0 0) (vec3 10 0 0)
                    |> Expect.equal
                        { fraction = 1
                        , endPosition = vec3 10 0 0
                        , allSolid = False
                        , plane = Nothing
                        }

        , test "segment straight into the wall, through the splitting node: stops epsilon short of it" <|
            \_ ->
                -- Hand-derived (exact rational arithmetic, see conversation): crosses the
                -- node's plane at x=5, then the wall's front face at x=0, stopping exactly
                -- EPSILON (1/32) short of it, at fraction 639/1280 = 0.49921875.
                trace testTree (vec3 20 0 0) (vec3 -20 0 0)
                    |> Expect.all
                        [ .fraction >> Expect.within (Expect.Absolute 1.0e-9) 0.49921875
                        , .endPosition >> Expect.equal (vec3 0.03125 0 0)
                        , .allSolid >> Expect.equal False
                        , .plane >> Expect.equal (Just { normal = vec3 1 0 0, distance = 0 })
                        ]

        , test "segment starting and ending embedded in the wall: allSolid, but fraction is NOT forced to 0" <|
            \_ ->
                -- Known limitation carried over from the tutorial (see BspTracer.trace's
                -- doc comment): allSolid alone doesn't clip the movement, a caller must
                -- check for it separately before trusting endPosition/fraction.
                trace testTree (vec3 -5 0 0) (vec3 -6 0 0)
                    |> Expect.all
                        [ .allSolid >> Expect.equal True
                        , .fraction >> Expect.equal 1
                        ]
        ]
