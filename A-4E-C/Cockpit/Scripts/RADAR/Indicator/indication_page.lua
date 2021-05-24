dofile(LockOn_Options.script_path.."RADAR/Indicator/definitions.lua")


yscale=0.8527
xscale=0.8527

function AddGrid(dx,dy,rows,cols)
	local rows          = rows or 1
	local cols          = cols or 1
	
	local sz_x          = cols * dx * xscale
	local sz_y          = rows * dy * yscale
	
	local verts       = {{0,0},
						 {sz_x,0},
						 {sz_x,sz_y},
						 {0,sz_y}}
	local indices     = {0,1,2,2,3,0}
	
	for j = 1,cols do
		verts[#verts + 1] =  {dx*j*xscale ,   0}	indices[#indices + 1] = #verts - 1
		verts[#verts + 1] =  {dx*j*xscale ,sz_y}	indices[#indices + 1] = #verts - 1
	end
	
	for i = 1,rows do
		verts[#verts + 1] =  {0   ,dy*i*yscale}	indices[#indices + 1] = #verts - 1
		verts[#verts + 1] =  {sz_x,dy*i*yscale}	indices[#indices + 1] = #verts - 1
	end

	grid			    = CreateElement "ceMeshPoly"
	grid.name 		    = create_guid_string()
	grid.material	    = "RADAR_GRID"
	grid.primitivetype  = "lines"	
	grid.vertices       = verts
	grid.indices	    = indices
	grid.init_pos		= {-0.5 * sz_x , -0.5 * sz_y, z_offset}

    grid.element_params = {"RADAR_GRID_OP"}
    grid.controllers = {
        {"opacity_using_parameter", 0},
    }

	Add(grid)
	return grid
end

--AddGrid(0.4,0.4,5,5)

local meter2feet = 3.28084
local nm2meter = 1852
function add_1000ft_profile_scribe(max_range_nm)
    verts={}
    indices={}

    start_angle=math.deg(math.asin((-1000/meter2feet)/(max_range_nm*nm2meter)))
    verts[#verts + 1] = {1*xscale, (-1+2*((start_angle+15)/25))*yscale}
    indices[#indices + 1]=#verts-1

    start_angle=(math.floor(start_angle*10))/10
    start_distance=(-1000/meter2feet)/math.sin(math.rad(start_angle))
    if start_distance>(max_range_nm*nm2meter) then
        start_distance=max_range_nm*nm2meter
    end
    verts[#verts + 1] = {(-1+2*(start_distance/(max_range_nm*nm2meter)))*xscale, (-1+2*((start_angle+15)/25))*yscale}
    indices[#indices + 1]=#verts-1
    indices[#indices + 1]=#verts-1
    for r=start_angle,-15,-0.1 do
        dist=(-1000/meter2feet)/math.sin(math.rad(r))
        verts[#verts + 1] = {(-1+2*(dist/(max_range_nm*nm2meter)))*xscale, (-1+2*((r+15)/25))*yscale}
        indices[#indices + 1]=#verts-1
        indices[#indices + 1]=#verts-1
    end
    indices[#indices + 1]=#verts-1
    scribe = CreateElement "ceSimpleLineObject"
    scribe.name = create_guid_string()
    scribe.material = "RADAR_SCRIBE"
    scribe.vertices = verts
    scribe.indices = indices
    scribe.width = 0.01
    scribe.init_pos = {0, 0, z_offset}
    scribe.element_params = {"RADAR_PROFILE_SCRIBE_"..tostring(max_range_nm).."NM","RADAR_FILTER"}
    scribe.controllers = {
        {"opacity_using_parameter", 0},
        {"change_color_when_parameter_equal_to_number", 1, 1, 0.66, 0.22, 0.0},
    }
    scribe.additive_alpha   = true

	Add(scribe)
	return scribe
end
add_1000ft_profile_scribe(10)
add_1000ft_profile_scribe(20)

function create_textured_box(UL_X,UL_Y,DR_X,DR_Y)
    local size_per_pixel = 1
    local texture_size_x = DR_X-UL_X
    local texture_size_y = DR_Y-UL_Y
    local W = DR_X - UL_X
    local H = DR_Y - UL_Y

    local half_x = 0.5 * W * size_per_pixel
    local half_y = 0.5 * H * size_per_pixel
    local ux 	 = UL_X / texture_size_x
    local uy 	 = UL_Y / texture_size_y
    local w  	 = W / texture_size_x
    local h 	 = H / texture_size_y

    local object = CreateElement "ceTexPoly"
    object.vertices =  {{-half_x, half_y},
    				    { half_x, half_y},
    				    { half_x,-half_y},
    				    { -half_x,-half_y}}
    object.indices	  = {0,1,2,2,3,0}
    object.tex_coords = {{ux -w/2    ,uy-h/2},
    					 {ux + w/2 ,uy-h/2},
    					 {ux + w/2 ,uy + h/2},
    				     {ux-w/2 	 ,uy + h/2}}

    return object
end

max_blobs=2500

for i=1,max_blobs do
    radar_blob 					= create_textured_box(-blob_scale/2,-blob_scale/2,blob_scale/2,blob_scale/2)
    radar_blob.material       	= "BLOB_TEXTURE"
    radar_blob.name 			= create_guid_string()
    --radar_blob.init_pos         = {-1+(i%20)*0.1, -1+math.floor(i/20)*0.1, z_offset}
    radar_blob.init_pos         = {0, 0, z_offset}
    radar_blob.init_rot		= {0, 0, 0}
    radar_blob.collimated	  	= false

    radar_blob.element_params = {"RADAR_BLOB_"..tostring(i).."_UD", "RADAR_BLOB_"..tostring(i).."_LR", "RADAR_BLOB_"..tostring(i).."_OP","RADAR_FILTER"}
    radar_blob.controllers = {
        {"move_up_down_using_parameter", 0, 0.0383},
        {"move_left_right_using_parameter", 1, 0.0383},
        {"opacity_using_parameter",2},
        {"change_color_when_parameter_equal_to_number", 3, 1, 0.66, 0.22, 0.0},
    }

    radar_blob.use_mipfilter    = true
    radar_blob.additive_alpha   = true
    radar_blob.h_clip_relation  = h_clip_relations.COMPARE
    radar_blob.level			= RADAR_DEFAULT_LEVEL

    Add(radar_blob)
end

dofile(LockOn_Options.script_path.."Systems/radar_scope_api.lua")

local max=math.floor(math.sqrt(max_blobs))
for i=1,max_blobs do
    set_blob(i,-1+(i%max)*(2/max), -1+math.floor(i/max)*(2/max), 0.0)
end
set_profile_scribe(0)

--[[
blob_op_params[50]:set(1)

blob_op_params[71]:set(1)
blob_ud_params[71]:set(0.05)

blob_op_params[92]:set(1)
blob_lr_params[92]:set(-0.05)
--]]