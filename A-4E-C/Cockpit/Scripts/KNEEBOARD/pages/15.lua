--dofile(LockOn_Options.script_path.."Systems/weapon_system.lua")
dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_15.png")


local gettext = require("i_18n")
_ = gettext.translate

function AddElement(object)
 object.use_mipfilter = true
 Add(object)
end

-- fonts
FontSizeX1	= 0.0065
FontSizeY1	= FontSizeX1

predefined_font_title	= {FontSizeY1,			FontSizeX1,			0.0,	    0.0}
predefined_font_header	= {FontSizeY1 * 0.60,	FontSizeX1 * 0.60,	-0.0009,	0.0}
predefined_font_item	= {FontSizeY1 * 0.60,	FontSizeX1 * 0.60,	-0.0009,	0.0}

-- lines
local FirstLineY	= 1.4
local LineSizeY		= 0.1

local function getLineY(line)
 return FirstLineY - LineSizeY * (line)
end

local initload_pos_y = getLineY(2)

Name_InitLoad = CreateElement "ceStringPoly"
Name_InitLoad.name = "Name_InitLoad"
Name_InitLoad.material = "font_kneeboard"
Name_InitLoad.init_pos = {0, initload_pos_y, 0}
Name_InitLoad.value = _("INITIAL LOADOUT")
Name_InitLoad.alignment = "CenterBottom"
Name_InitLoad.stringdefs = predefined_font_title
AddElement(Name_InitLoad)

local start_line = 1
local margin_xl = -0.8
local margin_xr = 0.75
local offset_loadout = 0.2

-------------
-- HEADERS --
-------------

Header_Station = CreateElement "ceStringPoly"
Header_Station.name = "Header_Station"
Header_Station.material = "font_kneeboard"
Header_Station.init_pos = {margin_xl, start_line, 0}
Header_Station.value = _("STATION")
Header_Station.alignment = "CenterBottom"
Header_Station.stringdefs = predefined_font_header
AddElement(Header_Station)

Header_Loadout = CreateElement "ceStringPoly"
Header_Loadout.name = "Header_Loadout"
Header_Loadout.material = "font_kneeboard"
Header_Loadout.init_pos = {margin_xl + offset_loadout, start_line, 0}
Header_Loadout.value = _("LOADOUT")
Header_Loadout.alignment = "LeftBottom"
Header_Loadout.stringdefs = predefined_font_header
AddElement(Header_Loadout)

Header_Quantity = CreateElement "ceStringPoly"
Header_Quantity.name = "Header_Quantity"
Header_Quantity.material = "font_kneeboard"
Header_Quantity.init_pos = {margin_xr, start_line, 0}
Header_Quantity.value = _("QTY.")
Header_Quantity.alignment = "RightBottom"
Header_Quantity.stringdefs = predefined_font_header
AddElement(Header_Quantity)

-------------
--  ITEMS  --
-------------

for station = 1,5 do
    local start_line_offset = start_line + 3
    local item_pos_y = getLineY(start_line_offset + station)

    EnumeratedStation                     = CreateElement "ceStringPoly"
    EnumeratedStation.name                = "EnumeratedStation"..station
    EnumeratedStation.material            = "font_kneeboard"
    EnumeratedStation.init_pos            = {margin_xl, item_pos_y, 0}
    EnumeratedStation.alignment           = "CenterBottom"
    EnumeratedStation.stringdefs          = predefined_font_item
    EnumeratedStation.value               = tostring(station)..". /"
    AddElement(EnumeratedStation)

    LoudoutByStation                     = CreateElement "ceStringPoly"
    LoudoutByStation.name                = "LoudoutByStation"..station
    LoudoutByStation.material            = "font_kneeboard"
    LoudoutByStation.init_pos            = {margin_xl + offset_loadout, item_pos_y, 0}
    LoudoutByStation.alignment           = "LeftBottom"
    LoudoutByStation.stringdefs          = predefined_font_item
    LoudoutByStation.formats              = {"%s"}
    LoudoutByStation.element_params      = {"loadout_station"..station}
    LoudoutByStation.controllers         = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
    AddElement(LoudoutByStation)

    LoadoutQuantity                     = CreateElement "ceStringPoly"
    LoadoutQuantity.name                = "LoadoutQuantity"..station
    LoadoutQuantity.material            = "font_kneeboard"
    LoadoutQuantity.init_pos            = {margin_xr, item_pos_y, 0}
    LoadoutQuantity.alignment           = "RightBottom"
    LoadoutQuantity.stringdefs          = predefined_font_item
    LoadoutQuantity.formats              = {"%.0f"}
    LoadoutQuantity.element_params      = {"loadout_quantity"..station}
    LoadoutQuantity.controllers         = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
    AddElement(LoadoutQuantity)

end
