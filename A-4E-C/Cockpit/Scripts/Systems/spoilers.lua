dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

-- spoilers behavior / modeling
--
--
-- design summary:
--   Spoilers deploy automatically when:
--     Weight on left gear
--     Throttle below 70%
--     Spoiler ARM-OFF switch in the ARM position

local dev = GetSelf()

local update_time_step = 0.006
make_default_activity(update_time_step)

    
local sensor_data = get_efm_sensor_data_overrides()
local efm_data_bus = get_efm_data_bus()

local SpoilerToggle  = Keys.SpoilersArmToggle
local SpoilerOn  = Keys.SpoilersArmOn
local SpoilerOff  = Keys.SpoilersArmOff

local SpoilerExtendTimeSec = 0.6 -- spoiler extends quickly!
local SpoilerRetractTimeSec = 1.5  -- 1 sec to retract

--Creating local variables
local SPOILER_STATE = 0     -- 0 = retracted, 1.0 = extended -- "current" spoiler position
local SPOILER_TARGET = 0    -- 0 = retracted, 1.0 = extended -- "future" spoiler position
local SPOILER_ARMED = false -- true if switch is in the ARM position

dev:listen_command(SpoilerToggle)
dev:listen_command(SpoilerOn)
dev:listen_command(SpoilerOff)
dev:listen_command(device_commands.spoiler_arm)

function SetCommand(command,value)			
	
	if command == SpoilerToggle then
        SPOILER_ARMED = not SPOILER_ARMED


        dev:performClickableAction(device_commands.spoiler_arm, SPOILER_ARMED and 1 or 0, false)
    elseif command == SpoilerOn then
        SPOILER_ARMED = true
        dev:performClickableAction(device_commands.spoiler_arm, 1, false)
    elseif command == SpoilerOff then
        SPOILER_ARMED = false
        dev:performClickableAction(device_commands.spoiler_arm, 0, false)
    elseif command == device_commands.spoiler_arm then
        SPOILER_ARMED = (value==1) and true or false
    end

end

local spoiler_retract_increment = update_time_step / SpoilerRetractTimeSec
local spoiler_extend_increment = update_time_step / SpoilerExtendTimeSec
local tmin = 0.55
local tmax = 1.00
local current_spoiler=get_param_handle("D_SPOILERS")
local spoiler_caution=get_param_handle("D_SPOILER_CAUTION")
local master_test_param = get_param_handle("D_MASTER_TEST")

function update()
    local throttle = sensor_data.getThrottleLeftPosition()


    if get_elec_retraction_release_ground() and throttle < 0.34 and SPOILER_ARMED and get_elec_mon_dc_ok() then
        SPOILER_TARGET = 1
    else
        SPOILER_TARGET = 0
    end


    -- make primary adjustment if needed
    if get_hyd_utility_ok() then
        if SPOILER_TARGET == 1 and SPOILER_STATE < 1 then
            SPOILER_STATE = SPOILER_STATE + spoiler_extend_increment
            if SPOILER_STATE > 1 then
                SPOILER_STATE = 1
            end
        end
        if SPOILER_TARGET == 0 and SPOILER_STATE > 0 then
            SPOILER_STATE = SPOILER_STATE - spoiler_retract_increment
            if SPOILER_STATE < 0 then
                SPOILER_STATE = 0
            end
        end
    end

    set_aircraft_draw_argument_value(120,SPOILER_STATE) -- right spoiler draw angle
    set_aircraft_draw_argument_value(123,SPOILER_STATE) -- left spoiler draw angle
    -- share spoiler value so that airbrakes.lua can fake the effect
    current_spoiler:set(SPOILER_STATE)
    -- spoilers aren't modelled in SFM. They're supposed to dump lift, and in A-4E are
    -- used only on the ground. Instead of dumping lift, we will emulate them as
    -- airbrakes (increasing drag), see airbrakes.lua
    if (SPOILER_STATE>0 or master_test_param:get()==1) and get_elec_primary_ac_ok() then
        spoiler_caution:set(1)
    else
        spoiler_caution:set(0)
    end
	
	efm_data_bus.fm_setSpoilers(SPOILER_STATE)
	
end

need_to_be_closed = false -- close lua state after initialization

