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


{-| Data for a BSP tree leaf. 
-}
type alias BspLeaf =
    -- No real processing needed, just re-export the original lump structure
    BspLeafLump

-- type alias BspLeaf_ =
--     { clusterIndex : Int
--     , boundingBox : BoundingBox
--     , brushes : List Brush 
--     }


{-| Build a BSP tree from nodes, leaves, and planes.
-}
make : Array BspNodeLump -> Array BspLeafLump -> Array Plane -> BspTree
make nodes leaves planes =
    -- Start from root node index
    makeHelp nodes leaves planes 0


makeHelp : Array BspNodeLump -> Array BspLeafLump -> Array Plane -> Int -> BspTree
makeHelp nodes leaves planes nodeIndex =
    -- Leaf?
    if nodeIndex < 0 then
        Array.get (-nodeIndex - 1) leaves
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
                        (makeHelp nodes leaves planes node.front)
                        (makeHelp nodes leaves planes node.back)
                    )
            )
            maybeNode
            maybePlane
            |> Maybe.withDefault Empty


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
