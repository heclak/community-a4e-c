dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."APR-25_RWR/rwr_apr-25_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local update_time_step = 0.05
make_default_activity(update_time_step)
--device_timer_dt     = 0.02  	--0.2 

dev:listen_command(device_commands.new_apr25_sound_on)
dev:listen_command(device_commands.new_apr25_volume)
dev:listen_command(device_commands.new_apr25_power)

NO_BAND = 0
I_BAND_RADAR = 1
G_BAND_RADAR = 2
E_BAND_RADAR = 3

local apr25_power = false

local apr25_band_enabled = {
    [NO_BAND] = false,
    [I_BAND_RADAR] = true,
    [G_BAND_RADAR] = true,
    [E_BAND_RADAR] = true,
}

local apr25_aaa_defeat = false
local apr25_audio = false
local apr25_volume = 0.1

--Signal
SIGNAL_SEARCH = 1
SIGNAL_LOCK = 2
SIGNAL_LAUNCH = 3

--General Type
GENERAL_TYPE_EWR = 0
GENERAL_TYPE_AIRCRAFT = 1
GENERAL_TYPE_SURFACE = 2
GENERAL_TYPE_SHIP = 3

--source returns the unique unit id.
--power is between 0 and 1
--priority some abstract priority number on the order of hundreds
--time is time since the last recieved signal.

emitter_info = {}

emitter_default_sounds = {
    [GENERAL_TYPE_EWR] = {
        [SIGNAL_SEARCH] = get_param_handle("RWR_EWR_LO"),
    },
    [GENERAL_TYPE_AIRCRAFT] = {
        [SIGNAL_SEARCH] = get_param_handle("RWR_AI_GENERAL"),
    },
    [GENERAL_TYPE_SURFACE] = {
        [SIGNAL_SEARCH] = get_param_handle("RWR_SURFACE_LO"),
        [SIGNAL_LOCK] = get_param_handle("RWR_SURFACE_HI"),
    },
    [GENERAL_TYPE_SHIP] = {
        [SIGNAL_SEARCH] = get_param_handle("RWR_SHIP_LO"),
        [SIGNAL_LOCK] = get_param_handle("RWR_SHIP_HI"),
    },
}

function add_emitter(name, band, gain, search, lock, launch)
    emitter_info[name] = {
        band = band,
        gain = gain,
        audio = {
            [SIGNAL_SEARCH] = get_param_handle(search),
            [SIGNAL_LOCK] = get_param_handle(lock),
            [SIGNAL_LAUNCH] = get_param_handle(launch),
        }
    }
end

add_emitter("ZSU-23-4 Shilka",   E_BAND_RADAR,  0.7)                                                                                --SPAAA ZSU-23-4 Shilka "Gun Dish"
--         ("SNR_75V")                                                                                                              --SAM SA-2 S-75 "Fan Song" TR
add_emitter("SNR_75VE",          E_BAND_RADAR,  1.0, "RWR_FAN_SONG_TROUGH_E_LO", "RWR_FAN_SONG_TROUGH_E_HI")                        ----E-band (get_fan_song_variant)
add_emitter("SNR_75VG",          G_BAND_RADAR,  1.0, "RWR_FAN_SONG_TROUGH_G_LO", "RWR_FAN_SONG_TROUGH_E_HI", "RWR_FAN_SONG_LORO_G") ----G-band (get_fan_song_variant)
add_emitter("snr s-125 tr",      E_BAND_RADAR,  1.0, "RWR_LOW_BLOW_LO")                                                             --SAM SA-3 S-125 "Low Blow" TR
add_emitter("RPC_5N62V",         I_BAND_RADAR,  1.0, "RWR_SA5_LO", "RWR_SA5_HI")                                                    --SAM SA-5 S-200 "Square Pair" TR

--UNIT LIST: https://github.com/pydcs/dcs/blob/master/dcs/vehicles.py

----------------------------------------------------------------------
--VEHICLES                      --UNIT NAME
----------------------------------------------------------------------
--1L13 EWR                      --EWR 1L13
--55G6 EWR                      --EWR 55G6
--Dog Ear radar                 --MCC-SR Sborka "Dog Ear" SR
--M1097 Avenger                 --SAM Avenger (Stinger)
--M48 Chaparral                 --SAM Chaparral M48
--Hawk cwar                     --SAM Hawk CWAR AN/MPQ-55
--Hawk tr                       --SAM Hawk TR (AN/MPQ-46)
--Hawk sr                       --SAM Hawk SR (AN/MPQ-50)
--M6 Linebacker                 --SAM Linebacker - Bradley M6
--p-19 s-125 sr                 --SAM SA-2/3/5 P19 "Flat Face" SR 
--RLS_19J6                      --SAM SA-5 S-200 ST-68U "Tin Shield" SR
--Kub 1S91 str                  --SAM SA-6 Kub "Straight Flush" STR
--Kub 2P25 ln                   --SAM SA-6 Kub "Gainful" TEL
--Osa 9A33 ln                   --SAM SA-8 Osa "Gecko" TEL
--Strela-1 9P31                 --SAM SA-9 Strela 1 "Gaskin" TEL
--S-300PS 40B6MD sr             --SAM SA-10 S-300 "Grumble" Clam Shell SR
--S-300PS 64H6E s               --SAM SA-10 S-300 "Grumble" Big Bird SR 
--S-300PS 40B6M tr              --SAM SA-10 S-300 "Grumble" Flap Lid TR 
--SA-11 Buk SR 9S18M1           --SAM SA-11 Buk "Gadfly" Snow Drift SR
--SA-11 Buk LN 9A310M1          --SAM SA-11 Buk "Gadfly" Fire Dome TEL
--Strela-10M3                   --SAM SA-13 Strela 10M3 "Gopher" TEL
--Tor 9A331                     --SAM SA-15 Tor "Gauntlet"
--2S6 Tunguska                  --SAM SA-19 Tunguska "Grison" 
--Roland Radar                  --SAM Roland EWR
--NASAMS_Radar_MPQ64F1          --SAM NASAMS SR MPQ64F1
--rapier_fsa_blindfire_radar    --SAM Rapier Blindfire TR
--Gepard                        --SPAAA Gepard
--Vulcan                        --SPAAA Vulcan M163

----------------------------------------------------------------------
--SHIPS                         --UNIT NAME
----------------------------------------------------------------------
--PIOTR                         --Battlecruiser 1144.2 Pyotr Velikiy
--TICONDEROG                    --CG Ticonderoga
--ALBATROS                      --Corvette 1124.4 Grisha
--MOLNIYA                       --Corvette 1241.1 Molniya
--MOSCOW                        --Cruiser 1164 Moskva
--KUZNECOW                      --CV 1143.5 Admiral Kuznetsov
--CV_1143_5                     --CV 1143.5 Admiral Kuznetsov(2017)
--VINSON                        --CVN-70 Carl Vinson
--CVN_71                        --CVN-71 Theodore Roosevelt
--CVN_72                        --CVN-72 Abraham Lincoln
--Stennis                       --CVN-74 John C. Stennis
--CVN_73                        --CVN-73 George Washington 
--CVN_75                        --CVN-75 Harry S. Truman
--USS_Arleigh_Burke_IIa         --DDG Arleigh Burke IIa
--La_Combattante_II             --FAC La Combattante IIa
--PERRY                         --FFG Oliver Hazard Perry
--REZKY                         --Frigate 1135M Rezky
--NEUSTRASH                     --Frigate 11540 Neustrashimy
--LHA_Tarawa                    --LHA-1 Tarawa
--Type_052B                     --Type 052B Destroyer
--Type_054A                     --Type 054A Frigate
--Type_052C                     --Type 052C Destroyer

band_map = {
    [I_BAND_RADAR] = DASHED,
    [G_BAND_RADAR] = DOTTED,
    [E_BAND_RADAR] = SOLID,
}

fan_song_variant = {}

emitter_pos = {}

launch_timers = {}

function new_apr25_power(value)
    apr25_power = (value == 1.0)
end

function new_apr25_sound_on(value)
    apr25_audio = (value == 1.0)
end

function new_apr25_volume(value)
    apr25_volume = (1.0 + value) / 2.0
end

commands = {
    [device_commands.new_apr25_sound_on] = new_apr25_sound_on,
    [device_commands.new_apr25_volume] = new_apr25_volume,
    [device_commands.new_apr25_power] = new_apr25_power,
}

function SetCommand(command, value)
    --print_message_to_user(command.. " / "..value)
    if commands[command] then
        commands[command](value)
    end
end

function post_initialize()
    print_message_to_user("APR-25 RWR INIT")
end

function get_fan_song_variant(unit_id)
    if fan_song_variant[unit_id] == nil then
        local number = math.mod(math.floor(unit_id / 256.0), 10)
        
        fan_song_variant[unit_id] = number > 3 and "E" or "G"
    end
    return fan_song_variant[unit_id]
end

function get_unit_type(unit_type, unit_id)
    if unit_type == "SNR_75V" then
        unit_type = unit_type .. get_fan_song_variant(unit_id)
    end
    return unit_type
end

function reset_emitter_position(i)
    emitter_pos[i] = { unit_id = nil, r = 0, a= 0 }
end

function update_emitter_position(i, r, a, unit_id)

    if emitter_pos[i] == nil or emitter_pos[i].unit_id ~= unit_id then
        emitter_pos[i] = {
            unit_id = unit_id,
            r = r,
            a = a,
        }
        print_message_to_user(rwr_api:get(i, "unit_type").." ("..rwr_api:get(i, "general_type").."), "..tostring(r)..", "..tostring(a))
    else
        local x1 = emitter_pos[i].r * math.cos(emitter_pos[i].a)
        local y1 = emitter_pos[i].r * math.sin(emitter_pos[i].a)

        local x2 = r * math.cos(a)
        local y2 = r * math.sin(a)

        local x3 = x1 + (x2 - x1) * update_time_step * 1.2
        local y3 = y1 + (y2 - y1) * update_time_step * 1.2

        emitter_pos[i].r = math.sqrt(x3*x3 + y3*y3)
        emitter_pos[i].a = math.atan2(y3, x3)

        --emitter_pos[i].r = emitter_pos[i].r + (r - emitter_pos[i].r) * update_time_step

        --local delta = math.pi - math.abs(math.fmod(a - emitter_pos[i].a, 2.0 * math.pi))
        --emitter_pos[i].a = emitter_pos[i].a + delta * update_time_step
    end
end

function update_lights(i)

end

-- Takes table with signal types and their audio params
function get_closest_priority_sound(audio_table, signal)

    while signal >= SIGNAL_SEARCH and audio_table[signal] == nil do
        signal = signal - 1
    end

    return audio_table[signal]
end

function get_default(general_type, signal, power)

end

function reset_audio()
    for i1,v1 in pairs(emitter_default_sounds) do
        
        if v ~= nil then
            for i2,v2 in ipairs(v) do

                if v2 ~= nil then
                    v2:set(0.0)
                end
            end
        end
    end

    for i1,v1 in pairs(emitter_info) do
        for i2,v2 in ipairs(v1.audio) do
            v2:set(0.0)
        end
    end

end

function update_audio(general_type, type, signal, power)

    if not apr25_audio then
        return
    end

    power = power * apr25_volume

    local info = emitter_info[type]

    if info then
        audio_param = get_closest_priority_sound(info.audio, signal)
        if audio_param ~= nil then
            audio_param:set(power)
        end
    else
        if emitter_default_sounds[general_type] ~= nil then
            local audio_param = get_closest_priority_sound(emitter_default_sounds[general_type], signal)
            if audio_param ~= nil then
                audio_param:set(power)
            end
        end
    end
end

function get_radar_band(general_type, type)

    if general_type == GENERAL_TYPE_AIRCRAFT then
        return I_BAND_RADAR, 1.0
    end

    local info = emitter_info[type]
    --print_message_to_user(tostring(unit)..tostring(info.band))

    if info ~= nil then
        return info.band, info.gain
    end

    return NO_BAND, 1.0
end

function should_draw(signal, raw_unit_type, band)

    if apr25_band_enabled[band] == false then
        return false
    end

    if signal ~= SIGNAL_LAUNCH then
        return true
    end

    if raw_unit_type ~= "SNR_75V" then
        return true
    end

    if launch_timers[i] == nil or launch_timers[i] <= 0.0 then
        launch_timers[i] = 0.3
    end

    launch_timers[i] = launch_timers[i] - update_time_step

    if launch_timers[i] < 0.15 then
        return true
    end

    return false
end

function get_power_variation()
    return math.random() * 0.1
end

function get_azimuth_variation()
    return math.random() * 0.05
end

delay = 0

function debug_print()

    for i=1, num_contacts do
        unit = rwr_api:get(i, "unit_type")

        if unit ~= 0 then
            print_message_to_user(unit.." "..rwr_api:get(i, "source"))
        end
    end

    --print_message_to_user("Power: "..tostring(rwr_api:get(1, "power"))) 
    --print_message_to_user("General Type: "..tostring(rwr_api:get(1, "general_type"))) 
    --print_message_to_user("Signal: "..tostring(rwr_api:get(1, "signal"))) 
    --print_message_to_user("Source: "..tostring(rwr_api:get(1, "source"))) 
    --print_message_to_user("Priority: "..tostring(rwr_api:get(1, "priority")))
    --print_message_to_user("Unit type: "..tostring(rwr_api:get(1, "unit_type"))) 
    --print_message_to_user("Time: "..tostring(rwr_api:get(1, "time"))) 
end

function debug_print_delay()
    delay = delay + update_time_step

    if delay < 1.0 then
        return
    end

    delay = 0
    debug_print()
end

function update()
    --debug_print_delay()

    rwr_api:reset()
    reset_audio()
    
    if not get_elec_aft_mon_ac_ok() or not apr25_power then
        return
    end
    
    --bit_i_band()

    for i=1, num_contacts do

        local power = rwr_api:get(i, "power")
        if power > 0.0 and rwr_api:get(i, "time") < 3.0 then

            local general_type = rwr_api:get(i, "general_type")
            local raw_unit_type = rwr_api:get(i, "unit_type")
            local unit_id = rwr_api:get(i,"source")
            local type = get_unit_type(raw_unit_type, unit_id)
            local signal = rwr_api:get(i, "signal")
            local azimuth = rwr_api:get(i, "azimuth")
            
            update_emitter_position(i, power, azimuth, unit_id)  
            update_audio(general_type, type, signal, power)

            local band, radar_gain = get_radar_band(general_type, type)
            local line_type = band_map[band]

            if line_type ~= nil then

                power = (emitter_pos[i].r + get_power_variation()) * radar_gain
                if should_draw(signal, raw_unit_type, band) then
                    rwr_api:set(emitter_pos[i].a + get_azimuth_variation(), power, line_type)
                end
            end
        else
            reset_emitter_position(i)
        end
    end
end

function bit(band)
    rwr_api:set(math.rad(45)  + get_azimuth_variation(), 0.8  + get_power_variation(), band)
    rwr_api:set(math.rad(135) + get_azimuth_variation(), 0.8  + get_power_variation(), band)
    rwr_api:set(math.rad(225) + get_azimuth_variation(), 0.8  + get_power_variation(), band)
    rwr_api:set(math.rad(315) + get_azimuth_variation(), 0.8  + get_power_variation(), band)
end

function bit_i_band()
    bit(DASHED)
end

function bit_g_band()
    bit(DOTTED)
end

function bit_e_band()
    bit(SOLID)
end

need_to_be_closed = false -- close lua state after initialization