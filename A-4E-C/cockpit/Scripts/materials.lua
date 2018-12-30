dofile(LockOn_Options.script_path.."fonts.lua")

-------MATERIALS-------
materials = {}
materials["DBG_GREY"]    = {25, 25, 25, 255}
materials["DBG_BLACK"]   = {0, 0, 0, 100}
materials["DBG_GREEN"]   = {0, 80, 0, 255}
materials["DBG_RED"]     = {255, 0, 0, 100}
materials["DBG_CLEAR"]   = {0, 0, 0, 0}
materials["BLOB_COLOR"] = {0,128,0,192}
materials["RADAR_FOV"] 	= {17,80,7,20}
materials["RADAR_GRID"] = {0,100,0,192}
materials["RADAR_SCRIBE"] = {0,200,0,192}
materials["GUNSIGHT_GLASS"] = {0,120,0,128}
materials["GUNSIGHT_COLOR"] = {255,128,0,255}


local IndicationTexturesPath = LockOn_Options.script_path.."../Resources/IndicationTextures/"

-------TEXTURES-------
textures = {}
textures["BLOB_TEXTURE"] = {"radar_blob.dds",materials["BLOB_COLOR"]}
textures["GUNSIGHT_TEXTURE"] = {"gunsight4.dds",materials["GUNSIGHT_COLOR"]}

-------------------------------------------------------
-------FONTS-------
fonts = {}

-- force preload resources to avoid freeze on start (list of texture files)
--[[
preload_texture =
{
}
--]]