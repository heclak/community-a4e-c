dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

device_timer_dt     = 0.2  	
local update_rate 	= 0.2
MaxThreats          = 9
EmitterLiveTime     = 7.0	

RWR_detection_coeff = 0.85

local dev     = GetSelf()

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


TestLights = {	
				UU	= get_param_handle("ECM_TEST_UPPER_U"),
				ULL	= get_param_handle("ECM_TEST_UPPER_LL"),
				ULR	= get_param_handle("ECM_TEST_UPPER_LR"),
				
				LUL	= get_param_handle("ECM_TEST_LOWER_UL"),
				LUR	= get_param_handle("ECM_TEST_LOWER_UR"),
				LLL	= get_param_handle("ECM_TEST_LOWER_LL"),
				LLR	= get_param_handle("ECM_TEST_LOWER_LR"),
}

local ticker=0
local light_ticker = 0
local Launch_played=false
local Lock_played=false

--local glare_rwr_light=get_param_handle("D_GLARE_RWR")	-- glare_rwr_light:set(rwr_val)
local glare_rwr_light=get_param_handle("D_GLARE_OBST")	--glare_obst_light:set(obst_val) --USED ONLY UNTIL PROPPER LIGHT IS IN

local glare_rwr_param=get_param_handle("D_GLARE_RWR")
local rwr_status_light_param=get_param_handle("RWR_STATUS_LIGHT")
rwr_status_light_param:set(0)

local rwr_master_status = 0 	--1 = on
local rwr_master_volume = 1		--0-2		--inner
local rwr_launch_volume = 1		--0-2		--outer
local rwr_apr25_audio  = 1		---1 = on
	
local rwr_apr25_apr27_audio = 0
local rwr_apr27_status = 0
local rwr_apr27_selector = 0
local ecm_upper_test	= 0
local ecm_lower_test	= 0


dev:listen_command(device_commands.ecm_apr25_off)
dev:listen_command(device_commands.ecm_apr25_audio)
dev:listen_command(device_commands.ecm_apr27_off)

dev:listen_command(device_commands.ecm_systest_upper)
dev:listen_command(device_commands.ecm_systest_lower)

dev:listen_command(device_commands.ecm_selector_knob)

dev:listen_command(device_commands.ecm_msl_alert_axis_inner)
dev:listen_command(device_commands.ecm_msl_alert_axis_outer)

dev:listen_command(Keys.ecm_apr25_off)

function post_initialize()
	
	--GetDevice(devices.RWR):set_power(true)			
--	print_message_to_user("Init - RWR")
	
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
	

end
---------------------------------
function SetCommand(command,value)
--	print_message_to_user(command .. " / " ..value)
	
--keys	
	if command == Keys.ecm_apr25_off then
		dev:performClickableAction((device_commands.ecm_apr25_off), ((rwr_master_status * -1) +1), false) -- currently off, so enable pylon
	end
	
	
--clickable	
	if command == device_commands.ecm_apr25_off then
		rwr_master_status = value
		
	elseif command == device_commands.ecm_apr25_audio then
	--	rwr_apr25_audio = value
		rwr_apr25_apr27_audio = value
		if rwr_apr25_apr27_audio == 1 then
			rwr_apr25_audio = 0
		elseif rwr_apr25_apr27_audio == 0 then
			rwr_apr25_audio = 1
		end
		
		
	elseif command == device_commands.ecm_apr27_off then
		rwr_apr27_status = value
	elseif command == device_commands.ecm_msl_alert_axis_inner then
		rwr_master_volume = (value + 1) 

	elseif command == device_commands.ecm_msl_alert_axis_outer then
		rwr_launch_volume = (value + 1) 
	
	
	elseif command == device_commands.ecm_selector_knob then

		
		rwr_apr27_selector = round(value, 2)

	
	
	elseif command == device_commands.ecm_systest_upper then
		ecm_upper_test = value

	elseif command == device_commands.ecm_systest_lower then
		ecm_lower_test = value

	end
	

end

function update()

	if (get_elec_mon_dc_ok()) and rwr_master_status == 1 then
--print_message_to_user("RWR on")
		if get_elec_aft_mon_ac_ok() == true then
			GetDevice(devices.RWR):set_power(true)			
			--print_message_to_user("RWR on")
		else
			GetDevice(devices.RWR):set_power(false)			
			--print_message_to_user("RWR off")
		end


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
			if rwrLaunch:is_playing() then
				rwrLaunch:stop()
			end
		elseif tmp_rwr_signal == 3 then
			if rwr_status_light_param:get()==0 then
				rwr_status_light_param:set(1)
				glare_rwr_param:set(1)
			else
				rwr_status_light_param:set(0)
				glare_rwr_param:set(0)
			end
				if not rwrLaunch:is_playing()  then
					rwrLaunch:play_continue()
					rwrLaunch:update(nil,rwr_launch_volume * rwr_apr25_audio * 1,nil)
				else
					rwrLaunch:update(nil,rwr_launch_volume * rwr_apr25_audio * 1,nil)
				end
			
		elseif tmp_rwr_signal < 2 then
			rwr_status_light_param:set(0)
			glare_rwr_param:set(0)
			
			if rwrLaunch:is_playing() then
				rwrLaunch:stop()
			end
			
		end
		

		
		if not rwrHum:is_playing() then
			rwrHum:play_continue()
			rwrHum:update(nil,rwr_master_volume * rwr_apr25_audio * 0.05,nil)
		else
			rwrHum:update(nil,rwr_master_volume * rwr_apr25_audio * 0.05,nil)
		end
			
		check_search_played(esam_search,rwrEsamSearch,tmp_rwr_signal)	
		check_search_played(aaa_search,rwrAAASearch,tmp_rwr_signal)
		check_lock_played(tmp_rwr_signal,tmp_rwr_type)
		
		if rwrEsamSearch:is_playing() then
			rwrEsamSearch:update(nil,rwr_master_volume * rwr_apr25_audio * 1,nil)
		end
		if rwrEsamLock:is_playing() then
			rwrEsamLock:update(nil,rwr_master_volume * rwr_apr25_audio * 1,nil)
		end
		if rwrAAASearch:is_playing() then
			rwrAAASearch:update(nil,rwr_master_volume * rwr_apr25_audio * 1,nil)
		end
		if rwrAAALock:is_playing() then
			rwrAAALock:update(nil,rwr_master_volume * rwr_apr25_audio * 1,nil)
		end
	else
		rwrEsamSearch:stop()
		rwrEsamLock:stop()
		
		rwrAAASearch:stop()
		rwrAAALock:stop()
		rwrHum:stop()
		
		rwrLaunch:stop()
	
	end	
	
	
	update_apr27()
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




function update_apr27()

	if rwr_apr27_status == 1 and (get_elec_mon_dc_ok()) then
		
		
		if ecm_lower_test == 1 then
			TestLights.LUR:set(1)
			TestLights.LUL:set(1)
			TestLights.LLR:set(1)
			TestLights.LLL:set(1)
		
		elseif rwr_apr27_selector == 0.0 then
			TestLights.LUR:set(0)
			TestLights.LUL:set(0)
			TestLights.LLR:set(0)
			TestLights.LLL:set(0)
		elseif rwr_apr27_selector == 0.33 then
			TestLights.LUR:set(0)
			TestLights.LUL:set(0)
			TestLights.LLR:set(0)
			TestLights.LLL:set(1)
		elseif rwr_apr27_selector == 0.66 then
			TestLights.LUR:set(0)
			TestLights.LUL:set(0)
			TestLights.LLR:set(1)
			TestLights.LLL:set(0)
		elseif rwr_apr27_selector == 0.99 then
			TestLights.LUR:set(1)
			TestLights.LUL:set(0)
			TestLights.LLR:set(0)
			TestLights.LLL:set(0)
		else
			TestLights.LUR:set(0)
			TestLights.LUL:set(0)
			TestLights.LLR:set(0)
			TestLights.LLL:set(0)
		end
		
		if ecm_upper_test == 1 then
			TestLights.UU:set(1)
			TestLights.ULR:set(1)
			TestLights.ULL:set(1)
		else
			TestLights.UU:set(0)
			TestLights.ULR:set(0)
			TestLights.ULL:set(0)
		end
		
		
		
	else
		TestLights.LUR:set(0)
		TestLights.LUL:set(0)
		TestLights.LLR:set(0)
		TestLights.LLL:set(0)
	end

	end

need_to_be_closed = false -- close lua state after initialization
--[[
devices.lua
device_init.lua
Systems/rwr.lua


]]--

--[[

ECM_Test_Upper_U		                    = CreateGauge("parameter")
ECM_Test_Upper_U.arg_number                 = 514
ECM_Test_Upper_U.input                      = {0.0, 1.0}
ECM_Test_Upper_U.output                     = {0.0, 1.0}
ECM_Test_Upper_U.parameter_name             = "ECM_TEST_UPPER_U"

ECM_Test_Upper_LL		                    = CreateGauge("parameter")
ECM_Test_Upper_LL.arg_number                = 515
ECM_Test_Upper_LL.input                     = {0.0, 1.0}
ECM_Test_Upper_LL.output                    = {0.0, 1.0}
ECM_Test_Upper_LL.parameter_name            = "ECM_TEST_UPPER_LL"

ECM_Test_Upper_LR		                    = CreateGauge("parameter")
ECM_Test_Upper_LR.arg_number                 = 516
ECM_Test_Upper_LR.input                      = {0.0, 1.0}
ECM_Test_Upper_LR.output                     = {0.0, 1.0}
ECM_Test_Upper_LR.parameter_name             = "ECM_TEST_UPPER_LR"



ECM_Test_Lower_UL		                    = CreateGauge("parameter")
ECM_Test_Lower_UL.arg_number                = 517
ECM_Test_Lower_UL.input                     = {0.0, 1.0}
ECM_Test_Lower_UL.output                    = {0.0, 1.0}
ECM_Test_Lower_UL.parameter_name            = "ECM_TEST_LOWER_UL"

ECM_Test_Lower_UR		                    = CreateGauge("parameter")
ECM_Test_Lower_UR.arg_number                 = 518
ECM_Test_Lower_UR.input                      = {0.0, 1.0}
ECM_Test_Lower_UR.output                     = {0.0, 1.0}
ECM_Test_Lower_UR.parameter_name             = "ECM_TEST_LOWER_UR"

ECM_Test_Lower_LL		                    = CreateGauge("parameter")
ECM_Test_Lower_LL.arg_number                = 519
ECM_Test_Lower_LL.input                     = {0.0, 1.0}
ECM_Test_Lower_LL.output                    = {0.0, 1.0}
ECM_Test_Lower_LL.parameter_name            = "ECM_TEST_LOWER_LL"

ECM_Test_Lower_LR		                    = CreateGauge("parameter")
ECM_Test_Lower_LR.arg_number                 = 520
ECM_Test_Lower_LR.input                      = {0.0, 1.0}
ECM_Test_Lower_LR.output                     = {0.0, 1.0}
ECM_Test_Lower_LR.parameter_name             = "ECM_TEST_LOWER_LR"
]]--