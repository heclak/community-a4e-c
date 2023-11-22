dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.common_script_path.."elements_defs.lua")


avionics = require_avionics()

local dev 	    = GetSelf()

local extended_dev = avionics.ExtendedRadio(devices.ELECTRIC_SYSTEM, devices.INTERCOM, devices.UHF_RADIO)
local extended_dev_guard = avionics.ExtendedRadio(devices.ELECTRIC_SYSTEM, devices.INTERCOM, devices.UHF_RADIO_GUARD)
local update_time_step = 0.05 --update will be called 20/second
make_default_activity(update_time_step)

dev:listen_command(device_commands.arc51_mode)
dev:listen_command(device_commands.arc51_xmitmode)
dev:listen_command(device_commands.arc51_volume)
dev:listen_command(device_commands.arc51_squelch)
dev:listen_command(device_commands.arc51_freq_preset)
dev:listen_command(device_commands.arc51_freq_XXooo)
dev:listen_command(device_commands.arc51_freq_ooXoo)
dev:listen_command(device_commands.arc51_freq_oooXX)
--dev:listen_command(Keys.radio_ptt)
--plusnine uhf frequency keybinds
dev:listen_command(Keys.UHFPresetChannelInc)
dev:listen_command(Keys.UHFPresetChannelDec)
dev:listen_command(Keys.UHFFreqModeInc)
dev:listen_command(Keys.UHFFreqModeDec)
dev:listen_command(Keys.UHFModeInc)
dev:listen_command(Keys.UHFModeDec)
dev:listen_command(Keys.UHF10MHzInc)
dev:listen_command(Keys.UHF10MHzDec)
dev:listen_command(Keys.UHF1MHzInc)
dev:listen_command(Keys.UHF1MHzDec)
dev:listen_command(Keys.UHF50kHzInc)
dev:listen_command(Keys.UHF50kHzDec)
dev:listen_command(Keys.UHFVolumeInc)
dev:listen_command(Keys.UHFVolumeDec)
dev:listen_command(Keys.UHFVolumeStartUp)
dev:listen_command(Keys.UHFVolumeStartDown)
dev:listen_command(Keys.UHFVolumeStop)
dev:listen_command(Keys.radio_ptt)
dev:listen_command(Keys.radio_ptt_voip)

voice_ptt_0_icommand = 1731
voice_ptt_1_icommand = 1732
dev:listen_command(voice_ptt_0_icommand)
dev:listen_command(voice_ptt_1_icommand)

efm_data_bus = get_efm_data_bus()

-- arc-51 displayed frequencies
local arc51_freq_XXxxx_display = get_param_handle("ARC51-FREQ-XXxxx")
local arc51_freq_xxXxx_display = get_param_handle("ARC51-FREQ-xxXxx")
local arc51_freq_xxxXX_display = get_param_handle("ARC51-FREQ-xxxXX")
local arc51_freq_preset_display = get_param_handle("ARC51-FREQ-PRESET")

local adf_on_and_powered = get_param_handle("ADF_ON_AND_POWERED")
local sound_adf_garble = get_param_handle("SND_CONT_ADF_GARBLE")
local sound_adf_garble_volume = get_param_handle("SND_CONT_ADF_GARBLE_VOLUME")

--ARC51 States
ARC51_STATE_OFF = 0
ARC51_STATE_ON_MANUAL = 1
ARC51_STATE_ON_PRESET = 2
ARC51_STATE_ON_GUARD = 3

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
local arc51_voip_factor = 1
local arc51_volume_moving = 0
local arc51_squelch = 0

local arc51_freq_XXxxx = 0
local arc51_freq_xxXxx = 0
local arc51_freq_xxxXX = 0

local uhf_radio_device = nil

local arc51_radio_presets = GetRadioChannels()

function sync_switches()
    dev:performClickableAction(device_commands.arc51_mode, arc51_mode / 10.0, false)
    dev:performClickableAction(device_commands.arc51_xmitmode, arc51_xmit_mode / 10.0, false)
end

function arc51_set_knobs_to_frequency(value)
	value = value - 220
	
	--I absolutely fucking hate floats.
	--This should be entirely represented by
	--integers but NOOOO lua doesn't need integers
	--because everything is just a magical number.
	--TODO clean my conscience
	XXxxx = math.floor(value / 10)
	xxXxx = math.floor(value % 10)
	xxxXX = round( (value % 1) * 100 )
	
	
	dev:performClickableAction(device_commands.arc51_freq_XXooo, XXxxx / 20, false)
	dev:performClickableAction(device_commands.arc51_freq_ooXoo, xxXxx / 10, false)
	dev:performClickableAction(device_commands.arc51_freq_oooXX, xxxXX / 100, false)
end

function post_initialize()
    uhf_radio_device = GetDevice(devices.UHF_RADIO)
	arc51_set_knobs_to_frequency(arc51_radio_presets[1])

    extended_dev:init()
    extended_dev_guard:init()
    extended_dev:setCurrentCommunicator() -- Sets this radio for communication with AI etc.


	dev:performClickableAction(device_commands.arc51_volume, 0.7, false)
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

function GetVolume(value)
    return math.pow(value, 3.0)
end

function fnc_arc51_volume(value)
    if value < 0.0 then
        dev:performClickableAction(device_commands.arc51_volume, 0.0, false)
    elseif value > 1.0 then
        dev:performClickableAction(device_commands.arc51_volume, 1.0, false)
    else
        arc51_volume = value

        local actual_volume = GetVolume(arc51_volume * arc51_voip_factor)
        extended_dev:setVolume(actual_volume)
        extended_dev_guard:setVolume(actual_volume)
    end
end

function fnc_arc51_mode(value)
    arc51_mode = round(value*10)

    if arc51_mode == ARC51_ADF then
        arc51_voip_factor = 0.5
    else
        arc51_voip_factor = 1
    end

    fnc_arc51_volume(arc51_volume)
end

function fnc_arc51_xmitmode(value)
    arc51_xmit_mode = round(value + 1)
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

function fnc_arc51_voip_ptt(value)
    extended_dev:pushToTalkVOIP(value == 1, arc51_mode == ARC51_ADF )
end

function fnc_arc51_voip_guard_ptt(value)
    extended_dev_guard:pushToTalkVOIP(value == 1, false )
end


local command_table = {
    [device_commands.arc51_mode] = fnc_arc51_mode,
    [device_commands.arc51_xmitmode] = fnc_arc51_xmitmode,
    [device_commands.arc51_volume] = fnc_arc51_volume,
    [device_commands.arc51_squelch] = fnc_arc51_squelch,
    [device_commands.arc51_freq_preset] = fnc_arc51_freq_preset,
    [device_commands.arc51_freq_XXooo] = fnc_arc51_freq_XXxxx,
    [device_commands.arc51_freq_ooXoo] = fnc_arc51_freq_xxXxx,
    [device_commands.arc51_freq_oooXX] = fnc_arc51_freq_xxxXX,
    [Keys.radio_ptt_voip] = fnc_arc51_voip_ptt,
    [voice_ptt_0_icommand] = fnc_arc51_voip_ptt,
    [voice_ptt_1_icommand] = fnc_arc51_voip_guard_ptt,
}

function SetCommand(command,value)

    if command_table[command] ~= nil then
        command_table[command](value)
    -- mode switch
    elseif command == Keys.UHFModeInc and arc51_mode < 3 then
        dev:performClickableAction(device_commands.arc51_mode, clamp(arc51_mode / 10 + 0.1, 0, 0.3), false)
    elseif command == Keys.UHFModeDec and arc51_mode > 0 then
        dev:performClickableAction(device_commands.arc51_mode, clamp(arc51_mode / 10 - 0.1, 0, 0.3), false)
    -- frequency xmit mode switch
    elseif command == Keys.UHFFreqModeInc and arc51_xmit_mode > 0 then
        dev:performClickableAction(device_commands.arc51_xmitmode, clamp(arc51_xmit_mode - 2, -1, 1), false)
    elseif command == Keys.UHFFreqModeDec and arc51_xmit_mode < 2 then
        dev:performClickableAction(device_commands.arc51_xmitmode, clamp(arc51_xmit_mode, -1, 1), false)
    -- preset frequency select
    elseif command == Keys.UHFPresetChannelInc and arc51_preset < 0.95 then
        dev:performClickableAction(device_commands.arc51_freq_preset, clamp(arc51_preset + 0.05, 0, 0.95), false)
    elseif command == Keys.UHFPresetChannelDec and arc51_preset > 0 then
        dev:performClickableAction(device_commands.arc51_freq_preset, clamp(arc51_preset - 0.05, 0, 0.95), false)
    -- manual freqency select
    elseif command == Keys.UHF10MHzInc and arc51_freq_XXxxx < 0.85 then
        dev:performClickableAction(device_commands.arc51_freq_XXooo, arc51_freq_XXxxx + 0.05,false)
    elseif command == Keys.UHF10MHzDec and arc51_freq_XXxxx > 0 then
        dev:performClickableAction(device_commands.arc51_freq_XXooo, arc51_freq_XXxxx - 0.05,false)
    elseif command == Keys.UHF10MHzInc and arc51_freq_XXxxx < 0.85 then
        dev:performClickableAction(device_commands.arc51_freq_XXooo, arc51_freq_XXxxx + 0.05,false)
    elseif command == Keys.UHF10MHzDec and arc51_freq_XXxxx > 0 then
        dev:performClickableAction(device_commands.arc51_freq_XXooo, arc51_freq_XXxxx - 0.05,false)
    elseif command == Keys.UHF1MHzInc and arc51_freq_xxXxx < 0.9 then
        dev:performClickableAction(device_commands.arc51_freq_ooXoo, arc51_freq_xxXxx + 0.10,false)
    elseif command == Keys.UHF1MHzDec and arc51_freq_xxXxx > 0 then
        dev:performClickableAction(device_commands.arc51_freq_ooXoo, arc51_freq_xxXxx - 0.10,false)
    elseif command == Keys.UHF50kHzInc and arc51_freq_xxxXX < 0.95 then
        dev:performClickableAction(device_commands.arc51_freq_oooXX, arc51_freq_xxxXX + 0.05,false)
    elseif command == Keys.UHF50kHzDec and arc51_freq_xxxXX > 0 then
        dev:performClickableAction(device_commands.arc51_freq_oooXX, arc51_freq_xxxXX - 0.05,false)
    -- volume
    elseif command == Keys.UHFVolumeInc and arc51_volume < 1.0 then
        dev:performClickableAction(device_commands.arc51_volume, arc51_volume + 0.02,false)
    elseif command == Keys.UHFVolumeDec and arc51_volume > 0.0 then
        dev:performClickableAction(device_commands.arc51_volume, arc51_volume - 0.02,false)
    elseif command == Keys.UHFVolumeStartUp then
        arc51_volume_moving = 1
    elseif command == Keys.UHFVolumeStartDown then
        arc51_volume_moving = -1
    elseif command == Keys.UHFVolumeStop then
        arc51_volume_moving = 0
    elseif command == Keys.radio_ptt then
        extended_dev:pushToTalk()
    end
end

function SetPower(value)
    extended_dev:setPower(value)
    extended_dev_guard:setPower(value and arc51_mode == ARC51_TRG )
end

function arc51_get_current_state()
    if arc51_mode == ARC51_OFF or not get_elec_primary_dc_ok() then
        return ARC51_STATE_OFF
    else --must be in TR, TR+G or ADF
        if arc51_xmit_mode == ARC51_PRESET then
            return ARC51_STATE_ON_PRESET
        elseif arc51_xmit_mode == ARC51_MAN then
            return ARC51_STATE_ON_MANUAL
        else --no other options
            return ARC51_STATE_ON_GUARD
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
        uhf_radio_device:set_frequency(243E6) --standard guard frequency
    end
end

function SetADFGarble(value)

    if value then
        sound_adf_garble:set(1)
        local actual_volume = GetVolume(arc51_volume)
        sound_adf_garble_volume:set(actual_volume)
    else
        sound_adf_garble:set(0)
        sound_adf_garble_volume:set(0)
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
        SetPower(true)

        if arc51_mode == ARC51_ADF then
            adf_on_and_powered:set( 1 )
            SetADFGarble(extended_dev:getADFBearing() ~= nil)
        else
            adf_on_and_powered:set(0)
            SetADFGarble(false)
        end
    else
        adf_on_and_powered:set( 0 )
        SetPower(false)
        SetADFGarble(false)
    end

end

function update()
    arc51_update()

    if arc51_volume_moving ~= 0 then
        dev:performClickableAction(device_commands.arc51_volume, clamp(arc51_volume + 0.03 * arc51_volume_moving, 0.0, 1.0), false)
    end

end

need_to_be_closed = false -- close lua state after initialization



