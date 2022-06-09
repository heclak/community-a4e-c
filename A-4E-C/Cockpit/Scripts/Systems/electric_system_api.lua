-- API functions to determine state of electric system
-- To use, add this near the top of your system file:
-- dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
-- and then call the functions below as needed, e.g.
-- if get_elec_mon_dc_ok() then
--   -- do stuff
-- end

function get_elec_primary_ac_ok()
    return elec_primary_ac_ok:get()==1 and true or false
end

function get_elec_primary_dc_ok()
    return elec_primary_dc_ok:get()==1 and true or false
end

function get_elec_26V_ac_ok()
    return elec_26V_ac_ok:get()==1 and true or false
end

function get_elec_aft_mon_ac_ok()
    return elec_aft_mon_ac_ok:get()==1 and true or false
end

function get_elec_fwd_mon_ac_ok()
    return elec_fwd_mon_ac_ok:get()==1 and true or false
end

function get_elec_mon_primary_ac_ok()
    return elec_mon_primary_ac_ok:get()==1 and true or false
end

function get_elec_mon_dc_ok()
    return elec_mon_dc_ok:get()==1 and true or false
end

function get_elec_mon_arms_dc_ok()
    return elec_mon_arms_dc_ok:get()==1 and true or false
end

function get_elec_emergency_gen_active()
    return elec_emergency_gen_active:get()==1 and true or false
end

function get_elec_external_power()
    return elec_external_power:get()==1 and true or false
end

function get_elec_retraction_release_ground()
    return elec_ground_mode:get()==1 and true or false
end

function get_elec_retraction_release_airborne()
    return elec_ground_mode:get()==0 and true or false
end

function debug_print_electric_system()
    print_message_to_user("primAC:"..tostring(elec_primary_ac_ok:get())..",primDC:"..tostring(elec_primary_dc_ok:get())..",26VAC:"..tostring(elec_26V_ac_ok:get())..
        "primmonAC:"..tostring(elec_mon_primary_ac_ok:get())..",afmonAC:"..tostring(elec_aft_mon_ac_ok:get())..",fwdmonAC:"..tostring(elec_fwd_mon_ac_ok:get())..
        "monDC:"..tostring(elec_mon_dc_ok:get())..",armsDC:"..tostring(elec_mon_arms_dc_ok:get()) )
end


elec_primary_ac_ok=get_param_handle("ELEC_PRIMARY_AC_OK") -- 1 or 0
elec_primary_dc_ok=get_param_handle("ELEC_PRIMARY_DC_OK") -- 1 or 0
elec_26V_ac_ok=get_param_handle("ELEC_26V_AC_OK") -- 1 or 0
elec_aft_mon_ac_ok=get_param_handle("ELEC_AFT_MON_AC_OK") -- 1 or 0
elec_fwd_mon_ac_ok=get_param_handle("ELEC_FWD_MON_AC_OK") -- 1 or 0
elec_mon_primary_ac_ok=get_param_handle("ELEC_MON_PRIMARY_AC_OK") -- 1 or 0
elec_mon_dc_ok=get_param_handle("ELEC_MON_DC_OK") -- 1 or 0
elec_mon_arms_dc_ok=get_param_handle("ELEC_MON_ARMS_DC_OK") -- 1 or 0
elec_emergency_gen_active=get_param_handle("ELEC_EMERGENCY_GEN_ACTIVE") -- 1 or 0
elec_external_power=get_param_handle("ELEC_EXTERNAL_POWER") -- 1 or 0
elec_ground_mode=get_param_handle("ELEC_GROUND_MODE") -- 1 or 0


--[[

The various systems are on the following busses (see FO-5 in NATOPS):
(lines beginning with = have already been "connected" in A-4E lua systems files,
the rest need to be done still (if possible and relevant))

Busses:
1.Primary AC bus (115V) (also on emergency generator)
=AJB-3/3A ATTITUDE SYSTEM
CABIN TEMP CONTROLLER
=CABIN PRESSURE (NORMAL-RAM)
CONSOLE LIGHTS
ENGINE CONTROL
=FUEL FLOW
HORIZONTAL STABILIZER TRIM
IGNITION (20 JOULE)
INSTRUMENT LIGHTS
OIL LEVEL
=STANDBY ATTITUDE INDICATOR
TEST PANEL
WARNING LIGHTS RELAYS
WINDSHIELD DEFROST
WINDSHIELD HEAT (inoperative on emerg generator if gear down)
RETRACTION RELEASE
SOLENOID
ANGLE-OF-ATTACK HEAT (inoperative on emerg generator if gear down)
APPROACH LIGHTS
=AOA INDEXER
FUEL DUMP
RED FLOODLIGHTS

2.Primary DC bus (28V) (also on emergency generator)
AIR REFUELING
=AJB-3/3A ATTITUDE SYSTEM
AUDIO ISOLATION AMPLIFIER
=CABIN PRESSURE (NORMAL-RAM)
=FUEL QUANTITY <WING AND EXT>
FUEL TRANSFER BYPASS (A-4E)
HOOK BYPASS (NATOPS page 1-48, only manipulated by ground crew)
IFF, SIF & REMOTE CHANNEL IND
IGNITION TIMER
OIL LEVEL
RADIO CONTROL
=TRIM POSITION
UHF/ADF/AUX RECEIVER
=WHEEL &FLAPS POSITION IND.

3.Transformer AC bus (26V) (also on emergency generator)
ANGLE-OF-ATTACK
=BDHI
COMPASS
=EMERGENCY BOMB RELEASE
HOSE JETTISON
=OIL PRESSURE

4.Aft monitored AC bus (115V) (not available on emergency generator)
AILERON BUNGEE HEAT
AILERON TRIM
AMMUNITION BOOSTERS
=GUN POD POWER
ECM
EXTERIOR LIGHTS
EXTERNAL STORES
FUEL BOOST PUMP
FUSE TEST
SHRIKE & CP-741A
RUDDER TRIM
=LH GUN
=RH GUN
PIN RETRACT (SHRIKE)
WALLEYE POWER

5.Fwd monitored AC bus (115V) (not available on emergency generator)
AFCS POWER
AIR REFUELING PROBE LIGHT
ANTICOLLISION & FUSELAGE LIGHTS
DOPPLER
=ENGINE PRESSURE RATIO IND
GCBS
JATO FIRING
NAVIGATION COMPUTER
INSTRUMENT PANEL VIBRATOR
=RADAR ALTIMETER
RADAR POWER
RAIN REMOVAL
=SEAT ADJUSTMENT
SMOKE ABATEMENT
SUIT VENT BLOWER
TAILLIGHT
TAXILIGHT
TRUE AIRSPEED COMPUTER (ASN-41)
WING LIGHTS
EXTERIOR LIGHTS FLASHER
WHITE FLOODLIGHTS

6.Monitored primary AC bus (115V) (also on emergency generator)
FIRE WARNING
=FUEL QUANTITY (FUSELAGE)
IFF
=LOX QUANTITY
PITOT HEAT
RADIO
=TACAN  (inoperative on emerg generator if gear down)
UHF-ADF
ANTI-ICING REGULATOR

7.Monitored DC bus (28V) (not available on emergency generator)
EMERGENCY FUEL TRANSFER
AFCS AWE-1 CONTROL
DROP TANK SOLENOIDS
ECM
FUSE & MISSILE
FUSE TEST
GCBS
JATO JETTISON
=LAWS
RADAR POWER
RAIN REPELLENT
SHRIKE AND CP-741A
=SPEEDBRAKE CONTROL
=SPOILERS
WALLEYE CONTROL

8.Armament bus (28V) (gated by master arm switch, not available on emergency generator)
ARMAMENT RELEASE
ARMAMENT FIRE
AWE-1 PROGRAMER
BOMB ARMING
GUN POD CONTROL
LABS TIMER
SPRAY TANK & MISSILE CONTROL

Retraction release system:
NATOPS:
The retraction release switch system has two posi¬
tions, airborne and ground. The airborne position
is activated by extension of the left main gear strut as
aircraft becomes airborne. The ground position is
activated as the left main gear strut compresses on
aircraft landing. If aircraft is airborne and retrac¬
tion release switch system malfunctions to the ground
position, operation of the following systems will be
affected:
1. Landing gear lever safety solenoid inoper ¬
ative, requiring manual movement of the serrated
lever to place landing gear handle in the up
position.
2. AFCS and STAB-AUG inoperative (will not
engage).
=3. Spoilers will open if armed, and the throttle is
reduced below the 70 percent position.
4. APCS inoperative (will not engage).
=5. Approach AOA lights and transducer heat
inoperative.
=6. Radar altimeter inoperative.
Upon landing if retraction release switch malfunc¬
tions to airborne position, operation of the following
systems will be affected:
1. STAB-AUG will not disengage.
2. APCS will not disengage.
=3. Nose wheel steering inoperative.
=4. AOA transducer heat and AOA lights will
remain ON.
=5. Spoilers will not operate

--]]