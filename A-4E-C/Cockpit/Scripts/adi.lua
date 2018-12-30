-- ADI (IKP-81)

pitch_bias					= {{-math.rad(90.0), math.rad(90.0), math.rad(0.3)}} -- radians
pitch_min					= -math.rad(90.0)
pitch_max					= math.rad(90.0)
pitch_maxw					= math.rad(80.0) -- rad/sec
pitch_K1_operating			= 3.7
pitch_K2_operating			= 0.73
pitch_K1_nonoperating		= 3.7
pitch_K2_nonoperating		= 0.73

bank_bias					= {{0.0, math.rad(360.0), math.rad(0.5)}} -- radians
bank_min					= 0.0
bank_max					= math.rad(360.0)
bank_K1						= 6.5
bank_K2						= 1.0

warn_flag_d_value			= 11.0
warn_flag_value_min			= 0.0
warn_flag_value_max			= 1.0

deviation_bias				= {{-1.0, 1.0, 0.1}}
deviation_min				= -1.0
deviation_max				= 1.0
deviation_K1				= 0.9
deviation_K2				= 0.5


gauges = 
{
	pitch =
	{
		arg_number							= 109,
		input								= {-math.pi / 2.0, math.pi / 2.0},
		output								= {-0.447, 0.447},
	},
	bank = 
	{
		arg_number								= 108,
		input									= { 0, 2 * math.pi},
		output									= {-1.0,1.0},
	},
	slipball = 
	{
		arg_number								= 31,
		input									= {-1, 1},
		output									= { 1,-1},
	}
}


need_to_be_closed = true -- lua_state  will be closed in post_initialize()
