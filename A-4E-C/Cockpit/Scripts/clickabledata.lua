dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."sounds.lua")
--dofile(LockOn_Options.common_script_path..'localizer.lua')

local gettext = require("i_18n")
_ = gettext.translate

cursor_mode = 
{ 
    CUMODE_CLICKABLE = 0,
    CUMODE_CLICKABLE_AND_CAMERA  = 1,
    CUMODE_CAMERA = 2,
};

clickable_mode_initial_status  = cursor_mode.CUMODE_CLICKABLE
use_pointer_name			   = true

function default_button(hint_,device_,command_,arg_,arg_val_,arg_lim_, sound_)

	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}

	return  {	
				class 				= {class_type.BTN},
				hint  				= hint_,
				device 				= device_,
				action 				= {command_},
				stop_action 		= {command_},
				arg 				= {arg_},
				arg_value			= {arg_val_}, 
				arg_lim 			= {arg_lim_},
				use_release_message = {true},
                sound = sound_ and {{sound_},{sound_}} or nil
			}
end

function default_1_position_tumb(hint_, device_, command_, arg_, arg_val_, arg_lim_)
	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}
	return  {	
				class 		= {class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {arg_val_}, 
				arg_lim   	= {arg_lim_},
				updatable 	= true, 
				use_OBB 	= true
			}
end

function default_2_position_tumb(hint_, device_, command_, arg_, sound_)
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {1,-1}, 
				arg_lim   	= {{0,1},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
                sound = sound_ and {{sound_,sound_}} or nil
			}
end

function default_3_position_tumb(hint_,device_,command_,arg_,cycled_,inversed_, sound_)
	local cycled = true
	
	
	local val =  1
	if inversed_ then
	      val = -1
	end
	if cycled_ ~= nil then
	   cycled = cycled_
	end
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {val,-val}, 
				arg_lim   	= {{-1,1},{-1,1}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle       = cycled,
                sound = sound_ and {{sound_,sound_}} or nil
			}
end

function default_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

function default_movable_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

function default_axis_limited(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_, arg_lim_)
	
	local relative = false
	local default = default_ or 0
	local updatable = updatable_ or false
	if relative_ ~= nil then
		relative = relative_
	end

	local gain = gain_ or 0.1
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {arg_lim_},
				updatable 	= updatable, 
				use_OBB 	= false,
				gain		= {gain},
				relative    = {relative},
				cycle		= false
			}
end


function multiposition_switch(hint_,device_,command_,arg_,count_,delta_,inversed_, min_, sound_)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true,
                sound = sound_ and {{sound_,sound_}} or nil
			}
end

function multiposition_switch_limited(hint_,device_,command_,arg_,count_,delta_,inversed_,min_, sound_)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle     	= false, 
                sound = sound_ and {{sound_,sound_}} or nil
			}
end

function default_button_axis(hint_, device_,command_1, command_2, arg_1, arg_2, limit_1, limit_2)
	local limit_1_   = limit_1 or 1.0
	local limit_2_   = limit_2 or 1.0
return {
			class		=	{class_type.BTN, class_type.LEV},
			hint		=	hint_,
			device		=	device_,
			action		=	{command_1, command_2},
			stop_action =   {command_1, 0},
			arg			=	{arg_1, arg_2},
			arg_value	= 	{1, 0.5},
			arg_lim		= 	{{0, limit_1_}, {0,limit_2_}},
			animated        = {false,true},
			animation_speed = {0, 0.4},
			gain = {0, 0.1},
			relative	= 	{false, false},
			updatable 	= 	true, 
			use_OBB 	= 	true,
			use_release_message = {true, false}
	}
end

function default_animated_lever(hint_, device_, command_, arg_, animation_speed_,arg_lim_)
local arg_lim__ = arg_lim_ or {0.0,1.0}
return  {	
	class  = {class_type.TUMB, class_type.TUMB},
	hint   	= hint_, 
	device 	= device_,
	action 	= {command_, command_},
	arg 		= {arg_, arg_},
	arg_value 	= {1, 0},
	arg_lim 	= {arg_lim__, arg_lim__},
	updatable  = true, 
	gain 		= {0.1, 0.1},
	animated 	= {true, true},
	animation_speed = {animation_speed_, 0},
	cycle = true
}
end

function default_button_tumb(hint_, device_, command1_, command2_, arg_)
	return  {	
				class 		= {class_type.BTN,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command1_,command2_},
				stop_action = {command1_,0},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-1,1}, 
				arg_lim   	= {{-1,0},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
				use_release_message = {true,false}
			}
end

elements = {}

-- Landing Gear & Tail Hook
elements["PNT_8"] = default_2_position_tumb("Landing Gear Handle", devices.GEAR, device_commands.Gear, 8)
elements["PNT_8"].animated        = {true, true}
elements["PNT_8"].animation_speed = {2, 2}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  2 means animates in 0.5 seconds.

--[[  Remove tail hook level from clickables, until we can solve the tail hook problem in DCS replays. For now it moves to a gauge in mainpanel_init.lua
elements["PNT_10"] = default_2_position_tumb("Tail Hook Handle", devices.GEAR, device_commands.Hook, 10)
elements["PNT_10"].animated        = {true, true}
elements["PNT_10"].animation_speed = {2, 2} -- multiply these numbers by the base 1.0 second animation speed to get final speed.  2 means animates in 0.5 seconds.
--]]
elements["PNT_83"] = multiposition_switch_limited("Master Lighting ON/OFF/Momentary", devices.EXT_LIGHTS, device_commands.extlight_master, 83, 3, 1, false, -1.0, TOGGLECLICK_LEFT_MID)

--Spoilers
elements["PNT_84"] = default_2_position_tumb("Spoiler Arm Switch",devices.SPOILERS, device_commands.spoiler_arm,84,TOGGLECLICK_LEFT_MID)
--Speedbrake
elements["PNT_85"] = default_2_position_tumb("Speedbrake switch",devices.AIRBRAKES, device_commands.speedbrake,85,TOGGLECLICK_LEFT_MID)
elements["PNT_128"] = default_3_position_tumb("Speedbrake emergency",devices.AIRBRAKES, device_commands.speedbrake_emer,128)

-- canopy lever
elements["PNT_129"] = default_2_position_tumb("Canopy", devices.CANOPY, Keys.Canopy, 0)

elements["PNT_132"] = multiposition_switch_limited("Flaps Lever", devices.FLAPS, device_commands.flaps, 132, 3, 1, false, -1.0)

-- THROTTLE CONTROL PANEL
elements["PNT_80"] = default_3_position_tumb("Throttle",devices.ENGINE, device_commands.throttle_click,0,false,true)
elements["PNT_82"] = default_axis_limited("Rudder trim", devices.TRIM, device_commands.rudder_trim, 82, 0.0, 0.3, false, false, {-1,1})


--ENGINE CONTROL PANEL
elements["PNT_100"] = default_2_position_tumb("Starter switch",devices.ENGINE, device_commands.push_starter_switch,100)
elements["PNT_100"].sound = {{PUSHPRESS,PUSHRELEASE}}

--elements["PNT_201"] = default_3_position_tumb("Throttle cutoff",devices.ENGINE, device_commands.throttle,201,false)


-- RADAR CONTROL PANEL #6
elements["PNT_120"] = multiposition_switch_limited( "Radar Mode", devices.RADAR, device_commands.radar_mode, 120, 5, 0.10, nil, nil, KNOBCLICK_LEFT_MID )
elements["PNT_120"].animated        = {true, true}
elements["PNT_120"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
elements["PNT_121"] = default_2_position_tumb( "Radar AoA Compensation", devices.RADAR, device_commands.radar_aoacomp, 121, TOGGLECLICK_LEFT_MID)
elements["PNT_122"] = default_axis_limited( "Radar Antenna Elevation", devices.RADAR, device_commands.radar_angle, 122, 0.4, 0.1, false, false, {0,1} )
elements["PNT_123"] = default_axis_limited( "Radar Warning Volume", devices.RADAR, device_commands.radar_volume, 123, 0.0, 0.3, false, false, {-1,1} )

-- APPROACH POWER COMPENSATOR PANEL #17A
elements["PNT_135"] = multiposition_switch_limited("APC Enable/Stby/Off", devices.AFCS, device_commands.apc_engagestbyoff, 135, 3, 1.0, false, -1.0, TOGGLECLICK_LEFT_FWD)
elements["PNT_136"] = multiposition_switch_limited("APC Cold/Std/Hot", devices.AFCS, device_commands.apc_hotstdcold, 136, 3, 1.0, false, -1.0, TOGGLECLICK_LEFT_FWD)

elements["PNT_139"] = default_button("Reset Accelerometer", devices.AVIONICS, device_commands.accel_reset, 139, nil, nil, TOGGLECLICK_MID_FWD)

elements["PNT_146"] = default_button("Stopwatch", devices.CLOCK, device_commands.clock_stopwatch, 146)

-- AFCS PANEL #8  (Aircraft Flight Control System)
elements["PNT_160"] = default_2_position_tumb("AFCS standby",devices.AFCS, device_commands.afcs_standby,160, TOGGLECLICK_LEFT_AFT)
elements["PNT_161"] = default_2_position_tumb("AFCS engage",devices.AFCS, device_commands.afcs_engage,161, TOGGLECLICK_LEFT_AFT)
elements["PNT_162"] = default_2_position_tumb("AFCS preselect heading",devices.AFCS, device_commands.afcs_hdg_sel,162, TOGGLECLICK_LEFT_AFT)
elements["PNT_163"] = default_2_position_tumb("AFCS altitude hold",devices.AFCS, device_commands.afcs_alt,163, TOGGLECLICK_LEFT_AFT)
elements["PNT_164"] = default_axis_limited( "AFCS heading selector", devices.AFCS, device_commands.afcs_hdg_set, 164, 0.0, 0.3, false, true, {0,1} )
elements["PNT_165"] = default_2_position_tumb("AFCS stability aug (unimplemented)",devices.AFCS, device_commands.afcs_stab_aug,165, TOGGLECLICK_LEFT_AFT)
elements["PNT_166"] = default_2_position_tumb("AFCS aileron trim (unimplemented)",devices.AFCS, device_commands.afcs_ail_trim,166, TOGGLECLICK_LEFT_AFT)

-- RADAR SCOPE #20
elements["PNT_400"] = default_axis_limited("Radar Storage", devices.RADAR, device_commands.radar_storage, 400, 0.0, 0.3, false, false, {-1,1})
elements["PNT_401"] = default_axis_limited("Radar Brilliance", devices.RADAR, device_commands.radar_brilliance, 401, 0.0, 0.3, false, false, {-1,1})
elements["PNT_402"] = default_axis_limited("Radar Detail", devices.RADAR, device_commands.radar_detail, 402, 0.0, 0.3, false, false, {-1,1})
elements["PNT_403"] = default_axis_limited("Radar Gain", devices.RADAR, device_commands.radar_gain, 403, 0.0, 0.3, false, false, {-1,1})
elements["PNT_404"] = default_axis_limited("Radar Reticle", devices.RADAR, device_commands.radar_reticle, 404, 0.0, 0.3, false, false, {-1,1})
elements["PNT_405"] = default_2_position_tumb("Radar Filter Plate", devices.RADAR, device_commands.radar_filter, 405)
elements["PNT_405"].animated        = {true, true}
elements["PNT_405"].animation_speed = {4, 4}  -- animation duration = 1/value.  4 means animates in .25 seconds.

elements["PNT_390"] = multiposition_switch("GunPods: Charge/Off/Clear", devices.WEAPON_SYSTEM, device_commands.gunpod_chargeclear, 390, 3, 1, false, -1, TOGGLECLICK_LEFT_FWD)
elements["PNT_391"] = default_2_position_tumb("GunPods: Left Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_l, 391, TOGGLECLICK_LEFT_FWD)
elements["PNT_392"] = default_2_position_tumb("GunPods: Center Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_c, 392, TOGGLECLICK_LEFT_FWD)
elements["PNT_393"] = default_2_position_tumb("GunPods: Right Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_r, 393, TOGGLECLICK_LEFT_FWD)


elements["PNT_522"] = multiposition_switch_limited("Countermeasures: Bank Select", devices.WEAPON_SYSTEM, device_commands.cm_bank, 522, 3, 1, true, -1, TOGGLECLICK_LEFT_FWD)
elements["PNT_523"] = default_2_position_tumb("Countermeasures: Auto Mode Toggle", devices.WEAPON_SYSTEM, device_commands.cm_auto, 523, TOGGLECLICK_LEFT_FWD)
elements["PNT_524"] = default_axis("Countermeasures: Bank 1 Adjust", devices.WEAPON_SYSTEM, device_commands.cm_adj1, 524, 0.0, 1, false, true)
elements["PNT_525"] = default_axis("Countermeasures: Bank 2 Adjust", devices.WEAPON_SYSTEM, device_commands.cm_adj2, 525, 0.0, 1, false, true)
elements["PNT_530"] = default_2_position_tumb("Countermeasures: Power Toggle", devices.WEAPON_SYSTEM, device_commands.cm_pwr, 530, TOGGLECLICK_LEFT_FWD)

-- RADAR ALTIMETER #30
-- combined 2 position switch and rotatable knob. The switch turns the radar altimeter
-- on and off, and the knob sets the indexer
-- NOTE: There is supposed to be a 'push-to-test' function too, but currently
-- unknown how to implement this together with the 2position toggle switch.. if the first member of class is BTN,
-- then you get a push button, but not a 2pos switch anymore.. and if you amke the first entry in arg_lim {-1,1} then
-- you get a 3position switch, which is also undesirable
-- The master press-to-test switch on the misc switches panel also tests the radar altimeter, so perhaps good
-- enough for this switch/knob here to only represent on/off and not test mode
elements["PNT_602"] = default_button_axis("Radar altitude warning",devices.RADARWARN, device_commands.radar_alt_switch, device_commands.radar_alt_indexer,603,602)
elements["PNT_602"].class = {class_type.TUMB, class_type.LEV}
elements["PNT_602"].relative = {false,true}
elements["PNT_602"].gain = {1.0, 0.1}
elements["PNT_602"].arg_lim = {{-1, 0}, {0, 1}}
elements["PNT_602"].stop_action = nil

-- STANDBY ATTITUDE INDICATOR #33
elements["PNT_662"] = default_button_axis("Standby attitude horizon",devices.AVIONICS, device_commands.stby_att_index_button, device_commands.stby_att_index_knob,663,662)
elements["PNT_662"].gain = {1.0, 0.1}
elements["PNT_662"].relative = {false,true}
elements["PNT_662"].updatable = nil
elements["PNT_662"].animated = nil
elements["PNT_662"].animation_speed = nil
elements["PNT_662"].arg_lim = {{0, 1}, {0, 1}}

--ARMAMENT PANEL #35
--elements["PNT_700"] = default_3_position_tumb("Emergency selector switch",devices.WEAPON_SYSTEM, device_commands.arm_emer_sel,700)
elements["PNT_700"] = multiposition_switch_limited("Emergency release selector",devices.WEAPON_SYSTEM, device_commands.arm_emer_sel,700,7,0.1,false,nil,KNOBCLICK_MID_FWD)
--elements["PNT_700"].animated        = {true, true}
--elements["PNT_700"].animation_speed = {2, 2}
elements["PNT_701"] = default_2_position_tumb("Guns switch",devices.WEAPON_SYSTEM, device_commands.arm_gun,701,TOGGLECLICK_MID_FWD)
elements["PNT_702"] = default_3_position_tumb("Bomb arm switch",devices.WEAPON_SYSTEM, device_commands.arm_bomb,702,nil,nil,TOGGLECLICK_MID_FWD)
elements["PNT_703"] = default_2_position_tumb("Station 1 select",devices.WEAPON_SYSTEM, device_commands.arm_station1,703,TOGGLECLICK_MID_FWD)
elements["PNT_704"] = default_2_position_tumb("Station 2 select",devices.WEAPON_SYSTEM, device_commands.arm_station2,704,TOGGLECLICK_MID_FWD)
elements["PNT_705"] = default_2_position_tumb("Station 3 select",devices.WEAPON_SYSTEM, device_commands.arm_station3,705,TOGGLECLICK_MID_FWD)
elements["PNT_706"] = default_2_position_tumb("Station 4 select",devices.WEAPON_SYSTEM, device_commands.arm_station4,706,TOGGLECLICK_MID_FWD)
elements["PNT_707"] = default_2_position_tumb("Station 5 select",devices.WEAPON_SYSTEM, device_commands.arm_station5,707,TOGGLECLICK_MID_FWD)
elements["PNT_708"] = multiposition_switch_limited("Function selector",devices.WEAPON_SYSTEM, device_commands.arm_func_selector,708,6,0.1,false,nil,KNOBCLICK_MID_FWD)

--elements["PNT_708"].animated        = {true, true}
--elements["PNT_708"].animation_speed = {2, 2}
elements["PNT_709"] = default_2_position_tumb("Master armament",devices.ELECTRIC_SYSTEM, device_commands.arm_master,709,TOGGLECLICK_MID_FWD)
elements["PNT_721"] = default_2_position_tumb("Radar Plan/Profile",devices.RADAR, device_commands.radar_planprofile,721,TOGGLECLICK_MID_FWD)
elements["PNT_722"] = default_2_position_tumb("Radar Long/Short Range",devices.RADAR, device_commands.radar_range,722,TOGGLECLICK_MID_FWD)
elements["PNT_724"] = multiposition_switch_limited("BDHI mode",devices.NAV,device_commands.bdhi_mode,724,3,1.0,false,-1.0,TOGGLECLICK_MID_FWD)    -- values = -1,0,1

-- AIRCRAFT WEAPONS RELEASE SYSTEM PANEL #37
elements["PNT_740"] = multiposition_switch_limited("AWRS quantity selector",devices.WEAPON_SYSTEM, device_commands.AWRS_quantity,740,12,0.05,false,nil,KNOBCLICK_MID_FWD)
elements["PNT_742"] = default_movable_axis("AWRS drop interval",devices.WEAPON_SYSTEM, device_commands.AWRS_drop_interval,742,0,0.05,false,false)
elements["PNT_742"].arg_lim = {0,0.9}

elements["PNT_743"] = default_2_position_tumb("AWRS multiplier",devices.WEAPON_SYSTEM, device_commands.AWRS_multiplier,743,TOGGLECLICK_MID_FWD)
elements["PNT_744"] = multiposition_switch_limited("AWRS mode",devices.WEAPON_SYSTEM, device_commands.AWRS_stepripple,744,6,0.1,false,nil,KNOBCLICK_MID_FWD)
--elements["PNT_744"].animated        = {true, true}
--elements["PNT_744"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.

-- MISC SWITCHES PANEL #36
elements["PNT_720"] = default_button("Show EXT Fuel", devices.AVIONICS, device_commands.FuelGaugeExtButton, 720, nil, nil, TOGGLECLICK_MID_FWD)
elements["PNT_723"] = default_button("Master test", devices.AVIONICS, device_commands.master_test, 723)

-- ALTIMETER PANEL #41
elements["PNT_827"] = default_axis("Altimeter Setting", devices.AVIONICS, device_commands.AltPressureKnob, 827, 0, 0.05, false, true)

-- IAS Gauge
elements["PNT_884"] = default_button_axis("IAS Index",devices.AVIONICS, device_commands.ias_index_button, device_commands.ias_index_knob,885,884)
elements["PNT_884"].relative = {false,true}
elements["PNT_884"].gain = {1.0, 0.2}

-- GUNSIGHT
elements["PNT_895"] = default_axis("Gunsight brightness",devices.GUNSIGHT, device_commands.GunsightBrightness,895,0,0.1,false,false)
elements["PNT_891"] = default_2_position_tumb("Gunsight day/night",devices.GUNSIGHT, device_commands.GunsightDayNight,891,TOGGLECLICK_MID_FWD)
elements["PNT_892"] = default_movable_axis("Gunsight elevation", devices.GUNSIGHT, device_commands.GunsightKnob, 892, 1.0, 0.05, false, false)

-- ARN-52V TACAN
elements["PNT_900"] = multiposition_switch_limited("TACAN Mode", devices.NAV, device_commands.tacan_mode, 900, 4, 0.1, false, nil, KNOBCLICK_RIGHT_MID)
elements["PNT_900"].animated        = {true, true}
elements["PNT_900"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
elements["PNT_901"] = multiposition_switch_limited("TACAN Channel Major", devices.NAV, device_commands.tacan_ch_major, 901, 13, 0.05, false, nil, KNOBCLICK_RIGHT_MID)
elements["PNT_902"] = multiposition_switch_limited("TACAN Channel Minor", devices.NAV, device_commands.tacan_ch_minor, 902, 10, 0.1, false,nil, KNOBCLICK_RIGHT_MID)
--elements["PNT_902"] = default_button_tumb("TACAN Channel Minor", devices.NAV, device_commands.tacan_ch_minor_dec, device_commands.tacan_ch_minor_inc, 902)
elements["PNT_903"] = default_axis_limited("TACAN Volume", devices.NAV, device_commands.tacan_volume, 903, 0.0, 0.3, false, false, {-1,1} )

-- DOPPLER NAVIGATION COMPUTER #50 (ASN-41 / APN-153)
elements["PNT_170"] = multiposition_switch_limited("APN-153 Doppler Radar Mode",devices.NAV, device_commands.doppler_select,170,5,0.1,false,nil, KNOBCLICK_RIGHT_FWD)
elements["PNT_170"].animated        = {true, true}
elements["PNT_170"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
elements["PNT_247"] = default_button("APN-153 Memory Light Test", devices.NAV, device_commands.doppler_memory_test, 247)

elements["PNT_176"] = multiposition_switch_limited("ASN-41 Navigation Mode",devices.NAV, device_commands.nav_select,176,5,0.1,false,nil, KNOBCLICK_RIGHT_FWD)
elements["PNT_176"].animated        = {true, true}
elements["PNT_176"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
elements["PNT_177"] = default_axis("ASN-41 Present Position - Latitude", devices.NAV, device_commands.ppos_lat, 177, 0.0, 0.1, false, true)
elements["PNT_183"] = default_axis("ASN-41 Present Position - Longitude", devices.NAV, device_commands.ppos_lon, 183, 0.0, 0.1, false, true)
elements["PNT_190"] = default_axis("ASN-41 Destination - Latitude", devices.NAV, device_commands.dest_lat, 190, 0.0, 0.1, false, true)
elements["PNT_196"] = default_axis("ASN-41 Destination - Longitude", devices.NAV, device_commands.dest_lon, 196, 0.0, 0.1, false, true)
elements["PNT_203"] = default_axis("ASN-41 Magnetic Variation", devices.NAV, device_commands.asn41_magvar, 203, 0.0, 0.1, false, true)
elements["PNT_209"] = default_axis("ASN-41 Wind Speed", devices.NAV, device_commands.asn41_windspeed, 209, 0.0, 0.1, false, true)
elements["PNT_213"] = default_axis("ASN-41 Wind Bearing", devices.NAV, device_commands.asn41_winddir, 213, 0.0, 0.1, false, true)

-- LIGHTS SWITCHES PANEL #47
-- see also PNT_83 on the throttle, for master external lighting switch
elements["PNT_217"] = multiposition_switch_limited("Probe Light", devices.EXT_LIGHTS, device_commands.extlight_probe, 217, 3, 1, false, -1.0, TOGGLECLICK_RIGHT_MID)
elements["PNT_218"] = default_2_position_tumb("Taxi Light", devices.EXT_LIGHTS, device_commands.extlight_taxi, 218, TOGGLECLICK_RIGHT_MID)
elements["PNT_219"] = default_2_position_tumb("Anti-Collision Lights", devices.EXT_LIGHTS, device_commands.extlight_anticoll, 219, TOGGLECLICK_RIGHT_MID)
elements["PNT_220"] = multiposition_switch_limited("Fuselage Lights", devices.EXT_LIGHTS, device_commands.extlight_fuselage, 220, 3, 1, false, -1.0, TOGGLECLICK_RIGHT_MID)
elements["PNT_221"] = default_2_position_tumb("Lighting Flash/Steady mode", devices.EXT_LIGHTS, device_commands.extlight_flashsteady, 221, TOGGLECLICK_RIGHT_MID)
elements["PNT_222"] = multiposition_switch_limited("Navigation Lights", devices.EXT_LIGHTS, device_commands.extlight_nav, 222, 3, 1, false, -1.0, TOGGLECLICK_RIGHT_MID)
elements["PNT_223"] = multiposition_switch_limited("Tail Light", devices.EXT_LIGHTS, device_commands.extlight_tail, 223, 3, 1, false, -1.0, TOGGLECLICK_RIGHT_MID)

-- MISC SWITCHES PANEL #53
elements["PNT_1061"] = default_2_position_tumb("Emergency generator bypass",devices.ELECTRIC_SYSTEM, device_commands.emer_gen_bypass,1061, TOGGLECLICK_RIGHT_AFT)

-- INTERIOR LIGHTING PANEL #54
elements["PNT_106"] = default_axis_limited( "Instrument Lighting", devices.AVIONICS, device_commands.intlight_instruments, 106, 0.0, 0.3, false, false, {0,1} )
elements["PNT_107"] = default_axis_limited( "Console Lighting", devices.AVIONICS, device_commands.intlight_console, 107, 0.0, 0.3, false, false, {0,1} )
elements["PNT_108"] = multiposition_switch_limited("Console Light Intensity", devices.AVIONICS, device_commands.intlight_brightness, 108, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_AFT)
elements["PNT_110"] = default_axis_limited( "White Floodlight Control", devices.AVIONICS, device_commands.intlight_whiteflood, 110, 0.0, 0.3, false, false, {-1,1} )

-- AN/ARC-51 UHF RADIO #67
elements["PNT_361"] = multiposition_switch_limited("ARC-51 UHF Preset Channel", devices.RADIO, device_commands.arc51_freq_preset, 361, 20, 0.05, false, 0.00, KNOBCLICK_RIGHT_MID)
elements["PNT_365"] = default_axis_limited("ARC-51 UHF Volume", devices.RADIO, device_commands.arc51_volume, 365, 0.5, 0.3, false, false, {0,1})
elements["PNT_366"] = multiposition_switch_limited("ARC-51 UHF Frequency Mode", devices.RADIO, device_commands.arc51_xmitmode, 366, 3, 1, true, -1, KNOBCLICK_RIGHT_MID)
elements["PNT_367"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 10 MHz", devices.RADIO, device_commands.arc51_freq_XXxxx, 367, 18, 0.05, false, 0, KNOBCLICK_RIGHT_MID)
elements["PNT_368"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 1 MHz", devices.RADIO, device_commands.arc51_freq_xxXxx, 368, 10, 0.1, false, 0, KNOBCLICK_RIGHT_MID)
elements["PNT_369"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 50 kHz", devices.RADIO, device_commands.arc51_freq_xxxXX, 369, 20, 0.05, false, 0, KNOBCLICK_RIGHT_MID)
elements["PNT_370"] = default_2_position_tumb("ARC-51 UHF Squelch Disable", devices.RADIO, device_commands.arc51_squelch, 370, TOGGLECLICK_RIGHT_MID)
elements["PNT_372"] = multiposition_switch_limited("ARC-51 UHF Mode", devices.RADIO, device_commands.arc51_mode, 372, 4, 0.1, false, 0, KNOBCLICK_RIGHT_MID)

-- T handles
elements["PNT_1240"] = default_2_position_tumb("Emergency gear release",devices.GEAR, device_commands.emer_gear_release,1240)
elements["PNT_1240"].animated        = {true, true}
elements["PNT_1240"].animation_speed = {15, 15}
elements["PNT_1241"] = default_2_position_tumb("Emergency bomb release",devices.WEAPON_SYSTEM, device_commands.emer_bomb_release,1241)
elements["PNT_1241"].animated        = {true, true}
elements["PNT_1241"].animation_speed = {15, 15}
elements["PNT_1243"] = default_2_position_tumb("Emergency generator deploy",devices.ELECTRIC_SYSTEM, device_commands.emer_gen_deploy,1243)
elements["PNT_1243"].animated        = {true, true}
elements["PNT_1243"].animation_speed = {15, 15}

-- ECM panel
elements["PNT_503"] = default_2_position_tumb("Audio APR/25 - APR/27",devices.RWR,device_commands.ecm_apr25_audio,	503,TOGGLECLICK_LEFT_MID)
elements["PNT_504"] = default_2_position_tumb("APR/25 on/off",	devices.RWR, device_commands.ecm_apr25_off,		504,TOGGLECLICK_LEFT_MID)
elements["PNT_501"] = default_2_position_tumb("APR/27 on/off",	devices.RWR, device_commands.ecm_apr27_off,		501,TOGGLECLICK_LEFT_MID)

elements["PNT_507"] = default_button("APR/27 test", devices.RWR, device_commands.ecm_systest_upper, 507)--,TOGGLECLICK_LEFT_MID)
elements["PNT_510"] = default_button("APR/27 light", devices.RWR, device_commands.ecm_systest_lower, 510)--,TOGGLECLICK_LEFT_MID)

elements["PNT_506"] = default_axis_limited( "PRF volume (inner knob)", devices.RWR, device_commands.ecm_msl_alert_axis_inner, 506, 0.0, 0.3, false, false, {-0.8,0.8} )
elements["PNT_505"] = default_axis_limited( "MSL volume (outer knob)", devices.RWR, device_commands.ecm_msl_alert_axis_outer, 505, 0.0, 0.3, false, false, {-0.8,0.8} )

elements["PNT_502"] = multiposition_switch_limited("ECM selector knob",devices.RWR, device_commands.ecm_selector_knob,502,4,0.33,false,0.0,KNOBCLICK_MID_FWD)



for i,o in pairs(elements) do
	if  o.class[1] == class_type.TUMB or 
	   (o.class[2]  and o.class[2] == class_type.TUMB) or
	   (o.class[3]  and o.class[3] == class_type.TUMB)  then
	   o.updatable = true
	   o.use_OBB   = true
	end
end