-- API functions to determine state of hydraulic system
--
-- To use, add this near the top of your system file:
-- dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
-- and then call the functions below as needed, e.g.
-- if get_hyd_utility_ok() then
--   -- do stuff
-- end



function get_hyd_flight_control_ok()
    return hyd_flight_control_ok:get()==1 and true or false
end

function get_hyd_utility_ok()
    return hyd_utility_ok:get()==1 and true or false
end

function get_hyd_brakes_ok()
    return hyd_brakes_ok:get()==1 and true or false
end


function debug_print_electric_system()
    print_message_to_user("primAC:"..tostring(elec_primary_ac_ok:get())..",primDC:"..tostring(elec_primary_dc_ok:get())..",26VAC:"..tostring(elec_26V_ac_ok:get())..
        "primmonAC:"..tostring(elec_mon_primary_ac_ok:get())..",afmonAC:"..tostring(elec_aft_mon_ac_ok:get())..",fwdmonAC:"..tostring(elec_fwd_mon_ac_ok:get())..
        "monDC:"..tostring(elec_mon_dc_ok:get())..",armsDC:"..tostring(elec_mon_arms_dc_ok:get()) )
end


hyd_flight_control_ok = get_param_handle("HYD_FLIGHT_CONTROL_OK")   -- 1 or 0
hyd_utility_ok = get_param_handle("HYD_UTILITY_OK")                 -- 1 or 0
hyd_brakes_ok = get_param_handle("HYD_BRAKES_OK")                   -- 1 or 0

--[[

The various systems are on the hydraulic systems (see FO-6 in NATOPS):
(lines beginning with = have already been "connected" in A-4E lua systems files,
the rest need to be done still (if possible and relevant))

1. Flight Control System

Ailerons
Elevators
Rudder

2. Utility System

Ailerons
Elevators
Rudder
Spoilers
Flaps
Landing Gear
= Tail Hook (Retract only)
Speedbrakes

3. Brake System

Left Wheel Brake
Right Wheel Brake



--]]