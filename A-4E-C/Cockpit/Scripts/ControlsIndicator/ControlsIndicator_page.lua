dofile(LockOn_Options.common_script_path.."elements_defs.lua")
dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")

-- set color values are r, g, b, a, with a min-max of 0, 255
local draw_background           = MakeMaterial("arcade.tga", {255, 0, 0, 80})
local draw_percentile           = MakeMaterial("arcade.tga", {255, 0, 0, 32})
local draw_percentile_strong    = MakeMaterial("arcade.tga", {255, 0, 0, 128})
local draw_axis                 = MakeMaterial("arcade.tga", {255, 0, 0, 255})
local draw_hidden               = MakeMaterial("arcade.tga", {255, 0, 0, 0})
local draw_input                = MakeMaterial("arcade.tga", {255, 255, 0, 255})
local draw_indicator            = MakeMaterial("arcade.tga", {255, 0, 0, 255})
local draw_gear                 = MakeMaterial("arcade.tga", {255, 0, 0, 255})

local draw_on                   = MakeMaterial("arcade.tga", {128, 0, 0, 255})
local draw_off                  = MakeMaterial("arcade.tga", {255, 0, 0, 255})

SetCustomScale(1.0)

function AddElement(object)
	object.screenspace            = ScreenType.SCREENSPACE_TRUE
    object.use_mipfilter        = true
    Add(object)
end

local aspect                    = LockOn_Options.screen.aspect

local sizeX                     = 0.15
local sizeY                     = 0.2

local tex_scale                 = 0.25 / sizeX
local ds                        = 0.05 * sizeX
local line_width                = (4.5 / 512) / tex_scale

local throttle_offset           = 4.0 * ds
local rudder_offset             = 3.0 * ds

-- =============================
-- BACKGROUND
-- =============================

-- draw BACKGROUND
base       			                = CreateElement "ceMeshPoly"
base.name		                    = "base"
base.primitivetype              = "triangles"
base.material                   = draw_background
base.vertices                   = {
                                    {-(sizeX + throttle_offset + rudder_offset + 3.0 * line_width + ds), -sizeY},
                                    {-(sizeX + throttle_offset + rudder_offset + 3.0 * line_width + ds), sizeY}, 
                                    {sizeX + ds, sizeY},
                                    {sizeX + ds, -sizeY}
                                  }        
base.indices                    = default_box_indices
base.init_pos                   = {(-1 * aspect + 1.5 * sizeX),(1 - 1.3 * sizeX)}
base.element_params             = {"SHOW_CONTROLS"} 
base.controllers                = {{"parameter_in_range", 0, 1}}
base.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
base.level		                  = 8
AddElement(base)

-- =================================
-- AXES ands GRIDS
-- =================================

-- scale PITCH
pitch_scale                     = CreateElement "ceTexPoly"
pitch_scale.name		            = "pitch_scale"
pitch_scale.vertices            = {
                                    {-sizeX,-line_width},
                                    {-sizeX, line_width},
                                    {sizeX, line_width},
                                    {sizeX, -line_width}
                                  }
pitch_scale.indices		          = default_box_indices
pitch_scale.material	          = draw_axis
pitch_scale.init_rot            = {90, 0, 0}
pitch_scale.tex_params	        = {256 / 512, 176.5 / 512, 0.5 * tex_scale, 2 * tex_scale}
pitch_scale.parent_element      = base.name
AddElement(pitch_scale)

-- scale PITCH PERCENTILE grid
pitch_scale_p100                = Copy(pitch_scale)
pitch_scale_p100.vertices       = {
                                    {0, -0.5 * line_width},
                                    {0, 0.5 * line_width},
                                    {2.0 * sizeX, 0.5 * line_width},
                                    {2.0 * sizeX, -0.5 * line_width}
                                  }
pitch_scale_p100.init_pos       = {1.00 * sizeX, -sizeX}
pitch_scale_p100.material	      = draw_percentile_strong
AddElement(pitch_scale_p100)

pitch_scale_p075                = Copy(pitch_scale_p100)
pitch_scale_p075.init_pos       = {0.75 * sizeX, -sizeX}
pitch_scale_p075.material	      = draw_percentile
AddElement(pitch_scale_p075)

pitch_scale_p050                = Copy(pitch_scale_p100)
pitch_scale_p050.init_pos       = {0.50 * sizeX, -sizeX}
pitch_scale_p050.material	      = draw_percentile_strong
AddElement(pitch_scale_p050)

pitch_scale_p025                = Copy(pitch_scale_p100)
pitch_scale_p025.init_pos       = {0.25 * sizeX, -sizeX}
pitch_scale_p025.material	      = draw_percentile
AddElement(pitch_scale_p025)

pitch_scale_n100                = Copy(pitch_scale)
pitch_scale_n100.vertices       = {
                                    {0, -0.5 * line_width},
                                    {0, 0.5 * line_width},
                                    {2.0 * sizeX, 0.5 * line_width},
                                    {2.0 * sizeX, -0.5 * line_width}
                                  }
pitch_scale_n100.init_pos       = {-1.00 * sizeX, -sizeX}
pitch_scale_n100.material	      = draw_percentile_strong
AddElement(pitch_scale_n100)

pitch_scale_n075                = Copy(pitch_scale_n100)
pitch_scale_n075.init_pos       = {-0.75 * sizeX, -sizeX}
pitch_scale_n075.material	      = draw_percentile
AddElement(pitch_scale_n075)

pitch_scale_n050                = Copy(pitch_scale_n100)
pitch_scale_n050.init_pos       = {-0.50 * sizeX, -sizeX}
pitch_scale_p100.material	      = draw_percentile_strong
AddElement(pitch_scale_n050)

pitch_scale_n025                = Copy(pitch_scale_n100)
pitch_scale_n025.init_pos       = {-0.25 * sizeX, -sizeX}
pitch_scale_n025.material	      = draw_percentile
AddElement(pitch_scale_n025)

-- scale ROLL
roll_scale                      = CreateElement "ceTexPoly"
roll_scale.name		              = "roll_scale"
roll_scale.vertices             = {
                                    {-sizeX, -line_width},
                                    {-sizeX, line_width},
                                    {sizeX, line_width},
                                    {sizeX, -line_width}
                                  }
roll_scale.indices		          = default_box_indices
roll_scale.material	            = draw_axis
roll_scale.tex_params	          = {256 / 512, 176.5 / 512, tex_scale, 2 * tex_scale}
roll_scale.parent_element       = base.name
AddElement(roll_scale)

local stick_index_sz            = 0.1 * sizeX

-- scale ROLL PERCENTILE grid
roll_scale_n100                 = Copy(roll_scale)
roll_scale_n100.vertices        = {
                                    {-sizeX, -0.5 * line_width},
                                    {-sizeX, 0.5 * line_width},
                                    {sizeX, 0.5 * line_width},
                                    {sizeX, -0.5 * line_width}
                                  }
roll_scale_n100.init_pos        = {0, -(1.00 * sizeX)}
roll_scale_n100.material	      = draw_percentile_strong
AddElement(roll_scale_n100)

roll_scale_n075                 = Copy(roll_scale_n100)
roll_scale_n075.init_pos        = {0, -(0.75 * sizeX)}
roll_scale_n075.material	      = draw_percentile
AddElement(roll_scale_n075)

roll_scale_n050                 = Copy(roll_scale_n100)
roll_scale_n050.init_pos        = {0, -(0.50 * sizeX)}
roll_scale_n050.material	      = draw_percentile_strong
AddElement(roll_scale_n050)

roll_scale_n025                 = Copy(roll_scale_n100)
roll_scale_n025.init_pos        = {0, -(0.25 * sizeX)}
roll_scale_n025.material	      = draw_percentile
AddElement(roll_scale_n025)

roll_scale_p100                 = Copy(roll_scale)
roll_scale_p100.vertices        = {
                                    {-sizeX, -0.5 * line_width},
                                    {-sizeX, 0.5 * line_width},
                                    {sizeX, 0.5 * line_width},
                                    {sizeX, -0.5 * line_width}
                                  }
roll_scale_p100.init_pos        = {0, (1.00 * sizeX)}
roll_scale_p100.material	      = draw_percentile_strong
AddElement(roll_scale_p100)

roll_scale_p075                 = Copy(roll_scale_p100)
roll_scale_p075.init_pos        = {0, (0.75 * sizeX)}
roll_scale_p075.material	      = draw_percentile
AddElement(roll_scale_p075)

roll_scale_p050                 = Copy(roll_scale_p100)
roll_scale_p050.init_pos        = {0, (0.50 * sizeX)}
roll_scale_p050.material	      = draw_percentile_strong
AddElement(roll_scale_p050)

roll_scale_p025                 = Copy(roll_scale_p100)
roll_scale_p025.init_pos        = {0, (0.25 * sizeX)}
roll_scale_p025.material	      = draw_percentile
AddElement(roll_scale_p025)

-- scale THROTTLE position
throttle_scale                  = Copy(pitch_scale)
throttle_scale.vertices         = {
                                    {0, -line_width},
                                    {0, line_width},
                                    {2.0 * sizeX, line_width},
                                    {2.0 * sizeX, -line_width}
                                  }
throttle_scale.init_pos         = {-(sizeX + throttle_offset), -sizeX}
AddElement(throttle_scale)

-- scale WHEELBRAKE LEFT position
wbrakel_scale                   = Copy(pitch_scale)
wbrakel_scale.vertices          = {
                                    {0.0, -line_width},
                                    {0.0, line_width},
                                    {2.0 * sizeX, line_width},
                                    {2.0 * sizeX, -line_width}
                                  }
wbrakel_scale.init_pos          = {-0.5 * sizeX, -sizeX}
wbrakel_scale.material          = draw_hidden
AddElement(wbrakel_scale)

-- scale WHEELBRAKE RIGHT position
wbraker_scale                   = Copy(wbrakel_scale)
wbraker_scale.init_pos          = {0.5 * sizeX, -sizeX}
AddElement(wbraker_scale)

-- =============================
-- INDICATORS
-- =============================

-- draw GEAR NOSE position
gearc_index                     = Copy(roll_scale)
gearc_index.vertices            = {
                                    {-4.0 * line_width, -5.0 * line_width},
                                    {-4.0 * line_width, 5.0 * line_width},
                                    {4.0 * line_width, 5.0 * line_width},
                                    {4.0 * line_width, -5.0 * line_width}
                                  }
gearc_index.element_params      = {"FM_GEAR_NOSE"}
gearc_index.controllers         = {{"move_up_down_using_parameter", sizeX, sizeX}}
gearc_index.tex_params	        = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
gearc_index.init_rot            = {-90, 0, 0}
gearc_index.material            = draw_gear
gearc_index.parent_element      = pitch_scale.name
AddElement(gearc_index)

-- draw GEAR LEFT position
gearl_index                     = Copy(gearc_index)
gearl_index.element_params      = {"FM_GEAR_LEFT"}
gearl_index.init_pos            = {0, (0.50 * sizeX)}
gearl_index.controllers         = {{"move_up_down_using_parameter", -sizeX, -sizeX}}
AddElement(gearl_index)

-- draw GEAR RIGHT position
gearr_index                     = Copy(gearc_index)
gearr_index.element_params      = {"FM_GEAR_RIGHT"}
gearr_index.init_pos            = {0, -(0.50 * sizeX)}
gearr_index.controllers         = {{"move_up_down_using_parameter", -sizeX, -sizeX}}
AddElement(gearr_index)

-- draw SLAT LEFT position
slatl_index                     = Copy(roll_scale)
slatl_index.vertices            = {
                                    {-1.5 * line_width, -2.0 * line_width},
                                    {-1.5 * line_width, 2.0 * line_width},
                                    {1.5 * line_width, 2.0 * line_width},
                                    {1.5 * line_width, -2.0 * line_width}
                                  }
slatl_index.element_params      = {"FM_SLAT_LEFT"}
slatl_index.init_pos            = {-sizeX, sizeX}
slatl_index.controllers         = {{"move_up_down_using_parameter", 0, 2.0 * sizeX}}
slatl_index.tex_params	        = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
slatl_index.init_rot            = {-90, 0, 0}
slatl_index.material            = draw_gear
slatl_index.parent_element      = pitch_scale.name
AddElement(slatl_index)

-- draw SLAT RIGHT position
slatr_index                     = Copy(slatl_index)
slatr_index.element_params      = {"FM_SLAT_RIGHT"}
slatr_index.init_pos            = {-sizeX, -sizeX}
AddElement(slatr_index)

-- draw GEAR NOSE position
gearc_index                     = Copy(roll_scale)
gearc_index.vertices            = {
                                  {-4.0 * line_width, -5.0 * line_width},
                                  {-4.0 * line_width, 5.0 * line_width},
                                  {4.0 * line_width, 5.0 * line_width},
                                  {4.0 * line_width, -5.0 * line_width}
                                  }
gearc_index.element_params      = {"FM_GEAR_NOSE"}
gearc_index.controllers         = {{"move_up_down_using_parameter", sizeX, sizeX}}
gearc_index.tex_params	        = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
gearc_index.init_rot            = {-90, 0, 0}
gearc_index.material            = draw_gear
gearc_index.parent_element      = pitch_scale.name
AddElement(gearc_index)

-- draw FLAPS position
flaps_index                     = Copy(roll_scale)
flaps_index.vertices            = {
                                    {-sizeX, -0.5 * line_width},
                                    {-sizeX, 0.5 * line_width},
                                    {sizeX, 0.5 * line_width},
                                    {sizeX, -0.5 * line_width}
                                  }
flaps_index.element_params      = {"FM_FLAPS"}
flaps_index.controllers         = {{"move_up_down_using_parameter", 0, -sizeX}}
flaps_index.tex_params	        = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
flaps_index.init_rot            = {-90, 0, 0}
flaps_index.material            = draw_indicator
flaps_index.parent_element      = pitch_scale.name
AddElement(flaps_index)

-- draw SPOILER position
spoiler_index                   = Copy(pitch_scale)
spoiler_index.vertices          = {
                                    {-sizeX, -0.5 * line_width},
                                    {-sizeX, 0.5 * line_width},
                                    {sizeX, 0.5 * line_width},
                                    {sizeX, -0.5 * line_width}
                                  }
spoiler_index.element_params    = {"FM_SPOILERS"}  
spoiler_index.controllers       = {{"move_up_down_using_parameter", 0, sizeX}}
spoiler_index.tex_params	      = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
spoiler_index.init_rot          = {-90, 0, 0}
spoiler_index.material          = draw_indicator
spoiler_index.parent_element    = pitch_scale.name
AddElement(spoiler_index)

-- draw AIRBRAKE1 position
abrake1_index                   = Copy(roll_scale)
abrake1_index.vertices          = {
                                    {-sizeX, -0.5 * line_width},
                                    {-sizeX, 0.5 * line_width},
                                    {sizeX, 0.5 * line_width},
                                    {sizeX, -0.5 * line_width}
                                  }
abrake1_index.element_params    = {"FM_BRAKES"}
abrake1_index.controllers       = {{"move_up_down_using_parameter", 0, sizeX}}
abrake1_index.tex_params	      = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
abrake1_index.init_rot          = {-90, 0, 0}
abrake1_index.material          = draw_indicator
abrake1_index.parent_element    = roll_scale.name
AddElement(abrake1_index)

-- draw AIRBRAKE2 position
abrake2_index                   = Copy(abrake1_index)
abrake2_index.controllers       = {{"move_up_down_using_parameter", 0, -sizeX}}
AddElement(abrake2_index)

-- draw RPM position
rpm_index                       = Copy(roll_scale)
rpm_index.vertices              = {
                                    {-4.0 * line_width, -5.0 * line_width},
                                    {-4.0 * line_width, 5.0 * line_width},
                                    {4.0 * line_width, 5.0 * line_width},
                                    {4.0 * line_width, -5.0 * line_width}
                                  }
rpm_index.element_params        = {"RPM"}
rpm_index.controllers           = {{"move_up_down_using_parameter", 0, sizeX / 50}}
rpm_index.tex_params	          = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
rpm_index.init_rot              = {-90, 0, 0}
rpm_index.material              = draw_indicator
rpm_index.parent_element        = throttle_scale.name
AddElement(rpm_index)

-- =============================
-- INPUT INDICATORS
-- =============================

-- scale RUDDER
rudder_scale                    = Copy(roll_scale)
rudder_scale.init_pos           = {0,-(sizeX + rudder_offset)}
AddElement(rudder_scale)

-- draw RUDDER position
rudder_index                    = Copy(roll_scale)
rudder_index.vertices           = {
                                    {-2.0 * line_width, -line_width},
                                    {-2.0 * line_width, line_width},
                                    {2.0 * line_width, line_width},
                                    {2.0 * line_width, -line_width}
                                  }
rudder_index.element_params     = {"RUDDER_PEDALS"}  
rudder_index.controllers 	      = {{"move_up_down_using_parameter", 0, -sizeX}}
rudder_index.init_rot           = {90, 0}
rudder_index.parent_element     = rudder_scale.name
rudder_index.tex_params	        = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
rudder_index.material	          = draw_input
AddElement(rudder_index)

-- draw THROTTLE position
throttle_index                  = Copy(roll_scale)
throttle_index.vertices         = {
                                    {-2.0 * line_width, -line_width},
                                    {-2.0 * line_width, line_width},
                                    {2.0 * line_width, line_width},
                                    {2.0 * line_width, -line_width}
                                  }
throttle_index.element_params   = {"FM_THROTTLE_POSITION"}  
throttle_index.controllers      = {{"move_up_down_using_parameter", 0, 2.0 * sizeX}}
throttle_index.tex_params	      = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
throttle_index.init_rot         = {-90, 0, 0}
throttle_index.material         = draw_input
throttle_index.parent_element   = throttle_scale.name
AddElement(throttle_index)

-- draw WHEELBRAKE LEFT position
wbrakel_index                   = Copy(roll_scale)
wbrakel_index.vertices          = {
                                    {-2.0 * line_width, -line_width},
                                    {-2.0 * line_width, line_width},
                                    {2.0 * line_width, line_width},
                                    {2.0 * line_width, -line_width}
                                  }
wbrakel_index.element_params    = {"LEFT_BRAKE_PEDAL"}  
wbrakel_index.controllers       = {{"move_up_down_using_parameter", 0, 2.0 * sizeX}}
wbrakel_index.tex_params	      = {256 / 512, 176.5 / 512, 0.5 * tex_scale / 3, 2 * tex_scale / 3}
wbrakel_index.init_rot          = {-90, 0, 0}
wbrakel_index.material          = draw_input
wbrakel_index.parent_element    = wbrakel_scale.name
AddElement(wbrakel_index)

-- draw WHEELBRAKE RIGHT position
wbraker_index                   = Copy(wbrakel_index)
wbraker_index.element_params    = {"RIGHT_BRAKE_PEDAL"}  
wbraker_index.parent_element    = wbraker_scale.name
AddElement(wbraker_index)

-- draw NOSEWHEEL STEERING status
nws_index                     = Copy(roll_scale)
nws_index.vertices            = {
                                  {-2.25 * ds, -2.25 * ds},
                                  {-2.25 * ds, 2.25 * ds},
                                  {2.25 * ds, 2.25 * ds},
                                  {2.25 * ds, -2.25 * ds}
                                }
nws_index.element_params      = {"FM_NWS"}
nws_index.init_pos            = {-3.0 * sizeX, sizeX}
nws_index.controllers         = {{"move_up_down_using_parameter", 0, 3.0 * sizeX}}
nws_index.tex_params	        = {179.5 / 512, 256.5 / 512, 3 * tex_scale, 3 * tex_scale}
nws_index.init_rot            = {-90, 0, 0}
nws_index.material            = draw_input
nws_index.parent_element      = base.name
AddElement(nws_index)

-- draw PITCH AND ROLL (STICK) position
stick_position					        = CreateElement "ceTexPoly"
stick_position.name             = "stick_position"
stick_position.vertices         = {
                                    {-stick_index_sz, -stick_index_sz},
                                    {-stick_index_sz, stick_index_sz},
                                    {stick_index_sz, stick_index_sz},
                                    {stick_index_sz, -stick_index_sz}
                                  }
stick_position.indices          = default_box_indices
stick_position.material	        = draw_input
stick_position.tex_params	      = {330 / 512, 365.5 / 512, 2 * tex_scale, 2 * tex_scale / 0.8}
stick_position.element_params   = {"STICK_PITCH", "STICK_ROLL"} 
stick_position.controllers      = {
                                    {"move_left_right_using_parameter", 1, sizeX},
								                    {"move_up_down_using_parameter", 0, -sizeX}
                                  }
stick_position.parent_element   = base.name
AddElement(stick_position)
