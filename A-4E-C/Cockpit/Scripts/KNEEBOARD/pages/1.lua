dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_01.png")

--[[

Insert new pages as needed.
Catalogue enumeration and contents here.
Assign pages an integer filename 10-99.
For example, page "23" is "23.lua".

0 Welcome
  01 Table of Contents

1 Mission
  11 Navigation
  12 Radio & TACAN
  13 ILS Data
  14 Countermeasures

2 Weapons
  21 Master Arm & Bombs
  22 Weapon Delivery
  23 Guns
  24 Rockets
  25 Missiles & ECM

3 Flight
  31 Autopilot
  32 Case I Recovery & APC
  33 Case III Recovery
  34 Fuel & Air Refueling
  35 Structural Limits
  36 Airspeed Limits

4 Checklists
  41 Start-Up
  42 Taxi
  43 Takeoff
  44 Takeoff (cont.)
  45 Landing
  46 Emergency

5 Orientation
  51 Throttle & Stick
  52 Instrument Panel
  53 Console Left
  54 Console Right
  55 Controls

]]
