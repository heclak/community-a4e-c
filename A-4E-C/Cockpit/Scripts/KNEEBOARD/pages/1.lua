dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../KneeboardResources/a4e_cockpit_kneeboard_welcome.png")

--[[

-- Insert new pages as needed.
-- Catalogue numeration and contents here.
-- Assign pages an integer filename 10-99.

================================
0x - INTRODUCTION
================================
1 - Cover / Credits (this file)

================================
1x - MISSION INFORMATION
================================
11 - Navigation Log
12 - Radio Presets
13 - ILS Data

================================
2x - WEAPONS
================================
2  - *AVOID*
20 -
21 - Simple Bombing Tables and Snakeeye
22 - AWRS and CP-741/A
23 - CBU Configuration
24 - Guns and Gunpods
25 - Rockets, Shrike, Sidewinder

================================
3x - FLIGHT INSTRUCTION
================================
3  - *AVOID*
30 -
31 - Case III Recovery
32 - Weight and Accelleration Limits
33 - Airspeed Limits

================================
4x - QUICK-START
================================
4  - *AVOID*
40 -
41 - Quick-Start 1. Start Up
42 - Quick-Start 2. Taxi
43 - Quick-Start 3. Takeoff
44 - Quick-Start 4. Emergency Procedures

]]
