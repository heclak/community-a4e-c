
dofile(LockOn_Options.common_script_path.."tools.lua")

local mdir      = lfs.tempdir()
local cfile     = lfs.writedir()..'Data\\tempMission.lua'
local userPath  = lfs.writedir()..'Data\\'

function scandir(directory)
	local i, t = 0, {}
	for file in lfs.dir(directory) do
		if string.match(file, "~mis") then
			i = i + 1
			t[i] = directory .. file
		end
	end
	return t
end

function findMissionFile(fileList)
	local correctFile = 0
	local newest = 0
	local file_attr

	for fileNumber, filepath in pairs(fileList) do
	
		file = io.open(filepath, "r") 
	
		local fLine = file:read()
		
		if string.match(fLine, "mission") then
			file_attr = lfs.attributes(filepath)
			if file_attr.modification > newest then
				correctFile = filepath
				newest = file_attr.modification
			end
		end
		if file then
		file:close()
		end
	end
	return correctFile
	
end

function copyFile(fpath, cpath)
	infile = io.open(fpath, "r")
	instr = infile:read("*a")
	infile:close()

	outfile = io.open(cpath, "w+")
	outfile:write(instr)
	outfile:close()
end


function load_tempmission_file()

	local fList = scandir(mdir)
	local rf 	= findMissionFile(fList)
	copyFile(rf, cfile)

	dofile(userPath..'tempMission.lua')

	log.info("Temp mission file loaded")
end

----------------------------------------------------------
--miz_carriers = {}	

function decode_mission()
	local miz_carriers = {}
--print_message_to_user("decode mission")

	if mission then
--		print_message_to_user("MissionCarrier TRUE")
		local wind ={
		dir 	= mission.weather.wind.atGround.dir	,
		ms 	= mission.weather.wind.atGround.speed * 2,
		}
			
		local tmp_carrier
		
		 
	--    for key, value in ipairs(mission) do
	--		print_message_to_user(key .." / "..dir(value))
	 --   end

		local num_blue_countries = #mission.coalition.blue.country
		for i = 1,num_blue_countries do
			if mission.coalition.blue.country[i].ship then
				--num_blue_groups = num_blue_groups + #mission.coalition.blue.country[i].vehicle.group
			--	print_message_to_user("country")
				for ig = 1,#mission.coalition.blue.country[i].ship.group do
				--	print_message_to_user("group")
					
					for iu = 1,#mission.coalition.blue.country[i].ship.group[ig].units do
			--
						local tacan = -1	
						local speed = mission.coalition.blue.country[i].ship.group[ig].route.points[1].speed
						for it = 1 ,#mission.coalition.blue.country[i].ship.group[ig].route.points	do
							
							for itt = 1,#mission.coalition.blue.country[i].ship.group[ig].route.points[it].task.params.tasks do
								if mission.coalition.blue.country[i].ship.group[ig].route.points[it].task.params.tasks[itt].params.action.id == "ActivateBeacon"	then
									tacan = mission.coalition.blue.country[i].ship.group[ig].route.points[it].task.params.tasks[itt].params.action.params.channel
								end		
							end					
							
						end
						
						if mission.coalition.blue.country[i].ship.group[ig].units[iu].type == "Stennis" then
							miz_carriers[#miz_carriers+1] = {
								type 	= mission.coalition.blue.country[i].ship.group[ig].units[iu].type,
								x 		= mission.coalition.blue.country[i].ship.group[ig].units[iu].x,
								z 		= mission.coalition.blue.country[i].ship.group[ig].units[iu].y,
								heading = mission.coalition.blue.country[i].ship.group[ig].units[iu].heading,
								tacan	= tacan,
								speed	= speed,
								act_x	= mission.coalition.blue.country[i].ship.group[ig].units[iu].x,
								act_z	= mission.coalition.blue.country[i].ship.group[ig].units[iu].y,
															}
						end	
						--print_message_to_user(tacan.." / "..speed)
					end
				
				end
				
			end
		end
---------------------------------------
		local num_red_countries = #mission.coalition.red.country
		for i = 1,num_red_countries do
			if mission.coalition.red.country[i].ship then
				--num_red_groups = num_red_groups + #mission.coalition.red.country[i].vehicle.group
			--	print_message_to_user("country")
				for ig = 1,#mission.coalition.red.country[i].ship.group do
				--	print_message_to_user("group")
					
					for iu = 1,#mission.coalition.red.country[i].ship.group[ig].units do
			--
						local tacan = -1	
						local speed = mission.coalition.red.country[i].ship.group[ig].route.points[1].speed
						for it = 1 ,#mission.coalition.red.country[i].ship.group[ig].route.points	do
							
							for itt = 1,#mission.coalition.red.country[i].ship.group[ig].route.points[it].task.params.tasks do
								if mission.coalition.red.country[i].ship.group[ig].route.points[it].task.params.tasks[itt].params.action.id == "ActivateBeacon"	then
									tacan = mission.coalition.red.country[i].ship.group[ig].route.points[it].task.params.tasks[itt].params.action.params.channel
								end		
							end					
							
						end
						
						if mission.coalition.red.country[i].ship.group[ig].units[iu].type == "Stennis" then
							miz_carriers[#miz_carriers+1] = {
								type 	= mission.coalition.red.country[i].ship.group[ig].units[iu].type,
								x 		= mission.coalition.red.country[i].ship.group[ig].units[iu].x,
								z 		= mission.coalition.red.country[i].ship.group[ig].units[iu].y,
								heading = mission.coalition.red.country[i].ship.group[ig].units[iu].heading,
								tacan	= tacan,
								speed	= speed,
								act_x	= mission.coalition.red.country[i].ship.group[ig].units[iu].x,
								act_z	= mission.coalition.red.country[i].ship.group[ig].units[iu].y,
															}
						end	
						--print_message_to_user(tacan.." / "..speed)
					end
				
				end
				
			end
		end






		
	end
	
	return miz_carriers
end


function get_actual_carrier_pos(id)
	local new_x,new_z
	--for i = 1,#miz_carriers do
		if miz_carriers[id].tacan ~= -1 then
			
			local act_travel_dist = model_time * miz_carriers[id].speed
				new_x,new_z =pnt_dir(	miz_carriers[id].x,
										miz_carriers[id].z,
										miz_carriers[id].heading,
										act_travel_dist)
										
		
							
										
		end										
	--end
return  new_x,new_z
end

function update_carrier_pos()
	local new_x,new_z
	for i = 1,#miz_carriers do
		if miz_carriers[i].tacan ~= -1 then
			
			local act_travel_dist = model_time * miz_carriers[i].speed
				new_x,new_z =pnt_dir(	miz_carriers[i].x,
										miz_carriers[i].z,
										miz_carriers[i].heading,
										act_travel_dist)
										
		
			miz_carriers[i].act_x = new_x
			miz_carriers[i].act_z = new_z			
										
		end										
	end

end


function update_carrier_ils()



	for i = 1,#miz_carriers do
		if miz_carriers[i].tacan ~= -1 then
	
			local tmp_offset = miz_carriers[i].heading + math.rad(270)
			if tmp_offset > math.rad(360) then tmp_offset = tmp_offset - math.rad(360) end		
			local new_x,new_z = pnt_dir(miz_carriers[i].act_x,miz_carriers[i].act_z,tmp_offset,20)

			--local ils_dir = miz_carriers[i].heading + math.rad(180)			--	-math.rad(9)		--DEGRESS?
			local ils_dir = math.deg(miz_carriers[i].heading) + 180 - 9
			--if ils_dir > math.rad(360) then ils_dir = ils_dir - math.rad(360) end		
			if ils_dir > 360 then ils_dir = ils_dir - 360 end		
			local ils_found = false
			for il = 1,#ils_loc do
				if ils_loc[il].name == miz_carriers[i].tacan .. "x" then
					ils_found = true
				--	print_message_to_user("foundols")
					ils_loc[il] = {
									name 	 = miz_carriers[i].tacan .."x",
									position = {x =new_x,-- miz_carriers[i].act_x,
												y = 21,
												z =new_z,-- miz_carriers[i].act_z,},
												},
									direction = ils_dir ,
									frequency = miz_carriers[i].tacan,
									}	

					ils_gs[il] = ils_loc[il]	
					
				--	local sensor_data = get_base_data()
				--	local lx, ly, lz = sensor_data.getSelfCoordinates()
				--	print_message_to_user(math.dist(lx,lz, new_x,new_z)) 	
				end
			end
			
			if ils_found == false then
				ils_loc[#ils_loc+1] = {
									name 	 = miz_carriers[i].tacan .."x",
									position = {x = miz_carriers[i].x,
												y = 21,
												z = miz_carriers[i].z,},
									direction = ils_dir ,
									frequency = miz_carriers[i].tacan,
									}	
				
				ils_gs[#ils_gs+1] = {
									name 	 = miz_carriers[i].tacan .."x",
									position = {x = miz_carriers[i].x,
												y = 21,
												z = miz_carriers[i].z,},
									direction = ils_dir ,
									frequency = miz_carriers[i].tacan,
									}					
			
			end
			
		end
	end	
	
	
end





function pnt_dir(pnt_x,pnt_z,angle_rad,distance)
	local new_x,new_z
	--angle_rad = angle_rad + 0
 
	if angle_rad < 0 then angle_rad = angle_rad + math.rad(360) end
		
	new_z = pnt_z + (distance * math.sin(angle_rad))
	new_x = pnt_x + (distance * math.cos(angle_rad))

	return new_x,new_z
end

function math.dist(x1,y1, x2,y2) 
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end





