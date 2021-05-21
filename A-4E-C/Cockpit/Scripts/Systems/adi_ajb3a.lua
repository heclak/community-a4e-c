--This file only deals with the ADI needles however it should deal with the ADI gyroscopes in future.

dofile(LockOn_Options.script_path.."Systems/adi_needles_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

loc_needle = WMA(0.2, -1)
gs_needle = WMA(0.2, -1)

function SetCommand(command, value)

end


function post_initialize()
    adi_needles_api.glideslope_needle_param:set(-1)
    adi_needles_api.localiser_needle_param:set(-1)

    adi_needles_api.localiser_param:set(-1)
    adi_needles_api.glideslope_param:set(-1)
end

function update()
    local loc_target = -1.0
    local gs_target = -1.0

    if get_elec_primary_ac_ok() then
        loc_target = adi_needles_api.localiser_param:get()
        gs_target = adi_needles_api.glideslope_param:get()
    end

    gs_needle:get_WMA(gs_target)
    loc_needle:get_WMA(loc_target)

    adi_needles_api.glideslope_needle_param:set(gs_needle:get_current_val())
    adi_needles_api.localiser_needle_param:set(loc_needle:get_current_val())
end

need_to_be_closed = false -- close lua state after initialization