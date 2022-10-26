dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")


local dev = GetSelf()

local update_time_step = 0.05  --20 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()
local efm_data_bus = get_efm_data_bus()

dev:listen_command(Keys.GunsightElevationInc)
dev:listen_command(Keys.GunsightElevationDec)
dev:listen_command(Keys.GunsightElevationStartUp)
dev:listen_command(Keys.GunsightElevationStartDown)
dev:listen_command(Keys.GunsightElevationStop)
dev:listen_command(Keys.GunsightBrightnessInc)
dev:listen_command(Keys.GunsightBrightnessDec)
dev:listen_command(Keys.GunsightBrightnessStartUp)
dev:listen_command(Keys.GunsightBrightnessStartDown)
dev:listen_command(Keys.GunsightBrightnessStop)
dev:listen_command(Keys.GunsightDayNightToggle)

dev:listen_command(device_commands.GunsightKnob)
dev:listen_command(device_commands.GunsightDayNight)
dev:listen_command(device_commands.GunsightBrightness)

dev:listen_command(device_commands.gunsight_brightness_axis)
dev:listen_command(device_commands.gunsight_brightness_axis)
dev:listen_command(device_commands.gunsight_elevation_axis)
dev:listen_command(device_commands.gunsight_elevation_axis)


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

-- position variables for keybinds
local gunsight_elevation_pos = 0
local gunsight_elevation_moving = 0
local gunsight_brightness_pos = 0
local gunsight_brightness_moving = 0

gunsight_reflector_param:set(reflector_pos_wma:get_current_val())
gunsight_reflector_rot_param:set(1-reflector_pos_wma:get_current_val())

local maximum_gunsight_angle = 360 --In mils
local MIL_TO_RADIAN = 9.817477042e-4

function gunsightAngleToRads()
	--print_message_to_user(maximum_gunsight_angle * reflector_pos * MIL_TO_RADIAN)
	return maximum_gunsight_angle * reflector_pos * MIL_TO_RADIAN
end

function post_initialize()
    local dev=GetSelf()
    gunsight_visible:set(0)
    gunsight_daynight_param:set(1)
    gunsight_reflector_param:set(reflector_pos)
    gunsight_reflector_rot_param:set(reflector_pos)
    dev:performClickableAction(device_commands.GunsightKnob, reflector_pos, false)
    dev:performClickableAction(device_commands.GunsightBrightness, (135/360), false)
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        power_on = true
        power_on_time = -100
        gunsight_visible:set(1)
    end

    -- night time setup
    local abstime = get_absolute_model_time()
    local hours = abstime / 3600.0

    if hours <= 6 or hours >= 17 then
        dev:performClickableAction(device_commands.GunsightDayNight, 1.0, false)
    end

end

function SetCommand(command,value)

    local nightbright = 0.25 --brightness reduction factor when night switch is engaged

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
        gunsight_elevation_pos = value
    elseif (command == device_commands.gunsight_elevation_axis) then
        gunsight_elevation_moving = value/150
    elseif (command == device_commands.gunsight_elevation_axis_abs) then
        dev:performClickableAction(device_commands.GunsightKnob, (value + 1)*0.5, false)
    elseif (command == device_commands.GunsightDayNight) then
        daynight = value -- value 0=day, 1=night
        adjusted_brightness = (daynight==1) and (brightness * nightbright) or (brightness)
        --gunsight_daynight_param:set(adjusted_brightness)
    elseif (command == device_commands.gunsight_brightness_axis) then
        gunsight_brightness_moving = value/80
    elseif (command == device_commands.gunsight_brightness_axis_abs) then
        dev:performClickableAction(device_commands.GunsightBrightness, (value + 1)*0.5, false)
    elseif (command == device_commands.GunsightBrightness) then
        gunsight_brightness_pos = value
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
        adjusted_brightness = (daynight==1) and (brightness * nightbright) or (brightness)
        --gunsight_daynight_param:set(adjusted_brightness)
    end

    -- keybinds
    if command == Keys.GunsightElevationInc then
        dev:performClickableAction(device_commands.GunsightKnob, clamp(gunsight_elevation_pos + 0.013875, 0, 1), false)
    elseif command == Keys.GunsightElevationDec then
        dev:performClickableAction(device_commands.GunsightKnob, clamp(gunsight_elevation_pos - 0.013875, 0, 1), false)
    elseif command == Keys.GunsightElevationStartUp then
        gunsight_elevation_moving = 1/300
    elseif command == Keys.GunsightElevationStartDown then
        gunsight_elevation_moving = -1/300
    elseif command == Keys.GunsightElevationStop then
        gunsight_elevation_moving = 0
    elseif command == Keys.GunsightBrightnessInc then
        dev:performClickableAction(device_commands.GunsightBrightness, clamp(gunsight_brightness_pos + 0.025, 0, 1), false)
    elseif command == Keys.GunsightBrightnessDec then
        dev:performClickableAction(device_commands.GunsightBrightness, clamp(gunsight_brightness_pos - 0.025, 0, 1), false)
    elseif command == Keys.GunsightBrightnessStartUp then
        gunsight_brightness_moving = 1/120
    elseif command == Keys.GunsightBrightnessStartDown then
        gunsight_brightness_moving = -1/120
    elseif command == Keys.GunsightBrightnessStop then
        gunsight_brightness_moving = 0
    elseif command == Keys.GunsightDayNightToggle then
		dev:performClickableAction((device_commands.GunsightDayNight), ((daynight * -1) +1), false)
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
	
    -- continuous movement for keybinds and slew
    if gunsight_elevation_moving ~= 0 then
        dev:performClickableAction(device_commands.GunsightKnob, clamp(gunsight_elevation_pos + gunsight_elevation_moving, 0, 1), false)
    end
    if gunsight_brightness_moving ~= 0 then
        dev:performClickableAction(device_commands.GunsightBrightness, clamp(gunsight_brightness_pos + gunsight_brightness_moving, 0, 1), false)
    end

	efm_data_bus.fm_setGunsightAngle(gunsightAngleToRads())

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