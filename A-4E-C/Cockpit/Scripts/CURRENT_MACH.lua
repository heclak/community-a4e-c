local dev 	    = GetSelf()
local current_mach  = get_param_handle("CURRENT_MACH") -- obtain shared parameter (created if not exist ), i.e. databus

current_mach:set(0.1) -- set to 0.1


local update_time_step = 0.1


make_default_activity(update_time_step)
--update will be called 10 times per second

local sensor_data = get_base_data()

function update()
	local mach = sensor_data.getMachNumber()
	
	current_mach:set(mach)
end




