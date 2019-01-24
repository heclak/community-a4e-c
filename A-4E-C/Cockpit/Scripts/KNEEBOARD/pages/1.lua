dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../Textures/kneeboard_weapon_bg.png")

local gettext = require("i_18n")
_ = gettext.translate

function AddElement(object)
    object.use_mipfilter = true
    Add(object)
end

-- fonts
FontSizeX1	= 0.0075
FontSizeY1	= FontSizeX1

predefined_font_title	= {FontSizeY1,			FontSizeX1,			0.0,		0.0}
predefined_font_header	= {FontSizeY1 * 0.9,	FontSizeX1 * 0.9,	0.0,	    0.0}
predefined_font_item	= {FontSizeY1 * 0.75,	FontSizeX1 * 0.75,	-0.0009,	0.0}


-- lines
local FirstLineY	= 1.3
local LineSizeY		= 0.095

local function getLineY(line)
	return FirstLineY - LineSizeY * (line)
end

local ValuePosX = -0.3
local UnitsPosX = -0.27
local HintsPosX = 0.8

-----------------------------------------------------------------
--                         WEAPONS CONFIG
-----------------------------------------------------------------

txt_BoardTitle				= CreateElement "ceStringPoly"
txt_BoardTitle.name			= "txt_BoardTitle"
txt_BoardTitle.material		= "font_kneeboard"
txt_BoardTitle.init_pos		= {0.0, getLineY(0), 0}
txt_BoardTitle.value		= "WEAPONS"
txt_BoardTitle.alignment	= "CenterBottom"
txt_BoardTitle.stringdefs	= predefined_font_title
AddElement(txt_BoardTitle)

-----------------------------------------------------------------
--                         WEAPONS CONFIG
-----------------------------------------------------------------

txt_BoardTitle				= CreateElement "ceStringPoly"
txt_BoardTitle.name			= "txt_BoardTitle"
txt_BoardTitle.material		= "font_kneeboard"
txt_BoardTitle.init_pos		= {0.0, getLineY(2), 0}
txt_BoardTitle.value		= "CBU CONFIG"
txt_BoardTitle.alignment	= "CenterBottom"
txt_BoardTitle.stringdefs	= predefined_font_header
AddElement(txt_BoardTitle)

-----------------------------------------------------------------
--                         CBU-1/A
-----------------------------------------------------------------

CBU1A_LineY = getLineY(3)

Name_CBU1A				    = CreateElement "ceStringPoly"
Name_CBU1A.name			    = "Name_CBU1A"
Name_CBU1A.material		    = "font_kneeboard"
Name_CBU1A.init_pos		    = {-0.5,  CBU1A_LineY, 0}
Name_CBU1A.value		    = _("CBU-1/A")
Name_CBU1A.alignment	    = "RightBottom"
Name_CBU1A.stringdefs	    = predefined_font_item
AddElement(Name_CBU1A)

Key_CBU1A				    = CreateElement "ceStringPoly"
Key_CBU1A.name			    = "Key_CBU1A"
Key_CBU1A.material		    = "font_kneeboard"
Key_CBU1A.init_pos		    = {ValuePosX,  CBU1A_LineY, 0}
Key_CBU1A.formats		    = {"%.0f","%s"}
Key_CBU1A.element_params    = {"CBU1A_QTY"}
Key_CBU1A.controllers       = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_CBU1A.alignment		    = "RightBottom"
Key_CBU1A.stringdefs		= predefined_font_item
AddElement(Key_CBU1A)


Units_CBU1A                 = CreateElement "ceStringPoly"
Units_CBU1A.name			= "Units_CBU1A"
Units_CBU1A.material		= "font_kneeboard"
Units_CBU1A.init_pos		= {UnitsPosX,  CBU1A_LineY, 0}
Units_CBU1A.value		    = _("TUBES PER PULSE")
Units_CBU1A.alignment	    = "LeftBottom"
Units_CBU1A.stringdefs	    = predefined_font_item
AddElement(Units_CBU1A)

-- Note: The CBU-1/A only has one option of releasing 2 tubes per weapon pulse.
-- Hints_CBU1A				= CreateElement "ceStringPoly"
-- Hints_CBU1A.name			= "Hints_CBU1A"
-- Hints_CBU1A.material		= "font_kneeboard_hint"
-- Hints_CBU1A.init_pos		= {HintsPosX,  CBU1A_LineY, 0}
-- Hints_CBU1A.value		= _("RS+RA+[1]")
-- Hints_CBU1A.alignment	= "RightBottom"
-- Hints_CBU1A.stringdefs	= predefined_font_item
-- AddElement(Hints_CBU1A)

-----------------------------------------------------------------
--                         CBU-2/A
-----------------------------------------------------------------

CBU2A_LineY = getLineY(4)

Name_CBU2A				    = CreateElement "ceStringPoly"
Name_CBU2A.name			    = "Name_CBU2A"
Name_CBU2A.material		    = "font_kneeboard"
Name_CBU2A.init_pos		    = {-0.5,  CBU2A_LineY, 0}
Name_CBU2A.value			= _("CBU-2/A")
Name_CBU2A.alignment		= "RightBottom"
Name_CBU2A.stringdefs		= predefined_font_item
AddElement(Name_CBU2A)

Key_CBU2A				    = CreateElement "ceStringPoly"
Key_CBU2A.name			    = "Key_CBU2A"
Key_CBU2A.material		    = "font_kneeboard"
Key_CBU2A.init_pos		    = {ValuePosX,  CBU2A_LineY, 0}
Key_CBU2A.formats			= {"%.0f","%s"}
Key_CBU2A.element_params    = {"CBU2A_QTY"}
Key_CBU2A.controllers       = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_CBU2A.alignment		    = "RightBottom"
Key_CBU2A.stringdefs		= predefined_font_item
AddElement(Key_CBU2A)

Units_CBU2A                 = CreateElement "ceStringPoly"
Units_CBU2A.name			= "Units_CBU2A"
Units_CBU2A.material		= "font_kneeboard"
Units_CBU2A.init_pos		= {UnitsPosX,  CBU2A_LineY, 0}
Units_CBU2A.value		    = _("TUBES PER PULSE")
Units_CBU2A.alignment	    = "LeftBottom"
Units_CBU2A.stringdefs	    = predefined_font_item
AddElement(Units_CBU2A)

Hints_CBU2A				    = CreateElement "ceStringPoly"
Hints_CBU2A.name			= "Hints_CBU2A"
Hints_CBU2A.material		= "font_kneeboard_hint"
Hints_CBU2A.init_pos		= {HintsPosX,  CBU2A_LineY, 0}
Hints_CBU2A.value			= _("RS+RA+[2]")
Hints_CBU2A.alignment		= "RightBottom"
Hints_CBU2A.stringdefs		= predefined_font_item
AddElement(Hints_CBU2A)



-----------------------------------------------------------------
--                         CBU-2B/A
-----------------------------------------------------------------

CBU2BA_LineY = getLineY(5)

Name_CBU2BA				    = CreateElement "ceStringPoly"
Name_CBU2BA.name			= "Name_CBU2BA"
Name_CBU2BA.material		= "font_kneeboard"
Name_CBU2BA.init_pos		= {-0.5,  CBU2BA_LineY, 0}
Name_CBU2BA.value			= _("CBU-2B/A")
Name_CBU2BA.alignment		= "RightBottom"
Name_CBU2BA.stringdefs		= predefined_font_item
AddElement(Name_CBU2BA)

Key_CBU2BA				    = CreateElement "ceStringPoly"
Key_CBU2BA.name			    = "Key_CBU2BA"
Key_CBU2BA.material		    = "font_kneeboard"
Key_CBU2BA.init_pos		    = {ValuePosX,  CBU2BA_LineY, 0}
Key_CBU2BA.formats			= {"%.0f","%s"}
Key_CBU2BA.element_params   = {"CBU2BA_QTY"}
Key_CBU2BA.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_CBU2BA.alignment		= "RightBottom"
Key_CBU2BA.stringdefs		= predefined_font_item
AddElement(Key_CBU2BA)

Units_CBU2BA                 = CreateElement "ceStringPoly"
Units_CBU2BA.name			= "Units_CBU2BA"
Units_CBU2BA.material		= "font_kneeboard"
Units_CBU2BA.init_pos		= {UnitsPosX,  CBU2BA_LineY, 0}
Units_CBU2BA.value		    = _("TUBES PER PULSE")
Units_CBU2BA.alignment	    = "LeftBottom"
Units_CBU2BA.stringdefs	    = predefined_font_item
AddElement(Units_CBU2BA)

Hints_CBU2BA				= CreateElement "ceStringPoly"
Hints_CBU2BA.name			= "Hints_CBU2BA"
Hints_CBU2BA.material		= "font_kneeboard_hint"
Hints_CBU2BA.init_pos		= {HintsPosX,  CBU2BA_LineY, 0}
Hints_CBU2BA.value			= _("RS+RA+[3]")
Hints_CBU2BA.alignment		= "RightBottom"
Hints_CBU2BA.stringdefs		= predefined_font_item
AddElement(Hints_CBU2BA)
