
my_carrier = nil
--carrier launch script
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/debug.lua")


dofile(LockOn_Options.script_path.."Systems/mission.lua")
--dofile(LockOn_Options.script_path.."Systems//mission.lua")

local catapult_max_tics 	= 215
--local catapult_max_length 	= 75	--stennis catapults should be 118m, but are actualy 100m in game?! Oriskanys should be 75m
local catapult_max_length 	= 100	--stennis catapults should be 118m, but are actualy 100m in game?! Oriskanys should be 75m

--local miz_carriers = {}
 
 --model_time
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
local birth_carrier_heading	= -999

local debug_txt =""

dev:listen_command(device_commands.throttle_axis_mod)
dev:listen_command(Keys.catapult_ready)
dev:listen_command(Keys.catapult_shoot)
dev:listen_command(Keys.catapult_abort)


local carrier_posx_param = get_param_handle("CARRIER_POSX")
local carrier_posz_param = get_param_handle("CARRIER_POSZ")

carrier_posx_param:set(0)
carrier_posz_param:set(0)

local wheelchocks_state_param = get_param_handle("WHEEL_CHOCKS_STATE")


local iCommandPlaneWheelBrakeOn = 74	--dispatch_action(nil,iCommandPlaneWheelBrakeOn)
local iCommandPlaneWheelBrakeOff = 75	--dispatch_action(nil,iCommandPlaneWheelBrakeOff)



local theatre = get_terrain_related_data("name")
local magvar = 0	--in radians!
if theatre == "Caucasus" then
	magvar = math.rad(6.1)
elseif theatre == "Persian Gulf" then
	magvar = math.rad(1.5)
end

function post_initialize()
--	print_message_to_user("Init - Carrier- "..theatre)
--decode_mission()

	load_tempmission_file() 
	miz_carriers = decode_mission()
end



function SetCommand(command,value)
--	print_message_to_user("carrier: command "..tostring(command).." = "..tostring(value))
	
	if command == Keys.catapult_ready then
		if on_carrier() == true and catapult_status == 0 and
			wheelchocks_state_param:get() == 0 then
			
			compare_carriers()
	
			if (birth_carrier_heading - Sensor_Data_Mod.self_head) > -math.rad(3) and
			   (birth_carrier_heading - Sensor_Data_Mod.self_head) < math.rad(12) and birth_carrier_heading ~= -999 then
			--if my_carrier and ( my_carrier.heading > -math.rad(3) and my_carrier.heading < math.rad(12)) then
				catapult_status = 1
				print_message_to_user("The catapult is ready!\nYou are hooked in.\nCheck takeoff flaps and trim\nSpool up the engine to max MIL\nSignal FIRE CATAPULT when ready.", 10)
				
				cat_hook_tics = 0		
			else
				print_message_to_user("You are not correctly aligned")
			--	print_message_to_user(birth_carrier_heading .. "\n" ..Sensor_Data_Mod.self_head )
			end
			
		elseif wheelchocks_state_param:get() == 1 then
				print_message_to_user("Wheel chocks are on!")	
		else	
			print_message_to_user("You are not on a carrier!")
		end
	elseif command == Keys.catapult_shoot then
		if on_carrier() == true and catapult_status == 1 then
		
			if Sensor_Data_Mod.throttle_pos_l > 0.9 then
				catapult_status = 2
				dispatch_action(nil, 2004,-1)
				print_message_to_user("Fire Catapult!")
			else
				print_message_to_user("Engines are not at max MIL power!")
			end
		end
	elseif command == Keys.catapult_abort then
			
			if catapult_status ~= 0 then
				catapult_status = 0
				print_message_to_user("Abort Takeoff! Unhooking the plane")
				--dispatch_action(nil,Keys.BrakesOff)
				dispatch_action(nil,iCommandPlaneWheelBrakeOff)
			end
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
	model_time = get_model_time()
	
--	local test = get_model_time
--	print_message_to_user(test)
--	print_message_to_user("modeltime:  " .. get_model_time())
--	print_message_to_user("Abs time:   " .. get_absolute_model_time())
	--print_message_to_user(get_aircraft_type())
	
	
	--if on_carrier() == true then
		
		
		--[[
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
		--	birth_carrier_heading = -999
		else
		end
		]]--
	--end

	if birth_tics < 41 then
		birth_tics = birth_tics	+ 1 	
	end
	
	if birth_tics == 40 and mission then
	--	miz_carriers = decode_mission()
	--	compare_carriers()
	end
	
	if catapult_status == 0 then
	
	elseif catapult_status == 1 then
		--dispatch_action(nil,Keys.BrakesOn)
		dispatch_action(nil,iCommandPlaneWheelBrakeOn)
		
		if cat_hook_tics == 0 then
			carrier_start_pos =	{	x = Sensor_Data_Mod.self_m_x,
									y = Sensor_Data_Mod.self_m_y,
									z = Sensor_Data_Mod.self_m_z,}
		end
		
		cat_hook_tics = cat_hook_tics + 1
		
								
	elseif catapult_status == 2 then
		--dispatch_action(nil,Keys.BrakesOff)
		dispatch_action(nil,iCommandPlaneWheelBrakeOff)
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
			print_message_to_user("Airborne!")
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
	
--	print_message_to_user(my_carrier.heading)
--	update_tacans()
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



function compare_carriers()
	local tmp_carrier
	local closest_carrier_dist = 9999999
	update_carrier_pos()

	for i = 1,#miz_carriers do
--[[	
		local act_travel_dist = model_time * miz_carriers[i].speed
			local new_x,new_z =pnt_dir(	miz_carriers[i].x,
										miz_carriers[i].z,
										miz_carriers[i].heading,
										act_travel_dist)
		]]--
		local tmp_dist = math.dist(Sensor_Data_Mod.self_m_x,Sensor_Data_Mod.self_m_z,miz_carriers[i].act_x,miz_carriers[i].act_z)--miz_carriers[i].x,miz_carriers[i].z)
--		print_message_to_user(tmp_dist)

		if tmp_dist < closest_carrier_dist then
			closest_carrier_dist = tmp_dist
			tmp_carrier = miz_carriers[i]
		end
	end	
			
	print_message_to_user(">>"..closest_carrier_dist)	

	if closest_carrier_dist < 500 then
		my_carrier = tmp_carrier
		birth_carrier_heading = my_carrier.heading
--		print_message_to_user( my_carrier.speed)
	end	
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

