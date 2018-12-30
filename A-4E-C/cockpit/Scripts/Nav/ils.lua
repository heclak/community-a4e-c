dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

local sensor_data = get_base_data()
local meter2mile = 0.000621371

local degrees_per_radian = 57.2957795
--local feet_per_meter_per_minute = 196.8

local hsi_comp = get_param_handle("D_MHDG")
local ils_gs_bar = get_param_handle("D_ILS_GS")
local ils_loc_bar = get_param_handle("D_ILS_LOC")

--local hsi_1000 = get_param_handle("D_HSI_1000")

--local tcn_001 = get_param_handle("D_TCN_001")
--local tcn_010 = get_param_handle("D_TCN_010")
--local tcn_xy = get_param_handle("D_TCN_XY")

--local vor_d01 = get_param_handle("D_VOR_D_01")
--local vor_d10 = get_param_handle("D_VOR_D_10")
--local vor_i001 = get_param_handle("D_VOR_I_001")
--local vor_i010 = get_param_handle("D_VOR_I_010")
--local vor_i100 = get_param_handle("D_VOR_I_100")

-- Variables

local ils_loc = {}
local ils_gs = {}


local ilschnidx = 0

local found = 0

local glideslope = 3
local gsarc = 5

local locarc = 7.5

local rangelimit =  390 * 1.1508 -- nmile2mile

dev:listen_command(Keys.NavReset)
dev:listen_command(Keys.NavILSNext)
dev:listen_command(Keys.NavILSPrev)


function post_initialize()
    
  ils_gs_bar:set(-1)
	ils_loc_bar:set(-1)
  
  -- nav data
	local f1 = loadfile(LockOn_Options.script_path.."Nav/ils_data.lua")
  ils_loc, ils_gs = f1()
  
  for i=1,#ils_loc do
    ils_gs[i].direction = ils_loc[i].direction
  end
  --print_message_to_user("ils loc: "..#ils_loc..", ils gs: "..#ils_gs)
  
  ilschnidx = 0
  
end

function SetCommand(command,value)
  --print_message_to_user("key: "..command)
  
	if command == Keys.NavILSNext or command == Keys.NavILSPrev then
    
    if #ils_loc > 0 then
      if command == Keys.NavILSNext then
        ilschnidx = ilschnidx + 1
      elseif command == Keys.NavILSPrev then
        ilschnidx = ilschnidx - 1
        if ilschnidx < 0 then
          ilschnidx = #ils_loc
        end
      end
      ilschnidx = ilschnidx%(#ils_loc+1)
      if ilschnidx > 0 then
        local tmpname = ''
        if ils_loc[ilschnidx].name ~= '' then
          tmpname = ils_loc[ilschnidx].name
        else
          tmpname = ils_loc[ilschnidx].beaconId
        end
        print_message_to_user("ils: "..ilschnidx.."("..#ils_loc.."): "..tmpname..", ang: "..ils_loc[ilschnidx].direction)
      end
      if ilschnidx > 0 then
        local tmpname = ''
        if ils_gs[ilschnidx].name ~= '' then
          tmpname = ils_gs[ilschnidx].name
        else
          tmpname = ils_gs[ilschnidx].beaconId
        end
        print_message_to_user("ils: "..ilschnidx.."("..#ils_gs.."): "..tmpname..", ang: "..ils_gs[ilschnidx].direction)
      end      
    else
      print_message_to_user("no ils")
    end
  
  elseif command == Keys.NavReset then
    ilschnidx = 0
    print_message_to_user("Reset ils channels")
  end
  
end

local function evalLoc(data_src, navchnidx)
  local tgt_rad = 0
  local rate = -1
  
  if #data_src > 0 and navchnidx > 0 then
    local st = data_src[navchnidx]
    
    -- local tcn10 = get_cockpit_draw_argument_value(621) 
    if st.position.x ~= nil and st.position.z ~= nil then

      local tx = st.position.x
      local tz = st.position.z
      
      -- print_message_to_user("ndb ".. st.name .." ".. st.frequency .." ".. tx .. " " .. tz)
      
      local lx, ly, lz = sensor_data.getSelfCoordinates()
      -- point to self, so need add 180 degree later
      local dx = lx - tx -- vertical
      local dz = lz - tz -- horizontal
      --local trad = 0

      local dist = math.sqrt(dx*dx + dz*dz)
      if dist == 0 then dist = 0.001 end
      local distmile = dist*meter2mile
      
      if distmile <= 15 then
        if dx >= 0 then
          tgt_rad = ((360 + 90 - degrees_per_radian * math.acos(dz/dist)))%360
        else
          tgt_rad = ((90 + degrees_per_radian * math.acos(dz/dist)))%360
        end
      
        if st.direction - tgt_rad <= locarc and st.direction - tgt_rad >= -locarc then
          found = 1
          rate = (tgt_rad - st.direction)/locarc
        else
          found = 0
        end
        
      else
        found = 0
      end
      
    else
      found = 0
    end
    
  else
    found = 0
  end
  
  if found == 0 then
    rate = -1
  end

  return rate
end


local function evalGS(data_src, navchnidx)
  local tgt_rad = 0
  local rate = -1
  
  if #data_src > 0 and navchnidx > 0 then
    local st = data_src[navchnidx]
    
    -- local tcn10 = get_cockpit_draw_argument_value(621) 
    if st.position.x ~= nil and st.position.z ~= nil then
            
      local tx = st.position.x
      local tz = st.position.z
      local ty = st.position.y
      
      -- print_message_to_user("ndb ".. st.name .." ".. st.frequency .." ".. tx .. " " .. tz)
      
      local lx, ly, lz = sensor_data.getSelfCoordinates()
      -- point to self, so need add 180 degree later
      local dx = lx - tx -- vertical
      local dz = lz - tz -- horizontal
      local dy = ly - ty -- altitude
      --local trad = 0

      local disttmp = math.sqrt(dx*dx + dz*dz)
      local dist = math.sqrt(disttmp*disttmp + dy*dy)
      if dist <= 0 then dist = 0.001 end
      local distmile = dist*meter2mile
      local disttmpmile = disttmp*meter2mile
      
      --print_message_to_user("dist: "..disttmp..", self alt: "..ly..", ILS alt: "..ty)
      
      if disttmpmile <= 15 then
        if dy >= 0 then
          tgt_rad = degrees_per_radian * math.asin(dy*meter2mile/distmile)
          --print_message_to_user("gs deg: "..tgt_rad)
          
          local sect_rad = 0
          if dx >= 0 then
            sect_rad = ((360 + 90 - degrees_per_radian * math.acos(dz/disttmp)))%360
          else
            sect_rad = ((90 + degrees_per_radian * math.acos(dz/disttmp)))%360
          end
                
          if (glideslope - tgt_rad <= gsarc and glideslope - tgt_rad >= -gsarc) and (st.direction - sect_rad <= locarc and st.direction - sect_rad >= -locarc) then
            found = 1
            rate = (glideslope - tgt_rad)/gsarc
          else
            found = 0
          end
          
        else
          found = 0
        end
        
      else
        found = 0
      end
      
    else
      found = 0
    end
    
  else
    found = 0
  end
  
  if found == 0 then
    rate = -1
  end

  return rate
end


function update()
  loc_arg = evalLoc(ils_loc, ilschnidx)
  ils_loc_bar:set(loc_arg)

  gs_arg = evalGS(ils_gs, ilschnidx)
  ils_gs_bar:set(gs_arg)
    
end

need_to_be_closed = false -- close lua state after initialization
