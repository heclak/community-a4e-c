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


terrainAirdromes = get_terrain_related_data("Airdromes") or {};

theatre          = get_terrain_related_data("name")

dofile(LockOn_Options.script_path.."Nav/NAV_util.lua") -- in module, seems not to use dofile() to load 'NAV_func.lua'

-- NTTR: all in beacons; Caucasus: beacons & Airdrome
local theatre_EB = theatre or "none" -- for test, setup in NAV_func.lua

-- EB has TACAN, VOR, ILS
local nav_vor = {}

if theatre_EB == 'Nevada' then
  -- clean
	
	for i,o in pairs(beacons) do
		if o.type == NAV_TYPE_VOR_TAC or o.type == NAV_TYPE_VOR_DME then
			nav_vor[#nav_vor + 1] = NAV_STATION2(o)
		end	
	end
	
elseif theatre_EB == 'Caucasus' then
  -- clean
   
  -- Airport related
	for i,o in pairs(Airdrome) do
    if o ~= nil then
      
      -- VOR & TACAN
      if o.airdrome ~= nil then
        for ia, oaf in pairs(o.airdrome) do
          if oaf.type ~= nil then
            if oaf.type == NAV_TYPE_VOR then
              local tmpafname = terrainAirdromes[i].names.en
              nav_vor[#nav_vor + 1] = af_homer(tmpafname, oaf)
              
            end
          end
        end
      end
 
    end
	end  

end

return nav_vor

--print("done")
