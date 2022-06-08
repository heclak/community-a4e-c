VR_capture = 
{
	stick = 
	{
		range_roll   = math.rad(20.0),
		range_pitch  = math.rad(15.0),
		
		left_turn = {0,0,0},
		left_shift = {-0.07,0.04,-0.01},
		
		right_turn = {0,0,180},
		right_shift = {-0.07,-0.04,-0.01},

		--grip_class = 2,
	},
	throttle = 
	{
		arg = 80,
		connector = "THROTTLE_L_HANDLE",

		left_turn = {-20,0,90},
		left_shift = {-0.09,0.0,0.02},
		
		right_turn = {-20,0,90},
		right_shift = {-0.09,0.0,0.02},
	}
}