module Bezier exposing
    ( indices
    , tessellate
    )

import Array exposing (Array)
import List.Extra as List
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Shaders.Pipeline exposing (Vertex)


tesselationLevel =
    4


{-| Tessellate an arbitrary large Bezier patch.

Within a rectangular grid, regions of 3×3 vertices represent biquadratic Bezier patches. Adjacent patches share a line of three vertices. There are a total of `( width-1 ) / 2` by `( height - 1 ) / 2` patches. Patches in the grid start at (i, j) given by:

i = 2n, with n in [ 0 .. ( width - 1 ) / 2 )
j = 2m, with m in [ 0 .. ( height - 1 ) / 2 )

-}
tessellate : Int -> ( Int, Int ) -> Array Vertex -> Array Vertex
tessellate level ( width, height ) patch =
    let
        m =
            (width - 1) // 2

        n =
            (height - 1) // 2

        -- Subdivide a 3x3 patch from the bigger one at given indices
        subdivideAt : Int -> Int -> List Vertex -> List Vertex
        subdivideAt i j accum =
            let
                rowOffset =
                    j * width

                -- First row
                maybeC0 =
                    Array.get (rowOffset + i) patch

                maybeC1 =
                    Array.get (rowOffset + i + 1) patch

                maybeC2 =
                    Array.get (rowOffset + i + 2) patch

                -- Second row
                maybeC3 =
                    Array.get (rowOffset + width + i) patch

                maybeC4 =
                    Array.get (rowOffset + width + i + 1) patch

                maybeC5 =
                    Array.get (rowOffset + width + i + 2) patch

                -- Third row
                maybeC6 =
                    Array.get (rowOffset + width + width + i) patch

                maybeC7 =
                    Array.get (rowOffset + width + width + i + 1) patch

                maybeC8 =
                    Array.get (rowOffset + width + width + i + 2) patch
            in
            case ( maybeC0, maybeC1, ( maybeC2, maybeC3, ( maybeC4, maybeC5, ( maybeC6, maybeC7, maybeC8 ) ) ) ) of
                ( Just c0, Just c1, ( Just c2, Just c3, ( Just c4, Just c5, ( Just c6, Just c7, Just c8 ) ) ) ) ->
                    subdividePatch level c0 c1 c2 c3 c4 c5 c6 c7 c8 accum

                _ ->
                    --Debug.todo "Invalid number of points for subdividePatch"
                    accum 
    in
    -- Loop thru the patch, one column at time
    List.range 0 (m - 1)
        |> List.foldr
            (\i ii ->
                List.range 0 (n - 1)
                    |> List.foldr
                        (\j jj ->
                            subdivideAt (i * 2) (j * 2) jj
                        )
                        ii
            )
            []
        |> Array.fromList


indices : Int -> ( Int, Int ) -> List ( Int, Int, Int )
indices level ( width, height ) =
    let
        m =
            (width - 1) // 2

        n =
            (height - 1) // 2

        ll =
            level + 1

        indicesAt : Int -> List ( Int, Int, Int ) -> List ( Int, Int, Int )
        indicesAt offset accum =
            List.range 0 (level - 1)
                |> List.foldr
                    (\i ii ->
                        List.range 0 (level - 1)
                            |> List.foldr
                                (\j jj ->
                                    let
                                        -- A quad, create two triangles out of it
                                        a =
                                            offset + i + j * ll

                                        b =
                                            offset + i + j * ll + ll + 1

                                        c =
                                            offset + i + j * ll + ll

                                        d =
                                            offset + i + j * ll + 1
                                    in
                                    -- List indices in a counter-clockwise order, so facing the viewer
                                    ( a, b, c ) :: ( a, d, b ) :: jj
                                )
                                ii
                    )
                    accum
    in
    -- Loop thru the patch, one column at time
    List.range 0 (m - 1)
        |> List.foldr
            (\i ii ->
                List.range 0 (n - 1)
                    |> List.foldr
                        (\j jj ->
                            -- Calculate the number of vertices until now and pass as an offset
                            indicesAt (i * n * ll ^ 2 + j * ll ^ 2) jj
                        )
                        ii
            )
            []


subdividePatch : Int -> Vertex -> Vertex -> Vertex -> Vertex -> Vertex -> Vertex -> Vertex -> Vertex -> Vertex -> List Vertex -> List Vertex
subdividePatch level c0 c1 c2 c3 c4 c5 c6 c7 c8 accum =
    let
        -- Calculate points along rows
        r0 =
            subdivideCurve level c0 c1 c2 []

        r1 =
            subdivideCurve level c3 c4 c5 []

        r2 =
            subdivideCurve level c6 c7 c8 []
    in
    -- Now calculate new points along columns
    List.zip3 r0 r1 r2
        |> List.foldr
            (\( p0, p1, p2 ) ii ->
                subdivideCurve level p0 p1 p2 ii
            )
            accum


subdivideCurve : Int -> Vertex -> Vertex -> Vertex -> List Vertex -> List Vertex
subdivideCurve level c0 c1 c2 accum =
    let
        stepSize =
            1 / toFloat level

        newPoints =
            List.range 1 (level - 1)
                |> List.foldr
                    (\index ii ->
                        let
                            t =
                                toFloat index * stepSize

                            b0 =
                                (1 - t) * (1 - t)

                            b1 =
                                2 * t * (1 - t)

                            b2 =
                                t * t

                            -- Interpolate vertex position
                            position =
                                Vec3.add
                                    (Vec3.scale b0 c0.position)
                                    (Vec3.scale b1 c1.position)
                                    |> Vec3.add
                                        (Vec3.scale b2 c2.position)

                            -- Interpolate texture coords
                            textureCoord =
                                Vec2.add
                                    (Vec2.scale b0 c0.textureCoord)
                                    (Vec2.scale b1 c1.textureCoord)
                                    |> Vec2.add
                                        (Vec2.scale b2 c2.textureCoord)

                            -- Interpolate lightmap coords
                            lightmapCoord =
                                Vec2.add
                                    (Vec2.scale b0 c0.lightmapCoord)
                                    (Vec2.scale b1 c1.lightmapCoord)
                                    |> Vec2.add
                                        (Vec2.scale b2 c2.lightmapCoord)
                        in
                        Vertex
                            position
                            textureCoord
                            lightmapCoord
                            -- Unused
                            c0.normal
                            -- Unused
                            c0.color
                            :: ii
                    )
                    -- Start with second control point
                    (c2 :: accum)
    in
    -- Finish with first control point
    c0 :: newPoints
