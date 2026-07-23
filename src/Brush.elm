module Brush exposing (Brush, makeBrushes)

import Array exposing (Array)
import Arena exposing (BrushLump)
import Plane exposing (Plane)
import Shaders.ShaderDef exposing (ShaderInfo, isSolid)


type alias Brush =
    { contentFlags : Int
    , planes : List Plane
    }


{-| Build the list of solid brushes only. Non-solid brush lumps (water, triggers, clip
brushes meant for other entity types, etc.) are dropped here, so nothing downstream ever
needs to look at content flags again.
-}
makeBrushes : Array Plane -> Array Int -> Array ShaderInfo -> Array BrushLump -> Array Brush
makeBrushes planes sides shaders brushes =
    brushes
        |> Array.toList
        |> List.filterMap (makeBrush planes sides shaders)
        |> Array.fromList


makeBrush : Array Plane -> Array Int -> Array ShaderInfo -> BrushLump -> Maybe Brush
makeBrush planes sides shaders lump =
    Array.get lump.shaderIndex shaders
        |> Maybe.andThen
            (\info ->
                if isSolid info then
                    resolvePlanes planes sides lump
                        |> Maybe.map (Brush info.contentFlags)

                else
                    Nothing
            )


resolvePlanes : Array Plane -> Array Int -> BrushLump -> Maybe (List Plane)
resolvePlanes planes sides lump =
    Array.slice lump.firstSideIndex (lump.firstSideIndex + lump.sideCount) sides
        |> Array.toList
        |> List.foldr
            (\index -> Maybe.map2 (::) (Array.get index planes))
            (Just [])
