dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.script_path.."sound_params.lua")

local debug_mode = false -- set to true for debug messages

function debug_print(x)
    if debug_mode then
        print_message_to_user(x)
        log.alert(x)
    end
end

local dev = GetSelf()

local update_time_step = 0.02  --50 time per second
make_default_activity(update_time_step)

local sensor_data = get_efm_sensor_data_overrides()
local efm_data_bus = get_efm_data_bus()

---------------------------------
-- ANIMATION CONSTANTS
---------------------------------
local WHEELCHOCKS_ANIM_ARG = 499


local Airbrake  = 73 -- This is the number of the command from command_defs
local AirbrakeOn = 147
local AirbrakeOff = 148

local iCommandPlaneWheelBrakeOn = 74
local iCommandPlaneWheelBrakeOff = 75

--Creating local variables
local ABRAKE_COMMAND	=	0				
local ABRAKE_STATE	=	0
local ABRAKE_TARGET = 0
local speedbrake_emer_countdown = 0
local WHEELCHOCKS_STATE = 0 -- state of wheel chocks

local brakes_on = false
local brake_eff = get_param_handle("BRAKE_EFF")

local wheelchocks_state_param = get_param_handle("WHEEL_CHOCKS_STATE")
wheelchocks_state_param:set(WHEELCHOCKS_STATE)

local birth_tics = 0

dev:listen_command(Airbrake)
dev:listen_command(AirbrakeOn)
dev:listen_command(AirbrakeOff)
dev:listen_command(device_commands.speedbrake)
dev:listen_command(device_commands.speedbrake_emer)
dev:listen_command(Keys.BrakesOn)
dev:listen_command(Keys.BrakesOff)

dev:listen_event("WheelChocksOn")
dev:listen_event("WheelChocksOff")

dev:listen_command(device_commands.wheelbrake_AXIS)
local single_wheelbrake_axis_value = -1
local left_wheelbrake_AXIS_value = -1
local right_wheelbrake_AXIS_value = -1
local wheelbrake_axis_value = -1
local wheelbrake_toggle_state = false


function CockpitEvent(event,val)
    -- val is mostly just empty table {}
    debug_print("Airbrake CockpitEvent event: "..tostring(event).." = "..tostring(val))
    if event == "WheelChocksOn" then
        debug_print("WheelChocksOn")
        WHEELCHOCKS_STATE = 1
        wheelchocks_state_param:set(WHEELCHOCKS_STATE)
    elseif event == "WheelChocksOff" then
        debug_print("WheelChocksOff")
        dispatch_action(nil,iCommandPlaneWheelBrakeOff)
        WHEELCHOCKS_STATE = 0
        wheelchocks_state_param:set(WHEELCHOCKS_STATE)
    end
end

function SetCommand(command,value)			
	if command == Airbrake then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = 1 - ABRAKE_COMMAND
            dev:performClickableAction(device_commands.speedbrake, ABRAKE_COMMAND, false)
        end
    elseif command == AirbrakeOn then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = 1
            dev:performClickableAction(device_commands.speedbrake, ABRAKE_COMMAND, false)
        end
    elseif command == AirbrakeOff then
        if get_elec_mon_dc_ok()  then
            ABRAKE_COMMAND = 0
            dev:performClickableAction(device_commands.speedbrake, ABRAKE_COMMAND, false)
        end
    elseif command == device_commands.speedbrake then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = value
        end
    elseif command == device_commands.speedbrake_emer then
        sound_params.snd_inst_emer_speedbrake_out:set(0.0)
        sound_params.snd_inst_emer_speedbrake_in:set(0.0)
        if (value==1 or value==-1) then
            speedbrake_emer_countdown=0.25 -- seconds until bungee knob reset
            if value==1 then
                ABRAKE_COMMAND = 1
                sound_params.snd_inst_emer_speedbrake_out:set(1.0)
            else
                ABRAKE_COMMAND = 0
                sound_params.snd_inst_emer_speedbrake_in:set(1.0)
            end
        end
    elseif command == Keys.BrakesOn then
		wheelbrake_toggle_state = true
    elseif command == Keys.BrakesOff then
		wheelbrake_toggle_state = false
	elseif command == device_commands.wheelbrake_AXIS then
		single_wheelbrake_axis_value = value
    elseif command == device_commands.left_wheelbrake_AXIS then
        left_wheelbrake_AXIS_value = value
    elseif command == device_commands.right_wheelbrake_AXIS then
        right_wheelbrake_AXIS_value = value
    end
end

local speedbrake_max_effective_knots = 440
local speedbrake_blowback_knots = 490
local a4_max_speed_knots = 540 -- approx, only used to calc linear speedbrake closing, and irrelevant past blowback speed anyway

local current_spoiler=get_param_handle("D_SPOILERS")
local spdbrk_caution=get_param_handle("D_SPDBRK_CAUTION")
local master_test_param = get_param_handle("D_MASTER_TEST")
local left_brake_pedal_param = get_param_handle("LEFT_BRAKE_PEDAL")
local right_brake_pedal_param = get_param_handle("RIGHT_BRAKE_PEDAL")

function post_initialize()
    startup_print("airbrake: postinit")

    -- check starting condition. Chocks should be on cold start and on the carrier to prevent sliding
    local birth = LockOn_Options.init_conditions.birth_place
    debug_print("Birth condition is "..birth)
    if birth == "GROUND_HOT" then
        -- not able to differentiate carrier hot from ground hot (runway start). Carrier hot should have the chocks on for ramp hot start. No solution yet.
    elseif birth == "GROUND_COLD" then
        -- turn on chocks if cold start. Current solution is bugged as it requires to turn chocks on again before turning off.
        -- WHEELCHOCKS_STATE = true 
    end

    startup_print("airbrake: postinit end")
end

local brk_lastx = 0
local brk_lastz = 0
-- returns velocity based on x/z coordinate delta per unit time
local function vel_xz_brakes()
    local curx,cury,curz = sensor_data.getSelfCoordinates()
    local dx = brk_lastx - curx
    local dz = brk_lastz - curz
    local dist = math.sqrt(dx*dx + dz*dz)
    local v = dist / update_time_step          -- convert to m/s
    brk_lastx = curx
    brk_lastz = curz
    return v
end

-- "below velocity v, use brake ratio x"
--[[
local brake_table = {
    {5,10, 14, 20, 30,  45, 999},     -- velocity in m/s
    {1, 4,  3,  3,  2,   1,   1},     -- numerator of brake power ratio
    {1, 5,  5,  5,  5,   3,   4},     -- denominator of brake power ratio
}]]--
local brake_table = {
	{-0.8,	-0.6,	-0.4,	-0.2,	0.0,	0.2,	0.4,	0.6,	0.8,	1.0},				
	{ 1,	1,		3,		2,		2,		3,		7,		4,		9,		1},
	{ 10,	5,		10,		5,		4,		5,		10,		5,		10,		1},
					}

function get_brake_ratio(v)
    for i = 1,#brake_table[1] do
        if v <= brake_table[1][i] then
            return brake_table[2][i],brake_table[3][i]
        end
    end
    return 1,7
end

local brake_now = 0
local brakes_on_last = brakes_on

function update_brakes()
    -- hold brakes on if wheels chocks are on.
    if WHEELCHOCKS_STATE == 1 then
        dispatch_action(nil,iCommandPlaneWheelBrakeOn)
    end

    -- calculate combined brake axis
    wheelbrake_axis_value = -1

    wheelbrake_axis_value = single_wheelbrake_axis_value
    if left_wheelbrake_AXIS_value > wheelbrake_axis_value then
        wheelbrake_axis_value = left_wheelbrake_AXIS_value
    end

    if right_wheelbrake_AXIS_value > wheelbrake_axis_value then
        wheelbrake_axis_value = right_wheelbrake_AXIS_value
    end

    if wheelbrake_axis_value > -0.95 or wheelbrake_toggle_state == true then
        brakes_on = true
    else
        brakes_on = false
    end

    if wheelbrake_toggle_state == true then
        wheelbrake_axis_value = 1
    end

    if brakes_on then
        --local x,y = get_brake_ratio(vel_xz_brakes())
		local x,y = get_brake_ratio(wheelbrake_axis_value)
        -- brake_now cycles from 1 to y
        -- brakes are enabled if brake_now <= x
        -- adjust ratios in brake_table above

        if brake_now <= x then
            dispatch_action(nil,iCommandPlaneWheelBrakeOn)
        else
            dispatch_action(nil,iCommandPlaneWheelBrakeOff)
        end

        brake_eff:set(100*x/y)

        brake_now = brake_now + 1
        if brake_now > y then
            brake_now = 1
        end
    else
        -- turn off the brakes if the brakes were still on
        -- brakes are not set again if the brakes are already off
        if brakes_on_last ~= brakes_on then  -- edge triggered
            dispatch_action(nil,iCommandPlaneWheelBrakeOff)
            brake_eff:set(0)
        end
    end
    brakes_on_last = brakes_on

    -- update brake pedal positions
    left_brake_pedal_param:set(wheelbrake_axis_value)
    right_brake_pedal_param:set(wheelbrake_axis_value)
    -- print_message_to_user(wheelbrake_axis_value)
end



function update()
    update_birth()
    --update_brakes()
    		
	if (ABRAKE_COMMAND == 0 and ABRAKE_STATE > 0) then
		ABRAKE_STATE = ABRAKE_STATE - 0.01 -- lower airbrake in increments of 0.01 (50x per second)
        if ABRAKE_STATE < 0 then
            ABRAKE_STATE = 0
        end
	else
		if (ABRAKE_COMMAND == 1) then
            local knots = sensor_data.getTrueAirSpeed()*1.9438444924574
            if knots > speedbrake_max_effective_knots then
                if knots > speedbrake_blowback_knots then
                    -- blowback pressure relief valve opens
                    ABRAKE_TARGET = 0
                    -- not sure whether blowback really means speedbrakes are closed fully, since
                    -- other places in NATOPS say "speedbrakes are partially effective up to maximum speed capabilities of the aircraft"
                    -- and "A blowback feature allows the speedbrakes to begin closing when the hydraulic pressure exceeds the pressure
                    -- at which the blowback relief valve opens (3650 psi), thus preventing damage to the speedbrake system. The speedbrakes
                    -- begin to blow back at approximately 490 KIAS"
                else
                    -- partially open and partially effective up to max speed of aircraft
                    -- "The speedbrakes will not open fully above 440 KIAS"
                    -- "Maximum speed for fully effective opening of speedbrakes is 440 KIAS. However, speedbrakes are
                    -- partially effective up to maximum speed capabilities of the aircraft."
                    local reduction = (knots - speedbrake_max_effective_knots) / (a4_max_speed_knots - speedbrake_max_effective_knots)  -- simplistically assume linear reduction from 440 to 540kts
                    if reduction > 1 then
                        reduction = 1
                    end
                    ABRAKE_TARGET = 1 - reduction
                end
            else
                ABRAKE_TARGET = 1
            end
            if (ABRAKE_STATE < ABRAKE_TARGET) then
                ABRAKE_STATE = ABRAKE_STATE + 0.01 -- raise airbrake in increment of 0.01 (50x per second)
                if ABRAKE_STATE > ABRAKE_TARGET then
                    ABRAKE_STATE = ABRAKE_TARGET
                end
            elseif (ABRAKE_STATE > ABRAKE_TARGET) then
                ABRAKE_STATE = ABRAKE_STATE - 0.01 -- lower airbrake in increments of 0.01 (50x per second)
                if ABRAKE_STATE < ABRAKE_TARGET then
                    ABRAKE_STATE = ABRAKE_TARGET
                end
            end
		end
	end
    if (speedbrake_emer_countdown>0) then
        speedbrake_emer_countdown=speedbrake_emer_countdown-update_time_step
        if speedbrake_emer_countdown<=0 then
            speedbrake_emer_countdown=0
            dev:performClickableAction(device_commands.speedbrake_emer, 0, false)
        end
    end

    if (ABRAKE_STATE>0 or master_test_param:get()==1) and get_elec_primary_ac_ok() then
        spdbrk_caution:set(1)
    else
        spdbrk_caution:set(0)
    end

	local spoil=current_spoiler:get() -- this value comes from spoilers.lua
    -- spoilers aren't modelled in SFM. They're supposed to dump lift, and in A-4E are
    -- used only on the ground. Instead of dumping lift, we will emulate them as
    -- airbrakes (increasing drag)
    local effective_airbrake = 0.333*ABRAKE_STATE + 0.667*spoil -- TODO: determine percentage split between airbrake and spoiler
    --set_aircraft_draw_argument_value(21,effective_airbrake)
    --set_aircraft_draw_argument_value(500,ABRAKE_STATE)
    set_aircraft_draw_argument_value(WHEELCHOCKS_ANIM_ARG, WHEELCHOCKS_STATE) -- draw wheel chocks if state is 1. 
	efm_data_bus.fm_setBrakes(ABRAKE_STATE)

    -- speedbrake hydraulic transit sound
    local speedbrake_in_transit = false
    if get_hyd_utility_ok() then
        if ((ABRAKE_STATE <= ABRAKE_TARGET) or (ABRAKE_STATE >= ABRAKE_TARGET)) and ((ABRAKE_STATE > 0) and (ABRAKE_STATE < 1)) then
            speedbrake_in_transit = true
        end
        if speedbrake_in_transit == true then
            sound_params.snd_cont_hydraulic_mov:set(1.0)
            sound_params.snd_inst_hydraulic_stop:set(0.0)
        else
            sound_params.snd_cont_hydraulic_mov:set(0.0)
            sound_params.snd_inst_hydraulic_stop:set(1.0)
        end
    end
end

function update_birth()

	if birth_tics < 200 then
		brakes_on = true
		birth_tics = birth_tics + 1
		wheelbrake_axis_value = 1
	elseif birth_tics < 205 then
		brakes_on = false
		birth_tics = birth_tics + 1
		wheelbrake_axis_value= -1
	end
end

need_to_be_closed = false -- close lua state after initialization

--[[
Notes from NATOPS manual:

(under banner towing procedures)
Maximum speed for speedbrake operations - 250 KIAS


pg 1-14:
Switches for the radio
microphone and speedbrakes are located on the
inboard side of the throttle grip, with the exterior
lights master switch on the outboard side

pg 1-26:
The flight control hydraulic system powers only its
half of the aileron, elevator, and rudder tandem
actuating cylinders. The utility hydraulic system, in
addition to powering one-half of the aileron, elevator,
and rudder tandem actuating cylinders, also operates
the landing gear, wing flaps, speedbrakes, arresting
hook, autopilot servos, spoilers, and nosewheel
steering. Hydraulic pressure warning lights are
provided in the cockpit for each of the two systems.

Both of the engine-driven hydraulic pumps are of the
constant pressure, variable displacement type. The
flow of fluid through each system will vary in rate
(gallons per minute) with the operating speed of the
associated pump. As rate of fluid flow determines
the speed at which the various hydraulically operated
units responded to actuation of their individual controls,
variation in rate of flow with power changes
during normal operation might ordinarily produce
objectionable characteristics in operation of the
hydraulic systems. Therefore, flow restrictors
have been installed in the subsystems to regulate the
maximum rate of flow. The flow restrictors prevent
the wing flaps, speedbrakes, and arresting hook from
operating too fast when fluid flow is at its peak, yet
do not affect the time of operation when flow is
reduced at low engine speeds. As long as the engine
is turning at IDLE rpm or greater, the hydraulically
operated units will operate against the usual loads.
However, at engine windmilling speeds, fluid flow is
greatly reduced, and the time required for hydraulically
operated units to respond fully is increased.

pg 1-28:
The elevators are interconnected with
the operation of the speedbrakes to assist the pilot in
overcoming trim changes resulting from speedbrake
operation. A system of cables and springs attached
to the left speedbrake actuates the control cables
between the stick and the elevator control valve.
When speedbrakes are opened, this system pulls the
nosedown elevator cable, moving the stick forward
and actuating the elevator to reduce a noseup pitch.
When the speedbrakes are closed, the stick moves
aft to its original trimmed position, thus reducing
nosedown pitch

pg 1-31:
Two flush-mounted speedbrakes (figure 1-4), one on
each side of the fuselage, provide deceleration during
flight. Hydraulically operated speedbrakes are electrically controlled by the speedbrakes switch on the
inboard side of the throttle grip. Movement of the
switch to either OPEN or C LOSE actuates a solenoid
valve which controls the flow of hydraulic pressure
to the speedbrake actuating cylinders. The speedbrakes cannot be stopped at intermediate positions
between fully opened and fully closed.
The SPD BRK OPEN warning light, located on the
caution panel (figures FO-1 and FO-2) comes on
whenever the speedbrakes are in any position other
than fully closed. A blowback feature allows the
speedbrakes to begin closing when the hydraulic
pressure exceeds the pressure at which the blowback relief valve opens (3650 psi), thus preventing
damage to the speedbrake system. The speedbrakes
begin to blow back at apprOXimately 490 KIAS. The
.3peedbrakes will not open fully above 440 KIAS.
Three flush-mounted JATO hooks are attached to
each speedbrake for mounting a JATO bottle for
assisted takeoffs.
NOTE
When JATO bottles are attached to the
speedbrakes, an interlock in the speedbrake electrical circuit will prevent the
speedbrakes from opening when the speedbrake is in OPEN position. Ensure that
the speedbrake switch is in the CLOSED
position prior to takeoff to prevent inadvertent opening of the speedbrakes when the
JATO bottles are jettisoned.
Speed brake -Elevator Interco nnect
A speedbrake -elevator interconnect spring minimizes aircraft pitchup during speedbrake actuation
by automatically providing nosedown elevator when
the speedbrakes are opened.

Emergency Speedbrake Control
The aircraft is equipped with an emergency speed
brake solenoid valve override control. The emer
gency speedbrake control (figures FO-1, FO-2,
FO-6, and FO-7), a push-pull knob located at the af
end of the left-hand console, can be used to open or
close the speedbrakes in the event of dc electrical
failure, or failure of one of the speedbrake control
valve solenoids. The emergency speedbrake control
knob is held in a neutral position by a spring bungee
and must be pulled up or pushed down to open or
close the speedbrakes, respectively.
In the event of electrical failure, the speedbrakes
may be opened or closed by momentary operation of
the emergency speedbrake control push-pull knob.
When JATO bottles are installed, operation
of the emergency speedbrake control will
force the JATO bottles off the aircraft
resulting in airframe damage.

pg 1-46:
condition: 250 knot descent with speedbrakes extended
angle of attack (cockpit indicator units): 7.0

pg 1-92:
A two-bottle JATO system provides the aircraft with
additional thrust during takeoff. A JATO bottle is
mounted on each speedbrake (figure 1-4). Each
bottle is capable of producing 4500 pounds of thrust
for a period of 5 seconds. The bottles are fired
electrically and jettisoned hydraulically by utility
system hydraulic pressure controlled through a
solenoid operated selector valve.

pg 1-93:
When JATO bottles are installed, operation of the emergency
speedbrake control will force the JATO bottles off the
aircraft resulting in airframe damage.
NOTE
An interlock in the speedbrake electrical
circuit prevents normal operation of speed
brakes with JATO bottles attached. Be sure
the speedbrake switch on the throttle is in
the CLOSED position prior to jettisioning the
JATO bottles; otherwise, upon release of the
JATO bottles the speedbrakes will open.

pg 3-13:
Takeoff procedures: Upon completion of the pretakeoff checklist and after
receipt of clearance from the tower, the aircraft will
line up on the runway. Each pilot should check adjacent aircraft for correct trim settings, flap position,
canopy closed, speedbrakes closed, spoilers closed,
no fuel or hydraulic leaks, and ejection seat safety
handle up. Half-flaps should be used for takeoff during normal shore-based operations. Each pilot shall
indicate his readiness for takeoff by giving a "thumbsup" up the line.

pg 3-16:
Landing: LANDING
The flight shall normally approach the breakup point
in echelon, parade formation, at 250 to 300 KIAS.
A 3- to 5-second break will provide an adequate downwind interval. Immediately after the break, extend
speedbrakes and retard throttle to 70 percent. Speedbrakes will normally remain extended throughout
approach and landing. (Speedbrakes increase the
stalling speed approximately 1 knot. )

pg 3-18:
Crosswind landing:
4. Extend speedbrakes to shorten landing roll
if not already extended.

pg 3-19:
Securing Engine
The following steps will be performed prior to
shutdown:
1. Flaps. UP
2. Speedbrakes IN
3. Spoilers ... CLOSED

Field Carrier Landing Practice (FCLP):
Reduce power to 70 percent and extend speedbrakes.
Speedbrakes will normally remain out throughout the
approach and landing. Use of speedbrakes may not
be desirable at high gross weights (in excess of
13,000 pounds) when configured with high drag stores,
i. e., buddy store, MBR's, etc, due to the high thrust
required during the approach. At 225 KIAS, lower
gear and full flaps. Adjust angle of bank to provide

pg 3-20:
LANDING
Keep the aircraft on the glide slope and centerline.
Keep the "meatball" centered until touchdown. Do not
flare. Upon touchdown, add full power and retract
speedbrakes immediately. Climb straight ahead until
reaching at least 300 feet and 150 KIAS. Turn down
wind when the aircraft ahead is approximately in the
10 0 'clock position on the downwind leg. Do not
exceed 150 KIAS in the pattern. About 30-degree
angle of bank turning downwind should establish the
correct distance abeam. Extend speedbrakes on the
downwind leg prior to reaching the 180 degree
position.
WAVEOFF
To execute a waveoff, immediately add full power,
retract speedbrakes, and transition to a climbing
attitude to prevent further loss of altitude. Make all
waveoffs directly down the runway until at least 300
feet of altitude and 150 KIAS are attained.

pg 3-22P:
(as part of airborne rate of roll check test procedure)
Deceleration should be accomplished without the use
of speedbrakes if possible. The speedbrakes are
directly connected to the elevator control and a pos
sible trim change may occur due to extension and
retraction.

pg 3-22N:
In the case of excessive nosedown pitch, it should be
remembered that use of the speedbrakes may cause
an increased nosedown tendency due to the design of
the system.

pg 3-22Q:
Decelerate and perform a
simulated landing approach. In decelerating prior to
performing the simulated approach, use should be
made of all systems which may be needed in the actual
landing (speedbrakes, landing gear, flaps) to determine
any adverse effects they might have on the control of the aircraft.

pg 4-2:
SPEEDBRAKES
Operation of the speedbrakes results in changes in
trim characterized by a noseup pitch when opened and
a nosedown pitch when closed. To counter this
characteristic, a speedbrake-elevator interconnect
is installed which physically displaces the elevator
when the speedbrakes are operated. This interconnect
mechanism pulls the control stick forward when
the speedbrakes are opened, and returns the stick to
its original position when the speedbrakes are closed,
thus decreasing the noseup and nosedown pitching.
Some trim change will occur when the speedbrakes
are operated. The degree of this trim change will be
a function of airspeed. For further information on
use of the speedbrakes, refer to the paragraph on
Diving, in thi s part.

pg 4-10:
NOTE
• If difficulty is experienced in recovering
from dive, speedbrakes should be opened
immediately and throttle retarded in an effort
to reduce airspeed and limit altitude loss in
recovery maneuver.
• Maximum speed for fully effective opening of
speedbrakes is 440 KlAS. However, speedbrakes are
partially effective up to maximum
speed capabilities of the aircraft.

If the speedbrakes are used before entering the dive,
airspeeds will be limited to lower values where the
increase in stick forces will not be severe.
NOTE
The speedbrakes will begin to "blowback" at
approximately 490 KlAS .
The speedbrakes should not be closed until the recov
ery has been completed to prevent an increase in
stick forces resulting from the combined effects of
the buildup in airspeed and the characteristic nose
down trim changes that accompanies closing of the
speedbrakes. The control stick forces required to
produce 19 change in load factor at various Mach
numbers are presented in figure 4-1.

pg 4-18:
Descents may be made very rapidly by using IDLE
power and speedbrakes.

pg 4-16:
Do not actuate the speedbrakes during any
part of the refueling operation.

pg 4-29:
Where no light signal exists for a certain maneuver,
the radio should be used. Speedbrake signals may
be given on the radio by transmitting "flight,
speedbrakes-now." Channel changes will be given on
the radio and should be acknowledged before and
after making the shift .

pg 5-4:
(under Aborting Takeoff section)
NOTE
Best deceleration will occur by placing the
throttle to IDLE until below 80 KIAS and
then by placing the throttle to OFF (spoiler
equipped aircraft).
b. Speedbrakes OPEN
c. Ensure spoilers ARMED

pg 5-7:
(under Fuel Boost Pump Failure)
When the boost pump fails, reduce throttle to mini
mum required. Avoid zero g, negative g, or inverted
flight. Ensure positive g during speedbrake
operation.

pg 5-37:
SPEEDBRAKE FAILURE
In the event of a speedbrakecontrol valve solenoid
or dc electrical failure, operate the speedbrakes as
follows: '
1.' Speedbrake switch ••..• OPEN OR CLOSE,
. . AS REQUIRED
2. : Emergency speed
brake knob '.. '...••.••..•• PULL TO OPEN OR
PUSH TO CLOSE,
AS REQUIRED
The emergency speedbrake control may be used to
override the electrical Signal, but the handle must be
held in the desired position. Incase of hydraulic and
electrical 'failures when the ·speedbrakes are open, the
speedbrakes may be closed·to the ·.trail position by
momentary actuation of the manual control.

pg 5-42:
LIGHT SIGNALS AT NIGHT
After the pushover from marshal (shipboard) or initial
approach, fix the first blinking of leader's external
lights means speedbrakes out, second blinking means
gear and flaps down, third blinking means Wingman
take over visually and land the aircraft.

--]]