--dofile(LockOn_Options.script_path.."debug.lua")
--print_message_to_user(LockOn_Options.script_path)
--dir(getmetatable(GetDevice(deviceid)))))

function dump_to_file(file_to_export)

--function dump_to_file()
	local tmp_file = lfs.writedir()..'Data\\g_dump.lua'
	file = io.open(tmp_file, "w+")

	--tmp_data = get_terrain_related_data()
	tmp_data = file_to_export
	str=dump("tmp_data",tmp_data)
	--str=dump("_G",_G)
	file:write(str)
	file:close()
	
end
--[[

"list_cockpit_params"			--works

get_mission_route				--works
get_aircraft_mission_data		--nope
get_cockpit_draw_argument_value(2001)

]]--


function basic_dump (o)
	if type(o) == "number" then
		return tostring(o)
	elseif type(o) == "string" then
		return string.format("%q", o)
	else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
		return tostring(o)
	end
end


function dump (name, value, saved, result)
	seen = seen or {} -- initial value
	result = result or ""
	result=result..name.." = "
	if type(value) ~= "table" then
		result=result..basic_dump(value).."\n"
	elseif type(value) == "table" then
		if seen[value] then -- value already saved?
		result=result.."->"..seen[value].."\n" -- use its previous name
		else
		seen[value] = name -- save name for next time
		result=result.."{}\n" -- create a new table
			for k,v in pairs(value) do -- save its fields
				local fieldname = string.format("%s[%s]", name,basic_dump(k))
			--	print_message_to_user(fieldname)
				if fieldname~="_G[\""..seen[value].."\"]" then
					result=dump(fieldname, v, seen, result)
				end
			end
		end
	end
	return result
end



--dump_to_file()


function dir(obj,level)
  local s,t = '', type(obj)

  level = level or ' '

  if (t=='nil') or (t=='boolean') or (t=='number') or (t=='string') then
    s = tostring(obj)
    if t=='string' then
      s = '"' .. s .. '"'
    end
  elseif t=='function' then s='function'
  elseif t=='userdata' then
    s='userdata'
    for n,v in pairs(getmetatable(obj)) do  s = s .. " (" .. n .. "," .. dir(v) .. ")" end
  elseif t=='thread' then s='thread'
  elseif t=='table' then
    s = '{'
    for k,v in pairs(obj) do
      local k_str = tostring(k)
      if type(k)=='string' then
        k_str = '["' .. k_str .. '"]'
      end
      s = s .. k_str .. ' = ' .. dir(v,level .. level) .. ', '
    end
    s = string.sub(s, 1, -3)
    s = s .. '}'
  end
  return s
end

