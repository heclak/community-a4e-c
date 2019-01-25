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
					power_h			= get_param_handle("RWR_CONTACT_0" .. i .. "_POWER"),
					general_type_h	= get_param_handle("RWR_CONTACT_0" .. i .. "_GENERAL_TYPE"),
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

local rwr_master_status = "on" 	--"off"
local rwr_master_volume = 1

function post_initialize()
	
	--GetDevice(devices.RWR):set_power(true)			
	print_message_to_user("Init - RWR")
	
	sndhost = create_sound_host("COCKPIT_RADAR_WARN","2D",0,0,0)
    --rwrLock = sndhost:create_sound("obsttone") 
	--rwrLaunch = sndhost:create_sound("radarwarn") 
	
	
	rwrLock 	= sndhost:create_sound("a4e-rwr-aaa-lo-loop") 
	rwrLaunch 	= sndhost:create_sound("a4e-rwr-aaa-hi-loop") 
	rwrHum		= sndhost:create_sound("a4e-rwr-hum-loop") 
	
	
	rwrEsamSearch	= sndhost:create_sound("a4e-rwr-e-sam-hi-loop") 	--yes they are switched
	rwrEsamLock		= sndhost:create_sound("a4e-rwr-e-sam-lo-loop") 	--yes they are switched
	
	rwrAAASearch	= sndhost:create_sound("a4e-rwr-ai-loop")							--("a4e-rwr-aaa-lo-loop") 
	rwrAAALock		= sndhost:create_sound("a4e-rwr-aaa-lo-loop") 
	
--	rwrHum:play_continue()
	
end
---------------------------------


function update()
--math.randomseed(get_absolute_model_time())
	if (get_elec_mon_dc_ok()) and rwr_master_status == "on" then

		if get_elec_aft_mon_ac_ok() == true then
			GetDevice(devices.RWR):set_power(true)			
			--print_message_to_user("RWR on")
		else
			GetDevice(devices.RWR):set_power(false)			
			--print_message_to_user("RWR off")
		end

		--print_message_to_user("update - RWR")
	--[[
		if 	(get_elec_mon_dc_ok()) then
			GetDevice(devices.RWR):set_power(true)		
		end]]--
		local tmp_rwr_signal 	= 0
		local tmp_rwr_type		= 0
		local tmp_rwr_power		= 0
		
		local esam_search			= false
		local aaa_search			= false
		
		--print_message_to_user("--------------------------")
		for i = 1,maxcontacts do	
			local tmp_sig  = rwr[i].signal_h:get()
			local gen_tmp_type = rwr[i].general_type_h:get()
			
		--	print_message_to_user(i .. " / Signal: "..tmp_sig .. " / Type: "..rwr[i].general_type_h:get())
			
			if tmp_sig == 3 then			--We are launched on
				tmp_rwr_signal = 3		
				tmp_rwr_type = gen_tmp_type
			elseif tmp_sig == 2 then
				if tmp_rwr_signal < 2 then	--We are locked
					tmp_rwr_signal = 2
				end
				tmp_rwr_type = gen_tmp_type
			elseif tmp_sig == 1 then		--there is a radar energie source reaching our plane, but no STT
				if tmp_rwr_signal < 1 then
					tmp_rwr_signal = 1
				end
				if gen_tmp_type == 2 then
					esam_search = true
				elseif gen_tmp_type == 1 then
					aaa_search = true
				end
				
			end
		end	
		
	--print_message_to_user("tmp_rwr_signal "..tmp_rwr_signal)	--Just print 1/2/3 on the screen for debugging
	--	print_message_to_user(rwr[1].general_type_h:get())
		
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
		

		
		if not rwrHum:is_playing() then
			rwrHum:play_continue()
			rwrHum:update(nil,rwr_master_volume * 0.05,nil)
		else
			rwrHum:update(nil,rwr_master_volume * 0.05,nil)
		end
			
		check_search_played(esam_search,rwrEsamSearch,tmp_rwr_signal)	
		check_search_played(aaa_search,rwrAAASearch,tmp_rwr_signal)
		check_lock_played(tmp_rwr_signal,tmp_rwr_type)
		
		if rwrEsamSearch:is_playing() then
			rwrEsamSearch:update(nil,rwr_master_volume * 1,nil)
		end
		if rwrEsamLock:is_playing() then
			rwrEsamLock:update(nil,rwr_master_volume * 1,nil)
		end
		if rwrAAASearch:is_playing() then
			rwrAAASearch:update(nil,rwr_master_volume * 1,nil)
		end
		if rwrAAALock:is_playing() then
			rwrAAALock:update(nil,rwr_master_volume * 1,nil)
		end

	end	
	
end




function check_search_played(rwrtyp,snd,rwr_signal)

	if rwrtyp then
		if rwr_signal == 1 and not snd:is_playing() then
			snd:play_continue()
		end	
	else
		snd:stop()
	end

end

function check_lock_played(tmp_rwr_signal,tmp_rwr_type)--(rwrtyp,snd,rwr_signal)

	if tmp_rwr_type == 2 and (tmp_rwr_signal == 2 or tmp_rwr_signal == 3 ) then 	
		if not rwrEsamLock:is_playing() then
			rwrEsamLock:play_continue()
		end
		if rwrEsamSearch:is_playing() then
			rwrEsamSearch:stop()
		end
		if rwrAAALock:is_playing() then
			rwrAAALock:stop()
		end
		
	end
	if tmp_rwr_type == 1 and (tmp_rwr_signal == 2 or tmp_rwr_signal == 3 ) then 	
		if not rwrAAALock:is_playing() then
			rwrAAALock:play_continue()
		end
		if rwrAAASearch:is_playing() then
			rwrAAASearch:stop()
		end
		if rwrEsamLock:is_playing() then
			rwrEsamLock:stop()
		end
	end
	
	if tmp_rwr_signal < 2 then
		if rwrEsamLock:is_playing() then
			rwrEsamLock:stop()
		end
		if rwrAAALock:is_playing() then
			rwrAAALock:stop()
		end
	
	end
end

--[[
devices.lua
device_init.lua
Systems/rwr.lua


]]--

