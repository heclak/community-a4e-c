local dev 	    = GetSelf()
local my_param  = get_param_handle("TEST_PARAM") -- obtain shared parameter (created if not exist ), i.e. databus

my_param:set(0.1) -- set to 0.1


local update_time_step = 0.1


make_default_activity(update_time_step)
--update will be called 10 times per second

local sensor_data = get_base_data()

local DC_BUS_V  = get_param_handle("DC_BUS_V")
DC_BUS_V:set(0)

function post_initialize()
	electric_system = GetDevice(3) --devices["ELECTRIC_SYSTEM"]
	print("post_initialize called")
end

function update()
	local v = my_param:get()
	print(v)
	my_param:set(sensor_data.getMachNumber())
	if electric_system ~= nil then
	   local DC_V     =  electric_system:get_DC_Bus_1_voltage()
	   local prev_val =  DC_BUS_V:get()
	   -- add some dynamic: 
	   DC_V = prev_val + (DC_V - prev_val) * update_time_step   
	   DC_BUS_V:set(DC_V)
	end	
end




