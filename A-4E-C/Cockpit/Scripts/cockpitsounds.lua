--[[
sndhost_left_fwd_console = create_sound_host("COCKPIT_CLICKS","3D", 0.5,-0.2,-0.5)
sndhost_left_mid_console = create_sound_host("COCKPIT_CLICKS","3D", 0,-0.2,-0.5)
sndhost_left_aft_console = create_sound_host("COCKPIT_CLICKS","3D", -0.5,-0.2,-0.5)
sndhost_right_fwd_console = create_sound_host("COCKPIT_CLICKS","3D", 0.5,-0.2,0.5)
sndhost_right_mid_console = create_sound_host("COCKPIT_CLICKS","3D", 0,-0.2,0.5)
sndhost_right_aft_console = create_sound_host("COCKPIT_CLICKS","3D", -0.5,-0.2,0.5)
sndhost_mid_fwd_console = create_sound_host("COCKPIT_CLICKS","3D", 0.5,0.0,0.0)


toggleclick_left_fwd = sndhost_left_fwd_console:create_sound("toggleclick")
toggleclick_left_mid = sndhost_left_mid_console:create_sound("toggleclick")
toggleclick_left_aft = sndhost_left_aft_console:create_sound("toggleclick")
toggleclick_right_fwd = sndhost_right_fwd_console:create_sound("toggleclick")
toggleclick_right_mid = sndhost_right_mid_console:create_sound("toggleclick")
toggleclick_right_aft = sndhost_right_aft_console:create_sound("toggleclick")
toggleclick_mid_fwd = sndhost_mid_fwd_console:create_sound("toggleclick")
--]]

sndhost_3D = create_sound_host("COCKPIT_CLICKS","3D")

toggleclick_left_fwd = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_lf")
toggleclick_left_mid = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_lm")
toggleclick_left_aft = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_la")
toggleclick_right_fwd = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_rf")
toggleclick_right_mid = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_rm")
toggleclick_right_aft = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_ra")
toggleclick_mid_fwd = sndhost_3D:create_sound("Aircrafts/A-4E-C/toggleclick_mf")

knobclick_left_fwd = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_lf")
knobclick_left_mid = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_lm")
knobclick_left_aft = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_la")
knobclick_right_fwd = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_rf")
knobclick_right_mid = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_rm")
knobclick_right_aft = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_ra")
knobclick_mid_fwd = sndhost_3D:create_sound("Aircrafts/A-4E-C/knob_mf")
