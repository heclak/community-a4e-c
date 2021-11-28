dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/radar_scope_api.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

local cpp_radar_disabled = get_plugin_option_value("A-4E-C", "oldRadar", "local")

local dev = GetSelf()

local Terrain = require('terrain')

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

local sensor_data = get_base_data()
local efm_data_bus = get_efm_data_bus()
local meter2mile = 0.000621371
local meter2feet = 3.28084
local nm2meter = 1852

local degrees_per_radian = 57.2957795
--local feet_per_meter_per_minute = 196.8

local radar_grid_op = get_param_handle("RADAR_GRID_OP")
local apg53a_leftrange = get_param_handle("APG53A-LEFTRANGE")
local apg53a_bottomrange = get_param_handle("APG53A-BOTTOMRANGE")
local master_test_param = get_param_handle("D_MASTER_TEST")
local glare_obst_light=get_param_handle("D_GLARE_OBST")
local radar_filter_param=get_param_handle("RADAR_FILTER")
local apg53a_glow_param = get_param_handle("APG53A_GLOW")

-- Variables
local apg53a_state = "apg53a-off"

local apg53a_inputlist = {"OFF", "STBY", "SRCH", "TC", "A/G"}
local apg53a_input = "OFF"

local apg53a_planprofilelist = {"PLAN", "PROFILE"}
local apg53a_planprofile = "PLAN"

local apg53a_rangelist = {"SHORT", "LONG"}
local apg53a_range = "SHORT"

local apg53a_warm = false
local apg53a_warmup_timer = 0
local apg53a_errx = 0   -- x error magnitude, 0 to 1 during warmup
local apg53a_erry = 0   -- y error magnitude, 0 to 1 during warmup
local apg53a_maxb = 0   -- brightness limit, 0 to 1 during warmup
local apg53a_wup_time = 180
local apg53a_off_time = -180
local apg53a_shimmy = 0.03  -- analog noise in the display

local apg53a_angle = 0
local apg53a_angle_value = 0.4
local apg53a_aoacomp = false
local apg53a_storage = 0.8
local apg53a_brilliance = 0.8
local apg53a_detail = 0.5
local apg53a_gain = 0.5
local apg53a_reticle = 0.5
local apg53a_volume = 0.0
local radar_filter_position_arg = 405

local theta_inc = 1
local sweep_theta = 0
local apg53a_sweep_rho = 1

-- AN/APG-53A CONFIGURATION
local RADAR_RESOLUTION = 50     -- main radar resolution for collisions.  a2g mode uses 1/2 this.

-- plusnine keybinding move/directon
local radar_tilt_moving = 0 
local radar_volume_moving = 0

-- Listeners (clickable)
dev:listen_command(device_commands.radar_planprofile)
dev:listen_command(device_commands.radar_range)
dev:listen_command(device_commands.radar_storage)
dev:listen_command(device_commands.radar_brilliance)
dev:listen_command(device_commands.radar_detail)
dev:listen_command(device_commands.radar_gain)
dev:listen_command(device_commands.radar_reticle)
dev:listen_command(device_commands.radar_filter)
dev:listen_command(device_commands.radar_mode)
dev:listen_command(device_commands.radar_aoacomp)
dev:listen_command(device_commands.radar_angle)
dev:listen_command(device_commands.radar_angle_axis)
dev:listen_command(device_commands.radar_volume)

-- Listeners (keys)
dev:listen_command(Keys.RadarModeOFF)
dev:listen_command(Keys.RadarModeSTBY)
dev:listen_command(Keys.RadarModeSearch)
dev:listen_command(Keys.RadarModeTC)
dev:listen_command(Keys.RadarModeA2G)
dev:listen_command(Keys.RadarMode)
dev:listen_command(Keys.RadarModeCW)
dev:listen_command(Keys.RadarModeCCW)
dev:listen_command(Keys.RadarTCPlanProfile)
dev:listen_command(Keys.RadarRangeLongShort)
dev:listen_command(Keys.RadarAoAComp)
dev:listen_command(Keys.RadarVolume)
dev:listen_command(Keys.RadarVolumeStartUp)
dev:listen_command(Keys.RadarVolumeStartDown)
dev:listen_command(Keys.RadarVolumeStop)
dev:listen_command(Keys.RadarTiltInc)
dev:listen_command(Keys.RadarTiltDec)
dev:listen_command(Keys.RadarTiltStartUp)
dev:listen_command(Keys.RadarTiltStartDown)
dev:listen_command(Keys.RadarTiltStop)

-- "SEARCH" and "TC-PLAN" mode data structures
search = {}
function clear_search_array()   -- uses blobs 1 to 847
    for i = 1,121 do
        search[i] = {}
        for j = 1,7 do
            search[i][j] = 0
        end
    end
end
clear_search_array()

strength = {}
function clear_strength_array()   -- uses blobs 1 to 847
    for i = 1,121 do
        strength[i] = {}
        for j = 1,7 do
            strength[i][j] = 0
        end
    end
end
clear_strength_array()


function clear_search_blobs()
    for i = 1,121 do
        for j = 1,7 do
            set_blob(j*121+i, 0, 0, 0)
        end
    end
end

profile_rho_per_degree = 80
profile = {}
profilemin = {}
function clear_profile_array()
    local num_rho = 15*profile_rho_per_degree + 1 + 10*profile_rho_per_degree
    for i = 1,5 do  -- -2.5 to 2.5 deg heading in 1.25 deg steps
        profile[i] = {}
        for j = 1,num_rho do  -- -15 to 10 pitch degrees in (1/profile_rho_per_degree) deg steps
            profile[i][j] = 0
            profilemin[j] = 0
        end
    end
end
clear_profile_array()

profile_1000ft={}
function calc_profile_1000ft()
    local num_rho = 15*profile_rho_per_degree + 1 + 10*profile_rho_per_degree
    profile_1000ft={}
    for i=1,math.floor(15*num_rho/25) do
        angle=-15+(i-1)*25/(num_rho-1)
        distance=(-1000/meter2feet)/math.sin(math.rad(angle))
        profile_1000ft[i]=distance
    end
end
calc_profile_1000ft()
profile_obstruction=0
obstruction_period=2 -- seconds, period of OBST light/tone

range = {}
function clear_range_array()
    for i = 1,7 do
        range[i] = 0
    end
end
local a2g_range = 1.0 -- variable for persistant sweep behavior
local a2g_waslocked = false
local a2g_lasty = 0
clear_range_array()

function clear_range_blobs()
    for i = 1,61 do
        set_blob(i, 0, 0, 0)
    end
end

function clear_all_blobs()
    for i = 1,max_blobs do
        set_blob(i, 0, 0, 0)
    end
end

function reset_blobs()
    local max=math.floor(math.sqrt(max_blobs))
    for i=1,max_blobs do
        set_blob(i,-1+(i%max)*(2/max), -1+math.floor(i/max)*(2/max), 0.0)
    end
end

function post_initialize()

    if not check_disabled() then
        reset_blobs()
    end
    

    -- initialize sounds first
    sndhost = create_sound_host("COCKPIT_RADAR","HEADPHONES",0,0,0)
    obsttone = sndhost:create_sound("Aircrafts/A-4E-C/obsttone") -- refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef

    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        apg53a_state = "apg53a-stby"
        dev:performClickableAction(device_commands.radar_mode, 0.1, false)  -- radar starts in 'STBY' for warm starts
        dev:performClickableAction(device_commands.radar_angle, 0.4, false)  -- set radar angle to 0 degrees initially
        dev:performClickableAction(device_commands.radar_brilliance, 0.5, false)  -- set radar brilliance to 80% by default
        dev:performClickableAction(device_commands.radar_storage, 0.6, false)  -- initial storage of 0.8 means stuff decays over ~4 wipes
        dev:performClickableAction(device_commands.radar_gain, 0.5, false)  -- set radar gain to 0.5, not currently used
        dev:performClickableAction(device_commands.radar_detail, 0.5, false)  -- set radar detail to 0.5, moderate beam width
        dev:performClickableAction(device_commands.radar_reticle, 0.0, false)  -- set radar reticle to 0.5, 50% background brightness on hashmarks
        dev:performClickableAction(device_commands.radar_aoacomp, 1, false) -- enable AoA comp by default on warm starts
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.radar_mode, 0.0, false)  -- radar starts in 'OFF' for warm starts
        dev:performClickableAction(device_commands.radar_angle, 0.4, false)  -- set radar angle to 0 degrees initially
        dev:performClickableAction(device_commands.radar_brilliance, 0.5, false)  -- set radar brilliance to 80% by default
        dev:performClickableAction(device_commands.radar_storage, 0.6, false)  -- initial storage of 0.8 means stuff decays over ~4 wipes
        dev:performClickableAction(device_commands.radar_gain, 0.5, false)  -- set radar gain to 0.5, not currently used
        dev:performClickableAction(device_commands.radar_detail, 0.5, false)  -- set radar detail to 0.5, moderate beam width
        dev:performClickableAction(device_commands.radar_reticle, 0.0, false)  -- set radar reticle to 0.5, 50% background brightness on hashmarks
        dev:performClickableAction(device_commands.radar_aoacomp, 0, false) -- disable AoA comp by default
    end

    -- night time setup
    local abstime = get_absolute_model_time()
    local hours = abstime / 3600.0

    if hours <= 6 or hours >= 17 then
        dev:performClickableAction(device_commands.radar_filter, 0, false)
        radar_filter_param:set(1)
    else
        dev:performClickableAction(device_commands.radar_filter, 1, false)
        radar_filter_param:set(0)
    end

    dev:performClickableAction(device_commands.radar_volume, 0.5, false)
end

local xyz ={{5.2,9.2}, {6.7,9.2}, {8.2,8.2}, {7.9,7.8}, {8.0,7.0},  -- AE
            {8.0,6.0}, {8.2,5.5}, {8.6,5.3}, {8.6,4.2}, {8.1,3.6},  -- FJ
            {7.1,3.3}, {5.5,2.0}, {4.8,1.6}, {3.4,1.6}, {2.4,2.2},  -- KO
            {2.0,3.1}, {2.5,3.9}, {4.3,5.0}, {4.8,6.4}, {5.0,7.5},  -- PT
            {5.1,8.1}, {7.0,8.1}, {3.1,3.8}, {3.8,3.0}, {4.3,2.0},  -- UY
            {7.5,4.7} }                                             -- Z

local blobsperline = 7

function sp(x)
    return ((x*2)/sizescale)-1
end

function assign_blobs_to_line(blobidx, x1, y1, x2, y2, numpoints, opacity)
    local xdelta = (x2-x1)/(numpoints-1)
    local ydelta = (y2-y1)/(numpoints-1)

    sizescale = 10.2

    set_blob(blobidx, sp(x1), sp(y1), opacity)    -- establish endpoints
    set_blob(blobidx+1, sp(x2), sp(y2), opacity)

    for i = 3,numpoints do
        set_blob(blobidx+i, sp(x1+(xdelta*(i-2))), sp(y1+(ydelta*(i-2))), opacity)
    end
end

function draw_segment(blobidx, idxA, idxB, opacity)
    assign_blobs_to_line(blobidx, xyz[idxA][1], xyz[idxA][2], xyz[idxB][1], xyz[idxB][2], blobsperline, opacity)
    return blobsperline
end

function draw_segments_in_order(blobidx,firstidx,lastidx,opacity)
    for i = firstidx,lastidx-1 do
        draw_segment( blobidx+(i*blobsperline), i, i+1, opacity )
    end
    return blobsperline*(lastidx-firstidx)
end

function draw_xyz(opacity)
    local blobidx = 1
    for i=1,5 do
        blobidx = blobidx + draw_segments_in_order(blobidx, 1, 21, opacity)
        blobidx = blobidx + draw_segment(blobidx, 21, 1, opacity)
        blobidx = blobidx + draw_segment(blobidx, 21, 22, opacity)
        blobidx = blobidx + draw_segment(blobidx, 22, 4, opacity)
        blobidx = blobidx + draw_segment(blobidx, 7, 26, opacity)
        blobidx = blobidx + draw_segment(blobidx, 26, 11, opacity)
        blobidx = blobidx + draw_segments_in_order(blobidx, 23, 25, opacity)
    end
end



-- finds the collision range, within t meters of accuracy, between p0 and p
-- set water to true if water can collide (needs debug)
-- returns 0 if point p is visible from p0
-- function executes log2(vector length)-log2(t) iterations
function find_collision_range(t, p0x, p0y, p0z, px, py, pz, water)
--[[ point a will be the "near" side of my ray
     point b will be the far side of my ray
     point c is the midpoint to test
    
     loop:
        if length of ray between a and b is < t, we're done
        calc midpoint c and test c for visibility
        if c is visible, push move a to midpoint
        if c is hidden, pull b to midpoint
        halve the deltas
]]--
    local ax = p0x
    local ay = p0y
    local az = p0z
    local bx = px
    local by = py
    local bz = pz
    local cx,cy,cz

    -- early exit if no collision at max range
    if Terrain.isVisible(p0x, p0y, p0z, px, py, pz) then
        return 0
    end

    local length = math.sqrt( (bx-ax)^2 + (by-ay)^2 + (bz-az)^2 )

    while length > t do
        -- find midpoint 'c' as next point to test between a and b
        cx = (ax+bx)/2
        cy = (ay+by)/2
        cz = (az+bz)/2

        if cy < 0 or not Terrain.isVisible(p0x,p0y,p0z,cx,cy,cz) then
            -- obscured, pull b to midpoint and re-test
            bx = cx; by = cy; bz = cz
        else
            -- visible, push a to midpoint and re-test
            ax = cx; ay = cy; az = cz
        end

        length = length/2;  -- halve the length for next iteration
    end

    local range = math.sqrt( (bx-p0x)^2 + (by-p0y)^2 + (bz-p0z)^2 )    -- distance between final b (terrain intersect) and p0

    if not water and Terrain.GetSurfaceType(bx, bz) == "sea" then
        return 0
    else
        return range
    end
end

-- returns slope in radians of a point hdg/pitch/range away from lx,ly,lz, used for radar return filtering
function find_visible_slope(lx,ly,lz,hdg,pitch,range)
    -- find a point 10 meters in front of our collision point, and test the terrain's slope
    local fx,fy,fz = pointFromVector(lx, ly, lz, hdg, pitch, range)  -- find a "target" point to measure
    local fx1 = fx - math.cos(hdg)*10   -- find new fx1,fz1 10m in front of fx,fz in the direction we're heading
    local fz1 = fz - math.sin(hdg)*10
    local h = Terrain.GetHeight(fx,fz)  -- grab the two heights
    local h1 = Terrain.GetHeight(fx1,fz1)

    local terrainAngle = math.sin((h-h1)/10)    -- SOHCAHTOA

    return math.abs(pitch-terrainAngle)
end


--[[
    'theta' is the side-to-side (azimuth) scan angle of the radar array.  It sweeps a maximum
    arc of 60 degrees.  Negative values are "left" of the current heading, and positive
    values are "right".

    The increment is by 1 entry.  Conversion to degrees is outside the scope of this iterator.
    If the dimensions of search[][] change, this code has to change.  The draw code would also
    need to adapt.
--]]

function update_theta_search()
    if theta_inc then
        sweep_theta = sweep_theta + 1
    else
        sweep_theta = sweep_theta - 1
    end

    if sweep_theta == -60 or sweep_theta == 60 then
        theta_inc = not theta_inc
    end
    --print_message_to_user("newtheta= "..sweep_theta)
end

--[[
    'rho' is the vertical scan angle, and rangse from +10 degrees above the weapon boresight
    line to -15 degrees below the weapon boresight line.  Note that any AoA compensation
    is managed elsewhere.
--]]
local rho_inc=true
local sweep_rho_idx=1
local obst_range=0
local sweep_obst_range=0
function update_rho_profile(num_idx)
    if rho_inc then
        sweep_rho_idx = sweep_rho_idx + num_idx
    else
        sweep_rho_idx = sweep_rho_idx - num_idx
    end

    if sweep_rho_idx < 1 then
        sweep_rho_idx = 1+ (1-sweep_rho_idx)
        rho_inc = true
        sweep_obst_range=0 -- recheck obstruction on forward sweep
    elseif sweep_rho_idx > #profilemin then
        sweep_rho_idx = #profilemin - (sweep_rho_idx - #profilemin)
        rho_inc = false
        if sweep_obst_range~=0 then
            obst_range = sweep_obst_range
        else
            obst_range = 0 -- no obstruction found on forward sweep
        end
    end
    --print_message_to_user("newrho= "..sweep_rho_idx)
end

--[[
    RADAR SCAN FUNCTIONS

    These functions are responsible for calculating the collision ranges for the
    radar scan in each mode, and populating the appropriate collision distance
    data structure to be used by the draw functions below.
--]]


-- apg53a_scan_search()
--
-- heading: input, heading in game radians (west = pi/2)
-- pitch:   input, pitch to base the scan on
-- thetas:  how many scan segments (changes in theta) to cover on this execution
--
-- note that this mode shares the search[][] array with tc-plan mode
function apg53a_scan_search(heading,pitch,thetas)
    local lx, ly, lz = sensor_data.getSelfCoordinates()
    local rho, hdg

    local rho_steps = 7
    -- search mode has a fixed 5-degree vertical beam height
    local rho_delta = math.rad(5/rho_steps)
    local angle = pitch+math.rad(apg53a_angle)

    local radius = (apg53a_range == "LONG") and 40*nm2meter or 20*nm2meter

    while thetas > 0 do
        hdg = heading - math.rad(sweep_theta/2)   -- negative theta is "left", 2 entries per degree
        for rho = 1,rho_steps do
            local px,py,pz = pointFromVector(lx, ly, lz, hdg, angle+(rho_delta*(rho-4)), radius)
            if py < -200 then   -- if height of radius result is > 200m below surface, rescale it as height Y / height P+Y
                local tempRadiusScale = math.abs(ly)/(math.abs(py)+math.abs(ly)) 
                px,py,pz = pointFromVector(lx, ly, lz, hdg, angle+(rho_delta*(rho-4)), radius*tempRadiusScale)
            end
            local t = sweep_theta+61
            search[t][rho] = find_collision_range(RADAR_RESOLUTION, lx, ly, lz, px, py, pz, false)
            if search[t][rho] > 0 then
                strength[t][rho] = find_visible_slope(lx, ly, lz, hdg, angle, search[t][rho])
            else
                strength[t][rho] = 0
            end
        end
        update_theta_search()
        thetas = thetas - 1
    end
end


-- apg53a_scan_plan()
--
-- heading: input, heading in game radians (west = pi/2)
-- pitch:   input, pitch to base the scan on
-- thetas:  how many scan segments (changes in theta) to cover on this execution
--
-- note that this mode shares the search[][] array with search mode
function apg53a_scan_plan(heading,pitch,thetas)
    local lx, ly, lz = sensor_data.getSelfCoordinates()
    local rho, hdg

    local rho_steps = 7

    -- plan mode is from 5 degrees (min detail) to 0.5 degrees (max detail) of vertical beam
    -- width, split across 'rho_steps' steps
    local rho_delta = math.rad(((1-apg53a_detail)*4.5 + 0.5)/rho_steps)   

    --local angle = pitch+math.rad(apg53a_angle)    -- radar angle not adjustable in plan mode
    local radius = (apg53a_range == "LONG") and 20*nm2meter or 10*nm2meter

    while thetas > 0 do
        hdg = heading - math.rad(sweep_theta/2)   -- negative theta is "left", 2 entries per degree
        for rho = 1,rho_steps do
            local px,py,pz = pointFromVector(lx, ly, lz, hdg, pitch+(rho_delta*(rho-4)), radius)
            if py < -200 then   -- if height of radius result is > 200m below surface, rescale it as height Y / height P+Y
                local tempRadiusScale = math.abs(ly)/(math.abs(py)+math.abs(ly)) 
                px,py,pz = pointFromVector(lx, ly, lz, hdg, pitch+(rho_delta*(rho-4)), radius*tempRadiusScale)
            end
            local t = sweep_theta+61
            search[t][rho] = find_collision_range(RADAR_RESOLUTION, lx, ly, lz, px, py, pz, false)
            if search[t][rho] > 0 then
                strength[t][rho] = find_visible_slope(lx, ly, lz, hdg, pitch, search[t][rho])
            else
                strength[t][rho] = 0
            end
        end
        update_theta_search()
        thetas = thetas - 1
    end
end


-- apg53a_scan_profile()
--
-- heading: input, heading in game radians (west = pi/2)
-- pitch:   input, pitch to base the scan on (flight path for profile mode)
-- rhos:    how many rho entries to update per invocation
--
-- note that this mode uses the profile[][] array
function apg53a_scan_profile(hdg,pitch,rhos)
    local lx, ly, lz = sensor_data.getSelfCoordinates()

    local radius = (apg53a_range == "LONG") and 20*nm2meter or 10*nm2meter

    --print_message_to_user("scan hdg: "..(360-math.deg(hdg)).."  pitch angle: "..math.deg(angle))
    --[[
    for i=1,5 do
        local px,py,pz = pointFromVector(lx,ly,lz,hdg,angle + (rho_delta * (i-3)), radius)
        search[sweep_theta][i] = find_collision_range(5, lx, ly, lz, px, py, pz, false)
    end
    ]]--
    -- detail=1.0, step=1
    -- detail=0.0, step=20
    local rho_idx_step = math.floor((1-apg53a_detail)*profile_rho_per_degree/4)
    if rho_idx_step==0 then
        rho_idx_step=1
    end
    draw={}
    local roll_cos
    local roll_sin
    if false then   -- if roll has effect on radar sweep change this to true
        local roll=sensor_data.getRoll()
        roll_cos=math.cos(roll)
        roll_sin=math.sin(roll)
    else
        roll_cos=1
        roll_sin=0
    end

    while rhos > 0 do
        local sweep_rho=-15+((sweep_rho_idx-1)/#profilemin)*25
        local angle = math.rad(sweep_rho)
        for i = 1,5 do
            local azimuth=math.rad(-2.5+(i-1)*1.25)
            local px,py,pz = pointFromVector(lx, ly, lz, hdg+azimuth*roll_cos+angle*roll_sin, pitch+angle*roll_cos+azimuth*roll_sin, radius)
            profile[i][sweep_rho_idx] = find_collision_range(RADAR_RESOLUTION*4, lx, ly, lz, px, py, pz, false)
            -- TODO: maybe optimise with knowledge of previous range in azimuth sweep, only need to find shorter ranges
            if profile[i][sweep_rho_idx]==0 then
                profile[i][sweep_rho_idx] = radius*16  -- just a big value
            end
            if i==1 then
                profilemin[sweep_rho_idx]=profile[i][sweep_rho_idx]
            else
                profilemin[sweep_rho_idx]=math.min(profilemin[sweep_rho_idx], profile[i][sweep_rho_idx])
            end
        end
        -- TODO: maybe also base blob opacity on variance of the azimuth values, e.g. if all similar then brighter, if large variance then less bright  (e.g use delta between average and minimum)
        -- TODO: maybe estimate terrain angle from successive scans, and use that to simulate return signal attenuation, e.g. front profile of hill will give bright, flat terrain less bright, downward angling terrain least bright
        draw[#draw+1] = sweep_rho_idx
        rhos = rhos - 1
        if sweep_rho_idx < (#profile_1000ft) and profilemin[sweep_rho_idx]~=0 and profilemin[sweep_rho_idx] < profile_1000ft[sweep_rho_idx] and profile_1000ft[sweep_rho_idx]<(radius-RADAR_RESOLUTION*4) and sweep_obst_range==0 then
            sweep_obst_range=profilemin[sweep_rho_idx]
            --print_message_to_user("obst: rho_idx:"..tostring(sweep_rho_idx)..",profilemin:"..tostring(profilemin[sweep_rho_idx])..",1000ft:"..tostring(profile_1000ft[sweep_rho_idx])..",radius:"..tostring(radius-RADAR_RESOLUTION*4))
        end
        update_rho_profile(rho_idx_step)
    end
    for key,value in next,draw,nil do
        apg53a_draw_profile(value)
    end

    --print_message_to_user("hdg_R="..hdg.."  angle_R="..angle)
    --print_message_to_user("hdg="..(360-math.deg(hdg)).."  angle="..math.deg(angle))
    --print_message_to_user("lx="..lx.."  ly="..ly.."  lz="..lz)
    --print_message_to_user("px="..px.."  py="..py.."  pz="..pz)
end


-- apg53a_scan_a2g()
--
-- heading: input, heading in game radians (west = pi/2)
-- pitch:   input, pitch to base the scan on using weapon datum
--
-- note that this mode uses the range[] array
function apg53a_scan_a2g(heading,pitch)
    local filterangle = math.rad( 10 )
    local lx, ly, lz = sensor_data.getSelfCoordinates()
    local hdg

    local theta_steps = 7   -- 0.5 degree wide beam, 7 "rays" 

    local theta_delta = math.rad(0.5/theta_steps)
    local radius = 14000    -- 14km is approx 15,000 yds, max slant range

    for theta = 1,theta_steps do
        hdg = heading - (theta_delta*(theta-4))
        local px,py,pz = pointFromVector(lx, ly, lz, hdg, pitch, radius)
        range[theta] = find_collision_range(RADAR_RESOLUTION/4, lx, ly, lz, px, py, pz, false)

        if find_visible_slope(lx, ly, lz, hdg, pitch, range[theta]) < filterangle then
            range[theta] = 0    -- erase the collision distance
        end
    end
end




--[[
    RADAR DRAW FUNCTIONS

    These functions are responsible for drawing the radar screen in the appropriate modes
    by updating the blob opacity and position for each dot on the radar.
--]]



-- apg53a_draw_search()
--
-- iterates through the search[i][j] array, drawing the collisions at each search
-- distance.  'i' represents left-to-right azimuth with increasing i, and jrepresents
-- increasing rho (relative to the flight path) with increasing j
--
-- width of each 'i' in degrees is fixed (theta) and width of each 'j' is fixed (rho)
-- in the scan phase
--
-- sets a minimum return angle based on gain, from 3 (max gain) to 15 degrees (min gain)
function apg53a_draw_search()
    local i,j
    local scale = (apg53a_range == "LONG") and 1 or 2
    local filterangle = math.rad( 15 - (apg53a_gain*12) )

    local storage_factor = (-1 + (apg53a_storage*0.7))  -- decay by -1 to -0.3

    local bril = math.max(apg53a_brilliance, apg53a_maxb)

    local sweepy = 0.97 - (2*apg53a_erry*math.random())
    if sweepy < -1 then
        sweepy = sweepy + 2
    end
    set_blob( 999, sweep_theta/60, sweepy, 1 ) --debug

    for i=1,121 do
        for j = 1,7 do
            local val = search[i][j]
            local x = ((i-61)/60)
            local y = ((val*scale / (20*nm2meter)) - 1)

            local b = bril
            if not apg53a_warm then
                x = x + (2 * apg53a_errx * math.random())
                if x > 1 then
                    x = x - 2
                end
                y = y + (2 * apg53a_erry * math.random())
                if y > 1 then
                    y = y - 2
                end
                b = bril*math.random()
            else
                y = y + (apg53a_shimmy * math.random())
            end

            --print_message_to_user(y)
            if val > 0 then
                if strength[i][j] > filterangle then
                    set_blob( j*121+i, x, y, b )    -- max brilliance for hits facing us by >= 10 degrees
                else
                    set_blob( j*121+i, x, y, b*math.abs(strength[i][j])/filterangle )
                end
            else
                change_blob_opacity( j*121+i, storage_factor )
            end
        end
    end
end


-- apg53a_draw_plan()
--
-- iterates through the search[i][j] array, drawing the collisions at the search distance
-- i represents left-to-right azimuth with increasing i, and increasing j represents
-- increasing rho above the horizon.
--
-- width of i is fixed (theta) and width of j is adjustable with the 'detail' input, as
-- modified during the scan phase
--
-- max displayed range is 20nm in "LONG" mode and 10nm in "SHORT" mode
--
-- sets a minimum return angle based on gain, from 3 (max gain) to 15 degrees (min gain)
function apg53a_draw_plan()
    local i,j
    local scale = (apg53a_range == "LONG") and 1 or 2
    local filterangle = math.rad( 15 - (apg53a_gain*12) )

    local storage_factor = (-1 + (apg53a_storage*0.7))  -- decay by -1 to -0.3

    local bril = math.max(apg53a_brilliance, apg53a_maxb)

    local sweepy = 0.97 - (2*apg53a_erry*math.random())
    if sweepy < -1 then
        sweepy = sweepy + 2
    end
    set_blob( 999, sweep_theta/60, sweepy, 1 ) --debug

    for i=1,121 do
        for j = 1,7 do
            local val = search[i][j]
            local x = ((i-61)/60)
            local y = ((val*scale / (10*nm2meter)) - 1)
            --print_message_to_user(y)

            local b = bril
            if not apg53a_warm then
                x = x + (2 * apg53a_errx * math.random())
                if x > 1 then
                    x = x - 2
                end
                y = y + (2 * apg53a_erry * math.random())
                if y > 1 then
                    y = y - 2
                end
                b = bril*math.random()
            else
                y = y + (apg53a_shimmy * math.random())
            end

            if val > 0 then
                if strength[i][j] > filterangle then
                    set_blob( j*121+i, x, y, b )    -- max brilliance for hits facing us by >= 10 degrees
                else
                    set_blob( j*121+i, x, y, b*math.abs(strength[i][j])/filterangle )
                end
            else
                change_blob_opacity( j*121+i, storage_factor )
            end
        end
    end
end


local prev_drawn_rho_idx=1
function apg53a_draw_profile(rho_idx)
    if apg53a_range == "LONG" then
        radius = 20 * nm2meter
    else
        radius = 10 * nm2meter
    end

    local drawn=false
    dist=profilemin[rho_idx]
    if dist==0 then
        dist = 100 * nm2meter
    end
    local y=-1+2*((rho_idx-1)/(#profilemin))
    local x=-1+2*(dist/radius)

    local bril = math.max(apg53a_brilliance, apg53a_maxb)

    if not apg53a_warm then
        x = x + (2 * apg53a_errx * math.random())
        if x > 1 then
            x = x - 2
        end
        y = y + (2 * apg53a_erry * math.random())
        if y > 1 then
            y = y - 2
        end
        bril = bril * math.random()
    end

    if dist > radius then
        set_blob_opacity(rho_idx, 0)
    else
        set_blob(rho_idx, x, y + (0.03*math.random()), bril)
    end
    if (math.abs(prev_drawn_rho_idx-rho_idx) ~= 1) then
        -- clear inbetween blobs
        for i=math.min(prev_drawn_rho_idx,rho_idx)+1,math.max(prev_drawn_rho_idx,rho_idx)-1 do
            set_blob_opacity(i, 0)
        end
    end
    prev_drawn_rho_idx = rho_idx
end

local prev_obst_range=0
local obst_timer=0
--TODO audio tone 400cps
function apg53a_check_profile_obstruction()
    if not apg53a_warm then
        profile_obstruction = 0
    elseif obst_range~=0 and prev_obst_range==0 then
        obst_timer=0
        profile_obstruction=1
    elseif prev_obst_range~=0 and obst_range==0 then
        profile_obstruction=0
    elseif prev_obst_range~=0 and obst_range~=0 then
        obst_timer=obst_timer+update_time_step
        if obst_timer>obstruction_period then
            obst_timer=0
            profile_obstruction=1
        else
            if apg53a_range == "LONG" then
                radius = 20 * nm2meter
            else
                radius = 10 * nm2meter
            end
            if obst_timer < (1-(obst_range/radius))*obstruction_period then
                profile_obstruction=1
            else
                profile_obstruction=0
            end
        end
    else
        profile_obstruction=0
    end
    if profile_obstruction==1 and not obsttone:is_playing() then
        obsttone:update(nil,apg53a_volume,nil)
        obsttone:play_continue()
    elseif profile_obstruction==0 and obsttone:is_playing() then
        obsttone:stop()
    end

    prev_obst_range = obst_range
end

-- apg53a_draw_a2g()
--
-- iterates through the range[i] array and finds the minimum collision distance. it then
-- draws a line across the screen at 4000 yds per division.  Screen max is 20,000yds, but
-- max effective range is about 15,000 yds.
--
-- if the radar doesn't have a lock, draws a range sweeping horizontal line from top to
-- bottom, roughly once per second.  Line sweep stops at the proper range when lock is
-- gained. position.  If lock is lost, sweep starts from the current line position.
function apg53a_draw_a2g()
    local r = 99999
    local locked = false
    for i = 1,7 do
        if range[i] > 0 then
            r = math.min(range[i], r)
            locked = true
            a2g_waslocked = true
        end
    end
	
	if locked then
		efm_data_bus.fm_setRadarSlantRange(r)
	else
		efm_data_bus.fm_setRadarSlantRange(-1.0)
	end

    --map r to a height for the line (y)
    local y = ((r*2)/18288)-1 -- convert from meters of distance display position -1 to 1

    -- continue sweep while locked until line intersects the position we want on the screen
    local converged
    if math.abs(a2g_range - y) < 0.2 then
        converged = true
    else
        converged = false
        a2g_range = a2g_range - (update_time_step*2)    -- sweep a2g_range while not converged
        if a2g_range < -1.0 then
            a2g_range = 1.0
        end
    end
    
    if not locked and a2g_waslocked then
        a2g_range = a2g_lasty
        a2g_waslocked = false
    end

    if locked and converged then
        a2g_lasty = y   -- save y for when/if we lose lock
        a2g_range = y   -- move a2g_range to the new position too, to avoid the jump
        -- arbitrarilly draw 121 blobs to form our search line
        for j = 1,61 do
            if not apg53a_warm then
                local x = (j-31)/30
                x = x + (2*apg53a_errx*math.random())
                if x > 1 then
                    x = x - 2
                end
                local scany = y + (2*apg53a_erry*math.random())
                if scany > 1 then
                    scany = scany - 2
                end
                local bril = math.max(apg53a_brilliance, apg53a_maxb)
                set_blob(j, x, scany, bril*math.random())
            else
                set_blob(j, (j-31)/30, y+(apg53a_shimmy*math.random()), apg53a_brilliance)
            end
        end
    else
        -- not locked or not converged, continue drawing sweep line
        for j = 1,61 do
            if not apg53a_warm then
                local x = (j-31)/30
                x = x + (2*apg53a_errx*math.random())
                if x > 1 then
                    x = x - 2
                end
                local scany = a2g_range + (2*apg53a_erry*math.random())
                if scany > 1 then
                    scany = scany - 2
                end
                local bril = math.max(apg53a_brilliance, apg53a_maxb)
                set_blob(j, x, scany, bril*math.random())
            else
                set_blob(j, (j-31)/30, a2g_range+(apg53a_shimmy*math.random()), apg53a_brilliance)
            end
        end
    end
end

function check_disabled()
    if cpp_radar_disabled then
        efm_data_bus.fm_setRadarDisabled(1.0)
        return false
    else
        efm_data_bus.fm_setRadarDisabled(0.0)
        return true
    end
end


function SetCommand(command,value)

    --[[
    if command == device_commands.radar_storage then
        if value > 0.5 then
            cpp_radar_disabled = true
            check_disabled()
        else
            cpp_radar_disabled = false
            check_disabled()
        end
    end
    ]]


    --print_message_to_user(value)
    if check_disabled() then
        return
    end


    local mode_changed=false
    if command == device_commands.radar_planprofile then
        apg53a_planprofile = apg53a_planprofilelist[ value+1 ]
        mode_changed=true
    elseif command == device_commands.radar_range then
        apg53a_range = apg53a_rangelist[ value+1 ]
        mode_changed=true
    elseif command == device_commands.radar_storage then
        apg53a_storage = value -- direct value from knob, scale elsewhere
        if apg53a_storage < -0.5 then
            dev:performClickableAction(device_commands.radar_storage, 1, false)
        elseif apg53a_storage < 0 and apg53a_storage >= -0.5 then
            dev:performClickableAction(device_commands.radar_storage, 0, false)
        end
    elseif command == device_commands.radar_brilliance then
        apg53a_brilliance = value -- direct value from knob, scale elsewhere
        if apg53a_brilliance < -0.5 then
            dev:performClickableAction(device_commands.radar_brilliance, 1, false)
        elseif apg53a_brilliance < 0 and apg53a_brilliance >= -0.5 then
            dev:performClickableAction(device_commands.radar_brilliance, 0, false)
        end
    elseif command == device_commands.radar_detail then
        apg53a_detail = value -- direct value from knob, scale elsewhere
        if apg53a_detail < -0.5 then
            dev:performClickableAction(device_commands.radar_detail, 1, false)
        elseif apg53a_detail < 0 and apg53a_detail >= -0.5 then
            dev:performClickableAction(device_commands.radar_detail, 0, false)
        end
    elseif command == device_commands.radar_gain then
        apg53a_gain = value -- direct value from knob, scale elsewhere
        if apg53a_gain < -0.5 then
            dev:performClickableAction(device_commands.radar_gain, 1, false)
        elseif apg53a_gain < 0 and apg53a_gain >= -0.5 then
            dev:performClickableAction(device_commands.radar_gain, 0, false)
        end
    elseif command == device_commands.radar_reticle then
        apg53a_reticle = value -- direct value from knob, scale elsewhere
        if apg53a_reticle < -0.5 then
            dev:performClickableAction(device_commands.radar_reticle, 1, false)
        elseif apg53a_reticle < 0 and apg53a_reticle >= -0.5 then
            dev:performClickableAction(device_commands.radar_reticle, 0, false)
        end
        radar_grid_op:set(apg53a_reticle)
    elseif command == device_commands.radar_mode then
        apg53a_input = apg53a_inputlist[ round((value*10)+1,0) ]
        mode_changed=true
    elseif command == device_commands.radar_aoacomp then
        apg53a_aoacomp = (value == 1) and true or false
    elseif command == device_commands.radar_angle then
        apg53a_angle = 25 * (0.4 - value)   -- negative values point below the nose
        apg53a_angle_value = value
    elseif command == device_commands.radar_angle_axis then
        dev:performClickableAction(device_commands.radar_angle, apg53a_angle_value + value/20, false )
    elseif command == device_commands.radar_angle_axis_abs then
        if value < 0 then value = 0 end
        dev:performClickableAction(device_commands.radar_angle, value, false)
    elseif command == device_commands.radar_volume then
        apg53a_volume = value -- direct value from knob, scale elsewhere
        if apg53a_volume < -0.5 then
            dev:performClickableAction(device_commands.radar_volume, 1, false)
        elseif apg53a_volume < 0 and apg53a_volume >= -0.5 then
            dev:performClickableAction(device_commands.radar_volume, 0, false)
        else
            obsttone:update(nil,apg53a_volume,nil)
        end
    elseif command == device_commands.radar_filter then
        radar_filter_param:set(1-value)
    elseif command == Keys.RadarModeOFF then
        dev:performClickableAction(device_commands.radar_mode, 0.0, false)
    elseif command == Keys.RadarModeSTBY then
        dev:performClickableAction(device_commands.radar_mode, 0.1, false)
    elseif command == Keys.RadarModeSearch then
        dev:performClickableAction(device_commands.radar_mode, 0.2, false)
    elseif command == Keys.RadarModeTC then
        dev:performClickableAction(device_commands.radar_mode, 0.3, false)
    elseif command == Keys.RadarModeA2G then
        dev:performClickableAction(device_commands.radar_mode, 0.4, false)
    elseif command == Keys.RadarMode then
        if apg53a_state == "apg53a-off" then
            dev:performClickableAction(device_commands.radar_mode, 0.1, false)  -- off advances to standby
        elseif apg53a_state == "apg53a-stby" then
            dev:performClickableAction(device_commands.radar_mode, 0.2, false)  -- standby advances to search
        elseif apg53a_state == "apg53a-search" then
            dev:performClickableAction(device_commands.radar_mode, 0.3, false)  -- search advances to TC
        elseif apg53a_state == "apg53a-tc-plan" or apg53a_state == "apg53a-tc-profile" then
            dev:performClickableAction(device_commands.radar_mode, 0.4, false)  -- TC advances to A2G
        elseif apg53a_state == "apg53a-range" then
            dev:performClickableAction(device_commands.radar_mode, 0.2, false)  -- A2G cycles back to search
        end
    elseif command == Keys.RadarModeCW then
        if apg53a_state == "apg53a-off" then
            dev:performClickableAction(device_commands.radar_mode, 0.1, false)  -- off advances to standby
        elseif apg53a_state == "apg53a-stby" then
            dev:performClickableAction(device_commands.radar_mode, 0.2, false)  -- standby advances to search
        elseif apg53a_state == "apg53a-search" then
            dev:performClickableAction(device_commands.radar_mode, 0.3, false)  -- search advances to TC
        elseif apg53a_state == "apg53a-tc-plan" or apg53a_state == "apg53a-tc-profile" then
            dev:performClickableAction(device_commands.radar_mode, 0.4, false)  -- TC advances to A2G
        elseif apg53a_state == "apg53a-range" then
            -- range is the last CW mode
        end
    elseif command == Keys.RadarModeCCW then
        if apg53a_state == "apg53a-off" then
            -- off is the last CCW mode
        elseif apg53a_state == "apg53a-stby" then
            dev:performClickableAction(device_commands.radar_mode, 0.0, false)  -- standby goes back to off
        elseif apg53a_state == "apg53a-search" then
            dev:performClickableAction(device_commands.radar_mode, 0.1, false)  -- search goes back to standby
        elseif apg53a_state == "apg53a-tc-plan" or apg53a_state == "apg53a-tc-profile" then
            dev:performClickableAction(device_commands.radar_mode, 0.2, false)  -- TC goes back to search
        elseif apg53a_state == "apg53a-range" then
            dev:performClickableAction(device_commands.radar_mode, 0.3, false)  -- A2G cycles back to plan/profile
        end
    elseif command == Keys.RadarTCPlanProfile then
        if value == 1 then
            dev:performClickableAction(device_commands.radar_planprofile, 1, false)
        elseif value == 0 then
            dev:performClickableAction(device_commands.radar_planprofile, 0, false)
        elseif value == -1 then
            if apg53a_planprofile == "PLAN" then
                dev:performClickableAction(device_commands.radar_planprofile, 1, false) -- in PLAN, switch to PROFILE
            else
                dev:performClickableAction(device_commands.radar_planprofile, 0, false) -- in PROFILE, switch to PLAN
            end
        end
    elseif command == Keys.RadarRangeLongShort then
        if value == 1 then
            dev:performClickableAction(device_commands.radar_range, 1, false)
        elseif value == 0 then
            dev:performClickableAction(device_commands.radar_range, 0, false)
        elseif value == -1 then
            if apg53a_range == "SHORT" then
                dev:performClickableAction(device_commands.radar_range, 1, false)   -- in SHORT switch to LONG
            else
                dev:performClickableAction(device_commands.radar_range, 0, false)   -- in LONG switch to SHORT
            end
        end
    elseif command == Keys.RadarAoAComp then
        if value == 1 then
            dev:performClickableAction(device_commands.radar_aoacomp, 1, false)
        elseif value == 0 then
            dev:performClickableAction(device_commands.radar_aoacomp, 0, false)
        elseif value == -1 then
            if apg53a_aoacomp then
                dev:performClickableAction(device_commands.radar_aoacomp, 0, false) -- AoA Compensation ON, Disable it
            else
                dev:performClickableAction(device_commands.radar_aoacomp, 1, false) -- AoA Compensation OFF, Enable it
            end
        end
    elseif command == Keys.RadarVolume then
        if value == 1 then
            dev:performClickableAction(device_commands.radar_volume, clamp(apg53a_volume+0.1, 0, 1), false)
        elseif value == 0 then
            dev:performClickableAction(device_commands.radar_volume, clamp(apg53a_volume-0.1, 0, 1), false)
        end
    elseif command == Keys.RadarTiltInc then
        dev:performClickableAction(device_commands.radar_angle, clamp(apg53a_angle_value+0.04, 0, 1), false)
    elseif command == Keys.RadarTiltDec then
        dev:performClickableAction(device_commands.radar_angle, clamp(apg53a_angle_value-0.04, 0, 1), false)
    elseif command == Keys.RadarTiltStartUp then
        radar_tilt_moving = 1
    elseif command == Keys.RadarTiltStartDown then
        radar_tilt_moving = -1
    elseif command == Keys.RadarTiltStop then
        radar_tilt_moving = 0
    elseif command == Keys.RadarVolumeStartUp then
        radar_volume_moving = 1
    elseif command == Keys.RadarVolumeStartDown then
        radar_volume_moving = -1
    elseif command == Keys.RadarVolumeStop then
        radar_volume_moving = 0
    end

    if mode_changed then -- XXX temporary hack to display (or clear) profile scribe on change of mode, range or plan/profile
        local scribe_range=0
        if apg53a_planprofile=="PROFILE" and apg53a_input=="TC" then
            scribe_range=(apg53a_range == "LONG") and 20 or 10
        end
        set_profile_scribe(scribe_range)
    end
end

function change_state(old_state, new_state)
    local timenow = get_model_time() -- time since spawn in seconds
    local state=old_state
    -- procedures for exiting each state
    if state == "apg53a-off" then
    elseif state == "apg53a-stby" then
    elseif state == "apg53a-search" then
        dev:performClickableAction(device_commands.radar_angle, 0.4, false)  -- exiting search reverts radar angle to 0 degrees
        clear_search_blobs()
        clear_search_array()    -- clear search[][] on exit
        clear_strength_array()
        set_blob( 999, sweep_theta/60, 0, 0 ) --debug (disable the debug blob)
    elseif state == "apg53a-tc-plan" then
        clear_search_blobs()
        clear_search_array()    -- clear search[][] on exit
        clear_strength_array()
        set_blob( 999, sweep_theta/60, 0, 0 ) --debug (disable the debug blob)
    elseif state == "apg53a-tc-profile" then
        clear_all_blobs()
        set_profile_scribe(0)
        profile_obstruction=0
        obsttone:stop()
    elseif state == "apg53a-range" then
        clear_range_blobs()
        clear_range_array()
    end

    state=new_state
    -- procedures for entering each state
    if state == "apg53a-off" then
        clear_all_blobs()
        set_profile_scribe(0)
        apg53a_warm = false
        apg53a_off_time = timenow   -- record when it was turned off, to bound re-warmup time
    elseif state == "apg53a-stby" then
        clear_all_blobs()
        set_profile_scribe(0)
    elseif state == "apg53a-search" then
    elseif state == "apg53a-tc-plan" then
    elseif state == "apg53a-tc-profile" then
        clear_all_blobs()
        local scribe_range=(apg53a_range == "LONG") and 20 or 10
        set_profile_scribe(scribe_range)
        profile_obstruction=0
    elseif state == "apg53a-range" then
    end

end

function update_apg53a()
    local timenow = get_model_time() -- time since spawn in seconds
    local hdg = sensor_data.getHeading()
    local pitch = sensor_data.getPitch()
    local aoa = sensor_data.getAngleOfAttack()

    local vertical_aoa = math.cos(sensor_data.getRoll()) * aoa  -- correct for high AoA in the lateral plane

    local state = apg53a_state
    local input = apg53a_input

    local p 
    if apg53a_aoacomp then
        p = pitch-vertical_aoa  -- flight path if AoA compensation enabled
    else
        p = pitch-math.rad(3)   -- else fixed to armament boresight
    end

    if not apg53a_warm and timenow >= apg53a_warmup_timer and apg53a_state ~= "apn153-off" then
        apg53a_warm = true
        --print_message_to_user("AN/APG-53A: warmup complete, time:"..timenow)
    end

    if not apg53a_warm then
        local apg53a_remaining = apg53a_warmup_timer - timenow
        local wup = apg53a_wup_time
        local window = 30   -- point at which screen starts to show
        local apg53a_pct = ((wup-(apg53a_remaining*(wup/window)))/wup)   -- 0 to 1 percentage complete of final 30 seconds, 1 indicates warmed up
        if apg53a_remaining > window then
            apg53a_errx = 1
            apg53a_erry = 1
            apg53a_maxb = .2
        else
            apg53a_erry = math.cos( apg53a_pct * math.pi/2 )
            apg53a_errx = math.cos( apg53a_pct * math.pi/2 )
            apg53a_maxb = apg53a_pct*0.8 + 0.2
        end
    end


    if state == "apg53a-off" then
        if input ~= "OFF" then
            if input == "STBY" then apg53a_state = "apg53a-stby"
            elseif input == "SRCH" then apg53a_state = "apg53a-search"
            elseif input == "TC" and apg53a_planprofile == "PLAN" then apg53a_state = "apg53a-tc-plan"
            elseif input == "TC" and apg53a_planprofile == "PROFILE" then apg53a_state = "apg53a-tc-profile"
            elseif input == "A/G" then apg53a_state = "apg53a-range"
            end
            --print_message_to_user("AN/APG-53A: warmup starting, time:"..timenow)
            -- default warmup is 3 minutes
            -- if radar has been off for less than 3 minutes, warmup = half the off time (minimum of 30 seconds)
            local delta = timenow - apg53a_off_time
            if delta < apg53a_wup_time then
                apg53a_warmup_timer = timenow + delta/2
                if apg53a_warmup_timer - timenow < 30 then
                    apg53a_warmup_timer = timenow + 30
                end
            else
                apg53a_warmup_timer = timenow + apg53a_wup_time
            end
            apg53a_warm = false
            change_state(state, apg53a_state)
        else
            apg53a_leftrange:set(0)
            apg53a_bottomrange:set(0)
            if apg53a_gain == 1.0 and apg53a_detail == 1.0 and apg53a_reticle == 0.0 and apg53a_storage == 1.0 then
                draw_xyz(apg53a_brilliance)
            end
        end
    elseif state == "apg53a-stby" then
        if input ~= "STBY" then
            if input == "OFF" then apg53a_state = "apg53a-off"
            elseif input == "SRCH" then apg53a_state = "apg53a-search"
            elseif input == "TC" and apg53a_planprofile == "PLAN" then apg53a_state = "apg53a-tc-plan"
            elseif input == "TC" and apg53a_planprofile == "PROFILE" then apg53a_state = "apg53a-tc-profile"
            elseif input == "A/G" then apg53a_state = "apg53a-range"
            end
            change_state(state, apg53a_state)
        else
            apg53a_leftrange:set(0)
            apg53a_bottomrange:set(0)
        end
    elseif state == "apg53a-search" then
        if input ~= "SRCH" then
            if input == "OFF" then apg53a_state = "apg53a-off"
            elseif input == "STBY" then apg53a_state = "apg53a-stby"
            elseif input == "TC" and apg53a_planprofile == "PLAN" then apg53a_state = "apg53a-tc-plan"
            elseif input == "TC" and apg53a_planprofile == "PROFILE" then apg53a_state = "apg53a-tc-profile"
            elseif input == "A/G" then apg53a_state = "apg53a-range"
            end
            change_state(state, apg53a_state)
        else
            apg53a_leftrange:set(0)
            apg53a_bottomrange:set(apg53a_range == "LONG" and .4 or .2)
            apg53a_scan_search(hdg,p,6) -- populates 5 columns of search data into search[][]
            apg53a_draw_search()        -- draws all search data from search[][]
        end
    elseif state == "apg53a-tc-plan" then
        if input ~= "TC" or apg53a_planprofile ~= "PLAN" then
            if input == "OFF" then apg53a_state = "apg53a-off"
            elseif input == "STBY" then apg53a_state = "apg53a-stby"
            elseif input == "SRCH" then apg53a_state = "apg53a-search"
            elseif input == "TC" and apg53a_planprofile == "PROFILE" then apg53a_state = "apg53a-tc-profile"
            elseif input == "A/G" then apg53a_state = "apg53a-range"
            end
            change_state(state, apg53a_state)
        else
            apg53a_leftrange:set(0)
            apg53a_bottomrange:set(apg53a_range == "LONG" and .2 or .1)
            apg53a_scan_plan(hdg,p,6)   -- populates 5 columns of plan data into search[][]
            apg53a_draw_plan()          -- draws all plan data from search[][]
        end
    elseif state == "apg53a-tc-profile" then
        if input ~= "TC" or apg53a_planprofile ~= "PROFILE" then
            if input == "OFF" then apg53a_state = "apg53a-off"
            elseif input == "STBY" then apg53a_state = "apg53a-stby"
            elseif input == "SRCH" then apg53a_state = "apg53a-search"
            elseif input == "TC" and apg53a_planprofile == "PLAN" then apg53a_state = "apg53a-tc-plan"
            elseif input == "A/G" then apg53a_state = "apg53a-range"
            end
            change_state(state, apg53a_state)
        else
            -- terrain clearance profile mode
            apg53a_leftrange:set(apg53a_range == "LONG" and .2 or .1)
            apg53a_bottomrange:set(0)
            apg53a_scan_profile(hdg,p,60)    -- calls update_rho_profile() and apg53a_draw_profile() too
            apg53a_check_profile_obstruction()
        end
    elseif state == "apg53a-range" then
        if input ~= "A/G" then
            if input == "OFF" then apg53a_state = "apg53a-off"
            elseif input == "STBY" then apg53a_state = "apg53a-stby"
            elseif input == "SRCH" then apg53a_state = "apg53a-search"
            elseif input == "TC" and apg53a_planprofile == "PLAN" then apg53a_state = "apg53a-tc-plan"
            elseif input == "TC" and apg53a_planprofile == "PROFILE" then apg53a_state = "apg53a-tc-profile"
            end
            change_state(state, apg53a_state)
        else
            apg53a_leftrange:set(0)
            apg53a_bottomrange:set(0)
            -- add -efm_data_bus.fm_getGunsightAngle() to allow gunsight angle slaved radar
            apg53a_scan_a2g(hdg,pitch-math.rad(3))  -- performs range array update[], always uses weapon datum - minus the gunsight angle
			 --apg53a_scan_a2g(hdg,pitch)  -- performs range array update[], always uses weapon datum
            apg53a_draw_a2g()
        end
    end

    -- green glow for radar scope
    -- refactor code to only set glow to off if state has changed. Consider moving it to state change code?
    if apg53a_state == "apg53a-off" or apg53a_state == "apg53a-stby" then
        apg53a_glow_param:set(0)
    else
        local jitter = math.random() / 50 -- calculate jitter for radar scope to simulate changing scope image
        local glow_value = (0.3 + jitter) * apg53a_brilliance * get_cockpit_draw_argument_value(radar_filter_position_arg)
        apg53a_glow_param:set(glow_value)
    end
end

local elec_26=true
function update()

    if check_disabled() then
        return
    end


    if get_elec_26V_ac_ok() then
        if not elec_26 then -- triggered on power restoration
            change_state(apg53a_state, apg53a_state)
        end
        update_apg53a()
        elec_26=true
    else
        if elec_26 then -- triggered on power failure
            clear_all_blobs()
            set_profile_scribe(0)
            apg53a_warm = false
            apg53a_off_time = timenow   -- record when it was turned off, to bound re-warmup time
            apg53a_state = "apg53a-off"
        end
        elec_26=false
    end

    if get_elec_primary_ac_ok() then
        local obst_val=profile_obstruction
        if master_test_param:get()==1 then
            obst_val = 1
        end

        glare_obst_light:set(obst_val)
    end

    -- continuous knob movements
    if radar_tilt_moving ~= 0 then
        dev:performClickableAction(device_commands.radar_angle, clamp(apg53a_angle_value + 0.02 * radar_tilt_moving, 0, 1), false)
    end
    if radar_volume_moving ~= 0 then
        dev:performClickableAction(device_commands.radar_volume, clamp(apg53a_volume + 0.02 * radar_volume_moving, 0, 1), false)
    end
end

need_to_be_closed = false -- close lua state after initialization
