--carrier launch script
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local update_time_step = 0.016 --update will be called 60 times per second
make_default_activity(update_time_step)
dev = GetSelf()
local catapult_status = 0	-- 1 hooked  	2 fireing

dev:listen_command(device_commands.throttle_axis_mod)
dev:listen_command(Keys.catapult_ready)
dev:listen_command(Keys.catapult_shoot)
dev:listen_command(Keys.catapult_abort)

function post_initialize()
	--print_message_to_user("Init - Carrier")
end

function SetCommand(command,value)
--	print_message_to_user("carrier: command "..tostring(command).." = "..tostring(value))
	
	if command == Keys.catapult_ready then
		if on_carrier() == true and catapult_status == 0 then
			catapult_status = 1
			print_message_to_user("Ready Catapult!")
			
		end
	elseif command == Keys.catapult_shoot then
		if on_carrier() == true and catapult_status == 1 then
			catapult_status = 2
			dispatch_action(nil, 2004,-1)
			print_message_to_user("Fire Catapult!")
		end
	elseif command == Keys.catapult_abort then
			catapult_status = 0
			print_message_to_user("Abort Catapult!")
			dispatch_action(nil,Keys.BrakesOff)
	end
	
	
	if command == device_commands.throttle_axis_mod then
		if  catapult_status == 3 then
			dispatch_action(nil, 2004,-1)
		else	
			if value < 0 then 
				if catapult_status == 2 then
					dispatch_action(nil, 2004,value)
				else
					dispatch_action(nil, 2004,value * 0.999)
				end
			else
				dispatch_action(nil, 2004,value)
			end
		end
	end
			
end

function update()

	get_base_sensor_data()
	
	
	if catapult_status == 0 then
	
	elseif catapult_status == 1 then
		dispatch_action(nil,Keys.BrakesOn)
	elseif catapult_status == 2 then
		dispatch_action(nil,Keys.BrakesOff)
		dispatch_action(nil, 2004,-1)
		catapult_status=3
	elseif catapult_status == 3 then
		dispatch_action(nil, 2004,-1)
		--if on_carrier() == false then
		if tostring(Sensor_Data_Mod.nose_wow) == "0" then
			catapult_status=0
			dispatch_action(nil, 2004,-0.999)
			print_message_to_user("Airborn!")
		end
	else
	
	end
	
	if catapult_status ~= 0 and Sensor_Data_Mod.self_alt > 50 then
		catapult_status = 0
		print_message_to_user("Abnormal Catapult status > Reset to ZERO")
	end
	
	
	if Sensor_Data_Mod.throttle_pos_l > 0.999 and catapult_status == 3 then
		
	elseif  Sensor_Data_Mod.throttle_pos_l > 0.999 then
		dispatch_action(nil, 2004,-0.999)
	end
 
 
	--print_message_to_user(Sensor_Data_Mod.throttle_pos_l)
end

function on_carrier()
	local on_carrier_bool 

	if  tostring(Sensor_Data_Mod.nose_wow) == "1" and Sensor_Data_Mod.self_alt > 20 and Sensor_Data_Mod.self_alt < 23 then
		on_carrier_bool = true
	else
		on_carrier_bool = false
	end
	return on_carrier_bool
end





function get_base_sensor_data()

	Sensor_Data_Raw = get_base_data()
	
	local self_loc_x , own_alt, self_loc_y = Sensor_Data_Raw.getSelfCoordinates()
	Sensor_Data_Mod = 	{
							throttle_pos_l  = Sensor_Data_Raw.getThrottleLeftPosition(),
							throttle_pos_r  = Sensor_Data_Raw.getThrottleRightPosition(),
							mach			= Sensor_Data_Raw.getMachNumber(),
							nose_wow		= Sensor_Data_Raw.getWOW_NoseLandingGear(),
							
							AoS 			= math.deg(Sensor_Data_Raw.getAngleOfSlide()),		--is in rad
							AoA 			= math.deg(Sensor_Data_Raw.getAngleOfAttack()),		--is in rad?
							
							self_m_x 		= self_loc_x,
							self_m_y 		= self_loc_y,
							self_alt 		= own_alt,
							
							self_balt		= Sensor_Data_Raw.getBarometricAltitude(),
							self_ralt		= Sensor_Data_Raw.getRadarAltitude(),
							
							self_pitch		= math.deg(Sensor_Data_Raw.getPitch()),
							self_bank		= math.deg(Sensor_Data_Raw.getRoll()),
							
							self_head			= math.rad(360)-Sensor_Data_Raw.getHeading(),
							self_head_raw		= Sensor_Data_Raw.getHeading(),
							self_head_rad		= math.rad(360)-Sensor_Data_Raw.getHeading(),
							self_head_deg		= -((math.deg(Sensor_Data_Raw.getHeading()))-360),
							
							self_head_wpt_rad	= math.rad((360-(math.deg(Sensor_Data_Raw.getHeading()))) + 0),
							
							self_ias 			=  Sensor_Data_Raw.getIndicatedAirSpeed(),
							true_speed			= Sensor_Data_Raw.getTrueAirSpeed()		,
							--true_speed			= (3600 * (Sensor_Data_Raw.getTrueAirSpeed()))		/ 1000,
							
							eng_l_fuel_usage	=	Sensor_Data_Raw.getEngineLeftFuelConsumption(),
							eng_l_rpm_text		=	Sensor_Data_Raw.getEngineLeftRPM(),
							eng_l_temp_text		=	Sensor_Data_Raw.getEngineLeftTemperatureBeforeTurbine(),
							eng_l_rpm_rot		=	math.rad(180) * (Sensor_Data_Raw.getEngineLeftRPM()),
							eng_l_temp_rot		=	(Sensor_Data_Raw.getEngineLeftTemperatureBeforeTurbine()),
													
							eng_r_fuel_usage	=	Sensor_Data_Raw.getEngineRightFuelConsumption(),
							eng_r_rpm_text		=	Sensor_Data_Raw.getEngineRightRPM(),
							eng_r_temp_text		=	Sensor_Data_Raw.getEngineRightTemperatureBeforeTurbine(),
							eng_r_rpm_rot		=	math.rad(180) * (Sensor_Data_Raw.getEngineRightRPM()),
							eng_r_temp_rot		=	(Sensor_Data_Raw.getEngineRightTemperatureBeforeTurbine()),

							fuel_weight			= 	Sensor_Data_Raw.getTotalFuelWeight(),
						}	

end


--[[
default.lua - joystick 	- axis
	{action = device_commands.throttle_axis_mod 	,cockpit_device_id = devices.CARRIER ,name = _('Modded Throttle Axis')},
						- keys
	{down = Keys.catapult_ready, value_down = 1.0,value_up = 0.0, name = _('Catapult Ready'), category = _('Catapult')},
	{down = Keys.catapult_shoot, value_down = 1.0,value_up = 0.0, name = _('Catapult Shoot'), category = _('Catapult')},
	{down = Keys.catapult_abort, value_down = 1.0,value_up = 0.0, name = _('Catapult Abort'), category = _('Catapult')},					
						

default.lua - keyboard -  keys
	{down = Keys.catapult_ready, value_down = 1.0,value_up = 0.0, name = _('Catapult Ready'), category = _('Catapult')},
	{down = Keys.catapult_shoot, value_down = 1.0,value_up = 0.0, name = _('Catapult Shoot'), category = _('Catapult')},
	{down = Keys.catapult_abort, value_down = 1.0,value_up = 0.0, name = _('Catapult Abort'), category = _('Catapult')},										


	
devices.lua	
	devices["CARRIER"] = counter()

device_init.lua
	creators[devices.CARRIER]			= {	"avLuaDevice",	LockOn_Options.script_path.."Systems/carrier.lua",}

	
command_defs.lua
		Keys:
			catapult_ready  = __custom_counter(),
			catapult_shoot  = __custom_counter(),
			catapult_abort  = __custom_counter(),
			
		device_commands:
			throttle_axis_mod = __counter(),
			
			
			
this file itself > Cockpit/Scripts/systems
	
	
--maybe todo: use Terrain DLL to check if over water
]]--

