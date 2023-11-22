dofile(LockOn_Options.common_script_path.."elements_defs.lua")
dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local gettext = require("i_18n")
_ = gettext.translate

function AddElement(object)
    object.use_mipfilter = true
    Add(object)
end

-- FontSizeX1 = 0.0045
FontSizeX1 = 0.0035
FontSizeY1 = FontSizeX1

predefined_font_title	= {FontSizeY1, FontSizeX1, 0.0, 0.0}

-- column_x_pos = {
--     [1] = -0.002,
--     [2] = 0.027,
--     [3] = 0.053,
--     [4] = 0.081
-- }


-- row_y_pos = {
--     [1] = -0.006,
--     [2] = -0.0105,
--     [3] = -0.015,
--     [4] = -0.02,
--     [5] = -0.025,
--     [6] = -0.0305,
-- }

column_x_pos = {
    [1] = -0.001,
    [2] = 0.0272,
    [3] = 0.054,
    [4] = 0.082
}

row_y_pos = {
    [1] = -0.0035,
    [2] = -0.0085,
    [3] = -0.0135,
    [4] = -0.0183,
    [5] = -0.0237,
    [6] = -0.029,
}

local channel_positions = {
    [1]  = {1, 1},
    [2]  = {1, 2},
    [3]  = {2, 1},
    [4]  = {2, 2},
    [5]  = {2, 3},
    [6]  = {2, 4},
    [7]  = {2, 5},
    [8]  = {2, 6},
    [9]  = {3, 1},
    [10] = {3, 2},
    [11] = {3, 3},
    [12] = {3, 4},
    [13] = {3, 5},
    [14] = {3, 6},
    [15] = {4, 1},
    [16] = {4, 2},
    [17] = {4, 3},
    [18] = {4, 4},
    [19] = {4, 5},
    [20] = {4, 6},
}

local txt_chn = {}

-- get radio preset data
local arc51_radio_presets = GetRadioChannels()

function print_channel(channel)
    
    line = channel

    local data = arc51_radio_presets[channel]
    local frequency = string.format("%.2f", data)

    if data == nil then
        return
    end    
    
    local txt_chn = {}
    txt_chn = CreateElement "ceStringPoly"
    txt_chn.name = "txt_chn["..tostring(channel).."]"
    txt_chn.material = "font_radio_labels"
    txt_chn.init_pos = {column_x_pos[channel_positions[channel][1]], row_y_pos[channel_positions[channel][2]], 0.000}
    txt_chn.value = string.upper(frequency)
    txt_chn.alignment = "LeftBottom"
    txt_chn.stringdefs = predefined_font_title
    AddElement(txt_chn)
    
    return
    
end

for i = 1, #arc51_radio_presets do
    print_channel(i)
end