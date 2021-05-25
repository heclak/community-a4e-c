dofile(LockOn_Options.common_script_path.."KNEEBOARD/indicator/definitions.lua")
SetScale(FOV)

-- Insert new pages as needed.
-- Prioritize experienced users who want to get information they need quickly.

-- Catalogue other page information and numeration here and assign your page an integer filename.
-- Use integers 2-9 sparingly, as they will cause file namesort issues.

-- ================================
-- 0x - INTRODUCTION
-- ================================
-- 1 - Cover / Credits (this file)

-- ================================
-- 1x - MISSION INFORMATION
-- ================================
-- 11 - Navigation Log
-- 12 - Radio Presets
-- 12 - ILS Data

-- ================================
-- 2x - WEAPONS
-- ================================
-- 21 - Bombing Table / CP-741/A Instructions
-- 22 - Weapon Info (CBUs)

-- ================================
-- 3x - FLIGHT INSTRUCTION
-- ================================
-- 31 - Case III Recovery

-- ================================
-- 4x - QUICK-START
-- ================================
-- 41 - Quick-Start 1. Start Up
-- 42 - Quick-Start 2. Taxi
-- 43 - Quick-Start 3. Takeoff
-- 44 - Quick-Start 4. Emergency Procedures

-- add background image for kneeboard
add_picture(LockOn_Options.script_path.."../Textures/a4e_cockpit_kneeboard_welcome.png")
