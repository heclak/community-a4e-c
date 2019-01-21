dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

device_timer_dt     = 0.2  	
local update_rate 	= 0.2
MaxThreats          = 9
EmitterLiveTime     = 7.0	

RWR_detection_coeff = 0.85

	eyes ={}	-- RWR sensors

	eyes[1] =
	{
		position      = {x = 5.447,y = -0.376,z =  0.356},--2
		orientation   = {azimuth  = math.rad(45),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}
	eyes[2] =
	{
		position      = {x = 5.447,y = -0.376,z = -0.357},
		orientation   = {azimuth  = math.rad(-45),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}
	eyes[3] =
	{
		position      = {x = -10.668,y = 0.836,z =  0.097},
		orientation   = {azimuth  = math.rad(135),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}
	eyes[4] =
	{
		position      = {x = -10.679,y = 0.875,z =  -0.07},
		orientation   = {azimuth  = math.rad(-135),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}



maxcontacts = MaxThreats
rwr = 	{}
for i = 1,maxcontacts do	
	rwr[i] = 	{
					signal_h		= get_param_handle("RWR_CONTACT_0" .. i .. "_SIGNAL"),
				}
				
end



local ticker=0
local light_ticker = 0
local Launch_played=false
local Lock_played=false

--local glare_rwr_light=get_param_handle("D_GLARE_RWR")	-- glare_rwr_light:set(rwr_val)
local glare_rwr_light=get_param_handle("D_GLARE_OBST")	--glare_obst_light:set(obst_val) --USED ONLY UNTIL PROPPER LIGHT IS IN

local glare_rwr_param=get_param_handle("D_GLARE_RWR")
local rwr_status_light_param=get_param_handle("RWR_STATUS_LIGHT")
rwr_status_light_param:set(0)

function post_initialize()
	
	--GetDevice(devices.RWR):set_power(true)			
	print_message_to_user("Init - RWR")
	
	sndhost = create_sound_host("COCKPIT_RADAR_WARN","2D",0,0,0)
    rwrLaunch = sndhost:create_sound("radarwarn") 
	rwrLock = sndhost:create_sound("obsttone") 
end
---------------------------------


function update()

	if get_elec_aft_mon_ac_ok() == true then
		GetDevice(devices.RWR):set_power(true)			
		--print_message_to_user("RWR on")
	else
		GetDevice(devices.RWR):set_power(false)			
		--print_message_to_user("RWR off")
	end

	--print_message_to_user("update - RWR")

	if 	(get_elec_mon_dc_ok()) then
		GetDevice(devices.RWR):set_power(true)		
	end
	local tmp_rwr_signal = 0
	for i = 1,maxcontacts do	
		local tmp_sig = rwr[i].signal_h:get()
		
		if tmp_sig == 3 then			--We are launched on
			tmp_rwr_signal = 3		
		elseif tmp_sig == 2 then
			if tmp_rwr_signal < 2 then	--We are locked
				tmp_rwr_signal = 2
			end
		elseif tmp_sig == 1 then		--there is a radar energie source reaching our plane, but no STT
			if tmp_rwr_signal < 1 then
				tmp_rwr_signal = 1
			end
		end
	end	
	
--print_message_to_user(tmp_rwr_signal)	--Just print 1/2/3 on the screen for debugging
	
	if tmp_rwr_signal == 2 then
		rwr_status_light_param:set(1)
		glare_rwr_param:set(1)
	
	elseif tmp_rwr_signal == 3 then
		if rwr_status_light_param:get()==0 then
			rwr_status_light_param:set(1)
			glare_rwr_param:set(1)
		else
			rwr_status_light_param:set(0)
			glare_rwr_param:set(0)
		end
	elseif tmp_rwr_signal < 2 then
		rwr_status_light_param:set(0)
		glare_rwr_param:set(0)
	end
	
	
		
		if Launch_played then
			ticker=ticker+update_rate
			if ticker >= 1.9 then
				Launch_played = false
				Lock_played = false
			end
		end
		
		if Lock_played then
			ticker=ticker+update_rate
			if ticker >= 1.9 then
				Lock_played = false
				Launch_played = false
			end
		end
		
	if tmp_rwr_signal == 3 and not Launch_played and (get_elec_mon_dc_ok()) then	
		Launch_played=true
        ticker = 0
		rwrLaunch:play_once()
	elseif tmp_rwr_signal == 2 and not Lock_played and (get_elec_mon_dc_ok()) then	
		Lock_played=true
        ticker = 0
		rwrLock:play_once() 
	end

end

--[[
devices.lua
device_init.lua
Systems/rwr.lua


]]--

