module BrushTest exposing (suite)

import Arena exposing (BrushLump)
import Array
import Brush exposing (Brush)
import Expect
import Math.Vector3 exposing (vec3)
import Plane exposing (Plane)
import Shaders.ShaderDef as ShaderDef
import Test exposing (Test, describe, test)


planeX0 : Plane
planeX0 =
    { normal = vec3 1 0 0, distance = 0 }


{-| Same name for both, absent from the real shader lookup table, so both resolve as
plain `UseTexture` entries — only the content flags differ.
-}
shaders =
    Array.fromList
        [ ShaderDef.resolve "textures/test/solid" 0 1
        , ShaderDef.resolve "textures/test/nonsolid" 0 0
        ]


planes =
    Array.fromList [ planeX0 ]


sides =
    Array.fromList [ 0 ]


{-| Solid, non-solid, solid — every lump must resolve into its own `Brush`, at its own
index, regardless of solidity; nothing here should ever be dropped or compacted.
-}
brushLumps : Array.Array BrushLump
brushLumps =
    Array.fromList
        [ { firstSideIndex = 0, sideCount = 1, shaderIndex = 0 }
        , { firstSideIndex = 0, sideCount = 1, shaderIndex = 1 }
        , { firstSideIndex = 0, sideCount = 1, shaderIndex = 0 }
        ]


suite : Test
suite =
    describe "Brush.makeBrushes"
        [ test "output array has one slot per input brush lump (index-preserving)" <|
            \_ ->
                Brush.makeBrushes planes sides shaders brushLumps
                    |> Array.length
                    |> Expect.equal (Array.length brushLumps)

        , test "every lump resolves into a Brush at its own index, solid or not" <|
            \_ ->
                let
                    result =
                        Brush.makeBrushes planes sides shaders brushLumps

                    solidBrush =
                        Just { contentFlags = 1, planes = [ planeX0 ] }

                    nonSolidBrush =
                        Just { contentFlags = 0, planes = [ planeX0 ] }
                in
                Expect.all
                    [ \_ -> Array.get 0 result |> Expect.equal solidBrush
                    , \_ -> Array.get 1 result |> Expect.equal nonSolidBrush
                    , \_ -> Array.get 2 result |> Expect.equal solidBrush
                    ]
                    ()

        , test "isSolid reads the CONTENTS_SOLID bit" <|
            \_ ->
                Expect.all
                    [ \_ -> Brush.isSolid { contentFlags = 1, planes = [] } |> Expect.equal True
                    , \_ -> Brush.isSolid { contentFlags = 0, planes = [] } |> Expect.equal False

                    -- Solid bit set alongside other unrelated flags.
                    , \_ -> Brush.isSolid { contentFlags = 0x81, planes = [] } |> Expect.equal True
                    ]
                    ()
        ]
