module Shaders.Pipeline exposing
    ( ShaderPipeline
    , SortOrder(..)
    , Stage
    , TextureDef(..)
    , Uniforms
    , Varyings
    , Vertex
    , addStage
    , default
    , empty
    , isSky
    , model
    , noShader
    , setLightmap
    , setMesh
    , setSkyFlag
    , sortAsBanner
    , sortAsFarthest
    , sortAsNearest
    , sortAsOpaque
    , sortAsTransparent
    , sortAsUnderwater
    , textures
    , useLightmap
    , withAnimation
    , withDefaultTexture
    , withSortValue
    , withTexture
    )

import Array exposing (Array)
import Bitwise exposing (and, or)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3)
import Math.Vector4 as Vec4 exposing (Vec4)
import WebGL exposing (Mesh, Shader)
import WebGL.Settings as Settings exposing (Setting)
import WebGL.Settings.Blend as Blend
import WebGL.Settings.DepthTest as DepthTest
import WebGL.Texture as Texture exposing (Texture)



-- FACE SORTING


type SortOrder
    = Farthest
      --| Sky
    | Opaque
    | Banner
    | Underwater
    | Transparent
    | Nearest
    | SortValue Int



{- Useful surface flags.

   See https://tinyurl.com/y3y56yvq
-}


skySurface =
    0x04


isSky pipeline =
    and pipeline.flags skySurface /= 0


{-| A shader pipeline with multiple stages and optionally bound to a mesh.

This is used to describe default and custom WebGL shaders.

-}
type alias ShaderPipeline =
    { sortOrder : SortOrder
    , flags : Int
    , lightmap : String
    , mesh : Maybe (Mesh Vertex)
    , stages : List Stage
    }


{-| A shader pipeline can have one or more stages. Each stage is rendered on top of the previous one, taking into account the specified settings, like depth testing and blending functions.
-}
type alias Stage =
    { vertexShader : Shader Vertex Uniforms Varyings
    , fragmentShader : Shader {} Uniforms Varyings
    , map : TextureDef
    , settings : List Setting
    }


{-| A single face vertex within the scene.
-}
type alias Vertex =
    { position : Vec3
    , textureCoord : Vec2
    , lightmapCoord : Vec2
    , normal : Vec3
    , color : Vec4
    }


{-| Values passed to the vertex and fragment shader for the whole draw call.
-}
type alias Uniforms =
    { modelView : Mat4
    , projection : Mat4
    , time : Float
    , texture : Texture
    , lightmap : Texture
    }


{-| Values passed to the fragment shader for each pixel.
-}
type alias Varyings =
    { vColor : Vec4
    , vTextureCoord : Vec2
    , vLightmapCoord : Vec2
    }


{-| Empty shader pipeline. It is used as a base to be build upon with the `set*` functions listed below.
-}
empty : ShaderPipeline
empty =
    { sortOrder = Opaque
    , flags = 0
    , lightmap = "$whiteimage"
    , mesh = Nothing
    , stages = []
    }


setMesh : Mesh Vertex -> ShaderPipeline -> ShaderPipeline
setMesh mesh pipeline =
    { pipeline | mesh = Just mesh }


setLightmap : String -> ShaderPipeline -> ShaderPipeline
setLightmap name pipeline =
    { pipeline | lightmap = name }


setSkyFlag : ShaderPipeline -> ShaderPipeline
setSkyFlag pipeline =
    { pipeline | flags = or pipeline.flags skySurface }


addStage : Stage -> ShaderPipeline -> ShaderPipeline
addStage stage pipeline =
    { pipeline | stages = List.append pipeline.stages [ stage ] }


sortAsFarthest : ShaderPipeline -> ShaderPipeline
sortAsFarthest pipeline =
    { pipeline | sortOrder = Farthest }



-- sortAsSky : ShaderPipeline -> ShaderPipeline
-- sortAsSky pipeline =
--     { pipeline | sortOrder = Sky }


sortAsOpaque : ShaderPipeline -> ShaderPipeline
sortAsOpaque pipeline =
    { pipeline | sortOrder = Opaque }


sortAsBanner : ShaderPipeline -> ShaderPipeline
sortAsBanner pipeline =
    { pipeline | sortOrder = Banner }


sortAsUnderwater : ShaderPipeline -> ShaderPipeline
sortAsUnderwater pipeline =
    { pipeline | sortOrder = Underwater }


sortAsTransparent : ShaderPipeline -> ShaderPipeline
sortAsTransparent pipeline =
    { pipeline | sortOrder = Transparent }


sortAsNearest : ShaderPipeline -> ShaderPipeline
sortAsNearest pipeline =
    { pipeline | sortOrder = Nearest }


withSortValue : Int -> ShaderPipeline -> ShaderPipeline
withSortValue value pipeline =
    { pipeline | sortOrder = SortValue value }


{-| Default shader pipeline for opaque surfaces. Most of the arena walls, floor and ceilings are rendered using this.
-}
default : TextureDef -> String -> ShaderPipeline
default texture lightmapName =
    empty
        |> setLightmap lightmapName
        |> addStage
            { vertexShader = defaultVertexShader
            , fragmentShader = defaultFragmentShader
            , map = texture
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write = True, near = 0, far = 0.9 }
                , Settings.cullFace Settings.front
                ]
            }


{-| A shader pipeline for the so-called "models", e.g. decorative arena elements like sculptures.
-}
model : TextureDef -> ShaderPipeline
model texture =
    empty
        |> addStage
            { vertexShader = defaultVertexShader
            , fragmentShader = modelFragmentShader
            , map = texture
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write = True, near = 0, far = 0.9 }
                , Settings.cullFace Settings.front
                ]
            }


{-| Fallback shader pipeline when no shader/texture is found. It displays a fully opaque checker texture.
-}
noShader : ShaderPipeline
noShader =
    empty
        |> addStage
            { vertexShader = defaultVertexShader
            , fragmentShader = defaultFragmentShader
            , map = withDefaultTexture
            , settings =
                [ DepthTest.lessOrEqual { write = True, near = 0, far = 0.9 }
                , Settings.cullFace Settings.front
                ]
            }



-- TEXTURING


type TextureDef
    = Name String
    | Animation Float (Array String)
    | Lightmap


{-| An animation with given frequency (cycles per second) and a list of frames.
-}
withAnimation : Float -> List String -> TextureDef
withAnimation frequency frames =
    Animation frequency (Array.fromList frames)


{-| Regular diffuse map.
-}
withTexture : String -> TextureDef
withTexture name =
    Name name


{-| Default diffuse map.
-}
withDefaultTexture : TextureDef
withDefaultTexture =
    withTexture "$default"


{-| Force the use of lightmap information from the parent shader pipeline.

This is the equivalent of the "$lightmap" keyword in the Quake 3 Arena shader language.

-}
useLightmap : TextureDef
useLightmap =
    Lightmap



-- MISC


{-| Extract all the textures used is a shader pipeline.
-}
textures : ShaderPipeline -> List String
textures pipeline =
    List.filterMap
        (\stage ->
            case stage.map of
                Name name ->
                    Just [ name ]

                Lightmap ->
                    -- Filter out, it's the $lightmap keyword
                    Nothing

                Animation _ names ->
                    Just (Array.toList names)
        )
        pipeline.stages
        |> List.concat



-- SHADERS


defaultVertexShader : Shader Vertex Uniforms Varyings
defaultVertexShader =
    [glsl|
        uniform mat4 projection;
        uniform mat4 modelView;                        
        uniform float time;
        
        // In
        attribute vec3 position;
        attribute vec3 normal;
        attribute vec4 color;
        attribute vec2 textureCoord;
        attribute vec2 lightmapCoord;

        // Out
        varying vec4 vColor;
        varying vec2 vTextureCoord;
        varying vec2 vLightmapCoord;        

        void main () {
          gl_Position = projection * modelView * vec4(position, 1.0);
          vColor = color;
          vTextureCoord = textureCoord; 
          vLightmapCoord = lightmapCoord;
        }

    |]


defaultFragmentShader : Shader {} Uniforms Varyings
defaultFragmentShader =
    [glsl|
        precision mediump float;
        
        uniform sampler2D texture;
        uniform sampler2D lightmap;           
        
        // In
        varying vec4 vColor;  // Unused for default geometry   
        varying vec2 vTextureCoord;
        varying vec2 vLightmapCoord;          

        void main() {
            vec4 diffuseColor = texture2D(texture, vTextureCoord); 
            vec4 lightColor = texture2D(lightmap, vLightmapCoord);
            gl_FragColor = vec4(diffuseColor.rgb * lightColor.rgb, diffuseColor.a);
        }

    |]


modelFragmentShader : Shader {} Uniforms Varyings
modelFragmentShader =
    [glsl|
        precision mediump float;

        uniform sampler2D texture;
        uniform sampler2D lightmap;           
        
        // In
        varying vec4 vColor; 
        varying vec2 vTextureCoord;
        varying vec2 vLightmapCoord; // Unused for meshes   

        void main() {
            vec4 diffuseColor = texture2D(texture, vTextureCoord); 
            gl_FragColor = vec4(diffuseColor.rgb * vColor.rgb, diffuseColor.a); 
        }

    |]


type alias FallbackUniforms =
    { modelView : Mat4
    , projection : Mat4
    }


type alias FallbackVaryings =
    { vColor : Vec4
    }


fallbackVertexShader : Shader Vertex FallbackUniforms FallbackVaryings
fallbackVertexShader =
    [glsl|
        uniform mat4 projection;
        uniform mat4 modelView;
        
        // In
        attribute vec3 position;
        attribute vec3 normal;
        attribute vec4 color;

        // Out
        varying vec4 vColor;
     
        void main () {
          gl_Position = projection * modelView * vec4(position, 1.0);
          vColor = color;
        }

    |]


fallbackFragmentShader : Shader {} FallbackUniforms FallbackVaryings
fallbackFragmentShader =
    [glsl|
        precision mediump float;

        // In
        varying vec4 vColor;

        void main () {
          gl_FragColor = vColor;
        }
    |]
