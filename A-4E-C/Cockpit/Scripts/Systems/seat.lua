local dev = GetSelf()
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/stores_config.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.script_path.."Systems/air_data_computer.lua")
dofile(LockOn_Options.script_path.."sound_params.lua") 
dofile(LockOn_Options.script_path.."Systems/mission.lua")
dofile(LockOn_Options.script_path.."Systems/mission_utils.lua")

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

startup_print("seat: load")


local once_per_second_refresh = 1/update_time_step
local once_per_second = once_per_second_refresh

local sensor_data = get_efm_sensor_data_overrides()
local efm_data_bus = get_efm_data_bus()
elec_fwd_mon_ac_ok=get_param_handle("ELEC_FWD_MON_AC_OK")

local iCommandViewPitCameraMoveUp = 484
local iCommandViewPitCameraMoveDown = 485
local iCommandViewPitCameraMoveStop = 483

-----------------------------------------------------------------------------
-- Misc: seat adjustment
local seat_input = 0;

dev:listen_command(device_commands.seat_adjustment)

function post_initialize()

    startup_print("seat: postinit start")
    startup_print("seat: postinit end")

end

function SetCommand(command,value)
    -- print_message_to_user("Test value: "..value)
    if command == device_commands.seat_adjustment then
        seat_input = value
    end
end

function update_seat_adjustment()
    if elec_fwd_mon_ac_ok:get() == 1 then
        if seat_input == 1 then
            dispatch_action(nil, iCommandViewPitCameraMoveUp)
        elseif seat_input == -1 then
            dispatch_action(nil, iCommandViewPitCameraMoveDown)
        elseif seat_input == 0 then
            dispatch_action(nil, iCommandViewPitCameraMoveStop)
        end
    else
        dispatch_action(nil, iCommandViewPitCameraMoveStop)
    end
end

function update()
    update_seat_adjustment()
end

startup_print("seat: load end")
need_to_be_closed = false -- close lua state after initialization

