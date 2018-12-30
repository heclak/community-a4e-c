--[[
   All func defined in NAV_func.lua, used by both EB & CC
--]]

--- for test
local fileName =  get_terrain_related_data("beacons") or get_terrain_related_data("beaconsFile")
if 	  fileName then 
	local f = loadfile(fileName)
	if    f     then
		  f()
	end
end

local Terrain			= require('terrain')

terrainAirdromes = get_terrain_related_data("Airdromes") or {};

theatre          = get_terrain_related_data("name")

dofile(LockOn_Options.script_path.."Nav/NAV_util.lua") -- in module, seems not to use dofile() to load 'NAV_func.lua'

-- NTTR: all in beacons; Caucasus: beacons & Airdrome
local theatre_EB = theatre or "none" -- for test, setup in NAV_func.lua

-- EB has TACAN, VOR, ILS
local nav_ndb = {}

if theatre_EB == 'Nevada' then
  -- clean
	
	for i,o in pairs(beacons) do
		if o.type == NAV_TYPE_NDB_AF or o.type == NAV_TYPE_NDB then
			nav_ndb[#nav_ndb + 1] = NAV_STATION2(o)

		end	
	end
	
elseif theatre_EB == 'Caucasus' then
  -- clean
  for i,o in pairs(beacons) do
		if o.type == NAV_TYPE_NDB_AF or o.type == NAV_TYPE_NDB then
			nav_ndb[#nav_ndb + 1] = NAV_STATION1(o)
		end	
	end

  -- Airport homer
	for i,o in pairs(Airdrome) do
    if o ~= nil and terrainAirdromes[i] ~= nil then

      if o.airdrome ~= nil then
        for ia, oaf in pairs(o.airdrome) do
          if oaf.type ~= nil then
            if oaf.type == NAV_TYPE_NDB_AF or oaf.type == NAV_TYPE_NDB or oaf.type == NAV_TYPE_NDB_AF_MK then
              table.insert(oaf, "name")
              oaf.name = terrainAirdromes[i].names.en
              nav_ndb[#nav_ndb + 1] = NAV_STATION1(oaf)
            end
          end
        end
      end
    end
  end
  
  -- Airport runway far/near
  for i,o in pairs(Airdrome) do
    if terrainAirdromes[i] then
      local roadnet = terrainAirdromes[i].roadnet
      if roadnet then
        if o.runway then
          for sideRangeName, ranges in pairs(o.runway) do
            if ranges.side then
              for sideName, sides in pairs(ranges.side) do
                for j, side in ipairs(sides) do
                  local sideType = side.type
                  
                  if sideType == NAV_TYPE_NDB_OUTER or sideType == NAV_TYPE_NDB_INNER or sideType == NAV_TYPE_NDB_AF_MK then
                    --createBeaconsWithMarkerFromRunway(sideType, side, sideName, roadnet)
                    
                    local position = side.position
                    
                    if not position then
                      if sideType == NAV_TYPE_NDB_OUTER then
                        position = {S0 = -4000}
                      elseif sideType == NAV_TYPE_NDB_INNER then
                        position = {S0 = -1300}
                      end
                    end
                    
                    for ii, runway in pairs(Terrain.getRunwayList(roadnet)) do
                      local sideX, sideY, angle	= getBeaconPlacement(sideName, runway, roadnet)
                      local x, y					= getBeaconPosition(sideX, sideY, angle, position)
                      local iopos = ""
                      if sideType == NAV_TYPE_NDB_INNER then
                        iopos = "-inner"
                      elseif sideType == NAV_TYPE_NDB_OUTER then
                        iopos = "-outer"
                      end
                      local	homer_data = {
                                            name        = terrainAirdromes[i].names.en.."-"..sideName..iopos,
                                            beaconId    = "",
                                            ntype       = sideType,
                                            callsign    = side.callsign or nil,
                                            frequency   = side.frequency,
                                            channel     = side.channel or nil,
                                            position    = {x = x, z = y,}, -- in-game xyz
                                            --direction   = homer.direction or nil,
                                            positionGeo = position or nil, -- lat/long
                                          }
                      
                      nav_ndb[#nav_ndb + 1] = NAV_STATION1(homer_data)
                    end
                    
                  end
                end
              end
            end
          end	
        end
      end
    end
  end
  
end

return nav_ndb
--print("done")
