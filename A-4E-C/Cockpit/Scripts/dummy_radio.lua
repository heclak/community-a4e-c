dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
local dev 	    = GetSelf()

GUI = {
}

local update_time_step = 1 --update will be called once per second
--local this_radio_ptr = get_param_handle("THIS_RADIO_PTR")

local this_intercom_ptr = get_param_handle("THIS_INTERCOM_PTR")

function post_initialize()
    str_ptr = string.sub(tostring(dev.link),10)
    this_intercom_ptr:set(str_ptr)

	--print_message_to_user("Init intercom")
end

function SetCommand(command,value)
    --print_message_to_user(tostring(command).." : "..tostring(value))
end


need_to_be_closed = false -- close lua state after initialization

