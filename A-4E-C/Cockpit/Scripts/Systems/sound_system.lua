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

    engine_wind_pitch = {
        curve = {0.30, 0.61, 0.85, 0.99, 1.05, 1.09, 1.1235},
        min = 1.0,
        max = 100.0,
    }

    engine_wind_volume = {
        curve = {0.00, 0.72, 0.85, 0.93, 0.97, 0.99},
        min = 1.0,
        max = 100.0,
    }

    engine_low_pitch = {
        curve = {0.30, 0.61, 0.85, 0.99, 1.05, 1.09, 1.1235},
        min = 1.0,
        max = 100.0,
    }

    engine_low_volume = {
        curve = {0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1},
        min = 11.0,
        max = 100.0,
    }

    engine_high_pitch = {
        curve = {0.30, 0.61, 0.85, 0.99, 1.05, 1.09, 1.1235},
        min = 1.0,
        max = 100.0,
    }

    engine_high_volume = {
        curve = {0.00, 0.10, 0.45, 0.67, 0.81, 0.93, 1.00},
        min = 56.0,
        max = 100.0,
    }

    sounds = {
        --DEBUG TEST SOUNDS
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a4e-debugtest05", "SND_CONT_TEST_05", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a4e-debugtest10", "SND_CONT_TEST_10", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a4e-debugtest15", "SND_CONT_TEST_15", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a4e-debugtest20", "SND_CONT_TEST_20", SOUND_CONTINUOUS),

        --AIRFLOW ADDITIVES
        --adjustable surfaces
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowSpoiler", "FM_SPOILERS", SOUND_ALWAYS, 18.0, 51.5),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowFlaps", "FM_FLAPS", SOUND_ALWAYS, 18.0, 51.5),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowSpeedbrake", "FM_BRAKES", SOUND_ALWAYS, 26.0, 77.0),
        --gear
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowGear_C", "FM_GEAR_NOSE", SOUND_ALWAYS, 20.5, 62.0),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowGear_L", "FM_GEAR_LEFT", SOUND_ALWAYS, 20.5, 62.0),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_AirflowGear_R", "FM_GEAR_RIGHT", SOUND_ALWAYS, 20.5, 62.0),

        --ENVIRONMENTAL
        --damage
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_DamageGearOverspeed", "SND_INST_DAMAGE_GEAR_OVERSPEED", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitStructuralDamage", "SND_ALWS_DAMAGE_AIRFRAME_STRESS", SOUND_ALWAYS, nil, nil, 1.0, 0.25),
        --engine
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitAvionics", "SND_INST_AVIONICS_WHINE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineIgniterWhirr", "SND_INST_ENGINE_IGNITER_WHIRR", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineIgniterSpark", "SND_ALWS_ENGINE_IGNITER_SPARK", SOUND_ALWAYS, nil, nil, 1.0, 0.1),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineWindUp", "SND_INST_ENGINE_WIND_UP", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineWindDown", "SND_INST_ENGINE_WIND_DOWN", SOUND_ONCE),


        Sound_Player.new_always_controlled(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineWindConstant", "RPM", engine_wind_volume, engine_wind_pitch),
        Sound_Player.new_always_controlled(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineOperationLo", "RPM", engine_low_volume, engine_low_pitch),
        Sound_Player.new_always_controlled(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineOperationHi", "RPM", engine_high_volume, engine_high_pitch),

        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_EngineCompressorStall", "SND_INST_ENGINE_STALL", SOUND_ONCE),
        --gear pod doors
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodClose_L", "SND_INST_L_GEAR_POD_CLOSE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodOpen_L", "SND_INST_L_GEAR_POD_OPEN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodClose_R", "SND_INST_R_GEAR_POD_CLOSE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodOpen_R", "SND_INST_R_GEAR_POD_OPEN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodClose_C", "SND_INST_C_GEAR_POD_CLOSE", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearPodOpen_C", "SND_INST_C_GEAR_POD_OPEN", SOUND_ONCE),
        --gear pod travel end
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndIn_L", "SND_INST_L_GEAR_END_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndOut_L", "SND_INST_L_GEAR_END_OUT", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndIn_R", "SND_INST_R_GEAR_END_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndOut_R", "SND_INST_R_GEAR_END_OUT", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndIn_C", "SND_INST_C_GEAR_END_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearEndOut_C", "SND_INST_C_GEAR_END_OUT", SOUND_ONCE),
        --rattle and rumble
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitRumble", "SND_ALWS_COCKPIT_RUMBLE", SOUND_ALWAYS, nil, nil, 1.0, 2.0 / device_timer_dt ),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitRattle", "SND_ALWS_COCKPIT_RATTLE", SOUND_ALWAYS, nil, nil, 1.0, 2.0 / device_timer_dt ),
        --refueling
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitRefuel", "SND_CONT_FUEL_INTAKE", SOUND_CONTINUOUS),
        --slats
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsLeftIn", "SND_INST_L_SLAT_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsLeftOut", "SND_INST_L_SLAT_OUT", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsRightIn", "SND_INST_R_SLAT_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitSlatsRightOut", "SND_INST_R_SLAT_OUT", SOUND_ONCE),
        --wheels
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitTouchdownN", "SND_INST_WHEELS_TOUCHDOWN_N", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitTouchdownL", "SND_INST_WHEELS_TOUCHDOWN_L", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitTouchdownR", "SND_INST_WHEELS_TOUCHDOWN_R", SOUND_ONCE),

        --HYDRAULICS
        --canopy
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyOpenMove", "SND_CONT_CANOPY_MOV_OPEN", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyCloseMove", "SND_CONT_CANOPY_MOV_CLOSE", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyCloseStop", "SND_INST_CANOPY_CLOSE_STOP", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyOpenStop", "SND_INST_CANOPY_OPEN_STOP", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyOpenSeal", "SND_INST_CANOPY_MOV_SEAL_OPEN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsCanopyCloseSeal", "SND_INST_CANOPY_MOV_SEAL_CLOSE", SOUND_ONCE),
        --flaps
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsFlapsMove", "SND_CONT_FLAPS_MOVE", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsFlapsStop", "SND_INST_FLAPS_STOP", SOUND_ONCE),
        --gear
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearMove", "SND_CONT_GEAR_MOV", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsGearStop", "SND_INST_GEAR_STOP", SOUND_ONCE),
        --supplemental
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitEmerSpeedbrakeIn", "SND_INST_EMER_SPEEDBRAKE_IN", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_CockpitEmerSpeedbrakeOut", "SND_INST_EMER_SPEEDBRAKE_OUT", SOUND_ONCE),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsSpeedbrakeMove", "SND_CONT_HYD_MOV", SOUND_CONTINUOUS),
        Sound_Player(sndhost_cockpit, "Aircrafts/A-4E-C/a-4e_HydraulicsSpeedbrakeStop", "SND_INST_HYD_STOP", SOUND_ONCE),

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
