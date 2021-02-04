dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."sound_class.lua")

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


local sounds

function post_initialize()
    -- initialise soundhosts
    sndhost_cockpit             = create_sound_host("COCKPIT","2D",0,0,0) -- TODO: look into defining this sound host for HEADPHONES/HELMET


    sounds = {
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsFlapsMove", "SND_CONT_FLAPS_MOVE", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsFlapsStop", "SND_INST_FLAPS_STOP", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitRattle", "SND_ALWS_COCKPIT_RATTLE", SOUND_ALWAYS, nil, nil, 1.0, 2.0 / device_timer_dt ),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyOpenMove", "SND_CONT_CANOPY_MOV_OPEN", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyCloseMove", "SND_CONT_CANOPY_MOV_CLOSE", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyOpenSeal", "SND_INST_CANOPY_MOV_SEAL_OPEN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyCloseSeal", "SND_INST_CANOPY_MOV_SEAL_CLOSE", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyCloseSeal", "SND_INST_CANOPY_CLOSE_STOP", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyOpenStop", "SND_INST_CANOPY_OPEN_STOP", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodClose_L", "SND_INST_L_GEAR_POD_CLOSE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodOpen_L", "SND_INST_L_GEAR_POD_OPEN", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodClose_R", "SND_INST_R_GEAR_POD_CLOSE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodOpen_R", "SND_INST_R_GEAR_POD_OPEN", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodClose_C", "SND_INST_C_GEAR_POD_CLOSE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodOpen_C", "SND_INST_C_GEAR_POD_OPEN", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndIn_L", "SND_INST_L_GEAR_END_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndOut_L", "SND_INST_L_GEAR_END_OUT", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndIn_R", "SND_INST_R_GEAR_END_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndOut_R", "SND_INST_R_GEAR_END_OUT", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndIn_C", "SND_INST_C_GEAR_END_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndOut_C", "SND_INST_C_GEAR_END_OUT", SOUND_ONCE),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearMove", "SND_CONT_GEAR_MOV", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearStop", "SND_INST_GEAR_STOP", SOUND_ONCE),

        

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowGear_C", "FM_GEAR_NOSE", SOUND_ALWAYS, 20.5, 62.0),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowGear_L", "FM_GEAR_LEFT", SOUND_ALWAYS, 20.5, 62.0),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowGear_R", "FM_GEAR_RIGHT", SOUND_ALWAYS, 20.5, 62.0),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowSpoiler", "FM_SPOILERS", SOUND_ALWAYS, 18.0, 51.5),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowFlaps", "FM_FLAPS", SOUND_ALWAYS, 18.0, 51.5),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowSpeedbrake", "FM_BRAKES", SOUND_ALWAYS, 26.0, 77.0),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsLeftIn", "SND_INST_L_SLAT_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsLeftOut", "SND_INST_L_SLAT_OUT", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsRightIn", "SND_INST_R_SLAT_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsRightOut", "SND_INST_R_SLAT_OUT", SOUND_ONCE),

    }




    -- initialise sounds
    snd_catapultTakeoff = sndhost_cockpit:create_sound("Aircrafts/A-4E-C/A4E-CarrierCatapultTakeoff_In")
    snd_catapultLaunchbarDisconnect = sndhost_cockpit:create_sound("Aircrafts/A-4E-C/A4E-CarrierLaunchBarDisconnect")
    
    param_catapult_takeoff:set(-1)
end

function update()
    
    for index, sound in pairs(sounds) do
        sound:update()
    end


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