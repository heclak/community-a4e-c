dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/stores_config.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step) --update will be called 50 times per second

local sensor_data = get_efm_sensor_data_overrides()
local efm_data_bus = get_efm_data_bus()

--[[
Control_Channel = {}
Control_Channel.__index = Control_Channel

--Set Control_Channel() operator to be the new function
setmetatable(Control_Channel, {
    __call = function(cls, ...)
    return cls.new(...)
    end,
})

function Control_Channel.new(Kp, Ki, Kd, umin, umax, uscale)
    local self = setmetatable({}, Control_Channel)

    self.m_pid = PID(Kp, Ki, Kd, umin, umax, uscale)
    self.m_activated = false
    self.m_setpoint = 0.0
end
]]--
local meters_to_feet = 3.2808399
local GALLON_TO_KG = 3.785 * 0.8
local KG_TO_POUNDS = 2.20462
local MPS_TO_KNOTS = 1.94384
local RADIANS_TO_DEGREES = 57.2958



local roll_trim_handle = get_param_handle("ROLL_TRIM")
local pitch_trim_handle = get_param_handle("PITCH_TRIM")

--AFCS PID
local roll_pid = PID(6, 0.05, 0.9, -100, 100, 0.01)   -- create the PID for bank angle control (aileron trim), values found experimentally
local pitch_pid = PID(6, 0.05, 0.2, -100, 100, 0.01)   -- create the PID for pitch angle control (elevator trim), values found experimentally
local altitude_pid = PID(1.5, 0.01, 0.11, -100, 100, 0.01)   -- create the PID for altitude control (elevator trim), values found experimentally

--APC PID
local apc_pid = PID(5, 0.02, 0.1, -100, 40, 0.01)   -- create the PID for the APC, values found experimentally

--APC control numbers
local ThrottleUp = 1032
local ThrottleDown = 1033
local ThrottleAxis = 2004

--AFCS Heading Indicator
local AFCS_HDG_100s_param = get_param_handle("AFCS_HDG_100s")
local AFCS_HDG_10s_param = get_param_handle("AFCS_HDG_10s")
local AFCS_HDG_1s_param = get_param_handle("AFCS_HDG_1s")

--Commands AFCS
dev:listen_command(device_commands.afcs_standby)
dev:listen_command(device_commands.afcs_engage)
dev:listen_command(device_commands.afcs_hdg_sel)
dev:listen_command(device_commands.afcs_alt)
dev:listen_command(device_commands.afcs_hdg_set)
dev:listen_command(device_commands.afcs_stab_aug)
dev:listen_command(device_commands.afcs_ail_trim)

--Commands APC
dev:listen_command(device_commands.apc_engagestbyoff)
dev:listen_command(device_commands.apc_hotstdcold)
dev:listen_command(Keys.APCEngageStbyOff)
dev:listen_command(Keys.APCHotStdCold)

-- AFCS States
AFCS_STATE_OFF = 0
AFCS_STATE_STBY = 1
AFCS_STATE_ATTITUDE_ONLY = 2
AFCS_STATE_ATTITUDE_HDG = 3
AFCS_STATE_ALTITUDE_ONLY = 4
AFCS_STATE_ALTITUDE_HDG = 5
AFCS_STATE_CSS = 6

-- AFCS initialization
local afcs_standby_enabled = false
local afcs_engage_enabled = false
local afcs_hdg_sel_enabled = false
local afcs_alt_hold_enabled = false
local afcs_ail_trim_enabled = true
local afcs_stab_aug_enabled = false
local afcs_css_enabled = false


--State information
local afcs_state = AFCS_STATE_OFF
local afcs_state_transition = false

--Current targets
local afcs_bank_angle_hold = 0
local afcs_pitch_angle_hold = 0
local afcs_altitude_hold = 0
local afcs_heading_hold = 0

-- APC initialization
local apc_enabled = false
local apc_inputlist = {"OFF", "STBY", "ENGAGE"}     -- -1,0,1
local apc_input = "OFF"
local apc_modelist = {"COLD", "STD", "HOT"}         -- -1,0,1
local apc_warmup_timer = 99999
local apc_warm = false
local apc_state = "apc-off"
local speedHold = -100
local apc_light = get_param_handle("APC_LIGHT")

local command_table = {}


function afcs_standby(value)
    afcs_standby_enabled = (value == 1)
end


function afcs_hdg_set(value)
    if value > 0 then
        afcs_heading_hold = afcs_heading_hold + 1
    elseif value < 0 then
        afcs_heading_hold = afcs_heading_hold - 1
    end

    if afcs_heading_hold >= 360 then
        afcs_heading_hold = afcs_heading_hold - 360
    end

    if afcs_heading_hold < 0 then
        afcs_heading_hold = afcs_heading_hold + 360
    end
end

function afcs_engage(value)

    afcs_engage_enabled = (value == 1)

    if not afcs_engage_enabled then
        dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
        dev:performClickableAction(device_commands.afcs_alt,0,false)
    end
end

function afcs_heading(value)
    afcs_hdg_sel_enabled = (value == 1)
end

function afcs_altitude(value)
    afcs_alt_hold_enabled = (value == 1)
end

function afcs_stab_aug(value)
    afcs_stab_aug_enabled = (value == 1)
end

function apc_engagestbyoff(value)
    apc_input = apc_inputlist[ round(value+2) ] -- convert -1,0,1 to 1,2,3
end

function apc_hotstdcold(value)
    apc_mode = apc_modelist[ round(value+2) ]   -- convert -1,0,1 to 1,2,3
end

function APCEngageStbyOff(value)
    dev:performClickableAction(device_commands.apc_engagestbyoff, value, false)
end

function APCHotStdCold(value)
    dev:performClickableAction(device_commands.apc_hotstdcold, value, false)
end


function afcs_check_engage_state()
    local state = get_current_state()

    if state == AFCS_STATE_ALTITUDE_HDG or state == AFCS_STATE_ALTITUDE_ONLY then
        --20 m/s = 4000 ft/min
        if math.abs(sensor_data.getVerticalVelocity()) > 20.0 then
            --print_message_to_user("Override Off")
            return false
        end

    elseif state == AFCS_STATE_ATTITUDE_HDG or state == AFCS_STATE_ATTITUDE_ONLY then
        local bank_angle = math.deg(sensor_data.getRoll())
        local pitch_angle = math.deg(sensor_data.getPitch())

        if math.abs(bank_angle) > 70.0 or math.abs(pitch_angle) > 60.0 then
            --print_message_to_user("Override Off")
            return false
        end
    end

    return true

end

function sync_switches()
    dev:performClickableAction(device_commands.afcs_standby,   afcs_standby_enabled and 1 or 0,  false)
    dev:performClickableAction(device_commands.afcs_engage,    afcs_engage_enabled and 1 or 0,   false)
    dev:performClickableAction(device_commands.afcs_stab_aug,  afcs_stab_aug_enabled and 1 or 0, false)
    dev:performClickableAction(device_commands.afcs_hdg_sel,   afcs_hdg_sel_enabled and 1 or 0,  false)
    dev:performClickableAction(device_commands.afcs_alt,       afcs_alt_hold_enabled and 1 or 0, false)
    dev:performClickableAction(device_commands.afcs_ail_trim,  afcs_ail_trim_enabled and 1 or 0, false)
end



function post_initialize()

    afcs_engage_enabled = false
    afcs_hdg_sel_enabled = false
    afcs_alt_hold_enabled = false
    afcs_ail_trim_enabled = true
    afcs_css_enabled = false
    
    afcs_heading_hold = 0
    
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        afcs_standby_enabled = true
        afcs_stab_aug_enabled = true
        afcs_state = AFCS_STATE_STBY

    elseif birth == "GROUND_COLD" then
        afcs_standby_enabled = false
        afcs_stab_aug_enabled = false
        afcs_state = AFCS_STATE_OFF
    end

    dev:performClickableAction(device_commands.apc_engagestbyoff,-1,true) --disable APC by default


    command_table[device_commands.afcs_standby] = afcs_standby
    command_table[device_commands.afcs_hdg_set] = afcs_hdg_set
    command_table[device_commands.afcs_engage] = afcs_engage
    command_table[device_commands.afcs_alt] = afcs_altitude
    command_table[device_commands.afcs_hdg_sel] = afcs_heading
    command_table[device_commands.afcs_stab_aug] = afcs_stab_aug
    command_table[device_commands.apc_engagestbyoff] = apc_engagestbyoff
    command_table[device_commands.apc_hotstdcold] = apc_hotstdcold
    command_table[Keys.APCEngageStbyOff] = APCEngageStbyOff
    command_table[Keys.APCHotStdCold] = APCHotStdCold

    sync_switches()
end




function SetCommand(command, value)
    --print_message_to_user("AFCS ".. command .. "," .. tostring(value))
    if command_table[command] == nil then
        return
    end
    command_table[command](value)
end


function check_switches()
    if not afcs_standby_enabled or not get_elec_mon_dc_ok() then
        dev:performClickableAction(device_commands.afcs_engage,0,false)
        dev:performClickableAction(device_commands.afcs_stab_aug,0,false)
        dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
        dev:performClickableAction(device_commands.afcs_alt,0,false)
    end
end


--Returns the current state of the autopilot based on the state of each setting.
function get_current_state(ignore_css)

    if not afcs_standby_enabled then
        return AFCS_STATE_OFF
    elseif not afcs_engage_enabled then
        return AFCS_STATE_STBY
    elseif afcs_css_enabled then
        return AFCS_STATE_CSS
    elseif afcs_hdg_sel_enabled then
        if afcs_alt_hold_enabled then
            return AFCS_STATE_ALTITUDE_HDG
        else
            return AFCS_STATE_ATTITUDE_HDG
        end
    else
        if afcs_alt_hold_enabled then
            return AFCS_STATE_ALTITUDE_ONLY
        else
            return AFCS_STATE_ATTITUDE_ONLY
        end
    end
end

function transition_state(from, to)
--[[
    state_names = {}

    state_names[AFCS_STATE_OFF] = "AFCS_STATE_OFF"
    state_names[AFCS_STATE_STBY] = "AFCS_STATE_STBY"
    state_names[AFCS_STATE_ATTITUDE_ONLY] = "AFCS_STATE_ATTITUDE_ONLY"
    state_names[AFCS_STATE_ATTITUDE_HDG] = "AFCS_STATE_ATTITUDE_HDG"
    state_names[AFCS_STATE_ALTITUDE_ONLY] = "AFCS_STATE_ALTITUDE_ONLY"
    state_names[AFCS_STATE_ALTITUDE_HDG] = "AFCS_STATE_ALTITUDE_HDG"
    state_names[AFCS_STATE_CSS] = "AFCS_STATE_CSS"
    
    print_message_to_user(tostring(state_names[from]).." -> "..tostring(state_names[to]))
]]--

    if to == AFCS_STATE_ALTITUDE_ONLY then
        afcs_bank_angle_hold = math.deg(sensor_data.getRoll())
        roll_pid:reset(roll_trim_handle:get())

        --Don't reset altitude if we are comming from another mode with altitude
        if from ~= AFCS_STATE_ALTITUDE_HDG then
            altitude_pid:reset(pitch_trim_handle:get())
            afcs_altitude_hold = sensor_data.getBarometricAltitude()
        end

    elseif to == AFCS_STATE_ALTITUDE_HDG then
        afcs_bank_angle_hold = 0
        roll_pid:reset(roll_trim_handle:get())

        --Don't reset altitude if we are comming from another mode with altitude
        if from ~= AFCS_STATE_ALTITUDE_ONLY then
            altitude_pid:reset(pitch_trim_handle:get())
            afcs_altitude_hold = sensor_data.getBarometricAltitude() 
        end

    elseif to == AFCS_STATE_ATTITUDE_ONLY then

        afcs_bank_angle_hold = math.deg(sensor_data.getRoll())
        afcs_pitch_angle_hold = math.deg(sensor_data.getPitch())

        if from ~= AFCS_STATE_CSS then
            pitch_pid:reset(pitch_trim_handle:get())
            roll_pid:reset(roll_trim_handle:get())
        end

    elseif to == AFCS_STATE_ATTITUDE_HDG then
        afcs_bank_angle_hold = 0
        afcs_pitch_angle_hold = math.deg(sensor_data.getPitch())

        pitch_pid:reset(pitch_trim_handle:get())
        roll_pid:reset(roll_trim_handle:get())
    elseif to == AFCS_STATE_OFF or to == AFCS_STATE_STBY then
        roll_trim_handle:set(0.0)
    end
end

function hold_bank(angle)
    local bank_angle = math.deg(sensor_data.getRoll())
    local roll_trim = clamp(roll_pid:run(angle, bank_angle), -1, 1)
    roll_trim_handle:set(roll_trim*0.4)
end

function hold_pitch(angle)
    local pitch_angle = math.deg(sensor_data.getPitch())
    local pitch_trim = clamp(pitch_pid:run(angle, pitch_angle), -1, 1)
    pitch_trim_handle:set(pitch_trim*0.4)
end

function hold_altitude(altitude_hold_m)
    -- first calculate desired rate of climb, based on delta between target and current altitude  (cannot directly control elevator to altitude)
    -- TODO: integrate with trim system (provide offset inputs)
    local cur_altitude_m

    radarHold = 0
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

    pitch_trim_handle:set(altitude_trim*0.4)
end

function auto_trim_pitch()
    local current_pitch_trim = pitch_trim_handle:get()
    local current_stick = efm_data_bus.fm_getPitchInput()

    local desired_g = current_stick * 9.0 + 1.0
    local current_g = sensor_data.getVerticalAcceleration()

    --Trim to minimise pitch to zero
    local new_pitch_trim = current_pitch_trim + (desired_g - current_g)/300.0
    pitch_trim_handle:set(new_pitch_trim)
end

function find_heading_desired_bank_angle()
    local heading = math.deg(sensor_data.getMagneticHeading()) % 360

    local left = (heading - afcs_heading_hold) % 360
    local right = (afcs_heading_hold - heading) % 360

    local bank_angle
    local delta_hdg

    local current_bank_angle = math.deg(sensor_data.getRoll())

    local bank_rate = 2

    if left < right then
        delta_hdg = -left
        bank_angle = clamp(current_bank_angle - bank_rate, -27, 27)
    else
        delta_hdg = right
        bank_angle = clamp(current_bank_angle + bank_rate, -27, 27)
    end
    

    --bank_angle = bank_angle * (clamp(math.abs(current_bank_angle / 27.5), 0.0, 1.0) + 0.1)

    if (math.abs(delta_hdg) < 4 ) then
        bank_angle = bank_angle * math.abs(delta_hdg) / 5.0 --this is just a P from a PID loop
    end

    return bank_angle
end

function check_for_css()

    if math.abs(efm_data_bus.fm_getPitchInput()) > 0.03 or math.abs(efm_data_bus.fm_getRollInput()) > 0.03  then
        afcs_css_enabled = true
        dev:performClickableAction(device_commands.afcs_hdg_sel,0,false)
        dev:performClickableAction(device_commands.afcs_alt,0,false)
    else
        --We must try and disengage the css mode.
        --We must check if this is allowed so disable afcs_ccs_enabled to check the state.
        afcs_css_enabled = false

        --If we cannot disable the css mode then we most go back to css.
        if not afcs_check_engage_state() then
            afcs_css_enabled = true
        end

    end
end

function check_limits()
    g_force = sensor_data.getVerticalAcceleration()


    --TODO adjust this for centerline stores
    --[[
    The AFCS is automatically disengaged and the engage switch automatically moved to the OFF position when
    normal load factor approaches 4 +/- 0.5 positive-g or 1.5 +/- 0.5 negative-g, or when the aileron surface displacement exceeds 20 degrees,
    one-half lateral stick displacement from neutral. Normal acceleration values are reduced to 3.5 +/- 0.5 positive-g and 1 +/- 0.5 negative-g
    when a centreline store is carried, except when operating in CSS mode. (Refer to Control Stick Steering Mode.)
    ]]--
    if g_force > 4 or g_force < -1.5 then
        dev:performClickableAction(device_commands.afcs_engage,0,false)
    end

end

function update_afcs()

    --enable/disable the afcs stability augmentation
    if afcs_stab_aug_enabled and get_hyd_utility_ok() and get_elec_primary_dc_ok() and get_elec_primary_ac_ok() then
        efm_data_bus.fm_setYawDamper(1.0)
    else
        efm_data_bus.fm_setYawDamper(0.0)
    end

    --switch based on the state and apply the various types of hold
    --early return for stdby/off positions
    if afcs_state == AFCS_STATE_STBY or afcs_state == AFCS_STATE_OFF then
        return
    elseif afcs_state == AFCS_STATE_ATTITUDE_ONLY then
        hold_bank(afcs_bank_angle_hold)
        hold_pitch(afcs_pitch_angle_hold)
    elseif afcs_state == AFCS_STATE_ATTITUDE_HDG then
        hold_bank(find_heading_desired_bank_angle())
        hold_pitch(afcs_pitch_angle_hold)
    elseif afcs_state == AFCS_STATE_ALTITUDE_ONLY then
        hold_bank(afcs_bank_angle_hold)
        hold_altitude(afcs_altitude_hold)
    elseif afcs_state == AFCS_STATE_ALTITUDE_HDG then
        hold_bank(find_heading_desired_bank_angle())
        hold_altitude(afcs_altitude_hold)
    elseif afcs_state == AFCS_STATE_CSS then
        auto_trim_pitch()
    end


    --see if we should enter into css mode
    check_for_css()

    --see if we should disengage
    check_limits()

    
end

function update()

    check_switches()
    local temp_state = get_current_state()

    --State change
    if temp_state ~= afcs_state then
        --Check if this state change is allowed with the current condition
        afcs_engage_enabled = afcs_check_engage_state() and afcs_engage_enabled

        --Update the possible new state
        temp_state = get_current_state()
        --Actually transition if this state is not the same as our current state.
        if temp_state ~= afcs_state then
            transition_state(afcs_state, temp_state)
            --Update state after transition
            afcs_state = temp_state
        end
    end
    
    

    --Calculate heading rotarys
    local hdg=afcs_heading_hold
    local _100s=math.floor(hdg/100)/10
    local _10s=math.floor((hdg%100)/10)/10
    local _1s=math.floor(hdg%10)/10

    --Set in-cockpit display
    AFCS_HDG_100s_param:set(_100s)
    AFCS_HDG_10s_param:set(_10s)
    AFCS_HDG_1s_param:set(_1s)

    --Calculate inputs
    update_afcs()
    update_apc()
    update_throttle_buttons()

end

--Update throttle clickables based on throttle position
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

function debug_print_apc(s)
    --stub
end

function update_apc()
    local timenow = get_model_time()

    --apc_throttle = apc_pid(sensor_data.getAngleOfAttack())
    local aoadeg
    local apc_target

    if speedHold > 0 then
        tas = -math.sqrt(sensor_data.getTrueAirSpeed())
        tastarget = -math.sqrt(speedHold)
    else
        aoadeg = efm_data_bus.fm_getAOAUnits()
        apc_target = 306.25  -- (8.75^2)
    end

    if apc_mode == "HOT" then
        apc_target = 324      -- (9)^2
    elseif apc_mode == "COLD" then
        apc_target = 289       -- (8.5)^2
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