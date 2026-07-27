module BspTracer exposing
    ( CheckBrushResult
    , NodeVisit
    , Side(..)
    , TraceResult
    , checkBrush
    , splitAtNode
    , trace
    )

import Brush exposing (Brush)
import BspTree exposing (BspNode, BspTree(..))
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
    , plane : Maybe Plane
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
    , plane = Nothing
    }


{-| Clip the segment [start, end] against a single solid brush's planes, treating the
segment as sweeping a sphere of `radius` (0 for a plain ray) rather than a bare point.

Ports the tutorial's `CheckBrush`. `startFraction`/`endFraction`/`startsOut`/`endsOut`
are exposed as-is, mirroring the tutorial's own bookkeeping variables, rather than
collapsed into a single "did it collide" answer — deciding whether this brush's
result beats the closest collision found so far across the *whole* trace needs the
running fraction from the rest of the BSP walk, which a single-brush function doesn't
have. That comparison belongs to the caller (the leaf/node walk in `trace` below).
`plane` is the brush side responsible for `startFraction` (the entry plane) — carried
forward so a caller can eventually use it for wall-sliding.

Sphere padding (docs/collisions.md "Tracing with a Sphere"): each plane is pushed
outward by `radius` along its normal before the usual distance checks — the standard
Minkowski-sum technique for sphere-vs-convex-polyhedron collision. Since
`Plane.distance plane point` is already `dot(normal, point) - plane.distance`, pushing
the plane out by `radius` is just subtracting `radius` from that.
-}
checkBrush : Float -> Vec3 -> Vec3 -> Brush -> CheckBrushResult
checkBrush radius start end brush =
    checkPlanes radius start end brush.planes { startFraction = -1, endFraction = 1, startsOut = False, endsOut = False, plane = Nothing }
        |> Maybe.map resolveAllSolid
        |> Maybe.withDefault noCollision


type alias Acc =
    { startFraction : Float
    , endFraction : Float
    , startsOut : Bool
    , endsOut : Bool
    , plane : Maybe Plane
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
    , plane = acc.plane
    }


{-| `Nothing` means the segment is provably outside this brush: some plane had it
entirely in front, which rules out the whole (convex) brush at once.
-}
checkPlanes : Float -> Vec3 -> Vec3 -> List Plane -> Acc -> Maybe Acc
checkPlanes radius start end planes acc =
    case planes of
        [] ->
            Just acc

        plane :: rest ->
            let
                startDistance =
                    Plane.distance plane start - radius

                endDistance =
                    Plane.distance plane end - radius

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
                checkPlanes radius start end rest acc_

            else if startDistance > endDistance then
                -- Segment enters the brush through this plane.
                let
                    fraction =
                        (startDistance - epsilon) / (startDistance - endDistance)
                in
                if fraction > acc_.startFraction then
                    checkPlanes radius start end rest { acc_ | startFraction = fraction, plane = Just plane }

                else
                    checkPlanes radius start end rest acc_

            else
                -- Segment leaves the brush through this plane.
                checkPlanes radius start end rest
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


{-| Given a node's splitting plane, the radius of the sphere being traced (0 for a plain
ray), and a segment [start, end] — itself already known to cover the fraction range
[startFraction, endFraction] of some larger original trace — work out which child(ren)
of the node need checking, splitting the segment at the plane when it straddles both
sides (or comes within `radius` of it).

Deliberately isolated from real tree/leaf/brush data (see docs/collisions.md "Checking
the Nodes") — this only knows about a single plane, and returns the sub-segments to
visit rather than what's actually inside them.

Sphere-trace padding (docs/collisions.md "Tracing with a Sphere"): a sphere of radius
`r` centered at signed distance `d` from the plane touches it whenever `|d| <= r`, not
just `d == 0`, so the "entirely in front"/"entirely behind" fast paths generalize from
`>= 0`/`< 0` to `>= radius`/`< -radius`. The split-fraction formulas below originally
solved for where `d(f) = 0` (nudged by `±epsilon` for float safety); generalized for a
sphere they instead solve for where `d(f) = ∓radius` (the edge of the sphere's overlap
zone), We get that for free by simply replacing every bare `epsilon` with
`radius + epsilon` — it reduces to exactly the original ray-trace formulas when
`radius = 0`.

Note: this does NOT follow `docs/collisions.md`'s source listing literally. That
listing's first branch (`startDistance < endDistance`) assigns `fraction1`/`fraction2`
identically, which can't be right — contrast with the second branch, where they differ
by the sign on `EPSILON`. The two branches are meant to be mirror images of each other
(whichever side is checked first should have its share of the segment nudged slightly
*past* the plane crossing, and the side checked second nudged slightly *before* it, so
the two recursions slightly overlap rather than leaving an untested gap right at the
plane). Mirroring branch two's shape (rather than copying branch one verbatim) is what
makes that true in both branches — verified by `BspTracerTest.elm`, which checks the two
sub-segments overlap instead of gapping for both straddling directions.
-}
splitAtNode : Float -> Plane -> Float -> Float -> Vec3 -> Vec3 -> List NodeVisit
splitAtNode radius plane startFraction endFraction start end =
    let
        startDistance =
            Plane.distance plane start

        endDistance =
            Plane.distance plane end

        paddedEpsilon =
            radius + epsilon
    in
    if startDistance >= radius && endDistance >= radius then
        [ { side = Front, start = start, end = end, startFraction = startFraction, endFraction = endFraction } ]

    else if startDistance < -radius && endDistance < -radius then
        [ { side = Back, start = start, end = end, startFraction = startFraction, endFraction = endFraction } ]

    else
        let
            inverseDistance =
                1 / (startDistance - endDistance)

            ( side, fraction1, fraction2 ) =
                if startDistance < endDistance then
                    ( Back
                    , (startDistance - paddedEpsilon) * inverseDistance
                    , (startDistance + paddedEpsilon) * inverseDistance
                    )

                else
                    ( Front
                    , (startDistance + paddedEpsilon) * inverseDistance
                    , (startDistance - paddedEpsilon) * inverseDistance
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


type alias TraceResult =
    { fraction : Float
    , endPosition : Vec3
    , allSolid : Bool
    , plane : Maybe Plane
    }


{-| Trace a segment [start, end] through the BSP tree, clipping it against every solid
brush it passes through, and returning the closest collision found (if any).

Ports the tutorial's outer `Trace`/`CheckNode` combination, using `splitAtNode` at
nodes and `checkBrush` at each leaf's resolved brushes, threading a running "closest
collision so far" accumulator through the recursion in place of the tutorial's mutable
`output*` variables.

Known limitation, carried over as-is from the tutorial rather than fixed here: if the
trace starts embedded in solid (`allSolid = True`), `fraction` is left untouched by
whichever brush produced that result — it does *not* get forced to 0. A caller that
just does `position = result.endPosition` would, in that specific case, still move the
full requested distance despite being stuck. Worth remembering when wiring this into
the camera later.

`radius` (0 for a plain ray) pads both node-splitting (`splitAtNode`) and per-brush plane
checks (`checkBrush`) — a full sphere-trace. The caller still owns deciding what value to
pass; `radius` itself is just plumbed straight through.
-}
trace : BspTree -> Float -> Vec3 -> Vec3 -> TraceResult
trace tree radius start end =
    let
        state =
            walk radius tree 0 1 start end { fraction = 1, allSolid = False, plane = Nothing }
    in
    { fraction = state.fraction
    , endPosition =
        if state.fraction >= 1 then
            end

        else
            Vec3.add start (Vec3.scale state.fraction (Vec3.sub end start))
    , allSolid = state.allSolid
    , plane = state.plane
    }


type alias TraceState =
    { fraction : Float
    , allSolid : Bool
    , plane : Maybe Plane
    }


walk : Float -> BspTree -> Float -> Float -> Vec3 -> Vec3 -> TraceState -> TraceState
walk radius tree startFraction endFraction start end state =
    case tree of
        Empty ->
            state

        Leaf leaf ->
            List.foldl (checkLeafBrush radius start end startFraction endFraction) state leaf.brushes

        Node node ->
            splitAtNode radius node.plane startFraction endFraction start end
                |> List.foldl (walkVisit radius node) state


walkVisit : Float -> BspNode -> NodeVisit -> TraceState -> TraceState
walkVisit radius node visit state =
    let
        subtree =
            case visit.side of
                Front ->
                    node.front

                Back ->
                    node.back
    in
    walk radius subtree visit.startFraction visit.endFraction visit.start visit.end state


checkLeafBrush : Float -> Vec3 -> Vec3 -> Float -> Float -> Brush -> TraceState -> TraceState
checkLeafBrush radius start end startFraction endFraction brush state =
    let
        result =
            checkBrush radius start end brush
    in
    if not result.startsOut then
        -- Tutorial: always returns here regardless of endsOut; only allSolid may change.
        if result.allSolid then
            { state | allSolid = True }

        else
            state

    else if result.startFraction < result.endFraction && result.startFraction > -1 then
        let
            -- checkBrush's fractions are local to [start, end]; map back to the whole
            -- trace's [0, 1] via the slice of it this leaf's segment covers.
            globalFraction =
                startFraction + (endFraction - startFraction) * max 0 result.startFraction
        in
        if globalFraction < state.fraction then
            { state | fraction = globalFraction, plane = result.plane }

        else
            state

    else
        state
