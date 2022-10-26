dofile(LockOn_Options.script_path.."fonts.lua")
dofile(LockOn_Options.common_script_path.."Fonts/fonts_cmn.lua")
dofile(LockOn_Options.script_path.."RADAR/Indicator/radar_display_settings.lua")

-------MATERIALS-------
materials = {}
materials["DBG_GREY"]    = {25, 25, 25, 255}
materials["DBG_BLACK"]   = {0, 0, 0, 100}
materials["DBG_GREEN"]   = {0, 80, 0, 255}
materials["DBG_RED"]     = {255, 0, 0, 100}
materials["DBG_RED_SOLID"]     = {255, 0, 0, 255}
materials["DBG_CLEAR"]   = {0, 0, 0, 0}
materials["BLOB_COLOR"] = blob_color
materials["RADAR_FOV"] 	= {17, 80, 7, 0}
materials["RADAR_GRID"] = {0, 96, 48, 192}
materials["RADAR_SCALE_MASK"] = {0,0,0,255}
materials["RADAR_SCALE_LIGHT"] = reticle_color
materials["RADAR_SCALE_FILTER"] = {255,0,0,255}
materials["RADAR_SCRIBE"] = blob_color--{0, 192, 0, 128} -- temporary, to be overridden in 2.1
materials["GUNSIGHT_GLASS"] = {0, 120, 0, 128}
materials["GUNSIGHT_COLOR"] = {255, 48, 0, 255}
materials["RWR_CONTACT"] = {192, 255, 8, 255}


local IndicationTexturesPath = LockOn_Options.script_path.."../Resources/IndicationTextures/"

-------TEXTURES-------
textures = {}
textures["BLOB_TEXTURE"] = {"a4e_radar_blob.dds",materials["BLOB_COLOR"]}
textures["GUNSIGHT_TEXTURE"] = {"a4e_gunsight_reticle.dds",materials["GUNSIGHT_COLOR"]}
textures["RADAR_SCALE"] = {"a4e_cockpit_radar_scale.dds", materials["RADAR_SCALE_MASK"]}
textures["RADAR_SCALE_RET"] = {"a4e_cockpit_radar_scale.dds", materials["RADAR_SCALE_LIGHT"]}
--a4e_cockpit_radar_scale
-------------------------------------------------------
-------FONTS-------
fonts = {}
fonts["font_kneeboard"]			= {fontdescription_cmn["font_general_loc"], 10, {0, 0, 0, 255}}
fonts["font_kneeboard_white"]   = {fontdescription_cmn["font_general_loc"], 10, {255, 255, 255, 255}}
fonts["font_kneeboard_hint"]	= {fontdescription_cmn["font_general_loc"], 10, {15, 81, 116, 255}}
-- fonts["font_radio_labels"]      = {fontdescription["font_arc51_labels"], 10, {0, 0, 0, 255}}
fonts["font_radio_labels"]      = {fontdescription["font_handwritten"], 10, {0, 0, 0, 255}}

-- force preload resources to avoid freeze on start (list of texture files)
--[[
preload_texture =
{
}
--]]