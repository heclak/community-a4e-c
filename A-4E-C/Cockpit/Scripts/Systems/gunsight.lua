dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev = GetSelf()

local update_time_step = 0.05  --20 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

dev:listen_command(device_commands.GunsightKnob)
dev:listen_command(device_commands.GunsightDayNight)
dev:listen_command(device_commands.GunsightBrightness)
local reflector_pos = 1
local reflector_pos_wma = WMA(0.25, 1-reflector_pos)
local daynight = 0  -- 0=day, 1=night. Night mode adds a 10ohm resistor in series with 150ohm variable resistor
local brightness = 1
local adjusted_brightness = 1
local power_on = false
local power_on_time

local gunsight_reflector_param = get_param_handle("D_GUNSIGHT_REFLECTOR")
local gunsight_reflector_rot_param = get_param_handle("D_GUNSIGHT_REFLECTOR_ROT")
local gunsight_daynight_param = get_param_handle("D_GUNSIGHT_DAYNIGHT")
local gunsight_mil_param = get_param_handle("GUNSIGHT_MIL_ANGLE") -- used for knob mil scale indication eventually
local gunsight_visible = get_param_handle("D_GUNSIGHT_VISIBLE")

gunsight_reflector_param:set(reflector_pos_wma:get_current_val())
gunsight_reflector_rot_param:set(1-reflector_pos_wma:get_current_val())

function post_initialize()
    local dev=GetSelf()
    gunsight_visible:set(0)
    gunsight_daynight_param:set(1)
    gunsight_reflector_param:set(reflector_pos)
    gunsight_reflector_rot_param:set(reflector_pos)
    dev:performClickableAction(device_commands.GunsightKnob, reflector_pos, false)
    dev:performClickableAction(device_commands.GunsightBrightness, (135/360), false) -- set to brightest
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        power_on = true
        power_on_time = -100
        gunsight_visible:set(1)
    end
end

function SetCommand(command,value)
    if (command == device_commands.GunsightKnob) then
        -- print_message_to_user("gunsight:"..tostring(value))
        --[[
        reflector_pos=reflector_pos+value
        if (reflector_pos<0) then
            reflector_pos=0
        end
        if (reflector_pos>1) then
            reflector_pos=1
        end
        --]]
        local gunsight_mil=(1-value)*380
        gunsight_mil=1000*(math.atan(gunsight_mil/1000.0)) -- correction for larger angles (y-movement to angle)
        gunsight_mil=math.floor(gunsight_mil*1000)/1000.0  -- restrict to 3 decimal places
        gunsight_mil_param:set(gunsight_mil)
        reflector_pos=1-value
    elseif (command == device_commands.GunsightElevationControl_AXIS) then
        local normalisedValue = ( ( value + 1 ) / 2 ) * 1.0 -- normalised {-1 to 1} to {0 - 1.0}
        dev:performClickableAction(device_commands.GunsightKnob, normalisedValue, false)
    elseif (command == device_commands.GunsightDayNight) then
        daynight = value -- value 0=day, 1=night
        adjusted_brightness = (daynight==1) and (brightness*0.5) or (brightness)
        --gunsight_daynight_param:set(adjusted_brightness)
    elseif (command == device_commands.GunsightBrightness) then
        -- off from 0 to 45deg, brighter from 45 to 135deg, brightest from 135 to 170 deg  (bulb 1)
        -- off from 170deg to 225 deg, brighter until 315 deg, brightest until 350deg, then off  (bulb 2)
        brightness=0
        if (value>=(45/360) and value<(135/360)) then
            brightness = (value - (45/360) ) / ( (135/360) - (45/360) )
        elseif (value>=(135/360) and value<(170/360)) then
            brightness=1
        elseif (value>=(225/360) and value<(315/360)) then
            brightness = (value - (225/360) ) / ( (315/360) - (225/360) )
        elseif (value>=(315/360) and value<(350/360)) then
            brightness=1
        end
        adjusted_brightness = (daynight==1) and (brightness*0.5) or (brightness)
        --gunsight_daynight_param:set(adjusted_brightness)
    end
end

function update()
    local poswma=reflector_pos_wma:get_WMA(reflector_pos)
    gunsight_reflector_param:set(poswma)
    gunsight_reflector_rot_param:set(1-poswma)

    if get_elec_primary_ac_ok() then -- check if electric power is available
        gunsight_visible:set(1)
        if not power_on then
            power_on = true
            power_on_time = get_model_time()
        end

        -- calculate hud brightness
        local bright_modifier = 1

        -- hud power on effect. hud will gradually fade in if power was only recently available.
        local timenow = get_model_time()
        if ((timenow - power_on_time) < 5) then
            bright_modifier = (timenow - power_on_time)/5
        end
        
        gunsight_daynight_param:set(LinearTodB(adjusted_brightness * bright_modifier))
    else
        gunsight_visible:set(0)
        power_on = false
    end
end

need_to_be_closed = false -- close lua state after initialization

--[[
Notes from NATOPS:
pg 8-4:
The gunsight reticle light control (figure 8-1) is located
on the upper left corner of the instrument panel. By
rotating the control knob, either of two filaments may
be selected for lighting. Light intensity can be
adjusted between the OFF and BRIGHT positions for
either filament.
On A-4E/ F aircraft reworked per A-4 AFC 353-II, a
two-position toggle switch labeled DAY-NIGHT is
located adjacent to the gunsight reticle light controL
When the switch is in the DAY position, a gunsight
light resistor circuit (also added per A-4 AFC 353-II)
is bypassed allOWing maximum power to the gunsight
reticle light control rheostat. With the switch in the
NIGHT position, power is directed through the gunsight
light resistor circuit, resulting in lower light
intensity variance controlled by the reticle light control
rheostat.
--]]