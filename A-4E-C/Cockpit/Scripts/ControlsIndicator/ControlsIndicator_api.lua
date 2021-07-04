dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

local throttle_fm_step_param_string = "API_THROTTLE_FM_STEP"
local throttle_fm_move_param_string = "API_THROTTLE_FM_MOVE"

local nosewheel_pos_param_string = "API_NOSEWHEEL_POS"

ControlsIndicator_api = {
    throttle_fm_step_param_string = throttle_fm_step_param_string,
    throttle_fm_move_param_string = throttle_fm_move_param_string,

    nosewheel_pos_param_string = nosewheel_pos_param_string,

    throttle_fm_step_param = get_param_handle(throttle_fm_step_param_string),
    throttle_fm_move_param = get_param_handle(throttle_fm_move_param_string),

    nosewheel_pos_param = get_param_handle(nosewheel_pos_param_string),

}

function ControlsIndicator_api:setThrottle(throttle_pos)
    local step = clamp(throttle_pos, -1, 0)
    local move = clamp(throttle_pos, 0, 1)
    self.throttle_fm_step_param:set(step)
    self.throttle_fm_move_param:set(move)
end

