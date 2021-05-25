dofile(LockOn_Options.script_path.."Nav/ils_utils.lua")

dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- ILS DATA

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

ils_data, marker_data = get_ils_data_in_format()
--BEACON_TYPE_ILS_LOCALIZER
--BEACON_TYPE_ILS_GLIDESLOPE

function get_frequency(channel)
    frequency = 0

    if channel[BEACON_TYPE_ILS_LOCALIZER] ~= nil then
        frequency = channel[BEACON_TYPE_ILS_LOCALIZER].frequency
    elseif channel[BEACON_TYPE_ILS_GLIDESLOPE] ~= nil then
        frequency = channel[BEACON_TYPE_ILS_GLIDESLOPE].frequency
    end

    freq_str = string.format("%.3f", frequency / 1000000.0)
    return freq_str
end

function get_declination()
    local sensor_data = get_base_data()
    local mh = sensor_data.getMagneticHeading()
    local th = 2*math.pi - sensor_data.getHeading()
    local dec = math.deg(th-mh)
    if dec > 180 then
        dec = dec - 360
    end
    return dec
end

local declination = get_declination()

function get_bearing(channel)
    bearing = ""

    if channel[BEACON_TYPE_ILS_LOCALIZER] ~= nil then
        local brg = channel[BEACON_TYPE_ILS_LOCALIZER].direction

        if brg > 180 then
            brg = brg - 180
        else
            brg = brg + 180
        end

        bearing = string.format("%03d", brg - declination)
    end

    return bearing
end

data_x_positions = {
    [1] = -0.86,
    [2] = -0.57,
    [3] = -0.07,
    [4] = 0.42,
    [5] = 0.78,

}
function add_channel(line, channel)
    
    local data = ils_data[channel]

    if data == nil then
        return
    end

    local line_data = {
        [1] = tostring(channel),
        [2] = string.upper(tostring(data.callsign)),
        [3] = string.upper(tostring(data.name)),
        [4] = get_frequency(data),
        [5] = get_bearing(data),
    }


    local txt_chn = {}
    for i = 1, 5 do
        txt_chn[i] = CreateElement "ceStringPoly"
        txt_chn[i].name = "txt_chn["..tostring(i).."]"
        txt_chn[i].material = "font_kneeboard"
        txt_chn[i].init_pos = {data_x_positions[i], getLineY(line), 0}
        txt_chn[i].value = _(line_data[i])
        txt_chn[i].alignment = "CenterBottom"
        txt_chn[i].stringdefs = predefined_font_item
    AddElement(txt_chn[i])
    end
    
    return txt_chn

end

-----------------------------------------------------------------
--                         WEAPONS CONFIG
-----------------------------------------------------------------

txt_BoardTitle				= CreateElement "ceStringPoly"
txt_BoardTitle.name			= "txt_BoardTitle"
txt_BoardTitle.material		= "font_kneeboard_white"
txt_BoardTitle.init_pos		= {0.0, getLineY(0), 0}
txt_BoardTitle.value		= _("ILS DATA")
txt_BoardTitle.alignment	= "CenterBottom"
txt_BoardTitle.stringdefs	= predefined_font_title
AddElement(txt_BoardTitle)


headings = {"CHN", "CODE", "NAME", "FREQ", "BRG"}
heading_x_position = {
    [1] = -0.75,
    [2] = -0.43,
    [3] = 0.07,
    [4] = 0.57,
    [5] = 0.9,

}
txt_heading = {}
for i = 1, 5 do
    txt_heading[i] = CreateElement "ceStringPoly"
    txt_heading[i].name = "txt_heading["..tostring(i).."]"
    txt_heading[i].material = "font_kneeboard"
    txt_heading[i].init_pos = {heading_x_position[i], getLineY(2), 0}
    txt_heading[i].value = _(headings[i])
    txt_heading[i].alignment = "RightBottom"
    txt_heading[i].stringdefs = predefined_font_title
    AddElement(txt_heading[i])
end

for i = 1, #ils_data do
    txt_chn = add_channel(i+2, i)
end

--[[
-----------------------------------------------------------------
--                         CBU-1/A
-----------------------------------------------------------------

CBU1A_LineY = getLineY(2)

Name_CBU1A				    = CreateElement "ceStringPoly"
Name_CBU1A.name			    = "Name_CBU1A"
Name_CBU1A.material		    = "font_kneeboard"
Name_CBU1A.init_pos		    = {NamePosX,  CBU1A_LineY, 0}
Name_CBU1A.value		    = _("CBU-1/A1")
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

]]--