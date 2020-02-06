local cscripts = folder.."../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_keyboard_binding.lua")

--
-- from common_chat_keyboard_binding.lua...
--

join(res.keyCommands,{

    {combos = {{key = 'Tab'}}, down = iCommandChat, name = _('Multiplayer chat - mode All'), category = _('General')},
    {combos = {{key = 'Tab', reformers = {'LCtrl'}}}, down = iCommandFriendlyChat, name = _('Multiplayer chat - mode Allies'), category = _('General')},
    {combos = {{key = 'Tab', reformers = {'LShift'}}}, down = iCommandAllChat, name = _('Chat read/write All'), category = _('General')},
    {combos = {{key = 'Y', reformers = {'LCtrl', 'LShift'}}}, down = iCommandChatShowHide, name = _('Chat show/hide'), category = _('General')},

    {down = Keys.ToggleStick, name = _('Hide/Show Control Stick'), category = _('General')},

    --
    -- from base_keyboard_binding.lua...
    --

    -- General (Gameplay)
    {combos = {{key = 'U'}}, down = iCommandPlaneShipTakeOff, name = _('Ship Take Off Position'), category = _('General')},
    {combos = {{key = 'P', reformers = {'RShift'}}}, down = iCommandCockpitShowPilotOnOff, name = _('Show Pilot Body'), category = _('General')},

    -- Flight Control
    {combos = {{key = 'Up'}}, down = iCommandPlaneUpStart, up = iCommandPlaneUpStop, name = _('Aircraft Pitch Down'), category = _('Flight Control')},
    {combos = {{key = 'Down'}}, down = iCommandPlaneDownStart, up = iCommandPlaneDownStop, name = _('Aircraft Pitch Up'), category = _('Flight Control')},
    {combos = {{key = 'Left'}}, down = iCommandPlaneLeftStart, up = iCommandPlaneLeftStop, name = _('Aircraft Bank Left'), category = _('Flight Control')},
    {combos = {{key = 'Right'}}, down = iCommandPlaneRightStart, up = iCommandPlaneRightStop, name = _('Aircraft Bank Right'), category = _('Flight Control')},
    {combos = {{key = 'Z'}}, down = iCommandPlaneLeftRudderStart, up = iCommandPlaneLeftRudderStop, name = _('Aircraft Rudder Left'), category = _('Flight Control')},
    {combos = {{key = 'X'}}, down = iCommandPlaneRightRudderStart, up = iCommandPlaneRightRudderStop, name = _('Aircraft Rudder Right'), category = _('Flight Control')},

    {combos = {{key = '.', reformers = {'RCtrl'}}}, pressed = Keys.TrimUp, up = Keys.TrimStop, name = _('Trim: Nose Up'), category = _('Flight Control')},
    {combos = {{key = ';', reformers = {'RCtrl'}}}, pressed = Keys.TrimDown, up = Keys.TrimStop, name = _('Trim: Nose Down'), category = _('Flight Control')},
    {combos = {{key = ',', reformers = {'RCtrl'}}}, pressed = Keys.TrimLeft, up = Keys.TrimStop, name = _('Trim: Left Wing Down'), category = _('Flight Control')},
    {combos = {{key = '/', reformers = {'RCtrl'}}}, pressed = Keys.TrimRight, up = Keys.TrimStop, name = _('Trim: Right Wing Down'), category = _('Flight Control')},
    {combos = {{key = 'Z', reformers = {'RCtrl'}}}, pressed = Keys.TrimLeftRudder, up = Keys.TrimStop, name = _('Trim: Rudder Left'), category = _('Flight Control')},
    {combos = {{key = 'X', reformers = {'RCtrl'}}}, pressed = Keys.TrimRightRudder, up = Keys.TrimStop, name = _('Trim: Rudder Right'), category = _('Flight Control')},
    {combos = {{key = 'T', reformers = {'LCtrl'}}}, down = Keys.TrimCancel, name = _('Trim: Reset'), category = _('Flight Control')},

    {combos = {{key = 'Num+'}}, 						pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,  name = _('Throttle Up'), category = _('Flight Control')},
    {combos = {{key = 'Num-'}}, 						pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,  name = _('Throttle Down'), category = _('Flight Control')},
    --{combos = {{key = 'Num+', reformers = {'RAlt'}}}, 	pressed = iCommandThrottle1Increase,up = iCommandThrottle1Stop, name = _('Throttle Left Up'), category = _('Flight Control')},
    --{combos = {{key = 'Num-', reformers = {'RAlt'}}}, 	pressed = iCommandThrottle1Decrease,up = iCommandThrottle1Stop, name = _('Throttle Left Down'), category = _('Flight Control')},
    --{combos = {{key = 'Num+', reformers = {'RShift'}}}, pressed = iCommandThrottle2Increase,up = iCommandThrottle2Stop, name = _('Throttle Right Up'), category = _('Flight Control')},
    --{combos = {{key = 'Num-', reformers = {'RShift'}}}, pressed = iCommandThrottle2Decrease,up = iCommandThrottle2Stop, name = _('Throttle Right Down'), category = _('Flight Control')},

    {combos = {{key = 'PageUp'}}, down = iCommandPlaneAUTIncreaseRegime, name = _('Throttle Step Up'), category = _('Flight Control')},
    {combos = {{key = 'PageDown'}}, down = iCommandPlaneAUTDecreaseRegime, name = _('Throttle Step Down'), category = _('Flight Control')},
    --{combos = {{key = 'PageUp', reformers = {'RAlt'}}}, down = iCommandPlaneAUTIncreaseRegimeLeft, name = _('Throttle Step Up Left'), category = _('Flight Control')},
    --{combos = {{key = 'PageDown', reformers = {'RAlt'}}}, down = iCommandPlaneAUTDecreaseRegimeLeft, name = _('Throttle Step Down Left'), category = _('Flight Control')},
    --{combos = {{key = 'PageUp', reformers = {'RShift'}}}, down = iCommandPlaneAUTIncreaseRegimeRight, name = _('Throttle Step Up Right'), category = _('Flight Control')},
    --{combos = {{key = 'PageDown', reformers = {'RShift'}}}, down = iCommandPlaneAUTDecreaseRegimeRight, name = _('Throttle Step Down Right'), category = _('Flight Control')},


    ---------------------------------------------
    -- Throttle Quadrant ------------------------
    ---------------------------------------------

    {down = Keys.ExtLightMaster, value_down = 1, name = _('Master Exterior Lights - ON'), category = {_('Throttle')}},
    {down = Keys.ExtLightMaster, value_down = 0, name = _('Master Exterior Lights - OFF'), category = {_('Throttle')}},
    {down = Keys.ExtLightMasterToggle, name = _('Master Exterior Lights - Toggle'), category = {_('Throttle')}},
    {combos = {{key = 'B', reformers = {'LShift'}}}, down = iCommandPlaneAirBrakeOn, name = _('Speedbrake OPEN'), category = {_('Throttle')}},
    {combos = {{key = 'B', reformers = {'LCtrl'}}}, down = iCommandPlaneAirBrakeOff, name = _('Speedbrake CLOSE'), category = {_('Throttle')}},

    -- Systems

    {combos = {{key = 'L', reformers = {'RShift'}}}, down = iCommandPowerOnOff, name = _('Electric Power Switch'), category = {_('Systems')}},
    {combos = {{key = 'B'}}, down = iCommandPlaneAirBrake, name = _('Speedbrake'), category = {_('Systems')}},
    {combos = {{key = 'T'}}, down = iCommandPlaneWingtipSmokeOnOff, name = _('Smoke'), category = {_('Systems')}},
    {combos = {{key = 'L'}}, down = iCommandPlaneCockpitIllumination, name = _('Illumination Cockpit'), category = {_('Systems')}},
    {combos = {{key = 'L', reformers = {'RCtrl'}}}, down = Keys.PlaneLightsOnOff, name = _('Navigation Lights Bright/Dim/Off'), category = {_('Systems')}},
    {combos = {{key = 'L', reformers = {'RAlt'}}}, down = Keys.PlaneHeadlightOnOff, name = _('Taxi Light On/Off'), category = {_('Systems')}},

    {combos = {{key = 'F'}}, down = iCommandPlaneFlaps, name = _('Flaps Up/Down'), category = {_('Systems')}},
    {combos = {{key = 'F', reformers = {'LCtrl'}}}, down = iCommandPlaneFlapsOn, name = _('Flaps Down'), category = {_('Systems')}},
    {combos = {{key = 'F', reformers = {'LShift'}}}, down = iCommandPlaneFlapsOff, name = _('Flaps Up'), category = {_('Systems')}},
    {combos = {{key = 'F', reformers = {'LAlt'}}}, down = Keys.PlaneFlapsStop, name = _('Flaps Stop'), category = {_('Systems')}},

    {combos = {{key = 'G'}}, down = Keys.PlaneGear, name = _('Landing Gear Up/Down'), category = {_('Systems')}},
    {combos = {{key = 'G', reformers = {'LCtrl'}}}, down = Keys.PlaneGearUp, name = _('Landing Gear Up'), category = {_('Systems')}},
    {combos = {{key = 'G', reformers = {'LShift'}}}, down = Keys.PlaneGearDown, name = _('Landing Gear Down'), category = {_('Systems')}},

    {combos = {{key = 'W'}}, down = Keys.BrakesOn, up = Keys.BrakesOff, name = _('Wheel Brake On'), category = {_('Systems')}},
    {combos = {{key = 'C', reformers = {'LCtrl'}}}, down = iCommandPlaneFonar, name = _('Canopy Open/Close'), category = {_('Systems')}},
    {combos = {{key = 'P'}}, down = iCommandPlaneParachute, name = _('Dragging Chute'), category = {_('Systems')}},
    {combos = {{key = 'N', reformers = {'RShift'}}}, down = iCommandPlaneResetMasterWarning, name = _('Audible Warning Reset'), category = {_('Systems')}},
    {down = Keys.JettisonWeapons,up = Keys.JettisonWeaponsUp, name = _('Weapons Jettison: Realistic'), category = {_('Systems')}},
    {combos = {{key = 'W', reformers = {'LCtrl'}}}, down = Keys.JettisonFC3,up = Keys.JettisonWeaponsUp, name = _('Weapons Jettison: FC3-style'), category = {_('Systems')}},
    {combos = {{key = 'E', reformers = {'LCtrl'}}}, down = iCommandPlaneEject, name = _('Eject (3 times)'), category = {_('Systems')}},
    {combos = {{key = 'C', reformers = {'RShift'}}}, down = iCommandFlightClockReset, name = _('Flight Clock Start/Stop/Reset'), category = {_('Systems')}},
    {down = iCommandClockElapsedTimeReset, name = _('Elapsed Time Clock Start/Stop/Reset'), category = {_('Systems')}},
    {combos = {{key = 'Home', reformers = {'RShift'}}}, down = Keys.Engine_Start, name = _('Engines Start'), category = {_('Systems')}},
    {combos = {{key = 'End', reformers = {'RShift'}}}, down = Keys.Engine_Stop, name = _('Engines Stop'), category = {_('Systems')}},
    --{combos = {{key = 'Home', reformers = {'RAlt'}}}, down = iCommandLeftEngineStart, name = _('Engine Left Start'), category = {_('Systems')}},
    --{combos = {{key = 'End', reformers = {'RAlt'}}}, down = iCommandLeftEngineStop, name = _('Engine Left Stop'), category = {_('Systems')}},
    --{combos = {{key = 'Home', reformers = {'RCtrl'}}}, down = iCommandRightEngineStart, name = _('Engine Right Start'), category = {_('Systems')}},
    --{combos = {{key = 'End', reformers = {'RCtrl'}}}, down = iCommandRightEngineStop, name = _('Engine Right Stop'), category = {_('Systems')}},
    -- {combos = {{key = 'H', reformers = {'RCtrl'}}}, down = iCommandBrightnessILS, name = _('HUD Color'), category = {_('Systems')}},
    -- {combos = {{key = 'H', reformers = {'RCtrl','RShift'}}}, pressed = iCommandHUDBrightnessUp, name = _('HUD Brightness up'), category = {_('Systems')}},
    -- {combos = {{key = 'H', reformers = {'RShift','RAlt'}}}, pressed = iCommandHUDBrightnessDown, name = _('HUD Brightness down'), category = {_('Systems')}},
    {combos = {{key = 'R'}}, down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff, name = _('Fuel Dump'), category = {_('Systems')}},

    -- Modes
    {combos = {{key = '`', reformers = {'LCtrl'}}}, down = iCommandPlaneChangeTarget  , name = _('Next Waypoint, Airfield Or Target'), category = _('Modes')},
    {combos = {{key = '`', reformers = {'LShift'}}},  down = iCommandPlaneUFC_STEER_DOWN, name = _('Previous Waypoint, Airfield Or Target'), category = _('Modes')},

    --{combos = {{key = 'N'}},								 	down    = iCommandViewNightVisionGogglesOn   , name = _('Night Vision Goggles')   		  , category = _('Sensors')},
    --{combos = {{key = 'N', reformers = {'RCtrl'}}}, 			pressed = iCommandPlane_Helmet_Brightess_Up  , name = _('Night Vision Goggles Gain Up')  , category = _('Sensors')},
    --{combos = {{key = 'N', reformers = {'RCtrl','RShift'}}}, 	pressed = iCommandPlane_Helmet_Brightess_Down, name = _('Night Vision Goggles Gain Down'), category = _('Sensors')},

    -- Weapons                                                                        
    {combos = {{key = 'Space'}}, down = Keys.PlaneFireOn, up = Keys.PlaneFireOff, name = _('Weapon Fire'), category = _('Weapons')},
    {combos = {{key = 'Space', reformers = {'LAlt'}}}, down = Keys.PickleOn,	up = Keys.PickleOff, name = _('Weapon Release'), category = 'Weapons'},
    {combos = {{key = 'D'}}, down = iCommandPlaneChangeWeapon, name = _('Weapon Change'), category = _('Weapons')},
    {combos = {{key = 'C'}}, down = iCommandPlaneModeCannon, name = _('Cannon'), category = _('Weapons')},
    
    {down = Keys.AWRSMultiplierToggle,  name = _('AWRS: Toggle multiplier'),        category = {_('Instrument Panel'), _('AWE-1'), _('Weapons')}},
    {down = Keys.AWRSQtySelIncrease,    name = _('AWRS: Quantity Select Increase'), category = {_('Instrument Panel'), _('AWE-1'), _('Weapons')}},
    {down = Keys.AWRSQtySelDecrease,    name = _('AWRS: Quantity Select Decrease'), category = {_('Instrument Panel'), _('AWE-1'), _('Weapons')}},
    {down = Keys.AWRSModeSelCCW,        name = _('AWRS: Mode Select CCW'),          category = {_('Instrument Panel'), _('AWE-1'), _('Weapons')}},
    {down = Keys.AWRSModeSelCW,         name = _('AWRS: Mode Select CW'),           category = {_('Instrument Panel'), _('AWE-1'), _('Weapons')}},
    

    --{combos = {{key = 'W', reformers = {'LAlt'}}}, down = iCommandPlaneLaunchPermissionOverride, name = _('Launch Permission Override'), category = _('Weapons')},
    -- Countermeasures
    --{combos = {{key = 'Q', reformers = {'LShift'}}}, down = iCommandPlaneDropSnar, name = _('Countermeasures Continuously Dispense'), category = _('Countermeasures')},
    {combos = {{key = 'Q'}}, down = Keys.JATOFiringButton, name = _('JATO Firing Button'), category = {_('JATO'), _('Countermeasures')}},
    --{combos = {{key = 'Delete'}}, down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'), category = _('Countermeasures')},
    --{combos = {{key = 'Insert'}}, down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'), category = _('Countermeasures')},
    {combos = {{key = 'E'}}, down = iCommandActiveJamming, name = _('Countermeasures: ECM'), category = _('Countermeasures')},

    {down = Keys.CmBankSelectRotate, name = _('Countermeasures: Bank Select Rotate'), category = _('Countermeasures')},
    {down = Keys.CmBankSelect, value_down = -1, name = _('Countermeasures: Bank Select 1'), category = _('Countermeasures')},
    {down = Keys.CmBankSelect, value_down = 1,  name = _('Countermeasures: Bank Select 2'), category = _('Countermeasures')},
    {down = Keys.CmBankSelect, value_down = 0,  name = _('Countermeasures: Bank Select Both'), category = _('Countermeasures')},
    {down = device_commands.cm_auto,    up = device_commands.cm_auto,   cockpit_device_id = devices.COUNTERMEASURES,  value_down = 1.0,   value_up = 0, name = _('Countermeasures: Auto Pushbutton'), category = _('Countermeasures')},
    {down = Keys.CmBank1AdjUp, name = _('Countermeasures: Bank 1 Adjust Up'), category = _('Countermeasures')},
    {down = Keys.CmBank1AdjDown, name = _('Countermeasures: Bank 1 Adjust Down'), category = _('Countermeasures')},
    {down = Keys.CmBank2AdjUp, name = _('Countermeasures: Bank 2 Adjust Up'), category = _('Countermeasures')},
    {down = Keys.CmBank2AdjDown, name = _('Countermeasures: Bank 2 Adjust Down'), category = _('Countermeasures')},
    {down = Keys.CmPowerToggle, name = _('Countermeasures: Power Toggle'), category = _('Countermeasures')},

    -- Communications
    {combos = {{key = 'I', reformers = {'LWin'}}}, down = iCommandAWACSTankerBearing, name = _('Request AWACS Available Tanker'), category = _('Communications')},
    {combos = {{key = '\\', reformers = {'RShift'}}, {key = 'M', reformers = {'RShift'}}}, down = iCommandToggleReceiveMode, name = _('Receive Mode'), category = _('Communications')},

    -- Cockpit Camera Motion
    {combos = {{key = 'N', reformers = {'RAlt'}}}, down = iCommandViewLeftMirrorOn ,	up = iCommandViewLeftMirrorOff , name = _('Mirror Left On'), category = _('View Cockpit')},
    {combos = {{key = 'M', reformers = {'RAlt'}}}, down = iCommandViewRightMirrorOn,	up = iCommandViewRightMirrorOff, name = _('Mirror Right On'), category = _('View Cockpit')},
    {combos = {{key = 'M' }}, down = iCommandToggleMirrors, name = _('Toggle Mirrors'), category = _('View Cockpit')},

    -- Auto Lock On 
    --{combos = {{key = 'F5', reformers = {'RAlt'}}}, down = iCommandAutoLockOnNearestAircraft, name = _('Auto lock on nearest aircraft'), category = _('Simplifications')},
    --{combos = {{key = 'F6', reformers = {'RAlt'}}}, down = iCommandAutoLockOnCenterAircraft, name = _('Auto lock on center aircraft'), category = _('Simplifications')},
    --{combos = {{key = 'F7', reformers = {'RAlt'}}}, down = iCommandAutoLockOnNextAircraft, name = _('Auto lock on next aircraft'), category = _('Simplifications')},
    --{combos = {{key = 'F8', reformers = {'RAlt'}}}, down = iCommandAutoLockOnPreviousAircraft, name = _('Auto lock on previous aircraft'), category = _('Simplifications')},
    --{combos = {{key = 'F9', reformers = {'RAlt'}}}, down = iCommandAutoLockOnNearestSurfaceTarget, name = _('Auto lock on nearest surface target'), category = _('Simplifications')},
    --{combos = {{key = 'F10', reformers = {'RAlt'}}}, down = iCommandAutoLockOnCenterSurfaceTarget, name = _('Auto lock on center surface target'), category = _('Simplifications')},
    --{combos = {{key = 'F11', reformers = {'RAlt'}}}, down = iCommandAutoLockOnNextSurfaceTarget, name = _('Auto lock on next surface target'), category = _('Simplifications')},
    --{combos = {{key = 'F12', reformers = {'RAlt'}}}, down = iCommandAutoLockOnPreviousSurfaceTarget, name = _('Auto lock on previous surface target'), category = _('Simplifications')},

    --
    -- A-4E Specific Controls
    --


    -- Autopilot
    -- {combos = {{key = 'A'}}, down = iCommandPlaneAutopilot, name = _('Autopilot'), category = _('Autopilot')},
    --{combos = {{key = 'J'}}, down = iCommandPlaneAUTOnOff, name = _('Autothrust'), category = _('Autopilot')},
    -- {combos = {{key = 'H'}}, down = iCommandPlaneSAUHBarometric, name = _('Autopilot - Barometric Altitude Hold \'H\''), category = _('Autopilot')},
    -- {combos = {{key = '1', reformers = {'LAlt'}}}, down = iCommandPlaneStabTangBank, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
    --{combos = {{key = '2', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbarBank, name = _('Autopilot - Altitude And Roll Hold'), category = _('Autopilot')},
    --{combos = {{key = '3', reformers = {'LAlt'}}}, down = iCommandPlaneStabHorizon,	name = _('Autopilot - Transition To Level Flight Control'), category = _('Autopilot')},
    -- {combos = {{key = '4', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbar, name = _('Autopilot - Barometric Altitude Hold'), category = _('Autopilot')},
    --{combos = {{key = '5', reformers = {'LAlt'}}}, down = iCommandPlaneStabHrad, name = _('Autopilot - Radar Altitude Hold'), category = _('Autopilot')},
    --{combos = {{key = '6', reformers = {'LAlt'}}}, down = iCommandPlaneRouteAutopilot, name = _('Autopilot - \'Route following\''), category = _('Autopilot')},
    -- {combos = {{key = '7', reformers = {'LAlt'}}}, down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},

    -- Systems
    {combos = {{key = 'R', reformers = {'LCtrl'}}}, down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = {_('Systems')}},
    {combos = {{key = 'G', reformers = {'LAlt'}}}, down = iCommandPlaneHook, name = _('Tail Hook Up/Down'), category = {_('Systems')}},
    --{down = Keys.PlaneHookUp, name = _('Tail Hook Up'), category = {_('Systems')}},
    --{down = Keys.PlaneHookDown, name = _('Tail Hook Down'), category = {_('Systems')}},
    --{combos = {{key = 'P', reformers = {'RCtrl'}}}, down = iCommandPlanePackWing, name = _('Folding Wings'), category = {_('Systems')}},

    -- Modes
    -- {combos = {{key = '1', reformers = {'LShift'}}}, down = iCommandPlaneModeNAV, name = _('(1) Navigation Modes'), category = _('Modes')},
    -- {combos = {{key = '2', reformers = {'LShift'}}}, down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
    -- {combos = {{key = '3', reformers = {'LShift'}}}, down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
    -- {combos = {{key = '4', reformers = {'LShift'}}}, down = Keys.PlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
    --{combos = {{key = '5'}}, down = iCommandPlaneModeHelmet, name = _('(5) Close Air Combat HMD Helmet Mode'), category = _('Modes')},
    --{combos = {{key = '6'}}, down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode'), category = _('Modes')},
    --{combos = {{key = '7', reformers = {'LShift'}}}, down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},
    --{combos = {{key = '8'}}, down = iCommandPlaneModeGrid, name = _('(8) Gunsight Reticle Switch'), category = _('Modes')},

    {combos = {{key = '5', reformers = {'LShift'}}}, down = Keys.RadarHoldToggle, name = _('Radar Hold: Toggle'), category = _('Modes')},
    {combos = {{key = '6', reformers = {'LShift'}}}, down = Keys.RadarHoldDec, name = _('Radar Hold: Dec'), category = _('Modes')},
    {combos = {{key = '7', reformers = {'LShift'}}}, down = Keys.RadarHoldInc, name = _('Radar Hold: Inc'), category = _('Modes')},
    {combos = {{key = '8', reformers = {'LShift'}}}, down = Keys.SpeedHoldToggle, name = _('Speed Hold: Toggle'), category = _('Modes')},
    {combos = {{key = '9', reformers = {'LShift'}}}, down = Keys.SpeedHoldDec, name = _('Speed Hold: Dec'), category = _('Modes')},
    {combos = {{key = '0', reformers = {'LShift'}}}, down = Keys.SpeedHoldInc, name = _('Speed Hold: Inc'), category = _('Modes')},

    -- Sensors
    --{combos = {{key = 'Enter'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
    --{combos = {{key = 'Back'}}, down = iCommandSensorReset, name = _('Return To Search'), category = _('Sensors')},
    --{combos = {{key = 'I'}}, down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
    --{combos = {{key = 'I', reformers = {'RAlt'}}}, down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
    --{combos = {{key = 'I', reformers = {'RCtrl'}}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
    --{combos = {{key = 'I', reformers = {'RShift'}}}, down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
    --{combos = {{key = 'O'}}, down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},
    {combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
    {combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
    {combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
    --{combos = {{key = ';', reformers = {'RShift'}}}, pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
    --{combos = {{key = '.', reformers = {'RShift'}}}, pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
    --{combos = {{key = ',', reformers = {'RShift'}}}, pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
    --{combos = {{key = '/', reformers = {'RShift'}}}, pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
    --{combos = {{key = '='}}, down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
    --{combos = {{key = '-'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
    --{combos = {{key = '-', reformers = {'RCtrl'}}}, down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
    --{combos = {{key = '=', reformers = {'RCtrl'}}}, down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
    --{combos = {{key = '=', reformers = {'RAlt'}}}, pressed = iCommandPlaneIncreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Increase'), category = _('Sensors')},
    --{combos = {{key = '-', reformers = {'RAlt'}}}, pressed = iCommandPlaneDecreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Decrease'), category = _('Sensors')},
    {combos = {{key = 'R', reformers = {'RShift'}}}, down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
    {combos = {{key = ',', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
    {combos = {{key = '.', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},

    -- Weapons                                                                        
    {combos = {{key = '1'}}, down = Keys.Station1, name = _('Armament: Station 1 Enable/Disable'), category = _('Weapons')},
    {combos = {{key = '2'}}, down = Keys.Station2, name = _('Armament: Station 2 Enable/Disable'), category = _('Weapons')},
    {combos = {{key = '3'}}, down = Keys.Station3, name = _('Armament: Station 3 Enable/Disable'), category = _('Weapons')},
    {combos = {{key = '4'}}, down = Keys.Station4, name = _('Armament: Station 4 Enable/Disable'), category = _('Weapons')},
    {combos = {{key = '5'}}, down = Keys.Station5, name = _('Armament: Station 5 Enable/Disable'), category = _('Weapons')},

    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.0,  name = _('Function Selector: OFF'),             category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.1,  name = _('Function Selector: ROCKETS'),         category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.2,  name = _('Function Selector: GM UNARM'),        category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.3,  name = _('Function Selector: SPRAY TANK'),      category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.4,  name = _('Function Selector: LABS'),            category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},
    {down = device_commands.arm_func_selector,  cockpit_device_id = devices.WEAPON_SYSTEM, value_down = 0.5,  name = _('Function Selector: BOMBS & GM ARM'),  category = {_('Instrument Panel'), _('Armament Panel'), _('Weapons')}},

    {combos = {{key = '7'}}, down = Keys.ArmsFuncSelectorCCW, name = _('Armament: Function Selector: CCW'), category = _('Weapons')},
    {combos = {{key = '8'}}, down = Keys.ArmsFuncSelectorCW, name = _('Armament: Function Selector: CW'), category = _('Weapons')},

    {combos = {{key = '9'}}, down = Keys.GunsReadyToggle, name = _('Armament: Guns READY/SAFE Toggle'), category = _('Weapons')},
    {combos = {{key = '0'}}, down = Keys.MasterArmToggle, name = _('Armament: Master Arm Toggle'), category = _('Weapons')},

    {down = Keys.GunpodCharge, name = _('GunPods: OFF/CHARGE/CLEAR Toggle'), category = _('Weapons')},
    {down = Keys.GunpodLeft, name = _('GunPods: Left Enable/Disable'), category = _('Weapons')},
    {down = Keys.GunpodCenter, name = _('GunPods: Center Enable/Disable'), category = _('Weapons')},
    {down = Keys.GunpodRight, name = _('GunPods: Right Enable/Disable'), category = _('Weapons')},

    --{combos = {{key = 'H', reformers = {'RShift'}}}, down = iCommandPlaneHUDFilterOnOff, name = _('HUD Filter On Off'), category = _('Weapons')},
    --{down = iCommandPlaneRightMFD_OSB1 , name = _('MFD HUD Repeater Mode On Off'), category = {_('Systems')}},


    --
    -- ADD NEW/CUSTOM COMMANDS for A-4E HERE:
    --

    --{combos = {{key = 'S', reformers = {'LShift'}}},down = Keys.SpoilerCoverToggle, name = _('Spoilers Switch Cover: Toggle'), category = {_('Systems')}},
    {combos = {{key = 'S'}}, down = Keys.SpoilersArmToggle, name = _('Spoilers ARM-OFF Toggle'), category = {_('Systems')}},
    {down = Keys.SpoilersArmOn, name = _('Spoilers ARM-OFF: ON'), category = {_('Systems')}},
    {down = Keys.SpoilersArmOff, name = _('Spoilers ARM-OFF: OFF'), category = {_('Systems')}},


    {combos = {{key = '-', reformers = {'RShift'}}}, down = Keys.AltPressureDec, name = _('Altimeter Pressure Decrease'), category = {_('Systems')}},
    {combos = {{key = '=', reformers = {'RShift'}}}, down = Keys.AltPressureInc, name = _('Altimeter Pressure Increase'), category = {_('Systems')}},

    {combos = {{key = '-', reformers = {'RCtrl'}}}, down = Keys.RadarAltWarningDown, name = _('Radar Altitude Warning: Lower'), category = {_('Systems')}},
    {combos = {{key = '=', reformers = {'RCtrl'}}}, down = Keys.RadarAltWarningUp, name = _('Radar Altitude Warning: Raise'), category = {_('Systems')}},

    {down = device_commands.bdhi_mode, value_down = 1, cockpit_device_id = devices.NAV, name = _('BDHI - NAV CMPTR'), category = _('Navigation')},
    {down = device_commands.bdhi_mode, value_down = 0, cockpit_device_id = devices.NAV, name = _('BDHI - TACAN'), category = _('Navigation')},
    {down = device_commands.bdhi_mode, value_down = -1, cockpit_device_id = devices.NAV, name = _('BDHI - NAV PAC'), category = _('Navigation')},

    {down = device_commands.arm_bomb, value_down = 1, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('BOMB ARM - NOSE & TAIL'), category = {_('Weapons')}},
    {down = device_commands.arm_bomb, value_down = 0, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('BOMB ARM - OFF'), category = {_('Weapons')}},
    {down = device_commands.arm_bomb, value_down = -1, cockpit_device_id = devices.WEAPON_SYSTEM, name = _('BOMB ARM - TAIL'), category = {_('Weapons')}},

    {down = Keys.FuelGaugeExt, name = _('Misc Switches: Fuel Gauge EXT'), category = {_('Systems')}},
    {down = Keys.FuelGaugeInt, name = _('Misc Switches: Fuel Gauge INT'), category = {_('Systems')}},

    -- NAV SYSTEM
    -- fake/shortcuts
    {combos = {{key = '0', reformers = {'LCtrl'}}}, down = Keys.NavReset, name = _('Reset Both TCN & NDB Channels'), category = {_('Systems')}},
    --{combos = {{key = '-', reformers = {'LAlt'}}}, down = Keys.NavTCNPrev, name = _('TACAN Channel: Previous'), category = {_('Systems')}},
    --{combos = {{key = '=', reformers = {'LAlt'}}}, down = Keys.NavTCNNext, name = _('TACAN Channel: Next'), category = {_('Systems')}},
    {combos = {{key = '-', reformers = {'LCtrl'}}}, down = Keys.NavNDBPrev, name = _('NDB Channel: Previous'), category = {_('Systems')}},
    {combos = {{key = '=', reformers = {'LCtrl'}}}, down = Keys.NavNDBNext, name = _('NDB Channel: Next'), category = {_('Systems')}},
    {combos = {{key = '-', reformers = {'LShift'}}}, down = Keys.NavILSPrev, name = _('ILS Channel: Previous'), category = {_('Systems')}},
    {combos = {{key = '=', reformers = {'LShift'}}}, down = Keys.NavILSNext, name = _('ILS Channel: Next'), category = {_('Systems')}},

    -- real nav system
    {down = Keys.NavPPosLatInc, name = _('Present Position Latitude - Increase'), category = _('Navigation')},
    {down = Keys.NavPPosLatDec, name = _('Present Position Latitude - Decrease'), category = _('Navigation')},
    {down = Keys.NavPPosLonInc, name = _('Present Position Longitude - Increase'), category = _('Navigation')},
    {down = Keys.NavPPosLonDec, name = _('Present Position Longitude - Decrease'), category = _('Navigation')},
    {down = Keys.NavDestLatInc, name = _('Destination Latitude - Increase'), category = _('Navigation')},
    {down = Keys.NavDestLatDec, name = _('Destination Latitude - Decrease'), category = _('Navigation')},
    {down = Keys.NavDestLonInc, name = _('Destination Longitude - Increase'), category = _('Navigation')},
    {down = Keys.NavDestLonDec, name = _('Destination Longitude - Decrease'), category = _('Navigation')},

    {down = Keys.NavDopplerOff, name = _('Nav Doppler - OFF'), category = _('Navigation')},
    {down = Keys.NavDopplerStandby, name = _('Nav Doppler - STBY'), category = _('Navigation')},
    {down = Keys.NavDopplerLand, name = _('Nav Doppler - ON:LAND'), category = _('Navigation')},
    {down = Keys.NavDopplerSea, name = _('Nav Doppler - ON:SEA'), category = _('Navigation')},
    {down = Keys.NavDopplerTest, name = _('Nav Doppler - TEST'), category = _('Navigation')},
    {down = Keys.NavDopplerCW, name = _('Nav Doppler - clockwise'), category = _('Navigation')},
    {down = Keys.NavDopplerCCW, name = _('Nav Doppler - counter-clockwise'), category = _('Navigation')},

    {down = Keys.NavSelectTest, name = _('Nav Select - TEST'), category = _('Navigation')},
    {down = Keys.NavSelectOff, name = _('Nav Select - OFF'), category = _('Navigation')},
    {down = Keys.NavSelectStandby, name = _('Nav Select - STBY'), category = _('Navigation')},
    {down = Keys.NavSelectD1, name = _('Nav Select - D1'), category = _('Navigation')},
    {down = Keys.NavSelectD2, name = _('Nav Select - D2'), category = _('Navigation')},
    {down = Keys.NavSelectCW, name = _('Nav Select - clockwise'), category = _('Navigation')},
    {down = Keys.NavSelectCCW, name = _('Nav Select - counter-clockwise'), category = _('Navigation')},

    -- APG-53A Radar commands
    {down = Keys.RadarModeOFF, name = _('Radar Mode: OFF'), category = _('Radar')},
    {down = Keys.RadarModeSTBY, name = _('Radar Mode: Standby'), category = _('Radar')},
    {down = Keys.RadarModeSearch, name = _('Radar Mode: Search'), category = _('Radar')},
    {down = Keys.RadarModeTC, name = _('Radar Mode: Terrain Clearance'), category = _('Radar')},
    {down = Keys.RadarModeA2G, name = _('Radar Mode: A2G'), category = _('Radar')},
    {down = Keys.RadarMode, name = _('Radar Mode Cycle'), category = _('Radar')},
    {down = Keys.RadarModeCW, name = _('Radar Mode CW'), category = _('Radar')},
    {down = Keys.RadarModeCCW, name = _('Radar Mode CCW'), category = _('Radar')},

    {down = Keys.RadarTCPlanProfile, value_down = 1, name = _('Radar Terrain Clearance: Plan'), category = _('Radar')},
    {down = Keys.RadarTCPlanProfile, value_down = 0, name = _('Radar Terrain Clearance: Profile'), category = _('Radar')},
    {down = Keys.RadarTCPlanProfile, value_down = -1, name = _('Radar Terrain Clearance Toggle'), category = _('Radar')},

    {down = Keys.RadarRangeLongShort, value_down = 1, name = _('Radar Range: Long'), category = _('Radar')},
    {down = Keys.RadarRangeLongShort, value_down = 0, name = _('Radar Range: Short'), category = _('Radar')},
    {down = Keys.RadarRangeLongShort, value_down = -1, name = _('Radar Range Toggle'), category = _('Radar')},

    {down = Keys.RadarAoAComp, value_down = 1, name = _('Radar AoA Compensation: ON'), category = _('Radar')},
    {down = Keys.RadarAoAComp, value_down = 0, name = _('Radar AoA Compensation: OFF'), category = _('Radar')},
    {down = Keys.RadarAoAComp, value_down = -1, name = _('Radar AoA Compensation Toggle'), category = _('Radar')},

    {down = Keys.RadarVolume, value_down = 1, name = _('Radar Warning Volume: Increase'), category = _('Radar')},
    {down = Keys.RadarVolume, value_down = 0, name = _('Radar Warning Volume: Decrease'), category = _('Radar')},

    -- Interior Lights Panel
    {down = device_commands.intlight_whiteflood_CHANGE,     cockpit_device_id = devices.AVIONICS,  value_down = 0.1,     name = _('Interior Lights: White Floodlight Increase'),      category = {_('Right Console'), _('INT LTS Panel')}},
    {down = device_commands.intlight_whiteflood_CHANGE,     cockpit_device_id = devices.AVIONICS,  value_down = -0.1,    name = _('Interior Lights: White Floodlight Decrease'),      category = {_('Right Console'), _('INT LTS Panel')}},
    {down = device_commands.intlight_instruments_CHANGE,    cockpit_device_id = devices.AVIONICS,  value_down = 0.1,     name = _('Interior Lights: Instrument Lights Increase'),     category = {_('Right Console'), _('INT LTS Panel')}},
    {down = device_commands.intlight_instruments_CHANGE,    cockpit_device_id = devices.AVIONICS,  value_down = -0.1,    name = _('Interior Lights: Instrument Lights Decrease'),     category = {_('Right Console'), _('INT LTS Panel')}},
    {down = device_commands.intlight_console_CHANGE,        cockpit_device_id = devices.AVIONICS,  value_down = 0.1,     name = _('Interior Lights: Console Lights Increase'),        category = {_('Right Console'), _('INT LTS Panel')}},
    {down = device_commands.intlight_console_CHANGE,        cockpit_device_id = devices.AVIONICS,  value_down = -0.1,    name = _('Interior Lights: Console Lights Decrease'),        category = {_('Right Console'), _('INT LTS Panel')}},

    -- lighting keys

    {down = Keys.ExtLightProbe, value_down = 1, name = _('Refueling Probe Light: BRIGHT'), category = {_('Systems')}},
    {down = Keys.ExtLightProbe, value_down = -1, name = _('Refueling Probe Light: DIM'), category = {_('Systems')}},
    {down = Keys.ExtLightProbe, value_down = 0, name = _('Refueling Probe Light: OFF'), category = {_('Systems')}},
    {down = Keys.ExtLightProbeCycle, name = _('Refueling Probe Light: BRIGHT/DIM/OFF'), category = {_('Systems')}},

    {down = Keys.ExtLightTaxi, value_down = 1, name = _('Taxi Light: ON'), category = {_('Systems')}},
    {down = Keys.ExtLightTaxi, value_down = 0, name = _('Taxi Light: OFF'), category = {_('Systems')}},
    {down = Keys.ExtLightTaxiToggle, name = _('Taxi Light: ON/OFF'), category = {_('Systems')}},

    {down = Keys.ExtLightAnticollision, value_down = 1, name = _('Anti-collision Lights: ON'), category = {_('Systems')}},
    {down = Keys.ExtLightAnticollision, value_down = 0, name = _('Anti-collision Lights: OFF'), category = {_('Systems')}},
    {down = Keys.ExtLightAnticollisionToggle, name = _('Anti-collision Lights: ON/OFF'), category = {_('Systems')}},

    {down = Keys.ExtLightNav, value_down = 1, name = _('Navigation Lights: BRIGHT'), category = {_('Systems')}},
    {down = Keys.ExtLightNav, value_down = -1, name = _('Navigation Lights: DIM'), category = {_('Systems')}},
    {down = Keys.ExtLightNav, value_down = 0, name = _('Navigation Lights: OFF'), category = {_('Systems')}},
    {down = Keys.ExtLightNavCycle, name = _('Navigation Lights: BRIGHT/DIM/OFF'), category = {_('Systems')}},

    {down = Keys.ExtLightTail, value_down = 1, name = _('Tail Light: BRIGHT'), category = {_('Systems')}},
    {down = Keys.ExtLightTail, value_down = -1, name = _('Tail Light: DIM'), category = {_('Systems')}},
    {down = Keys.ExtLightTail, value_down = 0, name = _('Tail Light: OFF'), category = {_('Systems')}},
    {down = Keys.ExtLightTailCycle, name = _('Tail Light: BRIGHT/DIM/OFF'), category = {_('Systems')}},

    {down = Keys.ExtLightFuselage, value_down = 1, name = _('Fuselage Lights: BRIGHT'), category = {_('Systems')}},
    {down = Keys.ExtLightFuselage, value_down = -1, name = _('Fuselage Lights: DIM'), category = {_('Systems')}},
    {down = Keys.ExtLightFuselage, value_down = 0, name = _('Fuselage Lights: OFF'), category = {_('Systems')}},
    {down = Keys.ExtLightFuselageCycle, name = _('Fuselage Lights: BRIGHT/DIM/OFF'), category = {_('Systems')}},

    {down = Keys.ExtLightFlashSteady, value_down = 1, name = _('Exterior Lights: FLASH'), category = {_('Systems')}},
    {down = Keys.ExtLightFlashSteady, value_down = 0, name = _('Exterior Lights: STEADY'), category = {_('Systems')}},
    {down = Keys.ExtLightFlashSteadyToggle, name = _('Exterior Lights: FLASH/STEADY'), category = {_('Systems')}},

    {down = Keys.AFCSOverride, name = _('AFCS Override (emergency)'), category = 'Autopilot'},
    {down = Keys.AFCSStandbyToggle, name = _('AFCS Standby Toggle'), category = 'Autopilot'},
    {down = Keys.AFCSEngageToggle, name = _('AFCS Engage Toggle'), category = 'Autopilot'},
    {down = Keys.AFCSAltitudeToggle, name = _('AFCS Altitude Toggle'), category = 'Autopilot'},
    {down = Keys.AFCSHeadingToggle, name = _('AFCS Heading Toggle'), category = 'Autopilot'},
    {down = Keys.AFCSHeadingInc, name = _('AFCS Heading Increment'), category = 'Autopilot'},
    {down = Keys.AFCSHeadingDec, name = _('AFCS Heading Decrement'), category = 'Autopilot'},
    {down = Keys.AFCSHotasPath, name = _('AFCS Path Mode'), category = 'Autopilot'},
    {down = Keys.AFCSHotasAltHdg, name = _('AFCS Altitude + Heading Modes'), category = 'Autopilot'},
    {down = Keys.AFCSHotasAlt, name = _('AFCS Altitude Mode'), category = 'Autopilot'},
    {down = Keys.AFCSHotasEngage, name = _('AFCS Engage'), category = 'Autopilot'},

    -- APC
    {down = Keys.APCEngageStbyOff, value_down = -1, name = _('APC: POWER - OFF'), category = _('APC Control Panel')},
    {down = Keys.APCEngageStbyOff, value_down = 0, name = _('APC: POWER - STBY'), category = _('APC Control Panel')},
    {down = Keys.APCEngageStbyOff, value_down = 1, name = _('APC: POWER - ENGAGE'), category = _('APC Control Panel')},
    {down = Keys.APCHotStdCold, value_down = -1, name = _('APC: TEMP - COLD'), category = _('APC Control Panel')},
    {down = Keys.APCHotStdCold, value_down = 0, name = _('APC: TEMP - STD'), category = _('APC Control Panel')},
    {down = Keys.APCHotStdCold, value_down = 1, name = _('APC: TEMP - HOT'), category = _('APC Control Panel')},

    -- PID tuning
    {down = Keys.Tune1, value_down = 0.1, name = _('Tune1: +0.1'), category = _('Debug')},
    {down = Keys.Tune1, value_down = -0.1, name = _('Tune1: -0.1'), category = _('Debug')},
    {down = Keys.Tune2, value_down = 0.1, name = _('Tune2: +0.1'), category = _('Debug')},
    {down = Keys.Tune2, value_down = -0.1, name = _('Tune2: -0.1'), category = _('Debug')},
    {down = Keys.Tune3, value_down = 0.1, name = _('Tune3: +0.1'), category = _('Debug')},
    {down = Keys.Tune3, value_down = -0.1, name = _('Tune3: -0.1'), category = _('Debug')},
	
		-- Used for the new Carrier logic
	  {combos = {{key = '1', reformers = {'LAlt'}}},  down = Keys.catapult_ready, value_down = 1.0, value_up = 0.0, name = _('Catapult Ready'), category = _('Catapult')},
	  {combos = {{key = '2', reformers = {'LAlt'}}},  down = Keys.catapult_shoot, value_down = 1.0, value_up = 0.0, name = _('Catapult Shoot'), category = _('Catapult')},
	  {combos = {{key = '3', reformers = {'LAlt'}}},  down = Keys.catapult_abort, value_down = 1.0, value_up = 0.0, name = _('Catapult Abort'), category = _('Catapult')},
  
    -- Weapon/CMDS Adjustment
    {combos = {{key = '2', reformers = {'RShift','RAlt'}}},		down = Keys.ChangeCBU2AQuantity,		value_down = 1,	name = _('Change CBU-2/A Release Quantity - 1/2/3'),		category = _('Ground Adjustment')},
    {combos = {{key = '3', reformers = {'RShift','RAlt'}}},		down = Keys.ChangeCBU2BAQuantity,		value_down = 1,	name = _('Change CBU-2B/A Release Quantity - 1/2/3/4/6/SALVO'),		category = _('Ground Adjustment')},
    {combos = {{key = '4', reformers = {'RShift','RAlt'}}},		down = Keys.ChangeCmsBursts,		value_down = 1,	name = _('Change Countermeasures Bursts'),		category = _('Ground Adjustment')},
    {combos = {{key = '5', reformers = {'RShift','RAlt'}}},		down = Keys.ChangeCmsBurstInterval,		value_down = 1,	name = _('Change Countermeasures Burst Interval'),		category = _('Ground Adjustment')},
    {combos = {{key = '6', reformers = {'RShift','RAlt'}}},		down = Keys.ChangeCmsSalvos,		value_down = 1,	name = _('Change Countermeasures Salvos'),		category = _('Ground Adjustment')},
    {combos = {{key = '7', reformers = {'RShift','RAlt'}}},		down = Keys.ChangeSalvoInterval,		value_down = 1,	name = _('Change Countermeasures Salvo Interval'),		category = _('Ground Adjustment')},
	
		-- used for RWR
    {down = Keys.ecm_apr25_off, value_down = 1.0,value_up = 0.0, name = _('APR/25 on/off toggle'), category = _('ECM Panel')},
  
    --NightVision
    {combos = {{key = 'H', reformers = {'RShift'}}}        , down = iCommandViewNightVisionGogglesOn   , name = _('Night Vision Goggle - Toggle'), category = _('Sensors')},
    {combos = {{key = 'H', reformers = {'RShift','RCtrl'}}}, down = iCommandPlane_Helmet_Brightess_Up  , name = _('Goggle Gain - Inc'), category = _('Sensors')},
    {combos = {{key = 'H', reformers = {'RShift','RAlt'}}} , down = iCommandPlane_Helmet_Brightess_Down, name = _('Goggle Gain - Dec'), category = _('Sensors')},
	
})
return res