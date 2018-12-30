dofile(LockOn_Options.script_path.."HUD/Indicator/definitions.lua")

--NOTE: the plane described by the 3 points instantiating this page (see device_init.lua and init.lua) is orthogonal to the reflector glass,
-- because the 'rotate_using_parameter' controller implicity rotates along Z axis. Therefore, everything defined on this page is
-- rotated 90 degrees along the Y axis to make it still face front (in effect, X and Z co-ords are swapped)

local SHOW_MASKS = false   -- tres interessant sur true

arc_sectors           = 16
arc_shift             = 200 -- y value of centrepoint of arc
arc_radius  	  	  = 304  -- radius of the arc at the top of the gunsight glass
half_width			  = arc_radius
down_border			  = -113  -- y value of left and right bottom corners

clip_mesh_verts    = {}
clip_mesh_indices  = {}
clip_mesh_verts[1] = { 0, arc_shift}
clip_mesh_verts[2] = { -half_width , down_border}
clip_mesh_verts[3] = { -half_width ,   arc_shift}

local ellipse_a = arc_radius
local ellipse_b = arc_radius  

-- define vertices for top half-circle
for i = 1,arc_sectors do
	local alpha        	   				  = math.pi - (math.pi/arc_sectors) * i;
    clip_mesh_verts[#clip_mesh_verts + 1] = {math.cos(alpha) * ellipse_a, math.sin(alpha) * ellipse_b + arc_shift}
end
clip_mesh_verts[#clip_mesh_verts + 1] = {  half_width , down_border}

-- define triangles for top half-circle and main rectangle
local number_of_triangles = #clip_mesh_verts - 1

for i = 1,number_of_triangles do

	clip_mesh_indices[3 * (i - 1)  + 1] = 0 -- all triangles anchor on midpoint of top half-circle
	clip_mesh_indices[3 * (i - 1)  + 2] = i
	if i < number_of_triangles then
		clip_mesh_indices[3 * (i - 1)  + 3] = i + 1
	else
		clip_mesh_indices[3 * (i - 1)  + 3] = 1
	end
	
end

clip_mesh_verts[#clip_mesh_verts + 1] = {  0 , down_border}
local bottom_anchor = #clip_mesh_verts - 1
clip_mesh_verts[#clip_mesh_verts + 1] = {  -half_width , down_border}
for i = 1,arc_sectors do
	local alpha        	   				  = math.pi - (math.pi/arc_sectors) * i;
    clip_mesh_verts[#clip_mesh_verts + 1] = {math.cos(alpha) * ellipse_a, - math.sin(alpha) * ellipse_b + down_border}
end

-- define triangles for bottom half-circle
local bottom_triangles = (#clip_mesh_verts - 1) - bottom_anchor - 1
for i = 1,bottom_triangles do
	clip_mesh_indices[#clip_mesh_indices+1] = bottom_anchor -- mid point of bottom half circle
	clip_mesh_indices[#clip_mesh_indices+1] = bottom_anchor + i
	clip_mesh_indices[#clip_mesh_indices+1] = bottom_anchor + i + 1
end

glass 			 	 = CreateElement "ceMeshPoly"
glass.name 			 = "glass"
glass.vertices 		 = clip_mesh_verts
glass.indices 		 = clip_mesh_indices
glass.init_pos		 = {0, 0, 0}
glass.init_rot		 = {0, 0, 0}
glass.material		 = "GUNSIGHT_GLASS"
glass.h_clip_relation = h_clip_relations.REWRITE_LEVEL
glass.level			 = HUD_NOCLIP_LEVEL
glass.isdraw		 = true
glass.change_opacity = false
glass.isvisible		 = SHOW_MASKS
Add(glass)



total_field_of_view = CreateElement "ceMeshPoly"
total_field_of_view.name = "total_field_of_view"
total_field_of_view.primitivetype = "triangles"

num_points = 32
step = math.rad(360.0/num_points)
TFOV  = 496
verts = {}
for i = 1, num_points do
    verts[i] = {TFOV * math.cos(i * step), TFOV * math.sin(i * step)}
end

total_field_of_view.vertices = verts

inds = {}
j = 0
for i = 0, 29 do
	j = j + 1
	inds[j] = 0
	j = j + 1
	inds[j] = i + 1
	j = j + 1
	inds[j] = i + 2
end

total_field_of_view.indices			= inds
total_field_of_view.init_pos		= {0, 0 --[[ -1100 --]] , 0}
total_field_of_view.material		= "DBG_RED"
total_field_of_view.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL
total_field_of_view.level			= HUD_DEFAULT_LEVEL - 1
total_field_of_view.change_opacity	= false
total_field_of_view.collimated 		= false
total_field_of_view.isvisible		= SHOW_MASKS
Add(total_field_of_view)
---------------------------------------------------------------------------

function texture_box (UL_X,UL_Y,W,H) --this is texture box function. Receives some coordinates and dimensions, returns 4 pairs of values. Nothing is calling this function inside script.
    local texture_size_x = 128
    local texture_size_y = 128
    local ux = UL_X / texture_size_x
    local uy = UL_Y / texture_size_y
    local w  = W / texture_size_x
    local h  = W / texture_size_y

    return {{ux	    ,uy},
    		{ux + w ,uy},
    		{ux + w ,uy + h},
    		{ux	 	,uy + h}}
end

function create_textured_box(UL_X,UL_Y,DR_X,DR_Y) -- function that creates textured square. This function is called 2 times in below code.
    local size_per_pixel = 4/6
    local texture_size_x = DR_X-UL_X --200
    local texture_size_y = DR_Y-UL_Y --200
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

gun_sight_mark 					= create_textured_box(-368,-368,368,368) -- this is create_textured_box function call with parameters
gun_sight_mark.material       	= "GUNSIGHT_TEXTURE"
gun_sight_mark.name 			= create_guid_string()
gun_sight_mark.init_pos         = {0, -1545, 0}
gun_sight_mark.init_rot		= {0, 0, 25}
gun_sight_mark.collimated	  	= true
gun_sight_mark.element_params = {"D_GUNSIGHT_REFLECTOR_ROT", "D_GUNSIGHT_DAYNIGHT", "D_GUNSIGHT_VISIBLE"}
gun_sight_mark.controllers = {
    {"move_up_down_using_parameter", 0, 0.095 },
    {"opacity_using_parameter",1},
    {"parameter_in_range", 2, 0.9, 1.1}
    }
gun_sight_mark.use_mipfilter    = true
gun_sight_mark.additive_alpha   = true
gun_sight_mark.h_clip_relation  = h_clip_relations.COMPARE
gun_sight_mark.level            = HUD_DEFAULT_LEVEL
Add(gun_sight_mark)
