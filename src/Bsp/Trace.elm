module Bsp.Trace exposing (CheckBrushResult, NodeVisit, Side(..), checkBrush, splitAtNode)

import Brush exposing (Brush)
import Math.Vector3 as Vec3 exposing (Vec3)
import Plane exposing (Plane)


{-| Quake 3's own "really, really ridiculously small" nudge (1/32), used to keep a
computed fraction just shy of the plane it clips against, so floating point error
never leaves the trace exactly flush with (and liable to re-collide with) a surface.
-}
epsilon : Float
epsilon =
    0.03125


type alias CheckBrushResult =
    { startFraction : Float
    , endFraction : Float
    , startsOut : Bool
    , endsOut : Bool
    , allSolid : Bool
    }


{-| Canonical "this brush was never touched at all" result: some plane had the whole
segment in front of it, so it can't be inside this (convex) brush anywhere.
-}
noCollision : CheckBrushResult
noCollision =
    { startFraction = -1
    , endFraction = 1
    , startsOut = True
    , endsOut = True
    , allSolid = False
    }


{-| Clip the segment [start, end] against a single solid brush's planes.

Ports the tutorial's `CheckBrush`. `startFraction`/`endFraction`/`startsOut`/`endsOut`
are exposed as-is, mirroring the tutorial's own bookkeeping variables, rather than
collapsed into a single "did it collide" answer — deciding whether this brush's
result beats the closest collision found so far across the *whole* trace needs the
running fraction from the rest of the BSP walk, which a single-brush function doesn't
have. That comparison belongs to the caller (the leaf/node walk built in a later step).
-}
checkBrush : Vec3 -> Vec3 -> Brush -> CheckBrushResult
checkBrush start end brush =
    checkPlanes start end brush.planes { startFraction = -1, endFraction = 1, startsOut = False, endsOut = False }
        |> Maybe.map resolveAllSolid
        |> Maybe.withDefault noCollision


type alias Acc =
    { startFraction : Float
    , endFraction : Float
    , startsOut : Bool
    , endsOut : Bool
    }


resolveAllSolid : Acc -> CheckBrushResult
resolveAllSolid acc =
    { startFraction = acc.startFraction
    , endFraction = acc.endFraction
    , startsOut = acc.startsOut
    , endsOut = acc.endsOut

    -- Stuck inside the brush: every plane had the segment behind it the whole way,
    -- i.e. never in front of (outside) any of them.
    , allSolid = not acc.startsOut && not acc.endsOut
    }


{-| `Nothing` means the segment is provably outside this brush: some plane had it
entirely in front, which rules out the whole (convex) brush at once.
-}
checkPlanes : Vec3 -> Vec3 -> List Plane -> Acc -> Maybe Acc
checkPlanes start end planes acc =
    case planes of
        [] ->
            Just acc

        plane :: rest ->
            let
                startDistance =
                    Plane.distance plane start

                endDistance =
                    Plane.distance plane end

                acc_ =
                    { acc
                        | startsOut = acc.startsOut || startDistance > 0
                        , endsOut = acc.endsOut || endDistance > 0
                    }
            in
            if startDistance > 0 && endDistance > 0 then
                -- Entirely in front of this plane: can't be inside the brush at all.
                Nothing

            else if startDistance <= 0 && endDistance <= 0 then
                -- Both behind this plane; it'll get clipped by another side, if any.
                checkPlanes start end rest acc_

            else if startDistance > endDistance then
                -- Segment enters the brush through this plane.
                checkPlanes start end rest
                    { acc_ | startFraction = max acc_.startFraction ((startDistance - epsilon) / (startDistance - endDistance)) }

            else
                -- Segment leaves the brush through this plane.
                checkPlanes start end rest
                    { acc_ | endFraction = min acc_.endFraction ((startDistance + epsilon) / (startDistance - endDistance)) }


type Side
    = Front
    | Back


{-| One of the (one or two) sub-segments a node's splitting plane says to recurse into,
carrying its own slice of the overall trace's fraction range along with it.
-}
type alias NodeVisit =
    { side : Side
    , start : Vec3
    , end : Vec3
    , startFraction : Float
    , endFraction : Float
    }


{-| Given a node's splitting plane and a segment [start, end] — itself already known to
cover the fraction range [startFraction, endFraction] of some larger original trace —
work out which child(ren) of the node need checking, splitting the segment at the plane
when it straddles both sides.

Deliberately isolated from real tree/leaf/brush data (see docs/collisions.md "Checking
the Nodes") — this only knows about a single plane, and returns the sub-segments to
visit rather than what's actually inside them.

Note: this does NOT follow `docs/collisions.md`'s source listing literally. That
listing's first branch (`startDistance < endDistance`) assigns `fraction1`/`fraction2`
identically, which can't be right — contrast with the second branch, where they differ
by the sign on `EPSILON`. The two branches are meant to be mirror images of each other
(whichever side is checked first should have its share of the segment nudged slightly
*past* the plane crossing, and the side checked second nudged slightly *before* it, so
the two recursions slightly overlap rather than leaving an untested gap right at the
plane). Mirroring branch two's shape (rather than copying branch one verbatim) is what
makes that true in both branches — verified by `TraceTest.elm`, which checks the two
sub-segments overlap instead of gapping for both straddling directions.
-}
splitAtNode : Plane -> Float -> Float -> Vec3 -> Vec3 -> List NodeVisit
splitAtNode plane startFraction endFraction start end =
    let
        startDistance =
            Plane.distance plane start

        endDistance =
            Plane.distance plane end
    in
    if startDistance >= 0 && endDistance >= 0 then
        [ { side = Front, start = start, end = end, startFraction = startFraction, endFraction = endFraction } ]

    else if startDistance < 0 && endDistance < 0 then
        [ { side = Back, start = start, end = end, startFraction = startFraction, endFraction = endFraction } ]

    else
        let
            inverseDistance =
                1 / (startDistance - endDistance)

            ( side, fraction1, fraction2 ) =
                if startDistance < endDistance then
                    ( Back
                    , (startDistance - epsilon) * inverseDistance
                    , (startDistance + epsilon) * inverseDistance
                    )

                else
                    ( Front
                    , (startDistance + epsilon) * inverseDistance
                    , (startDistance - epsilon) * inverseDistance
                    )

            otherSide =
                case side of
                    Front ->
                        Back

                    Back ->
                        Front

            clampedFraction1 =
                clamp 0 1 fraction1

            clampedFraction2 =
                clamp 0 1 fraction2

            pointAt fraction =
                Vec3.add start (Vec3.scale fraction (Vec3.sub end start))

            fractionAt fraction =
                startFraction + (endFraction - startFraction) * fraction
        in
        [ { side = side
          , start = start
          , end = pointAt clampedFraction1
          , startFraction = startFraction
          , endFraction = fractionAt clampedFraction1
          }
        , { side = otherSide
          , start = pointAt clampedFraction2
          , end = end
          , startFraction = fractionAt clampedFraction2
          , endFraction = endFraction
          }
        ]
