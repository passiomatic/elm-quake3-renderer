module BspTreeTest exposing (suite)

import Arena exposing (BrushLump, BspLeafLump, BspNodeLump)
import Array
import BoundingBox
import Brush
import BspTree exposing (BspTree(..))
import Expect
import Math.Vector3 exposing (vec3)
import Plane exposing (Plane)
import Shaders.ShaderDef as ShaderDef
import Test exposing (Test, describe, test)


planeX0 : Plane
planeX0 =
    { normal = vec3 1 0 0, distance = 0 }


emptyBox =
    BoundingBox.fromExtrema 0 0 0 0 0 0


shaders =
    Array.fromList
        [ ShaderDef.resolve "textures/test/solid" 0 1
        , ShaderDef.resolve "textures/test/nonsolid" 0 0
        ]


planes =
    Array.fromList [ planeX0 ]


sides =
    Array.fromList [ 0 ]


{-| Solid, non-solid, solid — same fixture as BrushTest, now carried all the way through
leaf resolution to confirm the non-solid one gets filtered there without corrupting
which of the two solid brushes ends up in the leaf.
-}
brushLumps : Array.Array BrushLump
brushLumps =
    Array.fromList
        [ { firstSideIndex = 0, sideCount = 1, shaderIndex = 0 }
        , { firstSideIndex = 0, sideCount = 1, shaderIndex = 1 }
        , { firstSideIndex = 0, sideCount = 1, shaderIndex = 0 }
        ]


{-| One splitting node at x = 0: front (x >= 0) is leaf 0, referencing all three brush
lumps above; back (x < 0) is leaf 1, referencing none.
-}
nodes : Array.Array BspNodeLump
nodes =
    Array.fromList [ { planeIndex = 0, front = -1, back = -2 } ]


leaves : Array.Array BspLeafLump
leaves =
    Array.fromList
        [ { clusterIndex = 0, boundingBox = emptyBox, firstBrushIndex = 0, brushCount = 3 }
        , { clusterIndex = 1, boundingBox = emptyBox, firstBrushIndex = 0, brushCount = 0 }
        ]


leafBrushIndices : Array.Array Int
leafBrushIndices =
    Array.fromList [ 0, 1, 2 ]


tree : BspTree
tree =
    BspTree.make nodes leaves planes leafBrushIndices (Brush.makeBrushes planes sides shaders brushLumps)


suite : Test
suite =
    describe "BspTree.make leaf brush resolution"
        [ test "a leaf's resolved brushes contain only the solid ones, both of them" <|
            \_ ->
                BspTree.findLeaf tree (vec3 5 0 0)
                    |> Maybe.map (.brushes >> List.map .contentFlags)
                    |> Expect.equal (Just [ 1, 1 ])

        , test "a leaf referencing no brush indices resolves to an empty list" <|
            \_ ->
                BspTree.findLeaf tree (vec3 -5 0 0)
                    |> Maybe.map .brushes
                    |> Expect.equal (Just [])
        ]
