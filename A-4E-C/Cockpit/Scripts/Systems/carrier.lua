--carrier launch script
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local catapult_max_tics 	= 215
local catapult_max_length 	= 75	--stennis catapults should be 118m, but are actualy 100m in game?! Oriskanys should be 75m


-------------------------------------------------
-------------------------------------------------
Terrain   	= require('terrain')

local cat_start_pos ={	x = 0,
						y = 0,
						z = 0,}

local cat_curr_pos = {	x = 0,
						y = 0,
						z = 0,}

local carrier_start_pos =	{	x = 0,
								y = 0,
								z = 0,}						
					

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)
dev = GetSelf()
local catapult_status 	= 0	-- 1 hooked  	2 fireing
local cat_fire_tics		= 0
local cat_hook_tics		= 0
local cat_fire_dist		= 0
local carrier_dist_per_tic = 0

local carrier_tacan		= false
local carrier_heading	= 0
local carrier_tacan_tics= 0

local birth_tics			= 0
local birth_carrier_heading	= 0

local debug_txt =""

dev:listen_command(device_commands.throttle_axis_mod)
dev:listen_command(Keys.catapult_ready)
dev:listen_command(Keys.catapult_shoot)
dev:listen_command(Keys.catapult_abort)


local carrier_posx_param = get_param_handle("CARRIER_POSX")
local carrier_posz_param = get_param_handle("CARRIER_POSZ")

carrier_posx_param:set(0)
carrier_posz_param:set(0)

local theatre = get_terrain_related_data("name")
local magvar = 0	--in radians!
if theatre == "Caucasus" then
	magvar = math.rad(6.1)
elseif theatre == "Persian Gulf" then
	magvar = math.rad(1.5)
end

function post_initialize()
	--print_message_to_user("Init - Carrier- "..theatre)
	
	
end

function SetCommand(command,value)
--	print_message_to_user("carrier: command "..tostring(command).." = "..tostring(value))
	
	if command == Keys.catapult_ready then
		if on_carrier() == true and catapult_status == 0 then
					
			if (birth_carrier_heading - Sensor_Data_Mod.self_head) > -math.rad(3) and
			   (birth_carrier_heading - Sensor_Data_Mod.self_head) < math.rad(12) then
			
				catapult_status = 1
				print_message_to_user("Ready Catapult!\nYou are Hooked in.\nCheck flaps and trim and\nspool up engine")
				
				cat_hook_tics = 0		
			else
				print_message_to_user("You are not correctly aligned")
			end
		else	
			print_message_to_user("You are not on a Carrier!")
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
	

	if on_carrier() == true then
		if birth_tics < 1 then
			birth_tics = birth_tics	+ 1 	
			carrier_start_pos =	{	x = Sensor_Data_Mod.self_m_x,
										y = Sensor_Data_Mod.self_m_y,
										z = Sensor_Data_Mod.self_m_z,}
		elseif birth_tics < 41 then
			birth_tics = birth_tics	+ 1 	
		elseif birth_tics == 41 then
			cat_start_pos =	{	x = Sensor_Data_Mod.self_m_x,
								y = Sensor_Data_Mod.self_m_y,
								z = Sensor_Data_Mod.self_m_z,}
			birth_carrier_heading = calc_bearing( carrier_start_pos.x,	carrier_start_pos.z,cat_start_pos.x,		cat_start_pos.z  )
			if birth_carrier_heading < 0 then birth_carrier_heading = birth_carrier_heading + math.rad(360) end
			cat_start_pos 		= {}
			carrier_start_pos 	= {}
			birth_tics = birth_tics	+ 1 
		--	print_message_to_user(math.deg(birth_carrier_heading))
		else
		end
	end

	
	
	if catapult_status == 0 then
	
	elseif catapult_status == 1 then
		dispatch_action(nil,Keys.BrakesOn)
		
		if cat_hook_tics == 0 then
			carrier_start_pos =	{	x = Sensor_Data_Mod.self_m_x,
									y = Sensor_Data_Mod.self_m_y,
									z = Sensor_Data_Mod.self_m_z,}
		end
		
		cat_hook_tics = cat_hook_tics + 1
		
								
	elseif catapult_status == 2 then
		dispatch_action(nil,Keys.BrakesOff)
		dispatch_action(nil, 2004,-1)
		catapult_status=3
		
		cat_start_pos =	{	x = Sensor_Data_Mod.self_m_x,
							y = Sensor_Data_Mod.self_m_y,
							z = Sensor_Data_Mod.self_m_z,}
							
		local carrier_travel_dist  = math.dist(	cat_start_pos.x,		cat_start_pos.z, 
												carrier_start_pos.x,	carrier_start_pos.z)						
		
		carrier_dist_per_tic=carrier_travel_dist /cat_hook_tics
		carrier_heading = calc_bearing( carrier_start_pos.x,	carrier_start_pos.z,cat_start_pos.x,		cat_start_pos.z  )
		if carrier_heading < 0 then carrier_heading = carrier_heading + math.rad(360) end
			
	
	elseif catapult_status == 3 then
		dispatch_action(nil, 2004,-1)
		cat_curr_pos =	{	x = Sensor_Data_Mod.self_m_x,
							y = Sensor_Data_Mod.self_m_y,
							z = Sensor_Data_Mod.self_m_z,}
		
		cat_fire_dist = math.dist(	cat_start_pos.x,cat_start_pos.z, 
									cat_curr_pos.x,	cat_curr_pos.z)
		
		cat_fire_dist = cat_fire_dist - (carrier_dist_per_tic * cat_fire_tics)							
		cat_fire_tics = cat_fire_tics + 1 
		
		--if cat_fire_dist > 2 then --catapult_max_length then
		if cat_fire_dist > catapult_max_length then
			catapult_status=0
			dispatch_action(nil, 2004,-0.999)
			print_message_to_user("Airborn!")
			cat_start_pos = 0
			cat_curr_pos  = 0
			cat_fire_tics = 0
			cat_fire_dist = 0
			
			carrier_tacan_tics = 0
			carrier_tacan = true
			carrier_start_pos =	{	x = Sensor_Data_Mod.self_m_x,
									y = Sensor_Data_Mod.self_m_y,
									z = Sensor_Data_Mod.self_m_z,}
									
		
			
		end
	else
	
	end
	
	if catapult_status ~= 0 and Sensor_Data_Mod.self_alt > 50 then
		catapult_status = 0
		print_message_to_user("Abnormal Catapult status > Reset to ZERO")
		
		cat_start_pos = 0
		cat_curr_pos  = 0
		cat_fire_tics = 0
		
	end
	
	
	if Sensor_Data_Mod.throttle_pos_l > 0.999 and catapult_status == 3 then
	elseif  Sensor_Data_Mod.throttle_pos_l > 0.9999 then
		dispatch_action(nil, 2004,-0.999)
	end
 
	if carrier_tacan == true then
		calc_carrier_position()
	end
	
end

function on_carrier()
	local on_carrier_bool 

	if  tostring(Sensor_Data_Mod.nose_wow) == "1" and Sensor_Data_Mod.self_alt > 20 and Sensor_Data_Mod.self_alt < 23 and 
		Terrain.GetSurfaceType(Sensor_Data_Mod.self_m_x,Sensor_Data_Mod.self_m_z) == "sea" then
		
		on_carrier_bool = true
	else
		on_carrier_bool = false
	end
	return on_carrier_bool
end


local dummy_tic = 0
function calc_carrier_position()
	carrier_tacan_tics = carrier_tacan_tics + 1
	
	local act_travel_dist = carrier_tacan_tics * carrier_dist_per_tic
	local new_x,new_z =pnt_dir(carrier_start_pos.x,carrier_start_pos.z,carrier_heading,act_travel_dist)

	carrier_posx_param:set(new_x)
	carrier_posz_param:set(new_z)
	
	--[[ --DEBUG
	dummy_tic = dummy_tic + 1
	if dummy_tic > 50*60 then
		
		print_message_to_user(math.deg(carrier_heading))
		dummy_tic=0
		
		print_message_to_user("tacandist "..string.format("%.0f",math.dist(	Sensor_Data_Mod.self_m_x,Sensor_Data_Mod.self_m_z, new_x,new_z ))
								.."\n" ..string.format("%.0f",Sensor_Data_Mod.self_m_x) .." / ".. string.format("%.0f",new_x)
								.."\n" ..string.format("%.0f",Sensor_Data_Mod.self_m_z) .." / ".. string.format("%.0f",new_z))
		
		debug_txt =debug_txt  .."\n".."tacandist "..string.format("%.0f",math.dist(	Sensor_Data_Mod.self_m_x,Sensor_Data_Mod.self_m_z, new_x,new_z ))
		print_message_to_user(debug_txt)
	end
	]]--
end



function get_base_sensor_data()

	Sensor_Data_Raw = get_base_data()
	
	local self_loc_x , own_alt, self_loc_y = Sensor_Data_Raw.getSelfCoordinates()
	local self_vel_l,	self_vel_v,self_vel_h = Sensor_Data_Raw.getSelfAirspeed()
	Sensor_Data_Mod = 	{
							throttle_pos_l  = Sensor_Data_Raw.getThrottleLeftPosition(),
							throttle_pos_r  = Sensor_Data_Raw.getThrottleRightPosition(),
							mach			= Sensor_Data_Raw.getMachNumber(),
							nose_wow		= Sensor_Data_Raw.getWOW_NoseLandingGear(),
							
							AoS 			= math.deg(Sensor_Data_Raw.getAngleOfSlide()),		--is in rad
							AoA 			= math.deg(Sensor_Data_Raw.getAngleOfAttack()),		--is in rad?
							
							self_m_x 		= self_loc_x,
							self_m_z 		= self_loc_y,
							self_m_y 		= own_alt,
							self_alt 		= own_alt,
							
							self_vl			= self_vel_l,
							self_vv			= self_vel_v,
							self_vh			= self_vel_h,
							self_gs			= math.sqrt(self_vel_h^2 + self_vel_l^2),	--grondspeed meters/s
							
							
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

function math.dist(x1,y1, x2,y2) 
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end

function calc_bearing(self_x, self_z,loc_x, loc_z)
	local tmp_bearing
	tmp_bearing = math.atan2(loc_z-self_z, loc_x-self_x)
		
	return tmp_bearing,math.deg(tmp_bearing)
end


function pnt_dir(pnt_x,pnt_z,angle_rad,distance)
	local new_x,new_z
	--angle_rad = angle_rad + 0
 
	if angle_rad < 0 then angle_rad = angle_rad + math.rad(360) end
		
	new_z = pnt_z + (distance * math.sin(angle_rad))
	new_x = pnt_x + (distance * math.cos(angle_rad))

	return new_x,new_z
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
	
]]--

