dofile(LockOn_Options.script_path.."Systems/air_data_computer_api.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev = GetSelf()

local update_time_step = 0.02  --50 time per second
make_default_activity(update_time_step)

sensor_data = get_efm_sensor_data_overrides()


c_speed_of_sound = 340.29 --m/s
c_standard_temperature = 288.15 --K

command_table = {

}

local tas = 0.0

function SetCommand(command, value)

    if command_table[command] == nil then
        return
    end

    command_table[command](value)
end

function post_initialize()
    print_message_to_user(recursively_traverse(sensor_data))

end

function calculateTAS(mach, temperature)
    return c_speed_of_sound * mach * math.sqrt(temperature / c_standard_temperature)
end

function update()
    tas = calculateTAS(sensor_data.getMachNumber(), sensor_data.getAngleOfAttack())

    Air_Data_Computer:setTAS(tas)

    print_message_to_user("TAS CALC: "..tostring(tas).." TAS: "..tostring(sensor_data.getTrueAirSpeed()))
end

need_to_be_closed = false