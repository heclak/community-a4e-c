dofile(LockOn_Options.script_path.."command_defs.lua")

dev = GetSelf()

update_time_step = 1.0
make_default_activity(update_time_step)

nvg_command = 438

nvg_allowed = get_aircraft_property("Night_Vision")

dev:listen_command(Keys.nvg_toggle)

function SetCommand(command, value)
    if command == Keys.nvg_toggle then
        if nvg_allowed == 1 then
            dispatch_action(nil, nvg_command)
        end
    end
end

function update()
end

function post_initialize()
end



need_to_be_closed = false
