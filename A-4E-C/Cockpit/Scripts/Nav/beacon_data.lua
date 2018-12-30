--[[
   All func defined in NAV_func.lua, used by both EB & CC
--]]

function dump_table(t)
    for key,value in pairs(t) do
        print(key,value)
    end
end

--- for test
local fileName =  get_terrain_related_data("beacons") or get_terrain_related_data("beaconsFile")
if fileName then 
    local f = loadfile(fileName)
    if f then
        f()
    end
end


terrainAirdromes = get_terrain_related_data("Airdromes") or {};

theatre          = get_terrain_related_data("name")

dofile(LockOn_Options.script_path.."Nav/NAV_util.lua") -- in module, seems not to use dofile() to load 'NAV_func.lua'

-- NTTR: all in beacons; Caucasus: beacons & Airdrome
local theatre_EB = theatre or "none" -- for test, setup in NAV_func.lua

-- EB has TACAN, VOR, ILS
local beacon_info = {}

if next(terrainAirdromes) == not nil then
    -- Caucasus (T3) format
    for i,o in pairs(Airdrome) do
        if o ~= nil and terrainAirdromes[i] ~= nil then
            -- VOR & TACAN
            if o.airdrome ~= nil then
                for ia, oaf in pairs(o.airdrome) do
                    if oaf.type ~= nil then
                        if oaf.type == NAV_TYPE_VOR or o.type == NAV_TYPE_VOR_TAC or oaf.type == NAV_TYPE_VOR_DME or oaf.type == NAV_TYPE_TCN then
                            --dump_table(o)
                            local tmpafname = terrainAirdromes[i].names.en
                            beacon_info[#beacon_info + 1] = af_homer(tmpafname, oaf)
                            --print_message_to_user(oaf.type)
                        end
                    end
                end
            end
        end
    end
else
    -- NTTR/Normandy (T4) format
    for i,o in pairs(beacons) do
        if o.type == NAV_TYPE_VOR or o.type == NAV_TYPE_VOR_TAC or o.type == NAV_TYPE_VOR_DME or o.type == NAV_TYPE_TCN then
            beacon_info[#beacon_info + 1] = NAV_STATION2(o)
            --dump_table(o)
        end
    end
end

return beacon_info
--print("done")
