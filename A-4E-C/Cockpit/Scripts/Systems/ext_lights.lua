dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.05 --update will be called 20 times per second
make_default_activity(update_time_step)

function debug_print(x)
    -- print_message_to_user(x)
end

local ExtLight_LeftNav_arg = 190
local ExtLight_RightNav_arg = 191
local ExtLight_Tail_arg = 192
local ExtLight_FuelProbe_arg = 193
local ExtLight_TopCollision_arg = 198
local ExtLight_BottomCollision_arg = 199
local ExtLight_TopCollisionBrightness_arg = 200
local ExtLight_BottomCollisionBrightness_arg = 202
local ExtLight_TopCollisionRotation_arg = 201
local ExtLight_BottomCollisionRotation_arg = 203
local ExtLight_Taxi_arg = 208

--[[
EXTERIOR LIGHTING DESIGN:

Switches:
    MASTER LIGHTING SWITCH:  ON/OFF/Momentary, #83
    #217: Probe Light Switch (3 position toggle: DIM, OFF, BRT)
    #218: Taxi Light Switch (2 position toggle: OFF, TAXI)
    #219: Anti-Collision Light Switch (2 position toggle: OFF, ANTI-COLL)
    #220: Fuselage Light Switch (3 position toggle: DIM, OFF, BRT)
    #221: Flash-Steady Light Switch (2 position toggle: STDY, FLSH)
    #222: Navigation Lights Switch (3 position toggle: DIM, OFF, BRT)
    #223: Tail Lights Switch (3 position toggle: DIM, OFF, BRT)


Lights involved (7 groups, 10 structures):
    Navigation Lights (aka "Wingtip Lights" aka "Position Lights")
        Left Navigation Light (left wingtip, DIM and BRIGHT bulbs)
        Right Navigation Light (right wingtip, DIM and BRIGHT bulbs)
    Tail Light (edge of tail, just below rudder, WHITE, DIM and BRIGHT bulbs)
    Anticollision Lights
        Anticollision Light Top (top of avionics hump, ROTATING RED)
        Anticollision Light Bottom (left main gear strut fairing, ROTATING RED)
    Fuselage Lights
        Left Fuselage Light (underside left wing, WHITE, DIM and BRIGHT bulbs)
        Right Fuselage Light (underside right wing, WHITE, DIM and BRIGHT bulbs)
    Fuel Probe Light (edge of right engine intake, WHITE, DIM and BRIGHT bulbs)
    Taxi Light (right main gear door, WHITE, single intensity)
    Approach Light (left wing root, outboard of cannon, 3 separate color bulbs)


Design:
    All external lighting is on the "Forward Monitored A/C Bus" which means it only
    works when on primary power (engine running) or when attached to ground power.
    External ighting does not work on backup power.

    MASTER ON will enable power to all light circuits, and energizes the flashing
        relay for NAV/TAIL/FUSELAGE lighting.

    Navigation Lights (bright) will be ON if MASTER ON and NAV BRT
    Navigation Lights (dim) will be ON if MASTER ON and NAV DIM
        Navigation Lights will flash if the FLASH/STDY switch is in the FLASH position

    Tail Light (bright) will be ON if MASTER ON and TAIL BRT
    Tail Light (dim) will be ON if MASTER ON and TAIL DIM
        Tail Light will flash if the FLASH/STDY switch is in the FLASH position

    ANTICOLL will be ON if MASTER ON and ANTI-COLL ON
        Anti-collision lights always flash

    Fuselage Lights (brt) will be ON if MASTER ON and FUSELAGE BRT and ANTI-COLL OFF
    Fuselage Lights (dim) will be ON if MASTER ON and FUSELAGE DIM and ANTI-COLL OFF
        Fuselage lights will flash if the FLASH/STDY switch is in the FLASH position

    TAXI light will be ON if MASTER ON and TAXI ON
        Taxi light is always steady
        Taxi light will turn off if right main gear is retracted

--]]



function post_initialize()
    local dev = GetSelf()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then --"GROUND_COLD","GROUND_HOT","AIR_HOT"
    elseif birth=="GROUND_COLD" then
    end
end

--dev:listen_command(Keys.PlaneLightsOnOff)
--dev:listen_command(Keys.PlaneHeadlightOnOff)
dev:listen_command(Keys.ExtLightMaster)
dev:listen_command(Keys.ExtLightMasterToggle)
dev:listen_command(Keys.ExtLightProbe)
dev:listen_command(Keys.ExtLightProbeCycle)
dev:listen_command(Keys.ExtLightTaxi)
dev:listen_command(Keys.ExtLightTaxiToggle)
dev:listen_command(Keys.ExtLightAnticollision)
dev:listen_command(Keys.ExtLightAnticollisionToggle)
dev:listen_command(Keys.ExtLightNav)
dev:listen_command(Keys.ExtLightNavCycle)
dev:listen_command(Keys.ExtLightTail)
dev:listen_command(Keys.ExtLightTailCycle)
dev:listen_command(Keys.ExtLightFuselage)
dev:listen_command(Keys.ExtLightFuselageCycle)
dev:listen_command(Keys.ExtLightFlashSteady)
dev:listen_command(Keys.ExtLightFlashSteadyToggle)
dev:listen_command(device_commands.extlight_master)
dev:listen_command(device_commands.extlight_probe)
dev:listen_command(device_commands.extlight_taxi)
dev:listen_command(device_commands.extlight_anticoll)
dev:listen_command(device_commands.extlight_fuselage)
dev:listen_command(device_commands.extlight_flashsteady)
dev:listen_command(device_commands.extlight_nav)
dev:listen_command(device_commands.extlight_tail)

local extlight_master = 0
local extlight_probe = 0
local extlight_taxi = 0
local extlight_anticoll = 0
local extlight_fuselage = 0
local extlight_flashsteady = 0
local extlight_nav = 0
local extlight_tail = 0

local extlight_key_allon = 0
local extlight_key_taxion = 0

function SetCommand(command,value)
    --[[
    if command == Keys.PlaneLightsOnOff then
        extlight_key_allon = extlight_key_allon - 0.5
        if extlight_key_allon < 0 then
            extlight_key_allon = 1
        end
        if extlight_key_allon == 1 then
            -- select "BRIGHT" setting for applicable lights
            dev:performClickableAction(device_commands.extlight_master, 1, false)
            dev:performClickableAction(device_commands.extlight_anticoll, 1, false)
            dev:performClickableAction(device_commands.extlight_fuselage, 1, false)
            dev:performClickableAction(device_commands.extlight_nav, 1, false)
            dev:performClickableAction(device_commands.extlight_tail, 1, false)
        elseif extlight_key_allon == 0.5 then
            -- select "DIM" setting for applicable lights
            dev:performClickableAction(device_commands.extlight_master, 1, false)
            dev:performClickableAction(device_commands.extlight_anticoll, 1, false)
            dev:performClickableAction(device_commands.extlight_fuselage, -1, false)
            dev:performClickableAction(device_commands.extlight_nav, -1, false)
            dev:performClickableAction(device_commands.extlight_tail, -1, false)
        else
            -- disable all lights except 'MASTER' switch
            --dev:performClickableAction(device_commands.extlight_master, 0, false)     -- don't turn off master
            dev:performClickableAction(device_commands.extlight_anticoll, 0, false)
            dev:performClickableAction(device_commands.extlight_fuselage, 0, false)
            dev:performClickableAction(device_commands.extlight_nav, 0, false)
            dev:performClickableAction(device_commands.extlight_tail, 0, false)
        end
    elseif command == Keys.PlaneHeadlightOnOff then
        extlight_key_taxion = 1 - extlight_key_taxion
        if extlight_key_taxion then
            -- enable taxi light, and make sure master is on
            dev:performClickableAction(device_commands.extlight_master, 1, false)
            dev:performClickableAction(device_commands.extlight_taxi, 1, false)
        else
            -- disable taxi light, but leave master on
            --dev:performClickableAction(device_commands.extlight_master, 0, false)     -- don't turn off master
            dev:performClickableAction(device_commands.extlight_taxi, 0, false)
        end
    --]]
    -- MASTER LIGHTING SWITCH (outside of throttle)
    if command == device_commands.extlight_master then
        if value == 1 or value == -1 then
            extlight_master = 1
        else
            extlight_master = 0
        end
    elseif command == Keys.ExtLightMaster then
        dev:performClickableAction(device_commands.extlight_master, value, false)
    elseif command == Keys.ExtLightMasterToggle then
        dev:performClickableAction(device_commands.extlight_master, (extlight_master == 0) and 1 or 0, false)

    -- PROBE LIGHT SWITCH (BRIGHT/DIM/OFF)
    elseif command == device_commands.extlight_probe then
        if value == 1 or value == 0 then
            extlight_probe = value
        elseif value == -1 then
            extlight_probe = 0.6
        end
    elseif command == Keys.ExtLightProbe then
        dev:performClickableAction(device_commands.extlight_probe, value, false)
    elseif command == Keys.ExtLightProbeCycle then
        if extlight_probe == 0 then
            dev:performClickableAction(device_commands.extlight_probe, 1, false)
        elseif extlight_probe == 1.0 then
            dev:performClickableAction(device_commands.extlight_probe, -1, false)
        else
            dev:performClickableAction(device_commands.extlight_probe, 0, false)
        end

    -- TAXI LIGHT SWITCH (ON/OFF)
    elseif command == device_commands.extlight_taxi then
        extlight_taxi = value
        extlight_key_taxion = value
    elseif command == Keys.ExtLightTaxi then
        dev:performClickableAction(device_commands.extlight_taxi, value, false)
    elseif command == Keys.ExtLightTaxiToggle then
        dev:performClickableAction(device_commands.extlight_taxi, 1 - extlight_taxi, false)

    -- ANTI-COLLISION LIGHTING (ON/OFF)
    elseif command == device_commands.extlight_anticoll then
        extlight_anticoll = value
    elseif command == Keys.ExtLightAnticollision then
        dev:performClickableAction(device_commands.extlight_anticoll, value, false)
    elseif command == Keys.ExtLightAnticollisionToggle then
        dev:performClickableAction(device_commands.extlight_anticoll, 1 - extlight_anticoll, false)

    -- FUSELAGE LIGHTS (BRIGHT/DIM/OFF)
    elseif command == device_commands.extlight_fuselage then
        if value == 1 or value == 0 then
            extlight_fuselage = value
        elseif value == -1 then
            extlight_fuselage = 0.5
        end
    elseif command == Keys.ExtLightFuselage then
        dev:performClickableAction(device_commands.extlight_fuselage, value, false)
    elseif command == Keys.ExtLightFuselageCycle then
        if extlight_fuselage == 0 then
            dev:performClickableAction(device_commands.extlight_fuselage, 1, false)
        elseif extlight_fuselage == 1.0 then
            dev:performClickableAction(device_commands.extlight_fuselage, -1, false)
        else
            dev:performClickableAction(device_commands.extlight_fuselage, 0, false)
        end

    -- FUSELAGE FLASH/STEADY CONFIGURATION
    elseif command == device_commands.extlight_flashsteady then
        extlight_flashsteady = value
    elseif command == Keys.ExtLightFlashSteady then
        dev:performClickableAction(device_commands.extlight_flashsteady, value, false)
    elseif command == Keys.ExtLightFlashSteadyToggle then
        dev:performClickableAction(device_commands.extlight_flashsteady, 1 - extlight_flashsteady, false)

    -- NAVIGATION LIGHTS (BRIGHT/DIM/OFF)
    elseif command == device_commands.extlight_nav then
        if value == 1 or value == 0 then
            extlight_nav = value
        elseif value == -1 then
            extlight_nav = 0.5
        end
    elseif command == Keys.ExtLightNav then
        dev:performClickableAction(device_commands.extlight_nav, value, false)
    elseif command == Keys.ExtLightNavCycle then
        if extlight_nav == 0 then
            dev:performClickableAction(device_commands.extlight_nav, 1, false)
        elseif extlight_nav == 1.0 then
            dev:performClickableAction(device_commands.extlight_nav, -1, false)
        else
            dev:performClickableAction(device_commands.extlight_nav, 0, false)
        end

    -- TAIL LIGHT (BRIGHT/DIM/OFF)
    elseif command == device_commands.extlight_tail then
        if value == 1 or value == 0 then
            extlight_tail = value
        elseif value == -1 then
            extlight_tail = 0.5
        end
    elseif command == Keys.ExtLightTail then
        dev:performClickableAction(device_commands.extlight_tail, value, false)
    elseif command == Keys.ExtLightTailCycle then
        if extlight_tail == 0 then
            dev:performClickableAction(device_commands.extlight_tail, 1, false)
        elseif extlight_tail == 1.0 then
            dev:performClickableAction(device_commands.extlight_tail, -1, false)
        else
            dev:performClickableAction(device_commands.extlight_tail, 0, false)
        end
    end

end


local flashcounter = 0.5
local flashperminute = 85
local anticoll_inc = 1

-- returns linear movement from 0.0 to 1.0 at 85 cycles per minute
function update_anticoll_value()
    -- if anticoll_inc == 1 then
    --     flashcounter = flashcounter + (update_time_step*(flashperminute/60) * 0.5)
    -- else
    --     flashcounter = flashcounter - (update_time_step*(flashperminute/60) * 0.5)
    -- end

    -- if flashcounter > 1 or flashcounter < 0.075 then
    --     anticoll_inc = 1 - anticoll_inc
    -- end

    -- -- set flashing duty cycle here
    -- local a,b = math.modf(flashcounter) -- extract the decimal part
    -- return b

    local increase = math.pi * 2 / 2 * ((1/update_time_step) * (60/flashperminute))
    local y = math.sin( flashcounter ) / 2 + 0.5
    flashcounter = flashcounter + increase
    return y

end


local flashcounter_ext = 0
local flashperminute_ext = 80

function update_flashing_ext()
    -- exterior lights flash 80 flashes/minute, on for 0.54 seconds and off for 0.21 seconds.
    flashcounter_ext = flashcounter_ext + (update_time_step*(flashperminute_ext/60))
    if flashcounter_ext > flashperminute_ext then
        flashcounter_ext = 0
    end

    -- set flashing duty cycle here
    local a,b = math.modf(flashcounter_ext) -- extract the decimal part
    if b < (0.54/(0.54+0.21)) then
        return 1
    else
        return 0
    end
end


function update()
    -- flashon is true if we're set in the "on" phase
    local anticoll = update_anticoll_value()
    local flashon_ext = update_flashing_ext()
    local gear = get_aircraft_draw_argument_value(3)    -- right main gear extension

    if extlight_master == 1 and get_elec_fwd_mon_ac_ok() then
        if extlight_flashsteady == 1 then
            -- in "FLASH" mode, modulate output with flashon value
            set_aircraft_draw_argument_value(ExtLight_LeftNav_arg, extlight_nav*flashon_ext)
            set_aircraft_draw_argument_value(ExtLight_RightNav_arg, extlight_nav*flashon_ext)
            set_aircraft_draw_argument_value(ExtLight_Tail_arg, extlight_tail*flashon_ext)
        else
            -- in "STEADY" mode, just draw them
            set_aircraft_draw_argument_value(ExtLight_LeftNav_arg, extlight_nav)
            set_aircraft_draw_argument_value(ExtLight_RightNav_arg, extlight_nav)
            set_aircraft_draw_argument_value(ExtLight_Tail_arg, extlight_tail)
        end

        set_aircraft_draw_argument_value(ExtLight_Taxi_arg, (gear > 0) and extlight_taxi or 0)
        set_aircraft_draw_argument_value(ExtLight_FuelProbe_arg, extlight_probe)

        if extlight_anticoll == 1 then
            set_aircraft_draw_argument_value(ExtLight_TopCollision_arg, extlight_anticoll)
            set_aircraft_draw_argument_value(ExtLight_BottomCollision_arg, extlight_anticoll)

            set_aircraft_draw_argument_value(ExtLight_TopCollisionBrightness_arg, extlight_anticoll)
            set_aircraft_draw_argument_value(ExtLight_BottomCollisionBrightness_arg, extlight_anticoll)

            set_aircraft_draw_argument_value(ExtLight_TopCollisionRotation_arg, anticoll)
            set_aircraft_draw_argument_value(ExtLight_BottomCollisionRotation_arg, anticoll)
        else
            set_aircraft_draw_argument_value(ExtLight_TopCollision_arg, 0)
            set_aircraft_draw_argument_value(ExtLight_BottomCollision_arg, 0)

            set_aircraft_draw_argument_value(ExtLight_TopCollisionBrightness_arg, 0)
            set_aircraft_draw_argument_value(ExtLight_BottomCollisionBrightness_arg, 0)
        end

    else
        set_aircraft_draw_argument_value(ExtLight_LeftNav_arg, 0)
        set_aircraft_draw_argument_value(ExtLight_RightNav_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_Tail_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_Taxi_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_TopCollision_arg, 0)
        set_aircraft_draw_argument_value(ExtLight_BottomCollision_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_TopCollisionBrightness_arg, 0)
        set_aircraft_draw_argument_value(ExtLight_BottomCollisionBrightness_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_FuelProbe_arg, 0)
    end

end


need_to_be_closed = false -- close lua state after initialization


