dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/mission.lua")
dofile(LockOn_Options.script_path.."Nav/NAV_util.lua")

startup_print("nav: load")

local dev = GetSelf()

local Terrain = require('terrain')
--local dllWeather = require('Weather')

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

local sensor_data = get_base_data()
local meter2mile = 0.000621371
local meter2feet = 3.28084
local knot2meter = 1852
local nm2meter = 1852

local degrees_per_radian = 57.2957795
--local feet_per_meter_per_minute = 196.8


----------------------
local carrier_posx_param = get_param_handle("CARRIER_POSX")
local carrier_posz_param = get_param_handle("CARRIER_POSZ")
local cvn_tcn_id = nil

local tacan_channel_param = get_param_handle("TACAN_CHANNEL")

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- AN/APN-153(V) STATE, OUTPUT and INDICATORS
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- apn-153 state and input processing
apn153_inputlist = {"OFF", "STBY", "LAND", "SEA", "TEST"}
local apn153_input = "OFF"
local apn153_state = "apn153-off"
local apn153_tempcondition = 0
local apn153_warmup_timer = 0
local apn153_test_timer = 99999
local apn153_memorylight_test = 0
local apn153_test_running = false -- check if test is running

-- apn-153 shared output data
local apn153_gs = get_param_handle("APN153-GS")
local apn153_drift = get_param_handle("APN153-DRIFT")
local apn153_wind_speed = get_param_handle("APN153-WIND-SPEED")
local apn153_wind_dir = get_param_handle("APN153-WIND-DIR")

-- apn-153 indicators
local apn153_speed_Xnn = get_param_handle("APN153-SPEED-Xnn")
local apn153_speed_nXn = get_param_handle("APN153-SPEED-nXn")
local apn153_speed_nnX = get_param_handle("APN153-SPEED-nnX")
local apn153_drift_gauge = get_param_handle("APN153-DRIFT-GAUGE")
local apn153_memorylight = get_param_handle("APN153-MEMORYLIGHT")

-- apn-153 constants
local APN153_WARMUP_TIME = 300 -- warmup time duration in seconds
local APN153_COOLDOWN_TIME = 900 -- cooldown time duration in seconds. This number is an arbitrary number
local APN153_WARMUP_DELTA = 100 / (APN153_WARMUP_TIME / update_time_step) -- calculate percentage warmup per simulation time step
local APN153_COOLDOWN_DELTA = 100 / (APN153_COOLDOWN_TIME / update_time_step) -- calculate percentage cooldown per simulation time step

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- AN/ASN-41 STATE, OUTPUT and INDICATORS
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- asn-41 state and input processing
asn41_inputlist = {"TEST", "OFF", "STBY", "D1", "D2"}
local asn41_state = "asn41-off"
local asn41_input = "OFF"

local asn41_ppos_lat = 0
local asn41_ppos_lon = 0
local asn41_ppos_lat_offset = 0
local asn41_ppos_lon_offset = 0

local asn41_d1_lat = 0
local asn41_d1_lon = 0
local asn41_d1_lat_offset = 0
local asn41_d1_lon_offset = 0

local asn41_d2_lat = 0
local asn41_d2_lon = 0
local asn41_d2_lat_offset = 0
local asn41_d2_lon_offset = 0

local asn41_magvar_offset = 0
local asn41_winddir_offset = 0
local asn41_windspeed_offset = 0

local ppos_lat_push_state = 0
local ppos_lon_push_state = 0
local dest_lat_push_state = 0
local dest_lon_push_state = 0
local asn41_magvar_push_state = 0
local asn41_windspeed_push_state = 0
local asn41_winddir_push_state = 0

-- asn-41 shared output data
local asn41_valid = get_param_handle("ASN41-VALID")
local asn41_bearing = get_param_handle("ASN41-BEARING")     -- calculated magnetic bearing to target
local asn41_track = get_param_handle("ASN41-TRACK")         -- calculated magnetic ground track to target
local asn41_range = get_param_handle("ASN41-RANGE")         -- calculated range to target

-- asn-41 indicators
local nav_curpos_lat_Xnnnn = get_param_handle("NAV_CURPOS_LAT_Xnnnn")
local nav_curpos_lat_nXnnn = get_param_handle("NAV_CURPOS_LAT_nXnnn")
local nav_curpos_lat_nnXnn = get_param_handle("NAV_CURPOS_LAT_nnXnn")
local nav_curpos_lat_nnnXn = get_param_handle("NAV_CURPOS_LAT_nnnXn")
local nav_curpos_lat_nnnnX = get_param_handle("NAV_CURPOS_LAT_nnnnX")

local nav_curpos_lon_Xnnnnn = get_param_handle("NAV_CURPOS_LON_Xnnnnn")
local nav_curpos_lon_nXnnnn = get_param_handle("NAV_CURPOS_LON_nXnnnn")
local nav_curpos_lon_nnXnnn = get_param_handle("NAV_CURPOS_LON_nnXnnn")
local nav_curpos_lon_nnnXnn = get_param_handle("NAV_CURPOS_LON_nnnXnn")
local nav_curpos_lon_nnnnXn = get_param_handle("NAV_CURPOS_LON_nnnnXn")
local nav_curpos_lon_nnnnnX = get_param_handle("NAV_CURPOS_LON_nnnnnX")

local nav_dest_lat_Xnnnn = get_param_handle("NAV_DEST_LAT_Xnnnn")
local nav_dest_lat_nXnnn = get_param_handle("NAV_DEST_LAT_nXnnn")
local nav_dest_lat_nnXnn = get_param_handle("NAV_DEST_LAT_nnXnn")
local nav_dest_lat_nnnXn = get_param_handle("NAV_DEST_LAT_nnnXn")
local nav_dest_lat_nnnnX = get_param_handle("NAV_DEST_LAT_nnnnX")

local nav_dest_lon_Xnnnnn = get_param_handle("NAV_DEST_LON_Xnnnnn")
local nav_dest_lon_nXnnnn = get_param_handle("NAV_DEST_LON_nXnnnn")
local nav_dest_lon_nnXnnn = get_param_handle("NAV_DEST_LON_nnXnnn")
local nav_dest_lon_nnnXnn = get_param_handle("NAV_DEST_LON_nnnXnn")
local nav_dest_lon_nnnnXn = get_param_handle("NAV_DEST_LON_nnnnXn")
local nav_dest_lon_nnnnnX = get_param_handle("NAV_DEST_LON_nnnnnX")

local asn41_windspeed_Xxx = get_param_handle("ASN41-WINDSPEED-Xxx")
local asn41_windspeed_xXx = get_param_handle("ASN41-WINDSPEED-xXx")
local asn41_windspeed_xxX = get_param_handle("ASN41-WINDSPEED-xxX")

local asn41_winddir_Xxx = get_param_handle("ASN41-WINDDIR-Xxx")
local asn41_winddir_xXx = get_param_handle("ASN41-WINDDIR-xXx")
local asn41_winddir_xxX = get_param_handle("ASN41-WINDDIR-xxX")

local asn41_magvar_Xxxxx = get_param_handle("ASN41-MAGVAR-Xxxxx")
local asn41_magvar_xXxxx = get_param_handle("ASN41-MAGVAR-xXxxx")
local asn41_magvar_xxXxx = get_param_handle("ASN41-MAGVAR-xxXxx")
local asn41_magvar_xxxXx = get_param_handle("ASN41-MAGVAR-xxxXx")
local asn41_magvar_xxxxX = get_param_handle("ASN41-MAGVAR-xxxxX")


-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- BDHI STATE, OUTPUT and INDICATORS
-----------------------------------------------------------------------
-----------------------------------------------------------------------

bdhi_modelist = {"NAVPAC", "TACAN", "NAVCMPTR"}
bdhi_mode = "TACAN"

local bdhi_hdg = get_param_handle("BDHI_HDG")
local bdhi_needle1 = get_param_handle("BDHI_NEEDLE1")
local bdhi_needle2 = get_param_handle("BDHI_NEEDLE2")
local bdhi_ils_gs = get_param_handle("BDHI_ILS_GS")
local bdhi_ils_loc = get_param_handle("BDHI_ILS_LOC")

local bdhi_dme_flag = get_param_handle("BDHI_DME_FLAG")
local bdhi_dme_Xxx = get_param_handle("BDHI_DME_Xxx")
local bdhi_dme_xXx = get_param_handle("BDHI_DME_xXx")
local bdhi_dme_xxX = get_param_handle("BDHI_DME_xxX")



-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- ARN-52V TACAN STATE, OUTPUT and INDICATORS
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- arn-52 state and input processing
tacan_modelist = {"OFF", "REC", "T/R", "A/A"}
local tacan_mode = "OFF"
local tacan_volume = 0
local tacan_ch_major = 0
local tacan_ch_minor = 1
local tacan_channel = 1
local tacan_channel_last = 1

-- arn-52 shared output data
local arn52_range = nil
local arn52_bearing = nil
local atcn -- "active tacan"




-- Variables

-- beacon_data[] entry table holds {ntype, beaconId, positionGeo {latititude, longitude}, name, channel, direction, position {x, y, z}, callsign, frequency}
local beacon_data = {}

local tcnchnidx = 0
local ndbchnidx = 0

local trad = 0
local nrad = 0
local found = 0
local inc_degree = 1.5 -- per 'update_time_step'
local dist100_0 = 0
local dist010_0 = 0
local dist001_0 = 0
local dist000_1 = 0

local rangelimit =  390 * 1.1508 -- nmile2mile

local mr = {}
local mridx = 2     -- 1 is home base ("0" in ME), 2 is first waypoint "1" in ME, etc.

dev:listen_command(Keys.NavReset)
--dev:listen_command(Keys.NavTCNNext)
--dev:listen_command(Keys.NavTCNPrev)
dev:listen_command(Keys.NavNDBNext)
dev:listen_command(Keys.NavNDBPrev)
dev:listen_command(Keys.PlaneChgTargetNext)
dev:listen_command(Keys.PlaneChgTargetPrev)
dev:listen_command(device_commands.doppler_select)
dev:listen_command(device_commands.doppler_memory_test)
dev:listen_command(device_commands.nav_select)
dev:listen_command(device_commands.ppos_lat)
dev:listen_command(device_commands.ppos_lon)
dev:listen_command(device_commands.dest_lat)
dev:listen_command(device_commands.dest_lon)
dev:listen_command(device_commands.bdhi_mode)
dev:listen_command(device_commands.asn41_windspeed)
dev:listen_command(device_commands.asn41_winddir)
dev:listen_command(device_commands.asn41_magvar)
dev:listen_command(device_commands.tacan_ch_major)
dev:listen_command(device_commands.tacan_ch_minor)
dev:listen_command(device_commands.tacan_volume)
dev:listen_command(device_commands.tacan_mode)


function get_true()
    -- getHeading() returns straight radians heading where positive is counter-clockwise from north = 0,
    -- thus we must subtract returned value from 360 to get a "compass" heading
    local trueheading = (360 - math.deg( sensor_data.getTrueHeading() ) ) % 360
    return trueheading
end

function get_magnetic()
    -- getMagneticHeading() returns heading where 0 is north, pi/2 = east, pi = south, etc.
    -- so we can straight convert to degrees
    local maghead = math.deg( sensor_data.getMagneticHeading() ) % 360
    return maghead
end

-- returns declination based on current plane position.  negative is easterly declination, subtract from TH to get MH
function get_declination()
    local mh = sensor_data.getMagneticHeading()
    local th = 2*math.pi - sensor_data.getHeading()
    local dec = math.deg(th-mh)
    if dec > 180 then
        dec = dec - 360
    end
    return dec
end

-- measures the deviation between grid north (delta x, fixed z) and "true" north in lat/long at that point
function get_true_deviation_from_grid(x,z)
    return true_bearing_viall_from_xz(x-1000, z, x+1000, z)
end


--[[
short mark, dot or "dit" (·) : "dot duration" is one time unit long
longer mark, dash or "dah" (–) : three time units long
inter-element gap between the dots and dashes within a character : one dot duration or one unit long
short gap (between letters) : three time units long
medium gap (between words) : seven time units long
--]]

local morse_alphabet={ a=".-~",b="-...~",c="-.-.~",d="-..~",e=".~",f="..-.~",g="--.~",h="....~",
i="..~",j=".---~",k="-.-~",l=".-..~",m="--~",n="-.~",o="---~",p=".--.~",q="--.-~",r=".-.~",
s="...~",t="-~",u="..-~",v="...-~",w=".--~",x="-..-~",y="-.--~",z="--..~",[" "]="|",
["0"]="-----~",["1"]=".----~",["2"]="..---~",["3"]="...--~",["4"]="....-~",["5"]=".....~",
["6"]="-....~",["7"]="--...~",["8"]="---..~",["9"]="----.~"}

function get_morse(str)
     local morse = string.gsub(string.lower(str), "%Z", morse_alphabet)
     local morse = string.gsub(morse, "~|", "      ") -- 6 units, 7th given by preceding dot or dash
     local morse = string.gsub(morse, "|", "       ")
     local morse = string.gsub(morse, "~", "  ") -- 2 units, 3rd given by preceding dot or dash
     return morse
end

local morse_unit_time = 0.1  -- MorzeDot.wav is 0.1s long, MorzeDash.wav is 0.3s
local time_to_next_morse = 0
local current_morse_string=""
local tacan_audio_active = false

function post_initialize()
    startup_print("nav: postinit")
    sndhost = create_sound_host("COCKPIT_TACAN","HEADPHONES",0,0,0)
    morse_dot_snd = sndhost:create_sound("Aircrafts/A-4E-C/MorzeDot") -- refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef
    morse_dash_snd = sndhost:create_sound("Aircrafts/A-4E-C/MorzeDash")

    local mhdg = get_magnetic()
  
    bdhi_hdg:set(mhdg)	
    
    bdhi_draw_needle2(0)
    bdhi_draw_needle1(0)
  
    bdhi_dme_flag:set(0)
    bdhi_dme_Xxx:set(0)
    bdhi_dme_xXx:set(0)
    bdhi_dme_xxX:set(0)
    --hsi_1000:set(0)
  
    -- nav data
    --local f1 = loadfile(LockOn_Options.script_path.."Nav/tcn_data.lua")
    --local f2 = loadfile(LockOn_Options.script_path.."Nav/vor_data.lua")
    --local f3 = loadfile(LockOn_Options.script_path.."Nav/ndb_data.lua")

    --tacan_data = f1()
    --vor_data = f2()
    --ndb_data = f3() -- test

    -- load Nav data
    local f4 = loadfile(LockOn_Options.script_path.."Nav/beacon_data.lua")
    beacon_data = f4()

    bdhi_mode = "TACAN"

    apn153_gs:set(0)
    apn153_drift:set(0)
    asn41_bearing:set(0)
    asn41_track:set(0)
    asn41_range:set(0)

    mr = get_mission_route()
    mr_index = 1

    if #mr >= 1 then
        set_d2_xy(mr[1].x, mr[1].y) -- set D2 to origin waypoint
        if #mr >= 2 then
            set_d1_xy(mr[2].x, mr[2].y) -- set D1 to first WP
        else
            set_d1_xy(mr[1].x, mr[1].y) -- set D1 to origin if no other WPs exist in mission
        end
    end

    dev:performClickableAction(device_commands.tacan_ch_major, 0.0, true)
    dev:performClickableAction(device_commands.tacan_ch_minor, 0.1, true)

    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        -- setup doppler
        apn153_state = "apn153-mem-stby"
        apn153_input = "STBY"
        apn153_tempcondition = 100
        apn153_warmup_timer = 0
        apn153_test_timer = 0
        dev:performClickableAction(device_commands.doppler_select, 0.1, true)   -- STBY by default for warm starts

        asn41_state = "asn41-off"
        asn41_input = "OFF"
        dev:performClickableAction(device_commands.nav_select, 0.1, true)  -- set switch to "off" initially

    elseif birth=="GROUND_COLD" then
        -- setup doppler
        apn153_state = "apn153-off"
        apn153_input = "OFF"
        apn153_tempcondition = 0
        apn153_warmup_timer = 99999
        apn153_test_timer = 99999
        dev:performClickableAction(device_commands.doppler_select, 0.0, true)   -- OFF by default for cold starts

        -- setup nav computer
        asn41_state = "asn41-off"
        asn41_input = "OFF"
        dev:performClickableAction(device_commands.nav_select, 0.1, true)  -- set switch to "off" initially

    end

	load_tempmission_file() 
	miz_carriers = decode_mission()
	tacan_channel_param:set(0)
	--print_message_to_user(#miz_carriers)
    startup_print("nav: postinit end")
end


function SetCommand(command,value)
    local sens = 0.05   -- lat long sensitivity

    ------------------------------------
    -- ASN-41 NAVIGATION COMPUTER SYSTEM
    -- APN-153(V) RADAR NAVIGATION SET
    ------------------------------------
    if command == device_commands.doppler_select then
        apn153_input = apn153_inputlist[ round((value*10)+1,0) ]
    elseif command == device_commands.doppler_memory_test then
        apn153_memorylight_test = value
        --print_message_to_user("value")
    elseif command == device_commands.nav_select then
        asn41_input = asn41_inputlist[ round((value*10)+1,0) ]
    elseif command == device_commands.bdhi_mode then
        bdhi_mode = bdhi_modelist[ value+2 ]   -- -1,0,1


    ----------------------------------
    -- NAV panel knob pushstates
    ----------------------------------
    elseif command == device_commands.ppos_lat_push then
        if value == 1 or value == 0 then
            ppos_lat_push_state = value
        end
    elseif command == device_commands.ppos_lon_push then
        if value == 1 or value == 0 then
            ppos_lon_push_state = value
        end
    elseif command == device_commands.dest_lat_push then
        if value == 1 or value == 0 then
            dest_lat_push_state = value
        end
    elseif command == device_commands.dest_lon_push then
        if value == 1 or value == 0 then
            dest_lon_push_state = value
        end
    elseif command == device_commands.asn41_magvar_push then
        if value == 1 or value == 0 then
            asn41_magvar_push_state = value
        end
    elseif command == device_commands.asn41_windspeed_push then
        if value == 1 or value == 0 then
            asn41_windspeed_push_state = value
        end
    elseif command == device_commands.asn41_winddir_push then
        if value == 1 or value == 0 then
            asn41_winddir_push_state = value
        end

    ----------------------------------
    -- NAV panel knobs
    ----------------------------------
    elseif command == device_commands.ppos_lat then
        if asn41_state ~= "asn41-test" and ppos_lat_push_state == 1 then
            -- gain 0.1 so 0.015 per "tick", we want increments of 0.01 or less
            -- divide by 15 = 0.001 per tick, then multiply by 10
            asn41_ppos_lat_offset = asn41_ppos_lat_offset + (value*10/15)
        end
    elseif command == device_commands.ppos_lon then
        if asn41_state ~= "asn41-test" and ppos_lon_push_state == 1 then
            asn41_ppos_lon_offset = asn41_ppos_lon_offset - (value*10/15) -- "positive" input = west which is negative lon
        end
    elseif command == device_commands.dest_lat then
        if dest_lat_push_state == 1 and asn41_state == "asn41-off" or asn41_state == "asn41-stby" or asn41_state == "asn41-d1" then
            asn41_d1_lat_offset = asn41_d1_lat_offset + (value*10/15)
        elseif asn41_state == "asn41-d2" and dest_lat_push_state == 1 then
            asn41_d2_lat_offset = asn41_d2_lat_offset + (value*10/15)
        end
    elseif command == device_commands.dest_lon then
        if dest_lon_push_state == 1 and asn41_state == "asn41-off" or asn41_state == "asn41-stby" or asn41_state == "asn41-d1" then
            asn41_d1_lon_offset = asn41_d1_lon_offset - (value*10/15) -- "positive" input = west which is negative lon
        elseif asn41_state == "asn41-d2" and dest_lon_push_state == 1 then
            asn41_d2_lon_offset = asn41_d2_lon_offset - (value*10/15) -- "positive" input = west which is negative lon
        end
    elseif command == device_commands.asn41_magvar then
        if asn41_state ~= "asn41-test" and asn41_magvar_push_state == 1 then
            asn41_magvar_offset = asn41_magvar_offset + (value*100/15) -- 0.015 per click * 100/15 = ~0.1
            asn41_magvar_offset = asn41_magvar_offset % 360
        end
    elseif command == device_commands.asn41_windspeed then
        if asn41_state ~= "asn41-test" and asn41_windspeed_push_state == 1 then
            asn41_windspeed_offset = asn41_windspeed_offset + (value*1000/15) -- 0.015 per click * 1000/15 = ~1
            if asn41_windspeed_offset < 0 then asn41_windspeed_offset = 0 end
            if asn41_windspeed_offset > 300 then asn41_windspeed_offset = 300 end
        end
    elseif command == device_commands.asn41_winddir then
        if asn41_state ~= "asn41-test" and asn41_winddir_push_state == 1 then
            asn41_winddir_offset = asn41_winddir_offset + (value*1000/15) -- 0.015 per click * 1000/15 = ~1
            asn41_winddir_offset = asn41_winddir_offset % 360
        end
    elseif command == Keys.PlaneChgTargetNext then
        mridx = mridx + 1
        if mridx > #mr then
            mridx = 1
        end
        set_d1_xy(mr[mridx].x, mr[mridx].y)
    elseif command == Keys.PlaneChgTargetPrev then
        mridx = mridx - 1
        if mridx < 1 then
            mridx = #mr
        end
        set_d1_xy(mr[mridx].x, mr[mridx].y)

    ---------------------------------------------
    -- ARN-52(V) TACAN BEARING-DISTANCE EQUIPMENT
    ---------------------------------------------
    elseif command == device_commands.tacan_mode then
        tacan_mode = tacan_modelist[ round((value*10)+1,0) ]
    elseif command == device_commands.tacan_ch_major then
        tacan_ch_major = value * 20     -- 0.05 per increment, 0 to 12
        tacan_channel = round(10*tacan_ch_major + tacan_ch_minor)
        atcn = find_matched_tacan(tacan_channel)
    elseif command == device_commands.tacan_ch_minor then
        tacan_ch_minor = value * 10     -- 0.10 per digit, 0 to 9
        tacan_channel = round(10*tacan_ch_major + tacan_ch_minor)
        atcn = find_matched_tacan(tacan_channel)
    elseif command == device_commands.tacan_volume then
        tacan_volume = value
        if tacan_volume < -0.5 then
            dev:performClickableAction(device_commands.tacan_volume, 1, false)  -- bound check to fix wrap
        elseif tacan_volume < 0 and tacan_volume > -0.5 then
            dev:performClickableAction(device_commands.tacan_volume, 0, false)  -- bounds check to fix wrap
        else
            morse_dot_snd:update(nil,tacan_volume,nil)
            morse_dash_snd:update(nil,tacan_volume,nil)
        end
    end
end


local function evalSrc(data_src, data_idx, navchnidx, tgt_brn, cur_hdg)
  
  if #data_src > 0 and navchnidx > 0 and data_idx > 0 then
    local st = data_src[navchnidx]
    
    -- local tcn10 = get_cockpit_draw_argument_value(621)
    if st.position.x ~= nil and st.position.z ~= nil then
      
      local tx = -6709
      local tz = 294539
      
      tx = st.position.x
      tz = st.position.z
      
      -- print_message_to_user("ndb ".. st.name .." ".. st.frequency .." ".. tx .. " " .. tz)
      
      local lx, ly, lz = sensor_data.getSelfCoordinates()
      -- point to self, so need add 180 degree later
      local dx = lx - tx -- vertical
      local dz = lz - tz -- horizontal
      --local trad = 0

      local dist = math.sqrt(dx*dx + dz*dz)
      
      if data_idx == 1 and tcn_block:get() == 0 then
        bdhi_dme_flag:set(1)
        
        local distmile = dist*meter2mile
        
        if distmile > rangelimit then
          distmile = rangelimit
        end
        
        dist100_0 = distmile/1000
        dist010_0 = (distmile%100)/100
        dist001_0 = (distmile%10)/10
        dist000_1 = (distmile/10)

        --print_message_to_user("pos: "..st.position.x.." "..st.position.z.." ("..distmile..")")
      
      end
      
      -- Krymsk
      if dx >= 0 then
        tgt_brn = ((360 + 90 - degrees_per_radian * math.acos(dz/dist)) + 180)%360
      else
        tgt_brn = ((90 + degrees_per_radian * math.acos(dz/dist)) + 180)%360
      end
      
      tgt_brn = (360 + tgt_brn - cur_hdg)%360
      found = 1
    else
      found = 0
    end
  else
    found = 0
  end
  
  if (found == 0 or tcn_block:get() == 1) and data_idx == 1 then
    tgt_brn = 45
  end
  if (found == 0 or ndb_block:get() == 1) and data_idx == 2 then
    tgt_brn = 45
  end
  
  if (found == 0 or tcn_block:get() == 1) and data_idx == 1 then
    dist100_0 = 0
    dist010_0 = 0
    dist001_0 = 0
    dist000_1 = 0
    bdhi_dme_flag:set(0)
  end
  
  local ct = 0
  if data_idx == 1 then
    ct = needle2_value:get_target_val() -- bdhi_needle2:get() --(360 + hsi_bear:get() - hdg)%360
  elseif data_idx == 2 then
    ct = needle1_value:get_target_val() --bdhi_needle1:get() --(360 + hsi_bear:get() - hdg)%360
  end
  
  if math.abs(tgt_brn - ct) <= inc_degree then
    ct = tgt_brn%360
  elseif (tgt_brn - ct)%360 > 180 then
    ct = (ct - inc_degree)%360
  elseif (tgt_brn - ct)%360 <= 180 then
    ct = (ct + inc_degree)%360
  end

  
  return ct, tgt_brn
end

-- utility function to update nav display
function draw_speed(x)
    apn153_speed_Xnn:set( jumpwheel(x,3) )
    apn153_speed_nXn:set( jumpwheel(x,2) )
    apn153_speed_nnX:set( jumpwheel(x,1) )
end

function asn41_draw_windspeed(x)
    asn41_windspeed_Xxx:set( jumpwheel(x,3) )
    asn41_windspeed_xXx:set( jumpwheel(x,2) )
    asn41_windspeed_xxX:set( jumpwheel(x,1) )
end

function asn41_draw_winddir(x)
    asn41_winddir_Xxx:set( jumpwheel(x,3) )
    asn41_winddir_xXx:set( jumpwheel(x,2) )
    asn41_winddir_xxX:set( jumpwheel(x,1) )
end

function asn41_draw_magvar(x)
    -- first, normalize magvar from 0-360 to west vs east
    local magvar = 0
    if x <= 180 then
        -- east
        magvar = x
        asn41_magvar_xxxxX:set( 1 )
    else
        -- west
        magvar = 360 - x
        asn41_magvar_xxxxX:set( 0 )
    end

    local y = magvar*10 -- we're going to draw 1 decimal place, so left shift by 10 for drawing only
    asn41_magvar_Xxxxx:set( jumpwheel(y,4) )
    asn41_magvar_xXxxx:set( jumpwheel(y,3) )
    asn41_magvar_xxXxx:set( jumpwheel(y,2) )
    asn41_magvar_xxxXx:set( jumpwheel(y,1) )
end

function draw_ppos(la, lo)
    local lat = get_digits_LL122(la)
    local lon = get_digits_LL123(lo)

    local N_S = not lat[1] and 0.5 or 0.0   -- set to 0.0 for "positive" latitude (North)
    local E_W = lon[1] and 0.5 or 0.0   -- set to 0.5 for "positive" longitude (East)

    nav_curpos_lat_Xnnnn:set( lat[5]/10 )   -- tens digit
    nav_curpos_lat_nXnnn:set( lat[4]/10 )   -- ones digit
    nav_curpos_lat_nnXnn:set( lat[3]/10 )   -- tenths
    nav_curpos_lat_nnnXn:set( lat[2]/10 )   -- hundredths
    nav_curpos_lat_nnnnX:set( N_S )

    nav_curpos_lon_Xnnnnn:set( lon[6]/10 )  -- hundreds digit
    nav_curpos_lon_nXnnnn:set( lon[5]/10 )  -- tens digit
    nav_curpos_lon_nnXnnn:set( lon[4]/10 )  -- ones digit
    nav_curpos_lon_nnnXnn:set( lon[3]/10 )  -- tenths
    nav_curpos_lon_nnnnXn:set( lon[2]/10 )  -- hundredths
    nav_curpos_lon_nnnnnX:set( E_W )
end

-- utility function to update nav display
function draw_dest(la, lo)

    local lat = get_digits_LL122(la)
    local lon = get_digits_LL123(lo)

    local N_S = not lat[1] and 0.5 or 0.0   -- set to 0.0 for "positive" latitude (North)
    local E_W = lon[1] and 0.5 or 0.0   -- set to 0.5 for "positive" longitude (East)

    nav_dest_lat_Xnnnn:set( lat[5]/10 )   -- tens digit
    nav_dest_lat_nXnnn:set( lat[4]/10 )   -- ones digit
    nav_dest_lat_nnXnn:set( lat[3]/10 )   -- tenths
    nav_dest_lat_nnnXn:set( lat[2]/10 )   -- hundredths
    nav_dest_lat_nnnnX:set( N_S )

    nav_dest_lon_Xnnnnn:set( lon[6]/10 )  -- hundreds digit
    nav_dest_lon_nXnnnn:set( lon[5]/10 )  -- tens digit
    nav_dest_lon_nnXnnn:set( lon[4]/10 )  -- ones digit
    nav_dest_lon_nnnXnn:set( lon[3]/10 )  -- tenths
    nav_dest_lon_nnnnXn:set( lon[2]/10 )  -- hundredths
    nav_dest_lon_nnnnnX:set( E_W )
end


function update_and_draw_ppos(asn41_ppos_lat_offset, asn41_ppos_lon_offset)
    local lx, ly, lz = sensor_data.getSelfCoordinates()
    local geopos = lo_to_geo_coords(lx, lz)

    asn41_ppos_lat = geopos.lat
    asn41_ppos_lon = geopos.lon
    draw_ppos(geopos.lat+asn41_ppos_lat_offset, geopos.lon+asn41_ppos_lon_offset)
end

function set_d1_xy(x, y)
    local geopos = lo_to_geo_coords(x, y)
    asn41_d1_lat_offset = 0
    asn41_d1_lon_offset = 0
    asn41_d1_lat = geopos.lat
    asn41_d1_lon = geopos.lon
end

function set_d2_xy(x, y)
    local geopos = lo_to_geo_coords(x, y)
    asn41_d2_lat_offset = 0
    asn41_d2_lon_offset = 0
    asn41_d2_lat = geopos.lat
    asn41_d2_lon = geopos.lon
end

--[[
AN/ASN-41 Navigational Computer Design

Supplies position, windspeed and direction, distance to destination, bearing and ground
track relative to true heading.

Provides great circle solutions for distances greater than 200 miles.
Provides planar solutions for distances less than 200 miles.

Outputs magnetic heading ground track bearing to the target and distance to go on the BDHI.

Three modes of operation:  DOPPLER, MEMORY, AIR MASS

DOPPLER MODE: continuous data fed by AN/APN-153 used to calculate position information

MEMORY MODE: if signal is lost by the AN/APN-153, automatically retains the most-recently
    captured wind memory vector and combines that with current airspeed to calculate ground
    speed.

AIR MASS MODE: *either* leave AN/APN-153 in STBY mode and set the drift/speed vectors manually,
    or disable the AN/APN-153 and enter the wind settings into the AN/ASN-41 navigation computer.



states:
    asn41-off:
        output: valid = 0, distance=0, bearing=0, track=0

        draw: initial ppos, initial d1

        adjustable: ppos, d1

    asn41-stby:
        "power is applied to the computer, D1 is displayed on the destination and stored in memory,
         push-to-set or slew knobs can be used to change D1 in the standby position"
        output: valid = 0, distance = 0, bearing = 0, track = 0
        draw: initial ppos, initial d1, wind speed, wind direction, mag variation
        adjustable: ppos, d1

    asn41-d1:
        "course and distance information for D1 is output to BDHI, D1 slew can be altered via slew knobs"
        output: valid = 1, distance/bearing/track based on ppos->D1 solution
        draw: ppos, d1, wind speed, wind direction, mag variation
        adjustable: ppos, d1

    asn41-d2:
        "course and distance information for D2 is output to BDHI, D2 slew can be altered via slew knobs"
        output: valid = 1, distance/bearing/track based on ppos->D2 solution
        draw: ppos, d2, wind speed, wind direction, mag variation
        adjustable: ppos, d2

    asn41-test:
        "inputs a pre-determined navigation problem into the computer, solved output is sent to BDHI"

        output: valid = 1, distance = 987, bearing = 45, track = 30

        draw: wind speed = 223.6 +- 2.5 knots, wind direction = 091+/- 1.5 degrees
        draw: ppos shows "south" + "east"
        draw: dest shows "north" + "west"

        inputs have no effect


--]]


-- calculates the haversine formula distance (m) between latitude,longitude pairs x1,y1 and x2,y2
local function haversine(x1, y1, x2, y2)
    local r=0.017453292519943295769236907684886127;
    local x1= x1*r; local x2= x2*r; local y1= y1*r; local y2= y2*r; local dy = y2-y1; local dx = x2-x1;
    local a = math.pow(math.sin(dx/2),2) + math.cos(x1) * math.cos(x2) * math.pow(math.sin(dy/2),2);
    local c = 2 * math.asin(math.sqrt(a));
    local d = 6372800 * c;
    return d;
end

-- calculates the "forward azimuth" bearing of a great circle route from x1,y1 to x2,y2 in true heading degrees
local function forward_azimuth_bearing(x1,y1,x2,y2)
    local lat1r = math.rad(x1)
    local lon1r = math.rad(y1)
    local lat2r = math.rad(x2)
    local lon2r = math.rad(y2)

    local y = math.sin(lon2r-lon1r) * math.cos(lat2r)
    local x = math.cos(lat1r)*math.sin(lat2r) - math.sin(lat1r)*math.cos(lat2r)*math.cos(lon2r-lon1r)
    local brng = math.deg(math.atan2(y, x))

    return brng
end

--
-- calculates range and bearing to destination waypoint provided in 'dest' (either d1 or d2)
-- sets magnetic track, magnetic bearing, and distance in nautical miles
function asn41_update_range_and_bearing(dest)
    local distance = 0
    local bearing = 0
    local track = 0

    --------------------------------------------------------
    -- first, calculate range


    local lat1 = asn41_ppos_lat+asn41_ppos_lat_offset
    local lon1 = asn41_ppos_lon+asn41_ppos_lon_offset
    local lat2,lon2

    if dest == 1 then
        lat2 = asn41_d1_lat+asn41_d1_lat_offset
        lon2 = asn41_d1_lon+asn41_d1_lon_offset
    elseif dest == 2 then
        lat2 = asn41_d2_lat+asn41_d2_lat_offset
        lon2 = asn41_d2_lon+asn41_d2_lon_offset
    else
        lat2 = 0
        lon2 = 0
    end
            
    local point1 = geo_to_lo_coords(lat1,lon1)
    local point2 = geo_to_lo_coords(lat2,lon2)

    local distance = math.sqrt( (point2.x-point1.x)^2 + (point2.z-point1.z)^2 ) * knot2meter

    if distance > 200 then
        distance = haversine(lat1,lon1,lat2,lon2) / knot2meter
    end

    if distance < 999 then
        asn41_range:set(distance)
        asn41_valid:set(1)
    else
        asn41_range:set(0)
        asn41_valid:set(0)
    end


    local declination = get_declination()

    --------------------------------------------------------
    -- second, calculate bearing
    bearing = forward_azimuth_bearing(lat1,lon1,lat2,lon2)
    asn41_bearing:set( bearing - declination )

    --------------------------------------------------------
    -- third, calculate track based on wind influence
    track = (asn41_bearing:get() + apn153_drift:get()) % 360
    asn41_track:set( track )

    --print_message_to_user( haversine(36.12, -86.67, 33.94, -118.4) )
end

function update_asn41()
    if asn41_state == "asn41-test" then
        if asn41_input ~= "TEST" then
            if asn41_input == "OFF" then asn41_state = "asn41-off"
            elseif asn41_input == "STBY" then asn41_state = "asn41-stby"
            elseif asn41_input == "D1" then asn41_state = "asn41-d1"
            elseif asn41_input == "D2" then asn41_state = "asn41-d2"
            end
        else
            draw_ppos(-1, 1)
            draw_dest(0,0)
            asn41_draw_windspeed(223.6)
            asn41_draw_winddir(091)
            asn41_valid:set(1)
            asn41_range:set(0)
            asn41_bearing:set( 120 )
            asn41_track:set( 30 )
        end
    elseif asn41_state == "asn41-off" then
        if asn41_input ~= "OFF" then
            if asn41_input == "TEST" then asn41_state = "asn41-test"
            elseif asn41_input == "STBY" then asn41_state = "asn41-stby"
            elseif asn41_input == "D1" then asn41_state = "asn41-d1"
            elseif asn41_input == "D2" then asn41_state = "asn41-d2"
            end
        else
            -- asn41-off output
            asn41_valid:set(0)
            asn41_range:set(0)
            asn41_bearing:set(0)
            asn41_track:set(0)
            -- asn41-off draw
            asn41_draw_windspeed( asn41_windspeed_offset )
            asn41_draw_winddir( asn41_winddir_offset )
            asn41_draw_magvar( asn41_magvar_offset )
            draw_ppos(asn41_ppos_lat+asn41_ppos_lat_offset, asn41_ppos_lon+asn41_ppos_lon_offset)
            draw_dest(asn41_d1_lat+asn41_d1_lat_offset, asn41_d1_lon+asn41_d1_lon_offset)
        end
    elseif asn41_state == "asn41-stby" then
        if asn41_input ~= "STBY" then
            if asn41_input == "TEST" then asn41_state = "asn41-test"
            elseif asn41_input == "OFF" then
                asn41_state = "asn41-off"
                --for debug, zero the ppos offsets when we transition from stby to off
                asn41_ppos_lat_offset = 0
                asn41_ppos_lon_offset = 0
            elseif asn41_input == "D1" then asn41_state = "asn41-d1"
            elseif asn41_input == "D2" then asn41_state = "asn41-d2"
            end
        else
            -- asn41-stby output
            asn41_valid:set(0)
            asn41_range:set(0)
            asn41_bearing:set(0)
            asn41_track:set(0)
            -- asn41-stby draw
            asn41_draw_windspeed( asn41_windspeed_offset )
            asn41_draw_winddir( asn41_winddir_offset )
            asn41_draw_magvar( asn41_magvar_offset )
            update_and_draw_ppos(asn41_ppos_lat_offset, asn41_ppos_lon_offset)  -- fully tracks present position
            draw_dest(asn41_d1_lat+asn41_d1_lat_offset, asn41_d1_lon+asn41_d1_lon_offset)
        end
    elseif asn41_state == "asn41-d1" then
        if asn41_input ~= "D1" then
            if asn41_input == "TEST" then asn41_state = "asn41-test"
            elseif asn41_input == "OFF" then asn41_state = "asn41-off"
            elseif asn41_input == "STBY" then asn41_state = "asn41-stby"
            elseif asn41_input == "D2" then asn41_state = "asn41-d2"
            end
        else
            -- asn41-d1 output
            asn41_update_range_and_bearing(1)
            -- asn41-d1 draw
            -- asn41_draw_windspeed( asn41_windspeed_offset )
            -- asn41_draw_winddir( asn41_winddir_offset )
            asn41_draw_windspeed(apn153_wind_speed:get())
            asn41_draw_winddir(apn153_wind_dir:get())
            asn41_draw_magvar( asn41_magvar_offset )
            update_and_draw_ppos(asn41_ppos_lat_offset, asn41_ppos_lon_offset)  -- fully tracks present position
            draw_dest(asn41_d1_lat+asn41_d1_lat_offset, asn41_d1_lon+asn41_d1_lon_offset)
        end
    elseif asn41_state == "asn41-d2" then
        if asn41_input ~= "D2" then
            if asn41_input == "TEST" then asn41_state = "asn41-test"
            elseif asn41_input == "OFF" then asn41_state = "asn41-off"
            elseif asn41_input == "STBY" then asn41_state = "asn41-stby"
            elseif asn41_input == "D1" then asn41_state = "asn41-d1"
            end
        else
            -- asn41-d2 output
            asn41_update_range_and_bearing(2)
            -- asn41-d2 draw
            -- asn41_draw_windspeed( asn41_windspeed_offset )
            -- asn41_draw_winddir( asn41_winddir_offset )
            asn41_draw_windspeed(apn153_wind_speed:get())
            asn41_draw_winddir(apn153_wind_dir:get())
            asn41_draw_magvar( asn41_magvar_offset )
            update_and_draw_ppos(asn41_ppos_lat_offset, asn41_ppos_lon_offset)
            draw_dest(asn41_d2_lat+asn41_d2_lat_offset, asn41_d2_lon+asn41_d2_lon_offset)
        end
    else
        print_message_to_user("AN/ASN-41 state machine error")
    end
end


--[[
AN/APN-153(V) Radar Navigation Set (Doppler) Design
performance:
    (data from http://navyaviation.tpub.com/14030/css/Doppler-54.htm)
    accurate from 40' to 50,000' AGL
    accurate from 80 to 800 knots of ground speed over land and water
    accurate from -40 to +40 degrees of drift
    uses variable-PRF narrow-beam microwave pulses

    1 minutes to execute test mode
    5 minute warmup
    first signal acquision "within 30 seconds of reaching 150 knots of ground speed and greater than 40 feet of altitude"
    bank limited to 30 degrees relative to terrain below, or else memory mode "may" trigger

input information:
    whether conditions are valid (bank angle, etc.)
    switch position

state information needed:
    current state
    "warm" (boolean)
    "test" timer
    "warmup" timer
    ground speed output (80 to 800 knots per http://navyaviation.tpub.com/14030/css/Doppler-54.htm)
    drift output (-40 to +40 degrees)

states:
    apn153-off [0]:
        output: GS=0, drift=0
        set: "warm" = false
        set: "warmup" timer = 5 minute in the future
        set: "test" timer = 1 minutes in the future
        
        transition: if switch == off, stay here
        transition: if switch == stby goto apn153-mem-stby
        transition: if switch == land goto apn153-mem-land
        transition: if switch == sea goto apn153-mem-sea
        transition: if switch == test goto apn153-testrun

    apn153-testrun [1]:
        upon entry, begin 1 minute "test" timer
        if "warmup" timer < now(), set "warm" = true
        output: GS=0, drift=0

        transition: if switch == off goto apn153-off
        transition: if switch == stby goto apn153-mem-stby
        transition: if switch == land goto apn153-mem-land
        transition: if switch == sea goto apn153-mem-sea
        transition: if switch == test, stay here
        transition: if "test" timer == 0, goto apn153-testok

    apn153-testok [2]:
        output: GS=121 +/- 5 knots
        output: drift = 0 +/- 2 degrees
        if "warmup" timer < now(), set "warm" = true

        transition: if switch == off goto apn153-off
        transition: if switch == stby goto apn153-mem-stby
        transition: if switch == land goto apn153-mem-land
        transition: if switch == sea goto apn153-mem-sea
        transition: if switch == test, stay here
    
    apn153-mem-stby [3]:
        set: "test" timer = 1 minutes in the future
        if "warmup" timer < now(), set "warm" = true

        output: memory light = on
        output: last GS
        output: last drift

        transition: if switch == off goto apn153-off
        transition: if switch == stby, stay here
        transition: if switch == land goto apn153-mem-land
        transition: if switch == sea goto apn153-mem-sea
        transition: if switch == test goto apn153-testrun

    apn153-mem-land [4]:
        if "warmup" timer < now(), set "warm" = true

        output: memory light = on
        output: last GS
        output: last drift
                
        transition: if signal is acquired and "warm"==true, goto apn153-land

        transition: if switch == off goto apn153-off
        transition: if switch == stby goto apn153-mem-stby
        transition: if switch == land, stay here
        transition: if switch == sea goto apn153-mem-sea
        transition: if switch == test goto apn153-testrun
        
    apn153-mem-sea [5]:
        if "warmup" timer < now(), set "warm" = true
                       
        output: memory light = on
        output: last GS
        output: last drift
                       
        transition: if signal is acquired and "warm"==true, goto apn153-sea

        transition: if switch == off goto apn153-off
        transition: if switch == stby goto apn153-mem-stby
        transition: if switch == land, stay here
        transition: if switch == sea goto apn153-mem-sea
        transition: if switch == test goto apn153-testrun

    apn153-land [6]:
        output: memory light = off
        output: current ground speed in knots
        output: current drift in degrees (need to calculate angle difference between heading and position delta)

        store: current GS as "last GS" and current drift as "last GS"

        transition: if signal is lost, goto apn153-mem-land
        transition: if switch == off goto apn153-off
        transition: if switch == stby goto apn153-mem-stby
        transition: if switch == land, stay here
        transition: if switch == sea goto apn153-sea
        transition: if switch == test goto apn153-testrun

    apn153-sea [7]:
        output: memory light = off
        output: current ground speed in knots
        output: current drift in degrees (need to calculate angle difference between heading and position delta)

        store: current GS as "last GS" and current drift as "last GS"

        transition: if signal is lost, goto apn153-mem-sea

        transition: if switch == off, goto apn153-off
        transition: if switch == stby, goto apn153-mem-stby
        transition: if switch == land, stay goto apn153-land
        transition: if switch == sea, stay here
        transition: if switch == test, goto apn153-testrun
--]]

local lastx = 0
local lasty = 0
local lastz = 0

-- returns true if the apn153 would return valid sensor information
function apn153_get_signal_ok()
    local roll = math.abs(sensor_data.getRoll())
    local pitch = math.abs(sensor_data.getPitch())
    local alt = math.abs(sensor_data.getRadarAltitude())

    if math.deg(roll) > 30 or math.deg(pitch) > 30 then
        return false
    end

    if alt*meter2feet < 40 or alt*meter2feet > 50000 then
        return false
    end

    return true
end

-- Used to calculate the wind vector from the data provided by the AN/APN-153
-- @return wind direction and wind speed
function apn153_calculate_wind_vector(true_heading, true_airspeed, ground_track, ground_speed)
    -- print_message_to_user("true heading: "..true_heading.." true airspeed: "..true_airspeed.." ground track: "..ground_track.." ground speed: "..ground_speed)

    -- this function uses the air vector as the beginning of the vector path
    -- flip the air vector in preparation for vector addition
    local air_vector_heading_rad = math.rad((true_heading + 180) % 360)
    -- convert to radians
    local ground_track_rad = math.rad(ground_track)

    -- calculate the wind vector
    local air_vector = {
        x = true_airspeed * math.cos(air_vector_heading_rad),
        y = true_airspeed * math.sin(air_vector_heading_rad)
    }
    local ground_vector = {
        x = ground_speed * math.cos(ground_track_rad),
        y = ground_speed * math.sin(ground_track_rad)
    }
    local wind_vector = {
        x = air_vector.x + ground_vector.x,
        y = air_vector.y + ground_vector.y
    }
    wind_vector.magnitude = math.sqrt((wind_vector.x * wind_vector.x) + (wind_vector.y * wind_vector.y))

    -- check which quadrant is the wind vector in and adjust the direction
    -- this wind direction indicates the direction the wind is blowing towards
    if wind_vector.x >= 0 and wind_vector.y >= 0 then -- quadrant 1
        wind_vector.direction = math.deg(math.atan(wind_vector.y, wind_vector.x))
    elseif wind_vector.x < 0 and wind_vector.y >= 0 then -- quadrant 2
        wind_vector.direction = math.rad(math.atan(wind_vector.y, wind_vector.x)) + 180
    elseif wind_vector.x < 0 and wind_vector.y < 0 then -- quadrant 3
        wind_vector.direction = math.rad(math.atan(wind_vector.y, wind_vector.x)) + 180
    elseif wind_vector.x >= 0 and wind_vector.y < 0 then -- quadrant 4
        wind_vector.direction = math.rad(math.atan(wind_vector.y, wind_vector.x)) + 360
    end

    -- invert the wind direction to remain consistent with ATIS wind reporting
    -- wind direction will indicate the direction the wind is coming FROM
    wind_vector.direction = (wind_vector.direction + 180) % 360

    return wind_vector.magnitude, wind_vector.direction
end

-- This function is executed by the AN/APN-153 for purposes of preventing large impluses in
-- speed when the sensor transitions from inactive to active.  We run it on every pass through
-- the update_apn153() function where apn153_speed_and_drift() does not execute.
function apn153_speed_and_drift_dummy()
    local curx,cury,curz = sensor_data.getSelfCoordinates()
    lastx = curx
    lasty = cury
    lastz = curz
end


local apn153_mode_error = 0
local apn153_mode_error_change = 0

-- execute the AN/APN-153 speed & drift calculation from last position
-- speed is the hypotenus distance per unit time between old and new coordinates
-- drift is calculated as the arctangent of dx (northing) / dz (easting) adjusted based on the compass
function apn153_speed_and_drift(land)
    local curx,cury,curz = sensor_data.getSelfCoordinates()
    local heading = (360 - math.deg( sensor_data.getHeading() )) % 360
    local landtype = Terrain.GetSurfaceType(curx, curz) -- 'land', 'sea', 'river', 'lake'

    -- calculate current speed (in knots) based on position difference
    local speed = math.sqrt( (curx-lastx)^2 + (curz-lastz)^2 )  -- position difference in meters
    speed = speed * 72000 / knot2meter                          -- speed in knots = delta meters * (3600/update_time_step) * (1 / knot2meter)

    local angle = math.deg( math.atan2(curz-lastz, curx-lastx) ) % 360

    -- calculate wind data and share
    local wind_speed, wind_direction = apn153_calculate_wind_vector(heading, sensor_data.getTrueAirSpeed() * 1.94384, angle, speed)
    apn153_wind_speed:set(wind_speed)
    apn153_wind_dir:set(wind_direction)

    drift = (angle-heading)
    
    if drift < -180 then
        drift = drift + 360 -- handle case where angle = ~5 and heading is ~355 (flying north, strong westerly wind)
    elseif drift > 180 then
        drift = drift - 360 -- handle the opposite (flying north, strong easterly wind)
    end

    -- add a random 3-5% error to both speed and drift if your land/sea mode is configured improperly.
    -- 'land' mode over sea will return 3-5% slower
    -- 'sea' mode over land will return 3-5% faster
    -- these values are made up

    if apn153_mode_error_change == 0 or apn153_mode_error == 0 then
        apn153_mode_error = math.random(3,6)
        apn153_mode_error_change = math.random(100,200) -- error swings every 5-10 seconds assuming update_time_step = 0.05
    end
    
    if not land then
        -- sea mode
        if landtype == "land" or landtype == "river" then
            drift = drift * (1 + apn153_mode_error/100)
            speed = speed * (1 + apn153_mode_error/100)
            apn153_mode_error_change = apn153_mode_error_change - 1
        end
    else
        if landtype == "sea" or landtype == "lake" then
            drift = drift * (1 - apn153_mode_error/100)
            speed = speed * (1 - apn153_mode_error/100)
            apn153_mode_error_change = apn153_mode_error_change - 1
        end
    end

    lastx = curx
    lasty = cury
    lastz = curz

    return speed,drift
end

local function apn153_update_tempcondition()
    -- warm up unit if power if applied but apply cooldown function if power is removed.
    if apn153_state ~= "apn153-off" and apn153_tempcondition < 100 then
        -- warmup unit
        apn153_tempcondition = apn153_tempcondition + APN153_WARMUP_DELTA
        if apn153_tempcondition > 100 then
            apn153_tempcondition = 100
        end
    elseif apn153_state == "apn153-off" and apn153_tempcondition > 0 then
        -- apply cooldown
        apn153_tempcondition = apn153_tempcondition - APN153_COOLDOWN_DELTA
        if apn153_tempcondition < 0 then
            apn153_tempcondition = 0
        end
    end

    -- print_message_to_user("APN-153 Temp Condition: "..apn153_tempcondition)
end

local function update_apn153()
    local timenow = get_model_time() -- time since spawn in seconds
    local signalok = apn153_get_signal_ok()
    local updated = false

    if apn153_state == "apn153-off" then
        apn153_gs:set(0)
        apn153_drift:set(0)
        set_apn153_memorylight( apn153_memorylight_test==1 and 1 or 0 )

        if apn153_input ~= "OFF" then
            if apn153_input == "STBY" then apn153_state = "apn153-mem-stby"
            elseif apn153_input == "LAND" then apn153_state = "apn153-mem-land"
            elseif apn153_input == "SEA" then apn153_state = "apn153-mem-sea"
            elseif apn153_input == "TEST" then apn153_state = "apn153-test"
            end
        end

    elseif apn153_state == "apn153-mem-stby" then
        -- speed and drift do not update in standby modes
        set_apn153_memorylight(1)

        if apn153_input ~= "STBY" then
            if apn153_input == "OFF" then apn153_state = "apn153-off"
            elseif apn153_input == "LAND" then apn153_state = "apn153-mem-land"
            elseif apn153_input == "SEA" then apn153_state = "apn153-mem-sea"
            elseif apn153_input == "TEST" then apn153_state = "apn153-test"
            end
        end

    elseif apn153_state == "apn153-mem-land" then
        -- speed and drift do not update in standby modes
        set_apn153_memorylight(1)

        if apn153_input ~= "LAND" then
            if apn153_input == "OFF" then apn153_state = "apn153-off"
            elseif apn153_input == "STBY" then apn153_state = "apn153-mem-stby"
            elseif apn153_input == "SEA" then apn153_state = "apn153-mem-sea"
            elseif apn153_input == "TEST" then apn153_state = "apn153-test"
            end
        else
            if apn153_tempcondition == 100 and signalok then
                apn153_state = "apn153-land"
            end
        end

    elseif apn153_state == "apn153-mem-sea" then
        -- speed and drift do not update in standby modes
        set_apn153_memorylight(1)

        if apn153_input ~= "SEA" then
            if apn153_input == "OFF" then apn153_state = "apn153-off"
            elseif apn153_input == "STBY" then apn153_state = "apn153-mem-stby"
            elseif apn153_input == "LAND" then apn153_state = "apn153-mem-land"
            elseif apn153_input == "TEST" then apn153_state = "apn153-test"
            end
        else
            if apn153_tempcondition == 100 and signalok then
                apn153_state = "apn153-sea"
            end
        end

    elseif apn153_state == "apn153-land" then
        set_apn153_memorylight( apn153_memorylight_test==1 and 1 or 0 )

        if apn153_input ~= "LAND" then
            if apn153_input == "OFF" then apn153_state = "apn153-off"
            elseif apn153_input == "STBY" then apn153_state = "apn153-mem-stby"
            elseif apn153_input == "SEA" then apn153_state = "apn153-sea"
            elseif apn153_input == "TEST" then apn153_state = "apn153-test"
            end
        else
            if signalok then
                speed,drift = apn153_speed_and_drift(true)
                updated = true
                --print_message_to_user("speed: "..speed..",  drift: "..drift)
                apn153_gs:set(speed)
                apn153_drift:set(drift)
            else
                -- lost signal, revert to memory mode
                apn153_state = "apn153-mem-land"
            end
        end


    elseif apn153_state == "apn153-sea" then
        set_apn153_memorylight( apn153_memorylight_test==1 and 1 or 0 )

        if apn153_input ~= "SEA" then
            if apn153_input == "OFF" then apn153_state = "apn153-off"
            elseif apn153_input == "STBY" then apn153_state = "apn153-mem-stby"
            elseif apn153_input == "LAND" then apn153_state = "apn153-land"
            elseif apn153_input == "TEST" then apn153_state = "apn153-test"
            end
        else
            if signalok then
                speed,drift = apn153_speed_and_drift(false)
                updated = true
                --print_message_to_user("speed: "..speed..",  drift: "..drift)
                apn153_gs:set(speed)
                apn153_drift:set(drift)
            else
                -- lost signal, revert to memory mode
                apn153_state = "apn153-mem-land"
            end
        end

    elseif apn153_state == "apn153-test" then

        if apn153_input ~= "TEST" then
            if apn153_input == "OFF" then 
                apn153_test_running = false
                apn153_state = "apn153-off"
            elseif apn153_input == "STBY" then
                apn153_test_running = false
                apn153_state = "apn153-mem-stby"
            elseif apn153_input == "LAND" then
                apn153_test_running = false
                apn153_state = "apn153-mem-land"
            elseif apn153_input == "SEA" then
                apn153_test_running = false
                apn153_state = "apn153-mem-sea"
            end
        else
            if apn153_tempcondition == 100 then
                set_apn153_memorylight( apn153_memorylight_test==1 and 1 or 0 )
                -- set the "test OK" values once upon entry
                apn153_gs:set(121)
                apn153_drift:set(0)
            else
                set_apn153_memorylight(1)
            end
        end

    else
        print_message_to_user("AN/APN-153 state machine error")
    end

    -- now update gauges/indicators based on provided information
    draw_speed( apn153_gs:get() )
    apn153_drift_gauge:set( apn153_drift:get() )

    if not updated then
        apn153_speed_and_drift_dummy()  -- don't let lastx/lastz get far away, to prevent impulses in speed
    end

    apn153_update_tempcondition()
end

-- setter function for apn153 memory light
-- do not set param directly to allow for electrical supply checks
function set_apn153_memorylight(state)
    if state ~= 0 and state ~= 1 then
        return false
    end

    if get_elec_fwd_mon_ac_ok() and state == 1 then
        apn153_memorylight:set(1)
    else
        apn153_memorylight:set(0)
    end
end


function true_bearing_deg_from_xz(x1,z1,x2,z2)
    return ( math.deg(math.atan2(z2-z1,x2-x1)) %360 )  -- true bearing in degrees
end

function true_bearing_viall_from_xz(x1,z1,x2,z2)
    local geopos1 = lo_to_geo_coords(x1,z1)
    local geopos2 = lo_to_geo_coords(x2,z2)
    
    return forward_azimuth_bearing(geopos1.lat, geopos1.lon, geopos2.lat, geopos2.lon)
end


-- find_active_tacan()
--
-- takes channel 'chan' as an argument, searches the beacon database, and returns
-- key parameters about the matching beacon, or 'nil' if there's no tacan on the
-- appropriate frequency
function find_matched_tacan(chan)

    for i = 1,#beacon_data do
        if beacon_data[i].ntype == NAV_TYPE_VOR_TAC or beacon_data[i].ntype == NAV_TYPE_TCN then
		
            if chan == beacon_data[i].channel or getTACANFrequency(chan, 'X') == beacon_data[i].frequency then

                if beacon_data[i].position.y == nil then
                    beacon_data[i].position.y = Terrain.GetHeight(beacon_data[i].position.x, beacon_data[i].position.z)+10   -- fix caucasus height
                end

			--	tacan_channel_param:set(chan)
                return beacon_data[i]
				
				
            end
        end
    end
    return nil
end

function update_tacan()
    local max_tacan_range = 225

    -- for position of the active_tacan beacon, update visibility, distance, and range
    if atcn ~= nil and (tacan_mode == "REC" or tacan_mode == "T/R" or tacan_mode == "A/A") then

	if tacan_mode == "A/A" then
		tacan_channel_param:set(tacan_channel)
	else
		tacan_channel_param:set(0)
	end
	   local curx,cury,curz = sensor_data.getSelfCoordinates()

        if Terrain.isVisible(curx,cury,curz,atcn.position.x,atcn.position.y+15,atcn.position.z) then
            local range = math.sqrt( (atcn.position.x - curx)^2 + (atcn.position.y - cury)^2 + (atcn.position.z - curz)^2 )/nm2meter
            if range < max_tacan_range then
                if tacan_mode == "T/R" then
                    arn52_range = (range < max_tacan_range) and range or nil
                    --print_message_to_user("range: "..arn52_range)
                end

                --local bearing = true_bearing_deg_from_xz(curx, curz, atcn.position.x, atcn.position.z)
                local bearing = true_bearing_viall_from_xz(curx, curz, atcn.position.x, atcn.position.z)
                local declination = get_declination()

                -- grid X/Y isn't aligned with true north, so find average adjustment between current position and beacon source
                local adj = get_true_deviation_from_grid( (atcn.position.x+curx)/2, (atcn.position.z+curz)/2)
                --print_message_to_user("declination= "..declination.."  adj= "..adj)

                arn52_bearing = (bearing - declination - adj) % 360
                --print_message_to_user("brg: "..bearing.."  dec: "..declination.."  mb: "..arn52_bearing)

                if not tacan_audio_active then
                    local timenow = get_model_time()
                    if (math.floor(timenow) % 8) == 0 then
                        if atcn.callsign ~= nil then
                            current_morse_string = get_morse(atcn.callsign)
                            tacan_audio_active = true
                        end
                    end
                end

            else
                current_morse_string = ""
                tacan_audio_active = false
                arn52_range = nil
                arn52_bearing = nil
            end
        else
            -- do not change string here, modulated with volume instead
            arn52_range = nil
            arn52_bearing = nil
        end
    else
        arn52_range = nil
        arn52_bearing = nil
        current_morse_string = ""
        tacan_audio_active = false
    end
end

local needle1_value = WMA_wrap(0.15,0,0,360)
function bdhi_draw_needle1( brg )
    bdhi_needle1:set( needle1_value:get_WMA_wrap(brg) )
end

local needle2_value = WMA_wrap(0.15,0,0,360)
function bdhi_draw_needle2( brg )
    bdhi_needle2:set( needle2_value:get_WMA_wrap(brg) )
end


local bdhi_moving_range = WMA(0.15,0)
function bdhi_draw_range( r )
    if r ~= nil then
        r = bdhi_moving_range:get_WMA(r)
        bdhi_dme_flag:set(1)
    else
        r = bdhi_moving_range:get_WMA(0)    -- move towards 0 on nil range
        bdhi_dme_flag:set(0)
    end
    bdhi_dme_Xxx:set(  r      /1000 )
    bdhi_dme_xXx:set( (r%100) /100  )
    bdhi_dme_xxX:set( (r%10 ) / 10  )
end


function update_bdhi()
    local maghead = get_magnetic()
    bdhi_hdg:set(maghead)   -- outer ring of BDHI always operates as a magnetic compass

    if not get_elec_26V_ac_ok() then
        return
    end

    if bdhi_mode == "TACAN" then
        local mh = 360 - bdhi_hdg:get() -- compass dial of BDHI rotates backwards
        local gear = get_aircraft_draw_argument_value(0) -- nose gear

        if (not (gear>0.01 and get_elec_emergency_gen_active())) then
            -- NATOPS: When the emergency generator is extended,
            --    ARN-52(V), APX-6B, ARA-25, ARC-27 A,
            --    and the compass system are the only navigational
            --    aids available to the pilot. ARN-52(V)
            --    is inoperative when the landing gear is DOWN
            -- ARN-52(V) == TACAN bearing-distance
            if arn52_bearing ~= nil then
                --print_message_to_user("mh= "..maghead.." brg= "..arn52_bearing)
                bdhi_draw_needle2( (arn52_bearing - maghead) % 360 )
                bdhi_draw_needle1( 330 )
            end
            bdhi_draw_range( arn52_range )
        else
            bdhi_draw_needle2( mh )
            bdhi_draw_range( nil )
        end
    elseif bdhi_mode == "NAVCMPTR" then
        if asn41_valid:get() == 1 then
            local mh = 360 - bdhi_hdg:get() -- compass dial of BDHI rotates backwards
            -- BDHI is getting its data from the ASN-41 navigation computer
            bdhi_draw_needle2( (mh + asn41_bearing:get()) % 360 )
            bdhi_draw_needle1( (mh + asn41_track:get()) % 360 )
            bdhi_draw_range( asn41_range:get() )
        else
            bdhi_draw_range( nil )
            bdhi_draw_needle2(0)
            bdhi_draw_needle1(0)
        end
    elseif bdhi_mode == "NAVPAC" then
        -- special debug mode.  output the waypoint number to the BDHI as needle #2, 10 degrees per waypoint ID
        if asn41_valid:get() == 1 then
            local mh = 360 - bdhi_hdg:get() -- compass dial of BDHI rotates backwards
            -- BDHI is getting its data from the ASN-41 navigation computer
            bdhi_draw_needle2( (mh + asn41_bearing:get()) % 360 )
            bdhi_draw_needle1( (mh + (mridx-1)*10) % 360 )
            bdhi_draw_range( asn41_range:get() )
        else
            bdhi_draw_needle2(0)
            bdhi_draw_needle1(0)
            bdhi_draw_range( nil )
        end
    end

--    bdhi_ils_gs:set(-1)
--    bdhi_ils_loc:set(-1)
end

function update_morse_playback()
    if #current_morse_string==0 then
        tacan_audio_active = false
        return
    end
    if (time_to_next_morse>0) then
        time_to_next_morse=time_to_next_morse-update_time_step
    end
    if time_to_next_morse <= 0 then
        -- if we fly behind a hill in the middle of a transmission, mute it while it's obscured but keep updating it
        if arn52_bearing == nil then
            morse_dot_snd:update(nil,0,nil)
            morse_dash_snd:update(nil,0,nil)
        else
            morse_dot_snd:update(nil,tacan_volume,nil)
            morse_dash_snd:update(nil,tacan_volume,nil)
        end

        --print_message_to_user(current_morse_string)
        local c = current_morse_string:sub(1,1)
        --[[if morse_dot_snd:is_playing() or morse_dash_snd:is_playing() then
            print_message_to_user("previous sound still playing!")
            log.alert("previous sound still playing!")
        end--]]
        --print(c)
        if (c=='.') then
            time_to_next_morse=2*morse_unit_time  -- dot and pause
            morse_dot_snd:play_once()
        elseif (c=='-') then
            time_to_next_morse=4*morse_unit_time  -- dash and pause
            morse_dash_snd:play_once()
        elseif (c==' ') then
            time_to_next_morse=morse_unit_time
        else
            log.alert("Bad morse character: "..tostring(c))
        end
        current_morse_string=current_morse_string:sub(2,#current_morse_string)
    end
end

function update()
	model_time = get_model_time()
	get_base_sensor_data()
    
	update_carrier_pos()
	update_carrier_tcn()	
	
	if get_elec_fwd_mon_ac_ok() then
        update_apn153() -- AN/APN-153(V) RADAR NAVIGATION SET (DOPPLER)
        update_asn41()  -- AN/ASN-41 NAVIGATION COMPUTER SYSTEM
    else
        set_apn153_memorylight(0)
        apn153_state = "apn153-off"
        apn153_update_tempcondition()
    end

    if get_elec_mon_primary_ac_ok() then
        update_tacan()  -- AN/ARN-52(V) TACAN BEARING-DISTANCE EQUIPMENT
    end

    if get_elec_26V_ac_ok() then
        update_bdhi()
    end
    if tacan_audio_active then
        update_morse_playback()
    end
end

function update_carrier_tcn()

--local cvn_x = carrier_posx_param:get()
--local cvn_z = carrier_posz_param:get()

--print_message_to_user(#miz_carriers)
	for i = 1,#miz_carriers do
	--	print_message_to_user(i)
		if miz_carriers[i].tacan ~= -1 then
--		print_message_to_user("updatecarriertcn - "..miz_carriers[i].tacan)
			local cvn_tcn_id = nil
			--print_message_to_user(#beacon_data)
			for ib = 1,#beacon_data do
--	print_message_to_user(beacon_data[ib].callsign)			
				if beacon_data[ib].callsign == (miz_carriers[i].tacan .."x") then
					beacon_data[ib].channel 	= miz_carriers[i].tacan
					beacon_data[ib].position.x 	= miz_carriers[i].act_x
					beacon_data[ib].position.z 	= miz_carriers[i].act_z
					--beacon_data[ib].position.x , beacon_data[ib].position.z = get_actual_carrier_pos(i)
					beacon_data[ib].position.y 	= 21
					beacon_data[ib].ntype		= NAV_TYPE_TCN
					beacon_data[ib].frequency    = miz_carriers[i].tacan
					cvn_tcn_id = ib
							
				end	
			end	
			
			if not cvn_tcn_id then
				beacon_data[#beacon_data+1] = {
												callsign 		= miz_carriers[i].tacan .."x",
												channel 		= miz_carriers[i].tacan ,
												position		= {
																	x = miz_carriers[i].x,
																	z = miz_carriers[i].z,
																	y =21},
												ntype			= NAV_TYPE_TCN,
												frequency    	= miz_carriers[i].tacan,
												
												}
				--print_message_to_user(dir(beacon_data[#beacon_data]))
			end						
	
	
		end
	end

	--	if cvn_x ~=	0 then
	--	end
	
	
	
	
	

end	


function get_base_sensor_data()

	Sensor_Data_Raw = get_base_data()
	
	local self_loc_x , own_alt, self_loc_y = Sensor_Data_Raw.getSelfCoordinates()
	local self_vel_l,	self_vel_v,self_vel_h = Sensor_Data_Raw.getSelfAirspeed()
	Sensor_Data_Mod = 	{
							throttle_pos_l  = Sensor_Data_Raw.getThrottleLeftPosition(),
							throttle_pos_r  = Sensor_Data_Raw.getThrottleRightPosition(),
							mach			= Sensor_Data_Raw.getMachNumber(),
							nose_wow		= Sensor_Data_Raw.getWOW_NoseLandingGear(),
							
							AoS 			= math.deg(Sensor_Data_Raw.getAngleOfSlide()),		--is in rad
							AoA 			= math.deg(Sensor_Data_Raw.getAngleOfAttack()),		--is in rad?
							
							self_m_x 		= self_loc_x,
							self_m_z 		= self_loc_y,
							self_m_y 		= own_alt,
							self_alt 		= own_alt,
							
							self_vl			= self_vel_l,
							self_vv			= self_vel_v,
							self_vh			= self_vel_h,
							self_gs			= math.sqrt(self_vel_h^2 + self_vel_l^2),	--grondspeed meters/s
							
							
							self_balt		= Sensor_Data_Raw.getBarometricAltitude(),
							self_ralt		= Sensor_Data_Raw.getRadarAltitude(),
							
							self_pitch		= math.deg(Sensor_Data_Raw.getPitch()),
							self_bank		= math.deg(Sensor_Data_Raw.getRoll()),
							
							self_head			= math.rad(360)-Sensor_Data_Raw.getHeading(),
							self_head_raw		= Sensor_Data_Raw.getHeading(),
							self_head_rad		= math.rad(360)-Sensor_Data_Raw.getHeading(),
							self_head_deg		= -((math.deg(Sensor_Data_Raw.getHeading()))-360),
							
							self_head_wpt_rad	= math.rad((360-(math.deg(Sensor_Data_Raw.getHeading()))) + 0),
							
							self_ias 			=  Sensor_Data_Raw.getIndicatedAirSpeed(),
							true_speed			= Sensor_Data_Raw.getTrueAirSpeed()		,
							--true_speed			= (3600 * (Sensor_Data_Raw.getTrueAirSpeed()))		/ 1000,
							
							eng_l_fuel_usage	=	Sensor_Data_Raw.getEngineLeftFuelConsumption(),
							eng_l_rpm_text		=	Sensor_Data_Raw.getEngineLeftRPM(),
							eng_l_temp_text		=	Sensor_Data_Raw.getEngineLeftTemperatureBeforeTurbine(),
							eng_l_rpm_rot		=	math.rad(180) * (Sensor_Data_Raw.getEngineLeftRPM()),
							eng_l_temp_rot		=	(Sensor_Data_Raw.getEngineLeftTemperatureBeforeTurbine()),
													
							eng_r_fuel_usage	=	Sensor_Data_Raw.getEngineRightFuelConsumption(),
							eng_r_rpm_text		=	Sensor_Data_Raw.getEngineRightRPM(),
							eng_r_temp_text		=	Sensor_Data_Raw.getEngineRightTemperatureBeforeTurbine(),
							eng_r_rpm_rot		=	math.rad(180) * (Sensor_Data_Raw.getEngineRightRPM()),
							eng_r_temp_rot		=	(Sensor_Data_Raw.getEngineRightTemperatureBeforeTurbine()),

							fuel_weight			= 	Sensor_Data_Raw.getTotalFuelWeight(),
						}	

end


startup_print("nav: load end")
need_to_be_closed = false -- close lua state after initialization
