dofile(LockOn_Options.common_script_path.."elements_defs.lua")

old_K = 73.5
new_K = 73.5 --44


texture_size  = 18.03
tex_x 	      = 18.05
tex_y 	      = 0.83
texture_magic = 8.33

texture_stb_size_X = 9.02
texture_stb_size_Y = 9.02

hud_scale    = new_K * texture_size
tex_scale    = texture_magic / (old_K * texture_size)

tex_scale_stb_X = 1.0 / 70.0
tex_scale_stb_Y = 1.0 / 70.1

hud_scalex = new_K * tex_x
tex_scalex = texture_magic / (old_K * tex_x)

hud_scaley = new_K * tex_y
tex_scaley = texture_magic /(old_K * tex_y)

SetScale(MILLYRADIANS)

FontSizeX1	= 0.0058 * (old_K / new_K)
FontSizeY1	= FontSizeX1

FontSizeX2	= FontSizeX1 * 1.254
FontSizeY2	= FontSizeX2


UnderlineDepr = -4.25
OneSymbolSpace = 2.88

five_degrees = math.rad(5) * 1000

TFOV				= 170
ZSL					= 158.64068
GBL_CROSS_pos		= ZSL - 33.7
CCRP_MaxPiperDefl	= 110

HUD_DEFAULT_LEVEL = 9
HUD_NOCLIP_LEVEL = HUD_DEFAULT_LEVEL - 1

use_mipfilter	= true

TestModePosX		= -60.0
TestModeInitPosY	= 140.0
TestModeDeltaPosY	= -9.0
Size1FontSymbWidth	= 4.6222
TestOptionPosX = TestModePosX + Size1FontSymbWidth * 18
TestOptionEngPreflPosX = TestModePosX + Size1FontSymbWidth * 22

--RELEASE_MODES = {"SGL", "PRS", "RIP SGL", "RIP PRS"}
--FUZE_TYPES = {"N/T", "NOSE", "TAIL"}
--IAM_RELEASE_MODES = {"SGL", "PRS"}

function AddHUDTexElement(name, vertices, tex_params, controllers, init_pos, init_rot, parent, level, material)
local 	element				= CreateElement "ceTexPoly"
	element.indices			= default_box_indices
	element.material		= "INDICATION_HUD"
	
	element.name			= name
	element.vertices		= vertices
	element.tex_params 		= tex_params 
	
	if controllers ~= nil then
		element.controllers	= controllers
	end
	
	element.init_pos		= init_pos
	element.init_rot		= init_rot

	element.isdraw			= false	
	if parent ~= nil then
		element.parent_element	= parent
		element.isdraw			= true
	end
	
	element.h_clip_relation	= h_clip_relations.COMPARE
	element.level			= level
	
	element.additive_alpha	= true
	element.collimated		= true

	
	element.use_mipfilter	= use_mipfilter
		
	Add(element)

	return element

end

function AddHUDStandbyTexElement(name, vertices, tex_params, controllers, init_pos, init_rot, parent, level)
local 	element				= CreateElement "ceTexPoly"
	element.indices			= default_box_indices
	element.material		= "INDICATION_HUD_STANDBY"
	
	element.name			= name
	element.vertices		= vertices
	element.tex_params 		= tex_params 
	
	if controllers ~= nil then
		element.controllers	= controllers
	end
	
	element.init_pos		= init_pos
	element.init_rot		= init_rot

	element.isdraw			= false	
	if parent ~= nil then
		element.parent_element	= parent
		element.isdraw			= true
	end
	
	element.h_clip_relation	= h_clip_relations.COMPARE
	element.level			= level
	
	element.additive_alpha	= true
	element.collimated		= true

	
	element.use_mipfilter	= use_mipfilter
		
	Add(element)

	return element

end

local dbg_k = 1.5

predefined_font_0 = {dbg_k* FontSizeY1, dbg_k* FontSizeX1, 0.0, 0.0}
predefined_font_1 = {dbg_k* FontSizeY1, dbg_k* FontSizeX1, 0.0, 0.00105}
predefined_font_2 = {dbg_k* FontSizeY2, dbg_k* FontSizeX2, 0.0, 0.00105}



function AddHUDTextElement(name, controllers, init_pos, parent, level, size)
local txt			= CreateElement "ceStringPoly"
	txt.name		= name
	txt.material	= "font_HUD"
	txt.init_pos	= init_pos
	txt.alignment	= "CenterCenter"
	
	if size ~= nil then
		if size == 2 then
			txt.stringdefs	= predefined_font_2
		else
			txt.stringdefs	= predefined_font_1
		end
	else
		txt.stringdefs	= predefined_font_0
	end
	
	txt.additive_alpha	= true
	txt.collimated		= true
	
	txt.isdraw			= false
	if controllers ~= nil then
		txt.controllers		= controllers
	end
	
	if parent ~= nil then
		txt.parent_element	= parent
		txt.isdraw		= true
	end
	
	txt.h_clip_relation	= h_clip_relations.COMPARE
	txt.level			= level
	txt.use_mipfilter	= use_mipfilter
		
	Add(txt)
	
	return txt
end


function AddHUDTextElement_Pos(name, controllers, init_pos, parent, level, pos, size)
local txt = AddHUDTextElement(name, controllers, init_pos, parent, level, size)
	txt.alignment	= pos
	return txt
end


function AddHUDTextElement_Pos_Val(name, controllers, init_pos, parent, level, pos, value, size)
local txt = AddHUDTextElement_Pos(name, controllers, init_pos, parent, level, pos, size)
	txt.value = value
	return txt
end

function AddHUDTextElement_Pos_Formats(name, controllers, init_pos, parent, level, pos, formats, size)
local txt = AddHUDTextElement_Pos(name, controllers, init_pos, parent, level, pos, size)
	txt.formats = formats
	return txt
end


function Add_invalid_X_symbol(name, controllers)
	return AddHUDTexElement("invalid_X" .. name, 
						{{-5.5, -5.0}, {-5.5, 5.0}, 
						{5.5, 5.0}, {5.5, -5.0}},
						{2.67/texture_size, 15.04/texture_size, tex_scale, tex_scale},
						controllers,
						{0.0, 0.0, 0.0},
						{0.0, 0.0, 0.0},
						name,
						HUD_DEFAULT_LEVEL)
end

function add_box(parent,Hosts, controllers)
	local GH = {}
	
	if Hosts ~= nil then
		i = 0
		for k, v in pairs(Hosts) do
			i = i+1
			GH[i] = v.name
		end
	end
	
	local size				= 1
	local Box  				= CreateElement "ceBoundingTexBox"
	Box.name 				= create_guid_string()
	Box.material	   		= "INDICATION_HUD"
	Box.width				= size
	Box.tex_params			= {{0.26/texture_size, 14.20/texture_size},{5.59/texture_size, 14.20/texture_size}, 
											{tex_scale, tex_scale}}
											
	if controllers ~= nil then
		Box.controllers		= controllers
	end											
	
	Box.parent_element      = parent.name 
	
	Box.geometry_hosts		= GH
	
	Box.additive_alpha	= true
	Box.collimated		= true
	Box.use_mipfilter	= use_mipfilter
	Add(Box)
	
	return Box
end

function addMeshBox(Name, Hosts, pos, controllers)

	local GH = {}
	
	if Hosts ~= nil then
		i = 0
		for k, v in pairs(Hosts) do
			i = i+1
			GH[i] = v.name
		end
	end
	
	local MeshBox  				= CreateElement "ceBoundingMeshBox"
	MeshBox.name 				= Name
	
	for k, v in pairs(GH) do
		MeshBox.name = MeshBox.name .. "_" .. v
	end
	
	MeshBox.primitivetype		= "lines"
	MeshBox.material	   		= "INDICATION_COMMON_RED"
	
	if pos ~= nil then
		MeshBox.init_pos = pos
	end
		
	--local BoxSide = 20
	MeshBox.vertices			= {{-1, -1},
								   { 1, -1},
								   { 1, 1},
								   {-1, 1}}
	
	if controllers ~= nil then
		MeshBox.controllers	= controllers
	end
		
	MeshBox.geometry_hosts		= GH
	Add(MeshBox)
		
	return MeshBox
end

function addHWLine(Name, length, maxlength, controllers, init_pos, init_rot, parent, level)

local	Line				= CreateElement("ceHWLine")
	Line.name				= Name
	Line.vertices			= {{-1, -1.2}, {306, -1.2},
							   {306, 1.2}, {-1, 1.2}}
	Line.maskvertices		= {{0, -1.2}, {306,-1.2},
							   {306, 1.2}, {0, 1.2}}
	Line.indices			= default_box_indices
	Line.maxlength			= maxlength
	Line.length				= length
	Line.material			= "INDICATION_HUD"
	Line.tex_params			= {0.24/texture_size, 17.761/texture_size, tex_scale/2, tex_scale}
	Line.init_pos			= init_pos
	Line.init_rot			= init_rot
	
	if controllers ~= nil then
		Line.controllers    	= controllers
	end
	
	if parent ~= nil then
		Line.parent_element	= parent
		Line.isdraw			= true
	end
	
	Line.h_clip_relation	= h_clip_relations.COMPARE
	Line.level				= level
	
	Line.additive_alpha	= true
	Line.collimated		= true
	Line.use_mipfilter	= use_mipfilter
	
	Add(Line)
	
	return Line
end


function addDashLine(Name, controllers, init_pos, init_rot, maxlength, length, parent, level)
local	Line				= CreateElement("ceHWLine")
	Line.name				= Name
	Line.vertices			= {{-2, -2}, {392, -2},
							   {392, 2}, {-2, 2}}
	Line.maskvertices		= {{0, -2}, {392,-2},
							   {392, 2}, {0, 2}}
	Line.indices			= default_box_indices
	Line.maxlength			= maxlength
	Line.length				= length
	Line.material			= "INDICATION_LINES_HUD"
	Line.tex_params			= {0.18/tex_x, 0.35/tex_y, tex_scalex/2.5, tex_scaley/1.5}
	Line.init_pos			= init_pos
	Line.init_rot			= init_rot
	
	if controllers ~= nil then
		Line.controllers    	= controllers
	end
	
	if parent ~= nil then
		Line.parent_element	= parent
		Line.isdraw			= true
	end
	
	Line.h_clip_relation	= h_clip_relations.COMPARE
	Line.level				= level
	
	Line.use_sigle_line	= true
	Line.additive_alpha	= true
	Line.collimated		= true
	Line.use_mipfilter	= use_mipfilter
	
	Add(Line)

	return Line
end

function OpenOccultWnd(Name, vertices, controllers, parent, level)

	local OccultWnd = CreateElement "ceMeshPoly"
	OccultWnd.name = Name
	OccultWnd.primitivetype = "triangles"
	OccultWnd.vertices = vertices
	OccultWnd.indices  = default_box_indices
	OccultWnd.material = "DBG_RED" --"GREEN"
	OccultWnd.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL
	OccultWnd.level			 = level
	
	if controllers ~= nil then
		OccultWnd.controllers    	= controllers
	end
	
	if parent ~= nil then
		OccultWnd.parent_element	= parent
		OccultWnd.isdraw			= true
	end
	
	OccultWnd.isdraw 	= true
	OccultWnd.isvisible = false
	Add(OccultWnd)

	return OccultWnd
end


function CloseOccultWnd(Name, vertices, controllers, parent, level)

	local OccultWnd = CreateElement "ceMeshPoly"
	OccultWnd.name = Name
	OccultWnd.primitivetype = "triangles"
	OccultWnd.vertices = vertices
	OccultWnd.indices  = default_box_indices
	OccultWnd.material = "DBG_RED" --"GREEN"
	OccultWnd.h_clip_relation = h_clip_relations.DECREASE_IF_LEVEL
	OccultWnd.level			 = level
	
	if controllers ~= nil then
		OccultWnd.controllers    	= controllers
	end
	
	if parent ~= nil then
		OccultWnd.parent_element	= parent
		OccultWnd.isdraw			= true
	end
	
	OccultWnd.isdraw 	= true
	OccultWnd.isvisible = false
	Add(OccultWnd)

	return OccultWnd
end

function addType1SymBorder(Name, Vertices, Parent, Pos, Controllers)
	local Border = {}
	for i = 1, 2 do
		Border[i]                  = CreateElement "ceMeshPoly"
		Border[i].name             = Name .. "_" .. i
		Border[i].primitivetype    = "triangles"
		Border[i].vertices         = Vertices
		Border[i].indices          = default_box_indices
		Border[i].material         = "DBG_RED"
		Border[i].h_clip_relation  = h_clip_relations.INCREASE_IF_LEVEL
		Border[i].level            = HUD_DEFAULT_LEVEL + i - 1
		Border[i].collimated       = true
		
		if i == 1 then
			Border[i].parent_element = Parent
			Border[i].init_pos       = Pos
			Border[i].controllers    = Controllers
		else
			Border[i].parent_element = Border[1].name
			Border[i].isdraw		 = true
		end
		
		Border[i].isvisible        = false
	    Add(Border[i])
	end
	
	return Border[2]
end

function CreateDummy()
	local  el = CreateElement "ceSimple"
		   el.collimated = true
	return el
end