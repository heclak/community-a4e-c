dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

local dev 	    = GetSelf()
local update_time_step = 0.05 --update will be called 20/second
make_default_activity(update_time_step)

dev:listen_command(device_commands.arc51_mode)
dev:listen_command(device_commands.arc51_xmitmode)
dev:listen_command(device_commands.arc51_volume)
dev:listen_command(device_commands.arc51_squelch)
dev:listen_command(device_commands.arc51_freq_preset)
dev:listen_command(device_commands.arc51_freq_XXxxx)
dev:listen_command(device_commands.arc51_freq_xxXxx)
dev:listen_command(device_commands.arc51_freq_xxxXX)
--dev:listen_command(Keys.radio_ptt)

efm_data_bus = get_efm_data_bus()

-- arc-51 displayed frequencies
local arc51_freq_XXxxx_display = get_param_handle("ARC51-FREQ-XXxxx")
local arc51_freq_xxXxx_display = get_param_handle("ARC51-FREQ-xxXxx")
local arc51_freq_xxxXX_display = get_param_handle("ARC51-FREQ-xxxXX")
local arc51_freq_preset_display = get_param_handle("ARC51-FREQ-PRESET")

--ARC51 States
ARC51_STATE_OFF = 0
ARC51_STATE_ON_MANUAL = 1
ARC51_STATE_ON_PRESET = 2
ARC51_STATE_ON_GUARD = 3
ARC51_STATE_ADF = 4

--ARC51 Settings
--Possible settings
ARC51_OFF = 0
ARC51_TR = 1
ARC51_TRG = 2
ARC51_ADF = 3

ARC51_GXMIT = 0
ARC51_MAN = 1
ARC51_PRESET = 2

--Current Radio Values
local arc51_mode = ARC51_OFF
local arc51_xmit_mode = ARC51_MAN
local arc51_state = ARC51_STATE_OFF
local arc51_preset = 0
local arc51_frequency = 256E6
local arc51_change = false
local arc51_volume = 0
local arc51_squelch = 0

local arc51_freq_XXxxx = 0
local arc51_freq_xxXxx = 0
local arc51_freq_xxxXX = 0

local uhf_radio_device = nil

local arc51_radio_presets
if get_aircraft_mission_data ~= nil then
    arc51_radio_presets = get_aircraft_mission_data("Radio")[1].channels
end

function sync_switches()
    dev:performClickableAction(device_commands.arc51_mode, arc51_mode / 10.0, false)
    dev:performClickableAction(device_commands.arc51_xmitmode, arc51_xmit_mode / 10.0, false)
end


function post_initialize()
    uhf_radio_device = GetDevice(devices.UHF_RADIO)

    local birth = LockOn_Options.init_conditions.birth_place

    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        arc51_mode = ARC51_TR
        arc51_xmit_mode = ARC51_MAN
        arc51_state = ARC51_STATE_OFF
    elseif birth == "GROUND_COLD" then
        arc51_mode = ARC51_OFF
        arc51_xmit_mode = ARC51_MAN
        arc51_state = ARC51_STATE_OFF
    end

    sync_switches()
end

function fnc_arc51_mode(value)
    arc51_mode = round(value*10)
end

function fnc_arc51_xmitmode(value)
    arc51_xmit_mode = round(value + 1)
end

function fnc_arc51_volume(value)
    if value < 0.2 then
        dev:performClickableAction(device_commands.arc51_volume, 0.2, false)
    elseif value > 0.8 then
        dev:performClickableAction(device_commands.arc51_volume, 0.8, false)
    else
        arc51_value = value
    end
end

function fnc_arc51_squelch(value)
    arc51_squelch = value
end

function fnc_arc51_freq_preset(value)
    arc51_change = true
    arc51_preset = value
end

function fnc_arc51_freq_XXxxx(value)
    arc51_change = true
    arc51_freq_XXxxx = value
end

function fnc_arc51_freq_xxXxx(value)
    arc51_change = true
    arc51_freq_xxXxx = value
end

function fnc_arc51_freq_xxxXX(value)
    arc51_change = true
    arc51_freq_xxxXX = value
end


local command_table = {
    [device_commands.arc51_mode] = fnc_arc51_mode,
    [device_commands.arc51_xmitmode] = fnc_arc51_xmitmode,
    [device_commands.arc51_volume] = fnc_arc51_volume,
    [device_commands.arc51_squelch] = fnc_arc51_squelch,
    [device_commands.arc51_freq_preset] = fnc_arc51_freq_preset,
    [device_commands.arc51_freq_XXxxx] = fnc_arc51_freq_XXxxx,
    [device_commands.arc51_freq_xxXxx] = fnc_arc51_freq_xxXxx,
    [device_commands.arc51_freq_xxxXX] = fnc_arc51_freq_xxxXX,
}

function SetCommand(command,value)
    if command_table[command] ~= nil then
        command_table[command](value)
    end
end

function arc51_get_current_state()
    if arc51_mode == ARC51_OFF or not get_elec_primary_dc_ok() then
        return ARC51_STATE_OFF
    elseif arc51_mode == ARC51_ADF then
        return ARC51_ADF --do something about adf later.
    else --must be in TR or TR+G
        if arc51_xmit_mode == ARC51_PRESET then
            return ARC51_STATE_ON_PRESET
        elseif arc51_xmit_mode == ARC51_MAN then
            return ARC51_STATE_ON_MANUAL
        else --no other options
            return ARC_STATE_ON_GUARD
        end
    end
end

function arc51_update_frequency()
    a_XXxxx = round(arc51_freq_XXxxx*200,1)
    a_xxXxx = round(arc51_freq_xxXxx*10,1)
    a_xxxXX = round(arc51_freq_xxxXX,2)
    arc51_frequency = (a_XXxxx + a_xxXxx + a_xxxXX + 220) * 1E6
end

function arc51_transition_state()
    arc51_update_frequency()

    if arc51_state == ARC51_STATE_ON_PRESET then
        local channel = round(arc51_preset * 20) + 1
        local preset_frequency = arc51_radio_presets[channel] * 1E6
        uhf_radio_device:set_frequency(preset_frequency)
    elseif arc51_state == ARC51_STATE_ON_MANUAL then
        uhf_radio_device:set_frequency(arc51_frequency)
    elseif arc51_state == ARC51_STATE_ON_GUARD then
        uhf_radio_device:set_frequency(253E6) --standard guard frequency
    end
end

function arc51_update()
    arc51_freq_XXxxx_display:set( arc51_freq_XXxxx )
    arc51_freq_xxXxx_display:set( arc51_freq_xxXxx )
    arc51_freq_xxxXX_display:set( arc51_freq_xxxXX )
    arc51_freq_preset_display:set( arc51_preset )

    local temp_state = arc51_get_current_state()

    if temp_state ~= arc51_state or arc51_change then
        --print_message_to_user(arc51_state.."-->"..temp_state)
        arc51_state = temp_state
        arc51_transition_state()
        arc51_change = false
    end

    
    if arc51_state == ARC51_STATE_ON_PRESET or arc51_state == ARC51_STATE_ON_MANUAL or arc51_state == ARC51_STATE_ON_GUARD then
        efm_data_bus.fm_setRadioPower(1.0)
        --print_message_to_user("Power ON "..tostring(uhf_radio_device:is_on()))
        
    else
        efm_data_bus.fm_setRadioPower(0.0)
    end
    

end

function update()
    arc51_update()
end

need_to_be_closed = false -- close lua state after initialization



