-- Aircraft Flight Control System  (a.k.a. autopilot)
-- includes the APC (Approach Power Compensator)
-- Line 668 changes because of new Catapult logic
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/stores_config.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

startup_print("afcs: load")

local dev = GetSelf()

--local degrees_per_radian = 57.2957795
--local feet_per_meter_per_minute = 196.8
local meters_to_feet = 3.2808399
local GALLON_TO_KG = 3.785 * 0.8
local KG_TO_POUNDS = 2.20462
local MPS_TO_KNOTS = 1.94384
local RADIANS_TO_DEGREES = 57.2958

local function debug_print_apc(x)
    --print_message_to_user(x)
end

local function debug_print_afcs(x)
    --print_message_to_user(x)
end

local update_time_step = 0.02
make_default_activity(update_time_step) --update will be called 50 times per second

local sensor_data = get_efm_sensor_data_overrides()
local efm_data_bus = get_efm_data_bus()

local ThrottleUp = 1032
local ThrottleDown = 1033
local ThrottleAxis = 2004


local AFCS_HDG_100s_param = get_param_handle("AFCS_HDG_100s")
local AFCS_HDG_10s_param = get_param_handle("AFCS_HDG_10s")
local AFCS_HDG_1s_param = get_param_handle("AFCS_HDG_1s")
AFCS_HDG_100s_param:set(0.0)
AFCS_HDG_10s_param:set(0.0)
AFCS_HDG_1s_param:set(0.0)

local current_heading_setting=0 -- integer 0 to 360

local hdg_value = WMA_wrap(0.3,0,0,359.999)
local apc_pid = PID(5, 0.02, 0.1, -100, 40, 0.01)   -- create the PID for the APC, values found experimentally

dev:listen_command(device_commands.afcs_standby)
dev:listen_command(device_commands.afcs_engage)
dev:listen_command(device_commands.afcs_hdg_sel)
dev:listen_command(device_commands.afcs_alt)
dev:listen_command(device_commands.afcs_hdg_set)
dev:listen_command(device_commands.afcs_stab_aug)
dev:listen_command(device_commands.afcs_ail_trim)
dev:listen_command(Keys.AFCSOverride)
dev:listen_command(Keys.AFCSStandbyToggle)
dev:listen_command(Keys.AFCSEngageToggle)
dev:listen_command(Keys.AFCSAltitudeToggle)
dev:listen_command(Keys.AFCSHeadingToggle)
dev:listen_command(Keys.AFCSHeadingInc)
dev:listen_command(Keys.AFCSHeadingDec)
dev:listen_command(Keys.AFCSHotasMode)      -- for warthog
dev:listen_command(Keys.AFCSHotasPath)      -- for warthog
dev:listen_command(Keys.AFCSHotasAltHdg)    -- for warthog
dev:listen_command(Keys.AFCSHotasAlt)       -- for warthog
dev:listen_command(Keys.AFCSHotasEngage)    -- for warthog

dev:listen_command(Keys.RadarHoldToggle)    -- debug!
dev:listen_command(Keys.RadarHoldInc)
dev:listen_command(Keys.RadarHoldDec)
local radarHold = -100
dev:listen_command(Keys.SpeedHoldToggle)
dev:listen_command(Keys.SpeedHoldInc)
dev:listen_command(Keys.SpeedHoldDec)
local speedHold = -100

dev:listen_command(device_commands.apc_engagestbyoff)
dev:listen_command(device_commands.apc_hotstdcold)
dev:listen_command(Keys.APCEngageStbyOff)
dev:listen_command(Keys.APCHotStdCold)

dev:listen_command(Keys.Tune1)  -- debug tuning commands
dev:listen_command(Keys.Tune2)
dev:listen_command(Keys.Tune3)

local roll_trim_handle = get_param_handle("ROLL_TRIM")
local pitch_trim_handle = get_param_handle("PITCH_TRIM")
local trim_override_handle = get_param_handle("TRIM_OVERRIDE")
local apc_light = get_param_handle("APC_LIGHT")

-- AFCS initialization
afcs_standby_enabled = false
afcs_engage_enabled = false
afcs_hdg_sel_enabled = false
afcs_alt_hold_enabled = false
afcs_ail_trim_enabled = false
afcs_stab_aug_enabled = false
afcs_css_enabled = false
local afcs_hotas_mode = "afcs-hotas-alt-hdg"
css_ignore_time = 0
bank_hold_angle = 0
pitch_hold_angle = 0
altitude_hold_m = 0
local afcs_state = "afcs-off"
local roll_pid = PID(6, 0.05, 0.2, -100, 100, 0.01)   -- create the PID for bank angle control (aileron trim), values found experimentally
local pitch_pid = PID(6, 0.05, 0.2, -100, 100, 0.01)   -- create the PID for pitch angle control (elevator trim), values found experimentally
local altitude_pid = PID(1.5, 0.01, 0.11, -100, 100, 0.01)   -- create the PID for altitude control (elevator trim), values found experimentally

-- APC initialization
local apc_enabled = false
local apc_inputlist = {"OFF", "STBY", "ENGAGE"}     -- -1,0,1
local apc_input = "OFF"
local apc_modelist = {"COLD", "STD", "HOT"}         -- -1,0,1
local apc_warmup_timer = 99999
local apc_warm = false
local apc_state = "apc-off"

local Kp_handle = get_param_handle("Kp_DEBUG")      -- used for PID debug tuning, feel free to repurpose
local Ki_handle = get_param_handle("Ki_DEBUG")
local Kd_handle = get_param_handle("Kd_DEBUG")
local debug_pid = apc_pid

local fm_stab_aug = get_param_handle("FM_YAW_DAMPER")

function post_initialize()
    startup_print("afcs: postinit")
	
    local dev = GetSelf()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then --"GROUND_COLD","GROUND_HOT","AIR_HOT"
        -- set AFCS to standby
        dev:performClickableAction(device_commands.afcs_standby,1,false)
		 dev:performClickableAction(device_commands.afcs_stab_aug, 1, false)
        afcs_standby_enabled = true
        afcs_state = "afcs-stby"
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.afcs_standby,0,false)
        afcs_state = "afcs-off"
		 dev:performClickableAction(device_commands.afcs_stab_aug, 0, false)
    end

    dev:performClickableAction(device_commands.apc_engagestbyoff,-1,true)    -- disable APC by default

    -- for debug, set these for whichever PID is being tuned
    Kp_handle:set(debug_pid:get_Kp())
    Ki_handle:set(debug_pid:get_Ki())
    Kd_handle:set(debug_pid:get_Kd())

    startup_print("afcs: postinit end")
end

-- determine whether to go to heading hold or attitude hold mode, depending on aircraft roll state
function capture_afcs_attitude()
    local new_state=""
    local absroll=math.abs(sensor_data.getRoll())

    if absroll < 5*(2.0*math.pi/360.0) then  -- roll less than 5deg == heading hold mode
        bank_hold_angle = 0
    else
        bank_hold_angle = sensor_data.getRoll()*360.0/(2*math.pi)
    end
    new_state = "afcs-eng-attitude"
    pitch_hold_angle = sensor_data.getPitch()*360.0/(2*math.pi)
    debug_print_afcs("hold attitude: p:"..string.format("%.1f",pitch_hold_angle)..",r:"..string.format("%.1f",bank_hold_angle))
    -- TODO: check pitch less than 60, else refuse to engage

    return new_state
end

--[[
AFCS states:
afcs-off
afcs-stby
afcs-eng-attitude: attitude hold mode; pitch less than 60; hold bank between 5 and 70, or 0 when less than 5
afcs-eng-css: control stick steering mode (when stick is deflected above a threshold); hdg select and altitude hold turned off
afcs-eng-hdgselect: preselected heading, aircraft rolls to selected heading

altitude hold and stability augmentation are both orthogonal to the above states, and can be
enabled independently as long as AFCS is engaged

ground control bombing mode: no detail, need A-4 Tactical Manual NAVAIR 01-40AV—1T
--]]

-- "edge triggered" actions for each AFCS state (only on state changes)
function change_afcs_state(new_state)
    local old_state = afcs_state
    debug_print_afcs("afcs state: "..old_state.." -> "..new_state)
    local state=old_state
    -- procedures for exiting each state
    if state == "afcs-off" then
    elseif state == "afcs-stby" then
    elseif state == "afcs-eng-attitude" then
    elseif state == "afcs-eng-css" then
        afcs_css_enabled = false
    elseif state == "afcs-eng-hdgselect" then
        if new_state ~= "afcs-eng-hdgselect" then
            afcs_hdg_sel_enabled = false
        end
    end

    state=new_state
    -- procedures for entering each state
    if state == "afcs-off" then
    elseif state == "afcs-stby" then
    elseif state == "afcs-eng-attitude" then
        css_ignore_time = 0.5
    elseif state == "afcs-eng-css" then
        debug_print_afcs("control stick steering")
        afcs_css_enabled = true
        if old_state == "afcs-eng-attitude" or old_state == "afcs-eng-hdgselect" then
            dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
            dev:performClickableAction(device_commands.afcs_alt,0,false)
        end
    elseif state == "afcs-eng-hdgselect" then
        css_ignore_time = 0.5
        afcs_hdg_sel_enabled = true
    end

    afcs_state = new_state
end

--[[
old SFM autopilot actions (unused now)
local iCommandPlaneStabHbar = 389 -- Barometric Altitude Hold
local iCommandPlaneStabTangBank = 386 -- Attitude Hold
local iCommandPlaneStabCancel = 408 -- Autopilot Disengage

local iCommandPlaneAutopilot = 62
local iCommandPlaneAutopilotOverrideOn = 427
local iCommandPlaneAutopilotOverrideOff = 428
local iCommandPlaneRouteAutopilot = 429
local iCommandAutopilotEmergOFF_up = 297
local iCommandAutopilotEmergOFF = 538
local iCommandPlaneStabHbarBank = 387 -- altitude and roll hold
local iCommandPlaneStabHorizon = 388 -- level flight control
local iCommandPlaneStabHrad = 390 -- radar altitude hold
local iCommandPlaneStabHbarHeading = 636
local iCommandPlaneStabPathHold = 637
--]]

function SetCommand(command,value)
    -- "primary" control is the clickable device, key commands trigger the clickable actions...
    -- dev:performClickableAction(device_commands.xxx, value, false)
    --print_message_to_user("AFCS "..command..","..tostring(value))
    local current_afcs_state = afcs_state
    if command == device_commands.afcs_hdg_set then
        if value>0 then
            current_heading_setting=current_heading_setting+1
            if current_heading_setting>=360 then
                current_heading_setting=0
            end
        elseif value<0 then
            current_heading_setting=current_heading_setting-1
            if current_heading_setting<0 then
                current_heading_setting=359
            end
        end
        --print_message_to_user("hdg set:"..tostring(current_heading_setting))
    elseif command == Keys.AFCSHeadingInc then
        dev:performClickableAction(device_commands.afcs_hdg_set, 1, false)
    elseif command == Keys.AFCSHeadingDec then
        dev:performClickableAction(device_commands.afcs_hdg_set, -1, false)
    elseif command == Keys.AFCSOverride then
        dev:performClickableAction(device_commands.afcs_engage, 0, false)
    elseif command == device_commands.afcs_standby then
        if value == 0 then
            -- disable all toggle switches
            dev:performClickableAction(device_commands.afcs_engage,0,true)
            dev:performClickableAction(device_commands.afcs_stab_aug,0,false)
            afcs_standby_enabled = false
            change_afcs_state("afcs-off")
        else
            -- TODO: start 90s timer  (and e.g. make it not reset the PID controller to the correct current value if engaging before that)
            afcs_standby_enabled = true
            change_afcs_state("afcs-stby")
        end
    elseif command == Keys.AFCSHotasMode then
        if value == 1 then
            afcs_hotas_mode = "afcs-hotas-path"
        elseif value == 0 then
            afcs_hotas_mode = "afcs-hotas-alt-hdg"
        elseif value == -1 then
            afcs_hotas_mode = "afcs-hotas-alt"
        end
    elseif command == Keys.AFCSHotasPath then
        afcs_hotas_mode = "afcs-hotas-path"
    elseif command == Keys.AFCSHotasAltHdg then
        afcs_hotas_mode = "afcs-hotas-alt-hdg"
    elseif command == Keys.AFCSHotasAlt then
        afcs_hotas_mode = "afcs-hotas-alt"
    elseif command == Keys.AFCSHotasEngage then
        if afcs_engage_enabled then
            dev:performClickableAction(device_commands.afcs_engage, 0, false)
        else
            if afcs_hotas_mode == "afcs-hotas-path" then
                dev:performClickableAction(device_commands.afcs_engage, 1, false)
            elseif afcs_hotas_mode == "afcs-hotas-alt-hdg" then
                dev:performClickableAction(device_commands.afcs_engage, 1, false)
                dev:performClickableAction(device_commands.afcs_alt, 1, false)
                dev:performClickableAction(device_commands.afcs_hdg_sel, 1, false)
            elseif afcs_hotas_mode == "afcs-hotas-alt" then
                dev:performClickableAction(device_commands.afcs_engage, 1, false)
                dev:performClickableAction(device_commands.afcs_alt, 1, false)
            end
        end
    elseif command == Keys.AFCSStandbyToggle then
        if afcs_standby_enabled then
            dev:performClickableAction(device_commands.afcs_standby,0,false)
        else
            dev:performClickableAction(device_commands.afcs_standby,1,false)
        end
    elseif command == device_commands.afcs_engage then
        if value == 0 then
            -- disable AFCS  NATOPS 1-76
            --[[
            When this switch is placed in the OFF position both
            the heading select switch and the altitude switch
            return to the OFF position.
            --]]
            if afcs_engage_enabled then
                dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
                dev:performClickableAction(device_commands.afcs_alt,0,false)
                afcs_engage_enabled = false
                trim_override_handle:set(0)
                change_afcs_state("afcs-stby")
            end
        else
            -- TODO: check ADI OFF flag
            -- TODO: check 90s timer has elapsed
            if not afcs_engage_enabled then
                local abspitch=math.abs(sensor_data.getPitch())
                if afcs_standby_enabled and not afcs_ail_trim_enabled and abspitch<(60*2.0*math.pi/360.0) then
                    afcs_engage_enabled = true
                    local new_state=capture_afcs_attitude()

                    change_afcs_state(new_state)
                    roll_pid:reset(roll_trim_handle:get())
                    pitch_pid:reset(pitch_trim_handle:get())
                    trim_override_handle:set(1)
                else
                    dev:performClickableAction(device_commands.afcs_engage,0,false)
                end
            end
        end
    elseif command == Keys.AFCSEngageToggle then
        if afcs_engage_enabled then
            dev:performClickableAction(device_commands.afcs_engage, 0, false)
        else
            dev:performClickableAction(device_commands.afcs_engage, 1, false)
        end
    elseif command == device_commands.afcs_alt then
        if value == 1 then
            if not afcs_engage_enabled then
                dev:performClickableAction(device_commands.afcs_alt,0,false)
            else
                local cur_climb_rate = sensor_data.getVerticalVelocity()
                --[[
                The altitude hold mode may be engaged when the rate-
                of-change of altitude is less than 4000+-500 feet per
                minute. The aircraft will maintain the altitude at
                engagement. The aircraft automatically will pull out
                of its climb or dive and return to and maintain the
                engage altitude.
                --]]
                if (math.abs(cur_climb_rate*3.28084)<4000) then
                    css_ignore_time = 0.5
                    afcs_alt_hold_enabled = true
                    if radarHold > 0 then
                        altitude_hold_m = radarHold
                    else
                        altitude_hold_m = sensor_data.getBarometricAltitude()
                    end
                    altitude_pid:reset(pitch_trim_handle:get())
                    debug_print_afcs("altitude hold "..string.format("%.1f",altitude_hold_m).."m,"..string.format("%.1f",altitude_hold_m*3.28084).."'")
                    --[[
                    The mode cannot be engaged if any force is being
                    applied to the control stick. The switch will move
                    automatically to the OFF position whenever control
                    stick steering mode is engaged.
                    --]]
                end
            end
        else
            if afcs_alt_hold_enabled then
                debug_print_afcs("disable altitude")
                afcs_alt_hold_enabled = false
                if not afcs_css_enabled then
                    capture_afcs_attitude()
                    pitch_pid:reset(pitch_trim_handle:get())
                end
            end
        end
    elseif command == Keys.AFCSAltitudeToggle then
        if afcs_alt_hold_enabled then
            dev:performClickableAction(device_commands.afcs_alt, 0, false)
        else
            dev:performClickableAction(device_commands.afcs_alt, 1, false)
        end
    elseif command == device_commands.afcs_hdg_sel then
        if value == 1 then
            if not afcs_engage_enabled then
                dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
            else
                --dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
                roll_pid:reset(roll_trim_handle:get())
                change_afcs_state("afcs-eng-hdgselect")
            end
        else
            --[[
            If placed in the OFF position prior to the
            completion of a turn, the aircraft will roll smoothly
            to a level attitude and maintain the compass heading
            indicated at that time
            --]]
            if afcs_engage_enabled then
                if afcs_hdg_sel_enabled then
                    if not afcs_css_enabled then
                        capture_afcs_attitude()
                        bank_hold_angle=0
                        roll_pid:reset(roll_trim_handle:get())
                        change_afcs_state("afcs-eng-attitude")
                    end
                end
            end
        end
    elseif command == Keys.AFCSHeadingToggle then
        if afcs_hdg_sel_enabled then
            dev:performClickableAction(device_commands.afcs_hdg_sel, 0, false)
        else
            dev:performClickableAction(device_commands.afcs_hdg_sel, 1, false)
        end
    elseif command == device_commands.afcs_stab_aug then
        if value == 1 then
			if afcs_standby_enabled then
				afcs_stab_aug_enabled = true
			else
				dev:performClickableAction(device_commands.afcs_stab_aug,0,false)
			end
		 else
			afcs_stab_aug_enabled = false
	 	 end
    elseif command == device_commands.afcs_ail_trim then
        if value == 1 then
            if not afcs_ail_trim_enabled then
                afcs_ail_trim_enabled = true
                dev:performClickableAction(device_commands.afcs_engage,0,true)
            end
            --[[
            Movement of this
            switch to the EMER position also disengages and
            prevents reengagement of the AFCS, except stability
            augmentation, while in the EMER position. The
            AFCS can be reengaged after placing the switch in
            the NORM position.
            --]]
        else
            if afcs_ail_trim_enabled then
                afcs_ail_trim_enabled = false
            end
        end
    elseif command == device_commands.apc_engagestbyoff then
        apc_input = apc_inputlist[ round(value+2) ] -- convert -1,0,1 to 1,2,3
        --debug_print_apc("APC: enable set to "..apc_input)
    elseif command == device_commands.apc_hotstdcold then
        apc_mode = apc_modelist[ round(value+2) ]   -- convert -1,0,1 to 1,2,3
        --debug_print_apc("APC: mode set to "..apc_mode)
    elseif command == Keys.APCEngageStbyOff then
        dev:performClickableAction(device_commands.apc_engagestbyoff, value, false)
    elseif command == Keys.APCHotStdCold then
        dev:performClickableAction(device_commands.apc_hotstdcold, value, false)
--[[
    elseif command == Keys.Tune1 then
        apc_pid:set_Kp(apc_pid:get_Kp() + value*10)
        Kp_handle:set(apc_pid:get_Kp())
    elseif command == Keys.Tune2 then
        apc_pid:set_Ki(apc_pid:get_Ki() + value*10)
        Ki_handle:set(apc_pid:get_Ki())
    elseif command == Keys.Tune3 then
        apc_pid:set_Kd(apc_pid:get_Kd() + value*10)
        Kd_handle:set(apc_pid:get_Kd())
--]]
    elseif command == Keys.Tune1 then
        debug_pid:set_Kp(debug_pid:get_Kp() + value)
        Kp_handle:set(debug_pid:get_Kp())
    elseif command == Keys.Tune2 then
        debug_pid:set_Ki(debug_pid:get_Ki() + value/10.0)
        Ki_handle:set(debug_pid:get_Ki())
    elseif command == Keys.Tune3 then
        debug_pid:set_Kd(debug_pid:get_Kd() + value/10.0)
        Kd_handle:set(debug_pid:get_Kd())
    elseif command == Keys.RadarHoldToggle then
        if radarHold < 0 then
            radarHold = sensor_data.getRadarAltitude()
            debug_print_afcs("Radar Alt Hold: Enabled: "..radarHold*meters_to_feet)
        else
            radarHold = -100
            debug_print_afcs("Radar Alt Hold: Disabled")
        end
    elseif command == Keys.RadarHoldInc then
        if radarHold >= 10 then
            radarHold = round(radarHold * meters_to_feet, -1)
            radarHold = radarHold+10
            debug_print_afcs("Radar Alt Hold: "..radarHold)
            radarHold = radarHold / meters_to_feet
            altitude_hold_m = radarHold
        end
    elseif command == Keys.RadarHoldDec then
        if radarHold > 20 then
            radarHold = round(radarHold * meters_to_feet, -1)
            radarHold = radarHold-10
            debug_print_afcs("Radar Alt Hold: "..radarHold)
            radarHold = radarHold / meters_to_feet
            altitude_hold_m = radarHold
        end
    elseif command == Keys.SpeedHoldToggle then
        if speedHold < 0 then
            speedHold = sensor_data.getTrueAirSpeed()
            debug_print_afcs("TAS Hold: Enabled: "..speedHold*MPS_TO_KNOTS)
        else
            speedHold = -100
            debug_print_afcs("TAS Hold: Disabled")
        end
    elseif command == Keys.SpeedHoldInc then
        if speedHold >= 0 then
            speedHold = round((speedHold * MPS_TO_KNOTS)/5, 0)
            speedHold = (speedHold*5)+5
            debug_print_afcs("TAS Hold: "..speedHold)
            speedHold = speedHold / MPS_TO_KNOTS
        end
    elseif command == Keys.SpeedHoldDec then
        if speedHold >= 100 then
            speedHold = round((speedHold * MPS_TO_KNOTS)/5, 0)
            speedHold = (speedHold*5)-5
            debug_print_afcs("TAS Hold: "..speedHold)
            speedHold = speedHold / MPS_TO_KNOTS
        end
    end
end



local apc_throttle = 0
--[[
APC operation:

apc-off:
        - system de-energized
        - APC warning light off
        - if switch == "STBY", begin warmup timer, transition to apc-standby
apc-standby:
        - APC light on dash turns on
        - apc_warm = true when ~15s has elapsed
        - if apc_warm and switch == "ENGAGE", transition to apc-engaged
        - if ~apc_warm and switch == "ENGAGE", transition to apc-disengage
apc-engaged:
        - APC light on dash turns off
        - APC system functions normally
        - if pilot adjusts throttle manually, transition to apc-disengage
apc-disengage:
        - spring-loaded enable switch moves to "STBY" automatically
--]]

function update_apc()
    local timenow = get_model_time()

    --apc_throttle = apc_pid(sensor_data.getAngleOfAttack())
    local aoadeg
    local apc_target

    if speedHold > 0 then
        tas = -math.sqrt(sensor_data.getTrueAirSpeed())
        tastarget = -math.sqrt(speedHold)
    else
        aoadeg = math.deg(sensor_data.getAngleOfAttack())
        apc_target = 76.5725  -- (8.75^2)
    end

    if apc_mode == "HOT" then
        apc_target = 81       -- (9)^2
    elseif apc_mode == "COLD" then
        apc_target = 72.25       -- (8.5)^2
    end

    if speedHold > 0 then
        apc_throttle = apc_pid:run( tastarget, tas )
        --print_message_to_user(tastarget.." "..tas.." "..apc_throttle)
    else
        apc_throttle = apc_pid:run( apc_target, aoadeg*aoadeg )
    end

    if not get_elec_mon_dc_ok() then
        apc_light:set(0.0)
        apc_warm = false
        apc_warmup_timer = 99999
        if apc_state ~= "apc-off" then
            debug_print_apc("APC: 28V monitored DC power lost, disabling system")
            dev:performClickableAction(device_commands.apc_engagestbyoff, 0, false)
            apc_state = "apc-off"
        end
        return
    end

    if not apc_warm and timenow >= apc_warmup_timer and apc_state == "apc-standby" then
        apc_warm = true
        debug_print_apc("APC: warmup complete, time:"..timenow)
    end

    if apc_state == "apc-off" then
        apc_light:set(0.0)
        apc_warm = false
        if apc_input == "STBY" then
            debug_print_apc("APC: warmup starting, time:"..timenow)
            apc_warmup_timer = timenow+15
            apc_state = "apc-standby"
        elseif apc_input == "ENGAGE" then apc_state = "apc-disengage"
        end
    elseif apc_state == "apc-standby" then
        apc_light:set(1.0)
        if apc_input == "OFF" then apc_state = "apc-off"
        elseif apc_input == "ENGAGE" then apc_state = "apc-engaged"
        end
    elseif apc_state == "apc-disengage" then
        debug_print_apc("APC: disengaged")
        apc_state = "apc-standby"
        apc_input = "STBY"
        dev:performClickableAction(device_commands.apc_engagestbyoff, 0, true) -- bounces switch back to middle
    elseif apc_state == "apc-engaged" then
        if apc_input == "OFF" then apc_state = "apc-off"
        elseif apc_input == "STBY" then apc_state = "apc-standby"
        elseif not apc_warm then apc_state = "apc-disengage"
        else
            local tpos = sensor_data.getThrottleLeftPosition()
            local wow = sensor_data.getWOW_LeftMainLandingGear()
            if tpos < 0.25 or wow > 0 then
                apc_state = "apc-disengage"     -- kick APC to standby if pilot adjusts throttle below 25% or weight on wheels
            end
            -- APC will now operate
            apc_light:set(0.0)
            dispatch_action(nil, ThrottleAxis, (apc_throttle * 0.999))
        end
    end
end

function bank_hold_PID(bank_angle)
    -- control the roll trim to the bank angle
    -- TODO: integrate with trim system (provide offset inputs)
    local roll_angle = sensor_data.getRoll()*360.0/(2*math.pi)
    local roll_trim = roll_pid:run( bank_angle, roll_angle )
    if roll_trim>1 then
        roll_trim=1
    elseif roll_trim<-1 then
        roll_trim=-1
    end
    -- TODO XXX: remove the following once integrated with trim system (offsets)
    local iCommandPlaneTrimRollAbs=2023
    dispatch_action(nil, iCommandPlaneTrimRollAbs, roll_trim*0.06)
    roll_trim_handle:set(roll_trim)
    --debug_print_afcs("hdg:"..tostring(current_hdg)..",dhdg:"..tostring(delta_hdg)..",l:"..tostring(left)..",r:"..tostring(right))
    --debug_print_afcs("rt:"..tostring(roll_trim)..",ra:"..tostring(roll_angle)..",ba:"..tostring(bank_angle))
end

function heading_select_PID()
    -- first calculate desired bank angle, based on delta between desired heading and current heading  (cannot directly control ailerons towards heading)
    --local current_hdg = 360.0-(sensor_data.getHeading()*360.0/(2*math.pi))
    local current_hdg = math.deg( sensor_data.getMagneticHeading() ) % 360
    local delta_hdg
    local left = (current_hdg-current_heading_setting) % 360
    local right = (current_heading_setting-current_hdg) % 360
    local bank_angle
    if left<right then
        delta_hdg = -left
        bank_angle = -27
    else
        delta_hdg = right
        bank_angle = 27
    end
    if math.abs(delta_hdg)<5 then -- smoothly roll out to desired heading
        bank_angle = bank_angle * math.abs(delta_hdg) / 5.0
    end
    -- now control bank angle with PID
    bank_hold_PID(bank_angle)
end

function pitch_hold_PID(pitch_angle)
    -- control the elevator trim to the pitch angle
    -- TODO: integrate with trim system (provide offset inputs)
    local cur_pitch_angle = sensor_data.getPitch()*360.0/(2*math.pi)
    local pitch_trim = pitch_pid:run( pitch_angle, cur_pitch_angle )
    if pitch_trim>1 then
        pitch_trim=1
    elseif pitch_trim<-1 then
        pitch_trim=-1
    end
    -- TODO XXX: remove the following once integrated with trim system (offsets)
    local iCommandPlaneTrimPitchAbs=2022
    dispatch_action(nil, iCommandPlaneTrimPitchAbs, pitch_trim*0.4)
    pitch_trim_handle:set(pitch_trim)
    --debug_print_afcs("hdg:"..tostring(current_hdg)..",dhdg:"..tostring(delta_hdg)..",l:"..tostring(left)..",r:"..tostring(right))
    --debug_print_afcs("rt:"..tostring(roll_trim)..",ra:"..tostring(roll_angle)..",ba:"..tostring(bank_angle))
end

function altitude_hold_PID(altitude_hold_m)
    -- first calculate desired rate of climb, based on delta between target and current altitude  (cannot directly control elevator to altitude)
    -- TODO: integrate with trim system (provide offset inputs)
    local cur_altitude_m
    if radarHold > 0 then
        cur_altitude_m = sensor_data.getRadarAltitude()
    else
        cur_altitude_m = sensor_data.getBarometricAltitude()
    end

    local alt_delta = altitude_hold_m-cur_altitude_m
    local ias = sensor_data.getIndicatedAirSpeed() * MPS_TO_KNOTS
    local target_climb_rate
    if alt_delta >= 0 then
        target_climb_rate = 30  -- 30m/s == 5905ft/min
    else
        target_climb_rate = -30  -- -30m/s == -5905/min
    end
    if math.abs(alt_delta)<(600/3.28084) then  -- start levelling out below 600ft delta
        target_climb_rate = target_climb_rate * (math.abs(alt_delta)/(600/3.28084))
    end
    -- now control elevators to get desired climb rate
    local cur_climb_rate = sensor_data.getVerticalVelocity()
    --debug_print_afcs("t.climb:"..string.format("%.2f",target_climb_rate).."m/s,c.climb:"..string.format("%.2f",cur_climb_rate).."m/s,t.alt:"..string.format("%.2f",altitude_hold_m)..",c.alt:"..string.format("%.2f",cur_altitude_m))
    if ias > 450 then
        altitude_pid:set_Kp(0.5)
        altitude_pid:set_Ki(0.007)
    else
        altitude_pid:set_Kp(1.5)
        altitude_pid:set_Ki(0.01)
    end

    local altitude_trim = altitude_pid:run( target_climb_rate, cur_climb_rate )
    if altitude_trim>1 then
        altitude_trim=1
    elseif altitude_trim<-1 then
        altitude_trim=-1
    end
    -- TODO XXX: remove the following once integrated with trim system (offsets)
    local iCommandPlaneTrimPitchAbs=2022
    dispatch_action(nil, iCommandPlaneTrimPitchAbs, (altitude_trim)*0.4)
    pitch_trim_handle:set(altitude_trim)
end

function update_afcs()
    -- TODO : take electric system into account
    -- TODO : take hydraulic system into account
    --[[
    The AFCS is an electrohydraulic system requiring
    all three phases of the 115/200-vac, 400-Hz power
    and 28—vdc power. Normal hydraulic system pres-
    sure of 3000 psi is reduced to 1500 + 75, —50 psi for
    the aileron and elevator servos and to 1150 + 450
    -50 psi for the dual input rudder valve. The AFCS
    will not Operate on the emergency generator and will
    not engage unless proper electrical and hydraulic
    power is available. It will disengage automatically
    if the electrical or hydraulic power fails.
    --]]
    -- note: sensor_data stick roll/pitch are swapped
    local realstickpitch = sensor_data.getStickRollPosition()/100.0-0.4*pitch_trim_handle:get()
    local realstickroll = sensor_data.getStickPitchPosition()/100.0-0.06*roll_trim_handle:get()

    if css_ignore_time>0 then
        css_ignore_time = css_ignore_time - update_time_step
        if css_ignore_time < 0 then
            css_ignore_time = 0
        end
    end

    -- TODO: check criteria for exiting states automatically, e.g. over-G, overpitch etc.
    local hdg=hdg_value:get_WMA_wrap(current_heading_setting)
    local _100s=math.floor(hdg/100)/10
    local _10s=math.floor((hdg%100)/10)/10
    local _1s=math.floor(hdg%10)/10

    AFCS_HDG_100s_param:set(_100s)
    AFCS_HDG_10s_param:set(_10s)
    AFCS_HDG_1s_param:set(_1s)

    -- "level triggered" actions for each AFCS state (every timer tick)
    local state=afcs_state
    local control_elevators=false
    if state == "afcs-off" then
    elseif state == "afcs-stby" then
    elseif state == "afcs-eng-attitude" then
        if css_ignore_time==0 and (math.abs(realstickpitch)>0.06 or math.abs(realstickroll)>0.06) then
            debug_print_afcs("css threshold p:"..string.format("%.3f", math.abs(realstickpitch))..",r:"..string.format("%.3f", math.abs(realstickroll)))
            change_afcs_state("afcs-eng-css")
        else
            bank_hold_PID(bank_hold_angle)
            control_elevators = true
        end
    elseif state == "afcs-eng-css" then
        if math.abs(realstickpitch)<=0.03 and math.abs(realstickroll)<=0.03 then
            --[[
            The AFCS will not switch out of CSS at
            bank angles exceeding 70 degrees or pitch angles
            exceeding 60 degrees noseup or nosedown unless
            limits of acceleration or aileron deflection are
            exceeded.
            --]]
            local pitch_angle = sensor_data.getPitch()*360.0/(2*math.pi)
            local roll_angle = sensor_data.getRoll()*360.0/(2*math.pi)
            if math.abs(roll_angle)<70 and math.abs(pitch_angle)<60 then
                debug_print_afcs("css cancel p:"..string.format("%.3f", math.abs(realstickpitch))..",r:"..string.format("%.3f", math.abs(realstickroll)))
                capture_afcs_attitude()
                change_afcs_state("afcs-eng-attitude")
            end
        end
    elseif state == "afcs-eng-hdgselect" then
        if css_ignore_time==0 and (math.abs(realstickpitch)>0.06 or math.abs(realstickroll)>0.06) then
            debug_print_afcs("css threshold p:"..string.format("%.3f", math.abs(realstickpitch))..",r:"..string.format("%.3f", math.abs(realstickroll)))
            change_afcs_state("afcs-eng-css")
        else
            heading_select_PID()
            control_elevators = true
        end
    end
    if control_elevators then
        if afcs_alt_hold_enabled then
            altitude_hold_PID(altitude_hold_m)
        else
            pitch_hold_PID(pitch_hold_angle)
        end
    end
    if afcs_engage_enabled then
        -- TODO: disengage AFCS if limits exceeded
        --[[
        The AFCS is automatically disengaged and the engage
        switch automatically moved to the OFF position when
        normal load factor approaches 4+-1/2 positive-g or
        1 1/2+-1/2 negative g, or when the aileron surface
        displacement exceeds 20 degrees, one-half lateral
        stick displacement from neutral. Normal accelera-
        tion values are reduced to 3 1/2 +- 1/2 positive g and
        1:1/2 negative g when a centerline store is carried,
        except when operating in CSS mode
        --]]
    end
	
	if afcs_stab_aug_enabled and get_hyd_utility_ok() and get_elec_primary_dc_ok() and get_elec_primary_ac_ok() then
		efm_data_bus.fm_setYawDamper(1.0)
	else
		efm_data_bus.fm_setYawDamper(0.0)
	end
	
end

local prev_throttle_lever=0
function update_throttle_buttons()
    local throttle_lever=get_cockpit_draw_argument_value(80)
    if prev_throttle_lever ~= throttle_lever then
        local lights_clickable_ref = get_clickable_element_reference("PNT_83")
        lights_clickable_ref:update() -- ensure the connector moves too
        local speedbrake_clickable_ref = get_clickable_element_reference("PNT_85")
        speedbrake_clickable_ref:update() -- ensure the connector moves too
        prev_throttle_lever = throttle_lever
    end
end

function update()
    -- TODO : take electric system into account
    -- TODO : take hydraulic system into account
    update_afcs()
    update_apc()
    update_throttle_buttons()
end

startup_print("afcs: load end")
need_to_be_closed = false -- close lua state after initialization

