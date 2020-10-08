


local optionsData_cockpitShake = get_plugin_option_value("A-4E-C", "cockpitShake", "local")
local fm_cockpitShake = get_param_handle("FM_COCKPIT_SHAKE")



function post_initialize()
    fm_cockpitShake:set(optionsData_cockpitShake/100.0)
end