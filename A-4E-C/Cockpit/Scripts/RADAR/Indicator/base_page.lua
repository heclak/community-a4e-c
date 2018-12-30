dofile(LockOn_Options.script_path.."RADAR/Indicator/definitions.lua")

local SHOW_MASKS = true

total_field_of_view 				= CreateElement "ceMeshPoly"
total_field_of_view.name 			= "total_field_of_view"
total_field_of_view.primitivetype 	= "triangles"
total_field_of_view.vertices 		=  {{-1,1},{1,1},{1,-1},{-1,-1}}
total_field_of_view.indices			=  {0,1,2,0,2,3}
total_field_of_view.init_pos		= {0, 0, z_offset}
total_field_of_view.material		= "RADAR_FOV"
total_field_of_view.h_clip_relation = h_clip_relations.REWRITE_LEVEL
total_field_of_view.level			= RADAR_DEFAULT_LEVEL
total_field_of_view.change_opacity	= false
total_field_of_view.collimated 		= false
total_field_of_view.isvisible		= SHOW_MASKS
Add(total_field_of_view)