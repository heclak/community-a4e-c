local dev = GetSelf()
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/stores_config.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local update_time_step = 0.02  --50 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


local Canopy = 71 -- This is the number of the command from command_defs


--Creating local variables
local initial_canopy = get_aircraft_draw_argument_value(38)
local CANOPY_COMMAND	=	0   -- 0 closing, 1 opening, 2 jettisoned
if (initial_canopy>0) then
    CANOPY_COMMAND = 1
end

local HIDESTICK         =   0   -- 0 = visible, 1 = hidden
local HideStick = get_param_handle("HIDE_STICK")

dev:listen_command(Canopy)
dev:listen_command(Keys.ToggleStick)

--dev:listen_command(CanopyOpenClose) --test

-- getCanopyPos
-- getCanopyState


function SetCommand(command,value)			
	
	if (command == Canopy) then
        if CANOPY_COMMAND <= 1 then -- only toggle while not jettisoned
            CANOPY_COMMAND = 1-CANOPY_COMMAND --toggle
        end
    elseif command == Keys.ToggleStick then
        HIDESTICK = 1 - HIDESTICK
	end
end

local prev_canopy_val=-1
function update()		
	local curvalue=get_aircraft_draw_argument_value(38)
    if curvalue > 0.95 then
        CANOPY_COMMAND = 2 -- jetissoned
    end
	if (CANOPY_COMMAND == 0 and curvalue > 0) then
		-- lower canopy in increments of 0.01 (50x per second)
		curvalue = curvalue - 0.01
        set_aircraft_draw_argument_value(38,curvalue)
	elseif (CANOPY_COMMAND == 1 and curvalue <= 0.89) then
        -- raise canopy in increment of 0.01 (50x per second)
		curvalue = curvalue + 0.01
        set_aircraft_draw_argument_value(38,curvalue)
	end
    local cockpit_lever=get_cockpit_draw_argument_value(129)
    if prev_canopy_val ~= cockpit_lever then
        local canopy_lever_clickable_ref = get_clickable_element_reference("PNT_129")
        canopy_lever_clickable_ref:update() -- ensure the connector moves too
        prev_canopy_val = cockpit_lever
    end

    HideStick:set(HIDESTICK)
end

need_to_be_closed = false -- close lua state after initialization