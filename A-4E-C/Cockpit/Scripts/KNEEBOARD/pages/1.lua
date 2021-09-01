dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_01.png")

--[[

Insert new pages as needed.
Catalogue enumeration and contents here.
Assign pages an integer filename 10-99.
For example, page "2 - 3" is "23.lua".

-----------------------------------
1 - MISSION INFORMATION
-----------------------------------
1 - 1 - Navigation Log
1 - 2 - UHF Radio Presets
1 - 3 - MCL/ICLS Data
1 - 4 - Countermeasures Programmer

-----------------------------------
2 - WEAPONS
-----------------------------------
2 - 1 - Master Arm & Bombs
2 - 2 - AWRS, CP-741/A
2 - 3 - Guns
2 - 4 - Rockets
2 - 5 - Missiles & AN/APR-23 RHWS

-----------------------------------
3 - FLIGHT
-----------------------------------
3 - 1 - Case III Recovery & APC
3 - 2 - AFCS
3 - 3 - Weight & Structural Limits
3 - 4 - Airspeed Limits

-----------------------------------
4 - CHECKLISTS
-----------------------------------
4 - 1 - Start Up
4 - 2 - Taxi
4 - 3 - Takeoff
4 - 4 - Emergency

-----------------------------------
5 - ORIENTATION
-----------------------------------
5 - 1 - Instrument Panel
5 - 2 - Console Left
5 - 3 - Console Right
5 - 4 - Controls Indicator

]]
