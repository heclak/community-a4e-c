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
dev:listen_command(device_commands.arc51_freq_XXooo)
dev:listen_command(device_commands.arc51_freq_ooXoo)
dev:listen_command(device_commands.arc51_freq_oooXX)
--dev:listen_command(Keys.radio_ptt)
--plusnine uhf frequency keybinds
dev:listen_command(Keys.UHF10MHzInc)
dev:listen_command(Keys.UHF10MHzDec)
dev:listen_command(Keys.UHF1MHzInc)
dev:listen_command(Keys.UHF1MHzDec)
dev:listen_command(Keys.UHF50kHzInc)
dev:listen_command(Keys.UHF50kHzDec)

efm_data_bus = get_efm_data_bus()

-- arc-51 state and input processing
arc51_inputlist = {"OFF", "T/R", "T/R+G", "ADF"}
local arc51_state = "arc51-off"
local arc51_input = "OFF"
local arc51_mode = "OFF"
arc51_xmitinputlist = {"G XMIT", "MAN", "PRESET"}
local arc51_xmitstate = "arc51-xmit-man"
local arc51_xmit_input = "MAN"
local arc51_xmit_mode = "MAN"

local arc51_volume = 0
local arc51_squelch = 0
local arc51_freq_preset = 0
local arc51_freq_XXxxx = 0
local arc51_freq_xxXxx = 0
local arc51_freq_xxxXX = 0

local arc51_xmitinput

local arc51_frequency = 220E6

-- arc-51 displayed frequencies
local arc51_freq_XXxxx_display = get_param_handle("ARC51-FREQ-XXxxx")
local arc51_freq_xxXxx_display = get_param_handle("ARC51-FREQ-xxXxx")
local arc51_freq_xxxXX_display = get_param_handle("ARC51-FREQ-xxxXX")
local arc51_freq_preset_display = get_param_handle("ARC51-FREQ-PRESET")


function post_initialize()
end

local arc51_freq_old = 0

function update_radio_device()
    local uhf=GetDevice(devices.UHF_RADIO)
    if uhf then
        uhf:set_frequency(arc51_frequency)
        arc51_freq_old = arc51_frequency
    end
end

local arc51_freq_last = 220E6

function SetCommand(command,value)
    --print_message_to_user("SetCommand in radio_interface: "..tostring(command).."="..tostring(value))

    if command == device_commands.arc51_mode then
        arc51_input = arc51_inputlist[ round((value*10)+1) ]
        -- print_message_to_user("mode = "..arc51_input)
    elseif command == device_commands.arc51_xmitmode then
        arc51_xmit_input = arc51_xmitinputlist[ round(value+2) ]
        -- print_message_to_user("xmit mode = "..arc51_xmit_input)
    elseif command == device_commands.arc51_volume then
        if value < 0.2 then
            dev:performClickableAction(device_commands.arc51_volume, 0.2, false)
        elseif value > 0.8 then
            dev:performClickableAction(device_commands.arc51_volume, 0.8, false)
        else
            arc51_volume = value
        end
    elseif command == device_commands.arc51_squelch then
        arc51_squelch = value
    elseif command == device_commands.arc51_freq_preset then
        arc51_freq_preset = value
    elseif command == device_commands.arc51_freq_XXooo then
        arc51_freq_XXxxx = value
    elseif command == device_commands.arc51_freq_ooXoo then
        arc51_freq_xxXxx = value
    elseif command == device_commands.arc51_freq_oooXX then
        arc51_freq_xxxXX = value
    --manual frequency keybinds
    elseif command == Keys.UHF10MHzInc then
        print_message_to_user('ARC-51 UHF 10 MHz inc')
    elseif command == Keys.UHF10MHzDec then
        print_message_to_user('ARC-51 UHF 10 MHz dec')
    elseif command == Keys.UHF1MHzInc then
        print_message_to_user('ARC-51 UHF 1 MHz inc')
    elseif command == Keys.UHF1MHzDec then
        print_message_to_user('ARC-51 UHF 1 MHz dec')
    elseif command == Keys.UHF50kHzInc then
        print_message_to_user('ARC-51 UHF 50 kHz inc')
    elseif command == Keys.UHF50kHzDec then
        print_message_to_user('ARC-51 UHF 50 kHz dec')
    end

    arc51_freq_last = arc51_frequency

    a_XXxxx = round(arc51_freq_XXxxx*200,1)
    --print_message_to_user("XXxxx = "..a_XXxxx)
    a_xxXxx = round(arc51_freq_xxXxx*10,1)
    --print_message_to_user("xxXxx = "..a_xxXxx)
    a_xxxXX = round(arc51_freq_xxxXX,2)
    --print_message_to_user("xxxXX = "..a_xxxXX)
    arc51_frequency = (a_XXxxx + a_xxXxx + a_xxxXX + 220) * 1E6

    --arc51_frequency = round((arc51_freq_XXxxx * 200) + 220 + (arc51_freq_xxXxx*10) + arc51_freq_xxxXX, 2) * 1E6
    if arc51_frequency ~= arc51_freq_last then
        -- print_message_to_user("freq = "..arc51_frequency)
    end

end


function update_arc51()
    arc51_freq_XXxxx_display:set( arc51_freq_XXxxx )
    arc51_freq_xxXxx_display:set( arc51_freq_xxXxx )
    arc51_freq_xxxXX_display:set( arc51_freq_xxxXX )
    arc51_freq_preset_display:set( arc51_freq_preset )

    if (arc51_state == "arc51-tr" or arc51_state == "arc51-trg") and get_elec_primary_dc_ok() then
		print_message_to_user("Hello")
        efm_data_bus.fm_setRadioPower(1.0)
    else
        efm_data_bus.fm_setRadioPower(0.0)
    end
    

    if arc51_state == "arc51-off" then
        if arc51_input == "T/R" then arc51_state = "arc51-tr"
        elseif arc51_input == "T/R+G" then arc51_state = "arc51-trg"
        elseif arc51_input == "ADF" then arc51_state = "arc51-adf"
        end
    elseif arc51_state == "arc51-tr" then
        if arc51_input == "OFF" then arc51_state = "arc51-off"
        elseif arc51_input == "T/R+G" then arc51_state = "arc51-trg"
        elseif arc51_input == "ADF" then arc51_state = "arc51-adf"
        end
    elseif arc51_state == "arc51-trg" then
        
        if arc51_input == "OFF" then arc51_state = "arc51-off"
        elseif arc51_input == "T/R" then arc51_state = "arc51-tr"
        elseif arc51_input == "ADF" then arc51_state = "arc51-adf"
        end
    elseif arc51_state == "arc51-adf" then
        if arc51_input == "OFF" then arc51_state = "arc51-off"
        elseif arc51_input == "T/R" then arc51_state = "arc51-tr"
        elseif arc51_input == "T/R+G" then arc51_state = "arc51-trg"
        end
    end

end

function update()
    update_arc51()
    if arc51_frequency ~= arc51_freq_old then
        update_radio_device()
    end
end

need_to_be_closed = false -- close lua state after initialization



