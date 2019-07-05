dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local SOUND_SYSTEM = GetSelf()
local update_time_step = 0.02  --20 time per second
make_default_activity(update_time_step)
device_timer_dt     = 0.02  	--0.2  

local sensor_data = get_base_data()

function debug_print(message)
    -- print_message_to_user(message)
end

-- params
local param_catapult_takeoff = get_param_handle("SOUND_CAT_TAKEOFF")


function post_initialize()
    -- initialise soundhosts
    sndhost_cockpit             = create_sound_host("COCKPIT","2D",0,0,0) -- TODO: look into defining this sound host for HEADPHONES/HELMET

    -- initialise sounds
    snd_catapultTakeoff = sndhost_cockpit:create_sound("Aircrafts/A-4E-C/A4E-CarrierCatapultTakeoff_In")
    snd_catapultLaunchbarDisconnect = sndhost_cockpit:create_sound("Aircrafts/A-4E-C/A4E-CarrierLaunchBarDisconnect")
    
    param_catapult_takeoff:set(-1)
end

function update()
    playSoundOnceByParam(snd_catapultTakeoff, snd_catapultLaunchbarDisconnect, param_catapult_takeoff)
end

-- Reset = -1, Play == 1
function playSoundOnceByParam(start_sound, stop_sound, param)
    if param:get() > -1 then
        if start_sound then
            if param:get() == 0 and start_sound:is_playing() then
                start_sound:stop()
                if stop_sound then
                    stop_sound:play_once()
                end
            else
                start_sound:play_once()
            end
        end
        param:set(-1)
    end
end

need_to_be_closed = false -- close lua state after initialization