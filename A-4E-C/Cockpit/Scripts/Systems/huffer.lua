dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.1  --10 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

--Creating local variables
local HUFFER_ANIM_ARG	=	402
local HUFFER_STATE	=	0		

-- local lastrpm = 0

--dev:listen_command(Engine_Start)

--function SetCommand(command,value)			

--end

-- TODO: play sounds for huffer/generator

local prev_external_power = false
function update()	
    local external_power_connected = get_elec_external_power()

    if external_power_connected then
        HUFFER_STATE = 1
    else
        HUFFER_STATE = 0
    end
		
	set_aircraft_draw_argument_value(HUFFER_ANIM_ARG, HUFFER_STATE) -- update visual state of huffer

end

need_to_be_closed = false -- close lua state after initialization