module Shaders.Q3dm3 exposing (..)

import WebGL.Settings as Settings
import WebGL.Settings.Blend as Blend
import WebGL.Settings.DepthTest as DepthTest
import Shaders.Pipeline as Pipeline exposing (..)

{- ==================================
   textures/liquids/lavahell
   ==================================
-}
textures_liquids_lavahell = 
    empty
        |> addStage
            { vertexShader = textures_liquids_lavahell_vertex_0
            , fragmentShader = textures_liquids_lavahell_fragment_0
            , map = withTexture "textures/liquids/lavahell"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=1 }
                
                ]
            }
textures_liquids_lavahell_vertex_0 = 
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
textures_liquids_lavahell_fragment_0 = 
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
   textures/skies/killsky
   ==================================
-}
textures_skies_killsky = 
    empty
    |> setSkyFlag
    |> addStage
            { vertexShader = textures_skies_killsky_vertex_0
            , fragmentShader = textures_skies_killsky_fragment_0
            , map = withTexture "textures/skies/killsky_1"
            , settings =
                [ Blend.add Blend.one Blend.zero
                , DepthTest.lessOrEqual { write= True, near=0, far=1 }
                , Settings.cullFace Settings.front
                ]
            }
    |> addStage
            { vertexShader = textures_skies_killsky_vertex_1
            , fragmentShader = textures_skies_killsky_fragment_1
            , map = withTexture "textures/skies/killsky_2"
            , settings =
                [ Blend.add Blend.one Blend.one
                , DepthTest.lessOrEqual { write= False, near=0, far=1 }
                , Settings.cullFace Settings.front
                ]
            }
textures_skies_killsky_vertex_0 = 
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
textures_skies_killsky_fragment_0 = 
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
textures_skies_killsky_vertex_1 = 
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
textures_skies_killsky_fragment_1 = 
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
