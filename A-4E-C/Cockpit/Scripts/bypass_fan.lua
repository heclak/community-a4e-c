local engines_system = GetSelf()

local update_time_step = 0.0167
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local DRAW_FAN			 = 	325
local PropStepLim		 =  0.0833
local propState         =   -1
local propMaxRPM		= 2500

function update()
    --sensor is from 0 to 100 so it is divided by 100 and multiplied by the prop max RPM.
	propRPM = sensor_data.getEngineLeftRPM()*(propMaxRPM/100)
	
	propStep = propRPM*update_time_step/60
	
	--keeps prop animation between 0 and 1
	propState = (propState + propStep)%1

	set_aircraft_draw_argument_value(DRAW_FAN,propState)
end