dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_15.dds")

local gettext = require("i_18n")
_ = gettext.translate

function AddElement(object)
 object.use_mipfilter = true
 Add(object)
end

-- fonts
FontSizeX1	= 0.0065
FontSizeY1	= FontSizeX1

predefined_font_title	= {FontSizeY1 * 0.85,	FontSizeX1 * 0.85,	-0.0009,	0.0}
predefined_font_header	= {FontSizeY1 * 0.75,	FontSizeX1 * 0.75,	-0.0009,	0.0}
predefined_font_item	= {FontSizeY1 * 0.675,	FontSizeX1 * 0.675,	-0.0009,	0.0}

--define top of page and line height
local FirstLineY	= 1.4
local LineSizeY		= 0.1

--define basic page margins to left and right
local margin_xl = -0.9
local margin_xr = 0.735

--define the first line to appear
local function getLineY(line)
    return FirstLineY - LineSizeY * (line)
end

--define blank lines at top of page for station diagram
--define each section by line count offset from prior section
--to reorder these sections, end each with a value of 1.5 higher than the prior section's total number of lines.
local offset_line_fuel          = 5
local offset_line_loadout       = offset_line_fuel + 3.5
local offset_line_programmer    = offset_line_loadout + 6.5
local offset_line_cbus          = offset_line_programmer + 4
local offset_line_cms           = offset_line_cbus + 4.5

--define columned placements
local offset_indent_line        = margin_xl + 0.025
local offset_fuel_quantity      = offset_indent_line + 0.275
local offset_fuel_lbs           = offset_fuel_quantity + 0.04
local offset_loadout_name       = offset_indent_line + 0.075
local offset_cbu_quantity       = offset_indent_line + 0.55
local offset_cbu_method         = offset_cbu_quantity + 0.1
local offset_cms_quantity       = offset_cbu_quantity
local offset_cms_method         = offset_cbu_method

------------
--  FUEL  --
------------
--fuel title
--[[
txt_HeaderFuel = CreateElement "ceStringPoly"
txt_HeaderFuel.name = "txt_HeaderFuel"
txt_HeaderFuel.material = "font_kneeboard"
txt_HeaderFuel.init_pos = {margin_xl, getLineY(offset_line_fuel), 0}
txt_HeaderFuel.value = _("FUEL STORES")
txt_HeaderFuel.alignment = "LeftBottom"
txt_HeaderFuel.stringdefs = predefined_font_title
AddElement(txt_HeaderFuel)
]]

--internal fuel
txt_FuelLabelInternal                   = CreateElement "ceStringPoly"
txt_FuelLabelInternal.name              = "txt_FuelLabelInternal"
txt_FuelLabelInternal.material          = "font_kneeboard"
txt_FuelLabelInternal.init_pos          = {offset_indent_line, getLineY(offset_line_fuel + 1), 0}
txt_FuelLabelInternal.value             = _("INT:")
txt_FuelLabelInternal.alignment         = "LeftBottom"
txt_FuelLabelInternal.stringdefs        = predefined_font_item
AddElement(txt_FuelLabelInternal)

txt_FuelWeightInternal				    = CreateElement "ceStringPoly"
txt_FuelWeightInternal.name			    = "txt_FuelWeightInternal"
txt_FuelWeightInternal.material		    = "font_kneeboard"
txt_FuelWeightInternal.init_pos		    = {offset_fuel_quantity,  getLineY(offset_line_fuel + 1), 0}
txt_FuelWeightInternal.formats		    = {"%.0f"}
txt_FuelWeightInternal.element_params   = {"kneeboard_fuel_int"}
txt_FuelWeightInternal.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
txt_FuelWeightInternal.alignment		= "RightBottom"
txt_FuelWeightInternal.stringdefs		= predefined_font_header
AddElement(txt_FuelWeightInternal)

txt_FuelLbsInternal                   = CreateElement "ceStringPoly"
txt_FuelLbsInternal.name              = "txt_FuelLbsInternal"
txt_FuelLbsInternal.material          = "font_kneeboard"
txt_FuelLbsInternal.init_pos          = {offset_fuel_lbs, getLineY(offset_line_fuel + 1), 0}
txt_FuelLbsInternal.value             = _("LBS.")
txt_FuelLbsInternal.alignment         = "LeftBottom"
txt_FuelLbsInternal.stringdefs        = predefined_font_item
AddElement(txt_FuelLbsInternal)

--external fuel
txt_FuelLabelExternal                   = CreateElement "ceStringPoly"
txt_FuelLabelExternal.name              = "txt_FuelLabelExternal"
txt_FuelLabelExternal.material          = "font_kneeboard"
txt_FuelLabelExternal.init_pos          = {offset_indent_line, getLineY(offset_line_fuel + 2), 0}
txt_FuelLabelExternal.value             = _("EXT:")
txt_FuelLabelExternal.alignment         = "LeftBottom"
txt_FuelLabelExternal.stringdefs        = predefined_font_item
AddElement(txt_FuelLabelExternal)

txt_FuelWeightExternal				    = CreateElement "ceStringPoly"
txt_FuelWeightExternal.name			    = "txt_FuelWeightExternal"
txt_FuelWeightExternal.material		    = "font_kneeboard"
txt_FuelWeightExternal.init_pos		    = {offset_fuel_quantity,  getLineY(offset_line_fuel + 2), 0}
txt_FuelWeightExternal.formats		    = {"%.0f"}
txt_FuelWeightExternal.element_params   = {"kneeboard_fuel_ext"}
txt_FuelWeightExternal.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
txt_FuelWeightExternal.alignment		= "RightBottom"
txt_FuelWeightExternal.stringdefs		= predefined_font_header
AddElement(txt_FuelWeightExternal)

txt_FuelLbsExternal                     = CreateElement "ceStringPoly"
txt_FuelLbsExternal.name                = "txt_FuelLbsExternal"
txt_FuelLbsExternal.material            = "font_kneeboard"
txt_FuelLbsExternal.init_pos            = {offset_fuel_lbs, getLineY(offset_line_fuel + 2), 0}
txt_FuelLbsExternal.value               = _("LBS.")
txt_FuelLbsExternal.alignment           = "LeftBottom"
txt_FuelLbsExternal.stringdefs          = predefined_font_item
AddElement(txt_FuelLbsExternal)

------------------------
--  STATION LOADOUTS  --
------------------------
--station loadout title
--[[
txt_HeaderLoadout                          = CreateElement "ceStringPoly"
txt_HeaderLoadout.name                     = "txt_HeaderLoadout"
txt_HeaderLoadout.material                 = "font_kneeboard"
txt_HeaderLoadout.init_pos                 = {margin_xl, getLineY(offset_line_loadout), 0}
txt_HeaderLoadout.value                    = _("STATION LOADOUTS")
txt_HeaderLoadout.alignment                = "LeftBottom"
txt_HeaderLoadout.stringdefs               = predefined_font_title
AddElement(txt_HeaderLoadout)
]]

txt_HeaderLoadout_Quantity = CreateElement "ceStringPoly"
txt_HeaderLoadout_Quantity.name = "txt_HeaderLoadout_Quantity"
txt_HeaderLoadout_Quantity.material = "font_kneeboard"
txt_HeaderLoadout_Quantity.init_pos = {margin_xr, getLineY(offset_line_loadout), 0}
txt_HeaderLoadout_Quantity.value = _("QTY")
txt_HeaderLoadout_Quantity.alignment = "RightBottom"
txt_HeaderLoadout_Quantity.stringdefs = predefined_font_header
AddElement(txt_HeaderLoadout_Quantity)

--station loadout items
for station = 1,5 do
    local item_pos_y = getLineY(offset_line_loadout + station)

    EnumeratedStation                   = CreateElement "ceStringPoly"
    EnumeratedStation.name              = "EnumeratedStation"..station
    EnumeratedStation.material          = "font_kneeboard_hint"
    EnumeratedStation.init_pos          = {offset_indent_line, item_pos_y, 0}
    EnumeratedStation.alignment         = "LeftBottom"
    EnumeratedStation.stringdefs        = predefined_font_header
    EnumeratedStation.value             = tostring(station).."."
    AddElement(EnumeratedStation)

    LoudoutByStation                    = CreateElement "ceStringPoly"
    LoudoutByStation.name               = "LoudoutByStation"..station
    LoudoutByStation.material           = "font_kneeboard"
    LoudoutByStation.init_pos           = {offset_loadout_name, item_pos_y, 0}
    LoudoutByStation.alignment          = "LeftBottom"
    LoudoutByStation.stringdefs         = predefined_font_item
    LoudoutByStation.formats            = {"%s"}
    LoudoutByStation.element_params     = {"loadout_station"..station}
    LoudoutByStation.controllers        = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
    AddElement(LoudoutByStation)

    LoadoutQuantity                     = CreateElement "ceStringPoly"
    LoadoutQuantity.name                = "LoadoutQuantity"..station
    LoadoutQuantity.material            = "font_kneeboard"
    LoadoutQuantity.init_pos            = {margin_xr, item_pos_y, 0}
    LoadoutQuantity.alignment           = "RightBottom"
    LoadoutQuantity.stringdefs          = predefined_font_item
    LoadoutQuantity.formats             = {"%.0f"}
    LoadoutQuantity.element_params      = {"loadout_quantity"..station}
    LoadoutQuantity.controllers         = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
    AddElement(LoadoutQuantity)
end

--------------------------
-- AN/ALE-29A PROGRAMMER 
--------------------------
--title
--[[
txt_BoardTitle				= CreateElement "ceStringPoly"
txt_BoardTitle.name			= "txt_BoardTitle"
txt_BoardTitle.material		= "font_kneeboard"
txt_BoardTitle.init_pos		= {margin_xl, getLineY(offset_line_programmer), 0}
txt_BoardTitle.value		= "AN/ALE-29A PROGRAMMER"
txt_BoardTitle.alignment	= "LeftBottom"
txt_BoardTitle.stringdefs	= predefined_font_title
AddElement(txt_BoardTitle)
]]

----------------------
-- CBU CONFIGURATION
----------------------
txt_WeaponsTitle			= CreateElement "ceStringPoly"
txt_WeaponsTitle.name		= "txt_WeaponsTitle"
txt_WeaponsTitle.material	= "font_kneeboard"
txt_WeaponsTitle.init_pos	= {margin_xl, getLineY(offset_line_cbus), 0}
txt_WeaponsTitle.value		= "CBU CONFIGURATION"
txt_WeaponsTitle.alignment	= "LeftBottom"
txt_WeaponsTitle.stringdefs	= predefined_font_header
AddElement(txt_WeaponsTitle)

--CBU-1/A
CBU1A_LineY = getLineY(offset_line_cbus + 1)

Name_CBU1A				    = CreateElement "ceStringPoly"
Name_CBU1A.name			    = "Name_CBU1A"
Name_CBU1A.material		    = "font_kneeboard"
Name_CBU1A.init_pos		    = {offset_indent_line,  CBU1A_LineY, 0}
Name_CBU1A.value		    = _("CBU-1/A")
Name_CBU1A.alignment	    = "LeftBottom"
Name_CBU1A.stringdefs	    = predefined_font_item
AddElement(Name_CBU1A)

Key_CBU1A				    = CreateElement "ceStringPoly"
Key_CBU1A.name			    = "Key_CBU1A"
Key_CBU1A.material		    = "font_kneeboard"
Key_CBU1A.init_pos		    = {offset_cbu_quantity,  CBU1A_LineY, 0}
Key_CBU1A.formats		    = {"%.0f","%s"}
Key_CBU1A.element_params    = {"CBU1A_QTY"}
Key_CBU1A.controllers       = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_CBU1A.alignment		    = "RightBottom"
Key_CBU1A.stringdefs		= predefined_font_header
AddElement(Key_CBU1A)


Units_CBU1A                 = CreateElement "ceStringPoly"
Units_CBU1A.name			= "Units_CBU1A"
Units_CBU1A.material		= "font_kneeboard"
Units_CBU1A.init_pos		= {offset_cbu_method,  CBU1A_LineY, 0}
Units_CBU1A.value		    = _("TUBES PER PULSE")
Units_CBU1A.alignment	    = "LeftBottom"
Units_CBU1A.stringdefs	    = predefined_font_item
AddElement(Units_CBU1A)

-- Note: The CBU-1/A only has one option of releasing 2 tubes per weapon pulse.
-- Hints_CBU1A				= CreateElement "ceStringPoly"
-- Hints_CBU1A.name			= "Hints_CBU1A"
-- Hints_CBU1A.material		= "font_kneeboard_hint"
-- Hints_CBU1A.init_pos		= {margin_xr,  CBU1A_LineY, 0}
-- Hints_CBU1A.value		= _("RS+RA+[1]")
-- Hints_CBU1A.alignment	= "RightBottom"
-- Hints_CBU1A.stringdefs	= predefined_font_item
-- AddElement(Hints_CBU1A)

--CBU-2/A
CBU2A_LineY = getLineY(offset_line_cbus + 2)

Name_CBU2A				    = CreateElement "ceStringPoly"
Name_CBU2A.name			    = "Name_CBU2A"
Name_CBU2A.material		    = "font_kneeboard"
Name_CBU2A.init_pos		    = {offset_indent_line,  CBU2A_LineY, 0}
Name_CBU2A.value			= _("CBU-2/A")
Name_CBU2A.alignment		= "LeftBottom"
Name_CBU2A.stringdefs		= predefined_font_item
AddElement(Name_CBU2A)

Key_CBU2A				    = CreateElement "ceStringPoly"
Key_CBU2A.name			    = "Key_CBU2A"
Key_CBU2A.material		    = "font_kneeboard"
Key_CBU2A.init_pos		    = {offset_cbu_quantity,  CBU2A_LineY, 0}
Key_CBU2A.formats			= {"%.0f","%s"}
Key_CBU2A.element_params    = {"CBU2A_QTY"}
Key_CBU2A.controllers       = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_CBU2A.alignment		    = "RightBottom"
Key_CBU2A.stringdefs		= predefined_font_header
AddElement(Key_CBU2A)

Units_CBU2A                 = CreateElement "ceStringPoly"
Units_CBU2A.name			= "Units_CBU2A"
Units_CBU2A.material		= "font_kneeboard"
Units_CBU2A.init_pos		= {offset_cbu_method,  CBU2A_LineY, 0}
Units_CBU2A.value		    = _("TUBES PER PULSE")
Units_CBU2A.alignment	    = "LeftBottom"
Units_CBU2A.stringdefs	    = predefined_font_item
AddElement(Units_CBU2A)

Hints_CBU2A				    = CreateElement "ceStringPoly"
Hints_CBU2A.name			= "Hints_CBU2A"
Hints_CBU2A.material		= "font_kneeboard_hint"
Hints_CBU2A.init_pos		= {margin_xr,  CBU2A_LineY, 0}
Hints_CBU2A.value			= _("RSHIFT+RALT+2")
Hints_CBU2A.alignment		= "RightBottom"
Hints_CBU2A.stringdefs		= predefined_font_item
AddElement(Hints_CBU2A)

--CBU-2B/A
CBU2BA_LineY = getLineY(offset_line_cbus + 3)

Name_CBU2BA				    = CreateElement "ceStringPoly"
Name_CBU2BA.name			= "Name_CBU2BA"
Name_CBU2BA.material		= "font_kneeboard"
Name_CBU2BA.init_pos		= {offset_indent_line,  CBU2BA_LineY, 0}
Name_CBU2BA.value			= _("CBU-2B/A")
Name_CBU2BA.alignment		= "LeftBottom"
Name_CBU2BA.stringdefs		= predefined_font_item
AddElement(Name_CBU2BA)

Key_CBU2BA				    = CreateElement "ceStringPoly"
Key_CBU2BA.name			    = "Key_CBU2BA"
Key_CBU2BA.material		    = "font_kneeboard"
Key_CBU2BA.init_pos		    = {offset_cbu_quantity,  CBU2BA_LineY, 0}
Key_CBU2BA.formats			= {"%.0f","%s"}
Key_CBU2BA.element_params   = {"CBU2BA_QTY"}
Key_CBU2BA.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_CBU2BA.alignment		= "RightBottom"
Key_CBU2BA.stringdefs		= predefined_font_header
AddElement(Key_CBU2BA)

Units_CBU2BA                 = CreateElement "ceStringPoly"
Units_CBU2BA.name			= "Units_CBU2BA"
Units_CBU2BA.material		= "font_kneeboard"
Units_CBU2BA.init_pos		= {offset_cbu_method,  CBU2BA_LineY, 0}
Units_CBU2BA.value		    = _("TUBES PER PULSE")
Units_CBU2BA.alignment	    = "LeftBottom"
Units_CBU2BA.stringdefs	    = predefined_font_item
AddElement(Units_CBU2BA)

Hints_CBU2BA				= CreateElement "ceStringPoly"
Hints_CBU2BA.name			= "Hints_CBU2BA"
Hints_CBU2BA.material		= "font_kneeboard_hint"
Hints_CBU2BA.init_pos		= {margin_xr,  CBU2BA_LineY, 0}
Hints_CBU2BA.value			= _("RSHIFT+RALT+3")
Hints_CBU2BA.alignment		= "RightBottom"
Hints_CBU2BA.stringdefs		= predefined_font_item
AddElement(Hints_CBU2BA)

--------------------
-- COUNTERMEASURES
--------------------
txt_CountermeasuresTitle				= CreateElement "ceStringPoly"
txt_CountermeasuresTitle.name			= "txt_CountermeasuresTitle"
txt_CountermeasuresTitle.material		= "font_kneeboard"
txt_CountermeasuresTitle.init_pos		= {margin_xl, getLineY(offset_line_cms), 0}
txt_CountermeasuresTitle.value		    = "COUNTERMEASURES"
txt_CountermeasuresTitle.alignment	    = "LeftBottom"
txt_CountermeasuresTitle.stringdefs	    = predefined_font_header
AddElement(txt_CountermeasuresTitle)

--burst
BURSTS_LineY = getLineY(offset_line_cms + 1)

Name_BURSTS				    = CreateElement "ceStringPoly"
Name_BURSTS.name			= "Name_BURSTS"
Name_BURSTS.material		= "font_kneeboard"
Name_BURSTS.init_pos		= {offset_indent_line, BURSTS_LineY, 0}
Name_BURSTS.value			= _("BURST")
Name_BURSTS.alignment		= "LeftBottom"
Name_BURSTS.stringdefs		= predefined_font_item
AddElement(Name_BURSTS)

Key_BURSTS				    = CreateElement "ceStringPoly"
Key_BURSTS.name			    = "Key_BURSTS"
Key_BURSTS.material		    = "font_kneeboard"
Key_BURSTS.init_pos		    = {offset_cms_quantity, BURSTS_LineY, 0}
Key_BURSTS.formats			= {"%.0f","%s"}
Key_BURSTS.element_params   = {"CMS_BURSTS_PARAM"}
Key_BURSTS.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_BURSTS.alignment		= "CenterBottom"
Key_BURSTS.stringdefs		= predefined_font_header
AddElement(Key_BURSTS)

Units_BURSTS                 = CreateElement "ceStringPoly"
Units_BURSTS.name			= "Units_BURSTS"
Units_BURSTS.material		= "font_kneeboard"
Units_BURSTS.init_pos		= {offset_cms_method, BURSTS_LineY, 0}
Units_BURSTS.value		    = _("BURSTS")
Units_BURSTS.alignment	    = "LeftBottom"
Units_BURSTS.stringdefs	    = predefined_font_item
AddElement(Units_BURSTS)

Hints_BURSTS				= CreateElement "ceStringPoly"
Hints_BURSTS.name			= "Hints_BURSTS"
Hints_BURSTS.material		= "font_kneeboard_hint"
Hints_BURSTS.init_pos		= {margin_xr, BURSTS_LineY, 0}
Hints_BURSTS.value			= _("RSHIFT+RALT+4")
Hints_BURSTS.alignment		= "RightBottom"
Hints_BURSTS.stringdefs		= predefined_font_item
AddElement(Hints_BURSTS)

--burst interval
BURST_INTERVAL_LineY = getLineY(offset_line_cms + 2)

Name_BURST_INTERVAL				    = CreateElement "ceStringPoly"
Name_BURST_INTERVAL.name			= "Name_BURST_INTERVAL"
Name_BURST_INTERVAL.material		= "font_kneeboard"
Name_BURST_INTERVAL.init_pos		= {offset_indent_line, BURST_INTERVAL_LineY, 0}
Name_BURST_INTERVAL.value			= _("BURST INTERVAL")
Name_BURST_INTERVAL.alignment		= "LeftBottom"
Name_BURST_INTERVAL.stringdefs		= predefined_font_item
AddElement(Name_BURST_INTERVAL)

Key_BURST_INTERVAL				    = CreateElement "ceStringPoly"
Key_BURST_INTERVAL.name			    = "Key_BURST_INTERVAL"
Key_BURST_INTERVAL.material		    = "font_kneeboard"
Key_BURST_INTERVAL.init_pos		    = {offset_cms_quantity, BURST_INTERVAL_LineY, 0}
Key_BURST_INTERVAL.formats			= {"%.1f","%s"}
Key_BURST_INTERVAL.element_params   = {"CMS_BURST_INTERVAL_PARAM"}
Key_BURST_INTERVAL.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_BURST_INTERVAL.alignment		= "CenterBottom"
Key_BURST_INTERVAL.stringdefs		= predefined_font_header
AddElement(Key_BURST_INTERVAL)

Units_BURST_INTERVAL                 = CreateElement "ceStringPoly"
Units_BURST_INTERVAL.name			= "Units_BURST_INTERVAL"
Units_BURST_INTERVAL.material		= "font_kneeboard"
Units_BURST_INTERVAL.init_pos		= {offset_cms_method, BURST_INTERVAL_LineY, 0}
Units_BURST_INTERVAL.value		    = _("SECONDS")
Units_BURST_INTERVAL.alignment	    = "LeftBottom"
Units_BURST_INTERVAL.stringdefs	    = predefined_font_item
AddElement(Units_BURST_INTERVAL)

Hints_BURST_INTERVAL				= CreateElement "ceStringPoly"
Hints_BURST_INTERVAL.name			= "Hints_BURST_INTERVAL"
Hints_BURST_INTERVAL.material		= "font_kneeboard_hint"
Hints_BURST_INTERVAL.init_pos		= {margin_xr, BURST_INTERVAL_LineY, 0}
Hints_BURST_INTERVAL.value			= _("RSHIFT+RALT+5")
Hints_BURST_INTERVAL.alignment		= "RightBottom"
Hints_BURST_INTERVAL.stringdefs		= predefined_font_item
AddElement(Hints_BURST_INTERVAL)

--salvos
SALVOS_LineY = getLineY(offset_line_cms + 3)

Name_SALVOS				    = CreateElement "ceStringPoly"
Name_SALVOS.name			= "Name_SALVOS"
Name_SALVOS.material		= "font_kneeboard"
Name_SALVOS.init_pos		= {offset_indent_line, SALVOS_LineY, 0}
Name_SALVOS.value			= _("SALVOS")
Name_SALVOS.alignment		= "LeftBottom"
Name_SALVOS.stringdefs		= predefined_font_item
AddElement(Name_SALVOS)

Key_SALVOS				    = CreateElement "ceStringPoly"
Key_SALVOS.name			    = "Key_SALVOS"
Key_SALVOS.material		    = "font_kneeboard"
Key_SALVOS.init_pos		    = {offset_cms_quantity, SALVOS_LineY, 0}
Key_SALVOS.formats			= {"%.0f","%s"}
Key_SALVOS.element_params   = {"CMS_SALVOS_PARAM"}
Key_SALVOS.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_SALVOS.alignment		= "CenterBottom"
Key_SALVOS.stringdefs		= predefined_font_header
AddElement(Key_SALVOS)

Units_SALVOS                 = CreateElement "ceStringPoly"
Units_SALVOS.name			= "Units_SALVOS"
Units_SALVOS.material		= "font_kneeboard"
Units_SALVOS.init_pos		= {offset_cms_method, SALVOS_LineY, 0}
Units_SALVOS.value		    = _("SALVOS")
Units_SALVOS.alignment	    = "LeftBottom"
Units_SALVOS.stringdefs	    = predefined_font_item
AddElement(Units_SALVOS)

Hints_SALVOS				= CreateElement "ceStringPoly"
Hints_SALVOS.name			= "Hints_SALVOS"
Hints_SALVOS.material		= "font_kneeboard_hint"
Hints_SALVOS.init_pos		= {margin_xr, SALVOS_LineY, 0}
Hints_SALVOS.value			= _("RSHIFT+RALT+6")
Hints_SALVOS.alignment		= "RightBottom"
Hints_SALVOS.stringdefs		= predefined_font_item
AddElement(Hints_SALVOS)

--salvo interval
SALVO_INTERVAL_LineY = getLineY(offset_line_cms + 4)

Name_SALVO_INTERVAL				    = CreateElement "ceStringPoly"
Name_SALVO_INTERVAL.name			= "Name_SALVO_INTERVAL"
Name_SALVO_INTERVAL.material		= "font_kneeboard"
Name_SALVO_INTERVAL.init_pos		= {offset_indent_line,  SALVO_INTERVAL_LineY, 0}
Name_SALVO_INTERVAL.value			= _("SALVO INTERVAL")
Name_SALVO_INTERVAL.alignment		= "LeftBottom"
Name_SALVO_INTERVAL.stringdefs		= predefined_font_item
AddElement(Name_SALVO_INTERVAL)

Key_SALVO_INTERVAL				    = CreateElement "ceStringPoly"
Key_SALVO_INTERVAL.name			    = "Key_SALVO_INTERVAL"
Key_SALVO_INTERVAL.material		    = "font_kneeboard"
Key_SALVO_INTERVAL.init_pos		    = {offset_cms_quantity,  SALVO_INTERVAL_LineY, 0}
Key_SALVO_INTERVAL.formats			= {"%.0f","%s"}
Key_SALVO_INTERVAL.element_params   = {"CMS_SALVO_INTERVAL_PARAM"}
Key_SALVO_INTERVAL.controllers      = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
Key_SALVO_INTERVAL.alignment		= "CenterBottom"
Key_SALVO_INTERVAL.stringdefs		= predefined_font_header
AddElement(Key_SALVO_INTERVAL)

Units_SALVO_INTERVAL                 = CreateElement "ceStringPoly"
Units_SALVO_INTERVAL.name			= "Units_SALVO_INTERVAL"
Units_SALVO_INTERVAL.material		= "font_kneeboard"
Units_SALVO_INTERVAL.init_pos		= {offset_cms_method,  SALVO_INTERVAL_LineY, 0}
Units_SALVO_INTERVAL.value		    = _("SECONDS")
Units_SALVO_INTERVAL.alignment	    = "LeftBottom"
Units_SALVO_INTERVAL.stringdefs	    = predefined_font_item
AddElement(Units_SALVO_INTERVAL)

Hints_SALVO_INTERVAL				= CreateElement "ceStringPoly"
Hints_SALVO_INTERVAL.name			= "Hints_SALVO_INTERVAL"
Hints_SALVO_INTERVAL.material		= "font_kneeboard_hint"
Hints_SALVO_INTERVAL.init_pos		= {margin_xr,  SALVO_INTERVAL_LineY, 0}
Hints_SALVO_INTERVAL.value			= _("RSHIFT+RALT+7")
Hints_SALVO_INTERVAL.alignment		= "RightBottom"
Hints_SALVO_INTERVAL.stringdefs		= predefined_font_item
AddElement(Hints_SALVO_INTERVAL)
