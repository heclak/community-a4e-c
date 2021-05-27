dofile(LockOn_Options.script_path.."clickable_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."sounds.lua")
--dofile(LockOn_Options.common_script_path..'localizer.lua')

local gettext = require("i_18n")
_ = gettext.translate



elements = {}

--THESE SOUNDS ARE DEFINED BY /Cockpit/Scripts/sounds.lua

-- Mirrors
elements["PNT_MIRROR_LEFT"]  = default_2_position_tumb("Toggle Mirrors", 0, 1625, nil)
elements["PNT_MIRROR_RIGHT"] = default_2_position_tumb("Toggle Mirrors", 0, 1625, nil)

elements["PNT_2"] = default_2_position_tumb("Hide Stick Toggle", devices.CANOPY, Keys.ToggleStick, nil)

-- Landing Gear & Tail Hook
elements["PNT_8"] = default_2_position_tumb("Landing Gear Handle", devices.GEAR, device_commands.Gear, 8)
elements["PNT_8"].animated        = {true, true}
elements["PNT_8"].animation_speed = {2, 2}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  2 means animates in 0.5 seconds.
elements["PNT_8"].sound = {{GEAR_LEVER_DOWN,GEAR_LEVER_UP}}

--Remove tail hook level from clickables, until we can solve the tail hook problem in DCS replays. For now it moves to a gauge in mainpanel_init.lua
elements["PNT_10"] = default_2_position_tumb("Tail Hook Handle", devices.GEAR, device_commands.Hook, 10)
elements["PNT_10"].animated        = {true, true}
elements["PNT_10"].animation_speed = {2, 2} -- multiply these numbers by the base 1.0 second animation speed to get final speed.  2 means animates in 0.5 seconds.
elements["PNT_10"].sound = {{TAILHOOK_HANDLE_DOWN,TAILHOOK_HANDLE_UP}}--{{TAILHOOK_HANDLE_DOWN},{KNOBCLICK_RIGHT_MID}}

elements["PNT_83"] = multiposition_switch_limited("Master Lighting ON/OFF/Momentary", devices.EXT_LIGHTS, device_commands.extlight_master, 83, 3, 1, false, -1.0, TOGGLECLICK_LEFT_MID)

--Spoilers
elements["PNT_84"] = default_2_position_tumb("Spoiler Arm Switch",devices.SPOILERS, device_commands.spoiler_arm,84,TOGGLECLICK_LEFT_MID)
elements["PNT_133"] = default_2_position_tumb("JATO ARM-OFF Switch",devices.AVIONICS, device_commands.JATO_arm,133,TOGGLECLICK_LEFT_MID)
elements["PNT_134"] = default_2_position_tumb("JATO JETTISON-SAFE Switch",devices.AVIONICS, device_commands.JATO_jettison,134,TOGGLECLICK_LEFT_MID)
--Speedbrake
elements["PNT_85"] = default_2_position_tumb("Speedbrake switch",devices.AIRBRAKES, device_commands.speedbrake,85,SPEEDBRAKE_SWITCH)
elements["PNT_128"] = default_3_position_tumb("Speedbrake emergency",devices.AIRBRAKES, device_commands.speedbrake_emer,128)

-- canopy lever
elements["PNT_129"] = default_2_position_tumb("Canopy", devices.CANOPY, Keys.Canopy, 0)
elements["PNT_129"].sound = {{CANOPY_LEVER_OPEN,CANOPY_LEVER_CLOSE}}

elements["PNT_132"] = multiposition_switch_limited("Flaps Lever", devices.FLAPS, device_commands.flaps, 132, 3, 1, false, -1.0)
elements["PNT_132"].sound = {{FLAPS_LEVER}}
-- THROTTLE PANEL
elements["PNT_80"] 	= default_3_position_tumb("Throttle", devices.ENGINE, device_commands.throttle_click,0, false, true)
elements["PNT_80"].sound = {{THROTTLE_DETENT}}
elements["PNT_82"] 	= default_axis_limited("Rudder trim", devices.TRIM, device_commands.rudder_trim, 82, 0.0, 0.3, false, false, {-1,1})

--ENGINE CONTROL PANEL
elements["PNT_100"] = default_2_position_tumb("Starter switch",devices.ENGINE, device_commands.push_starter_switch,100)
elements["PNT_100"].sound = {{STARTER_PUSH,STARTER_RELEASE}}
elements["PNT_101"] = default_3_position_tumb("Drop Tanks Pressurization and Flight Refuel switch", devices.ENGINE, device_commands.ENGINE_drop_tanks_sw, 101, false, true, TOGGLECLICK_LEFT_MID) -- NO COMMAND
elements["PNT_103"] = default_3_position_tumb("Emer Transfer and Wing Fuel Dump switch", devices.ENGINE, device_commands.ENGINE_wing_fuel_sw, 103, false, true, TOGGLECLICK_LEFT_MID) -- NO COMMAND
elements["PNT_104"] = default_2_position_tumb("Fuel control switch",devices.ENGINE, device_commands.ENGINE_fuel_control_sw,104, TOGGLECLICK_LEFT_MID)
elements["PNT_130"] = default_2_position_tumb("Manual Fuel Shutoff Lever",devices.ENGINE, device_commands.ENGINE_manual_fuel_shutoff, 130, nil, 3)
-- elements["PNT_130"].updatable = false
-- elements["PNT_130"].use_OBB = false
elements["PNT_131"] = default_2_position_tumb("Manual Fuel Shutoff Catch",devices.ENGINE, device_commands.ENGINE_manual_fuel_shutoff_catch, 131, nil, 2) -- NO COMMAND
--elements["PNT_201"] = default_3_position_tumb("Throttle cutoff",devices.ENGINE, device_commands.throttle,201,false)

-- OXYGEN and ANTI-G PANEL
elements["PNT_125"] = default_2_position_tumb("Oxygen Switch", devices.AVIONICS, device_commands.oxygen_switch, 125, TOGGLECLICK_LEFT_MID)

-- RADAR CONTROL PANEL #6
elements["PNT_120"] = multiposition_switch_limited( "Radar Mode", devices.RADAR, device_commands.radar_mode, 120, 5, 0.10, nil, nil, KNOBCLICK_LEFT_MID )
elements["PNT_120"].animated        = {true, true}
elements["PNT_120"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
elements["PNT_121"] = default_2_position_tumb( "Radar AoA Compensation", devices.RADAR, device_commands.radar_aoacomp, 121, TOGGLECLICK_LEFT_MID)
elements["PNT_122"] = default_axis_limited( "Radar Antenna Tilt", devices.RADAR, device_commands.radar_angle, 122, 0.4, 0.1, false, false, {0,1} )
elements["PNT_123"] = default_axis_limited( "Radar Obstacle Tone Volume", devices.RADAR, device_commands.radar_volume, 123, 0.0, 0.3, false, false, {-1,1} )

-- APPROACH POWER COMPENSATOR PANEL #17A
elements["PNT_135"] = multiposition_switch_limited("APC Enable/Stby/Off", devices.AFCS, device_commands.apc_engagestbyoff, 135, 3, 1.0, false, -1.0, TOGGLECLICK_LEFT_FWD)
elements["PNT_136"] = multiposition_switch_limited("APC Cold/Std/Hot", devices.AFCS, device_commands.apc_hotstdcold, 136, 3, 1.0, false, -1.0, TOGGLECLICK_LEFT_FWD)

elements["PNT_139"] = default_button("Reset Accelerometer", devices.AVIONICS, device_commands.accel_reset, 139, nil, nil, TOGGLECLICK_MID_FWD)

elements["PNT_146"] = default_button("Stopwatch", devices.CLOCK, device_commands.clock_stopwatch, 146)

-- ANGLE OF ANGLE INDEXER
elements["PNT_853"] = default_axis_limited( "AOA Indexer Dimming Wheel", devices.AVIONICS, device_commands.AOA_dimming_wheel_AXIS, 853, 1.0, 0.2, false, false, {-1,1} )

-- AFCS PANEL #8  (Aircraft Flight Control System)
elements["PNT_160"] = default_2_position_tumb("AFCS standby",devices.AFCS, device_commands.afcs_standby,160, TOGGLECLICK_LEFT_AFT)
elements["PNT_161"] = default_2_position_tumb("AFCS engage",devices.AFCS, device_commands.afcs_engage,161, TOGGLECLICK_LEFT_AFT)
elements["PNT_162"] = default_2_position_tumb("AFCS preselect heading",devices.AFCS, device_commands.afcs_hdg_sel,162, TOGGLECLICK_LEFT_AFT)
elements["PNT_163"] = default_2_position_tumb("AFCS altitude hold",devices.AFCS, device_commands.afcs_alt,163, TOGGLECLICK_LEFT_AFT)
elements["PNT_164"] = default_axis_limited( "AFCS heading selector", devices.AFCS, device_commands.afcs_hdg_set, 164, 0.0, 0.3, false, true, {0,1} )
elements["PNT_165"] = default_2_position_tumb("AFCS stability aug",devices.AFCS, device_commands.afcs_stab_aug,165, TOGGLECLICK_LEFT_AFT)
elements["PNT_166"] = default_2_position_tumb("AFCS aileron trim (unimplemented)",devices.AFCS, device_commands.afcs_ail_trim,166, TOGGLECLICK_LEFT_AFT)

-- RADAR SCOPE #20
elements["PNT_400"] = default_axis_limited("Radar Storage", devices.RADAR, device_commands.radar_storage, 400, 0.0, 0.3, false, false, {-1,1})
elements["PNT_401"] = default_axis_limited("Radar Brilliance", devices.RADAR, device_commands.radar_brilliance, 401, 0.0, 0.3, false, false, {-1,1})
elements["PNT_402"] = default_axis_limited("Radar Detail", devices.RADAR, device_commands.radar_detail, 402, 0.0, 0.3, false, false, {-1,1})
elements["PNT_403"] = default_axis_limited("Radar Gain", devices.RADAR, device_commands.radar_gain, 403, 0.0, 0.3, false, false, {-1,1})
elements["PNT_404"] = default_axis_limited("Radar Reticle", devices.RADAR, device_commands.radar_reticle, 404, 0.0, 0.3, false, false, {-1,1})
elements["PNT_405"] = default_2_position_tumb("Radar Filter Plate", devices.RADAR, device_commands.radar_filter, 405)
elements["PNT_405"].animated = {true, true}
elements["PNT_405"].animation_speed = {4, 4}  -- animation duration = 1/value.  4 means animates in .25 seconds.
elements["PNT_405"].sound = {{RADAR_FILTER_DOWN}, {RADAR_FILTER_UP}}

elements["PNT_390"] = multiposition_switch_limited("GunPods: Charge/Off/Clear", devices.WEAPON_SYSTEM, device_commands.gunpod_chargeclear, 390, 3, 1, false, -1, TOGGLECLICK_LEFT_FWD)
elements["PNT_391"] = default_2_position_tumb("GunPods: Left Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_l, 391, TOGGLECLICK_LEFT_FWD)
elements["PNT_392"] = default_2_position_tumb("GunPods: Center Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_c, 392, TOGGLECLICK_LEFT_FWD)
elements["PNT_393"] = default_2_position_tumb("GunPods: Right Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_r, 393, TOGGLECLICK_LEFT_FWD)


elements["PNT_522"] = multiposition_switch_limited("Countermeasures: Bank Select", devices.COUNTERMEASURES, device_commands.cm_bank, 522, 3, 1, true, -1, TOGGLECLICK_LEFT_FWD)
elements["PNT_523"] = default_button("Countermeasures: Auto Pushbutton", devices.COUNTERMEASURES, device_commands.cm_auto, 523, 1, nil, TOGGLECLICK_LEFT_FWD)
elements["PNT_524"] = default_axis("Countermeasures: Bank 1 Adjust", devices.COUNTERMEASURES, device_commands.cm_adj1, 524, 0.0, 1, false, true)
elements["PNT_525"] = default_axis("Countermeasures: Bank 2 Adjust", devices.COUNTERMEASURES, device_commands.cm_adj2, 525, 0.0, 1, false, true)
elements["PNT_530"] = default_2_position_tumb("Countermeasures: Power Toggle", devices.COUNTERMEASURES, device_commands.cm_pwr, 530, TOGGLECLICK_LEFT_FWD)

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
elements["PNT_602"].arg_lim = {{-1, 0}, {0, 1}}
elements["PNT_602"].stop_action = nil

-- STANDBY ATTITUDE INDICATOR #33
elements["PNT_662"] = default_button_axis("Standby attitude horizon",devices.AVIONICS, device_commands.stby_att_index_button, device_commands.stby_att_index_knob,663,662)
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
elements["PNT_702"] = default_3_position_tumb("Bomb arm switch",devices.WEAPON_SYSTEM, device_commands.arm_bomb,702,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_703"] = default_2_position_tumb("Station 1 select",devices.WEAPON_SYSTEM, device_commands.arm_station1,703,TOGGLECLICK_MID_FWD)
elements["PNT_704"] = default_2_position_tumb("Station 2 select",devices.WEAPON_SYSTEM, device_commands.arm_station2,704,TOGGLECLICK_MID_FWD)
elements["PNT_705"] = default_2_position_tumb("Station 3 select",devices.WEAPON_SYSTEM, device_commands.arm_station3,705,TOGGLECLICK_MID_FWD)
elements["PNT_706"] = default_2_position_tumb("Station 4 select",devices.WEAPON_SYSTEM, device_commands.arm_station4,706,TOGGLECLICK_MID_FWD)
elements["PNT_707"] = default_2_position_tumb("Station 5 select",devices.WEAPON_SYSTEM, device_commands.arm_station5,707,TOGGLECLICK_MID_FWD)
elements["PNT_708"] = multiposition_switch_limited("Function selector",devices.WEAPON_SYSTEM, device_commands.arm_func_selector,708,7,0.1,false,nil,KNOBCLICK_MID_FWD, 2)

--elements["PNT_708"].animated        = {true, true}
--elements["PNT_708"].animation_speed = {2, 2}
elements["PNT_709"] = default_2_position_tumb("Master armament",devices.ELECTRIC_SYSTEM, device_commands.arm_master,709,TOGGLECLICK_MID_FWD)
elements["PNT_721"] = default_2_position_tumb("Radar Plan/Profile",devices.RADAR, device_commands.radar_planprofile,721,TOGGLECLICK_MID_FWD)
elements["PNT_722"] = default_2_position_tumb("Radar Long/Short Range",devices.RADAR, device_commands.radar_range,722,TOGGLECLICK_MID_FWD)
elements["PNT_724"] = multiposition_switch_limited("BDHI mode",devices.NAV,device_commands.bdhi_mode,724,3,1.0,false,-1.0,TOGGLECLICK_MID_FWD)    -- values = -1,0,1

-- AIRCRAFT WEAPONS RELEASE SYSTEM PANEL #37
elements["PNT_740"] = multiposition_switch_limited("AWRS quantity selector",devices.WEAPON_SYSTEM, device_commands.AWRS_quantity,740,12,0.05,false,nil,KNOBCLICK_MID_FWD, 1)
elements["PNT_742"] = default_axis_limited("AWRS drop interval",devices.WEAPON_SYSTEM, device_commands.AWRS_drop_interval,742,0,0.05,false,false, {0, 0.9})
-- elements["PNT_742"].arg_lim = {0,0.9}

elements["PNT_743"] = default_2_position_tumb("AWRS multiplier",devices.WEAPON_SYSTEM, device_commands.AWRS_multiplier,743,TOGGLECLICK_MID_FWD)
elements["PNT_744"] = multiposition_switch_limited("AWRS mode",devices.WEAPON_SYSTEM, device_commands.AWRS_stepripple,744,6,0.1,false,nil,KNOBCLICK_MID_FWD, 2)
--elements["PNT_744"].animated        = {true, true}
--elements["PNT_744"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.

-- MISC SWITCHES PANEL #36
elements["PNT_720"] = default_button("Show EXT Fuel", devices.AVIONICS, device_commands.FuelGaugeExtButton, 720)
elements["PNT_723"] = default_button("Master test", devices.AVIONICS, device_commands.master_test, 723)
elements["PNT_725"] = multiposition_switch_limited( "Shrike Selector Knob", devices.WEAPON_SYSTEM, device_commands.shrike_selector, 725, 5, 0.1, false, nil, KNOBCLICK_MID_FWD, 2)
elements["PNT_726"] = default_axis_limited( "Missile Volume Knob", devices.WEAPON_SYSTEM, device_commands.shrike_sidewinder_volume, 726, 0, 0.1, false, false, {-1.0,1.0} )


-- ALTIMETER PANEL #41
elements["PNT_827"] = default_axis("Altimeter Setting", devices.AVIONICS, device_commands.AltPressureKnob, 827, 0, 0.05, false, true)

-- IAS Gauge
elements["PNT_884"] = default_button_axis("IAS Index",devices.AVIONICS, device_commands.ias_index_button, device_commands.ias_index_knob,885,884)
elements["PNT_884"].relative = {false,true}
elements["PNT_884"].gain = {1.0, 0.2}

-- GUNSIGHT
elements["PNT_895"] = default_axis("Gunsight Light Control",devices.GUNSIGHT, device_commands.GunsightBrightness,895,0,0.05,false,false)
elements["PNT_891"] = default_2_position_tumb("Gunsight Day/Night Switch",devices.GUNSIGHT, device_commands.GunsightDayNight,891,TOGGLECLICK_MID_FWD)
elements["PNT_892"] = default_movable_axis("Gunsight Elevation Control", devices.GUNSIGHT, device_commands.GunsightKnob, 892, 1.0, 0.05, false, false)

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

elements["PNT_176"] = multiposition_switch_limited("ASN-41 Function Selector Switch",devices.NAV, device_commands.nav_select,176,5,0.1,false,nil, KNOBCLICK_RIGHT_FWD)
elements["PNT_176"].animated        = {true, true}
elements["PNT_176"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.

elements["PNT_177"] = default_button_axis("ASN-41 Present Position - Latitude Knob", devices.NAV, device_commands.ppos_lat_push, device_commands.ppos_lat, 236, 177, 1, 1)
elements["PNT_177"].relative[2] = true
elements["PNT_177"].arg_value[2] = 1
elements["PNT_177"].animated = {true, false}
elements["PNT_177"].animation_speed = {16.0, 0}
elements["PNT_177"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

elements["PNT_183"] = default_button_axis("ASN-41 Present Position - Longitude Knob", devices.NAV, device_commands.ppos_lon_push, device_commands.ppos_lon, 237, 183, 1, 1)
elements["PNT_183"].relative[2] = true
elements["PNT_183"].arg_value[2] = 1
elements["PNT_183"].animated = {true, false}
elements["PNT_183"].animation_speed = {16.0, 0}
elements["PNT_183"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

elements["PNT_190"] = default_button_axis("ASN-41 Destination - Latitude Knob", devices.NAV, device_commands.dest_lat_push, device_commands.dest_lat, 238, 190, 1, 1)
elements["PNT_190"].relative[2] = true
elements["PNT_190"].arg_value[2] = 1
elements["PNT_190"].animated = {true, false}
elements["PNT_190"].animation_speed = {16.0, 0}
elements["PNT_190"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

elements["PNT_248"] = springloaded_3_pos_tumb("ASN-41 Destination - Latitude Slew", devices.NAV, device_commands.dest_lat_slew, 248, true, KNOBCLICK_RIGHT_MID)

elements["PNT_196"] = default_button_axis("ASN-41 Destination - Longitude Knob", devices.NAV, device_commands.dest_lon_push, device_commands.dest_lon, 239, 196, 1, 1)
elements["PNT_196"].relative[2] = true
elements["PNT_196"].arg_value[2] = 1
elements["PNT_196"].animated = {true, false}
elements["PNT_196"].animation_speed = {16.0, 0}
elements["PNT_196"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

elements["PNT_249"] = springloaded_3_pos_tumb("ASN-41 Destination - Longitude Slew", devices.NAV, device_commands.dest_lon_slew, 249, true, KNOBCLICK_RIGHT_MID)

elements["PNT_203"] = default_button_axis("ASN-41 Magnetic Variation Knob", devices.NAV, device_commands.asn41_magvar_push, device_commands.asn41_magvar, 240, 203, 1, 1)
elements["PNT_203"].relative[2] = true
elements["PNT_203"].arg_value[2] = 1
elements["PNT_203"].animated = {true, false}
elements["PNT_203"].animation_speed = {16.0, 0}
elements["PNT_203"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
elements["PNT_209"] = default_button_axis("ASN-41 Wind Speed Knob", devices.NAV, device_commands.asn41_windspeed_push, device_commands.asn41_windspeed, 241, 209, 1, 1)
elements["PNT_209"].relative[2] = true
elements["PNT_209"].arg_value[2] = 1
elements["PNT_209"].animated = {true, false}
elements["PNT_209"].animation_speed = {16.0, 0}
elements["PNT_209"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
elements["PNT_213"] = default_button_axis("ASN-41 Wind Direction Knob", devices.NAV, device_commands.asn41_winddir_push, device_commands.asn41_winddir, 242, 213, 1, 1)
elements["PNT_213"].relative[2] = true
elements["PNT_213"].arg_value[2] = 1
elements["PNT_213"].animated = {true, false}
elements["PNT_213"].animation_speed = {16.0, 0}
elements["PNT_213"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

-- LIGHTS SWITCHES PANEL #47
-- see also PNT_83 on the throttle, for master external lighting switch
elements["PNT_217"] = multiposition_switch_limited("Probe Light", devices.EXT_LIGHTS, device_commands.extlight_probe, 217, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)
elements["PNT_218"] = default_2_position_tumb("Taxi Light", devices.EXT_LIGHTS, device_commands.extlight_taxi, 218, TOGGLECLICK_RIGHT_MID)
elements["PNT_219"] = default_2_position_tumb("Anti-Collision Lights", devices.EXT_LIGHTS, device_commands.extlight_anticoll, 219, TOGGLECLICK_RIGHT_MID)
elements["PNT_220"] = multiposition_switch_limited("Fuselage Lights", devices.EXT_LIGHTS, device_commands.extlight_fuselage, 220, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)
elements["PNT_221"] = default_2_position_tumb("Lighting Flash/Steady mode", devices.EXT_LIGHTS, device_commands.extlight_flashsteady, 221, TOGGLECLICK_RIGHT_MID)
elements["PNT_222"] = multiposition_switch_limited("Navigation Lights", devices.EXT_LIGHTS, device_commands.extlight_nav, 222, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)
elements["PNT_223"] = multiposition_switch_limited("Tail Light", devices.EXT_LIGHTS, device_commands.extlight_tail, 223, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)

-- MISC SWITCHES PANEL #53
elements["PNT_250"] = multiposition_switch_limited("MCL Channel Selector",         devices.MCL, device_commands.mcl_channel_selector, 250, 20, 0.05, false, nil, KNOBCLICK_RIGHT_AFT, 2)
elements["PNT_251"] = springloaded_3_pos_tumb("Seat Adjustment (unimplemented)",                   devices.AVIONICS, device_commands.seat_adjustment, 251, false, KNOBCLICK_RIGHT_MID)
elements["PNT_252"] = default_2_position_tumb("Emergency Generator Bypass/Normal", devices.ELECTRIC_SYSTEM, device_commands.emer_gen_bypass, 252, TOGGLECLICK_RIGHT_AFT)
elements["PNT_253"] = springloaded_forward_only_3_pos_tumb("MCL Power",                         devices.MCL, device_commands.mcl_power_switch, 253, false, TOGGLECLICK_RIGHT_AFT)
elements["PNT_254"] = default_3_position_tumb("TACAN Antenna Control (unimplemented)",             devices.NAV, device_commands.tacan_antenna, 254, nil, false, TOGGLECLICK_RIGHT_AFT)
elements["PNT_255"] = default_2_position_tumb("Navigation Dead Reckoning/Doppler (unimplemented)", devices.NAV, device_commands.nav_dead_recon, 255, TOGGLECLICK_RIGHT_AFT)
elements["PNT_256"] = default_2_position_tumb("Fuel Transfer Bypass/Normal",       devices.ENGINE, device_commands.fuel_transfer_bypass, 256, TOGGLECLICK_RIGHT_AFT)
elements["PNT_257"] = default_2_position_tumb("Rain Removal (unimplemented)",                      devices.AVIONICS, device_commands.rain_removal, 257, TOGGLECLICK_RIGHT_AFT)

-- INTERIOR LIGHTING PANEL #54
elements["PNT_106"] = default_axis_limited( "Instrument Lighting", devices.AVIONICS, device_commands.intlight_instruments, 106, 0.0, 0.3, false, false, {0,1} )
elements["PNT_107"] = default_axis_limited( "Console Lighting", devices.AVIONICS, device_commands.intlight_console, 107, 0.0, 0.3, false, false, {0,1} )
elements["PNT_108"] = multiposition_switch_limited("Console Light Intensity", devices.AVIONICS, device_commands.intlight_brightness, 108, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_AFT)
elements["PNT_110"] = default_axis_limited( "White Floodlight Control", devices.AVIONICS, device_commands.intlight_whiteflood, 110, 0.0, 0.3, false, false, {0,1} )
-- TODO: trigger at or leave 0 ?
elements["PNT_405"].sound = {{COCKPIT_ILLUM_POT, COCKPIT_ILLUM_POT}}

-- AFCS TEST PANEL #59
elements["PNT_258"] = default_2_position_tumb("AFCS 1-N-2 Guard", devices.AFCS, device_commands.afcs_test_guard, 258, nil, 4.0)
elements["PNT_259"] = springloaded_3_pos_tumb("AFCS 1-N-2",       devices.AFCS, device_commands.afcs_test, 259, true, KNOBCLICK_RIGHT_AFT)

-- AN/ARC-51 UHF RADIO #67
elements["PNT_361"] = multiposition_switch_limited("ARC-51 UHF Preset Channel", devices.RADIO, device_commands.arc51_freq_preset, 361, 20, 0.05, false, 0.00, KNOBCLICK_RIGHT_MID)
elements["PNT_365"] = default_axis_limited("ARC-51 UHF Volume", devices.RADIO, device_commands.arc51_volume, 365, 0.5, 0.3, false, false, {0,1})
elements["PNT_366"] = multiposition_switch_limited("ARC-51 UHF Frequency Mode", devices.RADIO, device_commands.arc51_xmitmode, 366, 3, 1, true, -1, KNOBCLICK_RIGHT_MID)
elements["PNT_367"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 10 MHz", devices.RADIO, device_commands.arc51_freq_XXooo, 367, 18, 0.05, false, 0, KNOBCLICK_RIGHT_MID)
elements["PNT_368"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 1 MHz", devices.RADIO, device_commands.arc51_freq_ooXoo, 368, 10, 0.1, false, 0, KNOBCLICK_RIGHT_MID)
elements["PNT_369"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 50 kHz", devices.RADIO, device_commands.arc51_freq_oooXX, 369, 20, 0.05, false, 0, KNOBCLICK_RIGHT_MID)
elements["PNT_370"] = default_2_position_tumb("ARC-51 UHF Squelch Disable", devices.RADIO, device_commands.arc51_squelch, 370, TOGGLECLICK_RIGHT_MID)
elements["PNT_372"] = multiposition_switch_limited("ARC-51 UHF Mode", devices.RADIO, device_commands.arc51_mode, 372, 4, 0.1, false, 0, KNOBCLICK_RIGHT_MID)

-- COMPASS CONTROLLER
elements["PNT_509"] = default_axis_limited("Compass latitude knob", devices.COMPASS, device_commands.COMPASS_latitude, 509, 0, 0.3, false, false, {-1,1})
elements["PNT_511"] = springloaded_3_pos_tumb("Compass heading set knob", devices.COMPASS, device_commands.COMPASS_set_heading, 511, true, KNOBCLICK_RIGHT_MID)
elements["PNT_512"] = default_2_position_tumb("Compass Free/Slaved Mode Switch", devices.COMPASS, device_commands.COMPASS_free_slaved_switch, 512, TOGGLECLICK_RIGHT_MID) -- NO COMMAND
elements["PNT_513"] = default_button("Compass Push to Sync", devices.COMPASS, device_commands.COMPASS_push_to_sync, 513) -- NO COMMAND

-- T handles
elements["PNT_1240"] = default_2_position_tumb("Emergency gear release",devices.GEAR, device_commands.emer_gear_release,1240)
elements["PNT_1240"].animated        = {true, true}
elements["PNT_1240"].animation_speed = {15, 15}
elements["PNT_1240"].sound = {{EMER_GEAR_PULL, EMER_GEAR_RELEASE}}
elements["PNT_1241"] = default_2_position_tumb("Emergency bomb release",devices.WEAPON_SYSTEM, device_commands.emer_bomb_release,1241)
elements["PNT_1241"].animated        = {true, true}
elements["PNT_1241"].animation_speed = {15, 15}
elements["PNT_1241"].sound = {{EMER_BOMB_PULL, EMER_BOMB_RELEASE}}
elements["PNT_1242"] = default_2_position_tumb("Manual Flight Control",devices.HYDRAULIC_SYSTEM, device_commands.man_flt_control_override,1242)
elements["PNT_1242"].animated        = {true, true}
elements["PNT_1242"].animation_speed = {15, 15}
elements["PNT_1242"].sound = {{EMER_BOMB_PULL, EMER_BOMB_RELEASE}}
elements["PNT_1243"] = default_2_position_tumb("Emergency generator deploy",devices.ELECTRIC_SYSTEM, device_commands.emer_gen_deploy,1243)
elements["PNT_1243"].animated        = {true, true}
elements["PNT_1243"].animation_speed = {15, 15}
elements["PNT_1243"].sound = {{EMER_BOMB_PULL, EMER_BOMB_RELEASE}}

-- ECM panel
elements["PNT_503"] = default_2_position_tumb("Audio APR/25 - APR/27",devices.RWR,device_commands.ecm_apr25_audio,	503,TOGGLECLICK_LEFT_MID)
elements["PNT_504"] = default_2_position_tumb("APR/25 on/off",	devices.RWR, device_commands.ecm_apr25_off,		504,TOGGLECLICK_LEFT_MID)
elements["PNT_501"] = default_2_position_tumb("APR/27 on/off",	devices.RWR, device_commands.ecm_apr27_off,		501,TOGGLECLICK_LEFT_MID)

elements["PNT_507"] = default_button("APR/27 test", devices.RWR, device_commands.ecm_systest_upper, 507)--,TOGGLECLICK_LEFT_MID)
elements["PNT_510"] = default_button("APR/27 light", devices.RWR, device_commands.ecm_systest_lower, 510)--,TOGGLECLICK_LEFT_MID)

elements["PNT_506"] = default_axis_limited( "PRF volume (inner knob)", devices.RWR, device_commands.ecm_msl_alert_axis_inner, 506, 0.0, 0.3, false, false, {-0.8,0.8} )
elements["PNT_505"] = default_axis_limited( "MSL volume (outer knob)", devices.RWR, device_commands.ecm_msl_alert_axis_outer, 505, 0.0, 0.3, false, false, {-0.8,0.8} )

elements["PNT_502"] = multiposition_switch_limited("ECM selector knob",devices.RWR, device_commands.ecm_selector_knob,502,4,0.33,false,0.0,KNOBCLICK_MID_FWD, 5)

-- AIR CONDITIONING PANEL
elements["PNT_1251"] = default_2_position_tumb("Cabin Pressure Switch", devices.ELECTRIC_SYSTEM, device_commands.cabin_pressure , 224, TOGGLECLICK_LEFT_MID)
elements["PNT_225"] = default_3_position_tumb("Windshield Defrost", devices.ELECTRIC_SYSTEM, device_commands.windshield_defrost , 225, nil, nil, TOGGLECLICK_MID_FWD)
elements["PNT_226"] = default_axis_limited("Cabin Temp Knob", devices.ELECTRIC_SYSTEM, device_commands.cabin_temp , 226, 0.0, 0.3, false, false, {0,1} )

-- EJECTION SEAT
elements["PNT_24"] = default_2_position_tumb("Shoulder Harness Inertia Reel Control", devices.AVIONICS ,device_commands.CPT_shoulder_harness, 24, nil)
elements["PNT_24"].animated        = {true, true}
elements["PNT_24"].animation_speed = {7, 7}
elements["PNT_24"].sound = {{HARNESS_LOCK, HARNESS_UNLOCK}}
elements["PNT_25"] = default_2_position_tumb("Secondary Ejection Handle", devices.AVIONICS ,device_commands.CPT_secondary_ejection_handle, 25, nil)
elements["PNT_25"].animated        = {true, true}
elements["PNT_25"].animation_speed = {7, 7}
elements["PNT_25"].sound = {{EJECTION_PULL, EJECTION_PULL}}

-- Commented out because it doesn't seem to be required anymore [HECLAK]
-- Can be removed if someone figures out what the original requirement was
-- for i,o in pairs(elements) do
-- 	if  o.class[1] == class_type.TUMB or 
-- 	   (o.class[2]  and o.class[2] == class_type.TUMB) or
-- 	   (o.class[3]  and o.class[3] == class_type.TUMB)  then
-- 	   o.updatable = true
-- 	   o.use_OBB   = true
-- 	end
-- end