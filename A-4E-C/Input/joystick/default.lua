local cscripts = folder.."../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands,{

    ---------------------------------------------
    -- General ----------------------------------
    ---------------------------------------------
    -- {down = iCommandCockpitShowPilotOnOff, name = _('Show Pilot Body'), category = _('General')},

    ---------------------------------------------
    -- View Cockpit -----------------------------
    ---------------------------------------------
    {down = iCommandViewLeftMirrorOn, up = iCommandViewLeftMirrorOff,   name = _('Mirror Left ON else OFF'),    category = {_('View Cockpit')}},
    {down = iCommandViewRightMirrorOn, up = iCommandViewRightMirrorOff, name = _('Mirror Right ON else OFF'),   category = {_('View Cockpit')}},
    {down = iCommandToggleMirrors,                                      name = _('Mirrors ON/OFF'),             category = {_('View Cockpit')}},

    ---------------------------------------------
    -- Systems ----------------------------------
    ---------------------------------------------
    {down = iCommandPlaneEject,                                         name = _('Eject (3 times)'),            category = {_('Systems')}},
    {down = Keys.BrakesOn, up = Keys.BrakesOff,                         name = _('Wheel Brake - ON else OFF'),       category = {_('Systems')}},
	{down = Keys.BrakesOnLeft, up = Keys.BrakesOffLeft,					name = _('Wheel Brake Left - ON else OFF'), 	category = {_('Systems')}},
	{down = Keys.BrakesOnRight, up = Keys.BrakesOffRight,				name = _('Wheel Brake Right - ON else OFF'), category = {_('Systems')}},

    ---------------------------------------------
    -- Flight Control ---------------------------
    --------------------------------------------- 
    {down = iCommandPlaneUpStart, up = iCommandPlaneUpStop,                     name = _('Aircraft Pitch Down'),    category = {_('Flight Control')}},
    {down = iCommandPlaneDownStart, up = iCommandPlaneDownStop,                 name = _('Aircraft Pitch Up'),      category = {_('Flight Control')}},
    {down = iCommandPlaneLeftStart, up = iCommandPlaneLeftStop,                 name = _('Aircraft Bank Left'),     category = {_('Flight Control')}},
    {down = iCommandPlaneRightStart, up = iCommandPlaneRightStop,               name = _('Aircraft Bank Right'),    category = {_('Flight Control')}},
    {down = iCommandPlaneLeftRudderStart, up = iCommandPlaneLeftRudderStop,     name = _('Aircraft Rudder Left'),   category = {_('Flight Control')}},
    {down = iCommandPlaneRightRudderStart, up = iCommandPlaneRightRudderStop,   name = _('Aircraft Rudder Right'),  category = {_('Flight Control')}},

    ---------------------------------------------
    -- Stick ------------------------------------
    ---------------------------------------------
    {pressed = Keys.TrimUp, up = Keys.TrimStop,                                      name = _('Trimmer Switch - NOSE UP'),          category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimDown, up = Keys.TrimStop,                                    name = _('Trimmer Switch - NOSE DOWN'),        category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimLeft, up = Keys.TrimStop,                                    name = _('Trimmer Switch - LEFT WING DOWN'),   category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimRight, up = Keys.TrimStop,                                   name = _('Trimmer Switch - RIGHT WING DOWN'),  category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimCancel, up = Keys.TrimStop,                                  name = _('Trimmer Reset (Hold)'),              category = {_('Stick'), _('Flight Control')}},
    {combos = {{key = 'JOY_BTN1'}}, down = Keys.PlaneFireOn, up = Keys.PlaneFireOff, name = _('Gun-Rocket Trigger'),                category = {_('Stick')}},
    {combos = {{key = 'JOY_BTN2'}}, down = Keys.PickleOn, up = Keys.PickleOff,       name = _('Bomb Release Button'),               category = {_('Stick')}},
    {down = Keys.AFCSOverride,                                                       name = _('AFCS Override Button'),              category = {_('Stick')}},
    {down = Keys.ToggleStick,                                                        name = _('Control Stick - HIDE/SHOW'),         category = {_('Stick')}},
    {down = Keys.nws_engage, up = Keys.nws_disengage,                                name = _('Nose Wheel Steering - ON else OFF'), category = {_('Stick')}},

    ---------------------------------------------
    -- Throttle Quadrant ------------------------
    ---------------------------------------------
    {down = iCommandPlaneAUTIncreaseRegime,                                                           name = _('Throttle Rotary - Increment'),                           category = {_('Throttle Quadrant'), _('Flight Control')}},
    {down = iCommandPlaneAUTDecreaseRegime,                                                           name = _('Throttle Rotary - Decrement'),                           category = {_('Throttle Quadrant'), _('Flight Control')}},
    {pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,                                   name = _('Throttle Continuous - Increase'),                        category = {_('Throttle Quadrant'), _('Flight Control')}},
    {pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,                                   name = _('Throttle Continuous - Decrease'),                        category = {_('Throttle Quadrant'), _('Flight Control')}},

    {down = device_commands.throttle_click_ITER, value_down = 1, cockpit_device_id = devices.ENGINE,  name = _('Throttle OFF/IGN/IDLE - Step Up'),                       category = {_('Throttle Quadrant')}},
    {down = device_commands.throttle_click_ITER, value_down = -1, cockpit_device_id = devices.ENGINE, name = _('Throttle OFF/IGN/IDLE - Step Down'),                     category = {_('Throttle Quadrant')}},

    {down = Keys.ExtLightMaster, value_down = 1,                                                      name = _('Master Exterior Lights Switch - ON'),                    category = {_('Throttle Grip')}},
    {down = Keys.ExtLightMaster, value_down = 0,                                                      name = _('Master Exterior Lights Switch - OFF'),                   category = {_('Throttle Grip')}},
    {down = Keys.ExtLightMasterToggle,                                                                name = _('Master Exterior Lights Switch - ON/OFF'),                category = {_('Throttle Grip')}},
    {down = Keys.ExtLightMaster, value_down = 1, up = Keys.ExtLightMaster, value_up = 0,              name = _('Master Exterior Lights Switch - ON else OFF'),           category = {_('Throttle Grip')}},
    {down = iCommandPlaneAirBrake,                                                                    name = _('Speedbrake Switch - OPEN/CLOSE'),                        category = {_('Throttle Grip')}},
    {down = iCommandPlaneAirBrakeOn, up = iCommandPlaneAirBrakeOff,                                   name = _('Speedbrake Switch - OPEN else CLOSE'),                   category = {_('Throttle Grip')}},
    {down = iCommandPlaneAirBrakeOn,                                                                  name = _('Speedbrake Switch - OPEN'),                              category = {_('Throttle Grip')}},
    {down = iCommandPlaneAirBrakeOff,                                                                 name = _('Speedbrake Switch - CLOSE'),                             category = {_('Throttle Grip')}},

    {pressed = Keys.TrimLeftRudder, up = Keys.TrimStop,                                               name = _('Rudder Trim Switch - Rudder Left'),                      category = {_('Throttle Quadrant'), _('Flight Control')}},
    {pressed = Keys.TrimRightRudder, up = Keys.TrimStop,                                              name = _('Rudder Trim Switch - Rudder Right'),                     category = {_('Throttle Quadrant'), _('Flight Control')}},

    -- Flap Switch
    {down = iCommandPlaneFlaps,                                                                       name = _('FLAP Switch - UP/DOWN'),                                 category = {_('Throttle Quadrant')}},
    {down = iCommandPlaneFlapsOn,                                                                     name = _('FLAP Switch - DOWN'),                                    category = {_('Throttle Quadrant')}},
    {down = iCommandPlaneFlapsOff,                                                                    name = _('FLAP Switch - UP'),                                      category = {_('Throttle Quadrant')}},
    {down = Keys.PlaneFlapsStop,                                                                      name = _('FLAP Switch - STOP'),                                    category = {_('Throttle Quadrant')}},
    {down = Keys.PlaneFlapsDownHotas, up = Keys.PlaneFlapsStop,                                       name = _('FLAP Switch - DOWN else STOP'),                          category = {_('Throttle Quadrant')}},
    {down = Keys.PlaneFlapsUpHotas, up = Keys.PlaneFlapsStop,                                         name = _('FLAP Switch - UP else STOP'),                            category = {_('Throttle Quadrant')}},

    ---------------------------------------------
    -- ALE-29A Chaff Control Panel --------------
    --------------------------------------------- 
    {down = Keys.CmBankSelectRotate,                                                                                                            name = _('ALE-29A Dispenser Select - Cycle'),       category = {_('Chaff Control Panel')}},
    {down = Keys.CmBankSelect, value_down = -1,                                                                                                 name = _('ALE-29A Dispenser Select - 1'),           category = {_('Chaff Control Panel')}},
    {down = Keys.CmBankSelect, value_down = 1,                                                                                                  name = _('ALE-29A Dispenser Select - 2'),           category = {_('Chaff Control Panel')}},
    {down = Keys.CmBankSelect, value_down = 0,                                                                                                  name = _('ALE-29A Dispenser Select - Both'),        category = {_('Chaff Control Panel')}},
    {down = device_commands.cm_auto, up = device_commands.cm_auto, cockpit_device_id = devices.COUNTERMEASURES, value_down = 1.0, value_up = 0, name = _('ALE-29A AUTO Pushbutton'),                category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank1AdjUp,                                                                                                                  name = _('ALE-29A Dispenser 1 Counter - Increase'), category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank1AdjDown,                                                                                                                name = _('ALE-29A Dispenser 1 Counter - Decrease'), category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank2AdjUp,                                                                                                                  name = _('ALE-29A Dispenser 2 Counter - Increase'), category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank2AdjDown,                                                                                                                name = _('ALE-29A Dispenser 2 Counter - Decrease'), category = {_('Chaff Control Panel')}},
    {down = Keys.CmPowerToggle,                                                                                                                 name = _('ALE-29A PWR Switch - PWR/OFF'),           category = {_('Chaff Control Panel')}},
    {down = device_commands.cm_pwr, up = device_commands.cm_pwr, cockpit_device_id = devices.COUNTERMEASURES, value_down = 1.0, value_up = 0,   name = _('ALE-29A PWR Switch - PWR else OFF'),      category = {_('Chaff Control Panel')}},

    ---------------------------------------------
    -- ECM Control Panel ------------------------
    ---------------------------------------------
    {down = device_commands.ecm_selector_knob, value_down = 0.0, cockpit_device_id = devices.RWR,                                                       name = _('ECM Function Selector - OFF'),            category = {_('ECM Control Panel')}},
    {down = device_commands.ecm_selector_knob, value_down = 0.33, cockpit_device_id = devices.RWR,                                                      name = _('ECM Function Selector - STBY'),           category = {_('ECM Control Panel')}},
    {down = device_commands.ecm_selector_knob, value_down = 0.66, cockpit_device_id = devices.RWR,                                                      name = _('ECM Function Selector - REC'),            category = {_('ECM Control Panel')}},
    {down = device_commands.ecm_selector_knob, value_down = 0.99, cockpit_device_id = devices.RWR,                                                      name = _('ECM Function Selector - RPT'),            category = {_('ECM Control Panel')}},
    {down = Keys.ecm_select_cw,                                                                                                                         name = _('ECM Function Selector Switch - CW'),      category = {_('ECM Control Panel')}},
    {down = Keys.ecm_select_ccw,                                                                                                                        name = _('ECM Function Selector Switch - CCW'),     category = {_('ECM Control Panel')}},
    {down = Keys.ecm_apr27_off, value_down = 1.0, value_up = 0.0,                                                                                       name = _('APR-27 - ON/OFF'),                        category = {_('ECM Control Panel')}},
    {down = device_commands.ecm_apr27_off, up = device_commands.ecm_apr27_off, value_down = 1.0, value_up = 0.0, cockpit_device_id = devices.RWR,       name = _('APR-27 - ON else OFF'),                   category = {_('ECM Control Panel')}},
    {down = Keys.ecm_apr25_off, value_down = 1.0, value_up = 0.0, name = _('APR-25 - ON/OFF'), category = {_('ECM Control Panel')}},
    {down = device_commands.ecm_apr25_off, up = device_commands.ecm_apr25_off, value_down = 1.0, value_up = 0.0, cockpit_device_id = devices.RWR,       name = _('APR-25 - ON else OFF'),                           category = {_('ECM Control Panel')}},
    {down = device_commands.ecm_apr25_audio, up = device_commands.ecm_apr25_audio, value_down = 1.0, value_up = 0.0, cockpit_device_id = devices.RWR,   name = _('Audio - APR/27 else APR/25'),                     category = {_('ECM Control Panel')}},
    {down = Keys.ecm_OuterKnobInc,                                                                                                                      name = _('MSL Volume (Outer Knob) - Rotary Increment'),     category = {_('ECM Control Panel')}},
    {down = Keys.ecm_OuterKnobDec,                                                                                                                      name = _('MSL Volume (Outer Knob) - Rotary Decrement'),     category = {_('ECM Control Panel')}},
    {down = Keys.ecm_OuterKnobStartUp, up = Keys.ecm_OuterKnobStop,                                                                                     name = _('MSL Volume (Outer Knob) - Continuous Increase'),  category = {_('ECM Control Panel')}},
    {down = Keys.ecm_OuterKnobStartDown, up = Keys.ecm_OuterKnobStop,                                                                                   name = _('MSL Volume (Outer Knob) - Continuous Decrease'),  category = {_('ECM Control Panel')}},
    {down = Keys.ecm_InnerKnobInc,                                                                                                                      name = _('PRF Volume (Inner Knob) - Rotary Increment'),     category = {_('ECM Control Panel')}},
    {down = Keys.ecm_InnerKnobDec,                                                                                                                      name = _('PRF Volume (Inner Knob) - Rotary Decrement'),     category = {_('ECM Control Panel')}},
    {down = Keys.ecm_InnerKnobStartUp, up = Keys.ecm_InnerKnobStop,                                                                                     name = _('PRF Volume (Inner Knob) - Continuous Increase'),  category = {_('ECM Control Panel')}},
    {down = Keys.ecm_InnerKnobStartDown, up = Keys.ecm_InnerKnobStop,                                                                                   name = _('PRF Volume (Inner Knob) - Continuous Decrease'),  category = {_('ECM Control Panel')}}, 
        
    ---------------------------------------------
    -- Instrument Panel -------------------------
    ---------------------------------------------
    -- Gunsight Panel
    {down = Keys.GunsightElevationInc, value_down = 1.0, value_up = 0.0,        name = _('Gunsight Elevation Knob - Rotary Increment'),         category = {_('Gunsight Panel')}},
    {down = Keys.GunsightElevationDec, value_down = 1.0, value_up = 0.0,        name = _('Gunsight Elevation Knob - Rotary Decrement'),         category = {_('Gunsight Panel')}},
    {down = Keys.GunsightElevationStartUp, up = Keys.GunsightElevationStop,     name = _('Gunsight Elevation Knob - Continuous Increase'),      category = {_('Gunsight Panel')}},
    {down = Keys.GunsightElevationStartDown, up = Keys.GunsightElevationStop,   name = _('Gunsight Elevation Knob - Continuous Decrease'),      category = {_('Gunsight Panel')}},
    {down = Keys.GunsightBrightnessInc, value_down = 1.0, value_up = 0.0,       name = _('Gunsight Brightness Knob - Rotary Increment'),        category = {_('Gunsight Panel')}},
    {down = Keys.GunsightBrightnessDec, value_down = 1.0, value_up = 0.0,       name = _('Gunsight Brightness Knob - Rotary Decrement'),        category = {_('Gunsight Panel')}},
    {down = Keys.GunsightBrightnessStartUp, up = Keys.GunsightBrightnessStop,   name = _('Gunsight Brightness Knob - Continuous Increase'),     category = {_('Gunsight Panel')}},
    {down = Keys.GunsightBrightnessStartDown, up = Keys.GunsightBrightnessStop, name = _('Gunsight Brightness Knob - Continuous Decrease'),     category = {_('Gunsight Panel')}},
    {down = Keys.GunsightDayNightToggle,                                        name = _('Gunsight Brightness Switch - DAY/NIGHT'),             category = {_('Gunsight Panel')}},
    {down = device_commands.GunsightDayNight, up = device_commands.GunsightDayNight, value_down = 1.0, value_up = 0.0, cockpit_device_id = devices.GUNSIGHT, name = _('Gunsight Brightness Switch - DAY else NIGHT'), category = {_('Gunsight Panel')}},

    -- Stopwatch
    {down = device_commands.clock_stopwatch, up = device_commands.clock_stopwatch, value_down = 1.0, value_up = 0.0, cockpit_device_id = devices.CLOCK, name = _('Stopwatch - START/STOP/RESET'), category = {_('Instrument Panel')}},

    -- Altimeter
    {down = Keys.AltPressureInc,                                            name = _('Altimeter Pressure - Rotary Increment'),                  category = {_('Instrument Panel')}},
    {down = Keys.AltPressureDec,                                            name = _('Altimeter Pressure - Rotary Decrement'),                  category = {_('Instrument Panel')}},
    {down = Keys.AltPressureStartUp, up = Keys.AltPressureStop,             name = _('Altimeter Pressure - Continuous Increase'),               category = {_('Instrument Panel')}},
    {down = Keys.AltPressureStartDown, up = Keys.AltPressureStop,           name = _('Altimeter Pressure - Continuous Decrease'),               category = {_('Instrument Panel')}},

    -- Radar Altimeter
    {down = Keys.RadarAltToggle,                                            name = _('Radar Altitude Warning - ON/OFF'),                        category = {_('Instrument Panel')}},
    {down = Keys.RadarAltWarningUp,                                         name = _('Radar Altitude Warning - Rotary Increment'),              category = {_('Instrument Panel')}},
    {down = Keys.RadarAltWarningDown,                                       name = _('Radar Altitude Warning - Rotary Decrement'),              category = {_('Instrument Panel')}},
    {down = Keys.RadarAltWarningStartUp, up = Keys.RadarAltWarningStop,     name = _('Radar Altitude Warning - Continuous Increase'),           category = {_('Instrument Panel')}},
    {down = Keys.RadarAltWarningStartDown, up = Keys.RadarAltWarningStop,   name = _('Radar Altitude Warning - Continuous Decrease'),           category = {_('Instrument Panel')}},

    -- Landing Gear Handle
    {down = iCommandPlaneGear,                                              name = _('Landing Gear Handle - UP/DOWN'),                          category = {_('Instrument Panel')}},
    {down = iCommandPlaneGearUp,                                            name = _('Landing Gear Handle - UP'),                               category = {_('Instrument Panel')}},
    {down = iCommandPlaneGearDown,                                          name = _('Landing Gear Handle - DOWN'),                             category = {_('Instrument Panel')}},
    {down = iCommandPlaneGearUp, up = iCommandPlaneGearDown,                name = _('Landing Gear Handle - UP else DOWN'),                     category = {_('Instrument Panel')}},

    -- Arresting Hook Handle
    {down = Keys.PlaneHook,                                                 name = _('Tail Hook Handle - UP/DOWN'),                             category = {_('Instrument Panel')}},
    {down = Keys.PlaneHookUp,                                               name = _('Tail Hook Handle - UP'),                                  category = {_('Instrument Panel')}},
    {down = Keys.PlaneHookDown,                                             name = _('Tail Hook Handle - DOWN'),                                category = {_('Instrument Panel')}},
    {down = Keys.PlaneHookUp, up = Keys.PlaneHookDown,                      name = _('Tail Hook Handle - UP else DOWN'),                        category = {_('Instrument Panel')}},

    -- Misc Switches Panel
    {down = Keys.RadarTCPlanProfile, value_down = 1,                                                                                           name = _('Radar Terrain Clearance - PROFILE'),            category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarTCPlanProfile, value_down = 0,                                                                                           name = _('Radar Terrain Clearance - PLAN'),               category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarTCPlanProfile, value_down = -1,                                                                                          name = _('Radar Terrain Clearance - PROFILE/PLAN'),       category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarTCPlanProfile, value_down = 1, up = Keys.RadarTCPlanProfile, value_up = 0,                                               name = _('Radar Terrain Clearance - PROFILE else PLAN'),  category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = 1,                                                                                          name = _('Radar Range - LONG'),                           category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = 0,                                                                                          name = _('Radar Range - SHORT'),                          category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = -1,                                                                                         name = _('Radar Range - LONG/SHORT'),                     category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = 1, up = Keys.RadarRangeLongShort, value_up = 0,                                             name = _('Radar Range - LONG else SHORT'),                category = {_('Instrument Panel'), _('Misc Switches Panel')}},

    {down = device_commands.bdhi_mode, value_down = -1, cockpit_device_id = devices.NAV,                                                       name = _('BDHI Switch - NAV PAC'),                        category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = device_commands.bdhi_mode, value_down = 0, cockpit_device_id = devices.NAV,                                                        name = _('BDHI Switch - TACAN'),                          category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = device_commands.bdhi_mode, value_down = 1, cockpit_device_id = devices.NAV,                                                        name = _('BDHI Switch - NAV CMPTR'),                      category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = device_commands.bdhi_mode, value_down = -1, up = device_commands.bdhi_mode, value_up = 0, cockpit_device_id = devices.NAV,         name = _('BDHI Switch - NAV PAC else TACAN'),             category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = device_commands.bdhi_mode, value_down = 1, up = device_commands.bdhi_mode, value_up = 0, cockpit_device_id = devices.NAV,          name = _('BDHI Switch - NAV CMPTR else TACAN'),           category = {_('Instrument Panel'), _('Misc Switches Panel')}},

    {down = device_commands.master_test, up = device_commands.master_test, value_down = 1, value_up = 0, cockpit_device_id = devices.AVIONICS, name = _('Master Test Button'),                           category = {_('Instrument Panel'), _('Misc Switches Panel')}},

    {down = Keys.MissileVolumeInc,                                      name = _('Shike/Sidewinder/Missile Volume Knob - Increment'),                category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.MissileVolumeDec,                                      name = _('Shike/Sidewinder/Missile Volume Knob - Decrement'),                category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.MissileVolumeStartUp, up = Keys.MissileVolumeStop,     name = _('Shike/Sidewinder/Missile Volume Knob - Continuous Increase'),      category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.MissileVolumeStartDown, up = Keys.MissileVolumeStop,   name = _('Shike/Sidewinder/Missile Volume Knob - Continuous Decrease'),      category = {_('Instrument Panel'), _('Misc Switches Panel')}},

    {down = Keys.FuelGaugeExt,                                          name = _('Internal-External Fuel Switch - EXT'),            category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.FuelGaugeInt,                                          name = _('Internal-External Fuel Switch - INT'),            category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.FuelGaugeExt, up = Keys.FuelGaugeInt,                  name = _('Internal-External Fuel Switch - EXT else INT'),   category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    
    -- Armament Panel
    {down = device_commands.arm_bomb, value_down = 1, cockpit_device_id = devices.WEAPON_SYSTEM,                                                name = _('BOMB ARM - NOSE & TAIL'),                       category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = 0, cockpit_device_id = devices.WEAPON_SYSTEM,                                                name = _('BOMB ARM - OFF'),                               category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = -1, cockpit_device_id = devices.WEAPON_SYSTEM,                                               name = _('BOMB ARM - TAIL'),                              category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = -1, up = device_commands.arm_bomb, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM,  name = _('BOMB ARM - TAIL else OFF'),                     category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = 1, up = device_commands.arm_bomb, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM,   name = _('BOMB ARM - NOSE & TAIL else OFF'),              category = {_('Instrument Panel'), _('Armament Panel')}},
    
    {down = Keys.Station1,                                                                                                                      name = _('Station 1 Selector - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station2,                                                                                                                      name = _('Station 2 Selector - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station3,                                                                                                                      name = _('Station 3 Selector - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station4,                                                                                                                      name = _('Station 4 Selector - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station5,                                                                                                                      name = _('Station 5 Selector - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},

    {down = device_commands.arm_station1, up = device_commands.arm_station1, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0, name = _('Station 1 Selector - READY else OFF'), category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_station2, up = device_commands.arm_station2, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0, name = _('Station 2 Selector - READY else OFF'), category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_station3, up = device_commands.arm_station3, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0, name = _('Station 3 Selector - READY else OFF'), category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_station4, up = device_commands.arm_station4, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0, name = _('Station 4 Selector - READY else OFF'), category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_station5, up = device_commands.arm_station5, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0, name = _('Station 5 Selector - READY else OFF'), category = {_('Instrument Panel'), _('Armament Panel')}},

    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.0,                                    name = _('Function Selector - OFF'),               category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.1,                                    name = _('Function Selector - ROCKETS'),           category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.2,                                    name = _('Function Selector - GM UNARM'),          category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.3,                                    name = _('Function Selector - SPRAY TANK'),        category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.4,                                    name = _('Function Selector - LABS'),              category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.5,                                    name = _('Function Selector - BOMBS & GM ARM'),    category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.6,                                    name = _('Function Selector - CMPTR'),             category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = Keys.ArmsFuncSelectorCCW,                                                                                                           name = _('Function Selector Switch - CCW'),               category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = Keys.ArmsFuncSelectorCW,                                                                                                            name = _('Function Selector Switch - CW'),                category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    
    {down = Keys.GunsReadyToggle,                                                                                                                   name = _('Gun Charging Switch - READY/SAFE Toggle'), category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_gun, value_down = 1, up = device_commands.arm_gun, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM,         name = _('Guns - READY else SAFE'),                  category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.MasterArmToggle,                                                                                                                   name = _('Master Arm Switch Toggle'),                category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_master, value_down = 1, up = device_commands.arm_master, value_up = 0, cockpit_device_id = devices.ELECTRIC_SYSTEM, name = _('Master Arm - ON else OFF'),                category = {_('Instrument Panel'), _('Armament Panel')}},

    -- Aircraft Weapons Release System Panel
    {down = Keys.AWRSMultiplierToggle,      name = _('AWE-1 MULTIPLIER - ON/OFF'),          category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = device_commands.AWRS_multiplier, up = device_commands.AWRS_multiplier, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0, name = _('MULTIPLIER Switch ON else OFF'), category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSQtySelIncrease,        name = _('AWE-1 QTY SEL - CW/Increase'),        category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSQtySelDecrease,        name = _('AWE-1 QTY SEL - CCW/Decrease'),       category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSModeSelCCW,            name = _('AWE-1 MODE - CCW'),                   category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSModeSelCW,             name = _('AWE-1 MODE - CW'),                    category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRS_Drop_Interval_Inc,    name = _('AWE-1 DROP INTVL - Increment'),       category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRS_Drop_Interval_Dec,    name = _('AWE-1 DROP INTVL - Decrement'),       category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},

    -- T-Handles
    {down = device_commands.emer_bomb_release, up = device_commands.emer_bomb_release, cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 1.0, value_up = 0.0,                     name = _('Handles - EMER BOMB Release'),       category = {_('Instrument Panel')}},
    {down = device_commands.emer_gear_release, up = device_commands.emer_gear_release, cockpit_device_id = devices.GEAR, value_down = 1.0, value_up = 0.0,                              name = _('Handles - EMER GEAR Release'),       category = {_('Instrument Panel')}},
    {down = device_commands.man_flt_control_override, up = device_commands.man_flt_control_override, cockpit_device_id = devices.HYDRAULIC_SYSTEM, value_down = 1.0, value_up = 0.0,    name = _('Handles - MAN FLT CONT Release'),    category = {_('Instrument Panel')}},
    {down = device_commands.emer_gen_deploy, cockpit_device_id = devices.ELECTRIC_SYSTEM, value_down = 1.0,                                                                             name = _('Handles - EMER GEN Release'),        category = {_('Instrument Panel')}},

    ---------------------------------------------
    -- Left Console -----------------------------
    ---------------------------------------------    
    -- Gunpods Control Panel
    {down = Keys.GunpodCharge, name = _('Gunpod Switch - Cycle'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = device_commands.gunpod_chargeclear, value_down = 1, up = device_commands.gunpod_chargeclear, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('Gunpod Switch - CHARGE else OFF'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = device_commands.gunpod_chargeclear, value_down = -1, up = device_commands.gunpod_chargeclear, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('Gunpod Switch - CLEAR else OFF'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = Keys.GunpodLeft, name = _('Gunpod Station LH Switch - READY/SAFE'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = device_commands.gunpod_l, value_down = 1, up = device_commands.gunpod_l, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('Gunpod Station LH Switch - READY else SAFE'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = Keys.GunpodCenter, name = _('Gunpod Station CTR Switch - READY/SAFE'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = device_commands.gunpod_c, value_down = 1, up = device_commands.gunpod_c, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('Gunpod Station CTR Switch - READY else SAFE'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = Keys.GunpodRight, name = _('Gunpod Station RH Switch - READY/SAFE'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = device_commands.gunpod_r, value_down = 1, up = device_commands.gunpod_r, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('Gunpod Station RH Switch - READY else SAFE'), category = {_('Left Console'), _('Gunpods Control Panel')}},

    -- APC Control Panel
    {down = Keys.APCEngageStbyOff, value_down = -1,                                           name = _('APC POWER Switch - OFF'),               category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = 0,                                            name = _('APC POWER Switch - STBY'),              category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = 1,                                            name = _('APC POWER Switch - ENGAGE'),            category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = -1, up = Keys.APCEngageStbyOff, value_up = 0, name = _('APC POWER Switch - OFF else STBY'),     category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = 1, up = Keys.APCEngageStbyOff, value_up = 0,  name = _('APC POWER Switch - ENGAGE else STBY'),  category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = -1,                                              name = _('APC TEMP Switch - COLD'),               category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = 0,                                               name = _('APC TEMP Switch - STD'),                category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = 1,                                               name = _('APC TEMP Switch - HOT'),                category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = -1, up = Keys.APCHotStdCold, value_up = 0,       name = _('APC TEMP Switch - COLD else STD'),      category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = 1, up = Keys.APCHotStdCold, value_up = 0,        name = _('APC TEMP Switch - HOT else STD'),       category = {_('Left Console'), _('APC Control Panel')}},
    
    -- JATO Control Panel
    {down = Keys.SpoilersArmToggle,                                                           name = _('Spoilers Switch - ARM/OFF'),            category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.SpoilersArmOn,                                                               name = _('Spoilers Switch - ARM'),                category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.SpoilersArmOff,                                                              name = _('Spoilers Switch - OFF'),                category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.SpoilersArmOn, up = Keys.SpoilersArmOff,                                     name = _('Spoilers Switch - ARM else OFF'),       category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.JATOFiringButton,                                                            name = _('JATO Firing Button'),                   category = {_('Left Console'), _('JATO Control Panel')}},

    -- Engine Control Panel
    {down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff,                                   name = _('Fuel Dump'),                            category = {_('Left Console'), _('Engine Control Panel')}},
    {down = Keys.Engine_Start,                                                                name = _('Engine Starter Switch - START'),        category = {_('Left Console'), _('Engine Control Panel')}},
    {down = Keys.Engine_Stop,                                                                 name = _('Engine Starter Switch - ABORT'),        category = {_('Left Console'), _('Engine Control Panel')}},
    {down = device_commands.ENGINE_drop_tanks_sw, up = device_commands.ENGINE_drop_tanks_sw, value_down = 1, value_up = 0, cockpit_device_id = devices.ENGINE, name = _('Pressurization - UP/DROP TANKS else PRESS'), category = {_('Left Console'), _('Engine Control Panel')}},
    {down = device_commands.ENGINE_drop_tanks_sw, up = device_commands.ENGINE_drop_tanks_sw, value_down = -1, value_up = 0, cockpit_device_id = devices.ENGINE, name = _('Pressurization - DOWN/FLIGHT REFUEL else PRESS'), category = {_('Left Console'), _('Engine Control Panel')}},

    -- Radar Control Panel
    {down = Keys.RadarModeOFF,                                                          name = _('Radar Mode Selector - OFF'),                                  category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeSTBY,                                                         name = _('Radar Mode Selector - STBY'),                                 category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeSearch,                                                       name = _('Radar Mode Selector - SRCH'),                                 category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeTC,                                                           name = _('Radar Mode Selector - TC'),                                   category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeA2G,                                                          name = _('Radar Mode Selector - A/G'),                                  category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeSearch, up = Keys.RadarModeTC,                                name = _('Radar Mode Selector Switch - SRCH else TC'),                  category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeA2G, up = Keys.RadarModeTC,                                   name = _('Radar Mode Selector Switch - A/G else TC'),                   category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarMode,                                                             name = _('Radar Mode Selector Switch - SRCH, STBY, A/G (Cycle)'),       category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeCW,                                                           name = _('Radar Mode Selector Switch - Rotary CW'),                     category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeCCW,                                                          name = _('Radar Mode Selector Switch - Rotary CCW'),                    category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = 1,                                          name = _('Radar AoA Compensation Switch - ON'),                         category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = 0,                                          name = _('Radar AoA Compensation Switch - OFF'),                        category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = -1,                                         name = _('Radar AoA Compensation Switch - ON/OFF'),                     category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = 1, up = Keys.RadarAoAComp, value_up = 0,    name = _('Radar AoA Compensation Switch - ON else OFF'),                category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarVolume, value_down = 1,                                           name = _('Radar Obstacle Tone Volume Knob - Rotary Increment'),         category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarVolume, value_down = 0,                                           name = _('Radar Obstacle Tone Volume Knob - Rotary Decrement'),         category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarVolumeStartUp, up = Keys.RadarVolumeStop,                         name = _('Radar Obstacle Tone Volume Knob - Continuous Increase'),      category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarVolumeStartDown, up = Keys.RadarVolumeStop,                       name = _('Radar Obstacle Tone Volume Knob - Continuous Decrease'),      category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarTiltInc,                                                          name = _('Radar Antenna Tilt Knob - Rotary CW'),                        category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarTiltDec,                                                          name = _('Radar Antenna Tilt Knob - Rotary CCW'),                       category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarTiltStartUp, up = Keys.RadarTiltStop,                             name = _('Radar Antenna Tilt Knob - Continuous CW'),                    category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarTiltStartDown, up = Keys.RadarTiltStop,                           name = _('Radar Antenna Tilt Knob - Continuous CCW'),                   category = {_('Left Console'), _('Radar Control Panel')}},
    
    -- AFCS Panel
    {down = Keys.AFCSStandbyToggle,                                                             name = _('AFCS Standby Switch - OFF/STANDBY'),          category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_standby, value_down = 1, up = device_commands.afcs_standby, value_up = 0, cockpit_device_id = devices.AFCS, name = _('AFCS Standby Switch - STANDBY else OFF'), category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_standby, value_down = 1, cockpit_device_id = devices.AFCS,     name = _('AFCS Standby Switch - STANDBY'),              category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_standby, value_down = 0, cockpit_device_id = devices.AFCS,     name = _('AFCS Standby Switch - OFF'),                  category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSStabAugToggle,                                                             name = _('AFCS Yaw Damper - OFF/STAB AUG'),             category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_stab_aug, value_down = 1, up = device_commands.afcs_stab_aug, value_up = 0, cockpit_device_id = devices.AFCS, name = _('AFCS Yaw Damper - STAB AUG else OFF'), category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_stab_aug, value_down = 0, cockpit_device_id = devices.AFCS,    name = _('AFCS Yaw Damper - OFF'),                      category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_stab_aug, value_down = 1, cockpit_device_id = devices.AFCS,    name = _('AFCS Yaw Damper - STAB AUG'),                 category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSEngageToggle,                                                              name = _('AFCS Engage Switch - OFF/ENGAGE'),            category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_engage, value_down = 1, up = device_commands.afcs_engage, value_up = 0, cockpit_device_id = devices.AFCS, name = _('AFCS Engage Switch - ENGAGE else OFF'), category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_engage, value_down = 0, cockpit_device_id = devices.AFCS,      name = _('AFCS Engage Switch - OFF'),                   category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_engage, value_down = 1, cockpit_device_id = devices.AFCS,      name = _('AFCS Engage Switch - ENGAGE'),                category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSAltitudeToggle,                                                            name = _('AFCS Altitude Switch - OFF/ALT'),             category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_alt, value_down = 1, up = device_commands.afcs_alt, value_up = 0, cockpit_device_id = devices.AFCS, name = _('AFCS Altitude Switch - ALT else OFF'), category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_alt, value_down = 0, cockpit_device_id = devices.AFCS,         name = _('AFCS Altitude Switch - OFF'),                 category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_alt, value_down = 1, cockpit_device_id = devices.AFCS,         name = _('AFCS Altitude Switch - ALT'),                 category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSHeadingToggle,                                                             name = _('AFCS Heading Select Switch - OFF/HDG SEL'),   category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_sel, value_down = 1, up = device_commands.afcs_hdg_sel, value_up = 0, cockpit_device_id = devices.AFCS, name = _('AFCS Heading Select Switch - HDG SEL else OFF'), category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_sel, value_down = 0, cockpit_device_id = devices.AFCS,     name = _('AFCS Heading Select Switch - OFF'),           category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_sel, value_down = 1, cockpit_device_id = devices.AFCS,     name = _('AFCS Heading Select Switch - HDG SEL'),       category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_set, value_down = 1, cockpit_device_id = devices.AFCS,     name = _('AFCS SET Knob - CW/Increase'),                category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_set, value_down = -1, cockpit_device_id = devices.AFCS,    name = _('AFCS SET Knob - CCW/Decrease'),               category = {_('Left Console'), _('AFCS Panel')}},

    {down = Keys.AFCSHotasPath,                                                                 name = _('AFCS Path Mode'),                             category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSHotasAltHdg,                                                               name = _('AFCS Altitude + Heading Modes'),              category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSHotasAlt,                                                                  name = _('AFCS Altitude Mode'),                         category = {_('Left Console'), _('AFCS Panel'),}},

    -- Special commands for Warthog Throttle
    {down = Keys.AFCSHotasPath, up = Keys.AFCSHotasAltHdg,  name = _('AFCS Path Mode else Altitude+Heading (Warthog Throttle)'),     category = {_('Left Console'), _('AFCS Panel'), _('Special For Joystick')}},
    {down = Keys.AFCSHotasAlt, up = Keys.AFCSHotasAltHdg, name = _('AFCS Altitude Mode else Altitude+Heading (Warthog Throttle)'), category = {_('Left Console'), _('AFCS Panel'), _('Special For Joystick')}},
    {down = Keys.AFCSHotasEngage,                                                       name = _('AFCS Engage (Warthog Throttle)'),                              category = {_('Left Console'), _('AFCS Panel'), _('Special For Joystick')}},

    {down = Keys.AFCSHotasEngage,                                                               name = _('AFCS Engage (Warthog Throttle)'), category = {_('Left Console'), _('AFCS Panel'), _('Special for Joystick')}},

    -- Oxygen and Anti-G Panel
    {down = device_commands.oxygen_switch, value_down = 1, cockpit_device_id = devices.AVIONICS, name = _('Oxygen Switch - ON'), category = {_('Left Console'), _('Oxygen')}},
    {down = device_commands.oxygen_switch, value_down = 0, cockpit_device_id = devices.AVIONICS, name = _('Oxygen Switch - OFF'), category = {_('Left Console'), _('Oxygen')}},
    {down = Keys.OxygenToggle, name = _('Oxygen Switch - OFF/ON'), category = {_('Left Console'), _('Oxygen')}},

    -- Canopy Control
    {down = iCommandPlaneFonar,                                                         name = _('Canopy Open/Close'),                                   category = {_('Left Console')}},

    ---------------------------------------------
    -- Right Console ----------------------------
    ---------------------------------------------
    -- Doppler Radar Control Panel
    {down = device_commands.doppler_select, value_down = 0.0, cockpit_device_id = devices.NAV, name = _('Doppler Selector - OFF'),                         category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = device_commands.doppler_select, value_down = 0.1, cockpit_device_id = devices.NAV, name = _('Doppler Selector - STBY'),                        category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = device_commands.doppler_select, value_down = 0.2, cockpit_device_id = devices.NAV, name = _('Doppler Selector - LAND'),                        category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = device_commands.doppler_select, value_down = 0.3, cockpit_device_id = devices.NAV, name = _('Doppler Selector - SEA'),                         category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = device_commands.doppler_select, value_down = 0.4, cockpit_device_id = devices.NAV, name = _('Doppler Selector - TEST'),                        category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerCW, name = _('Doppler Selector Switch - CW'), category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerCCW, name = _('Doppler Selector Switch - CCW'), category = {_('Right Console'), _('Doppler Radar Control Panel')}},

    -- Navigation Control Panel
    {down = device_commands.ppos_lat_push, up = device_commands.ppos_lat_push, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Present Position Latitude Push-to-Set Knob - PUSH'),  category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.ppos_lon_push, up = device_commands.ppos_lon_push, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Present Position Longitude Push-to-Set Knob - PUSH'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.ppos_lat,                                       cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Present Position Latitude Push-to-Set Knob - CCW'),   category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.ppos_lat,                                       cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Present Position Latitude Push-to-Set Knob - CW'),    category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.ppos_lon,                                       cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Present Position Longitude Push-to-Set Knob - CCW'),  category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.ppos_lon,                                       cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Present Position Longitude Push-to-Set Knob - CW'),   category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = device_commands.dest_lat_push, up = device_commands.dest_lat_push, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Destination Latitude Push-to-Set Knob - PUSH'),       category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.dest_lon_push, up = device_commands.dest_lon_push, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Destination Longitude Push-to-Set Knob - PUSH'),      category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.dest_lat,                                       cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Destination Latitude Push-to-Set Knob - CCW'),        category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.dest_lat,                                       cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Destination Latitude Push-to-Set Knob - CW'),         category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.dest_lon,                                       cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Destination Longitude Push-to-Set Knob - CCW'),       category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.dest_lon,                                       cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Destination Longitude Push-to-Set Knob - CW'),        category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = device_commands.dest_lat_slew, up = device_commands.dest_lat_slew, cockpit_device_id = devices.NAV, value_down = -1, value_up = 0, name = _('Destination Latitude Slew Knob - CCW'),               category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.dest_lat_slew, up = device_commands.dest_lat_slew, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Destination Latitude Slew Knob - CW'),                category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.dest_lon_slew, up = device_commands.dest_lon_slew, cockpit_device_id = devices.NAV, value_down = -1, value_up = 0, name = _('Destination Longitude Slew Knob - CCW'),              category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.dest_lon_slew, up = device_commands.dest_lon_slew, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Destination Longitude Slew Knob - CW'),               category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = device_commands.asn41_magvar_push,    up = device_commands.asn41_magvar_push,    cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Magnetic Variation Push-to-Set Knob - PUSH'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.asn41_magvar,                                                 cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Magnetic Variation Push-to-Set Knob - CCW'),  category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.asn41_magvar,                                                 cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Magnetic Variation Push-to-Set Knob - CW'),   category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = device_commands.asn41_windspeed_push, up = device_commands.asn41_windspeed_push, cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Wind Speed Push-to-Set Knob - PUSH'),         category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.asn41_windspeed,                                              cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Wind Speed Push-to-Set Knob - CCW'),          category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.asn41_windspeed,                                              cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Wind Speed Push-to-Set Knob - CW'),           category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = device_commands.asn41_winddir_push,   up = device_commands.asn41_winddir_push,   cockpit_device_id = devices.NAV, value_down = 1,  value_up = 0, name = _('Wind Direction Push-to-Set Knob - PUSH'),     category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.asn41_winddir,                                                cockpit_device_id = devices.NAV, value_pressed = -0.015,        name = _('Wind Direction Push-to-Set Knob - CCW'),      category = {_('Right Console'), _('Navigation Control Panel')}},
    {pressed = device_commands.asn41_winddir,                                                cockpit_device_id = devices.NAV, value_pressed = 0.015,         name = _('Wind Direction Push-to-Set Knob - CW'),       category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = device_commands.nav_select, value_down = 0.0, cockpit_device_id = devices.NAV, name = _('Navigation Computer Selector - TEST'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.nav_select, value_down = 0.1, cockpit_device_id = devices.NAV, name = _('Navigation Computer Selector - OFF'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.nav_select, value_down = 0.2, cockpit_device_id = devices.NAV, name = _('Navigation Computer Selector - STBY'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.nav_select, value_down = 0.3, cockpit_device_id = devices.NAV, name = _('Navigation Computer Selector - D1'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = device_commands.nav_select, value_down = 0.4, cockpit_device_id = devices.NAV, name = _('Navigation Computer Selector - D2'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectCW, name = _('Navigation Computer Selector Switch - CW'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectCCW, name = _('Navigation Computer Selector Switch - CCW'), category = {_('Right Console'), _('Navigation Control Panel')}},

    -- ARN-52 TACAN Control Panel
    {down = Keys.NavReset,          name = _('Reset Both TCN & NDB Channels'),                              category = {_('Systems')}},
    --{down = Keys.NavILSPrev,        name = _('ILS Channel: Previous'),                                      category = {_('Systems')}},
    --{down = Keys.NavILSNext,        name = _('ILS Channel: Next'),                                          category = {_('Systems')}},
    {down = Keys.TacanModeInc,      name = _('TACAN Mode - CW'),                                            category = {_('Systems')}},
    {down = Keys.TacanModeDec,      name = _('TACAN Mode - CCW'),                                           category = {_('Systems')}},
    {down = Keys.TacanChMajorInc,   name = _('TACAN Channel 10s - Increase'),                               category = {_('Systems')}},
    {down = Keys.TacanChMajorDec,   name = _('TACAN Channel 10s - Decrease'),                               category = {_('Systems')}},
    {down = Keys.TacanChMinorInc,   name = _('TACAN Channel 1s - Increase'),                                category = {_('Systems')}},
    {down = Keys.TacanChMinorDec,   name = _('TACAN Channel 1s - Decrease'),                                category = {_('Systems')}},
    {down = Keys.TacanVolumeInc,    name = _('TACAN Volume - Rotary Increase'),                             category = {_('Systems')}},
    {down = Keys.TacanVolumeDec,    name = _('TACAN Volume - Rotary Decrease'),                             category = {_('Systems')}},
    {down = Keys.TacanVolumeStartUp, up = Keys.TacanVolumeStop, name = _('TACAN Volume - Continuous Increase'), category = {_('Systems')}},
    {down = Keys.TacanVolumeStartDown, up = Keys.TacanVolumeStop, name = _('TACAN Volume - Continuous Decrease'), category = {_('Systems')}},

    -- MCL
    {down = device_commands.mcl_power_switch, cockpit_device_id = devices.MCL, value_down = -1,  name = _('MCL (ILCS) Power - OFF'),  category = {_('Systems')}},
    {down = device_commands.mcl_power_switch, cockpit_device_id = devices.MCL, value_down = 0,  name = _('MCL (ILCS) Power - ON'),  category = {_('Systems')}},
    {down = device_commands.mcl_power_switch, up = device_commands.mcl_power_switch, cockpit_device_id = devices.MCL, value_down = 1, value_up = 0, name = _('MCL (ILCS) Power - BIT else ON'),  category = {_('Systems')}},
    {down = Keys.MCL_Power_Toggle, name = _('MCL (ILCS) Power - ON/OFF'), category = {_('Systems')}},
    {down = Keys.MCL_Chan_Inc, name = _('MCL (ILCS) Channel Selector - CW/Increase'), category = {_('Systems')}},
    {down = Keys.MCL_Chan_Dec, name = _('MCL (ILCS) Channel Selector - CCW/Decrease'), category = {_('Systems')}},

    -- Fuel Transfer Bypass Switch
    {down = device_commands.fuel_transfer_bypass, cockpit_device_id = devices.ENGINE, value_down = 0,  name = _('Fuel Transfer - NORMAL'),  category = {_('Systems')}},
    {down = device_commands.fuel_transfer_bypass, cockpit_device_id = devices.ENGINE, value_down = 1,  name = _('Fuel Transfer - BYPASS'),  category = {_('Systems')}},
    {down = device_commands.fuel_transfer_bypass, up = device_commands.fuel_transfer_bypass, cockpit_device_id = devices.ENGINE, value_down = 1, value_up = 0, name = _('Fuel Transfer - BYPASS else NORMAL'),  category = {_('Systems')}},
    {down = Keys.Fuel_Transfer_Bypass_Toggle, name = _('Fuel Transfer - NORMAL/BYPASS'), category = {_('Systems')}},

    -- Interior Lights Panel
    {down = device_commands.intlight_whiteflood_CHANGE,     cockpit_device_id = devices.AVIONICS,  value_down = 0.1,  name = _('White Floodlight Control Knob - CW/Increase'),  category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {down = device_commands.intlight_whiteflood_CHANGE,     cockpit_device_id = devices.AVIONICS,  value_down = -0.1, name = _('White Floodlight Control Knob - CCW/Decrease'), category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {down = device_commands.intlight_instruments_CHANGE,    cockpit_device_id = devices.AVIONICS,  value_down = 0.1,  name = _('INST Lights Control Knob - CW/Increase'),       category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {down = device_commands.intlight_instruments_CHANGE,    cockpit_device_id = devices.AVIONICS,  value_down = -0.1, name = _('INST Lights Control Knob - CCW/Decrease'),      category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {down = device_commands.intlight_console_CHANGE,        cockpit_device_id = devices.AVIONICS,  value_down = 0.1,  name = _('CONSOLES Lights Control Knob - CW/Increase'),   category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {down = device_commands.intlight_console_CHANGE,        cockpit_device_id = devices.AVIONICS,  value_down = -0.1, name = _('CONSOLES Lights Control Knob - CCW/Decrease'),  category = {_('Right Console'), _('Interior Lights Control Panel')}},

    -- Exterior Lights Panel
    {down = Keys.ExtLightProbe, value_down = 1,                                                        name = _('PROBE Light Switch - BRIGHT'),          category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightProbe, value_down = -1,                                                       name = _('PROBE Light Switch - DIM'),             category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightProbe, value_down = 0,                                                        name = _('PROBE Light Switch - OFF'),             category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightProbeCycle,                                                                   name = _('PROBE Light Switch - Cycle'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightProbe, value_down = 1, up = Keys.ExtLightProbe, value_up = 0,                 name = _('PROBE Light Switch - BRIGHT else OFF'), category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightProbe, value_down = -1, up = Keys.ExtLightProbe, value_up = 0,                name = _('PROBE Light Switch - DIM else OFF'),    category = {_('Right Console'), _('Exterior Lights Panel')}},

    {down = Keys.ExtLightTaxi, value_down = 1,                                                         name = _('TAXI Light Switch - ON'),               category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTaxi, value_down = 0,                                                         name = _('TAXI Light Switch - OFF'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTaxiToggle,                                                                   name = _('TAXI Light Switch - ON/OFF'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTaxi, value_down = 1, up = Keys.ExtLightTaxi, value_up = 0,                   name = _('TAXI Light Switch - ON else OFF'),      category = {_('Right Console'), _('Exterior Lights Panel')}},

    {down = Keys.ExtLightAnticollision, value_down = 1,                                                name = _('ANTI-COLLISION Light Switch - ON'),          category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightAnticollision, value_down = 0,                                                name = _('ANTI-COLLISION Light Switch - OFF'),         category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightAnticollisionToggle,                                                          name = _('ANTI-COLLISION Light Switch - ON/OFF'),      category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightAnticollision, value_down = 1, up = Keys.ExtLightAnticollision, value_up = 0, name = _('ANTI-COLLISION Light Switch - ON else OFF'), category = {_('Right Console'), _('Exterior Lights Panel')}},

    {down = Keys.ExtLightNav, value_down = 1,                                                          name = _('WING Light Switch - BRIGHT'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = -1,                                                         name = _('WING Light Switch - DIM'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = 0,                                                          name = _('WING Light Switch - OFF'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNavCycle,                                                                     name = _('WING Light Switch - Cycle'),            category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = 1, up = Keys.ExtLightNav, value_up = 0,                     name = _('WING Light Switch - BRIGHT else OFF'),  category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = -1, up = Keys.ExtLightNav, value_up = 0,                    name = _('WING Light Switch - DIM else OFF'),     category = {_('Right Console'), _('Exterior Lights Panel')}},

    {down = Keys.ExtLightTail, value_down = 1,                                                         name = _('TAIL Light Switch - BRIGHT'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = -1,                                                        name = _('TAIL Light Switch - DIM'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = 0,                                                         name = _('TAIL Light Switch - OFF'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTailCycle,                                                                    name = _('TAIL Light Switch - Cycle'),            category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = 1, up = Keys.ExtLightTail, value_up = 0,                   name = _('TAIL Light Switch - BRIGHT else OFF'),  category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = -1, up = Keys.ExtLightTail, value_up = 0,                  name = _('TAIL Light Switch - DIM else OFF'),     category = {_('Right Console'), _('Exterior Lights Panel')}},

    {down = Keys.ExtLightFuselage, value_down = 1,                                                     name = _('FUS Light Switch - BRIGHT'),            category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = -1,                                                    name = _('FUS Light Switch - DIM'),               category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = 0,                                                     name = _('FUS Light Switch - OFF'),               category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselageCycle,                                                                name = _('FUS Light Switch - Cycle'),             category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = 1, up = Keys.ExtLightFuselage, value_up = 0,           name = _('FUS Light Switch - BRIGHT else OFF'),   category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = -1, up = Keys.ExtLightFuselage, value_up = 0,          name = _('FUS Light Switch - DIM else OFF'),      category = {_('Right Console'), _('Exterior Lights Panel')}},

    {down = Keys.ExtLightFlashSteady, value_down = 1,                                                  name = _('FLASH-STEADY Switch - FLSH'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFlashSteady, value_down = 0,                                                  name = _('FLASH-STEADY Switch - STDY'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFlashSteadyToggle,                                                            name = _('FLASH-STEADY Switch - FLSH/STDY'),      category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFlashSteady, value_down = 1, up = Keys.ExtLightFlashSteady, value_up = 0,     name = _('FLASH-STEADY Switch - FLSH else STDY'), category = {_('Right Console'), _('Exterior Lights Panel')}},

    ---------------------------------------------
    -- Communitcations -------------------------
    --------------------------------------------- 
    {down = iCommandPilotGestureSalute, name = _('Pilot Salute'),       category = {_('Communications')}},
    {down = iCommandPlaneShipTakeOff,   name = _('Catapult Hook-Up'),   category = {_('Communications')}},
    {down = Keys.ToggleSlatsLock,       name = _('Lock/Unlock Slats (Ground Only)'),  category = {_('Communications')}},
    
    -- Weapon/CMDS Adjustment
    {down = Keys.ChangeCBU2AQuantity,    value_down = 1, name = _('ALE-29A set CBU-2/A Release Quantity - 1/2/3'),            category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCBU2BAQuantity,   value_down = 1, name = _('ALE-29A set CBU-2B/A Release Quantity - 1/2/3/4/6/SALVO'), category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCmsBursts,        value_down = 1, name = _('ALE-29A set Countermeasures Bursts'),                      category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCmsBurstInterval, value_down = 1, name = _('ALE-29A set Countermeasures Burst Interval'),              category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCmsSalvos,        value_down = 1, name = _('ALE-29A set Countermeasures Salvos'),                      category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeSalvoInterval,    value_down = 1, name = _('ALE-29A set Countermeasures Salvo Interval'),              category = {_('Kneeboard'), _('ALE-29A Programmer')}},

    --NightVision
    {down = iCommandViewNightVisionGogglesOn, name = _('NVG Night Vision Goggle - Toggle'), category = {_('Sensors')}},
    {down = iCommandPlane_Helmet_Brightess_Up, name = _('NVG Night Vision Goggle Gain - Increase'), category = {_('Sensors')}},
    {down = iCommandPlane_Helmet_Brightess_Down, name = _('NVG Night Vision Goggle Gain - Decrease'), category = {_('Sensors')}},
    
	-- Radio
	{down = Keys.radio_ptt, name = _('ARC-51 Push to Talk (PTT)'), category = {_('Radio')}},
    {down = Keys.UHF10MHzInc, name = _('ARC-51 UHF Frequency 10 MHz - Increase'), category = _('Radio')},
    {down = Keys.UHF10MHzDec, name = _('ARC-51 UHF Frequency 10 MHz - Decrease'), category = {_('Radio')}},    
    {down = Keys.UHF1MHzInc, name = _('ARC-51 UHF Frequency 1 MHz - Increase'), category = {_('Radio')}},
    {down = Keys.UHF1MHzDec, name = _('ARC-51 UHF Frequency 1 MHz - Decrease'), category = {_('Radio')}}, 
    {down = Keys.UHF50kHzInc, name = _('ARC-51 UHF Frequency 50 kHz - Increase'), category = {_('Radio')}},
    {down = Keys.UHF50kHzDec, name = _('ARC-51 UHF Frequency 50 kHz - Decrease'), category = {_('Radio')}}, 
    {down = Keys.UHFPresetChannelInc, name = _('ARC-51 UHF Preset Channel - Increase'), category = {_('Radio')}},
    {down = Keys.UHFPresetChannelDec, name = _('ARC-51 UHF Preset Channel - Decrease'), category = {_('Radio')}},    
    {down = Keys.UHFFreqModeInc, name = _('ARC-51 UHF Frequency Mode Switch - CW'), category = {_('Radio')}},
    {down = Keys.UHFFreqModeDec, name = _('ARC-51 UHF Frequency Mode Switch - CCW'), category = {_('Radio')}},    
    {down = device_commands.arc51_xmitmode, value_down = 1, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Frequency Mode - PRESET CHAN'), category = {_('Radio')}},    
    {down = device_commands.arc51_xmitmode, value_down = 0, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Frequency Mode - MANUAL'), category = {_('Radio')}},    
    {down = device_commands.arc51_xmitmode, value_down = -1, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Frequency Mode - GD XMIT'), category = {_('Radio')}},    
    {down = Keys.UHFModeInc, name = _('ARC-51 UHF Mode Switch - CW'), category = {_('Radio')}},
    {down = Keys.UHFModeDec, name = _('ARC-51 UHF Mode Switch - CCW'), category = {_('Radio')}},    
    {down = device_commands.arc51_mode, value_down = 0.0, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Mode - OFF'), category = {_('Radio')}},   
    {down = device_commands.arc51_mode, value_down = 0.1, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Mode - T/R'), category = {_('Radio')}},   
    {down = device_commands.arc51_mode, value_down = 0.2, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Mode - T/R + G'), category = {_('Radio')}},   
    {down = device_commands.arc51_mode, value_down = 0.3, cockpit_device_id = devices.RADIO, name = _('ARC-51 UHF Mode - ADF'), category = {_('Radio')}},   
    {down = Keys.UHFVolumeInc, name = _('ARC-51 UHF Volume - Rotary Increment'), category = {_('Radio')}},
    {down = Keys.UHFVolumeDec, name = _('ARC-51 UHF Volume - Rotary Decrement'), category = {_('Radio')}},    
    {down = Keys.UHFVolumeStartUp, up = Keys.UHFVolumeStop, name = _('ARC-51 UHF Volume - Continuous Increase'), category = {_('Radio')}},
    {down = Keys.UHFVolumeStartDown, up = Keys.UHFVolumeStop, name = _('ARC-51 UHF Volume - Continuous Decrease'), category = {_('Radio')}},    

    -- PID tuning
    {down = Keys.Tune1, value_down = 0.1,          name = _('Tune1: +0.1'),                  category = {_('Debug')}},
    {down = Keys.Tune1, value_down = -0.1,         name = _('Tune1: -0.1'),                  category = {_('Debug')}},
    {down = Keys.Tune2, value_down = 0.1,          name = _('Tune2: +0.1'),                  category = {_('Debug')}},
    {down = Keys.Tune2, value_down = -0.1,         name = _('Tune2: -0.1'),                  category = {_('Debug')}},
    {down = Keys.Tune3, value_down = 0.1,          name = _('Tune3: +0.1'),                  category = {_('Debug')}},
    {down = Keys.Tune3, value_down = -0.1,         name = _('Tune3: -0.1'),                  category = {_('Debug')}},
    
    -- FC3 Commands [Implemented] (TODO: What should be implmented here?)
    -- {down = Keys.JettisonFC3,up = Keys.JettisonWeaponsUp, name = _('Jettison Stores (3 times)'), category = {_('Systems')}},
    -- {down = Keys.RadarHoldToggle,                         name = _('Radar Hold: Toggle'),          category = _('Modes')},
    -- {down = Keys.RadarHoldDec,                            name = _('Radar Hold: Dec'),             category = _('Modes')},
    -- {down = Keys.RadarHoldInc,                            name = _('Radar Hold: Inc'),             category = _('Modes')},
    -- {down = Keys.SpeedHoldToggle,                         name = _('Speed Hold: Toggle'),          category = _('Modes')},
    -- {down = Keys.SpeedHoldDec,                            name = _('Speed Hold: Dec'),             category = _('Modes')},
    -- {down = Keys.SpeedHoldInc,                            name = _('Speed Hold: Inc'),             category = _('Modes')},

    -- FC3 Commands [Not Implemented]
    -- {down = iCommandPowerOnOff,                                                                                  name = _('Electric Power Switch'),                  category = {_('Systems')}},
    -- {down = iCommandPlaneCockpitIllumination,                                                                    name = _('Illumination Cockpit'),                   category = {_('Systems')}},
    -- {down = iCommandPlaneLightsOnOff,                                                                            name = _('Navigation lights'),                      category = {_('Systems')}},
    -- {down = iCommandPlaneHeadLightOnOff,                                                                         name = _('Gear Light Near/Far/Off'),                category = {_('Systems')}},
    -- {down = iCommandPlaneResetMasterWarning,                                                                     name = _('Audible Warning Reset'),                  category = {_('Systems')}},
    -- {down = iCommandFlightClockReset,                                                                            name = _('Flight Clock Start/Stop/Reset'),          category = {_('Systems')}},
    -- {down = iCommandClockElapsedTimeReset,                                                                       name = _('Elapsed Time Clock Start/Stop/Reset'),    category = {_('Systems')}},
    -- {down = iCommandBrightnessILS,                                                                               name = _('HUD Color'),                              category = {_('Systems')}},
    -- {pressed = iCommandHUDBrightnessUp,                                                                          name = _('HUD Brightness up'),                      category = {_('Systems')}},
    -- {pressed = iCommandHUDBrightnessDown,                                                                        name = _('HUD Brightness down'),                    category = {_('Systems')}},
    -- {down = iCommandPlaneDropSnar,                                                                               name = _('Countermeasures: Continuously Dispense'), category = _('Countermeasures')},
    -- {down = iCommandPlaneDropFlareOnce,                                                                          name = _('Countermeasures Flares Dispense'),        category = _('Countermeasures')},
    -- {down = iCommandPlaneDropChaffOnce,                                                                          name = _('Countermeasures Chaff Dispense'),         category = _('Countermeasures')},
    -- {down = iCommandActiveJamming,                                                                               name = _('Countermeasures: ECM'),                   category = _('Countermeasures')},
    -- {down = iCommandPlaneAutopilot,                                                                              name = _('Autopilot - Attitude Hold'),              category = 'Autopilot'},
    -- {down = iCommandPlaneStabHbar,                                                                               name = _('Autopilot - Altitude Hold'),              category = 'Autopilot'},
    -- {down = iCommandPlaneStabCancel,                                                                             name = _('Autopilot Disengage'),                    category = 'Autopilot'},
    -- {down = iCommandPlaneTrimOn, up = iCommandPlaneTrimOff,                                                      name = _('T/O Trim'),                               category = 'Flight Control'},
    -- {down = iCommandPlaneAirRefuel,                                                                              name = _('Refueling Boom'),                         category = 'Systems'},
    -- {down = iCommandPlaneJettisonFuelTanks,                                                                      name = _('Jettison Fuel Tanks'),                    category = 'Systems'},
    -- {down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton,       name = _('Nose Gear Maneuvering Range'),            category = 'Systems'},
    -- {down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, name = _('Nose Gear Steering Disengage'),           category = 'Systems'},
})

-- joystick axes 
join(res.axisCommands,{

    {combos = defaultDeviceAssignmentFor("roll"),   action = iCommandPlaneRoll,         name = _('Roll'),              category = {_('Flight Control')}},
    {combos = defaultDeviceAssignmentFor("pitch"),  action = iCommandPlanePitch,        name = _('Pitch'),             category = {_('Flight Control')}},
	{combos = defaultDeviceAssignmentFor("rudder"), action = iCommandPlaneRudder,		name = _('Rudder'),            category = {_('Flight Control')}},
	{combos = defaultDeviceAssignmentFor("thrust"), action = iCommandPlaneThrustCommon, name = _('Thrust'),            category = {_('Flight Control')}},
    {action = device_commands.wheelbrake_AXIS,                                          name = _('Wheel Brake'),       category = {_('Systems')}},
    {action = device_commands.left_wheelbrake_AXIS,                                     name = _('Wheel Brake Left'),  category = {_('Systems')}},
    {action = device_commands.right_wheelbrake_AXIS,                                    name = _('Wheel Brake Right'), category = {_('Systems')}},
    

    {combos = {{key = 'TRACKIR_PITCH'}},	action = iHeadTrackerPitchNormed,           name = _('Head Tracker : Pitch')},
    {combos = {{key = 'TRACKIR_YAW'}},  	action = iHeadTrackerYawNormed,             name = _('Head Tracker : Yaw')},
    {combos = {{key = 'TRACKIR_ROLL'}}, 	action = iHeadTrackerRollNormed,            name = _('Head Tracker : Roll')},
    
    {combos = {{key = 'TRACKIR_X'}}, 		action = iHeadTrackerPosZNormed,            name = _('Head Tracker : Right/Left')},
    {combos = {{key = 'TRACKIR_Y'}}, 		action = iHeadTrackerPosYNormed,            name = _('Head Tracker : Up/Down')},
    {combos = {{key = 'TRACKIR_Z'}}, 		action = iHeadTrackerPosXNormed,            name = _('Head Tracker : Forward/Backward')},
    
	--Old throttle
    --{combos = defaultDeviceAssignmentFor("rudder"),  action = iCommandPlaneRudder	   , name = _('Rudder')},
	--{combos = defaultDeviceAssignmentFor("thrust"),  action = iCommandPlaneThrustCommon, name = _('Thrust')},
	--Needed for the new Carrier script, should replace the Real throttle later
    
    ---------------------------------------------
    -- ECM Control Panel ------------------------
    --------------------------------------------- 
    {action = device_commands.ecm_msl_alert_axis_inner,     cockpit_device_id = devices.RWR,            name = _('ECM - PRF volume (inner knob)'),        category = {_('ECM Control Panel')}},
    {action = device_commands.ecm_msl_alert_axis_outer,     cockpit_device_id = devices.RWR,            name = _('ECM - MSL volume (outer knob)'),        category = {_('ECM Control Panel')}},
    
    -- Misc Switches Panel
    {action = device_commands.shrike_sidewinder_volume,     cockpit_device_id = devices.WEAPON_SYSTEM,  name = _('Missile Volume Knob'),            category = {_('Instrument Panel'), _('Misc Switches Panel')}},

    -- Radar Control Panel
    {action = device_commands.radar_angle_axis,             cockpit_device_id = devices.RADAR,          name = _('Radar Antenna Tilt - Slew'),      category = {_('Left Console'), _('Radar Control Panel')}},
    {action = device_commands.radar_angle_axis_abs,         cockpit_device_id = devices.RADAR,          name = _('Radar Antenna Tilt - Absolute'),  category = {_('Left Console'), _('Radar Control Panel')}},

    -- Interior Lights Panel
    {action = device_commands.intlight_instruments_AXIS,    cockpit_device_id = devices.AVIONICS,       name = _('Lighting - Instrument'),           category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {action = device_commands.intlight_console_AXIS,        cockpit_device_id = devices.AVIONICS,       name = _('Lighting - Console'),              category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {action = device_commands.intlight_whiteflood_AXIS,     cockpit_device_id = devices.AVIONICS,       name = _('Lighting - White Flood'),          category = {_('Right Console'), _('Interior Lights Control Panel')}},

    -- Aircraft Weapons Release System Panel
    {action = device_commands.AWRS_drop_interval_AXIS,      cockpit_device_id = devices.WEAPON_SYSTEM,  name = _('AWE-1 DROP INTVL - Control'),             category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    
    --{action = iCommandWheelBrake,		name = _('Wheel Brake')},

    {action = device_commands.GunsightBrightness,              cockpit_device_id = devices.GUNSIGHT,    name = _('Gunsight Brightness Control'),    category = {_('Instrument Panel'), _('Gunsight Panel')}},
    {action = device_commands.GunsightElevationControl_AXIS,   cockpit_device_id = devices.GUNSIGHT,    name = _('Gunsight Elevation Control'),     category = {_('Instrument Panel'), _('Gunsight Panel')}},

})
return res