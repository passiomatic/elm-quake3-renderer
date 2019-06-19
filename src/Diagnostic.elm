module Diagnostic exposing (drawBoundingBox)

{-| Diagnostic drawing functions.
-}

import BoundingBox exposing (BoundingBox)
import Color exposing (Color)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import WebGL exposing (Entity, Mesh, Shader)
import WebGL.Settings.DepthTest as DepthTest


drawBoundingBox : BoundingBox -> Color -> Mat4 -> Mat4 -> Entity
drawBoundingBox boundingBox color modelView projection =
    let
        transform =
            Mat4.identity
                |> Mat4.translate (BoundingBox.centerPoint boundingBox)
                |> Mat4.scale (BoundingBox.dimensions boundingBox)
                |> Mat4.mul modelView
    in
    WebGL.entityWith
        [ DepthTest.lessOrEqual { write = False, near = 0, far = 0.9 } ]
        vertexShader
        fragmentShader
        mesh
        { projection = projection
        , modelView = transform
        , color = color
        }


mesh : Mesh Vertex
mesh =
    -- Front and diagonals
    [ ( ( -1, -1, -1 ), ( 1, -1, -1 ) )
    , ( ( 1, -1, -1 ), ( 1, -1, 1 ) )
    , ( ( 1, -1, 1 ), ( -1, -1, 1 ) )
    , ( ( -1, -1, 1 ), ( -1, -1, -1 ) )
    , ( ( -1, -1, -1 ), ( 1, -1, 1 ) )
    , ( ( 1, -1, -1 ), ( -1, -1, 1 ) )
    ] ++
    -- Right and diagonals
    [ ( ( 1, -1, -1 ), ( 1, 1, -1 ) )
    , ( ( 1, 1, -1 ), ( 1, 1, 1 ) )
    , ( ( 1, 1, 1 ), ( 1, -1, 1 ) )
    , ( ( 1, -1, -1 ), ( 1, 1, 1 ) )
    , ( ( 1, 1, -1 ), ( 1, -1, 1 ) )
    ] ++
    -- Left and diagonals
    [ ( ( -1, 1, -1 ), ( -1, -1, -1 ) )
    , ( ( -1, -1, 1 ), ( -1, 1, 1 ) )
    , ( ( -1, 1, 1 ), ( -1, 1, -1 ) )
    , ( ( -1, 1, -1 ), ( -1, -1, 1 ) )
    , ( ( -1, -1, -1 ), ( -1, 1, 1 ) )
    ] ++
    -- Back and diagonals
    [ ( ( -1, 1, -1 ), ( 1, 1, -1 ) )
    , ( ( -1, 1, 1 ), ( 1, 1, 1 ) )
    , ( ( 1, 1, -1 ), ( -1, 1, 1 ) )
    , ( ( -1, 1, -1 ), ( 1, 1, 1 ) )
    ] ++
    -- Top diagonals only 
    [ ( ( 1, -1, 1 ), ( -1, 1, 1 ) )
    , ( ( -1, -1, 1 ), ( 1, 1, 1 ) )
    ] ++
    -- Bottom diagonals only 
    [ ( ( -1, 1, -1 ), ( 1, -1, -1 ) )
    , ( ( 1, 1, -1 ), ( -1, -1, -1 ) )
    ]
        |> List.map
            (\( ( x1, y1, z1 ), ( x2, y2, z2 ) ) ->
                ( Vertex (vec3 x1 y1 z1), Vertex (vec3 x2 y2 z2) )
            )
        |> WebGL.lines


type alias Vertex =
    { position : Vec3
    }


type alias Uniforms =
    { modelView : Mat4
    , projection : Mat4
    , color : Vec4
    }


vertexShader : Shader Vertex Uniforms { vColor : Vec4 }
vertexShader =
    [glsl|
        uniform mat4 modelView;
        uniform mat4 projection;
        uniform vec4 color;

        // In
        attribute vec3 position;

        // Out
        varying vec4 vColor;
     
        void main () {
          gl_Position = projection * modelView * vec4(position, 1.0);
          vColor = color;
        }

    |]


fragmentShader : Shader {} Uniforms { vColor : Vec4 }
fragmentShader =
    [glsl|
        precision mediump float;

        // In
        varying vec4 vColor;

        void main () {
          gl_FragColor = vColor;
        }
    |]
