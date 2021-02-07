dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."sound_params.lua")

-- This file includes both gear and tailhook behavior/systems
--

-- gear behavior / modeling
--
--
-- design summary:
--   When raising gear:
--     all gear occupy full 10 seconds
--   When extending gear:
--     both gear start simultaneously
--     main gear takes 6 seconds, nose gear takes 10 seconds
--

local dev = GetSelf()

local update_time_step = 0.01 --was 0.05
make_default_activity(update_time_step)
local sensor_data = get_efm_sensor_data_overrides()
local efm_data_bus = get_efm_data_bus()

-- constants/conversion values

local rate_met2knot = 0.539956803456
local ias_knots = 0 -- * rate_met2knot

-- keys & devices

local Gear  = Keys.PlaneGear
local GearUp = Keys.PlaneGearUp
local GearDown = Keys.PlaneGearDown
local GearHandle = device_commands.Gear

local iCommandPlaneHook = 69    -- for SFM integration
local Hook = Keys.PlaneHook
local HookUp = Keys.PlaneHookUp
local HookDown = Keys.PlaneHookDown
local HookHandle = device_commands.Hook

local NWS_Engage = Keys.nws_engage
local NWS_Disengage = Keys.nws_disengage

-- GEAR constants/definitions/configuration
local GearNoseRetractTimeSec = 8    -- 8 seconds to retract
local GearNoseExtendTimeSec = 6     -- 6 seconds to extend

local GearMainTimeSec = 5           -- 5 seconds to retract and extend main gear

local LeftSideLead = 0.4 / (GearMainTimeSec) -- left side main gear leads right side, both opening and closing, by 0.7 seconds

local GEAR_NOSE_STATE = 1.0 -- 0 = retracted, 1.0 = extended -- "current" nose gear position
local GEAR_LEFT_STATE =	1.0 -- 0 = retracted, 1.0 = extended -- "current" main left gear position
local GEAR_RIGHT_STATE = 1.0 -- 0 = retracted, 1.0 = extended -- "current" main right gear position
local GEAR_TARGET =     1.0 -- 0 = retracted, 1.0 = extended -- "future" gear position



local GEAR_ERR   = 0

-- HOOK constants/definitions/configuration

local HOOK_TARGET =     0   -- 0 = retracted, 1 = extended -- "future" hook position
local hook_controller = Constant_Speed_Controller(0.01, 0.0, 1.0, 0.0)

local emergency_gear_countdown = 0

local ONCE = 1



dev:listen_command(Hook)
dev:listen_command(HookUp)
dev:listen_command(HookDown)
dev:listen_command(HookHandle)

dev:listen_command(Gear)
dev:listen_command(GearUp)
dev:listen_command(GearDown)
dev:listen_command(GearHandle)
dev:listen_command(device_commands.emer_gear_release)
dev:listen_command(NWS_Engage)
dev:listen_command(NWS_Disengage)



function SetCommand(command,value)
	if command == Hook then
        dev:performClickableAction(HookHandle, 1-HOOK_TARGET, false)    -- send the object click when user presses key, with invert
    elseif command == HookUp then
        dev:performClickableAction(HookHandle, 0, false)                -- send the object click when user presses key, force 0
    elseif command == HookDown then
        dev:performClickableAction(HookHandle, 1, false)                -- send the object click when user presses key, force 1
    elseif command == HookHandle then
        if value ~= HOOK_TARGET then
            HOOK_TARGET = value
        end
    end
--]]
	--print_message_to_user("Command: ".. command)
    local retraction_release_solenoid = get_elec_primary_ac_ok()
    local gear_handle_pos = get_cockpit_draw_argument_value(8)  -- 1==down, 0==up
    -- TODO: prevent gear handle being moved if retraction_release_solenoid is false
    if command == Gear then
        if gear_handle_pos==1 then
            if not get_elec_retraction_release_ground() then
                dev:performClickableAction(GearHandle, 0, false)
            end
        elseif gear_handle_pos==0 then
            dev:performClickableAction(GearHandle, 1, false)
        end
    elseif command == GearUp then
        if (get_elec_retraction_release_airborne()) then
            dev:performClickableAction(GearHandle, 0, false)                -- gear handle animation:  0 = retracted, 1 = extended
        end
    elseif command == GearDown then
        dev:performClickableAction(GearHandle, 1, false)                -- gear handle animation:  0 = retracted, 1 = extended
    elseif command == GearHandle then
        if value ~= GEAR_TARGET then
            if get_hyd_utility_ok() then
                GEAR_TARGET = value
                dispatch_action(nil,iCommandPlaneGear)
            end
        end
    elseif command == device_commands.emer_gear_release then
        if (value==1)  then
            emergency_gear_countdown = 0.25 -- seconds until T-handle bungees back
            if GEAR_ERR==0 then -- necessary to differentiate from gear error?
                if gear_handle_pos == 1 then  -- gear handle down
                    if not get_hyd_utility_ok() then
                        -- print_message_to_user("Emergency gear release")
                        GEAR_ERR = 1 -- necessary to differentiate from gear error?
                        GEAR_TARGET = 1
                    end
                end
            end
        end
	elseif command == NWS_Engage then
		if get_hyd_utility_ok() then
			efm_data_bus.fm_setNWS(1.0)
		else
			efm_data_bus.fm_setNWS(0.0)
		end
	elseif command == NWS_Disengage then
		efm_data_bus.fm_setNWS(0.0)
    end
end

function post_initialize()
    local wowml = sensor_data.getWOW_LeftMainLandingGear()
    local gear_clickable_ref = get_clickable_element_reference("PNT_8")
	
	local birth = LockOn_Options.init_conditions.birth_place
	if birth=="GROUND_HOT" or birth=="GROUND_COLD" then
        GEAR_NOSE_STATE = 1
        GEAR_RIGHT_STATE = 1
        GEAR_LEFT_STATE = 1
        GEAR_TARGET = 1
	elseif birth=="AIR_HOT" then
		GEAR_NOSE_STATE = 0
       GEAR_RIGHT_STATE = 0
       GEAR_LEFT_STATE = 0
       GEAR_TARGET = 0
	end

    dev:performClickableAction(device_commands.Gear,GEAR_TARGET,true)   -- sync handle to gear state
    gear_clickable_ref:hide(GEAR_TARGET==1)

    --set_aircraft_draw_argument_value(0,GEAR_NOSE_STATE)     -- nose gear draw angle
    --set_aircraft_draw_argument_value(3,GEAR_RIGHT_STATE)    -- right gear draw angle
    --set_aircraft_draw_argument_value(5,GEAR_LEFT_STATE)     -- left gear draw angle

    set_aircraft_draw_argument_value(25,HOOK_TARGET)
end


local gear_nose_retract_increment = update_time_step / GearNoseRetractTimeSec
local gear_nose_extend_increment = update_time_step / GearNoseExtendTimeSec
local gear_main_increment = update_time_step / GearMainTimeSec
local prev_retraction_release_airborne=get_elec_retraction_release_airborne()
local gear_light_param = get_param_handle("GEAR_LIGHT")
local dev_gear_nose = get_param_handle("GEAR_NOSE")
local dev_gear_left = get_param_handle("GEAR_LEFT")
local dev_gear_right = get_param_handle("GEAR_RIGHT")


local GEAR_POD_CLOSE = 0.1
local GEAR_POD_OPEN = 0.9

function update_gear()
    local gear_handle_pos = get_cockpit_draw_argument_value(8)  -- 1==down, 0==up
    local retraction_release_solenoid = get_elec_primary_ac_ok()    -- according to NATOPS, if system is on emer gen power, the safety solenoid opens, allowing the gear handle to be moved up and gear retracted.  However, see gyrovague's notes at end of this file.
    local retraction_release_airborne = get_elec_retraction_release_airborne()
    -- gear retraction is allowed if retraction_release_solenoid is powered AND aircraft is airborne.
    local allowRetract = (retraction_release_solenoid) and (retraction_release_airborne)
    --[[
    To prevent movement of the landing gear handle to
    UP when the aircraft is on the ground , the landing
    gear handle is latched in the DOWN position. In
    normal operation , the retraction release switch
    located on the left main landing gear strut is actuated
    when the aircraft becomes airborne and the landing
    gear struts extend , energizing the safety solenoid.
    The solenoid then unlatches the handle
    --]]
    if prev_retraction_release_airborne ~= retraction_release_airborne then
        local gear_clickable_ref = get_clickable_element_reference("PNT_8")
        prev_retraction_release_airborne = retraction_release_airborne
        if gear_clickable_ref then
            gear_clickable_ref:hide(not retraction_release_airborne)  -- make non-clickable if not airborne, and clickable when airborne
        end
    end

    -- landing gear over-speed detection
    ias_knots = sensor_data.getIndicatedAirSpeed() * 3.6 * rate_met2knot
    if ias_knots > 280 then 
        if GEAR_ERR==0 and (GEAR_LEFT_STATE > 0.2 or GEAR_RIGHT_STATE > 0.2  or GEAR_NOSE_STATE > 0.2) then
            GEAR_ERR = 1
            -- TODO: maybe some aircraft animation showing gear panels damaged or gear landing light ripped away etc.
            -- print_message_to_user("Landing gear overspeed damage!") -- delete me once we have a sound effect or other notification
            sound_params.snd_inst_damage_gear_overspeed:set(1.0)
        else
            sound_params.snd_inst_damage_gear_overspeed:set(0.0)
        end
    end
    
    sound_params.snd_cont_gear_mov:set(0.0)
    sound_params.snd_inst_gear_stop:set(1.0)

    sound_params.snd_inst_r_gear_pod_open:set(0.0)
    sound_params.snd_inst_r_gear_pod_close:set(0.0)

    sound_params.snd_inst_l_gear_pod_open:set(0.0)
    sound_params.snd_inst_l_gear_pod_close:set(0.0)

    sound_params.snd_inst_c_gear_pod_open:set(0.0)
    sound_params.snd_inst_c_gear_pod_close:set(0.0)

    sound_params.snd_inst_l_gear_end_in:set(0.0)
    sound_params.snd_inst_l_gear_end_out:set(0.0)

    sound_params.snd_inst_r_gear_end_in:set(0.0)
    sound_params.snd_inst_r_gear_end_out:set(0.0)

    sound_params.snd_inst_c_gear_end_in:set(0.0)
    sound_params.snd_inst_c_gear_end_out:set(0.0)

    if GEAR_NOSE_STATE == GEAR_TARGET then
        if GEAR_TARGET == 1.0 then
            sound_params.snd_inst_c_gear_end_out:set(1.0)
        else
            sound_params.snd_inst_c_gear_end_in:set(1.0)
        end
    end

    if GEAR_NOSE_STATE == GEAR_TARGET then
        if GEAR_TARGET == 1.0 then
            sound_params.snd_inst_c_gear_end_out:set(1.0)
        else
            sound_params.snd_inst_c_gear_end_in:set(1.0)
        end
    end

    if GEAR_LEFT_STATE == GEAR_TARGET then
        if GEAR_TARGET == 1.0 then
            sound_params.snd_inst_l_gear_end_out:set(1.0)
        else
            sound_params.snd_inst_l_gear_end_in:set(1.0)
        end
    end

    if GEAR_RIGHT_STATE == GEAR_TARGET then
        if GEAR_TARGET == 1.0 then
            sound_params.snd_inst_r_gear_end_out:set(1.0)
        else
            sound_params.snd_inst_r_gear_end_in:set(1.0)
        end
    end

    

    -- gear movement is dependent on operational utility hydraulics.
    -- gear will be stuck in transit if hydraulic fails during transit.

    local gear_in_transit = false

    if get_hyd_utility_ok() or GEAR_ERR == 1 then
        -- make primary nosegear adjustments if needed
        if GEAR_TARGET ~= GEAR_NOSE_STATE then

            if math.abs(GEAR_NOSE_STATE - GEAR_TARGET) < gear_main_increment then
                GEAR_NOSE_STATE = GEAR_TARGET
            end

            if GEAR_NOSE_STATE < GEAR_TARGET or GEAR_ERR==1 then

                if GEAR_TARGET - GEAR_NOSE_STATE >= GEAR_POD_OPEN then
                    sound_params.snd_inst_c_gear_pod_open:set(1.0)
                end

                GEAR_NOSE_STATE = GEAR_NOSE_STATE + gear_nose_extend_increment
                gear_in_transit = true
                if GEAR_ERR == 1 then -- extend more quickly (drop by gravity and ram air pressure)
                    GEAR_NOSE_STATE = GEAR_NOSE_STATE + 2*gear_nose_extend_increment
                end
            elseif GEAR_NOSE_STATE > GEAR_TARGET then

                if GEAR_NOSE_STATE - GEAR_TARGET <= GEAR_POD_CLOSE then
                    sound_params.snd_inst_c_gear_pod_close:set(1.0)
                end

                if GEAR_ERR == 0 and allowRetract then
                    GEAR_NOSE_STATE = GEAR_NOSE_STATE - gear_nose_retract_increment
                    gear_in_transit = true
                end
            end
        end

        -- make primary main gear adjustments if needed
        if GEAR_TARGET ~= GEAR_LEFT_STATE or GEAR_TARGET ~= GEAR_RIGHT_STATE then

            if math.abs(GEAR_LEFT_STATE - GEAR_TARGET) < gear_main_increment then
                GEAR_LEFT_STATE = GEAR_TARGET
            end

            if math.abs(GEAR_RIGHT_STATE - GEAR_TARGET) < gear_main_increment then
                GEAR_RIGHT_STATE = GEAR_TARGET
            end


            -- left gear moves first, both up and down
            if GEAR_LEFT_STATE < GEAR_TARGET or GEAR_ERR==1 then

                if GEAR_TARGET - GEAR_LEFT_STATE >= GEAR_POD_OPEN then
                    sound_params.snd_inst_l_gear_pod_open:set(1.0)
                end

                -- extending
                GEAR_LEFT_STATE = GEAR_LEFT_STATE + gear_main_increment
                gear_in_transit = true
                if GEAR_ERR == 1 then -- extend more quickly (drop by gravity and ram air pressure)
                    GEAR_LEFT_STATE = GEAR_LEFT_STATE + 2*gear_main_increment
                end
            elseif GEAR_LEFT_STATE > GEAR_TARGET then

                if GEAR_LEFT_STATE - GEAR_TARGET <= GEAR_POD_CLOSE then
                    sound_params.snd_inst_l_gear_pod_close:set(1.0)
                end

                if GEAR_ERR == 0 and allowRetract then
                    GEAR_LEFT_STATE = GEAR_LEFT_STATE - gear_main_increment
                    gear_in_transit = true
                end
            end

            -- right gear lags left gear by LeftSideLead seconds
            if GEAR_RIGHT_STATE < GEAR_TARGET or GEAR_ERR==1 then

                if GEAR_TARGET - GEAR_RIGHT_STATE >= GEAR_POD_OPEN then
                    sound_params.snd_inst_r_gear_pod_open:set(1.0)
                end

                if GEAR_LEFT_STATE > LeftSideLead then
                    GEAR_RIGHT_STATE = GEAR_RIGHT_STATE + gear_main_increment
                    gear_in_transit = true
                    if GEAR_ERR == 1 then -- extend more quickly (drop by gravity and ram air pressure)
                        GEAR_RIGHT_STATE = GEAR_RIGHT_STATE + 2*gear_main_increment
                    end
                end
            elseif GEAR_RIGHT_STATE > GEAR_TARGET then

                if GEAR_RIGHT_STATE - GEAR_TARGET <= GEAR_POD_CLOSE then
                    sound_params.snd_inst_r_gear_pod_close:set(1.0)
                end

                if GEAR_LEFT_STATE < (1-LeftSideLead) then
                    if GEAR_ERR == 0 and allowRetract then
                        GEAR_RIGHT_STATE = GEAR_RIGHT_STATE - gear_main_increment
                        gear_in_transit = true
                    end
                end
            end
        end
    end

    if gear_in_transit then
        sound_params.snd_cont_gear_mov:set(1.0)
        sound_params.snd_inst_gear_stop:set(0.0)
    end

    -- handle rounding errors induced by non-modulo increment remainders
    if GEAR_NOSE_STATE < 0 then
        GEAR_NOSE_STATE = 0
    elseif GEAR_NOSE_STATE > 1 then
        GEAR_NOSE_STATE = 1
    end

    if GEAR_LEFT_STATE < 0 then
        GEAR_LEFT_STATE = 0
    elseif GEAR_LEFT_STATE > 1 then
        GEAR_LEFT_STATE = 1
    end

    if GEAR_RIGHT_STATE < 0 then
        GEAR_RIGHT_STATE = 0
    elseif GEAR_RIGHT_STATE > 1 then
        GEAR_RIGHT_STATE = 1
    end
	
	if not get_hyd_utility_ok() then
		efm_data_bus.fm_setNWS(0.0)
	end
	
	efm_data_bus.fm_setNoseGear(GEAR_NOSE_STATE)
	efm_data_bus.fm_setLeftGear(GEAR_LEFT_STATE)
	efm_data_bus.fm_setRightGear(GEAR_RIGHT_STATE)

    --set_aircraft_draw_argument_value(0,GEAR_NOSE_STATE) -- nose gear draw angle
    --set_aircraft_draw_argument_value(3,GEAR_RIGHT_STATE) -- right gear draw angle
    --set_aircraft_draw_argument_value(5,GEAR_LEFT_STATE) -- left gear draw angle

    -- reflect gear state on gear-flaps indicator panel
    

	

    if get_elec_primary_dc_ok() then
        --[[if GEAR_NOSE_STATE == 0 or GEAR_NOSE_STATE == 1 then
            dev_gear_nose:set(GEAR_NOSE_STATE)
        else
            dev_gear_nose:set(0.5)
        end

        if GEAR_LEFT_STATE == 0 or GEAR_LEFT_STATE == 1 then
            dev_gear_left:set(GEAR_LEFT_STATE)
        else
            dev_gear_left:set(0.5)
        end

        if GEAR_RIGHT_STATE == 0 or GEAR_RIGHT_STATE == 1 then
            dev_gear_right:set(GEAR_RIGHT_STATE)
        else
            dev_gear_right:set(0.5)
        end
        --]]
        dev_gear_nose:set(GEAR_NOSE_STATE)
        dev_gear_left:set(GEAR_LEFT_STATE)
        dev_gear_right:set(GEAR_RIGHT_STATE)
    end
    if emergency_gear_countdown > 0 then
        emergency_gear_countdown = emergency_gear_countdown - update_time_step
        if emergency_gear_countdown<=0 then
            emergency_gear_countdown = 0
            dev:performClickableAction(device_commands.emer_gear_release,0,false)
        end
    end

    if ( ((GEAR_NOSE_STATE+GEAR_LEFT_STATE+GEAR_RIGHT_STATE)/3) ~= gear_handle_pos) and get_elec_primary_ac_ok() then
        gear_light_param:set(1.0)
    else
        gear_light_param:set(0.0)
    end

    if GEAR_ERR==1 and get_elec_external_power() then
        -- pretend ground crew reset gear fault
        GEAR_ERR = 0
        print_message_to_user("Ground crew reset landing gear")
    end
end

local tail_hook_param = get_param_handle("D_TAIL_HOOK")
function update_hook()
    -- NOTE: we do not need to draw this ourselves, SFM always draws it based on built-in capabilities
    hook_controller:update(HOOK_TARGET)

    set_aircraft_draw_argument_value(25,hook_controller:get_position())

    -- mirror tail_hook to in-cockpit tailhook lever
    -- usually done automatically by clickabledata.lua, but DCS replay issue is forcing us to remove
    -- clickable behavior on the tail hook lever, so now we're implementing it as parametrized gauge
    --local tail_hook = get_aircraft_draw_argument_value(25)
    --tail_hook_param:set(hook_controller:get_position())
end

function update()
    update_gear()
    update_hook()
end

need_to_be_closed = false -- close lua state after initialization

--[[
NATOPS notes
pg 1-29
To prevent movement of the landing gear handle to
UP when the aircraft is on the ground, the landing
gear handle is latched in the DOWN position. In
normal operation, the retraction release switch
located on the left main landing gear strut, is actuated
when the aircraft becomes airborne and the landing
gear struts extend, energizing the safety solenoid.
The solenoid then unlatches the handle. On emergency
generator power, the retraction release safety
solenoid is deenergized. If it should become necessary
to retract the landing gear while on the ground,
the serrated end of the latch on the landing gear
control panel must be moved aft to unlatch the
landing gear handle.

  gyrovague: however, figure FO-5 for A-4E/F shows RETRACTION RELEASE
    SOLENOID on the primary AC bus for A-4E, and primary AC bus
    does have power on emergency generator. Fig Fo-5 for A-4G shows
    RETRACTION RELEASE SOLENOID on the monitored DC bus, which doesn't
    have power on emergency generator.

pg 1-30
A warning light in the wheel-shaped handle of the
control comes on when the handle is moved to either
of its two positions. The light remains on until the
wheels are locked in either the up or down position.
The position of the wheels is shown on the wheels
and flaps position indicator on the left console. A
flasher-type wheels warning light (figures 1-5 and
1-6) i s installed beneath the upper left side of the
glareshield adjacent to the LABS light. With the
wing flap handle at any position other than the UP
detent and the landing gear up or unsafe, retarding
the throttle below approximately 92 percent rpm
causes the WHEELS warning light to flash, informing
the pilot of a possible unsafe condition.

In the event of utility hydraulic system failure, the
landing gear may be lowered manually by means of
the emergency landing gear release T -handle (figures
1-5 and 1-6) on the extreme left side of the
cockpit, above the left console. When the landing
gear control is moved to DOWN and the emergency
landing gear release handle is pulled, the landing
gear doors are unlatched, allowing the landing gear
to drop into the airstream. The landing gear extends
and locks by a combination of gravity and ram air
force

--]]