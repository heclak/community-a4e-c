dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_01.png")

--[[

Insert new pages as needed.
Catalogue enumeration and contents here.
Assign pages an integer filename 10-99.
For example, page "2 - 3" is "23.lua".

0 - Welcome
  0 - 1 - Table of Contents

1 - Mission
  1 - 1 - Navigation
  1 - 2 - Radio & TACAN
  1 - 3 - ILS Data
  1 - 4 - Countermeasures

2 - Weapons
  2 - 1 - Master Arm & Bombs
  2 - 2 - AWRS & CP-741/A
  2 - 3 - Guns
  2 - 4 - Rockets
  2 - 5 - Missiles & ECM

3 - Flight
  3 - 1 - AFCS (Autopilot)
  3 - 2 - Case III Recovery & APC
  3 - 3 - Fuel & In-Air Refueling
  3 - 4 - Weight & Structural Limits
  3 - 5 - Airspeed Limits

4 - Checklists
  4 - 1 - Start-Up
  4 - 2 - Taxi
  4 - 3 - Takeoff
  4 - 4 - Emergency

5 - Orientation
  5 - 1 - Throttle & Stick
  5 - 2 - Instrument Panel
  5 - 3 - Console Left
  5 - 4 - Console Right
  5 - 5 - Controls

]]
