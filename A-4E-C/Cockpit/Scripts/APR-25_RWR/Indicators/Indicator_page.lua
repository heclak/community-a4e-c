dofile(LockOn_Options.common_script_path.."elements_defs.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

-- set color values are r, g, b, a, with a min-max of 0, 255
local draw_background           = MakeMaterial("arcade.tga", {2, 24, 1, 255})
local draw_strength             = MakeMaterial("arcade.tga", {48, 64, 32, 255})
-- materials.lua has the contact colour

local draw_on                   = MakeMaterial("arcade.tga", {128, 0, 0, 255})
local draw_off                  = MakeMaterial("arcade.tga", {255, 0, 0, 255})

SetCustomScale(1.0)

function AddElement(object)
	--object.screenspace            = ScreenType.SCREENSPACE_TRUE
  object.use_mipfilter        = true
  Add(object)
end

local aspect                    = LockOn_Options.screen.aspect

local radius                     = 0.035

local tex_scale                 = 0.25 / radius
local ds                        = 0.05 * radius
local line_width                = (4.5 / 512) / tex_scale

local throttle_offset           = 5.0 * ds
local rudder_offset             = 3.0 * ds

local stick_index_sz            = 0.1 * radius

-- =============================
-- BACKGROUND
-- =============================

-- draw BACKGROUND
base       			                = CreateElement("ceMeshPoly")
base.name		                    = "base"
base.primitivetype              = "triangles"
base.material                   = draw_background   
base.init_pos                   = {0.0, 0.0, 0.0}--{-1 * aspect + 1.1 * radius, 1 - 1.1 * radius}
base.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
base.level		                  = 8
set_circle(base, radius, nil)
AddElement(base)

inner       			              = CreateElement("ceMeshPoly")
inner.name		                  = "inner"
inner.primitivetype             = "triangles"
inner.material                  = draw_strength   
inner.init_pos                  = {0.0, 0.0, 0.0}
inner.h_clip_relation           = h_clip_relations.COMPARE
inner.level		                  = 8
inner.parent_element            = base.name
set_circle(inner, radius * 0.2, radius * 0.2 - radius * 0.01)
AddElement(inner)

middle       			              = CreateElement("ceMeshPoly")
middle.name		                  = "inner"
middle.primitivetype             = "triangles"
middle.material                  = draw_strength   
middle.init_pos                  = {0.0, 0.0}
middle.h_clip_relation           = h_clip_relations.COMPARE
middle.level		                  = 8
middle.parent_element            = base.name
set_circle(middle, radius * 0.4, radius * 0.4 - radius * 0.01)
AddElement(middle)

outer       			              = CreateElement("ceMeshPoly")
outer.name		                  = "inner"
outer.primitivetype             = "triangles"
outer.material                  = draw_strength   
outer.init_pos                  = {0.0, 0.0}
outer.h_clip_relation           = h_clip_relations.COMPARE
outer.level		                  = 8
outer.parent_element            = base.name
set_circle(outer, radius * 0.6, radius * 0.6 - radius * 0.01)
AddElement(outer)


--[[
line = CreateElement("ceSMultiLine")
line.name = create_guid_string()
line.material = "RADAR_SCRIBE"
line.init_pos = {0.0, 0.0}
line.init_rot = 0
line.level = 8
line.parent_element = base.name
line.vertices = {{0,0}, {0, 1}}
line.indices = {0,1}
line.width = 0.01
line.additive_alpha = true
line.h_clip_relation           = h_clip_relations.COMPARE
AddElement(line)
]]--


function get_line_vertices(length, dashed_length, gap_length)
  
end


for i = 1,100 do

  local line = CreateElement("ceSimpleLineObject")
  line.name = create_guid_string()
  line.material = "RWR_CONTACT"
  line.init_pos = {0.0, 0.0}
  line.init_rot = 0
  line.level = 8
  line.parent_element = base.name
  line.vertices = {{0,0}, {0, radius}}
  line.indices = {0,1}
  line.width = 0.0005
  line.additive_alpha = true
  line.h_clip_relation           = h_clip_relations.COMPARE

  
  --line.element_params = {
  --  "RWR_LINE_X1_"..tostring(i), 
  --  "RWR_LINE_Y1_"..tostring(i), 
  --  "RWR_LINE_X2_"..tostring(i), 
  --  "RWR_LINE_Y2_"..tostring(i),
  --}


  line.element_params = {
    "RWR_LINE_X1_"..tostring(i), "RWR_LINE_Y1_"..tostring(i),
    "RWR_LINE_X2_"..tostring(i), "RWR_LINE_Y2_"..tostring(i),
  }
  line.controllers = {
    {"line_object_set_point_using_parameters", 0, 0, 1, 1, 1},
    {"line_object_set_point_using_parameters", 1, 2, 3, 1, 1},
  }
  

  AddElement(line)

  --[[
  local line = CreateElement("ceSimpleLineObject")
  line.name = create_guid_string()
  line.material = "RADAR_SCRIBE"
  line.init_pos = {0.0, 0.0}
  line.init_rot = 0
  line.parent_element = base.name
  line.vertices = {{0,0}, {0, radius}}
  line.indices = {0,1}
  line.width = 0.01

  line.element_params = {"RWR_LINE_"..tostring(i).."VISIBLE", "RWR_LINE_X_"..tostring(i), "RWR_LINE_Y_"..tostring(i)}
  line.controllers = {
    {"line_object_set_point_using_parameters", 1, 1, 2, 0.1, 0.1},
  }
  line.additive_alpha = true
  line.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
  line.level = 9

  AddElement(line)
  ]]

end