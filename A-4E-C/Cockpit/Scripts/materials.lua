dofile(LockOn_Options.script_path.."fonts.lua")
dofile(LockOn_Options.common_script_path.."Fonts/fonts_cmn.lua")

-------MATERIALS-------
materials = {}
materials["DBG_GREY"]    = {25, 25, 25, 255}
materials["DBG_BLACK"]   = {0, 0, 0, 100}
materials["DBG_GREEN"]   = {0, 80, 0, 255}
materials["DBG_RED"]     = {255, 0, 0, 100}
materials["DBG_CLEAR"]   = {0, 0, 0, 0}
materials["BLOB_COLOR"] = {0, 128, 0, 192}
materials["RADAR_FOV"] 	= {17, 80, 7, 0}
materials["RADAR_GRID"] = {0, 100, 0, 192}
materials["RADAR_SCRIBE"] = {0, 200,0, 192}
materials["GUNSIGHT_GLASS"] = {0, 120, 0, 128}
materials["GUNSIGHT_COLOR"] = {255, 65, 0, 255}


local IndicationTexturesPath = LockOn_Options.script_path.."../Resources/IndicationTextures/"

-------TEXTURES-------
textures = {}
textures["BLOB_TEXTURE"] = {"a4e_radar_blob.dds",materials["BLOB_COLOR"]}
textures["GUNSIGHT_TEXTURE"] = {"a4e_gunsight_reticle.dds",materials["GUNSIGHT_COLOR"]}

-------------------------------------------------------
-------FONTS-------
fonts = {}
fonts["font_kneeboard"]			= {fontdescription_cmn["font_general_loc"], 10, {25, 33, 33, 255}}
fonts["font_kneeboard_white"]   = {fontdescription_cmn["font_general_loc"], 10, {255, 255, 255, 255}}
fonts["font_kneeboard_hint"]	= {fontdescription_cmn["font_general_loc"], 10, {143, 23, 0, 255}}

-- force preload resources to avoid freeze on start (list of texture files)
--[[
preload_texture =
{
}
--]]