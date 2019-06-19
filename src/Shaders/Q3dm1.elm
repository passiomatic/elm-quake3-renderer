module Shaders.Q3dm1 exposing (..)

import WebGL.Settings as Settings
import WebGL.Settings.Blend as Blend
import WebGL.Settings.DepthTest as DepthTest
import Shaders.Pipeline as Pipeline exposing (..)

{- ==================================
   textures/base_wall/protobanner
   ==================================
-}
textures_base_wall_protobanner = 
    empty
        |> addStage
            { vertexShader = textures_base_wall_protobanner_vertex_0
            , fragmentShader = textures_base_wall_protobanner_fragment_0
            , map = withTexture "textures/base_wall/protobanner"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_base_wall_protobanner_vertex_1
            , fragmentShader = textures_base_wall_protobanner_fragment_1
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_base_wall_protobanner_vertex_0 = 
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
	float deformOff0 = (position.x + position.y + position.z) * 0.0333;
	float deform0 = 0.0000 + sin((0.0000 + deformOff0 + time * 0.2000) * 6.283) * 3.0000;
	defPosition += normal * deform0;
	// deformVertexes wave
	float deformOff1 = (position.x + position.y + position.z) * 0.0100;
	float deform1 = 0.0000 + sin((0.0000 + deformOff1 + time * 0.7000) * 6.283) * 3.0000;
	defPosition += normal * deform1;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_wall_protobanner_fragment_0 = 
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
textures_base_wall_protobanner_vertex_1 = 
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
	// deformVertexes wave
	float deformOff0 = (position.x + position.y + position.z) * 0.0333;
	float deform0 = 0.0000 + sin((0.0000 + deformOff0 + time * 0.2000) * 6.283) * 3.0000;
	defPosition += normal * deform0;
	// deformVertexes wave
	float deformOff1 = (position.x + position.y + position.z) * 0.0100;
	float deform1 = 0.0000 + sin((0.0000 + deformOff1 + time * 0.7000) * 6.283) * 3.0000;
	defPosition += normal * deform1;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	// $lightmap
	vTextureCoord = lightmapCoord;
	gl_Position = projection * worldPosition;
}
    |]
textures_base_wall_protobanner_fragment_1 = 
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
   textures/gothic_block/largerblock3blood
   ==================================
-}
textures_gothic_block_largerblock3blood = 
    empty
        |> addStage
            { vertexShader = textures_gothic_block_largerblock3blood_vertex_0
            , fragmentShader = textures_gothic_block_largerblock3blood_fragment_0
            , map = withTexture "textures/liquids/proto_grueldark2"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_largerblock3blood_vertex_1
            , fragmentShader = textures_gothic_block_largerblock3blood_fragment_1
            , map = withTexture "textures/effects/tinfx3"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_largerblock3blood_vertex_2
            , fragmentShader = textures_gothic_block_largerblock3blood_fragment_2
            , map = withTexture "textures/gothic_block/largerblock3blood"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_largerblock3blood_vertex_3
            , fragmentShader = textures_gothic_block_largerblock3blood_fragment_3
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_block_largerblock3blood_vertex_0 = 
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
textures_gothic_block_largerblock3blood_fragment_0 = 
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
textures_gothic_block_largerblock3blood_vertex_1 = 
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
textures_gothic_block_largerblock3blood_fragment_1 = 
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
textures_gothic_block_largerblock3blood_vertex_2 = 
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
textures_gothic_block_largerblock3blood_fragment_2 = 
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
textures_gothic_block_largerblock3blood_vertex_3 = 
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
textures_gothic_block_largerblock3blood_fragment_3 = 
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
   textures/gothic_door/skullarch_b
   ==================================
-}
textures_gothic_door_skullarch_b = 
    empty
        |> addStage
            { vertexShader = textures_gothic_door_skullarch_b_vertex_0
            , fragmentShader = textures_gothic_door_skullarch_b_fragment_0
            , map = withTexture "textures/sfx/firegorre"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_door_skullarch_b_vertex_1
            , fragmentShader = textures_gothic_door_skullarch_b_fragment_1
            , map = withTexture "textures/gothic_door/skullarch_b"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_door_skullarch_b_vertex_2
            , fragmentShader = textures_gothic_door_skullarch_b_fragment_2
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_door_skullarch_b_vertex_0 = 
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
	vTextureCoord += vec2(0.0000 * time, 1.0000 * time);
	// tcMod turb
	float turbTime1 = 0.0000 + time * 5.6000;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	// tcMod scale
	vTextureCoord *= vec2(1.5000, 1.5000);
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_door_skullarch_b_fragment_0 = 
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
textures_gothic_door_skullarch_b_vertex_1 = 
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
textures_gothic_door_skullarch_b_fragment_1 = 
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
textures_gothic_door_skullarch_b_vertex_2 = 
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
textures_gothic_door_skullarch_b_fragment_2 = 
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
   textures/gothic_block/killblockgeomtrn
   ==================================
-}
textures_gothic_block_killblockgeomtrn = 
    empty
        |> addStage
            { vertexShader = textures_gothic_block_killblockgeomtrn_vertex_0
            , fragmentShader = textures_gothic_block_killblockgeomtrn_fragment_0
            , map = withTexture "textures/sfx/firegorre"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_killblockgeomtrn_vertex_1
            , fragmentShader = textures_gothic_block_killblockgeomtrn_fragment_1
            , map = withTexture "textures/gothic_block/blocks18cgeomtrn2"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_killblockgeomtrn_vertex_2
            , fragmentShader = textures_gothic_block_killblockgeomtrn_fragment_2
            , map = withTexture "textures/gothic_block/blocks18cgeomtrn2"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_killblockgeomtrn_vertex_3
            , fragmentShader = textures_gothic_block_killblockgeomtrn_fragment_3
            , map = withTexture "textures/gothic_block/killblockgeomtrn"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_killblockgeomtrn_vertex_4
            , fragmentShader = textures_gothic_block_killblockgeomtrn_fragment_4
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_block_killblockgeomtrn_vertex_0 = 
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
	vTextureCoord += vec2(0.0000 * time, 1.0000 * time);
	// tcMod turb
	float turbTime1 = 0.0000 + time * 1.6000;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	// tcMod scale
	vTextureCoord *= vec2(2.0000, 2.0000);
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_killblockgeomtrn_fragment_0 = 
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
textures_gothic_block_killblockgeomtrn_vertex_1 = 
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
	// tcMod rotate
	float r = 0.5236 * time;
	vTextureCoord -= vec2(0.5, 0.5);
	vTextureCoord = vec2(vTextureCoord.s * cos(r) - vTextureCoord.t * sin(r), vTextureCoord.t * cos(r) + vTextureCoord.s * sin(r));
	vTextureCoord += vec2(0.5, 0.5);
	float stretchWave = 0.8000 + sin((0.0000 + time * 0.2000) * 6.283) * 0.2000;
	// tcMod stretch
	stretchWave = 1.0 / stretchWave;
	vTextureCoord *= stretchWave;
	vTextureCoord += vec2(0.5 - (0.5 * stretchWave), 0.5 - (0.5 * stretchWave));
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_killblockgeomtrn_fragment_1 = 
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
textures_gothic_block_killblockgeomtrn_vertex_2 = 
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
	// tcMod rotate
	float r = 0.3491 * time;
	vTextureCoord -= vec2(0.5, 0.5);
	vTextureCoord = vec2(vTextureCoord.s * cos(r) - vTextureCoord.t * sin(r), vTextureCoord.t * cos(r) + vTextureCoord.s * sin(r));
	vTextureCoord += vec2(0.5, 0.5);
	float stretchWave = 0.8000 + sin((0.0000 + time * 0.1000) * 6.283) * 0.2000;
	// tcMod stretch
	stretchWave = 1.0 / stretchWave;
	vTextureCoord *= stretchWave;
	vTextureCoord += vec2(0.5 - (0.5 * stretchWave), 0.5 - (0.5 * stretchWave));
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_killblockgeomtrn_fragment_2 = 
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
textures_gothic_block_killblockgeomtrn_vertex_3 = 
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
textures_gothic_block_killblockgeomtrn_fragment_3 = 
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
textures_gothic_block_killblockgeomtrn_vertex_4 = 
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
textures_gothic_block_killblockgeomtrn_fragment_4 = 
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
   textures/gothic_block/demon_block15fx
   ==================================
-}
textures_gothic_block_demon_block15fx = 
    empty
        |> addStage
            { vertexShader = textures_gothic_block_demon_block15fx_vertex_0
            , fragmentShader = textures_gothic_block_demon_block15fx_fragment_0
            , map = withTexture "textures/sfx/firegorre"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_demon_block15fx_vertex_1
            , fragmentShader = textures_gothic_block_demon_block15fx_fragment_1
            , map = withTexture "textures/gothic_block/demon_block15fx"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_block_demon_block15fx_vertex_2
            , fragmentShader = textures_gothic_block_demon_block15fx_fragment_2
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_block_demon_block15fx_vertex_0 = 
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
	vTextureCoord += vec2(0.0000 * time, 1.0000 * time);
	// tcMod turb
	float turbTime1 = 0.0000 + time * 1.6000;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	// tcMod scale
	vTextureCoord *= vec2(4.0000, 4.0000);
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_block_demon_block15fx_fragment_0 = 
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
textures_gothic_block_demon_block15fx_vertex_1 = 
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
textures_gothic_block_demon_block15fx_fragment_1 = 
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
textures_gothic_block_demon_block15fx_vertex_2 = 
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
textures_gothic_block_demon_block15fx_fragment_2 = 
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
   textures/gothic_floor/center2trn
   ==================================
-}
textures_gothic_floor_center2trn = 
    empty
        |> addStage
            { vertexShader = textures_gothic_floor_center2trn_vertex_0
            , fragmentShader = textures_gothic_floor_center2trn_fragment_0
            , map = withTexture "textures/sfx/fireswirl2"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_center2trn_vertex_1
            , fragmentShader = textures_gothic_floor_center2trn_fragment_1
            , map = withTexture "textures/gothic_floor/center2trn"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_center2trn_vertex_2
            , fragmentShader = textures_gothic_floor_center2trn_fragment_2
            , map = withTexture "textures/gothic_floor/center2trn"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_center2trn_vertex_3
            , fragmentShader = textures_gothic_floor_center2trn_fragment_3
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_floor_center2trn_vertex_0 = 
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
	// tcMod rotate
	float r = 5.8118 * time;
	vTextureCoord -= vec2(0.5, 0.5);
	vTextureCoord = vec2(vTextureCoord.s * cos(r) - vTextureCoord.t * sin(r), vTextureCoord.t * cos(r) + vTextureCoord.s * sin(r));
	vTextureCoord += vec2(0.5, 0.5);
	float stretchWave = 0.8000 + sin((0.0000 + time * 9.7000) * 6.283) * 0.2000;
	// tcMod stretch
	stretchWave = 1.0 / stretchWave;
	vTextureCoord *= stretchWave;
	vTextureCoord += vec2(0.5 - (0.5 * stretchWave), 0.5 - (0.5 * stretchWave));
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_center2trn_fragment_0 = 
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
textures_gothic_floor_center2trn_vertex_1 = 
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
	// tcMod rotate
	float r = 0.5236 * time;
	vTextureCoord -= vec2(0.5, 0.5);
	vTextureCoord = vec2(vTextureCoord.s * cos(r) - vTextureCoord.t * sin(r), vTextureCoord.t * cos(r) + vTextureCoord.s * sin(r));
	vTextureCoord += vec2(0.5, 0.5);
	float stretchWave = 0.8000 + sin((0.0000 + time * 0.2000) * 6.283) * 0.2000;
	// tcMod stretch
	stretchWave = 1.0 / stretchWave;
	vTextureCoord *= stretchWave;
	vTextureCoord += vec2(0.5 - (0.5 * stretchWave), 0.5 - (0.5 * stretchWave));
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_center2trn_fragment_1 = 
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
textures_gothic_floor_center2trn_vertex_2 = 
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
textures_gothic_floor_center2trn_fragment_2 = 
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
textures_gothic_floor_center2trn_vertex_3 = 
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
textures_gothic_floor_center2trn_fragment_3 = 
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
   textures/gothic_floor/largerblock3b_ow
   ==================================
-}
textures_gothic_floor_largerblock3b_ow = 
    empty
        |> addStage
            { vertexShader = textures_gothic_floor_largerblock3b_ow_vertex_0
            , fragmentShader = textures_gothic_floor_largerblock3b_ow_fragment_0
            , map = withTexture "textures/sfx/firegorre"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_largerblock3b_ow_vertex_1
            , fragmentShader = textures_gothic_floor_largerblock3b_ow_fragment_1
            , map = withTexture "textures/gothic_floor/largerblock3b_ow"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_floor_largerblock3b_ow_vertex_2
            , fragmentShader = textures_gothic_floor_largerblock3b_ow_fragment_2
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_floor_largerblock3b_ow_vertex_0 = 
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
	vTextureCoord += vec2(0.0000 * time, 1.0000 * time);
	// tcMod turb
	float turbTime1 = 0.0000 + time * 1.6000;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime1 ) * 6.283) * 0.2500;
	// tcMod scale
	vTextureCoord *= vec2(4.0000, 4.0000);
	gl_Position = projection * worldPosition;
}
    |]
textures_gothic_floor_largerblock3b_ow_fragment_0 = 
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
textures_gothic_floor_largerblock3b_ow_vertex_1 = 
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
textures_gothic_floor_largerblock3b_ow_fragment_1 = 
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
textures_gothic_floor_largerblock3b_ow_vertex_2 = 
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
textures_gothic_floor_largerblock3b_ow_fragment_2 = 
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
   textures/gothic_light/pentagram_light1_1K
   ==================================
-}
textures_gothic_light_pentagram_light1_1K = 
    empty
        |> addStage
            { vertexShader = textures_gothic_light_pentagram_light1_1K_vertex_0
            , fragmentShader = textures_gothic_light_pentagram_light1_1K_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_light_pentagram_light1_1K_vertex_1
            , fragmentShader = textures_gothic_light_pentagram_light1_1K_fragment_1
            , map = withTexture "textures/gothic_light/pentagram_light1"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_light_pentagram_light1_1K_vertex_2
            , fragmentShader = textures_gothic_light_pentagram_light1_1K_fragment_2
            , map = withTexture "textures/gothic_light/pentagram_light1_blend"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_light_pentagram_light1_1K_vertex_0 = 
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
textures_gothic_light_pentagram_light1_1K_fragment_0 = 
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
textures_gothic_light_pentagram_light1_1K_vertex_1 = 
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
textures_gothic_light_pentagram_light1_1K_fragment_1 = 
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
textures_gothic_light_pentagram_light1_1K_vertex_2 = 
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
textures_gothic_light_pentagram_light1_1K_fragment_2 = 
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
   textures/gothic_trim/pitted_rust2_trans
   ==================================
-}
textures_gothic_trim_pitted_rust2_trans = 
    empty
        |> addStage
            { vertexShader = textures_gothic_trim_pitted_rust2_trans_vertex_0
            , fragmentShader = textures_gothic_trim_pitted_rust2_trans_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_gothic_trim_pitted_rust2_trans_vertex_1
            , fragmentShader = textures_gothic_trim_pitted_rust2_trans_fragment_1
            , map = withTexture "textures/gothic_trim/pitted_rust2"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_gothic_trim_pitted_rust2_trans_vertex_0 = 
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
textures_gothic_trim_pitted_rust2_trans_fragment_0 = 
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
textures_gothic_trim_pitted_rust2_trans_vertex_1 = 
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
textures_gothic_trim_pitted_rust2_trans_fragment_1 = 
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
   textures/liquids/lavahell_750
   ==================================
-}
textures_liquids_lavahell_750 = 
    empty
        |> addStage
            { vertexShader = textures_liquids_lavahell_750_vertex_0
            , fragmentShader = textures_liquids_lavahell_750_fragment_0
            , map = withTexture "textures/liquids/lavahell"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
textures_liquids_lavahell_750_vertex_0 = 
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
	float deform0 = 3.0000 + sin((0.1000 + deformOff0 + time * 0.1000) * 6.283) * 2.0000;
	defPosition += normal * deform0;
	vec4 worldPosition = modelView * vec4(defPosition, 1.0);
	vColor = color;
	vTextureCoord = textureCoord;
	// tcMod turb
	float turbTime0 = 0.0000 + time * 0.1000;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime0 ) * 6.283) * 0.2000;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime0 ) * 6.283) * 0.2000;
	gl_Position = projection * worldPosition;
}
    |]
textures_liquids_lavahell_750_fragment_0 = 
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
   textures/liquids/lavahellflat_400
   ==================================
-}
textures_liquids_lavahellflat_400 = 
    empty
        |> addStage
            { vertexShader = textures_liquids_lavahellflat_400_vertex_0
            , fragmentShader = textures_liquids_lavahellflat_400_fragment_0
            , map = withTexture "textures/liquids/lavahell"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
textures_liquids_lavahellflat_400_vertex_0 = 
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
	// tcMod turb
	float turbTime0 = 0.0000 + time * 0.1000;
	vTextureCoord.s += sin( ( ( position.x + position.z )* 1.0/128.0 * 0.125 + turbTime0 ) * 6.283) * 0.2000;
	vTextureCoord.t += sin( ( position.y * 1.0/128.0 * 0.125 + turbTime0 ) * 6.283) * 0.2000;
	gl_Position = projection * worldPosition;
}
    |]
textures_liquids_lavahellflat_400_fragment_0 = 
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
   models/mapobjects/wallhead/lion_m
   ==================================
-}
models_mapobjects_wallhead_lion_m = 
    empty
        |> addStage
            { vertexShader = models_mapobjects_wallhead_lion_m_vertex_0
            , fragmentShader = models_mapobjects_wallhead_lion_m_fragment_0
            , map = withTexture "models/mapobjects/wallhead/lion_m"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = models_mapobjects_wallhead_lion_m_vertex_1
            , fragmentShader = models_mapobjects_wallhead_lion_m_fragment_1
            , map = withTexture "textures/sfx/firewalla"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = models_mapobjects_wallhead_lion_m_vertex_2
            , fragmentShader = models_mapobjects_wallhead_lion_m_fragment_2
            , map = withTexture "models/mapobjects/wallhead/lion_m"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
models_mapobjects_wallhead_lion_m_vertex_0 = 
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
models_mapobjects_wallhead_lion_m_fragment_0 = 
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
models_mapobjects_wallhead_lion_m_vertex_1 = 
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
models_mapobjects_wallhead_lion_m_fragment_1 = 
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
models_mapobjects_wallhead_lion_m_vertex_2 = 
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
models_mapobjects_wallhead_lion_m_fragment_2 = 
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
   models/mapobjects/gratelamp/gratetorch2b
   ==================================
-}
models_mapobjects_gratelamp_gratetorch2b = 
    empty
        |> addStage
            { vertexShader = models_mapobjects_gratelamp_gratetorch2b_vertex_0
            , fragmentShader = models_mapobjects_gratelamp_gratetorch2b_fragment_0
            , map = withTexture "models/mapobjects/gratelamp/gratetorch2b"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                
                ]
            }
models_mapobjects_gratelamp_gratetorch2b_vertex_0 = 
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
models_mapobjects_gratelamp_gratetorch2b_fragment_0 = 
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
   textures/sfx/flame1side
   ==================================
-}
textures_sfx_flame1side = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = textures_sfx_flame1side_vertex_0
            , fragmentShader = textures_sfx_flame1side_fragment_0
            , map = withAnimation 10 [ "textures/sfx/flame1", "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1side_vertex_1
            , fragmentShader = textures_sfx_flame1side_fragment_1
            , map = withAnimation 10 [ "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8", "textures/sfx/flame1" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1side_vertex_2
            , fragmentShader = textures_sfx_flame1side_fragment_2
            , map = withTexture "textures/sfx/flameball"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_sfx_flame1side_vertex_0 = 
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
textures_sfx_flame1side_fragment_0 = 
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
textures_sfx_flame1side_vertex_1 = 
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
textures_sfx_flame1side_fragment_1 = 
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
textures_sfx_flame1side_vertex_2 = 
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
textures_sfx_flame1side_fragment_2 = 
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
   textures/sfx/flame2
   ==================================
-}
textures_sfx_flame2 = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = textures_sfx_flame2_vertex_0
            , fragmentShader = textures_sfx_flame2_fragment_0
            , map = withAnimation 10 [ "textures/sfx/flame1", "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame2_vertex_1
            , fragmentShader = textures_sfx_flame2_fragment_1
            , map = withAnimation 10 [ "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8", "textures/sfx/flame1" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame2_vertex_2
            , fragmentShader = textures_sfx_flame2_fragment_2
            , map = withTexture "textures/sfx/flameball"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_sfx_flame2_vertex_0 = 
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
textures_sfx_flame2_fragment_0 = 
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
textures_sfx_flame2_vertex_1 = 
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
textures_sfx_flame2_fragment_1 = 
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
textures_sfx_flame2_vertex_2 = 
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
textures_sfx_flame2_fragment_2 = 
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
   textures/sfx/flame1_hell
   ==================================
-}
textures_sfx_flame1_hell = 
    empty
    |> sortAsTransparent
    |> addStage
            { vertexShader = textures_sfx_flame1_hell_vertex_0
            , fragmentShader = textures_sfx_flame1_hell_fragment_0
            , map = withAnimation 10 [ "textures/sfx/flame1", "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1_hell_vertex_1
            , fragmentShader = textures_sfx_flame1_hell_fragment_1
            , map = withAnimation 10 [ "textures/sfx/flame2", "textures/sfx/flame3", "textures/sfx/flame4", "textures/sfx/flame5", "textures/sfx/flame6", "textures/sfx/flame7", "textures/sfx/flame8", "textures/sfx/flame1" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_flame1_hell_vertex_2
            , fragmentShader = textures_sfx_flame1_hell_fragment_2
            , map = withTexture "textures/sfx/flameball"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                
                ]
            }
textures_sfx_flame1_hell_vertex_0 = 
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
textures_sfx_flame1_hell_fragment_0 = 
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
textures_sfx_flame1_hell_vertex_1 = 
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
textures_sfx_flame1_hell_fragment_1 = 
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
textures_sfx_flame1_hell_vertex_2 = 
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
textures_sfx_flame1_hell_fragment_2 = 
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
   textures/sfx/computer_blocks17
   ==================================
-}
textures_sfx_computer_blocks17 = 
    empty
        |> addStage
            { vertexShader = textures_sfx_computer_blocks17_vertex_0
            , fragmentShader = textures_sfx_computer_blocks17_fragment_0
            , map = withTexture "textures/sfx/computer_blocks17"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_computer_blocks17_vertex_1
            , fragmentShader = textures_sfx_computer_blocks17_fragment_1
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_sfx_computer_blocks17_vertex_2
            , fragmentShader = textures_sfx_computer_blocks17_fragment_2
            , map = withAnimation 2 [ "textures/sfx/compscreen/letters1", "textures/sfx/compscreen/letters2", "textures/sfx/compscreen/letters3", "textures/sfx/compscreen/letters5", "textures/sfx/compscreen/letters4", "textures/sfx/compscreen/letters5", "textures/sfx/compscreen/letters5" ]
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_sfx_computer_blocks17_vertex_0 = 
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
textures_sfx_computer_blocks17_fragment_0 = 
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
textures_sfx_computer_blocks17_vertex_1 = 
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
textures_sfx_computer_blocks17_fragment_1 = 
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
textures_sfx_computer_blocks17_vertex_2 = 
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
textures_sfx_computer_blocks17_fragment_2 = 
    [glsl|
precision mediump float;

varying vec2 vTextureCoord;
varying vec2 vLightmapCoord;
varying vec4 vColor;
uniform sampler2D texture;
uniform float time;
void main(void) {
	vec4 textureColor = texture2D(texture, vTextureCoord.st);
	float rgbWave = 0.0000 + 1.0 - fract(0.0000 + time * 2.0000) * 1.0000;
	// rgbGen wave
	vec3 rgb = textureColor.rgb * rgbWave;
	// alphaGen
	float alpha = textureColor.a;
	gl_FragColor = vec4(rgb, alpha);
}
    |]
{- ==================================
   textures/skin/chapthroatooz
   ==================================
-}
textures_skin_chapthroatooz = 
    empty
        |> addStage
            { vertexShader = textures_skin_chapthroatooz_vertex_0
            , fragmentShader = textures_skin_chapthroatooz_fragment_0
            , map = withTexture "textures/liquids/proto_gruel3"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skin_chapthroatooz_vertex_1
            , fragmentShader = textures_skin_chapthroatooz_fragment_1
            , map = withTexture "textures/skin/chapthroatooz"
            , settings =
                [ Blend.add Blend.srcAlpha Blend.oneMinusSrcAlpha
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skin_chapthroatooz_vertex_2
            , fragmentShader = textures_skin_chapthroatooz_fragment_2
            , map = useLightmap
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skin_chapthroatooz_vertex_0 = 
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
	vTextureCoord += vec2(0.0000 * time, 0.2000 * time);
	// tcMod scale
	vTextureCoord *= vec2(2.0000, 2.0000);
	gl_Position = projection * worldPosition;
}
    |]
textures_skin_chapthroatooz_fragment_0 = 
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
textures_skin_chapthroatooz_vertex_1 = 
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
textures_skin_chapthroatooz_fragment_1 = 
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
textures_skin_chapthroatooz_vertex_2 = 
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
textures_skin_chapthroatooz_fragment_2 = 
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
   textures/skin/chapthroat2
   ==================================
-}
textures_skin_chapthroat2 = 
    empty
        |> addStage
            { vertexShader = textures_skin_chapthroat2_vertex_0
            , fragmentShader = textures_skin_chapthroat2_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skin_chapthroat2_vertex_1
            , fragmentShader = textures_skin_chapthroat2_fragment_1
            , map = withTexture "textures/skin/chapthroat2"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skin_chapthroat2_vertex_0 = 
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
textures_skin_chapthroat2_fragment_0 = 
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
textures_skin_chapthroat2_vertex_1 = 
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
textures_skin_chapthroat2_fragment_1 = 
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
   textures/skin/surface8_trans
   ==================================
-}
textures_skin_surface8_trans = 
    empty
        |> addStage
            { vertexShader = textures_skin_surface8_trans_vertex_0
            , fragmentShader = textures_skin_surface8_trans_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skin_surface8_trans_vertex_1
            , fragmentShader = textures_skin_surface8_trans_fragment_1
            , map = withTexture "textures/skin/surface8"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skin_surface8_trans_vertex_0 = 
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
textures_skin_surface8_trans_fragment_0 = 
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
textures_skin_surface8_trans_vertex_1 = 
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
textures_skin_surface8_trans_fragment_1 = 
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
   textures/skin/tongue_trans
   ==================================
-}
textures_skin_tongue_trans = 
    empty
        |> addStage
            { vertexShader = textures_skin_tongue_trans_vertex_0
            , fragmentShader = textures_skin_tongue_trans_fragment_0
            , map = useLightmap
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skin_tongue_trans_vertex_1
            , fragmentShader = textures_skin_tongue_trans_fragment_1
            , map = withTexture "textures/skin/tongue"
            , settings =
                [ Blend.add Blend.dstColor Blend.zero
                , DepthTest.lessOrEqual { write= False, near=0, far=0.9 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skin_tongue_trans_vertex_0 = 
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
textures_skin_tongue_trans_fragment_0 = 
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
textures_skin_tongue_trans_vertex_1 = 
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
textures_skin_tongue_trans_fragment_1 = 
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
   textures/skies/tim_hell
   ==================================
-}
textures_skies_tim_hell = 
    empty
    |> setSkyFlag
    |> addStage
            { vertexShader = textures_skies_tim_hell_vertex_0
            , fragmentShader = textures_skies_tim_hell_fragment_0
            , map = withTexture "textures/skies/killsky_1"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0.9, far=1 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skies_tim_hell_vertex_1
            , fragmentShader = textures_skies_tim_hell_fragment_1
            , map = withTexture "textures/skies/killsky_2"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0.9, far=1 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skies_tim_hell_vertex_0 = 
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
	vTextureCoord += vec2(0.0500 * time, 0.1000 * time);
	// tcMod scale
	vTextureCoord *= vec2(2.0000, 2.0000);
	gl_Position = projection * worldPosition;
}
    |]
textures_skies_tim_hell_fragment_0 = 
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
textures_skies_tim_hell_vertex_1 = 
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
	vTextureCoord += vec2(0.0500 * time, 0.0600 * time);
	// tcMod scale
	vTextureCoord *= vec2(3.0000, 2.0000);
	gl_Position = projection * worldPosition;
}
    |]
textures_skies_tim_hell_fragment_1 = 
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
