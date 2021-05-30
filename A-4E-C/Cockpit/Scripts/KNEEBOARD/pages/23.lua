dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- WEAPON / CBU INFO

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../Textures/a4e_cockpit_kneeboard_weapons.png")

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

local NamePosX = -0.45
local ValuePosX = -0.27
local UnitsPosX = -0.24
local HintsPosX = 0.8

local CMSValuePosX = -0.1
local CMSUnitsPosX = -0.05
local CMSHintsPosX = 0.8

-----------------------------------------------------------------
--                         WEAPONS CONFIG
-----------------------------------------------------------------

txt_BoardTitle				= CreateElement "ceStringPoly"
txt_BoardTitle.name			= "txt_BoardTitle"
txt_BoardTitle.material		= "font_kneeboard_white"
txt_BoardTitle.init_pos		= {0.0, getLineY(0), 0}
txt_BoardTitle.value		= "WEAPONS"
txt_BoardTitle.alignment	= "CenterBottom"
txt_BoardTitle.stringdefs	= predefined_font_title
AddElement(txt_BoardTitle)

-----------------------------------------------------------------
--                         WEAPONS CONFIG
-----------------------------------------------------------------

txt_WeaponsTitle				= CreateElement "ceStringPoly"
txt_WeaponsTitle.name			= "txt_WeaponsTitle"
txt_WeaponsTitle.material		= "font_kneeboard"
txt_WeaponsTitle.init_pos		= {0.0, getLineY(2), 0}
txt_WeaponsTitle.value		= "CBU CONFIG"
txt_WeaponsTitle.alignment	= "CenterBottom"
txt_WeaponsTitle.stringdefs	= predefined_font_header
AddElement(txt_WeaponsTitle)

-----------------------------------------------------------------
--                         CBU-1/A
-----------------------------------------------------------------

CBU1A_LineY = getLineY(3)

Name_CBU1A				    = CreateElement "ceStringPoly"
Name_CBU1A.name			    = "Name_CBU1A"
Name_CBU1A.material		    = "font_kneeboard"
Name_CBU1A.init_pos		    = {NamePosX,  CBU1A_LineY, 0}
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
Name_CBU2A.init_pos		    = {NamePosX,  CBU2A_LineY, 0}
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
Name_CBU2BA.init_pos		= {NamePosX,  CBU2BA_LineY, 0}
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

-----------------------------------------------------------------
--                COUNTERMEASURES CONFIG
-----------------------------------------------------------------

txt_CountermeasuresTitle				= CreateElement "ceStringPoly"
txt_CountermeasuresTitle.name			= "txt_CountermeasuresTitle"
txt_CountermeasuresTitle.material		= "font_kneeboard"
txt_CountermeasuresTitle.init_pos		= {0.0, getLineY(7), 0}
txt_CountermeasuresTitle.value		    = "COUNTERMEASURES"
txt_CountermeasuresTitle.alignment	    = "CenterBottom"
txt_CountermeasuresTitle.stringdefs	    = predefined_font_header
AddElement(txt_CountermeasuresTitle)


-----------------------------------------------------------------
--                         BURSTS
-----------------------------------------------------------------

BURSTS_LineY = getLineY(8)

Name_BURSTS				    = CreateElement "ceStringPoly"
Name_BURSTS.name			= "Name_BURSTS"
Name_BURSTS.material		= "font_kneeboard"
Name_BURSTS.init_pos		= {NamePosX,  BURSTS_LineY, 0}
Name_BURSTS.value			= _("BURST")
Name_BURSTS.alignment		= "RightBottom"
Name_BURSTS.stringdefs		= predefined_font_item
AddElement(Name_BURSTS)

Key_BURSTS				    = CreateElement "ceStringPoly"
Key_BURSTS.name			    = "Key_BURSTS"
Key_BURSTS.material		    = "font_kneeboard"
Key_BURSTS.init_pos		    = {CMSValuePosX,  BURSTS_LineY, 0}
Key_BURSTS.formats			= {"%.0f","%s"}
Key_BURSTS.element_params   = {"CMS_BURSTS_PARAM"}
Key_BURSTS.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_BURSTS.alignment		= "RightBottom"
Key_BURSTS.stringdefs		= predefined_font_item
AddElement(Key_BURSTS)

Units_BURSTS                 = CreateElement "ceStringPoly"
Units_BURSTS.name			= "Units_BURSTS"
Units_BURSTS.material		= "font_kneeboard"
Units_BURSTS.init_pos		= {CMSUnitsPosX,  BURSTS_LineY, 0}
Units_BURSTS.value		    = _("BURSTS")
Units_BURSTS.alignment	    = "LeftBottom"
Units_BURSTS.stringdefs	    = predefined_font_item
AddElement(Units_BURSTS)

Hints_BURSTS				= CreateElement "ceStringPoly"
Hints_BURSTS.name			= "Hints_BURSTS"
Hints_BURSTS.material		= "font_kneeboard_hint"
Hints_BURSTS.init_pos		= {CMSHintsPosX,  BURSTS_LineY, 0}
Hints_BURSTS.value			= _("RS+RA+[4]")
Hints_BURSTS.alignment		= "RightBottom"
Hints_BURSTS.stringdefs		= predefined_font_item
AddElement(Hints_BURSTS)


-----------------------------------------------------------------
--                        BURST INTERVAL
-----------------------------------------------------------------

BURST_INTERVAL_LineY = getLineY(9)

Name_BURST_INTERVAL				    = CreateElement "ceStringPoly"
Name_BURST_INTERVAL.name			= "Name_BURST_INTERVAL"
Name_BURST_INTERVAL.material		= "font_kneeboard"
Name_BURST_INTERVAL.init_pos		= {NamePosX,  BURST_INTERVAL_LineY, 0}
Name_BURST_INTERVAL.value			= _("BURST INTVL")
Name_BURST_INTERVAL.alignment		= "RightBottom"
Name_BURST_INTERVAL.stringdefs		= predefined_font_item
AddElement(Name_BURST_INTERVAL)

Key_BURST_INTERVAL				    = CreateElement "ceStringPoly"
Key_BURST_INTERVAL.name			    = "Key_BURST_INTERVAL"
Key_BURST_INTERVAL.material		    = "font_kneeboard"
Key_BURST_INTERVAL.init_pos		    = {CMSValuePosX,  BURST_INTERVAL_LineY, 0}
Key_BURST_INTERVAL.formats			= {"%.1f","%s"}
Key_BURST_INTERVAL.element_params   = {"CMS_BURST_INTERVAL_PARAM"}
Key_BURST_INTERVAL.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_BURST_INTERVAL.alignment		= "RightBottom"
Key_BURST_INTERVAL.stringdefs		= predefined_font_item
AddElement(Key_BURST_INTERVAL)

Units_BURST_INTERVAL                 = CreateElement "ceStringPoly"
Units_BURST_INTERVAL.name			= "Units_BURST_INTERVAL"
Units_BURST_INTERVAL.material		= "font_kneeboard"
Units_BURST_INTERVAL.init_pos		= {CMSUnitsPosX,  BURST_INTERVAL_LineY, 0}
Units_BURST_INTERVAL.value		    = _("SECONDS")
Units_BURST_INTERVAL.alignment	    = "LeftBottom"
Units_BURST_INTERVAL.stringdefs	    = predefined_font_item
AddElement(Units_BURST_INTERVAL)

Hints_BURST_INTERVAL				= CreateElement "ceStringPoly"
Hints_BURST_INTERVAL.name			= "Hints_BURST_INTERVAL"
Hints_BURST_INTERVAL.material		= "font_kneeboard_hint"
Hints_BURST_INTERVAL.init_pos		= {CMSHintsPosX,  BURST_INTERVAL_LineY, 0}
Hints_BURST_INTERVAL.value			= _("RS+RA+[5]")
Hints_BURST_INTERVAL.alignment		= "RightBottom"
Hints_BURST_INTERVAL.stringdefs		= predefined_font_item
AddElement(Hints_BURST_INTERVAL)


-----------------------------------------------------------------
--                         SALVOS
-----------------------------------------------------------------

SALVOS_LineY = getLineY(10)

Name_SALVOS				    = CreateElement "ceStringPoly"
Name_SALVOS.name			= "Name_SALVOS"
Name_SALVOS.material		= "font_kneeboard"
Name_SALVOS.init_pos		= {NamePosX,  SALVOS_LineY, 0}
Name_SALVOS.value			= _("SALVOS")
Name_SALVOS.alignment		= "RightBottom"
Name_SALVOS.stringdefs		= predefined_font_item
AddElement(Name_SALVOS)

Key_SALVOS				    = CreateElement "ceStringPoly"
Key_SALVOS.name			    = "Key_SALVOS"
Key_SALVOS.material		    = "font_kneeboard"
Key_SALVOS.init_pos		    = {CMSValuePosX,  SALVOS_LineY, 0}
Key_SALVOS.formats			= {"%.0f","%s"}
Key_SALVOS.element_params   = {"CMS_SALVOS_PARAM"}
Key_SALVOS.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_SALVOS.alignment		= "RightBottom"
Key_SALVOS.stringdefs		= predefined_font_item
AddElement(Key_SALVOS)

Units_SALVOS                 = CreateElement "ceStringPoly"
Units_SALVOS.name			= "Units_SALVOS"
Units_SALVOS.material		= "font_kneeboard"
Units_SALVOS.init_pos		= {CMSUnitsPosX,  SALVOS_LineY, 0}
Units_SALVOS.value		    = _("SALVOS")
Units_SALVOS.alignment	    = "LeftBottom"
Units_SALVOS.stringdefs	    = predefined_font_item
AddElement(Units_SALVOS)

Hints_SALVOS				= CreateElement "ceStringPoly"
Hints_SALVOS.name			= "Hints_SALVOS"
Hints_SALVOS.material		= "font_kneeboard_hint"
Hints_SALVOS.init_pos		= {CMSHintsPosX,  SALVOS_LineY, 0}
Hints_SALVOS.value			= _("RS+RA+[6]")
Hints_SALVOS.alignment		= "RightBottom"
Hints_SALVOS.stringdefs		= predefined_font_item
AddElement(Hints_SALVOS)



-----------------------------------------------------------------
--                         SALVO INTERVAL
-----------------------------------------------------------------

SALVO_INTERVAL_LineY = getLineY(11)

Name_SALVO_INTERVAL				    = CreateElement "ceStringPoly"
Name_SALVO_INTERVAL.name			= "Name_SALVO_INTERVAL"
Name_SALVO_INTERVAL.material		= "font_kneeboard"
Name_SALVO_INTERVAL.init_pos		= {NamePosX,  SALVO_INTERVAL_LineY, 0}
Name_SALVO_INTERVAL.value			= _("SALVO INTVL")
Name_SALVO_INTERVAL.alignment		= "RightBottom"
Name_SALVO_INTERVAL.stringdefs		= predefined_font_item
AddElement(Name_SALVO_INTERVAL)

Key_SALVO_INTERVAL				    = CreateElement "ceStringPoly"
Key_SALVO_INTERVAL.name			    = "Key_SALVO_INTERVAL"
Key_SALVO_INTERVAL.material		    = "font_kneeboard"
Key_SALVO_INTERVAL.init_pos		    = {CMSValuePosX,  SALVO_INTERVAL_LineY, 0}
Key_SALVO_INTERVAL.formats			= {"%.0f","%s"}
Key_SALVO_INTERVAL.element_params   = {"CMS_SALVO_INTERVAL_PARAM"}
Key_SALVO_INTERVAL.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_SALVO_INTERVAL.alignment		= "RightBottom"
Key_SALVO_INTERVAL.stringdefs		= predefined_font_item
AddElement(Key_SALVO_INTERVAL)

Units_SALVO_INTERVAL                 = CreateElement "ceStringPoly"
Units_SALVO_INTERVAL.name			= "Units_SALVO_INTERVAL"
Units_SALVO_INTERVAL.material		= "font_kneeboard"
Units_SALVO_INTERVAL.init_pos		= {CMSUnitsPosX,  SALVO_INTERVAL_LineY, 0}
Units_SALVO_INTERVAL.value		    = _("SECONDS")
Units_SALVO_INTERVAL.alignment	    = "LeftBottom"
Units_SALVO_INTERVAL.stringdefs	    = predefined_font_item
AddElement(Units_SALVO_INTERVAL)

Hints_SALVO_INTERVAL				= CreateElement "ceStringPoly"
Hints_SALVO_INTERVAL.name			= "Hints_SALVO_INTERVAL"
Hints_SALVO_INTERVAL.material		= "font_kneeboard_hint"
Hints_SALVO_INTERVAL.init_pos		= {CMSHintsPosX,  SALVO_INTERVAL_LineY, 0}
Hints_SALVO_INTERVAL.value			= _("RS+RA+[7]")
Hints_SALVO_INTERVAL.alignment		= "RightBottom"
Hints_SALVO_INTERVAL.stringdefs		= predefined_font_item
AddElement(Hints_SALVO_INTERVAL)