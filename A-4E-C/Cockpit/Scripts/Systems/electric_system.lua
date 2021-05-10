dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
function debug_print(x)
    --print_message_to_user(x)
end

startup_print("electric_system: load")

local electric_system = GetSelf()
local dev = electric_system

local efm_data_bus = get_efm_data_bus()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)
local emergency_generator_countdown = 0

local sensor_data = get_efm_sensor_data_overrides()

local master_arm = false

local prev_ac_volts
local prev_emerg_gen=false
local emergency_generator_deployed=false
local emergency_generator_bypass=false

local gen_init = 0

--This replaces eletric_system:get_AC_Bus_1_voltage()
function get_AC_Bus_1_voltage()
    if sensor_data.getEngineLeftRPM() > 50.0 or gen_init > 0 then
        return 115
    else
        return 0
    end
end

function update_AC_BUS()

    if sensor_data.getEngineLeftRPM() > 50.0 or get_elec_external_power() then
        electric_system:DC_Battery_on(true)
    else
        electric_system:DC_Battery_on(false)
        
        if gen_init >= 0 then
            gen_init = gen_init - 1
        end
    end
end



function update_elec_state()

    --We are no longer using the built in AC bus for this.
    --This is because we must set the RELATED_CORE_RPM and RELATED_THRUST to zero
    --so as to not produce SU-25 sounds.
    --Instead the rpm is checked to be more than 50.

    --The actual electric_system:DC_Battery_on must be switched to enable and disable eletrical power
    --to the radio.
    update_AC_BUS()

    -- External power switch is located on outside of aircraft, not in cockpit
    --local external_power_connected=(get_aircraft_draw_argument_value(402)==1) -- pretend we have external power when huffer is shown (TODO: AC electric mobile power plant, see Fig 1-49 of NATOPS)
    local external_power_connected=get_elec_external_power()
    if true --[[(electric_system:get_AC_Bus_1_voltage() ~= prev_ac_volts) or (prev_emerg_gen ~= emergency_generator_deployed)--]] then

        if get_AC_Bus_1_voltage() > 0 and ((not emergency_generator_deployed) or (emergency_generator_deployed and emergency_generator_bypass)) then
            -- main generator on
            elec_primary_ac_ok:set(1)
            elec_primary_dc_ok:set(1)
            elec_26V_ac_ok:set(1)
            elec_mon_primary_ac_ok:set(1)
            elec_aft_mon_ac_ok:set(1)
            elec_fwd_mon_ac_ok:set(1)
            elec_mon_dc_ok:set(1)
            elec_mon_arms_dc_ok:set(master_arm and 1 or 0)
            --elec_external_power:set(0)
        else
            -- main generator off or disconnected by emergency generator
            if emergency_generator_deployed and (not emergency_generator_bypass) and (not external_power_connected) then
                local ias_knots = sensor_data.getIndicatedAirSpeed()*1.9438444924574
                -- simulate problems if IAS<120kts (NATOPS says emergency generator may supply insufficient power at lower than 120kts IAS)
                -- set these busses that should be 1 to 0 randomly (PWM style), with probability based on proximity to 120kts, i.e. if much slower than 120, good chance of failure
                -- the plane starts to stall and fall out of the sky around 100kts IAS anyway (and airspeed then stays around 100), so this effect is not very pronounced
                local onoff=1
                if (ias_knots < 120) then
                    onoff = (math.random() < (ias_knots / 120.0)) and 1 or 0
                end
                elec_primary_ac_ok:set(onoff)
                elec_primary_dc_ok:set(onoff)
                elec_26V_ac_ok:set(onoff)
                elec_mon_primary_ac_ok:set(onoff)
                -- the following busses don't get power from emergency generator
                elec_aft_mon_ac_ok:set(0)
                elec_fwd_mon_ac_ok:set(0)
                elec_mon_dc_ok:set(0)
                elec_mon_arms_dc_ok:set(0)

                --elec_external_power:set(0)
            else
                if external_power_connected then
                    elec_primary_ac_ok:set(1)
                    elec_primary_dc_ok:set(1)
                    elec_26V_ac_ok:set(1)
                    elec_mon_primary_ac_ok:set(1)
                    elec_aft_mon_ac_ok:set(1)
                    elec_fwd_mon_ac_ok:set(1)
                    elec_mon_dc_ok:set(0)
                    elec_mon_arms_dc_ok:set(0)
                    --elec_external_power:set(1)
                    if emergency_generator_deployed then
                        emergency_generator_deployed = false -- pretend ground crew has reset RAT
                        print_message_to_user("Ground crew reset emergency generator")
                    end
                else
                    -- no main generator, no backup generator, no external power... no power at all
                    elec_primary_ac_ok:set(0)
                    elec_primary_dc_ok:set(0)
                    elec_26V_ac_ok:set(0)
                    elec_mon_primary_ac_ok:set(0)
                    elec_aft_mon_ac_ok:set(0)
                    elec_fwd_mon_ac_ok:set(0)
                    elec_mon_dc_ok:set(0)
                    elec_mon_arms_dc_ok:set(0)

                    --elec_external_power:set(0)
                end
            end
        end
        elec_emergency_gen_active:set(emergency_generator_deployed and 1 or 0)
        prev_ac_volts = get_AC_Bus_1_voltage()
        prev_emerg_gen = emergency_generator_deployed
    end

    local wow = sensor_data.getWOW_LeftMainLandingGear()
    if wow > 0 then
        elec_ground_mode:set(1)
    else
        elec_ground_mode:set(0)
    end
end

function update_rat_anim()
    local cur = get_aircraft_draw_argument_value(501)
    if emergency_generator_deployed then
        if (cur < 1) then -- deploying
            cur = cur + update_time_step  -- go from 0 to 1 in 1 second
        else -- deployed, spinning
            -- TODO revise this when we have anim args for blades that already look like they're spinning (blurred in spin direction)
            --      This will be necessary to make it look better as well as avoid aliasing effects at certain speeds
            -- local ias_knots = sensor_data.getIndicatedAirSpeed()*1.9438444924574
            -- local rps=ias_knots/30.0
            -- if (rps>20) then
            --     rps=20
            -- end
            -- cur=cur+(rps*update_time_step)
            -- while (cur>1.0) do
            --     cur=cur-1.0
            -- end
        end
    else
        if (cur > 0) then -- storing (after external power applied, pretend ground crew resets the emergency generator)
            cur = cur - update_time_step  -- go from 1 to 0 in 1second
            if cur < 0 then
                cur = 0
            end
        end
    end
    set_aircraft_draw_argument_value(501,cur)
end

function update()
    update_elec_state()
    update_rat_anim()
    if emergency_generator_countdown > 0 then
        emergency_generator_countdown = emergency_generator_countdown - update_time_step
        if emergency_generator_countdown<=0 then
            emergency_generator_countdown = 0
            electric_system:performClickableAction(device_commands.emer_gen_deploy,0,false)
        end
    end
end

function post_initialize()

    str_ptr = string.sub(tostring(dev.link),10)
    efm_data_bus.fm_setElecPTR(str_ptr)
    startup_print("electric_system: postinit start")

    electric_system:AC_Generator_1_on(true) -- A-4E generator is automatic and cannot be controlled by switches
    electric_system:AC_Generator_2_on(false) -- A-4E doesn't have a 2nd generator (since no second engine)
    electric_system:DC_Battery_on(true) -- A-4E doesn't have a battery
    set_aircraft_draw_argument_value(501,-1.0) -- hide RAT

    prev_ac_volts=-1
    update_elec_state()

    local dev = GetSelf()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then --"GROUND_COLD","GROUND_HOT","AIR_HOT"
        -- set master_arm when starting hot
        dev:performClickableAction(device_commands.arm_master,0,true) -- arg 709
        master_arm = false
        gen_init = 2
        -- elec_mon_arms_dc_ok:set(elec_mon_dc_ok:get())
        elec_mon_arms_dc_ok:set(0)
    elseif birth=="GROUND_COLD" then
        gen_init = 0
        dev:performClickableAction(device_commands.arm_master,0,true) -- arg 709
        master_arm = false
        elec_mon_arms_dc_ok:set(0)
    end

    startup_print("electric_system: postinit end")
end

--electric_system:listen_command(Keys.PowerGeneratorLeft) -- A-4E doesn't have main generator on/off switch
--electric_system:listen_command(Keys.PowerGeneratorRight) -- A-4E doesn't have a 2nd generator
--electric_system:listen_command(Keys.BatteryPower) -- A-4E doesn't have a battery
electric_system:listen_command(device_commands.arm_master)
electric_system:listen_command(Keys.MasterArmToggle)
electric_system:listen_command(device_commands.emer_gen_bypass)
electric_system:listen_command(device_commands.emer_gen_deploy)

-- TODO: maybe add a bit of drag to plane if emergency generator is deployed, fake extra airbrakes similar to spoilers (see spoilers.lua and airbrakes.lua) ?
-- TODO horizontal stabilizer manual override lever
-- TODO AMAC SYS EMER PWR switch
-- TODO add keyboard inputs for emergency generator bypass and deploy (similar to Keys.MasterArmToggle)
function SetCommand(command,value)
  --print_message_to_user("electric_system: command "..tostring(command).." = "..tostring(value))
    local external_power_connected=(get_aircraft_draw_argument_value(402)==1)
    if command == device_commands.arm_master then
        master_arm=(value==1) and true or false
        --print_message_to_user("Master Arm: "..(master_arm and "ON" or "OFF"))
        if master_arm then
            elec_mon_arms_dc_ok:set(elec_mon_dc_ok:get())
        else
            elec_mon_arms_dc_ok:set(0)
        end

    elseif command == Keys.MasterArmToggle then
        master_arm = not master_arm
        electric_system:performClickableAction(device_commands.arm_master, master_arm and 1 or 0, false)
    elseif command == device_commands.emer_gen_bypass then
        emergency_generator_bypass=(value==1 and true or false)
        --print_message_to_user("Emergency generator bypass: "..(emergency_generator_bypass and "BYPASS" or "NORMAL"))
    elseif command == device_commands.emer_gen_deploy then
        if (value==1) then
            emergency_generator_countdown = 0.25 -- seconds until T-handle bungees back
            if not emergency_generator_deployed and not external_power_connected then
                --print_message_to_user("Emergency generator deployed")
                emergency_generator_deployed=true
            end
        end
        -- emergency generator cannot be undeployed (except by ground crew, simulated when external power is connected)
        -- (pulling the handle drops the RAT (carried in a compartment in the lower right-hand
        -- side of the forward fuselage) into the airstream)
    end


  --[[
  if command == Keys.PowerGeneratorLeft then
   electric_system:AC_Generator_1_on(value > 0) -- A-4E doesn't have main generator on/off switch
  elseif command == Keys.PowerGeneratorRight then
   electric_system:AC_Generator_2_on(value > 0) -- A-4E doesn't have a 2nd generator
  elseif command == Keys.BatteryPower then
   electric_system:DC_Battery_on(value > 0) -- A-4E doesn't have a battery
  end
  --]]
end

startup_print("electric_system: load end")
need_to_be_closed = false -- close lua state after initialization


--[[
notes about A-4E electrical system from NATOPS page 1-24 onwards:

Electrical power is normally supplied by a 10-kva,
engine-driven generator, which furnishes 115/ 200vac,
3-phase, 400-cycle, constant frequency ac
power. and through a dc converter. No dc generator
or battery is provided. An additional transformer
modifies generator power to 26-vac power for the
operation of certain equipment. Eight buses serve to
distribute power to the various electrical units. An
airstream-operated emergency generator prOVides
electrical power to essential equipment in the event of
main generator or engine failure. External power can
be used to energize the system through an external
power receptacle located in the lower forward plating
of the left-hand wing root. Operation of the electrical
system is completely automatic, with the exception of
the emergency generator, which must be activated by
the pilot upon failure of the main generator. (Refer
to section V for emergency operation of the electrical
system, and figure FO-5 for schematic presentation
of normal and emergency electrical power
distribution.)

Main Generator
The generator is driven at a constant speed of
8000 rpm over the entire operating range of the engine
from idle to maximum power by the constant speed
drive unit. A test unit may be plugged into the receptacle
on the fuse panel in the nosewheel well to ascertain
that the generator is operating within prescribed
limits. An underfrequency protector (all A-4F,
A-4E reworked per A-4 AFC 338) is connected
between the output of the main generator and the voltage
regulator to prevent the supply of low frequency
power to electronic equipment during engine shutdown
or constant speed drive malfunction.
External Power Switch
When the external power switch is in the EXTERNAL
position, the aft monitored bus is disconnected from
the main generator and is connected to the external
power receptacle, so that power from an external
source may be applied to the system. The external
power receptacle door cannot be closed when the
switch is in the EXTERNAL position.
Emergency Generator
The emergency generator, rated at 1.7 kva, is
carried in a compartment in the lower right-hand
side of the forward fuselage. When the generator is
released into the airstream, a variable pitch propeller
governs the speed of the generator at approximately
12,000 rpm to provide 400-cycle power to the
primary and monitored primary buses.

EMERGENCY GENERATOR BYPASS SWITCH
An emergency generator bypass switch labeled
NORMAL-BYPASS is located in the right-hand
console (figures FO-l and FO-2). If the emergency
generator is extended, placing this switch in BYPASS
allows the pilot to return to main generator operation
prOViding main generator power has been
regained.

EMERGENCY GENERATOR RELEASE HANDLE
The emergency generator release T-handle (figures
1- 5 and 1- 6) on the extreme right side of the
cockpit, above the right console, provides control of
the emergency electrical system in the event of main
generator failure. When the handle is pulled, the
emergency generator drops into the airstream, the
main generator becomes disconnected from the electrical
system, and the primary and monitored primary
bus are connected to the emergency generator.
The emergency generator bypass switch must be in
the NORMAL position.
NOTE
Electrical power will be provided by the
emergency generator only if the emergency
generator bypass switch is in NORMAL.
Once the emergency generator is extended, there is
no way to retract it to the normal stowed position
while in flight.

AC Power Distribution

NORMAL AC POWER

Power from the main generator is sampled by a voltage
regulator. The voltage regulator maintains a
constant voltage output from the main generator by
varying the current in the generator exciter field.
The voltage-regulated power moves through the
INTERNAL position of the external power switch.

EMERGENCY AC POWER

Extending the emergency generator into the airstream
breaks the main generator exciter field circuit, rendering
the main generator inoperative, and transfers
the primary bus and monitored primary bus from the
aft monitored bus to the emergency generator (figure
FO-5). If either the horizontal stabilizer manual
override lever or the AMAC SYS EMER PWR switch
is actuated while operating on emergency generator,
the monitored primary bus will be lost as all emergency
generator power is diverted to the primary
bus. Upon releasing the manual override, or
returning the AMAC SYS switch to the NORM position,
power is again directed to the monitored primary bus.

DC Power Distribution

The primary bus supplies 115/200-vac, 3-phase,
400-cycle ac power to a single dc converter, which
converts the ac power to 28-vdc power, and powers
both the 28-vdc primary bus and the monitored dc
bus.


Figure FO-5 shows the electrical system.


--]]

--[[

gyrovague's notes&observations of avSimpleElectricSystem device:
This simple system provides two AC power sources and two DC power sources. It
seems like the two AC power sources are based on emulated generators connected
to the left and right engines, and the 2nd AC is always 0 for the A-4E (having no second engine...)
The AC voltage is either 115 or 0 (depending on 1 or 0 supplied to AC_Generator_x_on() as
well as corresponding engine RPM)

The first DC bus gives 28V if either of the AC sources is 115VAC, and 0 otherwise, so would
appear to emulate an AC-to-DC converter output. The second DC bus is indepedent of the
AC, and goes to 0 if DC_Battery_on(0) is called.

From DLL exports inspection, these are the methods support by avSimpleElectricSystem:
AC_Generator_1_on   <- pass true or false to this to enable or disable
AC_Generator_2_on   <- pass true or false to this to enable or disable
DC_Battery_on       <- pass true or false to this to enable or disable
get_AC_Bus_1_voltage  <- returns 115 if enabled (and left engine running), otherwise 0
get_AC_Bus_2_voltage  <- returns 115 if enabled (and right engine running), otherwise 0
get_DC_Bus_1_voltage  <- returns 28 if either AC bus has 115V, otherwise 0
get_DC_Bus_2_voltage  <- returns 28 if battery enabled, otherwise 0


potentially relevant standard base input commands:
iCommandPowerOnOff	315   -- the command dispatched by rshift-L in FC modules

iCommandGroundPowerDC	704
iCommandGroundPowerDC_Cover	705
iCommandPowerBattery1	706
iCommandPowerBattery1_Cover	707
iCommandPowerBattery2	708
iCommandPowerBattery2_Cover	709
iCommandGroundPowerAC	710
iCommandPowerGeneratorLeft	711
iCommandPowerGeneratorRight	712
iCommandElectricalPowerInverter	713

iCommandAPUGeneratorPower	1071
iCommandBatteryPower	1073
iCommandElectricalPowerInverterSTBY	1074
iCommandElectricalPowerInverterOFF	1075
iCommandElectricalPowerInverterTEST	1076
--]]