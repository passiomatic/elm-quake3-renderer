module Shaders.Q3dm2 exposing (..)

import WebGL.Settings as Settings
import WebGL.Settings.Blend as Blend
import WebGL.Settings.DepthTest as DepthTest
import Shaders.Pipeline as Pipeline exposing (..)

{- ==================================
   textures/base_floor/proto_rustygrate
   ==================================
-}
textures_base_floor_proto_rustygrate = 
    empty
        |> addStage
            { vertexShader = textures_base_floor_proto_rustygrate_vertex_0
            , fragmentShader = textures_base_floor_proto_rustygrate_fragment_0
            , map = withTexture "textures/base_floor/proto_rustygrate"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_base_floor_proto_rustygrate_vertex_1
            , fragmentShader = textures_base_floor_proto_rustygrate_fragment_1
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_base_floor_proto_rustygrate_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_floor_proto_rustygrate_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	// alphaFunc GE128
	if(alpha < 0.5) { discard; }
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_base_floor_proto_rustygrate_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_floor_proto_rustygrate_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/base_floor/rusty_pentagrate
   ==================================
-}
textures_base_floor_rusty_pentagrate = 
    empty
        |> addStage
            { vertexShader = textures_base_floor_rusty_pentagrate_vertex_0
            , fragmentShader = textures_base_floor_rusty_pentagrate_fragment_0
            , map = withTexture "textures/base_floor/rusty_pentagrate"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_base_floor_rusty_pentagrate_vertex_1
            , fragmentShader = textures_base_floor_rusty_pentagrate_fragment_1
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_base_floor_rusty_pentagrate_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_floor_rusty_pentagrate_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	// alphaFunc GE128
	if(alpha < 0.5) { discard; }
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_base_floor_rusty_pentagrate_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_floor_rusty_pentagrate_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/base_trim/deeprust_trans
   ==================================
-}
textures_base_trim_deeprust_trans = 
    empty
        |> addStage
            { vertexShader = textures_base_trim_deeprust_trans_vertex_0
            , fragmentShader = textures_base_trim_deeprust_trans_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_base_trim_deeprust_trans_vertex_1
            , fragmentShader = textures_base_trim_deeprust_trans_fragment_1
            , map = withTexture "textures/base_trim/deeprust"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_base_trim_deeprust_trans_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_trim_deeprust_trans_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_base_trim_deeprust_trans_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_trim_deeprust_trans_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   flareShader
   ==================================
-}
flareShader = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = flareShader_vertex_0
            , fragmentShader = flareShader_fragment_0
            , map = withTexture "gfx/misc/flare"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
flareShader_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
flareShader_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	// rgbGen vertex
	vec3 rgb = textureColor.rgb * vColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/gothic_block/wetwall
   ==================================
-}
textures_gothic_block_wetwall = 
    empty
        |> addStage
            { vertexShader = textures_gothic_block_wetwall_vertex_0
            , fragmentShader = textures_gothic_block_wetwall_fragment_0
            , map = withTexture "textures/gothic_block/wetwall"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_wetwall_vertex_1
            , fragmentShader = textures_gothic_block_wetwall_fragment_1
            , map = withTexture "textures/gothic_block/wetwallfx"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_wetwall_vertex_2
            , fragmentShader = textures_gothic_block_wetwall_fragment_2
            , map = withTexture "textures/gothic_block/wetwall"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_wetwall_vertex_3
            , fragmentShader = textures_gothic_block_wetwall_fragment_3
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_block_wetwall_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_wetwall_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_block_wetwall_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scroll
	vTextureCoord += vec2(0.0000 * time, -0.1000 * time);
	// tcMod scale
	vTextureCoord *= vec2(2.0000, 0.6000);
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_wetwall_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_block_wetwall_vertex_2 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_wetwall_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_block_wetwall_vertex_3 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_wetwall_fragment_3 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/gothic_floor/q1metal7_99spot
   ==================================
-}
textures_gothic_floor_q1metal7_99spot = 
    empty
        |> addStage
            { vertexShader = textures_gothic_floor_q1metal7_99spot_vertex_0
            , fragmentShader = textures_gothic_floor_q1metal7_99spot_fragment_0
            , map = withTexture "textures/liquids/proto_grueldark2"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_q1metal7_99spot_vertex_1
            , fragmentShader = textures_gothic_floor_q1metal7_99spot_fragment_1
            , map = withTexture "textures/effects/tinfx3"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_q1metal7_99spot_vertex_2
            , fragmentShader = textures_gothic_floor_q1metal7_99spot_fragment_2
            , map = withTexture "textures/gothic_floor/q1metal7_99spot"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_q1metal7_99spot_vertex_3
            , fragmentShader = textures_gothic_floor_q1metal7_99spot_fragment_3
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_floor_q1metal7_99spot_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(2.0000, 2.0000);
	// tcMod scroll
	vTextureCoord += vec2(0.0100 * time, 0.0300 * time);
	// tcMod turb
	float turbTime2 = 0.0000 + time * 0.0500;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime2 ) * 6.283) * 0.0500;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime2 ) * 6.283) * 0.0500;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_q1metal7_99spot_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_floor_q1metal7_99spot_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// tcGen environment
	vec3 viewer = normalize(-worldPosition.xyz);
	float d = dot(normal, viewer);
	vec3 reflected = normal*2.0*d - viewer;
	vTextureCoord = vec2(0.5, 0.5) + reflected.xy * 0.5;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_q1metal7_99spot_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_floor_q1metal7_99spot_vertex_2 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_q1metal7_99spot_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_floor_q1metal7_99spot_vertex_3 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_q1metal7_99spot_fragment_3 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/gothic_light/pentagram_light1_5K
   ==================================
-}
textures_gothic_light_pentagram_light1_5K = 
    empty
        |> addStage
            { vertexShader = textures_gothic_light_pentagram_light1_5K_vertex_0
            , fragmentShader = textures_gothic_light_pentagram_light1_5K_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_light_pentagram_light1_5K_vertex_1
            , fragmentShader = textures_gothic_light_pentagram_light1_5K_fragment_1
            , map = withTexture "textures/gothic_light/pentagram_light1"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_light_pentagram_light1_5K_vertex_2
            , fragmentShader = textures_gothic_light_pentagram_light1_5K_fragment_2
            , map = withTexture "textures/gothic_light/pentagram_light1_blend"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_light_pentagram_light1_5K_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_light_pentagram_light1_5K_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_light_pentagram_light1_5K_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_light_pentagram_light1_5K_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_light_pentagram_light1_5K_vertex_2 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_light_pentagram_light1_5K_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.8000 + sin((0.0000 + time * 1.0000) * 6.283) * 0.2000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/gothic_trim/pitted_rust3_trans
   ==================================
-}
textures_gothic_trim_pitted_rust3_trans = 
    empty
        |> addStage
            { vertexShader = textures_gothic_trim_pitted_rust3_trans_vertex_0
            , fragmentShader = textures_gothic_trim_pitted_rust3_trans_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_trim_pitted_rust3_trans_vertex_1
            , fragmentShader = textures_gothic_trim_pitted_rust3_trans_fragment_1
            , map = withTexture "textures/gothic_trim/pitted_rust3"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_trim_pitted_rust3_trans_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_trim_pitted_rust3_trans_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_gothic_trim_pitted_rust3_trans_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_trim_pitted_rust3_trans_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/gothic_door/door02_i_ornate5_fin
   ==================================
-}
textures_gothic_door_door02_i_ornate5_fin = 
    empty
        |> addStage
            { vertexShader = textures_gothic_door_door02_i_ornate5_fin_vertex_0
            , fragmentShader = textures_gothic_door_door02_i_ornate5_fin_fragment_0
            , map = withTexture "textures/gothic_door/door02_i_ornate5_fin"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_door_door02_i_ornate5_fin_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_door_door02_i_ornate5_fin_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/liquids/calm_poollight
   ==================================
-}
textures_liquids_calm_poollight = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = textures_liquids_calm_poollight_vertex_0
            , fragmentShader = textures_liquids_calm_poollight_fragment_0
            , map = withTexture "textures/liquids/pool3d_5c2"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_liquids_calm_poollight_vertex_1
            , fragmentShader = textures_liquids_calm_poollight_fragment_1
            , map = withTexture "textures/liquids/pool3d_6c2"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_liquids_calm_poollight_vertex_2
            , fragmentShader = textures_liquids_calm_poollight_fragment_2
            , map = withTexture "textures/liquids/pool3d_3c2"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_liquids_calm_poollight_vertex_3
            , fragmentShader = textures_liquids_calm_poollight_fragment_3
            , map = withTexture "textures/liquids/pool3d_4b2"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_liquids_calm_poollight_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	// deformVertexes wave
	float deformOff0 = (position.x + position.y + position.z) * 0.0100;
	float deform0 = 1.0000 + sin((1.0000 + deformOff0 + time * 0.1000) * 6.283) * 1.0000;
	defPosition += normal * deform0;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(0.5000, 0.5000);
	// tcMod scroll
	vTextureCoord += vec2(-0.0500 * time, 0.0010 * time);
	gl_Position = projection * worldPosition;
}
    |]
textures_liquids_calm_poollight_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_liquids_calm_poollight_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	// deformVertexes wave
	float deformOff0 = (position.x + position.y + position.z) * 0.0100;
	float deform0 = 1.0000 + sin((1.0000 + deformOff0 + time * 0.1000) * 6.283) * 1.0000;
	defPosition += normal * deform0;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(0.5000, 0.5000);
	// tcMod scroll
	vTextureCoord += vec2(0.0250 * time, -0.0010 * time);
	gl_Position = projection * worldPosition;
}
    |]
textures_liquids_calm_poollight_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_liquids_calm_poollight_vertex_2 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	// deformVertexes wave
	float deformOff0 = (position.x + position.y + position.z) * 0.0100;
	float deform0 = 1.0000 + sin((1.0000 + deformOff0 + time * 0.1000) * 6.283) * 1.0000;
	defPosition += normal * deform0;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(0.2500, 0.5000);
	// tcMod scroll
	vTextureCoord += vec2(0.0010 * time, 0.0250 * time);
	gl_Position = projection * worldPosition;
}
    |]
textures_liquids_calm_poollight_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_liquids_calm_poollight_vertex_3 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	// deformVertexes wave
	float deformOff0 = (position.x + position.y + position.z) * 0.0100;
	float deform0 = 1.0000 + sin((1.0000 + deformOff0 + time * 0.1000) * 6.283) * 1.0000;
	defPosition += normal * deform0;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(0.1250, 0.1250);
	gl_Position = projection * worldPosition;
}
    |]
textures_liquids_calm_poollight_fragment_3 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   models/mapobjects/horned/horned
   ==================================
-}
models_mapobjects_horned_horned = 
    empty
        |> addStage
            { vertexShader = models_mapobjects_horned_horned_vertex_0
            , fragmentShader = models_mapobjects_horned_horned_fragment_0
            , map = withTexture "textures/sfx/firewalla"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = models_mapobjects_horned_horned_vertex_1
            , fragmentShader = models_mapobjects_horned_horned_fragment_1
            , map = withTexture "models/mapobjects/horned/horned"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
models_mapobjects_horned_horned_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scroll
	vTextureCoord += vec2(0.1000 * time, 1.0000 * time);
	gl_Position = projection * worldPosition;
}
    |]
models_mapobjects_horned_horned_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
models_mapobjects_horned_horned_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
models_mapobjects_horned_horned_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	// rgbGen vertex
	vec3 rgb = textureColor.rgb * vColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   models/mapobjects/timlamp/timlamp
   ==================================
-}
models_mapobjects_timlamp_timlamp = 
    empty
        |> addStage
            { vertexShader = models_mapobjects_timlamp_timlamp_vertex_0
            , fragmentShader = models_mapobjects_timlamp_timlamp_fragment_0
            , map = withTexture "models/mapobjects/timlamp/timlamp"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
models_mapobjects_timlamp_timlamp_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
models_mapobjects_timlamp_timlamp_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	// rgbGen vertex
	vec3 rgb = textureColor.rgb * vColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	// alphaFunc GE128
	if(alpha < 0.5) { discard; }
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   models/mapobjects/pitted_rust_ps
   ==================================
-}
models_mapobjects_pitted_rust_ps = 
    empty
        |> addStage
            { vertexShader = models_mapobjects_pitted_rust_ps_vertex_0
            , fragmentShader = models_mapobjects_pitted_rust_ps_fragment_0
            , map = withTexture "models/mapobjects/pitted_rust_ps"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
models_mapobjects_pitted_rust_ps_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
models_mapobjects_pitted_rust_ps_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	// rgbGen vertex
	vec3 rgb = textureColor.rgb * vColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   models/mapobjects/skull/ribcage
   ==================================
-}
models_mapobjects_skull_ribcage = 
    empty
    |> sortAsUnderwater
    |> addStage
            { vertexShader = models_mapobjects_skull_ribcage_vertex_0
            , fragmentShader = models_mapobjects_skull_ribcage_fragment_0
            , map = withTexture "models/mapobjects/skull/ribcage"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
models_mapobjects_skull_ribcage_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
models_mapobjects_skull_ribcage_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	// rgbGen vertex
	vec3 rgb = textureColor.rgb * vColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	// alphaFunc GE128
	if(alpha < 0.5) { discard; }
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/sfx/flame1
   ==================================
-}
textures_sfx_flame1 = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = textures_sfx_flame1_vertex_0
            , fragmentShader = textures_sfx_flame1_fragment_0
            , map = withAnimation 10 [ "textures/sfx/flame1", "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1_vertex_1
            , fragmentShader = textures_sfx_flame1_fragment_1
            , map = withAnimation 10 [ "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8", "textures/sfx/flame1" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1_vertex_2
            , fragmentShader = textures_sfx_flame1_fragment_2
            , map = withTexture "textures/sfx/flameball"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_sfx_flame1_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_sfx_flame1_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.0000 + 1.0 - fract(0.0000 + time * 10.0000) * 1.0000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_sfx_flame1_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_sfx_flame1_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.0000 + fract(0.0000 + time * 10.0000) * 1.0000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_sfx_flame1_vertex_2 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_sfx_flame1_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.6000 + sin((0.0000 + time * 0.6000) * 6.283) * 0.2000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/sfx/flame1dark
   ==================================
-}
textures_sfx_flame1dark = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = textures_sfx_flame1dark_vertex_0
            , fragmentShader = textures_sfx_flame1dark_fragment_0
            , map = withAnimation 10 [ "textures/sfx/flame1", "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1dark_vertex_1
            , fragmentShader = textures_sfx_flame1dark_fragment_1
            , map = withAnimation 10 [ "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8", "textures/sfx/flame1" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1dark_vertex_2
            , fragmentShader = textures_sfx_flame1dark_fragment_2
            , map = withTexture "textures/sfx/flameball"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_sfx_flame1dark_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_sfx_flame1dark_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.0000 + 1.0 - fract(0.0000 + time * 10.0000) * 1.0000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_sfx_flame1dark_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_sfx_flame1dark_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.0000 + fract(0.0000 + time * 10.0000) * 1.0000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_sfx_flame1dark_vertex_2 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_sfx_flame1dark_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.6000 + sin((0.0000 + time * 0.6000) * 6.283) * 0.2000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/organics/dirt_trans
   ==================================
-}
textures_organics_dirt_trans = 
    empty
        |> addStage
            { vertexShader = textures_organics_dirt_trans_vertex_0
            , fragmentShader = textures_organics_dirt_trans_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_organics_dirt_trans_vertex_1
            , fragmentShader = textures_organics_dirt_trans_fragment_1
            , map = withTexture "textures/organics/dirt"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_organics_dirt_trans_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 lightmapCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_organics_dirt_trans_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_organics_dirt_trans_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_organics_dirt_trans_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/skies/toxicskytim_dm5
   ==================================
-}
textures_skies_toxicskytim_dm5 = 
    empty
    |> setSkyFlag
    |> addStage
            { vertexShader = textures_skies_toxicskytim_dm5_vertex_0
            , fragmentShader = textures_skies_toxicskytim_dm5_fragment_0
            , map = withTexture "textures/skies/bluedimclouds"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0.9, far=1 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skies_toxicskytim_dm5_vertex_1
            , fragmentShader = textures_skies_toxicskytim_dm5_fragment_1
            , map = withTexture "textures/skies/topclouds"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0.9, far=1 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skies_toxicskytim_dm5_vertex_0 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(3.0000, 2.0000);
	// tcMod scroll
	vTextureCoord += vec2(0.1500 * time, 0.1500 * time);
	gl_Position = projection * worldPosition;
}
    |]
textures_skies_toxicskytim_dm5_fragment_0 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
textures_skies_toxicskytim_dm5_vertex_1 = 
    [glsl|
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 textureCoord;
varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform mat4 modelView;
uniform mat4 projection;
uniform float time;
void main(void) {
	vec3 defPosition = position;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod scale
	vTextureCoord *= vec2(3.0000, 3.0000);
	// tcMod scroll
	vTextureCoord += vec2(0.0500 * time, 0.0500 * time);
	gl_Position = projection * worldPosition;
}
    |]
textures_skies_toxicskytim_dm5_fragment_1 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	vec3 rgb = textureColor.rgb;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
