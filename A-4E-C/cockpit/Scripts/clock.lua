dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev 	    = GetSelf()

currtime_hours = get_param_handle("CURRTIME_HOURS")
currtime_mins = get_param_handle("CURRTIME_MINS")
currtime_secs = get_param_handle("CURRTIME_SECS")
stopwatch_mins = get_param_handle("STOPWATCH_MINS")
stopwatch_secs = get_param_handle("STOPWATCH_SECS")

local STOPWATCH_RESET = 0
local STOPWATCH_START = 1
local STOPWATCH_PAUSE = 2

stopwatch_state = STOPWATCH_RESET
stopwatch_start_time = 0
stopwatch_pause_time = 0

local second_handle_wma = WMA_wrap(0.4, 0, 0, 60)
local stopwatch_second_handle_wma = WMA_wrap(0.4, 0, 0, 60)
local stopwatch_minute_handle_wma = WMA_wrap(0.4, 0, 0, 60)

local update_time_step = 0.1 --update will be called 10 times per second

make_default_activity(update_time_step)

function update()
    local abstime = get_absolute_model_time()
    local hours12 = abstime/3600.0
    if hours12>12.0 then
        hours12 = hours12 - 12.0
    end
    currtime_hours:set(hours12)
    local int,frac = math.modf(hours12)
    currtime_mins:set(frac*60)
    int,frac_s = math.modf(frac*60.0)
    currtime_secs:set(second_handle_wma:get_WMA_wrap(math.floor(frac_s*60)))
    --print_message_to_user("hr:"..tostring(hours12)..",min:"..tostring(frac*60)..",sec:"..tostring(second_handle_wma:get_current_val()))

    local stopwatch_min_target, stopwatch_sec_target
    if stopwatch_state == STOPWATCH_START then
        local delta = abstime - stopwatch_start_time
        local hrs = delta/3600.0
        local int,frac = math.modf(hrs)
        stopwatch_min_target = frac*60
        int,frac_s = math.modf(frac*60.0)
        stopwatch_sec_target = frac_s*60
    elseif stopwatch_state == STOPWATCH_PAUSE then
        local delta = stopwatch_pause_time - stopwatch_start_time
        local hrs = delta/3600.0
        local int,frac = math.modf(hrs)
        stopwatch_min_target = frac*60
        int,frac_s = math.modf(frac*60.0)
        stopwatch_sec_target = frac_s*60
    elseif stopwatch_state == STOPWATCH_RESET then
        stopwatch_min_target = 0
        stopwatch_sec_target = 0
    end
    stopwatch_mins:set( stopwatch_minute_handle_wma:get_WMA_wrap(stopwatch_min_target) )
    stopwatch_secs:set( stopwatch_second_handle_wma:get_WMA_wrap(stopwatch_sec_target) )
end

function post_initialize()
    local abstime = get_absolute_model_time()
    local hours12 = abstime/3600.0
    if hours12>12.0 then
        hours12 = hours12 - 12.0
    end
    currtime_hours:set(hours12)
    local int,frac = math.modf(hours12)
    currtime_mins:set(frac*60)
    int,frac_s = math.modf(frac*60.0)
    second_handle_wma:set_current_val(math.floor(frac_s*60))
    currtime_secs:set(math.floor(frac_s*60))
end

dev:listen_command(device_commands.clock_stopwatch)

function SetCommand(command,value)
    --print_message_to_user("clock cmd:"..tostring(command).."="..tostring(value))
    if command == device_commands.clock_stopwatch then
        if value == 1 then -- button pressed
            stopwatch_state = stopwatch_state + 1
            if stopwatch_state > STOPWATCH_PAUSE then
                stopwatch_state = STOPWATCH_RESET
            end
            if stopwatch_state == STOPWATCH_START then
                stopwatch_start_time = get_absolute_model_time()
            elseif stopwatch_state == STOPWATCH_PAUSE then
                stopwatch_pause_time = get_absolute_model_time()
            elseif stopwatch_state == STOPWATCH_RESET then
                stopwatch_pause_time = 0
                stopwatch_start_time = 0
            end
        end
    end
end

--[[
Mission start time:
LockOn_Options.time.hours
LockOn_Options.time.minutes
LockOn_Options.time.seconds

get_absolute_model_time() -- time of day in seconds (including fractional seconds)
get_model_time() -- time in seconds since mission launched
--]]

need_to_be_closed = false -- close lua state after initialization
