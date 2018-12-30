dofile(LockOn_Options.script_path.."HUD/Indicator/definitions.lua")

local SHOW_MASKS = true
local SHOW_DEBUG = true

local halfboxsize=65
clip_mesh_verts    = {}
clip_mesh_verts[#clip_mesh_verts + 1] = { -halfboxsize, -halfboxsize }
clip_mesh_verts[#clip_mesh_verts + 1] = { -halfboxsize, halfboxsize }
clip_mesh_verts[#clip_mesh_verts + 1] = { halfboxsize, halfboxsize }
clip_mesh_verts[#clip_mesh_verts + 1] = { halfboxsize, -halfboxsize }

debug_screen 			 	 = CreateElement "ceMeshPoly"
debug_screen.name 			 = "debug_screen"
debug_screen.vertices 		 = clip_mesh_verts
debug_screen.indices 		 = default_box_indices
debug_screen.init_pos		 = {0, 0, -10}
debug_screen.init_rot		 = {0, 0, 0}
debug_screen.material		 = "DBG_CLEAR"
debug_screen.h_clip_relation = h_clip_relations.REWRITE_LEVEL
debug_screen.level			 = HUD_NOCLIP_LEVEL
debug_screen.isdraw		 = true
debug_screen.change_opacity = false
debug_screen.element_params = {"D_ENABLE"}
debug_screen.controllers = {{"opacity_using_parameter",0}}
debug_screen.isvisible		 = SHOW_DEBUG
Add(debug_screen)


local debug_y_offset = 40
local DEBUG_COLOR = {0,255,0,200}
local FONT_         = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},DEBUG_COLOR,50,"test_font")

local ias_output = CreateElement "ceStringPoly"
ias_output.name = ("ias_" .. create_guid_string())
ias_output.material = FONT_
ias_output.init_pos = {-70,debug_y_offset-40}
ias_output.alignment = "LeftCenter"
ias_output.stringdefs = {0.75*0.010,0.75*0.75 * 0.010, 0, 0}    --{ecrase vertical si inf a 0.01,ecrase lateral * streccth, 0, 0}
ias_output.formats = {"%3.0fKIAS","%s"} -- knots
ias_output.element_params = {"D_IAS", "D_ENABLE"}
ias_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
ias_output.collimated = true
ias_output.use_mipfilter    = true
ias_output.additive_alpha   = true
ias_output.isvisible		= SHOW_DEBUG
ias_output.parent_element = "debug_screen"
Add(ias_output)

local tas_output = CreateElement "ceStringPoly"
tas_output.name = ("tas_" .. create_guid_string())
tas_output.material = FONT_
tas_output.init_pos = {0,debug_y_offset-40}
tas_output.alignment = "LeftCenter"
tas_output.stringdefs = {0.75*0.010,0.75*0.75 * 0.010, 0, 0}    --{ecrase vertical si inf a 0.01,ecrase lateral * streccth, 0, 0}
tas_output.formats = {"%3.0fKTAS","%s"} -- knots
tas_output.element_params = {"D_TAS", "D_ENABLE"}
tas_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
tas_output.collimated = true
tas_output.use_mipfilter    = true
tas_output.additive_alpha   = true
tas_output.isvisible		= SHOW_DEBUG
tas_output.parent_element = "debug_screen"
Add(tas_output)


local AOA_output = CreateElement "ceStringPoly"
AOA_output.name = create_guid_string()
AOA_output.material = FONT_
AOA_output.init_pos = {-55,debug_y_offset}
AOA_output.alignment = "LeftCenter"
AOA_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
AOA_output.formats = {"i %-2.1f","%s"}
AOA_output.element_params = {"D_AOA", "D_ENABLE"}
AOA_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
AOA_output.additive_alpha = true
AOA_output.use_mipfilter = true
AOA_output.collimated = true
AOA_output.isvisible		= SHOW_DEBUG
AOA_output.parent_element = "debug_screen"
Add(AOA_output)

local mach_output = CreateElement "ceStringPoly"
mach_output.name = create_guid_string()
mach_output.material = FONT_
mach_output.init_pos = {-55,debug_y_offset-10}
mach_output.alignment = "LeftCenter"
mach_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
mach_output.formats = {"M %.2f","%s"}
mach_output.element_params = {"D_MACH", "D_ENABLE"}
mach_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
mach_output.additive_alpha = true
mach_output.collimated = true
mach_output.use_mipfilter = true
mach_output.isvisible		= SHOW_DEBUG
mach_output.parent_element = "debug_screen"
Add(mach_output)

local G_output = CreateElement "ceStringPoly"
G_output.name = create_guid_string()
G_output.material = FONT_
G_output.init_pos = {-55,debug_y_offset-20}
G_output.alignment = "LeftCenter"
G_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
G_output.formats = {"G %2.1f","%s"}
G_output.element_params = {"current_G", "D_ENABLE"}
G_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
G_output.additive_alpha = true
G_output.collimated = true
G_output.use_mipfilter = true
G_output.isvisible		= SHOW_DEBUG
G_output.parent_element = "debug_screen"
Add(G_output)

local HDG_output = CreateElement "ceStringPoly"
HDG_output.name = create_guid_string()
HDG_output.material = FONT_
HDG_output.init_pos = {0,debug_y_offset-60}
HDG_output.alignment = "CenterCenter"
HDG_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
HDG_output.formats = {"TH:%3.1f","%s"}
HDG_output.element_params = {"D_HDG", "D_ENABLE"}
HDG_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
HDG_output.additive_alpha = true
HDG_output.collimated = true
HDG_output.use_mipfilter = true
HDG_output.isvisible = SHOW_DEBUG
HDG_output.parent_element = "debug_screen"
Add(HDG_output)

--[[
local MHDG_output = CreateElement "ceStringPoly"
MHDG_output.name = create_guid_string()
MHDG_output.material = FONT_
MHDG_output.init_pos = {0,debug_y_offset-70}
MHDG_output.alignment = "CenterCenter"
MHDG_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
MHDG_output.formats = {"MH:%3.1f","%s"}
MHDG_output.element_params = {"D_MHDG", "D_ENABLE"}
MHDG_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
MHDG_output.additive_alpha = true
MHDG_output.collimated = true
MHDG_output.use_mipfilter = true
MHDG_output.isvisible = SHOW_DEBUG
MHDG_output.parent_element = "debug_screen"
Add(MHDG_output)
--]]

local ALT_output = CreateElement "ceStringPoly"
ALT_output.name = create_guid_string()
ALT_output.material = FONT_
ALT_output.init_pos = {50,debug_y_offset-50}
ALT_output.alignment = "RightCenter"
ALT_output.stringdefs = {0.75*0.010,0.75*0.75 * 0.010, 0, 0}
ALT_output.formats = {"%s","%s"}
ALT_output.element_params = {"D_ALT", "D_ENABLE"}
ALT_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
ALT_output.additive_alpha = true
ALT_output.collimated = true
ALT_output.use_mipfilter = true
ALT_output.isvisible = SHOW_DEBUG
ALT_output.parent_element = "debug_screen"
Add(ALT_output)

local generic1_output = CreateElement "ceStringPoly"
generic1_output.name = create_guid_string()
generic1_output.material = FONT_
generic1_output.init_pos = {0,debug_y_offset-70}
generic1_output.alignment = "CenterCenter"
generic1_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
generic1_output.formats = {"%s","%s"}
generic1_output.element_params = {"D_GENERIC1", "D_ENABLE"}
generic1_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
generic1_output.additive_alpha = true
generic1_output.collimated = true
generic1_output.use_mipfilter = true
generic1_output.isvisible = SHOW_DEBUG
generic1_output.parent_element = "debug_screen"
Add(generic1_output)

local generic2_output = CreateElement "ceStringPoly"
generic2_output.name = create_guid_string()
generic2_output.material = FONT_
generic2_output.init_pos = {0,debug_y_offset-80}
generic2_output.alignment = "CenterCenter"
generic2_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
generic2_output.formats = {"%s","%s"}
generic2_output.element_params = {"D_GENERIC2", "D_ENABLE"}
generic2_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
generic2_output.additive_alpha = true
generic2_output.collimated = true
generic2_output.use_mipfilter = true
generic2_output.isvisible = SHOW_DEBUG
generic2_output.parent_element = "debug_screen"
Add(generic2_output)

--[[
local FUEL_output           = CreateElement "ceStringPoly"
FUEL_output.name            = create_guid_string()
FUEL_output.material        = FONT_
FUEL_output.init_pos        = {50,-100}
FUEL_output.alignment       = "RightCenter"
FUEL_output.stringdefs      = {0.75*0.010,0.75*0.75 * 0.010, 0, 0}
FUEL_output.formats         = {"F:%.0flbs","%s"}
FUEL_output.element_params  = {"D_FUEL", "D_ENABLE"}
FUEL_output.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}} --first index of text_using_parameter is for element_params (starting with 0) , second for formats ( starting with 0)
FUEL_output.additive_alpha  = true
FUEL_output.collimated     = true
FUEL_output.use_mipfilter = true
FUEL_output.isvisible = SHOW_DEBUG
FUEL_output.parent_element = "debug_screen"
Add(FUEL_output)  ]]--

local VV_output = CreateElement "ceStringPoly"
VV_output.name = create_guid_string()
VV_output.material = FONT_
VV_output.init_pos = {55,debug_y_offset-20}
VV_output.alignment = "RightCenter"
VV_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
VV_output.formats = {"VV:%3.0f","%s"}
VV_output.element_params = {"D_VV", "D_ENABLE"}
VV_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
VV_output.additive_alpha = true
VV_output.collimated = true
VV_output.use_mipfilter = true
VV_output.isvisible = SHOW_DEBUG
VV_output.parent_element = "debug_screen"
Add(VV_output)

local RPM_output = CreateElement "ceStringPoly"
RPM_output.name = create_guid_string()
RPM_output.material = FONT_
RPM_output.init_pos = {55,debug_y_offset+10}
RPM_output.alignment = "RightCenter"
RPM_output.stringdefs = {0.75*0.01,0.75*0.75 * 0.01, 0, 0}
RPM_output.formats = {"RPM:%0.1f%%","%s"}
RPM_output.element_params = {"D_RPMG", "D_ENABLE"}
RPM_output.controllers = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}
RPM_output.additive_alpha = true
RPM_output.collimated = true
RPM_output.use_mipfilter = true
RPM_output.isvisible = SHOW_DEBUG
RPM_output.parent_element = "debug_screen"
Add(RPM_output)
