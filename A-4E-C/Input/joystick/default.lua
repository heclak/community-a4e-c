local cscripts = folder.."../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands,{

    {down = iCommandChat,                                                            name = _('Multiplayer chat - mode All'),      category = _('General')},
    {down = iCommandFriendlyChat,                                                    name = _('Multiplayer chat - mode Allies'),   category = _('General')},
    {down = iCommandAllChat,                                                         name = _('Chat read/write All'),              category = _('General')},
    {down = iCommandChatShowHide,                                                    name = _('Chat show/hide'),                   category = _('General')},

    ---------------------------------------------
    -- General ----------------------------------
    ---------------------------------------------
    {down = iCommandPlaneShipTakeOff,                                                name = _('Ship Take Off Position'),           category = {_('General')}},
    -- {down = iCommandCockpitShowPilotOnOff,                                        name = _('Show Pilot Body'),                  category = _('General')},
    {down = iCommandPlaneWingtipSmokeOnOff,                                          name = _('Smoke - ON/OFF'), category = {_('General')}},

    ---------------------------------------------
    -- View Cockpit -----------------------------
    ---------------------------------------------
    {down = iCommandViewLeftMirrorOn, up = iCommandViewLeftMirrorOff ,               name = _('Mirror Left On'),                   category = {_('View Cockpit')}},
    {down = iCommandViewRightMirrorOn, up = iCommandViewRightMirrorOff,              name = _('Mirror Right On'),                  category = {_('View Cockpit')}},
    {down = iCommandToggleMirrors,                                                   name = _('Toggle Mirrors'),                   category = {_('View Cockpit')}},

    ---------------------------------------------
    -- Systems ----------------------------------
    ---------------------------------------------
    {down = iCommandPlaneEject,                                                     name = _('Eject (3 times)'),                  category = {_('Systems')}},
    {down = Keys.BrakesOn, up = Keys.BrakesOff,                                      name = _('Wheel Brake - ON/OFF'),             category = {_('Systems')}},
	{down = Keys.BrakesOnLeft, up = Keys.BrakesOffLeft,							 		  name = _('Wheel Brake Left - ON/OFF'), 		category = {_('Systems')}},
	{down = Keys.BrakesOnRight, up = Keys.BrakesOffRight,						 		  name = _('Wheel Brake Right - ON/OFF'), 		category = {_('Systems')}},

    ---------------------------------------------
    -- Flight Control ---------------------------
    --------------------------------------------- 
    {down = iCommandPlaneUpStart, up = iCommandPlaneUpStop,                          name = _('Aircraft Pitch Down'),              category = {_('Flight Control')}},
    {down = iCommandPlaneDownStart, up = iCommandPlaneDownStop,                      name = _('Aircraft Pitch Up'),                category = {_('Flight Control')}},
    {down = iCommandPlaneLeftStart, up = iCommandPlaneLeftStop,                      name = _('Aircraft Bank Left'),               category = {_('Flight Control')}},
    {down = iCommandPlaneRightStart, up = iCommandPlaneRightStop,                    name = _('Aircraft Bank Right'),              category = {_('Flight Control')}},
    {down = iCommandPlaneLeftRudderStart, up = iCommandPlaneLeftRudderStop,          name = _('Aircraft Rudder Left'),             category = {_('Flight Control')}},
    {down = iCommandPlaneRightRudderStart, up = iCommandPlaneRightRudderStop,        name = _('Aircraft Rudder Right'),            category = {_('Flight Control')}},

    ---------------------------------------------
    -- Stick ------------------------------------
    ---------------------------------------------
    {pressed = Keys.TrimUp, up = Keys.TrimStop,                                      name = _('Trimmer Switch - NOSE UP'),         category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimDown, up = Keys.TrimStop,                                    name = _('Trimmer Switch - NOSE DOWN'),       category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimLeft, up = Keys.TrimStop,                                    name = _('Trimmer Switch - LEFT WING DOWN'),  category = {_('Stick'), _('Flight Control')}},
    {pressed = Keys.TrimRight, up = Keys.TrimStop,                                   name = _('Trimmer Switch - RIGHT WING DOWN'), category = {_('Stick'), _('Flight Control')}},
    
    {down = Keys.TrimCancel,                                                         name = _('Trim: Reset'),                      category = {_('Stick'), _('Flight Control')}},
    {combos = {{key = 'JOY_BTN1'}}, down = Keys.PlaneFireOn, up = Keys.PlaneFireOff, name = _('Gun-Rocket Trigger'),               category = {_('Stick')}},
    {combos = {{key = 'JOY_BTN2'}}, down = Keys.PickleOn, up = Keys.PickleOff,       name = _('Bomb Release Button'),              category = {_('Stick')}},
    {down = Keys.AFCSOverride,                                                       name = _('AFCS Override Button'),             category = {_('Stick')}},

    {down = Keys.ToggleStick,                                                        name = _('Control Stick - HIDE/SHOW'),        category = {_('Stick')}},

    {down = Keys.nws_engage, up = Keys.nws_disengage,          name = _('Nose Wheel Steering'),              category = {_('Stick')}},

    ---------------------------------------------
    -- Throttle Quadrant ------------------------
    ---------------------------------------------
    {pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,                                   name = _('Throttle Smoothly - Increase'),                          category = {_('Throttle Quadrant'), _('Flight Control')}},
    {pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,                                   name = _('Throttle Smoothly - Decrease'),                          category = {_('Throttle Quadrant'), _('Flight Control')}},
    {down = iCommandPlaneAUTIncreaseRegime,                                                           name = _('Throttle Step - Increase'),                              category = {_('Throttle Quadrant'), _('Flight Control')}},
    {down = iCommandPlaneAUTDecreaseRegime,                                                           name = _('Throttle Step - Decrease'),                              category = {_('Throttle Quadrant'), _('Flight Control')}},

    {down = device_commands.throttle_click_ITER, value_down = 1, cockpit_device_id = devices.ENGINE,  name = _('Throttle OFF/IGN/IDLE - Step Up'),                       category = {_('Throttle Quadrant')}},
    {down = device_commands.throttle_click_ITER, value_down = -1, cockpit_device_id = devices.ENGINE, name = _('Throttle OFF/IGN/IDLE - Step Down'),                     category = {_('Throttle Quadrant')}},

    {down = Keys.ExtLightMaster, value_down = 1,                                                      name = _('Master Exterior Lights Switch - ON'),                    category = {_('Throttle Grip')}},
    {down = Keys.ExtLightMaster, value_down = 0,                                                      name = _('Master Exterior Lights Switch - OFF'),                   category = {_('Throttle Grip')}},
    {down = Keys.ExtLightMasterToggle,                                                                name = _('Master Exterior Lights Switch - ON/OFF'),                category = {_('Throttle Grip')}},
    {down = Keys.ExtLightMaster, value_down = 1, up = Keys.ExtLightMaster, value_up = 0,              name = _('Master Exterior Lights Switch - ON else OFF'),           category = {_('Throttle Grip'), _('Special For Joystick')}},
    {down = Keys.ExtLightMaster, value_down = -1, up = Keys.ExtLightMaster, value_up = 0,             name = _('Master Exterior Lights Switch - MOMENTARY ON else OFF'), category = {_('Throttle Grip'), _('Special For Joystick')}},
    {down = iCommandPlaneAirBrake,                                                                    name = _('Speedbrake Switch - OPEN/CLOSE'),                        category = {_('Throttle Grip')}},
    {down = iCommandPlaneAirBrakeOn,                                                                  name = _('Speedbrake Switch - OPEN'),                              category = {_('Throttle Grip')}},
    {down = iCommandPlaneAirBrakeOff,                                                                 name = _('Speedbrake Switch - CLOSE'),                             category = {_('Throttle Grip')}},

    {pressed = Keys.TrimLeftRudder, up = Keys.TrimStop,                                               name = _('Rudder Trim Switch - Rudder Left'),                      category = {_('Throttle Quadrant'), _('Flight Control')}},
    {pressed = Keys.TrimRightRudder, up = Keys.TrimStop,                                              name = _('Rudder Trim Switch - Rudder Right'),                     category = {_('Throttle Quadrant'), _('Flight Control')}},

    -- Flap Switch
    {down = iCommandPlaneFlaps,                                                                       name = _('FLAP Switch - UP/DOWN'),                                 category = {_('Throttle Quadrant')}},
    {down = iCommandPlaneFlapsOn,                                                                     name = _('FLAP Switch - DOWN'),                                    category = {_('Throttle Quadrant')}},
    {down = iCommandPlaneFlapsOff,                                                                    name = _('FLAP Switch - UP'),                                      category = {_('Throttle Quadrant')}},
    {down = Keys.PlaneFlapsStop,                                                                      name = _('FLAP Switch - STOP'),                                    category = {_('Throttle Quadrant')}},
    {down = Keys.PlaneFlapsDownHotas, up = Keys.PlaneFlapsStop,                                       name = _('FLAP Switch - DOWN else STOP'),                          category = {_('Throttle Quadrant'), _('Special For Joystick')}}, -- for Warthog/HOTAS Flaps lever - realistic
    {down = Keys.PlaneFlapsUpHotas, up = Keys.PlaneFlapsStop,                                         name = _('FLAP Switch - UP else STOP'),                            category = {_('Throttle Quadrant'), _('Special For Joystick')}},  -- for Warthog/HOTAS Flaps lever - realistic

    ---------------------------------------------
    -- ALE-29A Chaff Control Panel --------------
    --------------------------------------------- 
    {down = Keys.CmBankSelectRotate,                                                                                                            name = _('ALE-29A Dispenser Select Cycle'),                        category = {_('Chaff Control Panel')}},
    {down = Keys.CmBankSelect, value_down = -1,                                                                                                 name = _('ALE-29A Dispenser Select - 1'),                          category = {_('Chaff Control Panel')}},
    {down = Keys.CmBankSelect, value_down = 1,                                                                                                  name = _('ALE-29A Dispenser Select - 2'),                          category = {_('Chaff Control Panel')}},
    {down = Keys.CmBankSelect, value_down = 0,                                                                                                  name = _('ALE-29A Dispenser Select - Both'),                       category = {_('Chaff Control Panel')}},
    {down = device_commands.cm_auto, up = device_commands.cm_auto, cockpit_device_id = devices.COUNTERMEASURES, value_down = 1.0, value_up = 0, name = _('ALE-29A AUTO Pushbutton'),                               category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank1AdjUp,                                                                                                                  name = _('ALE-29A Dispenser 1 Counter - Increase'),                category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank1AdjDown,                                                                                                                name = _('ALE-29A Dispenser 1 Counter - Decrease'),                category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank2AdjUp,                                                                                                                  name = _('ALE-29A Dispenser 2 Counter - Increase'),                category = {_('Chaff Control Panel')}},
    {down = Keys.CmBank2AdjDown,                                                                                                                name = _('ALE-29A Dispenser 2 Counter - Decrease'),                category = {_('Chaff Control Panel')}},
    {down = Keys.CmPowerToggle,                                                                                                                 name = _('ALE-29A PWR Switch - PWR/OFF'),                          category = {_('Chaff Control Panel')}},

    ---------------------------------------------
    -- ECM Control Panel ------------------------
    ---------------------------------------------
    {down = Keys.ecm_apr25_off, value_down = 1.0,value_up = 0.0, name = _('APR-25 Power Switch - ON/OFF'),       category = {_('ECM Control Panel')}},

    ---------------------------------------------
    -- Instrument Panel -------------------------
    ---------------------------------------------
    -- Gunsight Panel(TODO)

    -- Altimeter
    {down = Keys.AltPressureInc,                             name = _('Altimeter Pressure - Increase'),      category = {_('Instrument Panel')}},
    {down = Keys.AltPressureDec,                             name = _('Altimeter Pressure - Decrease'),      category = {_('Instrument Panel')}},

    -- Radar Altimeter
    {down = Keys.RadarAltWarningUp,                          name = _('Radar Altitude Warning - Raise'),     category = {_('Instrument Panel')}},
    {down = Keys.RadarAltWarningDown,                        name = _('Radar Altitude Warning - Lower'),     category = {_('Instrument Panel')}},

    -- Landing Gear Handle
    {down = iCommandPlaneGear,                               name = _('Landing Gear Handle - UP/DOWN'),      category = {_('Instrument Panel')}},
    {down = iCommandPlaneGearUp,                             name = _('Landing Gear Handle - UP'),           category = {_('Instrument Panel')}},
    {down = iCommandPlaneGearDown,                           name = _('Landing Gear Handle - DOWN'),         category = {_('Instrument Panel')}},
    {down = iCommandPlaneGearUp, up = iCommandPlaneGearDown, name = _('Landing Gear Handle - UP else DOWN'), category = {_('Instrument Panel'), _('Special For Joystick')}}, -- for Warthog/HOTAS Toggle

    -- Arresting Hook Handle
    {down = device_commands.Hook, value_down = 1.0,                              name = _('Tail Hook Handle - UP/DOWN'),         category = {_('Instrument Panel')}},
    --{down = Keys.PlaneHookUp,                              name = _('Tail Hook Up'),                       category = 'Systems'},
    --{down = Keys.PlaneHookDown,                            name = _('Tail Hook Down'),                     category = 'Systems'},
    --{down = Keys.PlaneHookDown, up = Keys.PlaneHookUp,     name = _('Tail Hook DOWN else UP'),             category = 'HOTAS'},
    --{down = Keys.PlaneHookUp, up = Keys.PlaneHookDown,     name = _('Tail Hook UP else DOWN'),             category = 'HOTAS'},

    -- Misc Switches Panel
    {down = Keys.RadarTCPlanProfile, value_down = 1,                                                                                           name = _('Radar Terrain Clearance - PLAN'),               category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarTCPlanProfile, value_down = 0,                                                                                           name = _('Radar Terrain Clearance - PROFILE'),            category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarTCPlanProfile, value_down = -1,                                                                                          name = _('Radar Terrain Clearance - PLAN/PROFILE'),       category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = 1,                                                                                          name = _('Radar Range - LONG'),                           category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = 0,                                                                                          name = _('Radar Range - SHORT'),                          category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = -1,                                                                                         name = _('Radar Range - LONG/SHORT'),                     category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.RadarRangeLongShort, value_down = 1, up = Keys.RadarRangeLongShort, value_up = 0,                                             name = _('Radar Range - LONG else SHORT'),                category = {_('Instrument Panel'), _('Misc Switches Panel'), _('Special For Joystick')}},
    {down = Keys.RadarTCPlanProfile, value_down = 1, up = Keys.RadarTCPlanProfile, value_up = 0,                                               name = _('Radar Terrain Clearance - PLAN else PROFILE'),  category = {_('Instrument Panel'), _('Misc Switches Panel'), _('Special For Joystick')}},
    
    {down = device_commands.bdhi_mode, value_down = -1, up = device_commands.bdhi_mode, value_up = 0, cockpit_device_id = devices.NAV,         name = _('BDHI Switch - NAV PAC else TACAN'),             category = {_('Instrument Panel'), _('Misc Switches Panel'), _('Special For Joystick')}},
    {down = device_commands.bdhi_mode, value_down = 1, up = device_commands.bdhi_mode, value_up = 0, cockpit_device_id = devices.NAV,          name = _('BDHI Switch - NAV CMPTR else TACAN'),           category = {_('Instrument Panel'), _('Misc Switches Panel'), _('Special For Joystick')}},
    {down = device_commands.bdhi_mode, value_down = 1, cockpit_device_id = devices.NAV,                                                        name = _('BDHI Switch - NAV CMPTR'),                      category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = device_commands.bdhi_mode, value_down = 0, cockpit_device_id = devices.NAV,                                                        name = _('BDHI Switch - TACAN'),                          category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = device_commands.bdhi_mode, value_down = -1, cockpit_device_id = devices.NAV,                                                       name = _('BDHI Switch - NAV PAC'),                        category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    
    {down = Keys.FuelGaugeExt,                                                                                                                 name = _('Internal-External Fuel Switch - EXT'),          category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.FuelGaugeInt,                                                                                                                 name = _('Internal-External Fuel Switch - INT'),          category = {_('Instrument Panel'), _('Misc Switches Panel')}},
    {down = Keys.FuelGaugeExt, up = Keys.FuelGaugeInt,                                                                                         name = _('Internal-External Fuel Switch - EXT else INT'), category = {_('Instrument Panel'), _('Misc Switches Panel'), _('Special For Joystick')}},
    
    -- Armament Panel
    {down = device_commands.arm_bomb, value_down = 1, cockpit_device_id = devices.WEAPON_SYSTEM,                                               name = _('BOMB ARM - NOSE & TAIL'),                       category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = 0, cockpit_device_id = devices.WEAPON_SYSTEM,                                               name = _('BOMB ARM - OFF'),                               category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = -1, cockpit_device_id = devices.WEAPON_SYSTEM,                                              name = _('BOMB ARM - TAIL'),                              category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = device_commands.arm_bomb, value_down = -1, up = device_commands.arm_bomb, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('BOMB ARM - TAIL else OFF'),                     category = {_('Instrument Panel'), _('Armament Panel'), _('Special For Joystick')}},
    {down = device_commands.arm_bomb, value_down = 1, up = device_commands.arm_bomb, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM,  name = _('BOMB ARM - NOSE & TAIL else OFF'),              category = {_('Instrument Panel'), _('Armament Panel'), _('Special For Joystick')}},
    
    {down = Keys.Station1,                                                                                                                     name = _('Station 1 Selector Switch - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station2,                                                                                                                     name = _('Station 2 Selector Switch - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station3,                                                                                                                     name = _('Station 3 Selector Switch - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station4,                                                                                                                     name = _('Station 4 Selector Switch - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},
    {down = Keys.Station5,                                                                                                                     name = _('Station 5 Selector Switch - OFF/READY'),        category = {_('Instrument Panel'), _('Armament Panel')}},

    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.0,  name = _('Function Selector Switch - OFF'),             category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.1,  name = _('Function Selector Switch - ROCKETS'),         category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.2,  name = _('Function Selector Switch - GM UNARM'),        category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.3,  name = _('Function Selector Switch - SPRAY TANK'),      category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.4,  name = _('Function Selector Switch - LABS'),            category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.5,  name = _('Function Selector Switch - BOMBS & GM ARM'),  category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = Keys.ArmsFuncSelectorCCW, name = _('Function Selector Switch - CCW'), category = {_('Armament Panel')}},
    {down = Keys.ArmsFuncSelectorCW, name = _('Function Selector Switch - CW'), category = {_('Armament Panel')}},
    
    {down = Keys.GunsReadyToggle,                                                                                                                   name = _('Gun Charging Switch - READY/SAFE Toggle'), category = {_('Armament Panel')}},
    {down = device_commands.arm_gun, value_down = 1, up = device_commands.arm_gun, value_up = 0, cockpit_device_id = devices.WEAPON_SYSTEM,         name = _('Guns - READY else SAFE'),                  category = {_('Armament Panel'), _('Special For Joystick')}},
    {down = Keys.MasterArmToggle,                                                                                                                   name = _('Master Arm Switch Toggle'),                category = {_('Armament Panel')}},
    {down = device_commands.arm_master, value_down = 1, up = device_commands.arm_master, value_up = 0, cockpit_device_id = devices.ELECTRIC_SYSTEM, name = _('Master Arm - ON else OFF'),                category = {_('Armament Panel'), _('Special For Joystick')}},

    -- Aircraft Weapons Release System Panel
    {down = Keys.AWRSMultiplierToggle,  name = _('MULTIPLIER Switch Toggle'),       category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSQtySelIncrease,    name = _('QTY SEL Switch - CW/Increase'),   category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSQtySelDecrease,    name = _('QTY SEL Switch - CCW/Decrease'),  category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSModeSelCCW,        name = _('MODE SELECT Switch - CCW/Right'), category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    {down = Keys.AWRSModeSelCW,         name = _('MODE SELECT Switch - CW/Left'),   category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},

    -- T-Handles
    {down = Keys.JettisonWeapons,up = Keys.JettisonWeaponsUp, name = _('EMER BOMB Release Handle'), category = {_('Instrument Panel')}},

    ---------------------------------------------
    -- Left Console -----------------------------
    ---------------------------------------------    
    -- Gunpods Control Panel
    {down = Keys.GunpodCharge,                                                                name = _('GUNPOD CHARGE/OFF/CLEAR Switch Toggle'), category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = Keys.GunpodLeft,                                                                  name = _('LH STATION Switch - READY/SAFE'),        category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = Keys.GunpodCenter,                                                                name = _('CTR STATION Switch - READY/SAFE'),       category = {_('Left Console'), _('Gunpods Control Panel')}},
    {down = Keys.GunpodRight,                                                                 name = _('RH STATION Switch - READY/SAFE'),        category = {_('Left Console'), _('Gunpods Control Panel')}},

    -- APC Control Panel
    {down = Keys.APCEngageStbyOff, value_down = -1,                                           name = _('APC POWER Switch - OFF'),                category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = 0,                                            name = _('APC POWER Switch - STBY'),               category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = 1,                                            name = _('APC POWER Switch - ENGAGE'),             category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = -1,                                              name = _('APC TEMP Switch - COLD'),                category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = 0,                                               name = _('APC TEMP Switch - STD'),                 category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCHotStdCold, value_down = 1,                                               name = _('APC TEMP Switch - HOT'),                 category = {_('Left Console'), _('APC Control Panel')}},
    {down = Keys.APCEngageStbyOff, value_down = -1, up = Keys.APCEngageStbyOff, value_up = 0, name = _('APC POWER Switch - OFF else STBY'),      category = {_('Left Console'), _('APC Control Panel'), _('Special For Joystick')}},
    {down = Keys.APCEngageStbyOff, value_down = 1, up = Keys.APCEngageStbyOff, value_up = 0,  name = _('APC POWER Switch - ENGAGE else STBY'),   category = {_('Left Console'), _('APC Control Panel'), _('Special For Joystick')}},
    {down = Keys.APCHotStdCold, value_down = -1, up = Keys.APCHotStdCold, value_up = 0,       name = _('APC TEMP Switch - COLD else STD'),       category = {_('Left Console'), _('APC Control Panel'), _('Special For Joystick')}},
    {down = Keys.APCHotStdCold, value_down = 1, up = Keys.APCHotStdCold, value_up = 0,        name = _('APC TEMP Switch - HOT else STD'),        category = {_('Left Console'), _('APC Control Panel'), _('Special For Joystick')}},
    
    -- JATO Control Panel
    {down = Keys.SpoilersArmToggle,                                                           name = _('Spoilers ARM-OFF Switch - ARM/OFF'),      category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.SpoilersArmOn,                                                               name = _('Spoilers ARM-OFF Switch - ARM'),          category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.SpoilersArmOff,                                                              name = _('Spoilers ARM-OFF Switch - OFF'),         category = {_('Left Console'), _('JATO Control Panel')}},
    {down = Keys.SpoilersArmOn, up = Keys.SpoilersArmOff,                                     name = _('Spoilers ARM-Off Switch - ARM else OFF'), category = {_('Left Console'), _('JATO Control Panel'), _("Special For Joystick")}},
    {down = Keys.JATOFiringButton,                                                            name = _('JATO Firing Button'),                    category = {_('Left Console'), _('JATO Control Panel')}},

    -- Engine Control Panel
    {down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff,                                   name = _('Fuel Dump'),                             category = {_('Left Console'), _('Engine Control Panel')}},
    {down = Keys.Engine_Start,                                                                name = _('Engine Starter Switch - START'),         category = {_('Left Console'), _('Engine Control Panel')}},
    {down = Keys.Engine_Stop,                                                                 name = _('Engine Starter Switch - ABORT'),         category = {_('Left Console'), _('Engine Control Panel')}},

    -- Radar Control Panel
    {down = Keys.RadarModeOFF,                                                          name = _('Radar Mode Selector Switch Knob - OFF'),                       category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeSTBY,                                                         name = _('Radar Mode Selector Switch Knob - STANDBY'),                   category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeSearch,                                                       name = _('Radar Mode Selector Switch Knob - SEARCH'),                    category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeTC,                                                           name = _('Radar Mode Selector Switch Knob - TERRAIN CLEARANCE'),         category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeA2G,                                                          name = _('Radar Mode Selector Switch Knob - A2G'),                       category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarMode,                                                             name = _('Radar Mode Selector Switch Knob Cycle'),                       category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeCW,                                                           name = _('Radar Mode Selector Switch Knob - CW'),                        category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarModeCCW,                                                          name = _('Radar Mode Selector Switch Knob - CCW'),                       category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = 1,                                          name = _('Radar AoA Compensation Switch - ON'),                          category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = 0,                                          name = _('Radar AoA Compensation Switch - OFF'),                         category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarAoAComp, value_down = -1,                                         name = _('Radar AoA Compensation Switch - ON/OFF'),                      category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarVolume, value_down = 1,                                           name = _('Radar Obstacle Tone Volume Knob - Increase'),                  category = {_('Left Console'), _('Radar Control Panel')}},
    {down = Keys.RadarVolume, value_down = 0,                                           name = _('Radar Obstacle Tone Volume Knob - Decrease'),                  category = {_('Left Console'), _('Radar Control Panel')}},
    
    {down = Keys.RadarModeSearch, up = Keys.RadarModeTC,                                name = _('Radar Mode Selector Switch Knob - SEARCH else TC'),            category = {_('Left Console'), _('Radar Control Panel'), _('Special For Joystick')}},
    {down = Keys.RadarModeA2G, up = Keys.RadarModeTC,                                   name = _('Radar Mode Selector Switch Knob - A2G else TC'),               category = {_('Left Console'), _('Radar Control Panel'), _('Special For Joystick')}},
    {down = Keys.RadarAoAComp, value_down = 1, up = Keys.RadarAoAComp, value_up = 0,    name = _('Radar AoA Compensation Switch - ON else OFF'),                 category = {_('Left Console'), _('Radar Control Panel'), _('Special For Joystick')}},
    
    -- AFCS Panel
    {down = Keys.AFCSStandbyToggle,                                                     name = _('AFCS Standby Switch - OFF/STANDBY'),                           category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSEngageToggle,                                                      name = _('AFCS Engage Switch - OFF/ENGAGE'),                             category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSAltitudeToggle,                                                    name = _('AFCS Altitude Switch - OFF/ALT'),                              category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSHeadingToggle,                                                     name = _('AFCS Heading Select Switch - OFF/HDG SEL'),                    category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_set, value_down = 1, cockpit_device_id = devices.AFCS,                name = _('AFCS SET Knob - CW/Increase'),              category = {_('Left Console'), _('AFCS Panel')}},
    {down = device_commands.afcs_hdg_set, value_down = -1, cockpit_device_id = devices.AFCS,                name = _('AFCS SET Knob - CCW/Decrease'),            category = {_('Left Console'), _('AFCS Panel')}},

    {down = Keys.AFCSHotasPath,                                                         name = _('AFCS Path Mode'),                                              category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSHotasAltHdg,                                                       name = _('AFCS Altitude + Heading Modes'),                               category = {_('Left Console'), _('AFCS Panel')}},
    {down = Keys.AFCSHotasAlt,                                                          name = _('AFCS Altitude Mode'),                                          category = {_('Left Console'), _('AFCS Panel')}},

    -- Special commands for Warthog Throttle
    {down = Keys.AFCSHotasPath, up = Keys.AFCSHotasAltHdg,  name = _('AFCS Path Mode else Altitude+Heading (Warthog Throttle)'),     category = {_('Left Console'), _('AFCS Panel'), _('Special For Joystick')}},
    {down = Keys.AFCSHotasAlt, up = Keys.AFCSHotasAltHdg, name = _('AFCS Altitude Mode else Altitude+Heading (Warthog Throttle)'), category = {_('Left Console'), _('AFCS Panel'), _('Special For Joystick')}},
    {down = Keys.AFCSHotasEngage,                                                       name = _('AFCS Engage (Warthog Throttle)'),                              category = {_('Left Console'), _('AFCS Panel'), _('Special For Joystick')}},

    -- Oxygen and Anti-G Panel

    -- Canopy Control
    {down = iCommandPlaneFonar,                                                         name = _('Canopy Open/Close'),                                   category = {_('Left Console')}},

    ---------------------------------------------
    -- Right Console ----------------------------
    ---------------------------------------------
    -- Doppler Radar Control Panel
    {down = Keys.NavDopplerOff,     name = _('Doppler Selector Switch Knob - OFF'),                         category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerStandby, name = _('Doppler Selector Switch Knob - STBY'),                        category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerLand,    name = _('Doppler Selector Switch Knob - LAND'),                        category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerSea,     name = _('Doppler Selector Switch Knob - SEA'),                         category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerTest,    name = _('Doppler Selector Switch Knob - TEST'),                        category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerCW,      name = _('Doppler Selector Switch Knob - CW'),                          category = {_('Right Console'), _('Doppler Radar Control Panel')}},
    {down = Keys.NavDopplerCCW,     name = _('Doppler Selector Switch Knob - CCW'),                         category = {_('Right Console'), _('Doppler Radar Control Panel')}},

    -- Navigation Control Panel
    {down = Keys.NavPPosLatInc,     name = _('Present Position Latitude Push-to-Set Knob - CW/Increase'),   category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavPPosLatDec,     name = _('Present Position Latitude Push-to-Set Knob - CCW/Decrease'),  category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavPPosLonInc,     name = _('Present Position Longitude Push-to-Set Knob - CW/Increase'),  category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavPPosLonDec,     name = _('Present Position Longitude Push-to-Set Knob - CCW/Decrease'), category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavDestLatInc,     name = _('Destination Latitude Push-to-Set Knob - CW/Increase'),        category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavDestLatDec,     name = _('Destination Latitude Push-to-Set Knob - CCW/Decrease'),       category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavDestLonInc,     name = _('Destination Longitude Push-to-Set Knob - CW/Increase'),       category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavDestLonDec,     name = _('Destination Longitude Push-to-Set Knob - CCW/Decrease'),      category = {_('Right Console'), _('Navigation Control Panel')}},

    {down = Keys.NavSelectTest,     name = _('Navigation Computer Selector Switch - TEST'),                 category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectOff,      name = _('Navigation Computer Selector Switch - OFF'),                  category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectStandby,  name = _('Navigation Computer Selector Switch - STBY'),                 category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectD1,       name = _('Navigation Computer Selector Switch - D1'),                   category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectD2,       name = _('Navigation Computer Selector Switch - D2'),                   category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectCW,       name = _('Navigation Computer Selector Switch - CW'),                   category = {_('Right Console'), _('Navigation Control Panel')}},
    {down = Keys.NavSelectCCW,      name = _('Navigation Computer Selector Switch - CCW'),                  category = {_('Right Console'), _('Navigation Control Panel')}},

    -- ARN-52 TACAN Control Panel
    {down = Keys.NavReset,          name = _('Reset Both TCN & NDB Channels'),                              category = {_('Systems')}},
    -- {down = Keys.NavTCNPrev,     name = _('TACAN Channel: Previous'),                                    category = {_('Systems')}},
    -- {down = Keys.NavTCNNext,     name = _('TACAN Channel: Next'),                                        category = {_('Systems')}},
    -- {down = Keys.NavNDBPrev,     name = _('NDB Channel: Previous'),                                      category = {_('Systems')}},
    -- {down = Keys.NavNDBNext,     name = _('NDB Channel: Next'),                                          category = {_('Systems')}},
    {down = Keys.NavILSPrev,        name = _('ILS Channel: Previous'),                                      category = {_('Systems')}},
    {down = Keys.NavILSNext,        name = _('ILS Channel: Next'),                                          category = {_('Systems')}},
 
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
    {down = Keys.ExtLightProbeCycle,                                                                   name = _('PROBE Light Switch - BRIGHT/DIM/OFF'),  category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightProbe, value_down = 1, up = Keys.ExtLightProbe, value_up = 0,                 name = _('PROBE Light Switch - BRIGHT else OFF'), category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},
    {down = Keys.ExtLightProbe, value_down = -1, up = Keys.ExtLightProbe, value_up = 0,                name = _('PROBE Light Switch - DIM else OFF'),    category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    {down = Keys.ExtLightTaxi, value_down = 1,                                                         name = _('TAXI Light Switch - ON'),               category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTaxi, value_down = 0,                                                         name = _('TAXI Light Switch - OFF'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTaxiToggle,                                                                   name = _('TAXI Light Switch - ON/OFF'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTaxi, value_down = 1, up = Keys.ExtLightTaxi, value_up = 0,                   name = _('TAXI Light Switch - ON else OFF'),      category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    {down = Keys.ExtLightAnticollision, value_down = 1,                                                name = _('ANTI-COLL Light Switch - ON'),          category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightAnticollision, value_down = 0,                                                name = _('ANTI-COLL Light Switch - OFF'),         category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightAnticollisionToggle,                                                          name = _('ANTI-COLL Light Switch - ON/OFF'),      category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightAnticollision, value_down = 1, up = Keys.ExtLightAnticollision, value_up = 0, name = _('ANTI-COLL Light Switch - ON else OFF'), category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    {down = Keys.ExtLightNav, value_down = 1,                                                          name = _('WING Light Switch - BRIGHT'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = -1,                                                         name = _('WING Light Switch - DIM'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = 0,                                                          name = _('WING Light Switch - OFF'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNavCycle,                                                                     name = _('WING Light Switch - BRIGHT/DIM/OFF'),   category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightNav, value_down = 1, up = Keys.ExtLightNav, value_up = 0,                     name = _('WING Light Switch - BRIGHT else OFF'),  category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},
    {down = Keys.ExtLightNav, value_down = -1, up = Keys.ExtLightNav, value_up = 0,                    name = _('WING Light Switch - DIM else OFF'),     category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    {down = Keys.ExtLightTail, value_down = 1,                                                         name = _('TAIL Light Switch - BRIGHT'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = -1,                                                        name = _('TAIL Light Switch - DIM'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = 0,                                                         name = _('TAIL Light Switch - OFF'),              category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTailCycle,                                                                    name = _('TAIL Light Switch - BRIGHT/DIM/OFF'),   category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightTail, value_down = 1, up = Keys.ExtLightTail, value_up = 0,                   name = _('TAIL Light Switch - BRIGHT else OFF'),  category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},
    {down = Keys.ExtLightTail, value_down = -1, up = Keys.ExtLightTail, value_up = 0,                  name = _('TAIL Light Switch - DIM else OFF'),     category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    {down = Keys.ExtLightFuselage, value_down = 1,                                                     name = _('FUS Light Switch - BRIGHT'),            category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = -1,                                                    name = _('FUS Light Switch - DIM'),               category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = 0,                                                     name = _('FUS Light Switch - OFF'),               category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselageCycle,                                                                name = _('FUS Light Switch - BRIGHT/DIM/OFF'),    category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFuselage, value_down = 1, up = Keys.ExtLightFuselage, value_up = 0,           name = _('FUS Light Switch - BRIGHT else OFF'),   category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},
    {down = Keys.ExtLightFuselage, value_down = -1, up = Keys.ExtLightFuselage, value_up = 0,          name = _('FUS Light Switch - DIM else OFF'),      category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    {down = Keys.ExtLightFlashSteady, value_down = 1,                                                  name = _('FLASH-STEADY Switch - FLSH'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFlashSteady, value_down = 0,                                                  name = _('FLASH-STEADY Switch - STDY'),           category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFlashSteadyToggle,                                                            name = _('FLASH-STEADY Switch - FLSH/STDY'),      category = {_('Right Console'), _('Exterior Lights Panel')}},
    {down = Keys.ExtLightFlashSteady, value_down = 1, up = Keys.ExtLightFlashSteady, value_up = 0,     name = _('FLASH-STEADY Switch - FLSH else STDY'), category = {_('Right Console'), _('Exterior Lights Panel'), _('Special For Joystick')}},

    ---------------------------------------------
    -- Carrier Catapult -------------------------
    --------------------------------------------- 
    --{down = Keys.catapult_ready, value_down = 1.0, value_up = 0.0, name = _('Catapult Hook-up'), category = _('Flight Control')},
    --{down = Keys.catapult_shoot, value_down = 1.0, value_up = 0.0, name = _('Catapult Shoot'),     category = _('Flight Control')},
    {down = iCommandPilotGestureSalute, name = _('Pilot Salute'),     category = _('Communications')},
    
    -- Weapon/CMDS Adjustment
    {down = Keys.ChangeCBU2AQuantity,    value_down = 1, name = _('ALE-29A Programmer CBU-2/A Release Quantity - 1/2/3'),            category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCBU2BAQuantity,   value_down = 1, name = _('ALE-29A Programmer CBU-2B/A Release Quantity - 1/2/3/4/6/SALVO'), category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCmsBursts,        value_down = 1, name = _('ALE-29A Programmer Countermeasures Bursts'),                      category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCmsBurstInterval, value_down = 1, name = _('ALE-29A Programmer Countermeasures Burst Interval'),              category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeCmsSalvos,        value_down = 1, name = _('ALE-29A Programmer Countermeasures Salvos'),                      category = {_('Kneeboard'), _('ALE-29A Programmer')}},
    {down = Keys.ChangeSalvoInterval,    value_down = 1, name = _('ALE-29A Programmer Countermeasures Salvo Interval'),              category = {_('Kneeboard'), _('ALE-29A Programmer')}},

    --NightVision
    {down   = iCommandViewNightVisionGogglesOn   , name = _('Night Vision Goggle - Toggle'), category = _('Sensors')},
    {down   = iCommandPlane_Helmet_Brightess_Up  , name = _('Goggle Gain - Inc'),            category = _('Sensors')},
    {down   = iCommandPlane_Helmet_Brightess_Down, name = _('Goggle Gain - Dec'),            category = _('Sensors')},
    
	-- Radio
	{down = Keys.radio_ptt   , name = _('Radio Push to Talk (PTT)'), category = _('Radio')},
	
    -- PID tuning
    {down = Keys.Tune1, value_down = 0.1,          name = _('Tune1: +0.1'),                  category = _('Debug')},
    {down = Keys.Tune1, value_down = -0.1,         name = _('Tune1: -0.1'),                  category = _('Debug')},
    {down = Keys.Tune2, value_down = 0.1,          name = _('Tune2: +0.1'),                  category = _('Debug')},
    {down = Keys.Tune2, value_down = -0.1,         name = _('Tune2: -0.1'),                  category = _('Debug')},
    {down = Keys.Tune3, value_down = 0.1,          name = _('Tune3: +0.1'),                  category = _('Debug')},
    {down = Keys.Tune3, value_down = -0.1,         name = _('Tune3: -0.1'),                  category = _('Debug')},
    
    -- FC3 Commands [Implemented] (TODO: What should be implmented here?)
    {down = Keys.JettisonFC3,up = Keys.JettisonWeaponsUp, name = _('Weapons Jettison: FC3-style'), category = {_('Systems')}},
    
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

    {combos = defaultDeviceAssignmentFor("roll"),   action = iCommandPlaneRoll,                                                             name = _('Roll'),              category = {_('Flight Control')}},
    {combos = defaultDeviceAssignmentFor("pitch"),  action = iCommandPlanePitch,                                                            name = _('Pitch'),             category = {_('Flight Control')}},
	{combos = defaultDeviceAssignmentFor("rudder"), action = iCommandPlaneRudder,																	name = _('Rudder'),            category = {_('Flight Control')}},
	{combos = defaultDeviceAssignmentFor("thrust"), action = iCommandPlaneThrustCommon,    														name = _('Thrust'),            category = {_('Flight Control')}},
    {action = device_commands.wheelbrake_AXIS,       cockpit_device_id = devices.AIRBRAKES ,  name = _('Wheel Brake'),       category = {_('Systems')}},
    {action = device_commands.left_wheelbrake_AXIS,  name = _('Wheel Brake Left'),  category = {_('Systems')}},
    {action = device_commands.right_wheelbrake_AXIS,  name = _('Wheel Brake Right'), category = {_('Systems')}},
    
	--Old throttle
    --{combos = defaultDeviceAssignmentFor("rudder"),  action = iCommandPlaneRudder	   , name = _('Rudder')},
	--{combos = defaultDeviceAssignmentFor("thrust"),  action = iCommandPlaneThrustCommon, name = _('Thrust')},
	--Needed for the new Carrier script, should replace the Real throttle later
    
    ---------------------------------------------
    -- ECM Control Panel ------------------------
    --------------------------------------------- 
    {action = device_commands.ecm_msl_alert_axis_inner,     cockpit_device_id = devices.RWR ,          name = _('PRF volume (inner knob)'), category = {_('ECM Control Panel')}},
    {action = device_commands.ecm_msl_alert_axis_outer,     cockpit_device_id = devices.RWR ,          name = _('MSL volume (outer knob)'), category = {_('ECM Control Panel')}},
    
    -- Radar Control Panel
    {action = device_commands.radar_angle_axis,             cockpit_device_id = devices.RADAR,         name = _('Radar Angle Slew'),        category = {_('Left Console'), _('Radar Control Panel')}},
    {action = device_commands.radar_angle_axis_abs,         cockpit_device_id = devices.RADAR,         name = _('Radar Angle Absolute'),    category = {_('Left Console'), _('Radar Control Panel')}},

    -- Interior Lights Panel
    {action = device_commands.intlight_instruments_AXIS,    cockpit_device_id = devices.AVIONICS,      name = _('Lighting: Instrument'),    category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {action = device_commands.intlight_console_AXIS,        cockpit_device_id = devices.AVIONICS,      name = _('Lighting: Console'),       category = {_('Right Console'), _('Interior Lights Control Panel')}},
    {action = device_commands.intlight_whiteflood_AXIS,     cockpit_device_id = devices.AVIONICS,      name = _('Lighting: White Flood'),   category = {_('Right Console'), _('Interior Lights Control Panel')}},

    -- Aircraft Weapons Release System Panel
    {action = device_commands.AWRS_drop_interval_AXIS,      cockpit_device_id = devices.WEAPON_SYSTEM, name = _('DROP INTVL Control'),      category = {_('Instrument Panel'), _('AWE-1 Aircraft Weapons Release System Panel')}},
    
    --{action = iCommandWheelBrake,		name = _('Wheel Brake')},

    {action = device_commands.GunsightElevationControl_AXIS,   cockpit_device_id = devices.GUNSIGHT,       name = _('Gunsight Elevation Control'),      category = {_('Instrument Panel'), _('Gunsight Panel')}},

})
return res