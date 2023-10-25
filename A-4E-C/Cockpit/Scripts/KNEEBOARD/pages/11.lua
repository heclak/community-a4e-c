dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
dofile(LockOn_Options.script_path.."Nav/NAV_util.lua")
SetScale(FOV)

-- NAVIGATION LOG

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_11.dds")

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

--[[
-- local theatre      = get_terrain_related_data("name") 
    This method is no good.
    As of 2.7.9.108080
    Items that differrentiate by theatre should be revisited 
    using the coords and expressed as a function
    (especially MAGVAR on the nav system).
    'Caucauses', 'Nevada', 'Normandy' and 'Persian Gulf' have names.
    Syria and Marianas appear to be blank.
    Instead, starting coordinates are used, which should accomodate future maps.
]]

local missionroute = get_mission_route()
local waypointdata = {}

local function parse_waypoint_data(waypoint)

    local coord = lo_to_geo_coords(waypoint.x, waypoint.y)
    local parsed_waypoint_data = {}

    local lat = get_digits_LL122(coord.lat)
    local lon = get_digits_LL123(coord.lon)

    -- format lat to string
    parsed_waypoint_data.lat = ""
    for i = #lat, 2, -1 do
        parsed_waypoint_data.lat = parsed_waypoint_data.lat .. math.floor(lat[i])
    end
    if coord.lat == 0 then
        parsed_waypoint_data.lat = parsed_waypoint_data.lat .. " -"
    elseif coord.lat < 0 then
        parsed_waypoint_data.lat = parsed_waypoint_data.lat .. " S"
    else
        parsed_waypoint_data.lat = parsed_waypoint_data.lat .. " N"
    end

    -- format lon to string
    parsed_waypoint_data.lon = ""
    for i = #lon, 2, -1 do
        parsed_waypoint_data.lon = parsed_waypoint_data.lon .. math.floor(lon[i])
    end
    if coord.lon == 0 then
        parsed_waypoint_data.lat = parsed_waypoint_data.lat .. " -"
    elseif coord.lon < 0 then
        parsed_waypoint_data.lon = parsed_waypoint_data.lon .. " W"
    else
        parsed_waypoint_data.lon = parsed_waypoint_data.lon .. " E"
    end

    -- waypoint name from mission editor
	parsed_waypoint_data.name = waypoint.name

    return parsed_waypoint_data

end

local kneeboard_data = {}

local POS_LAT_X = 0.1
local POS_LON_X = 0.5
local POS_WAYPOINT_X = -0.9

local FIRST_LINE_Y = 1.00
local LINEHEIGHT = 0.105
local POS_TITLE_Y = 1.4
local POS_HEADERS_Y = FIRST_LINE_Y + 0.1

local function getLineY(line)
    return FIRST_LINE_Y - ((line - 1) * LINEHEIGHT)
end

local function addSimpleTextStringCommon(element, name, x, y, value, alignment, stringdefs, material)
    element = CreateElement "ceStringPoly"
    element.name = name
    element.isdraw = true
    element.alignment = alignment or "LeftBottom"
    element.value = value
    element.material = material or "font_kneeboard"
    element.init_pos = {x, y, 0}
    element.stringdefs = stringdefs or predefined_font_item
    return element
end

local function waypoint_name(waypoint_index, waypoint_data)
    if waypoint_index == 1 and waypoint_index < 11 then
        if waypoint_data.name == "" or waypoint_data.name == nil then
            return (waypoint_index - 1) .. ". START"
        else
            return (waypoint_index - 1) .. ". " .. string.upper(tostring(waypoint_data.name))
        end
    elseif waypoint_data.name == "" or waypoint_data.name == nil then
        return (waypoint_index - 1) .. ". WAYPOINT " .. (waypoint_index - 1)
    else
	    return (waypoint_index - 1) .. ". " .. string.upper(tostring(waypoint_data.name))
    end
end

-----------
-- TITLE --
-----------

--local txt_BoardTitle = {}
--txt_BoardTitle = addSimpleTextStringCommon(txt_BoardTitle, "txt_BoardTitle", 0.0, POS_TITLE_Y, "NAVIGATION LOG", nil, predefined_font_title, "font_kneeboard_white")
--AddElement(txt_BoardTitle)

-------------
-- HEADERS --
-------------

local name_label = {}
name_label = addSimpleTextStringCommon(name_label, "Name Label", POS_WAYPOINT_X, POS_HEADERS_Y, "NAME", nil, predefined_font_header)
AddElement(name_label)

local lat_label = {}
lat_label = addSimpleTextStringCommon(lat_label, "Lat Label", POS_LAT_X, POS_HEADERS_Y, "LATITUDE", nil, predefined_font_header)
AddElement(lat_label)

local lon_label = {}
lon_label = addSimpleTextStringCommon(lon_label, "Lon Label", POS_LON_X, POS_HEADERS_Y, "LONGITUDE", nil, predefined_font_header)
AddElement(lon_label)

-- NAVIGATION POINTS
local function add_waypoint(waypoint_index, waypoint_data)

    kneeboard_data[waypoint_index] = {}

    -- create waypoint name label

    kneeboard_data[waypoint_index].key  = addSimpleTextStringCommon(kneeboard_data[waypoint_index].key,
                                            "key_waypoint_"..waypoint_index,
                                            POS_WAYPOINT_X,
                                            getLineY(waypoint_index),
                                            waypoint_name(waypoint_index, waypoint_data),
                                            "LeftBottom"
                                        )
    AddElement(kneeboard_data[waypoint_index].key)

    -- create waypoint coordinate info
    kneeboard_data[waypoint_index].lat  = addSimpleTextStringCommon(kneeboard_data[waypoint_index].lat,
                                            "lat_waypoint_"..waypoint_index,
                                            POS_LAT_X,
                                            getLineY(waypoint_index),
                                            waypoint_data.lat
                                        )
    AddElement(kneeboard_data[waypoint_index].lat)

    kneeboard_data[waypoint_index].lon  = addSimpleTextStringCommon(kneeboard_data[waypoint_index].lon,
                                            "lon_waypoint_"..waypoint_index,
                                            POS_LON_X,
                                            getLineY(waypoint_index),
                                            waypoint_data.lon
                                        )
    AddElement(kneeboard_data[waypoint_index].lon)
end

-- parse route coordinates into geo coords
for i = 1, #missionroute, 1 do
    waypointdata[i] = parse_waypoint_data(missionroute[i])
    add_waypoint(i, waypointdata[i])
end
