dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_01.dds")

--[[

Insert new pages as needed.
Catalogue enumeration and contents here.
Assign pages an integer filename 10-99.
For example, page "23" is "23.lua".

0 Welcome
  01 Table of Contents

1 Mission
  11 Navigation
  12 UHF Radio
  13 ADF, TACAN, & MCL
  14 Radio & ILS Data
  15 Mission Loadout
  16 Weapons & Loadouts

2 Radar
  21 AN/APN-141 Radar Altimiter & LAWS
  22 AN/APG-53A Radar (Display Indicator)
  23 Ground Radar (Search)
  24 Ground Radar (Terrain Clearance)
  25 Ground Radar (Scope Distortion)
  26 Ground Radar (Air-to-Ground)

3 Weapons
  31 Master Arm & Bombs
  32 Weapon Delivery
  33 Guns
  34 Rockets
  35 Missiles
  36 Countermeasures & ECM

4 Flight
  41 Autopilot
  42 Case I Recovery & APC
  43 Case III Recovery
  44 Fuel & Air Refueling
  45 Structural Limits
  46 Airspeed Limits

5 Checklists
  51 Start-Up
  52 Pre-Taxi
  53 Pre-Takeoff
  54 Takeoff
  55 Landing
  56 Emergency (Engine Flame Out, Air Start, Low Precautionary Approach)
  57 Emergency (High Precautionary Flameout Approach)

6 Orientation
  61 Throttle & Stick
  62 Instrument Panel
  63 Console Left
  64 Console Right
  65 Controls Indicator
  66 Gamepad
  67 Gamepad (continued)

]]
