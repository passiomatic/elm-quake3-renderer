module Shaders.ShaderDef exposing (ShaderDef(..), resolve)

import Dict
import Shaders.Pipeline as Pipeline exposing (ShaderPipeline, TextureDef)
import Shaders.Q3dm1 exposing (..)
import Shaders.Q3dm2 exposing (..)
import Shaders.Q3dm3 exposing (..)


{-| A shader as defined in the BSP file.

A shader often has the same name of the texture the surface needs in order to be properly displayed. When this doesn't happen a custom shader pipeline is specified instead.

-}
type ShaderDef
    = Custom ShaderPipeline
    | UseTexture TextureDef


resolve : String -> ShaderDef
resolve name =
    case Dict.get name shaderLookup of
        Just shaderDef ->
            Custom shaderDef

        Nothing ->
            UseTexture (Pipeline.withTexture name)


shaderLookup =
    Dict.fromList
        -- Q3dm1
        [ ( "textures/base_wall/protobanner", textures_base_wall_protobanner )
        , ( "textures/gothic_block/largerblock3blood", textures_gothic_block_largerblock3blood )
        , ( "textures/gothic_door/skullarch_b", textures_gothic_door_skullarch_b )
        , ( "textures/gothic_block/killblockgeomtrn", textures_gothic_block_killblockgeomtrn )
        , ( "textures/gothic_block/demon_block15fx", textures_gothic_block_demon_block15fx )
        , ( "textures/gothic_floor/center2trn", textures_gothic_floor_center2trn )
        , ( "textures/gothic_floor/largerblock3b_ow", textures_gothic_floor_largerblock3b_ow )
        , ( "textures/gothic_light/pentagram_light1_1K", textures_gothic_light_pentagram_light1_1K )
        , ( "textures/gothic_trim/pitted_rust2_trans", textures_gothic_trim_pitted_rust2_trans )
        , ( "textures/liquids/lavahell_750", textures_liquids_lavahell_750 )
        , ( "textures/liquids/lavahellflat_400", textures_liquids_lavahellflat_400 )
        , ( "models/mapobjects/wallhead/lion_m", models_mapobjects_wallhead_lion_m )
        , ( "models/mapobjects/gratelamp/gratetorch2b", models_mapobjects_gratelamp_gratetorch2b )
        , ( "textures/sfx/flame1side", textures_sfx_flame1side )
        , ( "textures/sfx/flame2", textures_sfx_flame2 )
        , ( "textures/sfx/flame1_hell", textures_sfx_flame1_hell )
        , ( "textures/sfx/computer_blocks17", textures_sfx_computer_blocks17 )
        , ( "textures/skin/chapthroatooz", textures_skin_chapthroatooz )
        , ( "textures/skin/chapthroat2", textures_skin_chapthroat2 )
        , ( "textures/skin/surface8_trans", textures_skin_surface8_trans )
        , ( "textures/skin/tongue_trans", textures_skin_tongue_trans )
        , ( "textures/skies/tim_hell", textures_skies_tim_hell )

        -- Q3dm2
        , ( "textures/base_floor/proto_rustygrate", textures_base_floor_proto_rustygrate )
        , ( "textures/base_floor/rusty_pentagrate", textures_base_floor_rusty_pentagrate )
        , ( "textures/base_trim/deeprust_trans", textures_base_trim_deeprust_trans )
        , ( "textures/gothic_block/wetwall", textures_gothic_block_wetwall )
        , ( "textures/gothic_floor/q1metal7_99spot", textures_gothic_floor_q1metal7_99spot )
        , ( "textures/gothic_light/pentagram_light1_5K", textures_gothic_light_pentagram_light1_5K ) -- FIXME

        --, ( "textures/gothic_trim/pitted_rust2_trans", textures_gothic_trim_pitted_rust2_trans )
        , ( "textures/gothic_trim/pitted_rust3_trans", textures_gothic_trim_pitted_rust3_trans )
        , ( "textures/gothic_door/door02_i_ornate5_fin", textures_gothic_door_door02_i_ornate5_fin )
        , ( "textures/liquids/calm_poollight", textures_liquids_calm_poollight )
        , ( "models/mapobjects/horned/horned", models_mapobjects_horned_horned )
        , ( "models/mapobjects/timlamp/timlamp", models_mapobjects_timlamp_timlamp )
        , ( "models/mapobjects/pitted_rust_ps", models_mapobjects_pitted_rust_ps )
        , ( "models/mapobjects/skull/ribcage", models_mapobjects_skull_ribcage )
        , ( "textures/sfx/flame1", textures_sfx_flame1 )

        --, ( "textures/sfx/flame1side", textures_sfx_flame1side )
        , ( "textures/sfx/flame1dark", textures_sfx_flame1dark )
        , ( "textures/organics/dirt_trans", textures_organics_dirt_trans )
        , ( "textures/skies/toxicskytim_dm5", textures_skies_toxicskytim_dm5 )

        -- Q3dm3
        --, ("textures/gothic_light/pentagram_light1_1K", textures_gothic_light_pentagram_light1_1K)
        , ( "textures/liquids/lavahell", textures_liquids_lavahell )

        --, ("models/mapobjects/gratelamp/gratetorch2b", models_mapobjects_gratelamp_gratetorch2b)
        --, ("textures/sfx/flame2", textures_sfx_flame2)
        --, ("textures/sfx/flame1dark", textures_sfx_flame1dark)
        --, ("textures/sfx/computer_blocks17", textures_sfx_computer_blocks17)
        , ( "textures/skies/killsky", textures_skies_killsky )

        -- Q3tourney1
        -- --, ("textures/base_floor/proto_rustygrate", textures_base_floor_proto_rustygrate)
        -- , ("textures/base_light/ceil1_38_30k", textures_base_light_ceil1_38_30k)
        -- , ("textures/base_light/xceil1_39_2k", textures_base_light_xceil1_39_2k)
        -- , ("textures/base_light/xceil1_39_5k", textures_base_light_xceil1_39_5k)
        -- , ("textures/base_light/xceil1_39_15k", textures_base_light_xceil1_39_15k)
        -- , ("textures/base_light/xceil1_39_50k", textures_base_light_xceil1_39_50k)
        -- , ("textures/base_wall/atech1_alpha", textures_base_wall_atech1_alpha)
        -- , ("textures/common/weapclip", textures_common_weapclip)
        -- , ("textures/common/hint", textures_common_hint)
        -- , ("textures/common/donotenter", textures_common_donotenter)
        -- --, ("textures/common/nodraw", textures_common_nodraw)
        -- , ("textures/gothic_floor/pent_metalbridge06", textures_gothic_floor_pent_metalbridge06)
        -- , ("textures/gothic_light/gothic_light3_6K", textures_gothic_light_gothic_light3_6K)
        -- , ("textures/gothic_light/gothic_light3_4K", textures_gothic_light_gothic_light3_4K)
        -- , ("textures/liquids/lavahell_xdm1", textures_liquids_lavahell_xdm1)
        -- --, ("models/mapobjects/gratelamp/gratetorch2b", models_mapobjects_gratelamp_gratetorch2b)
        -- --, ("models/mapobjects/flares/electric", models_mapobjects_flares_electric)
        -- --, ("models/mapobjects/pitted_rust_ps", models_mapobjects_pitted_rust_ps)
        -- , ("models/mapobjects/bitch/orb", models_mapobjects_bitch_orb)
        -- , ("models/mapobjects/bitch/forearm", models_mapobjects_bitch_forearm)
        -- , ("textures/sfx/beam_dusty2", textures_sfx_beam_dusty2)
        -- , ("textures/sfx/jacobs_x", textures_sfx_jacobs_x)
        -- , ("textures/sfx/demonltblackfinal", textures_sfx_demonltblackfinal)
        -- --, ("textures/sfx/flame2", textures_sfx_flame2)
        -- , ("textures/sfx/teslacoil", textures_sfx_teslacoil)
        -- , ("textures/skies/nightsky_xian_dm1", textures_skies_nightsky_xian_dm1)
        -- , ("textures/sfx/mkc_fog_dm4", textures_sfx_mkc_fog_dm4)
        -- Common
        -- , ( "textures/common/weapclip", Pipeline.empty )
        -- , ( "textures/common/clip", Pipeline.empty )
        -- , ( "textures/common/hint", Pipeline.empty )
        -- , ( "textures/common/areaportal", Pipeline.empty )
        -- , ( "textures/common/donotenter", Pipeline.empty )
        -- , ( "textures/common/caulk", Pipeline.empty )
        -- , ( "textures/common/nodraw", Pipeline.empty )
        , ( "flareShader", flareShader )
        ]
