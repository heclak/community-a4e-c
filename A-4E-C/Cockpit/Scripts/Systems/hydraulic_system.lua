dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local hydraulic_system = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.1 --update will be called 10 times per second
make_default_activity(update_time_step)

startup_print("hydraulic_system: load")

local conthyd_light_param=get_param_handle("D_CONTHYD_CAUTION")
local utilhyd_light_param=get_param_handle("D_UTILHYD_CAUTION")
local master_test_param=get_param_handle("D_MASTER_TEST")

local engine_rpm = 0

function SetCommand(command, value)
    if command == device_commands.man_flt_control_override then
        if value == 1 then
            print_message_to_user("Flight Controls Disconnected")
        end
    end
end

local main_rpm = get_param_handle("RPM")

function update_hydraulic_state()
    -- only enable hydraulics when engine is running
    -- hydraulic system is powered if engine is turning at IDLE RPM (55%) or greater
    -- Informed by 1-26A
	engine_rpm = main_rpm:get()
    -- print_message_to_user(engine_rpm)
    if engine_rpm >= 52.0 then
        hyd_flight_control_ok:set(1)
        hyd_utility_ok:set(1)
        hyd_brakes_ok:set(1)
    else
        hyd_flight_control_ok:set(0)
        hyd_utility_ok:set(0)
        -- brakes are available with hydraulic failure. Need to look into gradual loss of hydraulic pressure.
        hyd_brakes_ok:set(1)
    end

    if get_elec_primary_ac_ok() then
        if master_test_param:get()==1 then
            conthyd_light_param:set(1)
            utilhyd_light_param:set(1)
        else
            conthyd_light_param:set(1-hyd_utility_ok:get())
            utilhyd_light_param:set(1-hyd_flight_control_ok:get())
        end
    else
        conthyd_light_param:set(0)
        utilhyd_light_param:set(0)
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
	
	--This is a dirty hack for the rudder not initialising to zero in the EFM for some reason.
	--2003 is the rudder enum, we just set it to zero for init.
	dispatch_action(nil, 2003, 0.0)
end

startup_print("hydraulic_system: load end")
need_to_be_closed = false -- close lua state after initialization

