dofile(LockOn_Options.script_path.."VR_config.lua")

shape_name   	   = "Cockpit_A-4E"
is_EDM			   = true
new_model_format   = true
ambient_light    = {255,255,255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60 ,150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels	 = {35, 25, 25}

dusk_border					 = 0.4
draw_pilot					 = false

external_model_canopy_arg	 = 38

use_external_views = false

day_texture_set_value   = 0.0
night_texture_set_value = 0.1

local controllers = LoRegisterPanelControls()

mirrors_data =
{
    center_point 	= {0.47,0.06,0.00},
    width 		 	= 1.4, --1.2,
    aspect 		 	= 1.5,
	rotation 	 	= math.rad(-10);
	animation_speed = 2.0;
	near_clip 		= 0.1;
	middle_clip		= 10;
	far_clip		= 60000;
}

mirrors_draw                    = CreateGauge()
mirrors_draw.arg_number    		= 16
mirrors_draw.input   			= {0,1}
mirrors_draw.output   			= {1,0}
mirrors_draw.controller         = controllers.mirrors_draw

Canopy    						= CreateGauge()
Canopy.arg_number 				= 26
Canopy.input   					= {0,1}
Canopy.output  					= {0,0.9}
Canopy.controller 				= controllers.base_gauge_CanopyPos
--CockpitCanopy.controller		= controllers.CockpitCanopy

CanopyLever    						= CreateGauge()
CanopyLever.arg_number 				= 129
CanopyLever.input   				= {0, 0.1, 0.9}
CanopyLever.output  				= {1, 0.4, 0.0}
CanopyLever.controller 				= controllers.base_gauge_CanopyPos

StickPitch							= CreateGauge("parameter")
StickPitch.arg_number				= 2
StickPitch.input					= {-1, 1}
StickPitch.output					= {-1, 1}
--StickPitch.controller				= controllers.base_gauge_StickPitchPosition
StickPitch.parameter_name				= "STICK_PITCH"

StickBank							= CreateGauge("parameter")
StickBank.arg_number				= 3
StickBank.input						= {-1, 1}
StickBank.output					= {-1, 1}
--StickBank.controller				= controllers.base_gauge_StickRollPosition
StickBank.parameter_name				= "STICK_ROLL"

RudderPedals						= CreateGauge("parameter")
RudderPedals.arg_number				= 4
RudderPedals.input					= {-1,1}
RudderPedals.output					= {-1,1}
--RudderPedals.controller				= controllers.base_gauge_RudderPosition
RudderPedals.parameter_name				= "RUDDER_PEDALS"

LeftBrakePedal						= CreateGauge("parameter")
LeftBrakePedal.arg_number			= 5
LeftBrakePedal.input				= {-1,1}
LeftBrakePedal.output				= {0,1}
LeftBrakePedal.parameter_name		= "LEFT_BRAKE_PEDAL"

RightBrakePedal						= CreateGauge("parameter")
RightBrakePedal.arg_number			= 6
RightBrakePedal.input				= {-1,1}
RightBrakePedal.output				= {0,1}
RightBrakePedal.parameter_name		= "RIGHT_BRAKE_PEDAL"

Throttle							= CreateGauge("parameter")
Throttle.arg_number					= 80
Throttle.input						= {-1, 1}
Throttle.output						= {-1, 1}
--Throttle.controller					= controllers.base_gauge_ThrottleLeftPosition
Throttle.parameter_name				= "THROTTLE_POSITION"

Landinggearhandle					= CreateGauge()
Landinggearhandle.arg_number		= 8
Landinggearhandle.input				= {0, 1}
Landinggearhandle.output			= {0, 1}
Landinggearhandle.controller		= controllers.gear_handle_animation

PitchTrim							= CreateGauge("parameter")
PitchTrim.arg_number				= 870
PitchTrim.input						= {-3, 13}
PitchTrim.output					= {-0.25, 1}
PitchTrim.parameter_name			= "PITCH_TRIM_GAUGE"

RollTrim							= CreateGauge("parameter")
RollTrim.arg_number					= 871
RollTrim.input						= {-1, 1}
RollTrim.output						= {-1, 1}
RollTrim.parameter_name				= "YAW_TRIM_GAUGE"

PitchTrimKnob							= CreateGauge("parameter")
PitchTrimKnob.arg_number				= 28
PitchTrimKnob.input						= {-1, 1}
PitchTrimKnob.output					= {1, -1} -- inverted
PitchTrimKnob.parameter_name			= "PITCH_TRIM_KNOB"

RollTrimKnob							= CreateGauge("parameter")
RollTrimKnob.arg_number					= 29
RollTrimKnob.input						= {-1, 1}
RollTrimKnob.output						= {-1, 1}
RollTrimKnob.parameter_name				= "ROLL_TRIM_KNOB"

---------------------------------------------------------------
-- ENGINE
---------------------------------------------------------------
Engine_RPM                          = CreateGauge("parameter")
Engine_RPM.arg_number               = 520
Engine_RPM.input                    = {0.0, 103.0}
Engine_RPM.output                   = {0.0, 1.0}
Engine_RPM.parameter_name           = "RPM"

Engine_RPMsub                       = CreateGauge("parameter")
Engine_RPMsub.arg_number            = 521
Engine_RPMsub.input                 = {0.0, 1.0}
Engine_RPMsub.output                = {0.0, 1.0}
Engine_RPMsub.parameter_name        = "RPM_DECI"

CM_bank1_Xx                         = CreateGauge("parameter")
CM_bank1_Xx.arg_number              = 526
CM_bank1_Xx.input                   = {0.0, 1.0}
CM_bank1_Xx.output                  = {0.0, 1.0}
CM_bank1_Xx.parameter_name          = "CM_BANK1_Xx"

CM_bank1_xX                         = CreateGauge("parameter")
CM_bank1_xX.arg_number              = 527
CM_bank1_xX.input                   = {0.0, 1.0}
CM_bank1_xX.output                  = {0.0, 1.0}
CM_bank1_xX.parameter_name          = "CM_BANK1_xX"

CM_bank2_Xx                         = CreateGauge("parameter")
CM_bank2_Xx.arg_number              = 528
CM_bank2_Xx.input                   = {0.0, 1.0}
CM_bank2_Xx.output                  = {0.0, 1.0}
CM_bank2_Xx.parameter_name          = "CM_BANK2_Xx"

CM_bank2_xX                         = CreateGauge("parameter")
CM_bank2_xX.arg_number              = 529
CM_bank2_xX.input                   = {0.0, 1.0}
CM_bank2_xX.output                  = {0.0, 1.0}
CM_bank2_xX.parameter_name          = "CM_BANK2_xX"

EGT                                 = CreateGauge("parameter")
EGT.arg_number                      = 540
EGT.input                           = {0, 1000}
EGT.output                          = {0.0, 1.0}
EGT.parameter_name                  = "EGT_C"

local lb_to_kg = 0.453592


Engine_Fuel_Flow                    = CreateGauge("parameter")
Engine_Fuel_Flow.arg_number         = 560
Engine_Fuel_Flow.input              = {0, 300*lb_to_kg/3600, 1000*lb_to_kg/3600, 5000*lb_to_kg/3600, 15000*lb_to_kg/3600} --1000 lb/min => kg/s
Engine_Fuel_Flow.output             = {0.0, 0.01, 0.15, 0.75, 1.00}
Engine_Fuel_Flow.parameter_name     = "D_FUEL_FLOW"

OilPressure                         = CreateGauge("parameter")
OilPressure.arg_number              = 152
OilPressure.input                   = {0.0, 100.0}  --psi
OilPressure.output                  = {0.0, 1.0}
OilPressure.parameter_name          = "OIL_PRESSURE"

PressureRatio                       = CreateGauge("parameter")
PressureRatio.arg_number            = 151
PressureRatio.input                 = {1.2, 3.4}
PressureRatio.output                = {0.0, 1.0}
PressureRatio.parameter_name        = "PRESSURE_RATIO"

ManualFuelControl_Warn                       = CreateGauge("parameter")
ManualFuelControl_Warn.arg_number            = 105
ManualFuelControl_Warn.input                 = {0.0, 1.0}
ManualFuelControl_Warn.output                = {0.0, 1.0}
ManualFuelControl_Warn.parameter_name        = "MANUAL_FUEL_CONTROL_WARN"

---------------------------------------------------------------
-- INSTRUMENTS
---------------------------------------------------------------

FlapsIndicator                  = CreateGauge("parameter")
FlapsIndicator.arg_number       = 23
FlapsIndicator.parameter_name   = "D_FLAPS_IND"
FlapsIndicator.input            = {0.0, 1.0}    -- percentage down relative to travel limits
FlapsIndicator.output           = {0.0, 0.95}

--[[
TailhookLever                  = CreateGauge("parameter")
TailhookLever.arg_number       = 10
TailhookLever.parameter_name   = "D_TAIL_HOOK"
TailhookLever.input            = {0.0, 1.0}
TailhookLever.output           = {0.0, 1.0}
]]--

GearNose                        = CreateGauge("parameter")
GearNose.arg_number             = 20
GearNose.parameter_name         = "GEAR_NOSE"
GearNose.input                  = {0.0, 1.0}
GearNose.output                 = {0.0, 1.0}

GearLeft                        = CreateGauge("parameter")
GearLeft.arg_number             = 21
GearLeft.parameter_name         = "GEAR_LEFT"
GearLeft.input                  = {0.0, 1.0}
GearLeft.output                 = {0.0, 1.0}

GearRight                       = CreateGauge("parameter")
GearRight.arg_number            = 22
GearRight.parameter_name        = "GEAR_RIGHT"
GearRight.input                 = {0.0, 1.0}
GearRight.output                = {0.0, 1.0}

GearLight                       = CreateGauge("parameter")
GearLight.arg_number            = 27
GearLight.parameter_name        = "GEAR_LIGHT"
GearLight.input                 = {0.0, 1.0}
GearLight.output                = {0.0, 1.0}

HideStick                       = CreateGauge("parameter")
HideStick.arg_number            = 153
HideStick.parameter_name        = "HIDE_STICK"
HideStick.input                 = {0.0, 1.0}
HideStick.output                = {0.0, 1.0}

FuelGauge                       = CreateGauge("parameter")
FuelGauge.arg_number            = 580
FuelGauge.parameter_name        = "D_FUEL"
FuelGauge.input                 = {0.0, 6600.0} -- pounds
FuelGauge.output                = {0.0, 1.0}

StandbyAttHorizon						= CreateGauge("parameter")
StandbyAttHorizon.arg_number		   	= 665
StandbyAttHorizon.parameter_name        = "ATTGYRO_STBY_HORIZ"
StandbyAttHorizon.input					= {-1.0, 1.0}
StandbyAttHorizon.output 				= {-1.0, 1.0}

IASGauge             			= CreateGauge("parameter")
IASGauge.parameter_name         = "D_IAS_DEG"
IASGauge.arg_number	            = 880
IASGauge.input			        = {0.0, 360.0}  -- rotation in degrees, calibration in avionics.lua
IASGauge.output		            = {0.0, 1.0}

MachDisc						= CreateGauge("parameter")
MachDisc.arg_number		    	= 881
MachDisc.parameter_name         = "D_IAS_MACH_DEG"
MachDisc.input					= {0.0, 360.0} -- rotation in degrees, calibration in avionics.lua
MachDisc.output 				= {0.0, 1.0}

IASIndex						= CreateGauge("parameter")
IASIndex.arg_number		    	= 882
IASIndex.parameter_name         = "D_IAS_IDX"
IASIndex.input					= {0.0, 1.0}
IASIndex.output 				= {0.0, 1.0}

MachIndex						= CreateGauge("parameter")
MachIndex.arg_number		    = 883
MachIndex.parameter_name        = "D_MACH_IDX"
MachIndex.input					= {0.0, 1.0}
MachIndex.output 				= {0.0, 1.0}

local ft_to_meter = 0.3048

RadarAltimeter					= CreateGauge("parameter")
RadarAltimeter.arg_number		= 600
RadarAltimeter.input			= {0.0,  100,  150,  200,  400,  600, 1000, 2000, 5000, 6000}  --m/s
RadarAltimeter.output			= {0.0, 0.25, 0.30, 0.35, 0.45, 0.55, 0.65, 0.80, 0.95, 1.00} -- from 0.95 to 1 (above 5000') the need is behind the mask
RadarAltimeter.parameter_name   = "D_RADAR_ALT"

LAWS_indexer					= CreateGauge("parameter")
LAWS_indexer.arg_number		= 601
LAWS_indexer.input			= {0.0, 100, 150, 200, 400, 600, 1000, 2000, 5000}  --m/s
LAWS_indexer.output			= {0.0, 0.25, 0.30, 0.35, 0.45, 0.55, 0.65, 0.80, 1.0}
LAWS_indexer.parameter_name   = "D_RADAR_IDX"

LAWS_OFF					= CreateGauge("parameter")
LAWS_OFF.arg_number		= 604
LAWS_OFF.input			= {0.0, 1.0}
LAWS_OFF.output			= {0.0, 1.0}
LAWS_OFF.parameter_name   = "D_RADAR_OFF"

LAWS_light_gauge					= CreateGauge("parameter")
LAWS_light_gauge.arg_number		= 605
LAWS_light_gauge.input			= { 0.0, 1.0}
LAWS_light_gauge.output			= {0.0, 0.6}
LAWS_light_gauge.parameter_name   = "D_RADAR_WARN"

Oil_light_gauge                      = CreateGauge("parameter")
Oil_light_gauge.arg_number           = 150
Oil_light_gauge.input                = {0.0, 1.0}
Oil_light_gauge.output               = {0.0, 1.0}
Oil_light_gauge.parameter_name       = "D_OIL_LOW"

INDICATOR_BRIGHTNESS                      = CreateGauge("parameter")
INDICATOR_BRIGHTNESS.arg_number           = 856
INDICATOR_BRIGHTNESS.input                = {0.0, 1.0}
INDICATOR_BRIGHTNESS.output               = {0.0, 1.0}
INDICATOR_BRIGHTNESS.parameter_name       = "D_INDICATOR_BRIGHTNESS"

AOA_BRIGHTNESS                      = CreateGauge("parameter")
AOA_BRIGHTNESS.arg_number           = 857
AOA_BRIGHTNESS.input                = {0.0, 1.0}
AOA_BRIGHTNESS.output               = {0.001, 0.6}
AOA_BRIGHTNESS.parameter_name       = "D_AOA_BRIGHTNESS"

Glareshield_BRIGHTNESS                      = CreateGauge("parameter")
Glareshield_BRIGHTNESS.arg_number           = 858
Glareshield_BRIGHTNESS.input                = {0.0, 1.0}
Glareshield_BRIGHTNESS.output               = {0.0, 0.1}
Glareshield_BRIGHTNESS.parameter_name       = "D_GLARE_BRIGHTNESS"

Glareshield_WHEELS                      = CreateGauge("parameter")
Glareshield_WHEELS.arg_number           = 154
Glareshield_WHEELS.input                = {0.0, 1.0}
Glareshield_WHEELS.output               = {0.0, 1.0}
Glareshield_WHEELS.parameter_name       = "D_GLARE_WHEELS"

Glareshield_LABS					= CreateGauge("parameter")
Glareshield_LABS.arg_number		= 155
Glareshield_LABS.input			= {0.0, 1.0}
Glareshield_LABS.output			= {0.0, 1.0}
Glareshield_LABS.parameter_name   = "D_GLARE_LABS"

Glareshield_LAWS					= CreateGauge("parameter")
Glareshield_LAWS.arg_number		= 156
Glareshield_LAWS.input			= {0.0, 1.0}
Glareshield_LAWS.output			= {0.0, 1.0}
Glareshield_LAWS.parameter_name   = "D_RADAR_WARN"

Glareshield_OBST                        = CreateGauge("parameter")
Glareshield_OBST.arg_number             = 157
Glareshield_OBST.input                  = {0.0, 1.0}
Glareshield_OBST.output                 = {0.0, 1.0}
Glareshield_OBST.parameter_name         = "D_GLARE_OBST"

Glareshield_IFF                         = CreateGauge("parameter")
Glareshield_IFF.arg_number              = 158
Glareshield_IFF.input                   = {0.0, 1.0}
Glareshield_IFF.output                  = {0.0, 1.0}
Glareshield_IFF.parameter_name          = "D_GLARE_IFF"

Glareshield_FIRE                        = CreateGauge("parameter")
Glareshield_FIRE.arg_number             = 159
Glareshield_FIRE.input                  = {0.0, 1.0}
Glareshield_FIRE.output                 = {0.0, 1.0}
Glareshield_FIRE.parameter_name         = "D_GLARE_FIRE"

BDHI_Heading                        = CreateGauge("parameter")
BDHI_Heading.parameter_name         = "BDHI_HDG"
BDHI_Heading.arg_number             = 780
BDHI_Heading.input                  = {0.0, 360.0}
BDHI_Heading.output                 = {0.0, 1.0}

BDHI_Needle1                        = CreateGauge("parameter")
BDHI_Needle1.parameter_name         = "BDHI_NEEDLE1"
BDHI_Needle1.arg_number             = 781
BDHI_Needle1.input                  = {0.0, 360.0}
BDHI_Needle1.output                 = {0.0, 1.0}

BDHI_Needle2                        = CreateGauge("parameter")
BDHI_Needle2.parameter_name         = "BDHI_NEEDLE2"
BDHI_Needle2.arg_number             = 782
BDHI_Needle2.input                  = {0.0, 360.0}
BDHI_Needle2.output                 = {0.0, 1.0}

BDHI_DME_Flag                       = CreateGauge("parameter")
BDHI_DME_Flag.parameter_name        = "BDHI_DME_FLAG"
BDHI_DME_Flag.arg_number            = 786
BDHI_DME_Flag.input                 = {0, 1.0}
BDHI_DME_Flag.output                = {0, 1.0}

BDHI_DME_Xxx                        = CreateGauge("parameter")
BDHI_DME_Xxx.parameter_name         = "BDHI_DME_Xxx"
BDHI_DME_Xxx.arg_number             = 785
BDHI_DME_Xxx.input                  = {0, 1.0}
BDHI_DME_Xxx.output                 = {0, 1.00}

BDHI_DME_xXx                        = CreateGauge("parameter")
BDHI_DME_xXx.parameter_name         = "BDHI_DME_xXx"
BDHI_DME_xXx.arg_number             = 784
BDHI_DME_xXx.input                  = {0, 1.0}
BDHI_DME_xXx.output                 = {0, 1.00}

BDHI_DME_xxX                        = CreateGauge("parameter")
BDHI_DME_xxX.parameter_name         = "BDHI_DME_xxX"
BDHI_DME_xxX.arg_number             = 783
BDHI_DME_xxX.input                  = {0, 1.0}
BDHI_DME_xxX.output                 = {0, 1.00}

BDHI_ILS_GS                         = CreateGauge("parameter")
BDHI_ILS_GS.parameter_name          = "BDHI_ILS_GS"
BDHI_ILS_GS.arg_number              = 381
BDHI_ILS_GS.input                   = {-1.0, 1.0}
BDHI_ILS_GS.output                  = {-1.0, 1.0}

BDHI_ILS_LOC                        = CreateGauge("parameter")
BDHI_ILS_LOC.parameter_name         = "BDHI_ILS_LOC"
BDHI_ILS_LOC.arg_number             = 382
BDHI_ILS_LOC.input                  = {-1.0, 1.0}
BDHI_ILS_LOC.output                 = {-1.0, 1.0}

-- GAUGE #41 Altimeter
Altimeter					= CreateGauge("parameter")
Altimeter.parameter_name    = "D_ALT_NEEDLE"
Altimeter.arg_number		= 820
Altimeter.input				= {0.0, 1000.0}  -- 0 to 1000 feet
Altimeter.output			= {0.0, 1.0}

Altimeter10K				= CreateGauge("parameter")
Altimeter10K.parameter_name = "D_ALT_10K"
Altimeter10K.arg_number	    = 821
Altimeter10K.input			= {0.0, 9900, 10000, 19900, 20000, 29900, 30000, 39900, 40000, 49900, 50000, 59900, 60000, 69900, 70000, 79900, 80000, 89900, 90000, 99900, 100000.0}  -- 0 to 100,000 feet
Altimeter10K.output			= {0.0, 0.09, 0.1, 0.19, 0.2, 0.29, 0.3, 0.39, 0.4, 0.49, 0.5, 0.59, 0.6, 0.69, 0.7, 0.79, 0.8, 0.89, 0.9, 0.99, 1.0}

Altimeter1K					= CreateGauge("parameter")
Altimeter1K.parameter_name  = "D_ALT_1K"
Altimeter1K.arg_number		= 822
Altimeter1K.input			= {0.0, 10000.0}  -- 0 to 10,000 feet
Altimeter1K.output			= {0.0, 1.0}

Altimeter100s					= CreateGauge("parameter")
Altimeter100s.parameter_name    = "D_ALT_100S"
Altimeter100s.arg_number		= 823
Altimeter100s.input				= {0.0, 1000.0}  -- 0 to 1000 feet
Altimeter100s.output			= {0.0, 1.0}

AltAdjNNxx                  = CreateGauge("parameter")
AltAdjNNxx.parameter_name   = "ALT_ADJ_NNxx"
AltAdjNNxx.arg_number       = 824
AltAdjNNxx.input            = {29, 30}
AltAdjNNxx.output           = {0, 1}        -- animates from 0.500 ("29") to 0.510 ("30") / 0.0 to 0.500 = 29,

AltAdjxxNx                  = CreateGauge("parameter")
AltAdjxxNx.parameter_name   = "ALT_ADJ_xxNx"
AltAdjxxNx.arg_number       = 825
AltAdjxxNx.input            = {0, 10}
AltAdjxxNx.output           = {0, 1}        -- animates from 0.x90 ("x") to 0.x99 ("x+1")  / e.g. .200 to .290 = 2, .291 to .299 rolling, .300 = "3"

AltAdjxxxN                  = CreateGauge("parameter")
AltAdjxxxN.parameter_name   = "ALT_ADJ_xxxN"
AltAdjxxxN.arg_number       = 826
AltAdjxxxN.input            = {0, 10}
AltAdjxxxN.output           = {0, 1}        -- animates from 0.x90 ("x") to 0.x99 ("x+1")  / e.g. .200 to .290 = 2, .291 to .299 rolling, .300 = "3"

CabinAlt                    = CreateGauge("parameter")
CabinAlt.parameter_name     = "CABIN_ALT"
CabinAlt.arg_number         = 710
CabinAlt.input              = {0,50000}
CabinAlt.output             = {0,1}         -- animates from 0 at 180 degrees, through 0, to ~120 degrees for 1.0

LiquidOxygen                = CreateGauge("parameter")
LiquidOxygen.parameter_name = "LIQUID_O2"
LiquidOxygen.arg_number     = 760
LiquidOxygen.input          = {0,10}
LiquidOxygen.output         = {0,1}         -- animates from 0 at 270 degrees, through 0, to 90 degrees for 10 on the gauge

Oxygen_light_gauge                      = CreateGauge("parameter")
Oxygen_light_gauge.arg_number           = 761
Oxygen_light_gauge.input                = {0.0, 1.0}
Oxygen_light_gauge.output               = {0.0, 1.0}
Oxygen_light_gauge.parameter_name       = "D_OXYGEN_LOW"

Oxygen_flag_gauge                      = CreateGauge("parameter")
Oxygen_flag_gauge.arg_number           = 762
Oxygen_flag_gauge.input                = {0.0, 1.0}
Oxygen_flag_gauge.output               = {0.0, 1.0}
Oxygen_flag_gauge.parameter_name       = "D_OXYGEN_OFF"

Accel_cur					    = CreateGauge("parameter")
Accel_cur.arg_number		    = 360
Accel_cur.input				    = {-5, 0, 5, 10}  --G
Accel_cur.output			    = {-1.0, 0.0, 0.50, 1.0}
Accel_cur.parameter_name        = "ACCEL_CUR"

Accel_max                       = CreateGauge("parameter")
Accel_max.arg_number            = 137
Accel_max.input                 = {-5, 0, 5, 10}  --G
Accel_max.output                = {-1.0, 0.0, 0.50, 1.0}
Accel_max.parameter_name        = "ACCEL_MAX"

Accel_min                       = CreateGauge("parameter")
Accel_min.arg_number            = 138
Accel_min.input                 = {-5, 0, 5, 10}  --G
Accel_min.output                = {-1.0, 0.0, 0.50, 1.0}
Accel_min.parameter_name        = "ACCEL_MIN"

VerticalVelocity				= CreateGauge("parameter")
VerticalVelocity.arg_number		= 800
VerticalVelocity.input			= {-6000*ft_to_meter/60, -4000*ft_to_meter/60, -2000*ft_to_meter/60, -1000*ft_to_meter/60, -500*ft_to_meter/60, 0, 500*ft_to_meter/60, 1000*ft_to_meter/60, 2000*ft_to_meter/60, 4000*ft_to_meter/60, 6000*ft_to_meter/60} --1000ft/min => m/s
VerticalVelocity.output			= {-1.0, -0.80, -0.60, -0.40, -0.20, 0.0, 0.20, 0.40, 0.60, 0.80, 1.0}
VerticalVelocity.parameter_name = "VVI"

ADIPitch                        = CreateGauge("parameter")
ADIPitch.parameter_name         = "ADI_PITCH"
ADIPitch.arg_number             = 383
ADIPitch.input                  = {-180, 180}
ADIPitch.output                 = {-1, 1}

ADIRoll                         = CreateGauge("parameter")
ADIRoll.parameter_name          = "ADI_ROLL"
ADIRoll.arg_number              = 384
ADIRoll.input                   = {-180, 180}
ADIRoll.output                  = {-1, 1}

ADIHeading                      = CreateGauge("parameter")
ADIHeading.parameter_name       = "ADI_HDG"
ADIHeading.arg_number           = 385
ADIHeading.input                = {0, 360}
ADIHeading.output               = {-1, 1}

ADIOFF                          = CreateGauge("parameter")
ADIOFF.parameter_name           = "ADI_OFF"
ADIOFF.arg_number               = 387
ADIOFF.input                    = {0.0, 1.0}
ADIOFF.output                   = {0.0, 1.0}

ADISlip                          = CreateGauge("parameter")
ADISlip.parameter_name           = "ADI_SLIP"
ADISlip.arg_number               = 388
ADISlip.input                    = {-1.0, 1.0}
ADISlip.output                   = {-1.0, 1.0}

ADITurn                          = CreateGauge("parameter")
ADITurn.parameter_name           = "ADI_TURN"
ADITurn.arg_number               = 389
ADITurn.input                    = {-1.0, 1.0}
ADITurn.output                   = {-1.0, 1.0}

BackupCompass                      = CreateGauge("parameter")
BackupCompass.parameter_name       = "COMPASS_HDG"
BackupCompass.arg_number           = 148
BackupCompass.input                = {0, 360}
BackupCompass.output               = {-1, 1}

AttGyroStbyPitch                = CreateGauge("parameter")
AttGyroStbyPitch.parameter_name = "ATTGYRO_STBY_PITCH"
AttGyroStbyPitch.arg_number     = 660
AttGyroStbyPitch.input          = {-180, 180}
AttGyroStbyPitch.output         = {-1.0, 1.0}

AttGyroStbyRoll                 = CreateGauge("parameter")
AttGyroStbyRoll.parameter_name  = "ATTGYRO_STBY_ROLL"
AttGyroStbyRoll.arg_number      = 661
AttGyroStbyRoll.input           = {-180, 180}
AttGyroStbyRoll.output          = {-1.0, 1.0}

AttGyroStbyOFF                 = CreateGauge("parameter")
AttGyroStbyOFF.parameter_name  = "ATTGYRO_STBY_OFF"
AttGyroStbyOFF.arg_number      = 664
AttGyroStbyOFF.input           = {0.0, 1.0}
AttGyroStbyOFF.output          = {0.0, 1.0}

AWRSPower					= CreateGauge("parameter")
AWRSPower.arg_number		= 741
AWRSPower.input			    = {0.0, 1.0}
AWRSPower.output			= {0.0, 1.0}
AWRSPower.parameter_name    = "AWRS_POWER"


GunsightReflector					= CreateGauge("parameter")
GunsightReflector.arg_number		= 894 -- 1 is upright, 0 is lowered
GunsightReflector.input			= {0.0, 1.0}
GunsightReflector.output			= {0.0, 1.0}
GunsightReflector.parameter_name   = "D_GUNSIGHT_REFLECTOR"

Ladder_Brightness					= CreateGauge("parameter")
Ladder_Brightness.arg_number		= 859
Ladder_Brightness.input			= {0.0, 1.0}
Ladder_Brightness.output			= {0.0, 0.5}
Ladder_Brightness.parameter_name   = "D_LADDER_BRIGHTNESS"

Ladder_FuelBoostCaution					= CreateGauge("parameter")
Ladder_FuelBoostCaution.arg_number		= 860
Ladder_FuelBoostCaution.input			= {0.0, 1.0}
Ladder_FuelBoostCaution.output			= {0.0, 1.0}
Ladder_FuelBoostCaution.parameter_name   = "D_FUELBOOST_CAUTION"

Ladder_ControlHydraulicCaution					= CreateGauge("parameter")
Ladder_ControlHydraulicCaution.arg_number		= 861
Ladder_ControlHydraulicCaution.input			= {0.0, 1.0}
Ladder_ControlHydraulicCaution.output			= {0.0, 1.0}
Ladder_ControlHydraulicCaution.parameter_name   = "D_CONTHYD_CAUTION"

Ladder_UtilityHydraulicCaution					= CreateGauge("parameter")
Ladder_UtilityHydraulicCaution.arg_number		= 862
Ladder_UtilityHydraulicCaution.input			= {0.0, 1.0}
Ladder_UtilityHydraulicCaution.output			= {0.0, 1.0}
Ladder_UtilityHydraulicCaution.parameter_name   = "D_UTILHYD_CAUTION"

Ladder_FuelTransCaution					= CreateGauge("parameter")
Ladder_FuelTransCaution.arg_number		= 863
Ladder_FuelTransCaution.input			= {0.0, 1.0}
Ladder_FuelTransCaution.output			= {0.0, 1.0}
Ladder_FuelTransCaution.parameter_name   = "D_FUELTRANS_CAUTION"

Ladder_SpdBrkCaution					= CreateGauge("parameter")
Ladder_SpdBrkCaution.arg_number		= 864
Ladder_SpdBrkCaution.input			= {0.0, 1.0}
Ladder_SpdBrkCaution.output			= {0.0, 1.0}
Ladder_SpdBrkCaution.parameter_name   = "D_SPDBRK_CAUTION"

Ladder_SpoilerCaution					= CreateGauge("parameter")
Ladder_SpoilerCaution.arg_number		= 865
Ladder_SpoilerCaution.input			= {0.0, 1.0}
Ladder_SpoilerCaution.output			= {0.0, 1.0}
Ladder_SpoilerCaution.parameter_name   = "D_SPOILER_CAUTION"

Advisory_InRange					= CreateGauge("parameter")
Advisory_InRange.arg_number		= 866
Advisory_InRange.input			= {0.0, 1.0}
Advisory_InRange.output			= {0.0, 1.0}
Advisory_InRange.parameter_name   = "D_ADVISORY_INRANGE"

Advisory_SetRange					= CreateGauge("parameter")
Advisory_SetRange.arg_number		= 867
Advisory_SetRange.input			= {0.0, 1.0}
Advisory_SetRange.output			= {0.0, 1.0}
Advisory_SetRange.parameter_name   = "D_ADVISORY_SETRANGE"

Advisory_Dive					= CreateGauge("parameter")
Advisory_Dive.arg_number		= 868
Advisory_Dive.input			= {0.0, 1.0}
Advisory_Dive.output			= {0.0, 1.0}
Advisory_Dive.parameter_name   = "D_ADVISORY_DIVE"

-- APC Indicator Light
APCLight                            = CreateGauge("parameter")
APCLight.arg_number                 = 147
APCLight.input                      = {0.0, 1.0}
APCLight.output                     = {0.0, 1.0}
APCLight.parameter_name             = "APC_LIGHT"

-- AOA Indicator and Ladder Lights
AngleOfAttack                       = CreateGauge("parameter")
AngleOfAttack.arg_number            = 840
AngleOfAttack.input                 = {0, 30.0} -- gauge shows arbitrary units up to 30 (not degrees or radians), optimum landing AoA should be 17.5units at 3oclock position. base_gauge_AngleOfAttack is in radians though... Need to tweak this input range on the gauge if we can figure out how the arbitrary units correspond to radians
AngleOfAttack.output                = {0.0, 1.0}
AngleOfAttack.parameter_name        = "FM_AOA_UNITS"

AoA_Green                           = CreateGauge("parameter")
AoA_Green.arg_number                = 850
AoA_Green.input                     = {0.0, 1.0}
AoA_Green.output                    = {0.0, 1.0}
AoA_Green.parameter_name            = "AOA_GREEN"

AoA_Yellow                          = CreateGauge("parameter")
AoA_Yellow.arg_number               = 851
AoA_Yellow.input                    = {0.0, 1.0}
AoA_Yellow.output                   = {0.0, 1.0}
AoA_Yellow.parameter_name           = "AOA_YELLOW"

AoA_Red                             = CreateGauge("parameter")
AoA_Red.arg_number                  = 852
AoA_Red.input                       = {0.0, 1.0}
AoA_Red.output                      = {0.0, 1.0}
AoA_Red.parameter_name              = "AOA_RED"

-- APG-53A Radar

APG53A_LeftRange                        = CreateGauge("parameter")
APG53A_LeftRange.arg_number             = 406
APG53A_LeftRange.input                  = {0.0, 1.0}
APG53A_LeftRange.output                 = {0.0, 1.0}
APG53A_LeftRange.parameter_name         = "APG53A-LEFTRANGE"

APG53A_BottomRange                      = CreateGauge("parameter")
APG53A_BottomRange.arg_number           = 407
APG53A_BottomRange.input                = {0.0, 1.0}
APG53A_BottomRange.output               = {0.0, 1.0}
APG53A_BottomRange.parameter_name       = "APG53A-BOTTOMRANGE"


AFCS_HDG_100s                      = CreateGauge("parameter")
AFCS_HDG_100s.arg_number           = 167
AFCS_HDG_100s.input                = {0.0, 1.0}
AFCS_HDG_100s.output               = {0.0, 1.0}
AFCS_HDG_100s.parameter_name       = "AFCS_HDG_100s"

AFCS_HDG_10s                      = CreateGauge("parameter")
AFCS_HDG_10s.arg_number           = 168
AFCS_HDG_10s.input                = {0.0, 1.0}
AFCS_HDG_10s.output               = {0.0, 1.0}
AFCS_HDG_10s.parameter_name       = "AFCS_HDG_10s"

AFCS_HDG_1s                      = CreateGauge("parameter")
AFCS_HDG_1s.arg_number           = 169
AFCS_HDG_1s.input                = {0.0, 1.0}
AFCS_HDG_1s.output               = {0.0, 1.0}
AFCS_HDG_1s.parameter_name       = "AFCS_HDG_1s"

APG53A_Glow								= CreateGauge("parameter")
APG53A_Glow.arg_number					= 115
APG53A_Glow.input						= {0.0, 1.0}
APG53A_Glow.output						= {0.0, 1.0}
APG53A_Glow.parameter_name				= "APG53A_GLOW"


-- APN-153 Doppler Radar

Doppler_MemoryLight                     = CreateGauge("parameter")
Doppler_MemoryLight.arg_number          = 171
Doppler_MemoryLight.input               = {0.0, 1.0}
Doppler_MemoryLight.output              = {0.0, 1.0}
Doppler_MemoryLight.parameter_name      = "APN153-MEMORYLIGHT"

Doppler_Drift                           = CreateGauge("parameter")
Doppler_Drift.arg_number                = 172
Doppler_Drift.input                     = {-40.0, 40.0} -- degrees
Doppler_Drift.output                    = {-1.0, 1.0}
Doppler_Drift.parameter_name            = "APN153-DRIFT-GAUGE"

Doppler_Speed_Xnn                       = CreateGauge("parameter")
Doppler_Speed_Xnn.arg_number            = 173
Doppler_Speed_Xnn.input                 = {0.0, 1.0}
Doppler_Speed_Xnn.output                = {0.0, 1.0}
Doppler_Speed_Xnn.parameter_name        = "APN153-SPEED-Xnn"

Doppler_Speed_nXn                       = CreateGauge("parameter")
Doppler_Speed_nXn.arg_number            = 174
Doppler_Speed_nXn.input                 = {0.0, 1.0}
Doppler_Speed_nXn.output                = {0.0, 1.0}
Doppler_Speed_nXn.parameter_name        = "APN153-SPEED-nXn"

Doppler_Speed_nnX                       = CreateGauge("parameter")
Doppler_Speed_nnX.arg_number            = 175
Doppler_Speed_nnX.input                 = {0.0, 1.0}
Doppler_Speed_nnX.output                = {0.0, 1.0}
Doppler_Speed_nnX.parameter_name        = "APN153-SPEED-nnX"

-- ASN-41 Navigation Computer
-- current position: XX.YY{N/S}
Nav_CurPos_Lat_Xnnnn                  = CreateGauge("parameter")
Nav_CurPos_Lat_Xnnnn.arg_number       = 178
Nav_CurPos_Lat_Xnnnn.input            = {0.0, 1.0}
Nav_CurPos_Lat_Xnnnn.output           = {0.0, 1.0}
Nav_CurPos_Lat_Xnnnn.parameter_name   = "NAV_CURPOS_LAT_Xnnnn"

Nav_CurPos_Lat_nXnnn                  = CreateGauge("parameter")
Nav_CurPos_Lat_nXnnn.arg_number       = 179
Nav_CurPos_Lat_nXnnn.input            = {0.0, 1.0}
Nav_CurPos_Lat_nXnnn.output           = {0.0, 1.0}
Nav_CurPos_Lat_nXnnn.parameter_name   = "NAV_CURPOS_LAT_nXnnn"

Nav_CurPos_Lat_nnXnn                  = CreateGauge("parameter")
Nav_CurPos_Lat_nnXnn.arg_number       = 180
Nav_CurPos_Lat_nnXnn.input            = {0.0, 1.0}
Nav_CurPos_Lat_nnXnn.output           = {0.0, 1.0}
Nav_CurPos_Lat_nnXnn.parameter_name   = "NAV_CURPOS_LAT_nnXnn"

Nav_CurPos_Lat_nnnXn                  = CreateGauge("parameter")
Nav_CurPos_Lat_nnnXn.arg_number       = 181
Nav_CurPos_Lat_nnnXn.input            = {0.0, 1.0}
Nav_CurPos_Lat_nnnXn.output           = {0.0, 1.0}
Nav_CurPos_Lat_nnnXn.parameter_name   = "NAV_CURPOS_LAT_nnnXn"

Nav_CurPos_Lat_nnnnX                  = CreateGauge("parameter")
Nav_CurPos_Lat_nnnnX.arg_number       = 182
Nav_CurPos_Lat_nnnnX.input            = {0.0, 1.0}
Nav_CurPos_Lat_nnnnX.output           = {0.0, 1.0}
Nav_CurPos_Lat_nnnnX.parameter_name   = "NAV_CURPOS_LAT_nnnnX"

-- navigation system, current position, longitude
Nav_CurPos_Lon_Xnnnnn                 = CreateGauge("parameter")
Nav_CurPos_Lon_Xnnnnn.arg_number      = 184
Nav_CurPos_Lon_Xnnnnn.input           = {0.0, 1.0}
Nav_CurPos_Lon_Xnnnnn.output          = {0.0, 1.0}
Nav_CurPos_Lon_Xnnnnn.parameter_name  = "NAV_CURPOS_LON_Xnnnnn"

Nav_CurPos_Lon_nXnnnn                 = CreateGauge("parameter")
Nav_CurPos_Lon_nXnnnn.arg_number      = 185
Nav_CurPos_Lon_nXnnnn.input           = {0.0, 1.0}
Nav_CurPos_Lon_nXnnnn.output          = {0.0, 1.0}
Nav_CurPos_Lon_nXnnnn.parameter_name  = "NAV_CURPOS_LON_nXnnnn"

Nav_CurPos_Lon_nnXnnn                 = CreateGauge("parameter")
Nav_CurPos_Lon_nnXnnn.arg_number      = 186
Nav_CurPos_Lon_nnXnnn.input           = {0.0, 1.0}
Nav_CurPos_Lon_nnXnnn.output          = {0.0, 1.0}
Nav_CurPos_Lon_nnXnnn.parameter_name  = "NAV_CURPOS_LON_nnXnnn"

Nav_CurPos_Lon_nnnXnn                 = CreateGauge("parameter")
Nav_CurPos_Lon_nnnXnn.arg_number      = 187
Nav_CurPos_Lon_nnnXnn.input           = {0.0, 1.0}
Nav_CurPos_Lon_nnnXnn.output          = {0.0, 1.0}
Nav_CurPos_Lon_nnnXnn.parameter_name  = "NAV_CURPOS_LON_nnnXnn"

Nav_CurPos_Lon_nnnnXn                 = CreateGauge("parameter")
Nav_CurPos_Lon_nnnnXn.arg_number      = 188
Nav_CurPos_Lon_nnnnXn.input           = {0.0, 1.0}
Nav_CurPos_Lon_nnnnXn.output          = {0.0, 1.0}
Nav_CurPos_Lon_nnnnXn.parameter_name  = "NAV_CURPOS_LON_nnnnXn"

Nav_CurPos_Lon_nnnnnX                 = CreateGauge("parameter")
Nav_CurPos_Lon_nnnnnX.arg_number      = 189
Nav_CurPos_Lon_nnnnnX.input           = {0.0, 1.0}
Nav_CurPos_Lon_nnnnnX.output          = {0.0, 1.0}
Nav_CurPos_Lon_nnnnnX.parameter_name  = "NAV_CURPOS_LON_nnnnnX"

-- current position: XX.YY{N/S}
Nav_Dest_Lat_Xnnnn                  = CreateGauge("parameter")
Nav_Dest_Lat_Xnnnn.arg_number       = 191
Nav_Dest_Lat_Xnnnn.input            = {0.0, 1.0}
Nav_Dest_Lat_Xnnnn.output           = {0.0, 1.0}
Nav_Dest_Lat_Xnnnn.parameter_name   = "NAV_DEST_LAT_Xnnnn"

Nav_Dest_Lat_nXnnn                  = CreateGauge("parameter")
Nav_Dest_Lat_nXnnn.arg_number       = 192
Nav_Dest_Lat_nXnnn.input            = {0.0, 1.0}
Nav_Dest_Lat_nXnnn.output           = {0.0, 1.0}
Nav_Dest_Lat_nXnnn.parameter_name   = "NAV_DEST_LAT_nXnnn"

Nav_Dest_Lat_nnXnn                  = CreateGauge("parameter")
Nav_Dest_Lat_nnXnn.arg_number       = 193
Nav_Dest_Lat_nnXnn.input            = {0.0, 1.0}
Nav_Dest_Lat_nnXnn.output           = {0.0, 1.0}
Nav_Dest_Lat_nnXnn.parameter_name   = "NAV_DEST_LAT_nnXnn"

Nav_Dest_Lat_nnnXn                  = CreateGauge("parameter")
Nav_Dest_Lat_nnnXn.arg_number       = 194
Nav_Dest_Lat_nnnXn.input            = {0.0, 1.0}
Nav_Dest_Lat_nnnXn.output           = {0.0, 1.0}
Nav_Dest_Lat_nnnXn.parameter_name   = "NAV_DEST_LAT_nnnXn"

Nav_Dest_Lat_nnnnX                  = CreateGauge("parameter")
Nav_Dest_Lat_nnnnX.arg_number       = 195
Nav_Dest_Lat_nnnnX.input            = {0.0, 1.0}
Nav_Dest_Lat_nnnnX.output           = {0.0, 1.0}
Nav_Dest_Lat_nnnnX.parameter_name   = "NAV_DEST_LAT_nnnnX"

-- navigation system, current position, longitude
Nav_Dest_Lon_Xnnnnn                 = CreateGauge("parameter")
Nav_Dest_Lon_Xnnnnn.arg_number      = 197
Nav_Dest_Lon_Xnnnnn.input           = {0.0, 1.0}
Nav_Dest_Lon_Xnnnnn.output          = {0.0, 1.0}
Nav_Dest_Lon_Xnnnnn.parameter_name  = "NAV_DEST_LON_Xnnnnn"

Nav_Dest_Lon_nXnnnn                 = CreateGauge("parameter")
Nav_Dest_Lon_nXnnnn.arg_number      = 198
Nav_Dest_Lon_nXnnnn.input           = {0.0, 1.0}
Nav_Dest_Lon_nXnnnn.output          = {0.0, 1.0}
Nav_Dest_Lon_nXnnnn.parameter_name  = "NAV_DEST_LON_nXnnnn"

Nav_Dest_Lon_nnXnnn                 = CreateGauge("parameter")
Nav_Dest_Lon_nnXnnn.arg_number      = 199
Nav_Dest_Lon_nnXnnn.input           = {0.0, 1.0}
Nav_Dest_Lon_nnXnnn.output          = {0.0, 1.0}
Nav_Dest_Lon_nnXnnn.parameter_name  = "NAV_DEST_LON_nnXnnn"

Nav_Dest_Lon_nnnXnn                 = CreateGauge("parameter")
Nav_Dest_Lon_nnnXnn.arg_number      = 200
Nav_Dest_Lon_nnnXnn.input           = {0.0, 1.0}
Nav_Dest_Lon_nnnXnn.output          = {0.0, 1.0}
Nav_Dest_Lon_nnnXnn.parameter_name  = "NAV_DEST_LON_nnnXnn"

Nav_Dest_Lon_nnnnXn                 = CreateGauge("parameter")
Nav_Dest_Lon_nnnnXn.arg_number      = 201
Nav_Dest_Lon_nnnnXn.input           = {0.0, 1.0}
Nav_Dest_Lon_nnnnXn.output          = {0.0, 1.0}
Nav_Dest_Lon_nnnnXn.parameter_name  = "NAV_DEST_LON_nnnnXn"

Nav_Dest_Lon_nnnnnX                 = CreateGauge("parameter")
Nav_Dest_Lon_nnnnnX.arg_number      = 202
Nav_Dest_Lon_nnnnnX.input           = {0.0, 1.0}
Nav_Dest_Lon_nnnnnX.output          = {0.0, 1.0}
Nav_Dest_Lon_nnnnnX.parameter_name  = "NAV_DEST_LON_nnnnnX"

Nav_WindSpeed_Xxx                   = CreateGauge("parameter")
Nav_WindSpeed_Xxx.arg_number        = 210
Nav_WindSpeed_Xxx.input             = {0.0, 1.0}
Nav_WindSpeed_Xxx.output            = {0.0, 1.0}
Nav_WindSpeed_Xxx.parameter_name    = "ASN41-WINDSPEED-Xxx"

Nav_WindSpeed_xXx                   = CreateGauge("parameter")
Nav_WindSpeed_xXx.arg_number        = 211
Nav_WindSpeed_xXx.input             = {0.0, 1.0}
Nav_WindSpeed_xXx.output            = {0.0, 1.0}
Nav_WindSpeed_xXx.parameter_name    = "ASN41-WINDSPEED-xXx"

Nav_WindSpeed_xxX                   = CreateGauge("parameter")
Nav_WindSpeed_xxX.arg_number        = 212
Nav_WindSpeed_xxX.input             = {0.0, 1.0}
Nav_WindSpeed_xxX.output            = {0.0, 1.0}
Nav_WindSpeed_xxX.parameter_name    = "ASN41-WINDSPEED-xxX"

Nav_WindDir_Xxx                     = CreateGauge("parameter")
Nav_WindDir_Xxx.arg_number          = 214
Nav_WindDir_Xxx.input               = {0.0, 1.0}
Nav_WindDir_Xxx.output              = {0.0, 1.0}
Nav_WindDir_Xxx.parameter_name      = "ASN41-WINDDIR-Xxx"

Nav_WindDir_xXx                     = CreateGauge("parameter")
Nav_WindDir_xXx.arg_number          = 215
Nav_WindDir_xXx.input               = {0.0, 1.0}
Nav_WindDir_xXx.output              = {0.0, 1.0}
Nav_WindDir_xXx.parameter_name      = "ASN41-WINDDIR-xXx"

Nav_WindDir_xxX                     = CreateGauge("parameter")
Nav_WindDir_xxX.arg_number          = 216
Nav_WindDir_xxX.input               = {0.0, 1.0}
Nav_WindDir_xxX.output              = {0.0, 1.0}
Nav_WindDir_xxX.parameter_name      = "ASN41-WINDDIR-xxX"

Nav_Magvar_Xxxxx                     = CreateGauge("parameter")
Nav_Magvar_Xxxxx.arg_number          = 204
Nav_Magvar_Xxxxx.input               = {0.0, 1.0}
Nav_Magvar_Xxxxx.output              = {0.0, 1.0}
Nav_Magvar_Xxxxx.parameter_name      = "ASN41-MAGVAR-Xxxxx"

Nav_Magvar_xXxxx                     = CreateGauge("parameter")
Nav_Magvar_xXxxx.arg_number          = 205
Nav_Magvar_xXxxx.input               = {0.0, 1.0}
Nav_Magvar_xXxxx.output              = {0.0, 1.0}
Nav_Magvar_xXxxx.parameter_name      = "ASN41-MAGVAR-xXxxx"

Nav_Magvar_xxXxx                     = CreateGauge("parameter")
Nav_Magvar_xxXxx.arg_number          = 206
Nav_Magvar_xxXxx.input               = {0.0, 1.0}
Nav_Magvar_xxXxx.output              = {0.0, 1.0}
Nav_Magvar_xxXxx.parameter_name      = "ASN41-MAGVAR-xxXxx"

Nav_Magvar_xxxXx                     = CreateGauge("parameter")
Nav_Magvar_xxxXx.arg_number          = 207
Nav_Magvar_xxxXx.input               = {0.0, 1.0}
Nav_Magvar_xxxXx.output              = {0.0, 1.0}
Nav_Magvar_xxxXx.parameter_name      = "ASN41-MAGVAR-xxxXx"

Nav_Magvar_xxxxX                     = CreateGauge("parameter")
Nav_Magvar_xxxxX.arg_number          = 208
Nav_Magvar_xxxxX.input               = {0.0, 1.0}
Nav_Magvar_xxxxX.output              = {0.0, 1.0}
Nav_Magvar_xxxxX.parameter_name      = "ASN41-MAGVAR-xxxxX"

-- AN/ARC-51 UHF Radio
ARC51_Freq_XXxxx                     = CreateGauge("parameter")
ARC51_Freq_XXxxx.arg_number          = 362
ARC51_Freq_XXxxx.input               = {0.0, 1.0}
ARC51_Freq_XXxxx.output              = {0.0, 1.0}
ARC51_Freq_XXxxx.parameter_name      = "ARC51-FREQ-XXxxx"

ARC51_Freq_xxXxx                     = CreateGauge("parameter")
ARC51_Freq_xxXxx.arg_number          = 363
ARC51_Freq_xxXxx.input               = {0.0, 1.0}
ARC51_Freq_xxXxx.output              = {0.0, 1.0}
ARC51_Freq_xxXxx.parameter_name      = "ARC51-FREQ-xxXxx"

ARC51_Freq_xxxXX                     = CreateGauge("parameter")
ARC51_Freq_xxxXX.arg_number          = 364
ARC51_Freq_xxxXX.input               = {0.0, 0.95}
ARC51_Freq_xxxXX.output              = {0.0, 0.95}
ARC51_Freq_xxxXX.parameter_name      = "ARC51-FREQ-xxxXX"

ARC51_Freq_Preset                    = CreateGauge("parameter")
ARC51_Freq_Preset.arg_number         = 371
ARC51_Freq_Preset.input              = {0.00, 0.95}
ARC51_Freq_Preset.output             = {0.00, 0.95}
ARC51_Freq_Preset.parameter_name     = "ARC51-FREQ-PRESET"

-- COCKPIT/FLOOD LIGHTING --
FloodWhite                          = CreateGauge("parameter")
FloodWhite.arg_number               = 111
FloodWhite.input                    = {0.0, 1.0}
FloodWhite.output                   = {0.0, 0.75}
FloodWhite.parameter_name           = "LIGHTS-FLOOD-WHITE"

FloodRed                            = CreateGauge("parameter")
FloodRed.arg_number                 = 114
FloodRed.input                      = {0.0, 1.0}
FloodRed.output                     = {0.0, 1.0}
FloodRed.parameter_name             = "LIGHTS-FLOOD-RED"

InstLightsPrimary                   = CreateGauge("parameter")
InstLightsPrimary.arg_number        = 117
InstLightsPrimary.input             = {0.0, 1.0}
InstLightsPrimary.output            = {0.0, 1.0}
InstLightsPrimary.parameter_name    = "LIGHTS-INST"

ConsoleLights                       = CreateGauge("parameter")
ConsoleLights.arg_number            = 119
ConsoleLights.input                 = {0.0, 1.0}
ConsoleLights.output                = {0.0, 1.0}
ConsoleLights.parameter_name        = "LIGHTS-CONSOLE"

-- CLOCK/STOPWATCH --

CurrTime_hours                     = CreateGauge("parameter")
CurrTime_hours.arg_number          = 440
CurrTime_hours.input               = {0.0, 12.0}
CurrTime_hours.output              = {0.0, 1.0}
CurrTime_hours.parameter_name      = "CURRTIME_HOURS"

CurrTime_mins                     = CreateGauge("parameter")
CurrTime_mins.arg_number          = 441
CurrTime_mins.input               = {0.0, 60.0}
CurrTime_mins.output              = {0.0, 1.0}
CurrTime_mins.parameter_name      = "CURRTIME_MINS"

CurrTime_secs                     = CreateGauge("parameter")
CurrTime_secs.arg_number          = 442
CurrTime_secs.input               = {0.0, 60.0}
CurrTime_secs.output              = {0.0, 1.0}
CurrTime_secs.parameter_name      = "CURRTIME_SECS"

Stopwatch_mins                     = CreateGauge("parameter")
Stopwatch_mins.arg_number          = 144
Stopwatch_mins.input               = {0.0, 60.0}
Stopwatch_mins.output              = {0.0, 1.0}
Stopwatch_mins.parameter_name      = "STOPWATCH_MINS"

Stopwatch_secs                     = CreateGauge("parameter")
Stopwatch_secs.arg_number          = 145
Stopwatch_secs.input               = {0.0, 60.0}
Stopwatch_secs.output              = {0.0, 1.0}
Stopwatch_secs.parameter_name      = "STOPWATCH_SECS"

--------------------ECM panel

ECM_TEST		                    = CreateGauge("parameter")
ECM_TEST.arg_number                 = 514
ECM_TEST.input                      = {0.0, 1.0}
ECM_TEST.output                     = {0.0, 1.0}
ECM_TEST.parameter_name             = "ECM_TEST"

ECM_GO		                    	= CreateGauge("parameter")
ECM_GO.arg_number                	= 515
ECM_GO.input                     	= {0.0, 1.0}
ECM_GO.output                    	= {0.0, 1.0}
ECM_GO.parameter_name            	= "ECM_GO"

ECM_NO_GO		                    = CreateGauge("parameter")
ECM_NO_GO.arg_number                = 516
ECM_NO_GO.input                    	= {0.0, 1.0}
ECM_NO_GO.output                   	= {0.0, 1.0}
ECM_NO_GO.parameter_name         	= "ECM_NO_GO"



ECM_SAM		                    	= CreateGauge("parameter")
ECM_SAM.arg_number                	= 517
ECM_SAM.input                     	= {0.0, 1.0}
ECM_SAM.output                    	= {0.0, 1.0}
ECM_SAM.parameter_name            	= "ECM_SAM"

ECM_RPT		                    	= CreateGauge("parameter")
ECM_RPT.arg_number                 	= 518
ECM_RPT.input                      	= {0.0, 1.0}
ECM_RPT.output                     	= {0.0, 1.0}
ECM_RPT.parameter_name             	= "ECM_RPT"

ECM_STBY		                   	= CreateGauge("parameter")
ECM_STBY.arg_number                	= 519
ECM_STBY.input                     	= {0.0, 1.0}
ECM_STBY.output                    	= {0.0, 1.0}
ECM_STBY.parameter_name            	= "ECM_STBY"

ECM_REC								= CreateGauge("parameter")
ECM_REC.arg_number					= 500
ECM_REC.input						= {0.0, 1.0}
ECM_REC.output						= {0.0, 1.0}
ECM_REC.parameter_name				= "ECM_REC"

ECM_Visibilty						= CreateGauge("parameter")
ECM_Visibilty.arg_number			= 531
ECM_Visibilty.input					= {0.0, 1.0}
ECM_Visibilty.output				= {0.0, 1.0}
ECM_Visibilty.parameter_name		= "ECM_VIS"

AFCS_TEST_ROLL						= CreateGauge("parameter")
AFCS_TEST_ROLL.arg_number			= 260
AFCS_TEST_ROLL.input				= {-1.0, 1.0}
AFCS_TEST_ROLL.output				= {-1.0, 1.0}
AFCS_TEST_ROLL.parameter_name		= "AFCS_TEST_ROLL"

AFCS_TEST_YAW						= CreateGauge("parameter")
AFCS_TEST_YAW.arg_number			= 261
AFCS_TEST_YAW.input					= {-1.0, 1.0}
AFCS_TEST_YAW.output				= {-1.0, 1.0}
AFCS_TEST_YAW.parameter_name		= "AFCS_TEST_YAW"

AFCS_TEST_PITCH						= CreateGauge("parameter")
AFCS_TEST_PITCH.arg_number			= 262
AFCS_TEST_PITCH.input				= {-1.0, 1.0}
AFCS_TEST_PITCH.output				= {-1.0, 1.0}
AFCS_TEST_PITCH.parameter_name		= "AFCS_TEST_PITCH"

--TEST_PARAM_GAUGE      			  = CreateGauge("parameter")
--TEST_PARAM_GAUGE.parameter_name   = "TEST"
--TEST_PARAM_GAUGE.arg_number    	  = 113
--TEST_PARAM_GAUGE.input    		  = {0,100}
--TEST_PARAM_GAUGE.output    		  = {0,1}

need_to_be_closed = true -- close lua state after initialization


Z_test =
{
	near = 0.05,
	far  = 4.0,
}

livery = "default"

--[[ available functions

 --base_gauge_RadarAltitude
 --base_gauge_BarometricAltitude
 --base_gauge_AngleOfAttack
 --base_gauge_AngleOfSlide
 --base_gauge_VerticalVelocity
 --base_gauge_TrueAirSpeed
 --base_gauge_IndicatedAirSpeed
 --base_gauge_MachNumber
 --base_gauge_VerticalAcceleration --Ny
 --base_gauge_HorizontalAcceleration --Nx
 --base_gauge_LateralAcceleration --Nz
 --base_gauge_RateOfRoll
 --base_gauge_RateOfYaw
 --base_gauge_RateOfPitch
 --base_gauge_Roll
 --base_gauge_MagneticHeading
 --base_gauge_Pitch
 --base_gauge_Heading
 --base_gauge_EngineLeftFuelConsumption
 --base_gauge_EngineRightFuelConsumption
 --base_gauge_EngineLeftTemperatureBeforeTurbine
 --base_gauge_EngineRightTemperatureBeforeTurbine
 --base_gauge_EngineLeftRPM
 --base_gauge_EngineRightRPM
 --base_gauge_WOW_RightMainLandingGear
 --base_gauge_WOW_LeftMainLandingGear
 --base_gauge_WOW_NoseLandingGear
 --base_gauge_RightMainLandingGearDown
 --base_gauge_LeftMainLandingGearDown
 --base_gauge_NoseLandingGearDown
 --base_gauge_RightMainLandingGearUp
 --base_gauge_LeftMainLandingGearUp
 --base_gauge_NoseLandingGearUp
 --base_gauge_LandingGearHandlePos
 --base_gauge_StickRollPosition
 --base_gauge_StickPitchPosition
 --base_gauge_RudderPosition
 --base_gauge_ThrottleLeftPosition
 --base_gauge_ThrottleRightPosition
 --base_gauge_HelicopterCollective
 --base_gauge_HelicopterCorrection
 --base_gauge_CanopyPos
 --base_gauge_CanopyState
 --base_gauge_FlapsRetracted
 --base_gauge_SpeedBrakePos
 --base_gauge_FlapsPos
 --base_gauge_TotalFuelWeight

--]]
