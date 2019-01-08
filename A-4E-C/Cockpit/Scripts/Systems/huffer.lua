dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.1  --10 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

--Creating local variables
local HUFFER_COMMAND	=	0				
local HUFFER_STATE	=	0		

local lastrpm = 0

local lastx,lasty,lastz = sensor_data.getSelfCoordinates()
local initx,inity,initz = sensor_data.getSelfCoordinates()


--dev:listen_command(Engine_Start)

--function SetCommand(command,value)			

--end

-- TODO: play sounds for huffer/generator

distance_threshold = 2.0  -- turn off ground power if moved more meters than this
speed_threshold = 0.4  -- turn off ground power if moving faster than this
local prev_external_power = false
function update()	
    local flow = sensor_data.getEngineLeftFuelConsumption()
    local tas = sensor_data.getTrueAirSpeed()
    local rpm = sensor_data.getEngineLeftRPM()
    local external_power_connected = get_elec_external_power()

    local curx,cury,curz = sensor_data.getSelfCoordinates()

    if prev_external_power ~= external_power_connected then
        prev_external_power = external_power_connected
        if external_power_connected then -- just got connected
            lastx,lasty,lastz = curx,cury,curz
            initx,inity,initz = curx,cury,curz
        else -- just got disconnected
        end
    end

    if external_power_connected then
        local distance = 1
        local delta_distance = math.sqrt((curx-lastx)^2 + (curz-lastz)^2)
        lastx,lasty,lastz = curx,cury,curz
        local speed = 0.2
        --if flow == 0 and tas == 0 and get_elec_retraction_release_ground() and rpm >= lastrpm then
        -- first "hey, what are you doing?" from ground crew triggers at about 0.4m/s; this should trigger a Stop event, but have not been able to figure out exactly what the string is to catch that
        -- at 5m total distance a GroundPowerOff event is also sent
        --print_message_to_user("dist="..string.format("%.2f",distance)..",spd="..string.format("%.2f",speed))
        if distance <= distance_threshold and speed <= speed_threshold then
            HUFFER_STATE = 1
        else
            HUFFER_STATE = 0
            elec_external_power:set(0) -- pretend ground power is off after moving too much
        end
    else
        HUFFER_STATE = 0
    end
	
	
	set_aircraft_draw_argument_value(402,HUFFER_STATE)
	lastrpm = rpm

end

need_to_be_closed = false -- close lua state after initialization