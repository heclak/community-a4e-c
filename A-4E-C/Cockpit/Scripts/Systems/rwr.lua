----------------------------------------------------------------
-- RWR/ECM
----------------------------------------------------------------
-- This module will handle the logic for the ALQ-51A, AN/APR-25
-- and AN/APR-27
----------------------------------------------------------------

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

device_timer_dt     = 0.02  	--0.2  	
--local update_rate 	= 0.2
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


Light = {	
				ECM_TEST	= get_param_handle("ECM_TEST"),
				ECM_GO		= get_param_handle("ECM_GO"),
				ECM_NO_GO	= get_param_handle("ECM_NO_GO"),
				
				ECM_SAM		= get_param_handle("ECM_SAM"),
				ECM_RPT		= get_param_handle("ECM_RPT"),
				ECM_STBY	= get_param_handle("ECM_STBY"),
				ECM_REC		= get_param_handle("ECM_REC"),
}

local ticker=0
local light_ticker = 0
local Launch_played=false
local Lock_played=false

local master_test_param 			= get_param_handle("D_MASTER_TEST")
local rwr_status_light_param	= get_param_handle("RWR_STATUS_LIGHT")
local rwr_status_signal_param	= get_param_handle("RWR_STATUS_SIGNAL")
rwr_status_light_param:set(0)
rwr_status_signal_param:set(0)

local rwr_apr25_power = 0 	--1 = on
local volume_prf = 0		--0-2		--inner
local volume_msl = 0		--0-2		--outer
local prf_audio_state  = 1		---1 = on

local volume_msl_pos = 0
local volume_prf_pos = 0
local rwr_inner_knob_moving = 0 
local rwr_outer_knob_moving = 0 
	
local rwr_apr25_alq_audio = 0
local rwr_apr27_status = 0
local ecm_alq_selector = 0
local ecm_upper_button	= 0
local ecm_lower_button	= 0

local ALQ_WARMUP_TIME = 2 * 60 -- two minutes
local ALQ_MODE = 0	-- 0 => OFF, 1 => STBY, 2 => REC, 3 => RPT

local BIT_TEST_STATE = false
local BIT_TEST_DURATION = 30 -- 28 to 34 seconds
local TIMER_alq_warmup = 0
local TIMER_BIT_TEST = 0

-- intermediate light state for BIT test
local BIT_TEST_REC_LIGHT_STATE = false
local BIT_TEST_RPT_LIGHT_STATE = false
local BIT_TEST_TEST_LIGHT_STATE = false
local BIT_TEST_GO_LIGHT_STATE = false
local BIT_TEST_NOGO_LIGHT_STATE = false

local HIDE_ECM = false


dev:listen_command(device_commands.ecm_apr25_off)
dev:listen_command(device_commands.ecm_apr25_audio)
dev:listen_command(device_commands.ecm_apr27_off)

dev:listen_command(device_commands.ecm_systest_upper)
dev:listen_command(device_commands.ecm_systest_lower)

dev:listen_command(device_commands.ecm_selector_knob)

dev:listen_command(device_commands.ecm_msl_alert_axis_inner)
dev:listen_command(device_commands.ecm_msl_alert_axis_outer)

dev:listen_command(Keys.ecm_apr25_off)
dev:listen_command(Keys.ecm_apr27_off)
dev:listen_command(Keys.ecm_select_cw)
dev:listen_command(Keys.ecm_select_ccw)

dev:listen_command(Keys.ecm_InnerKnobInc)
dev:listen_command(Keys.ecm_InnerKnobDec)
dev:listen_command(Keys.ecm_InnerKnobStartUp)
dev:listen_command(Keys.ecm_InnerKnobStartDown)
dev:listen_command(Keys.ecm_InnerKnobStop)

dev:listen_command(Keys.ecm_OuterKnobInc)
dev:listen_command(Keys.ecm_OuterKnobDec)
dev:listen_command(Keys.ecm_OuterKnobStartUp)
dev:listen_command(Keys.ecm_OuterKnobStartDown)
dev:listen_command(Keys.ecm_OuterKnobStop)


local ECM_vis_param = get_param_handle("ECM_VIS")

local function hideECMPanel(hideECM)
    if hideECM == 1 then
        local ECM_CLICKABLES = {"PNT_503", "PNT_504", "PNT_501", "PNT_507", "PNT_510", "PNT_506", "PNT_505", "PNT_502"}
        ECM_vis_param:set(1)
        for i = 1, #ECM_CLICKABLES, 1 do
            local clickable_ref = get_clickable_element_reference(ECM_CLICKABLES[i])
            clickable_ref:hide(0)
        end
    end
end

function post_initialize()

	HIDE_ECM = get_aircraft_property("HideECMPanel")
	
	--GetDevice(devices.RWR):set_power(true)			
--	print_message_to_user("Init - RWR")
	
	sndhost = create_sound_host("COCKPIT_RADAR_WARN","HEADPHONES",0,0,0)
    --rwrLock = sndhost:create_sound("Aircrafts/A-4E-C/obsttone") 
	--rwrLaunch = sndhost:create_sound("Aircrafts/A-4E-C/radarwarn") 
	
	
	-- rwrLock 	= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-aaa-lo-loop") 
	rwrLaunch 	= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-aaa-hi-loop") 
	rwrHum		= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-hum-loop") 
	
	
	rwrEsamSearch	= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-e-sam-hi-loop") 	--yes they are switched
	rwrEsamLock		= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-e-sam-lo-loop") 	--yes they are switched
	
	rwrAAASearch	= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-ai-loop")							--("a4e-rwr-aaa-lo-loop") 
	rwrAAALock		= sndhost:create_sound("Aircrafts/A-4E-C/a4e-rwr-aaa-lo-loop") 


	-------------------------------------
	-- BIRTH INITIALIZATION CODE
	-------------------------------------
	local birth = LockOn_Options.init_conditions.birth_place
	-- TODO Init code for HOT STARTS
	if birth=="GROUND_HOT" or birth=="AIR_HOT" then
		-- skip ALQ Warmup, place ALQ in standby mode
		ALQ_READY = true
		dev:performClickableAction(device_commands.ecm_selector_knob, 0.33) -- ALQ-51A in STBY MODE
		-- Initialise position of knobs
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_inner, 0) -- Volume knobs at 50%
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_outer, 0) -- Volume knobs at 50%
		
    elseif birth=="GROUND_COLD" then
		-- Initialise position of knobs
		dev:performClickableAction(device_commands.ecm_selector_knob, 0.0) -- ALQ-51A in OFF MODE
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_inner, -0.8) -- volume off
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_outer, -0.8) -- volume off
    end
	

end
---------------------------------
function SetCommand(command,value)
	--	print_message_to_user(command .. " / " ..value)
	
	-----------------
	-- keys
	-----------------
	if command == Keys.ecm_apr25_off then
		dev:performClickableAction((device_commands.ecm_apr25_off), ((rwr_apr25_power * -1) +1), false) -- currently off, so enable pylon
	elseif command == Keys.ecm_apr27_off then
		dev:performClickableAction((device_commands.ecm_apr27_off), ((rwr_apr27_status * -1) +1), false)
	-- plusnine mode selector - could be more efficient, but it works.
	elseif command == Keys.ecm_select_cw then
		if ALQ_MODE == 0 then
			dev:performClickableAction(device_commands.ecm_selector_knob, 0.33)
		elseif ALQ_MODE == 1 then
			dev:performClickableAction(device_commands.ecm_selector_knob, 0.66)
		elseif ALQ_MODE == 2 then
			dev:performClickableAction(device_commands.ecm_selector_knob, 0.99)
		end
	elseif command == Keys.ecm_select_ccw then
		if ALQ_MODE == 3 then
			dev:performClickableAction(device_commands.ecm_selector_knob, 0.66)
		elseif ALQ_MODE == 2 then
			dev:performClickableAction(device_commands.ecm_selector_knob, 0.33)
		elseif ALQ_MODE == 1 then
			dev:performClickableAction(device_commands.ecm_selector_knob, 0.00)
		end
	-- plusnine volume keybinds
	elseif command == Keys.ecm_InnerKnobInc then
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_inner, clamp(volume_prf_pos + 0.05, -0.8, 0.8))
	elseif command == Keys.ecm_InnerKnobDec then
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_inner, clamp(volume_prf_pos - 0.05, -0.8, 0.8))
	elseif command == Keys.ecm_InnerKnobStartUp then
		rwr_inner_knob_moving = 1
		print_message_to_user('inner up' ..volume_prf_pos)
	elseif command == Keys.ecm_InnerKnobStartDown then
		rwr_inner_knob_moving = -1
		print_message_to_user('inner down' ..volume_prf_pos)
	elseif command == Keys.ecm_InnerKnobStop then
		rwr_inner_knob_moving = 0
		print_message_to_user('inner stop' ..volume_prf_pos)
	elseif command == Keys.ecm_OuterKnobInc then
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_outer, clamp(volume_msl_pos + 0.10, -0.8, 0.8))
	elseif command == Keys.ecm_OuterKnobDec then
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_outer, clamp(volume_msl_pos - 0.10, -0.8, 0.8))
	elseif command == Keys.ecm_OuterKnobStartUp then
		rwr_outer_knob_moving = 1
	elseif command == Keys.ecm_OuterKnobStartDown then
		rwr_outer_knob_moving = -1
	elseif command == Keys.ecm_OuterKnobStop then
		rwr_outer_knob_moving = 0
	end

	-----------------
	-- clickable	
	-----------------
	if command == device_commands.ecm_apr25_off then
		rwr_apr25_power = value
		
	-- APR-25/ALQ audio toggle switch
	elseif command == device_commands.ecm_apr25_audio then
		rwr_apr25_alq_audio = value
		-- no audible change between ALQ and APR-25 for now as no information about audio tones for ALQ.
		-- assume that audio tones are the same
		-- if rwr_apr25_alq_audio == 1 then -- ALQ
		-- 	prf_audio_state = 1
		-- elseif rwr_apr25_alq_audio == 0 then -- APR-25
		-- 	prf_audio_state = 1
		-- end
			
	-- APR-27 Power Toggle Switch
	elseif command == device_commands.ecm_apr27_off then
		rwr_apr27_status = value

	-- PRF Volume Knob
	elseif command == device_commands.ecm_msl_alert_axis_inner then
		volume_prf = LinearTodB(((round(value/0.8,2))+1	)*0.5)
		volume_prf_pos = value
	
	-- MSL Volume Knob			
	elseif command == device_commands.ecm_msl_alert_axis_outer then
		volume_msl = LinearTodB(((round(value/0.8,2))+1	)*0.5)
		volume_msl_pos = value
	
	-- ALQ Rotary Control Switch
	elseif command == device_commands.ecm_selector_knob then
		local ecm_alq_selector = round(value, 2)

		-- cancel BIT Test if ALQ mode is changed
		if BIT_TEST_STATE then
			stop_bit_test()
		end

		-- update ALQ mode based on selector position
		if ecm_alq_selector == 0.0 then
			ALQ_MODE = 0 -- OFF
		elseif ecm_alq_selector == 0.33 then
			ALQ_MODE = 1 -- STBY
		elseif ecm_alq_selector == 0.66 then
			ALQ_MODE = 2 -- REC
		elseif ecm_alq_selector == 0.99 then
			ALQ_MODE = 3 -- RPT
		end
	
	-- Upper button on the ECM Panel
	elseif command == device_commands.ecm_systest_upper then
		ecm_upper_button = value
		-- print_message_to_user("Test Button: "..value)

		if value == 1  and ALQ_MODE == 2 and ALQ_READY then -- ALQ is in REC mode
			-- start bit test if test is not running
			if not BIT_TEST_STATE then
				-- print_message_to_user("BIT TEST STARTED")
				TIMER_BIT_TEST = 0
				BIT_TEST_STATE = true
				BIT_TEST_TEST_LIGHT_STATE = true
				BIT_TEST_REC_LIGHT_STATE = true
			else
				stop_bit_test()
			end
		end

	-- Lower button on ECM Panel
	elseif command == device_commands.ecm_systest_lower then
		ecm_lower_button = value

	end

end

function update()
	
	hideECMPanel(HIDE_ECM)
	
	if HIDE_ECM == 1 then -- if ECM is removed from cockpit. Skip ECM code.
		return
	end
	
--	if (get_elec_mon_dc_ok()) and rwr_apr25_power == 1 then
	
	if get_elec_aft_mon_ac_ok() == true then
		GetDevice(devices.RWR):set_power(true)			
	else
		GetDevice(devices.RWR):set_power(false)			
	end

	-- check PRF audio state
	if (rwr_apr25_power == 1 and rwr_apr25_alq_audio == 0) or
	(ALQ_MODE > 1 and ALQ_READY and rwr_apr25_alq_audio == 1) then
		prf_audio_state = 1
	else
		prf_audio_state = 0
	end
	
	
	if get_elec_aft_mon_ac_ok() == true and ((rwr_apr25_power == 1) or (ALQ_MODE > 1)) then
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
		
		-- print_message_to_user("tmp_rwr_signal "..tmp_rwr_signal)	--Just print 1/2/3 on the screen for debugging
		-- print_message_to_user(rwr[1].general_type_h:get())
		
		if tmp_rwr_signal == 2 then
			rwr_status_light_param:set(1)
			if rwrLaunch:is_playing() then
				rwrLaunch:stop()
			end
		elseif tmp_rwr_signal == 3 then
			if rwr_status_light_param:get()==0 then
				rwr_status_light_param:set(1)
			else
				rwr_status_light_param:set(0)
			end
				if not rwrLaunch:is_playing()  then
					rwrLaunch:play_continue()
					rwrLaunch:update(nil, volume_msl * rwr_apr27_status * 1, nil)
				else
					rwrLaunch:update(nil, volume_msl * rwr_apr27_status * 1, nil)
				end
			
		elseif tmp_rwr_signal < 2 then
			rwr_status_light_param:set(0)
			
			if rwrLaunch:is_playing() then
				rwrLaunch:stop()
			end
			
		end
		
		rwr_status_signal_param:set(tmp_rwr_signal)


		-------------------------------
		-- AUDIO UPDATES
		-------------------------------
		if not BIT_TEST_STATE then
			check_search_played(esam_search,rwrEsamSearch,tmp_rwr_signal)	
			check_search_played(aaa_search,rwrAAASearch,tmp_rwr_signal)
			check_lock_played(tmp_rwr_signal,tmp_rwr_type)
		else
			-- audio tone for BIT test plays with REC light
			if BIT_TEST_REC_LIGHT_STATE then
				if not rwrAAALock:is_playing() then
					rwrAAALock:play_continue()
				end
			else
				rwrAAALock:stop()
			end
		end
		
		-- update volume for all sounds based on knob positions
		if not rwrHum:is_playing() then
			rwrHum:play_continue()
			rwrHum:update(nil,volume_prf * prf_audio_state * 0.5,nil)
		else
			rwrHum:update(nil,volume_prf * prf_audio_state * 0.5,nil)
		end
			
		if rwrEsamSearch:is_playing() then
			rwrEsamSearch:update(nil,volume_prf * prf_audio_state * 1,nil)
		end
		if rwrEsamLock:is_playing() then
			rwrEsamLock:update(nil,volume_prf * prf_audio_state * 1,nil)
		end
		if rwrAAASearch:is_playing() then
			rwrAAASearch:update(nil,volume_prf * prf_audio_state * 1,nil)
		end
		if rwrAAALock:is_playing() then
			rwrAAALock:update(nil,volume_prf * prf_audio_state * 1,nil)
		end

	else
		rwrEsamSearch:stop()
		rwrEsamLock:stop()
		
		rwrAAASearch:stop()
		rwrAAALock:stop()
		rwrHum:stop()
		
		rwrLaunch:stop()
	
	end	
	
    if rwr_inner_knob_moving ~= 0 then
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_inner, clamp(volume_prf_pos + rwr_inner_knob_moving * 0.01, -0.8, 0.8))
    end

	if rwr_outer_knob_moving ~= 0 then
		dev:performClickableAction(device_commands.ecm_msl_alert_axis_outer, clamp(volume_msl_pos + rwr_outer_knob_moving * 0.01, -0.8, 0.8))
    end

	update_ALQ()
	alq_bit_test()
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

function update_ALQ()

	if get_elec_aft_mon_ac_ok() == true then

		alq_warm_up()

		-- print_message_to_user("ALQ READY: "..tostring(ALQ_READY))

		if master_test_param:get() == 1 then
			Light.ECM_RPT:set(1)
			Light.ECM_SAM:set(1)
			Light.ECM_REC:set(1)
			Light.ECM_STBY:set(1)
			Light.ECM_TEST:set(1)
			Light.ECM_GO:set(1)
			Light.ECM_NO_GO:set(1)

		elseif ALQ_MODE == 0 then -- ALQ OFF
			-- reset warmup timer and ready mode
			TIMER_alq_warmup = 0
			ALQ_READY = false

			-- all lights should be off when ALQ is OFF
			Light.ECM_RPT:set(0)
			Light.ECM_SAM:set(0)
			Light.ECM_REC:set(0)
			Light.ECM_STBY:set(0)
			Light.ECM_TEST:set(0)
			Light.ECM_GO:set(0)
			Light.ECM_NO_GO:set(0)

		elseif ALQ_MODE == 1 then -- ALQ STBY
			-- check if warmup time has passed
			if ALQ_READY then
				Light.ECM_STBY:set(0)
				Light.ECM_SAM:set(0)
				Light.ECM_REC:set(0)
				Light.ECM_RPT:set(0)
				Light.ECM_TEST:set(0)
				Light.ECM_GO:set(0)
				Light.ECM_NO_GO:set(0)
			else
				Light.ECM_STBY:set(1)
				Light.ECM_SAM:set(0)
				Light.ECM_REC:set(0)
				Light.ECM_RPT:set(0)
				Light.ECM_TEST:set(0)
				Light.ECM_GO:set(0)
				Light.ECM_NO_GO:set(0)
			end

		elseif ALQ_MODE == 2 then -- ALQ REC
			if not ALQ_READY then
				Light.ECM_STBY:set(1)
				Light.ECM_SAM:set(0)
				Light.ECM_REC:set(0)
				Light.ECM_RPT:set(0)
				Light.ECM_TEST:set(0)
				Light.ECM_GO:set(0)
				Light.ECM_NO_GO:set(0)

			elseif not BIT_TEST_STATE then
				-- turn on REC light if radar lock detected
				if (rwr_status_signal_param:get() == 2 or rwr_status_signal_param:get() == 3) then
					Light.ECM_REC:set(1)
				else
					Light.ECM_REC:set(0)
				end

				-- turn on SAM light if launched upon and APR-27 is ON
				if rwr_status_signal_param:get() == 3 and rwr_apr27_status == 1 then
					Light.ECM_SAM:set(1)
				else
					Light.ECM_SAM:set(0)
				end

				Light.ECM_STBY:set(0)
				Light.ECM_RPT:set(0)
				Light.ECM_TEST:set(0)
				Light.ECM_GO:set(0)
				Light.ECM_NO_GO:set(0)

			elseif BIT_TEST_STATE then

				if BIT_TEST_RPT_LIGHT_STATE then
					Light.ECM_RPT:set(1)
				else
					Light.ECM_RPT:set(0)
				end
				
				if BIT_TEST_REC_LIGHT_STATE then
					Light.ECM_REC:set(1)
				else
					Light.ECM_REC:set(0)
				end
				
				if BIT_TEST_TEST_LIGHT_STATE then
					Light.ECM_TEST:set(1)
				else
					Light.ECM_TEST:set(0)
				end

				if BIT_TEST_GO_LIGHT_STATE then
					Light.ECM_GO:set(1)
				else
					Light.ECM_GO:set(0)
				end

				if BIT_TEST_NOGO_LIGHT_STATE then
					Light.ECM_NO_GO:set(1)
				else
					Light.ECM_NO_GO:set(0)
				end

				Light.ECM_STBY:set(0)
				Light.ECM_SAM:set(0)
			end



		elseif ALQ_MODE == 3 then -- ALQ RPT
			-- check if warmup time has passed
			if not ALQ_READY then
				Light.ECM_STBY:set(1)
				
			elseif not BIT_TEST_STATE then
			-- turn on REC and RPT light if radar lock detected
				if (rwr_status_signal_param:get() == 2 or rwr_status_signal_param:get() == 3) then
					Light.ECM_REC:set(1)
					Light.ECM_RPT:set(1)
				else
					Light.ECM_REC:set(0)
					Light.ECM_RPT:set(0)
				end

				-- turn on SAM light if launched upon and APR-27 is ON
				if rwr_status_signal_param:get() == 3 and rwr_apr27_status == 1 then
					Light.ECM_SAM:set(1)
				else
					Light.ECM_SAM:set(0)
				end

				Light.ECM_STBY:set(0)
				Light.ECM_TEST:set(0)
				Light.ECM_GO:set(0)
				Light.ECM_NO_GO:set(0)

			elseif BIT_TEST_STATE then
				stop_bit_test()
			end

		else
			-- log error message
		end
	else
		Light.ECM_RPT:set(0)
		Light.ECM_SAM:set(0)
		Light.ECM_REC:set(0)
		Light.ECM_STBY:set(0)
		Light.ECM_TEST:set(0)
		Light.ECM_GO:set(0)
		Light.ECM_NO_GO:set(0)
	end

	
end

function alq_warm_up()
	-- check if warmup time has passed
	if not ALQ_READY and (TIMER_alq_warmup < ALQ_WARMUP_TIME) then
		TIMER_alq_warmup = TIMER_alq_warmup + device_timer_dt
		ALQ_READY = false
	elseif not ALQ_READY then
		ALQ_READY = true
	end
end


function alq_bit_test()
	if ALQ_MODE == 2 and ALQ_READY then
		-- update test state if test is running
		if BIT_TEST_STATE then
			-- One second after REC light comes on, RPT light flashes three times 
			-- (1-second time interval between flashes)
			if (TIMER_BIT_TEST > 1.0 and TIMER_BIT_TEST < 1.5) or
			(TIMER_BIT_TEST > 2.0 and TIMER_BIT_TEST < 2.5) or
			(TIMER_BIT_TEST > 3.0 and TIMER_BIT_TEST < 3.5) then
				BIT_TEST_RPT_LIGHT_STATE = true
			else
				BIT_TEST_RPT_LIGHT_STATE = false
			end

			-- GO light comes on 28-34 seconds after start of test
			if TIMER_BIT_TEST > BIT_TEST_DURATION then
				BIT_TEST_GO_LIGHT_STATE = true
			end

			-- Audio tone ceases, REC light goes off in ~5 seconds after end of BIT TEST
			if TIMER_BIT_TEST > (BIT_TEST_DURATION + 5) then
				BIT_TEST_REC_LIGHT_STATE = false
			end

			TIMER_BIT_TEST = TIMER_BIT_TEST + device_timer_dt
			-- print_message_to_user(TIMER_BIT_TEST)
		end
	end
end

function stop_bit_test()
	-- print_message_to_user("BIT TEST STOPPED")
	BIT_TEST_STATE = false
	BIT_TEST_REC_LIGHT_STATE = false
	BIT_TEST_RPT_LIGHT_STATE = false
	BIT_TEST_TEST_LIGHT_STATE = false
	BIT_TEST_GO_LIGHT_STATE = false
	BIT_TEST_NOGO_LIGHT_STATE = false
end

need_to_be_closed = false -- close lua state after initialization

--[[
devices.lua
device_init.lua
Systems/rwr.lua
]]--

--[[
BIT TEST
1. Turn control switch to STBY. STBY light will come on and goes off after warmup time delay of 2 minutes
2. Turn control switch to REC after warmup
3. Depress and then release TEST switch
4. Verify TEST and REC lights come on. Audio tone is present. (What is this audio tone?)
5. One second after REC light comes on, RPT light flashes three times (1-second time interval between flashes)
6. GO or NO GO light comes on 28~34 seconds after TEST light comes on
7. Audio tone ceases, REC light goes off in ~5 seconds
8. Depress TEST switch (TEST light off) to return system to normal
]]
