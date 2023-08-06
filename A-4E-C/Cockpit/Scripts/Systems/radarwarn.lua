local dev = GetSelf()
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."sound_params.lua")

local update_rate = 0.02
make_default_activity(update_rate)

startup_print("radarwarn: load")

local sensor_data = get_base_data()

function post_initialize()
    startup_print("radarwarn: postinit")

    --sndhost = create_sound_host("COCKPIT_RADAR_WARN","HEADPHONES",0,0,0)
    --radarwarntone = sndhost:create_sound("Aircrafts/A-4E-C/a-4e_CockpitRadarAltimeterWarn") -- Radar Altimeter Warning Tone
    --radarlocktone = sndhost:create_sound("Aircrafts/A-4E-C/a-4e_CockpitRadarAltimeterLock") -- Radar Altimeter Lock Status Change Tone
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.radar_alt_switch, -1, false)  -- disable radar warning on ground starts
    elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.radar_alt_switch, 0, false)  -- enable radar warning on air start
    end

    startup_print("radarwarn: postinit end")
end

local ticker=0
local played=false

local warning_altitude=500
local warning_altitude_gauge_idx=WMA(0.15, warning_altitude)
local prev_altitude = sensor_data.getRadarAltitude()*3.28084
local gauge_altitude = WMA(0.15,prev_altitude)
local radar_enabled=true

local current_RALT=get_param_handle("D_RADAR_ALT")
local RALT_idx=get_param_handle("D_RADAR_IDX")
RALT_idx:set(warning_altitude)
local RALT_off=get_param_handle("D_RADAR_OFF")
RALT_off:set(0)
local RALT_warn=get_param_handle("D_RADAR_WARN")
local RALT_warn_val=0
RALT_warn:set(0)

local current_RALT_valid=get_param_handle("D_RADAR_ALT_VALID")

local master_test_param = get_param_handle("D_MASTER_TEST")

local radar_alt_indexer_moving = 0

dev:listen_command(Keys.RadarAltToggle)
dev:listen_command(Keys.RadarAltWarningDown)
dev:listen_command(Keys.RadarAltWarningUp)
dev:listen_command(Keys.RadarAltWarningStartDown)
dev:listen_command(Keys.RadarAltWarningStartUp)
dev:listen_command(Keys.RadarAltWarningStop)

dev:listen_command(device_commands.radar_altitude_warning_axis_abs)
dev:listen_command(device_commands.radar_altitude_warning_axis_slew)

function update()
    local valid_radar=true
    local altitude_meters = sensor_data.getRadarAltitude()
    local altitude_feet = altitude_meters*3.28084

    warn_idx_delta = get_warn_idx_delta(warning_altitude) * radar_alt_indexer_moving * 0.3
    warning_altitude = warning_altitude + warn_idx_delta

    if altitude_meters > 1600 then
        -- DCS seems to cap the sensor value at 1600.05meters
        valid_radar = false

        -- TODO: maybe need to refactor this to use find_collision_range from apg53a code
        --  instead of this sensor value, and then inverse the angle correction below
    end

--[[NATOPS: The radar altimeter operates normally during 50-
degree angles of climb or dive and 30-degree angles
of bank, right or left. Beyond these points, the
indications on the radar altimeter become unreliable
but will resume normal operation when the aircraft
returns to normal flight.--]]
    local abspitch=math.abs(sensor_data.getPitch())
    local absroll=math.abs(sensor_data.getRoll())
    if abspitch>(50*2.0*math.pi/360.0) then
        abspitch=(50*2.0*math.pi/360.0)
        valid_radar=false
    end
    if absroll>(30*2.0*math.pi/360.0) then
        absroll=(30*2.0*math.pi/360.0)
        valid_radar=false
    end

    altitude_feet=altitude_feet*math.cos(abspitch)
    altitude_feet=altitude_feet*math.cos(absroll)

    if valid_radar and altitude_feet>5000 then -- radar altimeter cuts off at 5000' AGL per APN-141 capabilities
        valid_radar=false
    end
    if not valid_radar then
        altitude_feet=6000 -- puts needle behind mask on gauge
    end

    if (not get_elec_fwd_mon_ac_ok()) or (not valid_radar) or (not radar_enabled) or (get_elec_retraction_release_ground()) then
    --[[
    NATOPS: An OFF flag on the
    indicator face appears when signal strength becomes
    inadequate to provide reliable altitude information,
    when power to the system is lost, or when the system
    is turned OFF.

    NATOPS: Radar altimeter inoperative on the ground (pg 1-25)
    --]]
        RALT_off:set(1)
        if (not radar_enabled) or (not get_elec_fwd_mon_ac_ok()) or (get_elec_retraction_release_ground()) then
            altitude_feet = 0
        end
        prev_altitude = altitude_feet
        valid_radar=false
    else
        RALT_off:set(0)
    end

--[[
TODO: maybe play unreliability tone if pitch/roll cross these boundaries above?
From NATOPS:
A reliability warning signal
of the same frequency range (but with 8-cps repetition
rate) is also provided. The reliability warning signal
sounds for 2 seconds whenever the APN-141 acquires
or loses lock-on.
NOTE
On aircraft reworked per A-4 AFC 423, the
reliability warning signal is removed.

AFC 423: Disable LAWS Unreliability Tone with APR-27 Installed (Wiring Mod.)
--]]

    if played then
        RALT_warn_val=1
        ticker=ticker+update_rate
        if ticker >= 2 then
            played = false
        end
    end
    if valid_radar then
        if not played and (get_elec_mon_dc_ok()) then
            if prev_altitude > warning_altitude and altitude_feet < warning_altitude and radar_enabled then
                played=true
                ticker = 0
                --radarwarntone:play_once()
                sound_params.snd_inst_radar_altimeter_warning:set(1.0)
            end
        end
        prev_altitude = altitude_feet
        current_RALT_valid:set(1)
        if altitude_feet < warning_altitude and radar_enabled then
            RALT_warn_val=1
        else
            RALT_warn_val=0
            sound_params.snd_inst_radar_altimeter_warning:set(0.0)
        end
    else
        current_RALT_valid:set(0)
        RALT_warn_val=0
    end
    if master_test_param:get()==1 then
        RALT_warn_val=1
    end
    if not get_elec_primary_ac_ok() then
        RALT_warn_val=0
    end
    RALT_warn:set(RALT_warn_val)
    current_RALT:set(gauge_altitude:get_WMA(altitude_feet))
    RALT_idx:set(warning_altitude_gauge_idx:get_WMA(warning_altitude))
    
end

function get_warn_idx_delta(warn_alt)
    local warn_idx_delta = 500/4

    if warn_alt < 225 then
        warn_idx_delta = 10/4
    elseif warn_alt < 650 then
        warn_idx_delta = 50/4
    elseif warn_alt < 2250 then
        warn_idx_delta = 100/4
    end

    return warn_idx_delta
end

function SetCommand(command,value)
-- Radar altitude indicator, the indicator dial face is marked in 10-foot increments up to 200 feet,
-- 50-foot increments from 200 to 600 feet, 100-foot increments from 600 to 2000 feet, and 500-foot increments from 2000 to 5000 feet
    local warn_idx_delta
    if (command == Keys.RadarAltWarningDown) or (command == device_commands.radar_alt_indexer and value<0) then
        warn_idx_delta = get_warn_idx_delta(warning_altitude)
        warning_altitude = warning_altitude - warn_idx_delta

        if warning_altitude < 0 then
            warning_altitude = 0
        end
    elseif (command == Keys.RadarAltWarningUp) or (command == device_commands.radar_alt_indexer and value>0) then
        warn_idx_delta = get_warn_idx_delta(warning_altitude)
        warning_altitude = warning_altitude + warn_idx_delta
        if warning_altitude > 4500 then
            warning_altitude = 4500
        end
    elseif command == Keys.RadarAltToggle then
        dev:performClickableAction(device_commands.radar_alt_switch,radar_enabled and -1 or 0,false)
    elseif command == device_commands.radar_alt_switch then
        if (value==-1) then
            radar_enabled=false
        elseif (value==0) then
            radar_enabled=true
        else
            -- TODO: test mode
            radar_enabled=true
        end
    elseif command == Keys.RadarAltWarningStartUp then
        radar_alt_indexer_moving = 1
    elseif command == Keys.RadarAltWarningStartDown then
        radar_alt_indexer_moving = -1
    elseif command == Keys.RadarAltWarningStop then
        radar_alt_indexer_moving = 0
    elseif command == device_commands.radar_altitude_warning_axis_slew then
        if value < 0.02 and value > -0.02 then
            radar_alt_indexer_moving = 0
        elseif value >=0.01 then
            radar_alt_indexer_moving = 1
        elseif value <=0.01 then
            radar_alt_indexer_moving = -1
        end
    end
end

startup_print("radarwarn: load end")

need_to_be_closed = false -- close lua state after initialization

--[[
Notes from NATOPS:
The AN/APN-141 radar altimeter (figure 1-7)
employs the pulse radar technique to furnish accurate
instantaneous altitude information to the pilot from 0
to 5000 feet terrain clearance. Aircraft height is .
determined by measuring the elapsed transit time of
a radar pulse, which is converted directly to altitude
in feet and displayed on the cockpit indicator. The
indicator dial face is marked in 10-foot increments
up to 200 feet, 50-foot increments from 200 to 600
feet, 100-foot increments from 600 to 2000 feet, and
500-foot increments from 2000 to 5000 feet. A control knob on the front of the indicator controls power
to the indicator and is used for setting the low-limit
indexer. The controI knob also provides for preflight
and in-flight test of the equipment with a push-totest type control knob feature. Refer to LOW ALTITUDE WARNING SYSTEM (LAWS) for information
regarding low limit indexer. An OFF flag on the
indicator face appears when signal strength becomes
inadequate to provide reliable altitude information,
when power to the system is lost, or when the system
is turned OFF.


Low Altitude Warning System (LAWS)
The low altitude warning system is used to warn the
pilot of impending danger due to low altitude. The
warning system consists of two warning lights and an
aural warning tone heard in the pilot's headset that
operates in conjunction with the AN/APN-141 radar
altimeter. One warning light is located under the
glareshield (figure 1-6), and the other, which is the !
radar low limit warning light, is located adjacent to
the radar altimeter (figure FO-2). When the AN/
APN-141 radar altimeter indicator pointer drops
below the preset low-limit indexer altitude setting,
both warning lights come on and the aural warning
tone is activated for 2 seconds. The warning tone is
an alternating 700- to 1700-cps tone with a repetition
rate of 2 cps.
--]]