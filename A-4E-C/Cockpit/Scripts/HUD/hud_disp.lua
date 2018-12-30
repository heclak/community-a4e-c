dofile(LockOn_Options.script_path.."utils.lua")

startup_print("hud_disp: load")
local dev 	    = GetSelf()

local current_PITCH  	 = get_param_handle("D_PITCH")
local current_ROLL  	 = get_param_handle("D_ROLL")

local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)
--update will be called 50 times per second

function post_initialize()
    startup_print("hud_disp: postinit")

	current_PITCH:set(sensor_data.getPitch())
	current_ROLL:set(sensor_data.getRoll())

    startup_print("hud_disp: postinit end")
end

function update()
	current_PITCH:set(sensor_data.getPitch())
	current_ROLL:set(sensor_data.getRoll())
end

startup_print("hud_disp: load end")
need_to_be_closed = false -- close lua state after initialization
