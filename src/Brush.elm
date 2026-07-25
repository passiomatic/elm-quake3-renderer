module Brush exposing (Brush, isSolid, makeBrushes)

import Array exposing (Array)
import Arena exposing (BrushLump)
import Bitwise exposing (and)
import Plane exposing (Plane)
import Shaders.ShaderDef as ShaderDef exposing (ShaderInfo)


type alias Brush =
    { contentFlags : Int
    , planes : List Plane
    }


{-| Is this brush solid, i.e. should it ever block movement? Checked here rather than
filtered out at construction time (see `makeBrushes`), so a `Brush`'s content flags are
always available downstream if something other than collision ever needs them.
-}
isSolid : Brush -> Bool
isSolid brush =
    and brush.contentFlags ShaderDef.contentsSolid /= 0


{-| Resolve every brush lump into a `Brush`, always — one array slot per input lump, no
exceptions, so nothing can ever shift later brushes' indices out from under
`Arena.leafBrushIndices` (which indexes this array by the *original* BSP brush index).
Whether a brush is solid or not is just data on the result (`contentFlags`); callers
that only want solid brushes (e.g. `BspTree.makeLeaf`) filter with `isSolid` themselves.
-}
makeBrushes : Array Plane -> Array Int -> Array ShaderInfo -> Array BrushLump -> Array Brush
makeBrushes planes sides shaders brushes =
    Array.map (makeBrush planes sides shaders) brushes


makeBrush : Array Plane -> Array Int -> Array ShaderInfo -> BrushLump -> Brush
makeBrush planes sides shaders lump =
    { contentFlags =
        Array.get lump.shaderIndex shaders
            |> Maybe.map .contentFlags
            |> Maybe.withDefault 0
    , planes =
        resolvePlanes planes sides lump
            |> Maybe.withDefault []
    }


resolvePlanes : Array Plane -> Array Int -> BrushLump -> Maybe (List Plane)
resolvePlanes planes sides lump =
    Array.slice lump.firstSideIndex (lump.firstSideIndex + lump.sideCount) sides
        |> Array.toList
        |> List.foldr
            (\index -> Maybe.map2 (::) (Array.get index planes))
            (Just [])
