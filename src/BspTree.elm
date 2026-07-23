module BspTree exposing
    ( BspLeaf
    , BspNode
    , BspTree(..)
    , findLeaf
    , make
    )

{-| BSP tree data structures, creation and traversal.

A BSP tree is, at heart, nothing more than a tree that subdivides space in order to isolate features of interest. Each node of a BSP tree splits a volume in 3D, into two parts along a plane; thus the name “Binary Space Partitioning.” The subdivision is hierarchical; the root node splits the world into two subspaces, then each of the root’s two children splits one of those two subspaces into two more parts. This continues with each subspace being further subdivided, until each component of interest (each polygon, for example) has been assigned its own unique subspace.

More information at <http://www.jagregory.com/abrash-black-book/#chapter-59-the-idea-of-bsp-trees>.

-}
import Array exposing (Array)
import Plane exposing (Plane)
import Math.Vector3 as Vector3 exposing (Vec3)
import BoundingBox exposing (BoundingBox)
import Arena exposing (BspNodeLump, BspLeafLump)
import Brush exposing (Brush)

type BspTree
    = Node BspNode
    | Leaf BspLeaf
    | Empty


{-| Data for a node in the BSP tree.
-}
type alias BspNode =
    { plane : Plane
    , front : BspTree
    , back : BspTree

    --, boundingBox : BoundingBox
    }


{-| Data for a BSP tree leaf, with its solid brushes already resolved.
-}
type alias BspLeaf =
    { clusterIndex : Int
    , boundingBox : BoundingBox
    , brushes : List Brush
    }


{-| Build a BSP tree from nodes, leaves, planes, and the (leaf -> brush indices)
indirection table paired with the already-resolved solid brushes.
-}
make : Array BspNodeLump -> Array BspLeafLump -> Array Plane -> Array Int -> Array Brush -> BspTree
make nodes leaves planes leafBrushIndices brushes =
    -- Start from root node index
    makeHelp nodes leaves planes leafBrushIndices brushes 0


makeHelp : Array BspNodeLump -> Array BspLeafLump -> Array Plane -> Array Int -> Array Brush -> Int -> BspTree
makeHelp nodes leaves planes leafBrushIndices brushes nodeIndex =
    -- Leaf?
    if nodeIndex < 0 then
        Array.get (-nodeIndex - 1) leaves
            |> Maybe.map (makeLeaf leafBrushIndices brushes)
            |> Maybe.map Leaf
            |> Maybe.withDefault Empty

    else
        let
            maybeNode =
                Array.get nodeIndex nodes

            maybePlane =
                maybeNode
                    |> Maybe.andThen (\node -> Array.get node.planeIndex planes)
        in
        Maybe.map2
            (\node plane ->
                Node
                    (BspNode
                        plane
                        (makeHelp nodes leaves planes leafBrushIndices brushes node.front)
                        (makeHelp nodes leaves planes leafBrushIndices brushes node.back)
                    )
            )
            maybeNode
            maybePlane
            |> Maybe.withDefault Empty


makeLeaf : Array Int -> Array Brush -> BspLeafLump -> BspLeaf
makeLeaf leafBrushIndices brushes lump =
    { clusterIndex = lump.clusterIndex
    , boundingBox = lump.boundingBox
    , brushes =
        Array.slice lump.firstBrushIndex (lump.firstBrushIndex + lump.brushCount) leafBrushIndices
            |> Array.toList
            |> List.filterMap (\index -> Array.get index brushes)
    }


{-| Find which leaf the given position lies in.
-}
findLeaf : BspTree -> Vec3 -> Maybe BspLeaf
findLeaf tree position =
    case tree of
        Leaf leaf ->
            Just leaf

        Node node ->
            if Plane.isInFront node.plane position then
                findLeaf node.front position
            else
                findLeaf node.back position

        Empty ->
            Nothing
