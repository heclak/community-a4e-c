local optionsData_cockpitShake = get_plugin_option_value("A-4E-C", "cockpitShake", "local")

local fm_gear_nose = get_param_handle("FM_GEAR_NOSE")
local fm_gear_left = get_param_handle("FM_GEAR_LEFT")
local fm_gear_right = get_param_handle("FM_GEAR_RIGHT")

local fm_flaps = get_param_handle("FM_FLAPS")
local fm_brakes = get_param_handle("FM_BRAKES")
local fm_spoilers = get_param_handle("FM_SPOILERS")

local fm_throttle_position = get_param_handle("FM_THROTTLE_POSITION")
local fm_engine_throttle_position = get_param_handle("FM_ENGINE_THROTTLE_POSITION")
local fm_ignition = get_param_handle("FM_IGNITION")
local fm_bleed_air = get_param_handle("FM_BLEED_AIR")

local fm_stick_pitch = get_param_handle("STICK_PITCH")
local fm_stick_roll = get_param_handle("STICK_ROLL")
local fm_rudder_pedals = get_param_handle("RUDDER_PEDALS")

local fm_pitch_trim = get_param_handle("PITCH_TRIM")
local fm_roll_trim = get_param_handle("ROLL_TRIM")
local fm_rudder_trim = get_param_handle("RUDDER_TRIM")
local fm_yaw_damper = get_param_handle("FM_YAW_DAMPER")

local fm_nws = get_param_handle("FM_NWS")

local fm_internal_fuel = get_param_handle("FM_INTERNAL_FUEL")
local fm_external_fuel = get_param_handle("FM_EXTERNAL_FUEL")

local fm_cockpitShake = get_param_handle("FM_COCKPIT_SHAKE")

local fm_airspeed = get_param_handle("FM_AIRSPEED")

local fm_RPM = get_param_handle("RPM")

local EFM_enabled = true

function fm_setNoseGear(value)
    fm_gear_nose:set(value)
end

function fm_setLeftGear(value)
    fm_gear_left:set(value)
end

function fm_setRightGear(value)
    fm_gear_right:set(value)
end

function fm_setFlaps(value)
    fm_flaps:set(value)
end

function fm_setBrakes(value)
    fm_brakes:set(value)
end

function fm_setSpoilers(value)
    fm_spoilers:set(value)
end

function fm_setEngineThrottle(value)
    fm_engine_throttle_position:set(value)
end

function fm_setIgnition(value)
    fm_ignition:set(value)
end

function fm_setBleedAir(value)
    fm_bleed_air:set(value)
end

function fm_setPitchTrim(value)
    fm_pitch_trim:set(value)
end

function fm_setRollTrim(value)
    fm_roll_trim:set(value)
end

function fm_setRudderTrim(value)
    fm_rudder_trim:set(value)
end

function fm_setYawDamper(value)
    fm_yaw_damper:set(value)
end

function fm_setNWS(value)
    fm_nws:set(value)
end

function fm_setCockpitShake(value)
    fm_cockpitShake:set(value)
end

function fm_getEngineRPM()
    return fm_RPM:get()
end

function fm_getAirspeed()
    return fm_airspeed:get()
end

function fm_getThrottle()
    return fm_throttle_position:get()
end

function fm_getInternalFuel()
    return fm_internal_fuel:get()
end

function fm_getExternalFuel()
    return fm_external_fuel:get()
end

function fm_getIgnition()
    return fm_ignition:get()
end


function get_efm_data_bus()
    local efm_data_bus = {}
    --fm_cockpitShake:set(optionsData_cockpitShake/100.0)
    efm_data_bus.fm_setNoseGear = fm_setNoseGear
    efm_data_bus.fm_setLeftGear = fm_setLeftGear
    efm_data_bus.fm_setRightGear = fm_setRightGear
    efm_data_bus.fm_setFlaps = fm_setFlaps
    efm_data_bus.fm_setBrakes = fm_setBrakes
    efm_data_bus.fm_setSpoilers = fm_setSpoilers
    efm_data_bus.fm_setEngineThrottle = fm_setEngineThrottle
    efm_data_bus.fm_setIgnition = fm_setIgnition
    efm_data_bus.fm_setBleedAir = fm_setBleedAir
    efm_data_bus.fm_setPitchTrim = fm_setPitchTrim
    efm_data_bus.fm_setRollTrim = fm_setRollTrim
    efm_data_bus.fm_setRudderTrim = fm_setRudderTrim
    efm_data_bus.fm_setYawDamper = fm_setYawDamper
    efm_data_bus.fm_setNWS = fm_setNWS
    efm_data_bus.fm_setCockpitShake = fm_setCockpitShake

    efm_data_bus.fm_getInternalFuel = fm_getInternalFuel
    efm_data_bus.fm_getExternalFuel = fm_getExternalFuel
    efm_data_bus.fm_getIgnition = fm_getIgnition

    return efm_data_bus
    --efm_data_bus.setCockpitShake(optionsData_cockpitShake/100.0)
end

function get_efm_sensor_data_overrides()
    --Get the original data
    local data = get_base_data()

    if EFM_enabled then
        data.getEngineLeftRPM = fm_getEngineRPM
        data.getThrottleLeftPosition = fm_getThrottle
        data.getTrueAirSpeed = fm_getAirspeed
    end

    return data
end
