dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step) -- enables call to update

local sensor_data = get_base_data()



function post_initialize()
end



function update()
	--Test set anim argument
	--[[

	local ROLL_STATE = sensor_data:getStickPitchPosition() / 100
	set_aircraft_draw_argument_value(11, ROLL_STATE) -- right aileron
	set_aircraft_draw_argument_value(12, -ROLL_STATE) -- left aileron
	

	local PITCH_STATE = sensor_data:getStickRollPosition() / 100
	set_aircraft_draw_argument_value(15, PITCH_STATE) -- right elevator
	set_aircraft_draw_argument_value(16, PITCH_STATE) -- left elevator

	local RUDDER_STATE = sensor_data:getRudderPosition() / 100
	set_aircraft_draw_argument_value(17, -RUDDER_STATE)
	
	if get_elec_retraction_release_ground() then
        set_aircraft_draw_argument_value(2, -RUDDER_STATE*0.333) -- limit visual nosewheel deflection to 30 degrees
    else
        set_aircraft_draw_argument_value(2, 0)  -- otherwise center it
    end

    local pitch_trim_handle = get_param_handle("PITCH_TRIM")
    local pitch_trim = pitch_trim_handle:get() -- from -0.24 (1deg down) to 1.0 (13 deg up)
    if pitch_trim>=0 then
        set_aircraft_draw_argument_value(117, pitch_trim)
    elseif pitch_trim<0 then
        set_aircraft_draw_argument_value(117, (1.0/0.24)*pitch_trim)
    end
    
	--print(ROLL_STATE)
	--print(PITCH_STATE)
	]]
end

need_to_be_closed = false -- close lua state after initialization
