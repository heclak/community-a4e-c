


--carrier launch script
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local update_time_step = 0.016 --update will be called 60 times per second
make_default_activity(update_time_step)
dev = GetSelf()

local iCommandPlaneWheelBrakeOn 	= 74
local iCommandPlaneWheelBrakeOff 	= 75

--dev:listen_command(device_commands.throttle_axis_mod)
dev:listen_command(device_commands.pitch_axis_mod)
dev:listen_command(device_commands.roll_axis_mod)
dev:listen_command(device_commands.rudder_axis_mod)



local iCommandPlaneLeftRudderStart	= 201
local iCommandPlaneLeftRudderStop	= 202
local iCommandPlaneRightRudderStart	= 203
local iCommandPlaneRightRudderStop	= 204

dev:listen_command(iCommandPlaneLeftRudderStart)
dev:listen_command(iCommandPlaneLeftRudderStop)
dev:listen_command(iCommandPlaneRightRudderStart)
dev:listen_command(iCommandPlaneRightRudderStop)


--[[
dev:listen_command(Keys.sfm_ext_debug1)
dev:listen_command(Keys.sfm_ext_debug2)
dev:listen_command(Keys.sfm_ext_debug2)
]]--

--dev:listen_command(2003)
--GetDevice(0):listen_command(2003)

--dev:listen_command(iCommandPlaneWheelBrakeOn)
--dev:listen_command(iCommandPlaneWheelBrakeOff)


local max_auth_roll = 0.25		--1 max auth 0 no authority

local arg_roll 	= 2002
local arg_pitch = 2001
local arg_rudder= 2003

local mod_roll 	= 0
local mod_pitch = 0
local mod_rudder= 0
local des_rudder_ground = 0
local mod_rudder_ground = 0
local des_pitch	=0

local input_roll = 0
local input_pitch = 0
local input_rudder= 0

local auth_roll 	= 1
local auth_pitch 	= 1
local auth_rudder	= 1

local depart_base	= 0.0001--0.0001-- 0.001
local depart_act	= depart_base--0.01--0.001
local depart_max	= 0.1

local depart_aoa_start	= 21	--22	--20
local auth_aoa_start	= 17	--15
local depart_tic		= 0
local depart_time		= 0

local key_rudder_dir	= 0
local key_rudder_active	= 0


function post_initialize()
--	print_message_to_user("Init - SFM extender")
end

function SetCommand(command,value)
--	print_message_to_user("SFM: command "..tostring(command).." = "..tostring(value))
--[[	
	if command == device_commands.pitch_axis_mod then
		input_pitch = value
		--des_pitch= value
	end
	
	if command == device_commands.roll_axis_mod then
		input_roll = value
	end
]]--	

	if command == device_commands.rudder_axis_mod then
		key_rudder_active = 0
		if Sensor_Data_Mod.nose_wow == 1 then
			input_rudder 		= value
			des_rudder_ground   = round(value,2)
		else
			input_rudder = value
			des_rudder_ground =0
			
		end
	elseif command == iCommandPlaneLeftRudderStart then
		key_rudder_dir = - 0.01
		input_rudder = -1
		
	elseif command == iCommandPlaneRightRudderStart then
		key_rudder_dir =  0.01
		input_rudder = 1
		
	elseif command == iCommandPlaneRightRudderStop or command == iCommandPlaneLeftRudderStop then
		key_rudder_dir = 0
		key_rudder_active = 1
		input_rudder = 0
	end
	
	
	--[[
	if command == Keys.sfm_ext_debug1 then
		
	elseif command == Keys.sfm_ext_debug2 then
		
	end
]]--
end



function update()
	get_base_sensor_data()
	
	
--	print_message_to_user(des_rudder_ground)
	if Sensor_Data_Mod.nose_wow == 1 then
		--print_message_to_user("WOW")
	end
	
--	local pluginData =  get_plugin_option_value("A-4E-C","rwrType","local")
--	print_message_to_user(pluginData)
	
--	print_message_to_user(dir(LockOn_Options))--.init_conditions.birth_place)
	---print_message_to_user(dir(LockOn_Options.init_conditions))--.birth_place)
	
--	print_message_to_user(Sensor_Data_Mod.eng_l_fuel_usage)
	
	--print_message_to_user("AoA: "..Sensor_Data_Mod.AoA .. "\n"..mod_roll)
	--print_message_to_user(string.format("%.1f",auth_roll))
	--print_message_to_user("AoA: "..string.format("%.1f",Sensor_Data_Mod.AoA))


-----------------------------	
--	aoa_auth_roll()
--	speed_auth_roll()
--	mod_roll	= depart_mod(mod_roll)
--	mod_rudder	= depart_mod(mod_rudder)
--	mod_dump_pitch()	
-----------------------------	
	
--	mod_dump_pitch()	
	rudder()
	
	
	--[[
	if Sensor_Data_Mod.AoA > 15 then	
		if Sensor_Data_Mod.self_bank > 0 then
			mod_roll = mod_roll + 0.001
		else
			mod_roll = mod_roll - 0.001
		end
	else
	mod_roll 	= 0
		
	end
	
	]]--
	--[[	
	
		if auth_roll > 0 and auth_roll < 1 then
			auth_roll =auth_roll + 0.01
		elseif auth_roll < 0 and auth_roll > -1 then
			auth_roll =auth_roll - 0.01
		end
		]]--
		
	--[[	
		if des_pitch == ((input_pitch	* auth_pitch) 	+ mod_pitch) then
		
		elseif des_pitch > ((input_pitch	* auth_pitch) 	+ mod_pitch) then
				input_pitch = input_pitch + 0.005
		elseif des_pitch < ((input_pitch	* auth_pitch) 	+ mod_pitch) then
				input_pitch = input_pitch - 0.005
		end	
		]]--
	
---------------	
--	dispatch_action(nil, 2001,(input_pitch	* auth_pitch) 	+ mod_pitch)
--	dispatch_action(nil, 2002,(input_roll	* auth_roll) 	+ mod_roll)
---------------	
	
	
end


function rudder()

	if (des_rudder_ground > 0.99 or des_rudder_ground < -0.99) and key_rudder_dir ~= 0 then
	
	elseif key_rudder_dir ~= 0 then
		des_rudder_ground = des_rudder_ground + key_rudder_dir
		
	elseif key_rudder_dir == 0 and des_rudder_ground ~= 0 and key_rudder_active == 1 then
		if des_rudder_ground < 0 then
			des_rudder_ground = des_rudder_ground + 0.01
		elseif des_rudder_ground > 0 then
			des_rudder_ground = des_rudder_ground - 0.01
		end
	end
	

	if Sensor_Data_Mod.nose_wow == 1 then
--		print_message_to_user(des_rudder_ground)
		if des_rudder_ground == mod_rudder_ground then
		
		elseif des_rudder_ground > mod_rudder_ground then
				mod_rudder_ground = mod_rudder_ground + 0.01
		elseif des_rudder_ground < mod_rudder_ground then
				mod_rudder_ground = mod_rudder_ground - 0.01
		end
		 
		--dispatch_action(nil, 2003,(input_rudder	* auth_rudder) 	+ mod_rudder_ground)
		dispatch_action(nil, 2003,mod_rudder_ground)
	else
		dispatch_action(nil, 2003,(input_rudder	* auth_rudder) 	+ mod_rudder)
	end

end

function aoa_auth_roll()
	local calc_aoa = Sensor_Data_Mod.AoA - auth_aoa_start--15
--	print_message_to_user(string.format("calc_aoa:  %.1f",calc_aoa))
	if calc_aoa > 0 then
		auth_roll = 1-(calc_aoa/15)
	else
		auth_roll = 1
	end
	
	if auth_roll < max_auth_roll then auth_roll= max_auth_roll end
end

function speed_auth_roll()

end

function mod_dump_pitch()
	local ias = Sensor_Data_Mod.self_ias	--m/s
	local inverted = -1
	--print_message_to_user(Sensor_Data_Mod.self_bank)
	--mod_pitch
	if Sensor_Data_Mod.nose_wow == 1 then

	else
		if Sensor_Data_Mod.self_bank > 90 or Sensor_Data_Mod.self_bank < -90 then
			inverted = 1
		else
			inverted = -1
		end
	
	
		if ias < 60 then
			mod_pitch = (1-((ias-40)/20))*inverted	-- -1
		--	print_message_to_user(mod_pitch)
		else
			mod_pitch = 0
		end
	end
end

function mod_dump_pitch____x()
	local aoa_factor = ((Sensor_Data_Mod.AoA - depart_aoa_start) / 15) + 1
--print_message_to_user(aoa_factor)
--depart_time
--print_message_to_user("AoA: "..string.format("%.1f",Sensor_Data_Mod.AoA).."\n" ..string.format("%.1f",aoa_factor))
	if Sensor_Data_Mod.AoA > depart_aoa_start then	
		mod_pitch = -2
	--	depart_act = depart_act + depart_base
		if depart_act > depart_max then depart_act = depart_max end
	else
		mod_pitch = 0
		depart_act = depart_base
	end
	
	--print_message_to_user(string.format("%.1f",axis))
	
end

function depart_mod(axis)
	local aoa_factor_base = ((Sensor_Data_Mod.AoA - depart_aoa_start) / 15) --+ 1
	local aoa_factor = aoa_factor_base + 1
	aoa_factor = aoa_factor * (make_positiv(Sensor_Data_Mod.self_bank) / 180 + 1)
--print_message_to_user(aoa_factor)
--[[
print_message_to_user("AoA: "..	string.format("%.1f",Sensor_Data_Mod.AoA).."\n" ..
								string.format("aoaFactor %.1f",aoa_factor_base) .."\n"..
								string.format("RudderPos %.1f",Sensor_Data_Mod.rudder_pos).."\n"..
								string.format("BankAngle %.1f",Sensor_Data_Mod.self_bank)
								)
							]]--
	if Sensor_Data_Mod.AoA > depart_aoa_start then	
		if Sensor_Data_Mod.self_bank > 0 then
			--axis = axis + depart_act--0.001
			if depart_tic > 0 then
				axis = axis + depart_act * aoa_factor
			end
		else
			--axis = axis	- depart_act--0.001
			if depart_tic > 0 then
				axis = axis -depart_act * aoa_factor
			end
		end
		depart_act = depart_act + depart_base
		if depart_act > depart_max then depart_act = depart_max end
	else
		axis = 0
		depart_act = depart_base
	end
	
	
	depart_tic = depart_tic + 1
	if depart_tic > 2 then depart_tic = -1 end 
	--print_message_to_user(string.format("%.1f",axis))
	
	
	local max_axis = aoa_factor_base  --0.75
	if aoa_factor_base > 0 then
		if axis > max_axis then
			axis = max_axis
		elseif axis < -max_axis then
			axis = -max_axis
		end
	end	
	
	
	return axis
	
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

function make_positiv(number)
	if number < 0 then number = number * -1 end
	return number
end



function get_base_sensor_data()

	Sensor_Data_Raw = get_base_data()
	
	local self_loc_x , own_alt, self_loc_y = Sensor_Data_Raw.getSelfCoordinates()
	Sensor_Data_Mod = 	{
							throttle_pos_l  = Sensor_Data_Raw.getThrottleLeftPosition(),
							throttle_pos_r  = Sensor_Data_Raw.getThrottleRightPosition(),
							rudder_pos		= Sensor_Data_Raw.getRudderPosition(),
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
	{action = device_commands.pitch_axis_mod 	,cockpit_device_id = devices.SFMEXTENDER ,name = _('Pitch Axis')},
	{action = device_commands.roll_axis_mod 	,cockpit_device_id = devices.SFMEXTENDER ,name = _('Roll Axis')},
	{action = device_commands.rudder_axis_mod 	,cockpit_device_id = devices.SFMEXTENDER ,name = _('Rudder Axis')},					
						
								


	
devices.lua	
	devices["SFMEXTENDER"] = counter()

device_init.lua
	creators[devices.SFMEXTENDER]			= {	"avLuaDevice",	LockOn_Options.script_path.."Systems/sfm_extender.lua",}

	
command_defs.lua
		Keys:
	
			
		device_commands:
			pitch_axis_mod = __counter(),
			roll_axis_mod = __counter(),
			rudder_axis_mod = __counter(),
			
			
this file itself > Cockpit/Scripts/systems
	
]]--


--[[
command = 2001 - joystick pitch
command = 2002 - joystick roll
command = 2003 - joystick rudder
-- Thrust values are inverted for some internal reasons, sorry.
command = 2004 - joystick thrust (both engines)
command = 2005 - joystick left engine thrust
command = 2006 - joystick right engine thrust
command = 2007 - mouse camera rotate left/right  
command = 2008 - mouse camera rotate up/down
command = 2009 - mouse camera zoom 
command = 2010 - joystick camera rotate left/right
command = 2011 - joystick camera rotate up/down
command = 2012 - joystick camera zoom 
command = 2013 - mouse pitch
command = 2014 - mouse roll
command = 2015 - mouse rudder
-- Thrust values are inverted for some internal reasons, sorry.
command = 2016 - mouse thrust (both engines)
command = 2017 - mouse left engine thrust
command = 2018 - mouse right engine thrust
command = 2019 - mouse trim pitch
command = 2020 - mouse trim roll
command = 2021 - mouse trim rudder
command = 2022 - joystick trim pitch
command = 2023 - joystick trim roll
command = 2024 - trim rudder
command = 2025 - mouse rotate radar antenna left/right
command = 2026 - mouse rotate radar antenna up/down
command = 2027 - joystick rotate radar antenna left/right
command = 2028 - joystick rotate radar antenna up/down
command = 2029 - mouse MFD zoom
command = 2030 - joystick MFD zoom
command = 2031 - mouse move selecter left/right
command = 2032 - mouse move selecter up/down
command = 2033 - joystick move selecter left/right
command = 2034 - joystick move selecter up/down
]]--

