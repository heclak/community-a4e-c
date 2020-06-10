dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev = GetSelf()

local update_time_step = 0.01  --10 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function debug_print(x)
    -- print_message_to_user(x)
end

--Creating local variables
local HUFFER_ANIM_ARG	=	402
local HUFFER_VIS	=	0		
local huffer_connected = false
local huffer_state = "OFF" -- OFF, STARTING, RUNNING, STOPPING
local huffer_rpm = 0
local huffer_max_rpm = 100
local huffer_min_rpm = 0
local huffer_spool_up_time = 5 -- secs
local huffer_spool_down_time = 5 -- secs
local huffer_electrical_state = false -- is the huffer generating electricity

--function SetCommand(command,value)			

--end

-- TODO: play sounds for huffer/generator

dev:listen_event("GroundPowerOn")
dev:listen_event("GroundPowerOff")

-- none of these seem to work
dev:listen_event("Stop")
dev:listen_event("GroundCrewStop")
dev:listen_event("GroundPowerStop")

function CockpitEvent(event,val)
    -- val is mostly just empty table {}
    debug_print("Huffer system event: "..tostring(event))
    if event == "GroundPowerOn" then
        debug_print("Ground power on")
        huffer_connected = true
        -- if huffer_state == "OFF" then
        --     snd_huffer_starting:update(nil, 0.5, nil)
        --     snd_huffer_starting:play_once()
        -- end
        huffer_state = "STARTING"
        if not snd_huffer_running:is_playing() then
            snd_huffer_running:play_continue()
        end
    elseif event == "GroundPowerOff" then
        debug_print("Ground power off")
        huffer_connected = false
        huffer_state = "STOPPING"
    end
end

function post_initialize()
    -- initialise sounds
    sndhost_cockpit         = create_sound_host("COCKPIT","3D",0,0,2) -- TODO: look into defining this sound host for HEADPHONES/HELMET
    -- snd_huffer_starting     = sndhost_cockpit:create_sound("Aircrafts/Engines/APUBeginIn")
    snd_huffer_running      = sndhost_cockpit:create_sound("Aircrafts/Engines/APUIn")

end


local prev_external_power = false
function update()
    simulate_huffer_rpm()
    simluate_huffer_electrical()
    update_huffer_visibility()
end

function simulate_huffer_rpm()
    if huffer_state == "STARTING" then
        -- increase rpm
        huffer_rpm = huffer_rpm + ((huffer_max_rpm / huffer_spool_up_time) * update_time_step)
        if huffer_rpm >= huffer_max_rpm then
            huffer_rpm = huffer_max_rpm
            huffer_state = "RUNNING"
        end
    elseif huffer_state == "STOPPING" then
        -- decrease rpm
        huffer_rpm = huffer_rpm - ((huffer_max_rpm / huffer_spool_down_time) * update_time_step)
        if huffer_rpm <= huffer_min_rpm then
            huffer_rpm = huffer_min_rpm
            huffer_state = "OFF"
            if snd_huffer_running:is_playing() then
                snd_huffer_running:stop()
            end
        end
    end
    snd_huffer_running:update(0.5 + ((huffer_rpm/huffer_max_rpm)/2), LinearTodB(huffer_rpm/huffer_max_rpm) * 1.0, 10)
    -- print_message_to_user(huffer_rpm)
end

function simluate_huffer_electrical()
    if huffer_rpm >= 99 and huffer_electrical_state == false then
        elec_external_power:set(1)
        huffer_electrical_state = true
    elseif huffer_rpm < 99 and huffer_electrical_state == true then
        elec_external_power:set(0)
        huffer_electrical_state = false
    end
end

function update_huffer_visibility()
    if huffer_state == "OFF" then
        HUFFER_VIS = 0
    else
        HUFFER_VIS = 1
    end
    set_aircraft_draw_argument_value(HUFFER_ANIM_ARG, HUFFER_VIS) -- update visual state of huffer
end

-- if connected, init start up sequence
-- if started up, continue state
-- if disconnected, start shutdown sequence

need_to_be_closed = false -- close lua state after initialization