--dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 5
--local feet_per_meter_per_minute = 196.8
make_default_activity(update_time_step)--update will be called every 15 seconds

--local dev = GetSelf()
local sensor_data = get_base_data()
local Terrain			= require('terrain')

local meter2mile = 0.000621371
local degrees_per_radian = 57.2957795

--local terrain_block = get_param_handle("PARAM_TERRAIN_MASK")
local tcn_idx = get_param_handle("PARAM_TCN_IDX")
local ndb_idx = get_param_handle("PARAM_NDB_IDX")

local tcn_block = get_param_handle("PARAM_TCN_TERRAIN_BLOCK")
local ndb_block = get_param_handle("PARAM_NDB_TERRAIN_BLOCK")

local tacan_data = {}
local ndb_data = {}

local distseg = 2000

function post_initialize()
  local f1 = loadfile(LockOn_Options.script_path.."Nav/tcn_data.lua")
	-- local f3 = loadfile(LockOn_Options.script_path.."Nav/ndb_data.lua")
  
  tacan_data = f1()
  -- ndb_data = f3() -- test
  
  tcn_block:set(0)
  -- ndb_block:set(0)
end

function SetCommand(command,value)

end

local function evalSrc(data_src, data_idx, navchnidx, tgt_brn, cur_hdg)


end

function update()
  local tcnid = tcn_idx:get()
  local ndbid = ndb_idx:get()
  
  if tcnid > 0 then
    local selfx, selfy, selfz = sensor_data.getSelfCoordinates()
    local st = tacan_data[tcnid]
    local tgtx = st.position.x
    local tgtz = st.position.z 
    
    if tgtx ~= nil and tgtz ~= nil then
      local tgty = math.floor(Terrain.GetHeight(tgtx, tgtz) + 0.5)
      
      local distx = math.abs(tgtx - selfx)
      local distz = math.abs(tgtz - selfz)
      local dist = math.sqrt(distx*distx + distz*distz)
      
      local dx = distx/distseg
      local dz = distz/distseg
      
      local isblock = 0
      
      for i=1,distseg-1 do
        local newx = selfx + i*dx
        local newz = selfz + i*dz
        local newy = math.floor(Terrain.GetHeight(newx, newz) + 0.5)
        
        local disttmp = math.sqrt((tgtx-newx)*(tgtx-newx) + (tgtz-newz)*(tgtz-newz))
        local safey = disttmp/dist * math.abs(selfy - tgty) + tgty
        
        if safey <= newy then
          isblock = 1
          break
        end
      
      end
      
      if isblock == 1 then
        tcn_block:set(1)
      else
        tcn_block:set(0)
      end
      
      --print_message_to_user("terrain block tcn: "..isblock)
      
    end
  end
  
  -- if ndbid > 0 and 0 then
  
  -- end  
end

need_to_be_closed = false -- close lua state after initialization
