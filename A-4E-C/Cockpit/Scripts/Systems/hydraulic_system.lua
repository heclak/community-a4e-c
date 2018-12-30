dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local hydraulic_system = GetSelf()

local update_time_step = 0.1 --update will be called 10 times per second
make_default_activity(update_time_step)

startup_print("hydraulic_system: load")

local conthyd_light_param=get_param_handle("D_CONTHYD_CAUTION")
local utilhyd_light_param=get_param_handle("D_UTILHYD_CAUTION")
local master_test_param=get_param_handle("D_MASTER_TEST")

function update_hydraulic_state()
    -- TODO: only enable hydraulics when engine is running
    --hyd_flight_control_ok:set(1)
    --hyd_utility_ok:set(1)
    --hyd_brakes_ok:set(1)

    if get_elec_primary_ac_ok() then
        if master_test_param:get()==1 then
            conthyd_light_param:set(1)
            utilhyd_light_param:set(1)
        else
            conthyd_light_param:set(1-hyd_utility_ok:get())
            utilhyd_light_param:set(1-hyd_flight_control_ok:get())
        end
    end
end


function update()
    update_hydraulic_state()
end

function post_initialize()
    startup_print("hydraulic_system: postinit start")
    hyd_flight_control_ok:set(1)
    hyd_utility_ok:set(1)
    hyd_brakes_ok:set(1)
    conthyd_light_param:set(0)
    utilhyd_light_param:set(0)
    startup_print("hydraulic_system: postinit end")
end

function SetCommand(command,value)

end

startup_print("hydraulic_system: load end")
need_to_be_closed = false -- close lua state after initialization

