--EDITING THIS FILE WILL CAUSE THE EFM TO FAIL.
--NOSEGEAR
nose_amortizer_min_length 					= 0.00
nose_amortizer_max_length 					= 0.25 --0.32
nose_amortizer_basic_length 				= 0.25
nose_amortizer_reduce_length 				= 0.01


nose_amortizer_spring_force_factor 			= 3.0e+06
nose_amortizer_spring_force_factor_rate 	= 2.0

--nose_amortizer_static_force = 5e+4
nose_amortizer_static_force 				= 5256.0 * 9.81 * 0.2
nose_damper_force 							= 2.0e+4
nose_amortizer_direct_damper_force_factor 	=  nose_damper_force * 0.75
nose_amortizer_back_damper_force_factor 	=  nose_damper_force

nose_wheel_moment_of_inertia 				= 0.6

--Absolutely no idea what these do but they might be helpful, turns out it breaks everything.
--nose_wheel_kz_factor					= 0.52,
--nose_noise_k							= 0.4,

--MAINGEAR2
main_amortizer_min_length 					= 0.00
main_amortizer_max_length 					= 0.67 --0.7
main_amortizer_basic_length 				= 0.67 --0.7
--This is the length over which the amortizer will reduce. Smaller values mean higher ride height, larger values lower ride height.
main_amortizer_reduce_length 				= 28.0  --yes you read that right, 28 metres.

-- F = kx^y, where x is the displacement from the default position (determined by the reduce length)
--This is k in the above equation
main_amortizer_spring_force_factor 			= 7.0e+7
--This is y in the above equation
main_amortizer_spring_force_factor_rate 	= 3.5

--A static force that is there for countering gravity.
main_amortizer_static_force 				= 5256.0 * 9.81 * 1.08

main_damper_force 							= 7.0e+4 --3e+4
main_amortizer_direct_damper_force_factor 	= main_damper_force * 0.75 --Damping force in the compress direction.
main_amortizer_back_damper_force_factor 	= main_damper_force --Damping force in the extend direction

main_damper_coeff 							= 100.0

main_wheel_moment_of_inertia 				= 2.65

wheel_static_friction_factor_COMMON 		= 0.75
wheel_side_friction_factor_COMMON 			= 0.6
wheel_roll_friction_factor_COMMON 			= 0.04
wheel_glide_friction_factor_COMMON 			= 0.15 --this needs to be low to go from standstill to moving smoothly

brake_moment_main 							= 5500.0

wheel_radius_factor 						= 1.0

--Absolutely no idea what these do but they might be helpful.
main_wheel_kz_factor					= 0.52
main_noise_k							= 0.4

suspension = 
{
    --NOSEGEAR
    {
        anti_skid_installed = false,	
		
		mass 									= 50,
		damage_element 							= 83,
		moment_of_inertia 						= {10.0,0.5,10.0},--leg
		wheel_axle_offset 						= 0.1,
		self_attitude 							= true,
		yaw_limit 								= math.rad(90.0), --so apparently this must be set to half the animation angle for some reason
		
		amortizer_min_length 					= nose_amortizer_min_length,
		amortizer_max_length 					= nose_amortizer_max_length,
		amortizer_basic_length 					= nose_amortizer_basic_length,
		amortizer_reduce_length 				= nose_amortizer_reduce_length,
		
		amortizer_spring_force_factor 			= nose_amortizer_spring_force_factor,
		amortizer_spring_force_factor_rate 		= nose_amortizer_spring_force_factor_rate,

		amortizer_static_force 					= nose_amortizer_static_force,
		amortizer_direct_damper_force_factor 	= nose_amortizer_direct_damper_force_factor,
		amortizer_back_damper_force_factor 		= nose_amortizer_back_damper_force_factor,
	
		wheel_radius = 0.441,
		wheel_static_friction_factor 			= wheel_static_friction_factor_COMMON,
		wheel_side_friction_factor 				= wheel_side_friction_factor_COMMON,--affects the abillity to slide in turns - decrease for better turning
		wheel_roll_friction_factor 				= wheel_roll_friction_factor_COMMON,
		wheel_glide_friction_factor 			= wheel_glide_friction_factor_COMMON,
		wheel_damage_force_factor 				= 250.0,--/N/ 250 Su-25, damage to tires
		wheel_damage_speed 						= 200.0,
		wheel_brake_moment_max 					= 0.0,
		wheel_moment_of_inertia					= nose_wheel_moment_of_inertia,
		wheel_kz_factor							= nose_wheel_kz_factor,
		noise_k									= nose_noise_k,

		damper_coeff 							= main_damper_coeff,

		--damper_coeff = damper_coeff_tail_wheel,
		--arg_post = 0,
		arg_amortizer 							= 1,
		arg_wheel_rotation 						= 101,
		arg_wheel_yaw 							= 2,
		collision_shell_name					= "WHEEL_F",
    },

    --MAINGEAR LEFT
    {
        anti_skid_installed = false,
	
		mass 									= 200.0,
		damage_element 							= 84,
		moment_of_inertia 						= {100.0,10.0,100.0},--leg
		wheel_axle_offset 						= 0.0,
		yaw_limit	 							= 0.0,
		self_attitude	 						= false,

		amortizer_min_length 					= main_amortizer_min_length,
		amortizer_max_length 					= main_amortizer_max_length,
		amortizer_basic_length 					= main_amortizer_basic_length,
		amortizer_reduce_length 				= main_amortizer_reduce_length,
		
		amortizer_spring_force_factor 			= main_amortizer_spring_force_factor,
		amortizer_spring_force_factor_rate 		= main_amortizer_spring_force_factor_rate,
		
		amortizer_static_force 					= main_amortizer_static_force,
		amortizer_direct_damper_force_factor 	= main_amortizer_direct_damper_force_factor,
		amortizer_back_damper_force_factor 		= main_amortizer_back_damper_force_factor,
	
		wheel_radius 							= 0.609,
		wheel_static_friction_factor 			= wheel_static_friction_factor_COMMON,
		wheel_side_friction_factor 				= wheel_side_friction_factor_COMMON,
		wheel_roll_friction_factor 				= wheel_roll_friction_factor_COMMON,
		wheel_glide_friction_factor				= wheel_glide_friction_factor_COMMON,
		wheel_damage_force_factor 				= 250.0,
		wheel_damage_speed 						= 200.0, 
		wheel_brake_moment_max 					= brake_moment_main,
		wheel_moment_of_inertia 				= main_wheel_moment_of_inertia,
		wheel_kz_factor							= main_wheel_kz_factor,
		noise_k									= main_noise_k,

		damper_coeff 							= main_damper_coeff,

		--damper_coeff = damper_coeff_main_wheel,
		--arg_post = 5,
		arg_amortizer 							= 6,
		arg_wheel_rotation 						= 103,
		arg_wheel_yaw 							= -1,
		collision_shell_name 					= "WHEEL_L",
    },

    --MAINGEAR RIGHT
    {
        anti_skid_installed 					= false,
		
		mass 									= 200.0,
		damage_element 							= 85,--?
		moment_of_inertia 						= {100.0,10.0,100.0},--leg
		wheel_axle_offset 						= 0.0,
		yaw_limit	 							= 0.0,
		self_attitude	 						= false,

		amortizer_min_length 					= main_amortizer_min_length,
		amortizer_max_length 					= main_amortizer_max_length,
		amortizer_basic_length 					= main_amortizer_basic_length,
		amortizer_reduce_length 				= main_amortizer_reduce_length,
		
		amortizer_spring_force_factor 			= main_amortizer_spring_force_factor,
		amortizer_spring_force_factor_rate 		= main_amortizer_spring_force_factor_rate,
		
		amortizer_static_force 					= main_amortizer_static_force,
		amortizer_direct_damper_force_factor 	= main_amortizer_direct_damper_force_factor/2.0,
		amortizer_back_damper_force_factor 		= main_amortizer_back_damper_force_factor,
		
		wheel_radius 							= 0.609,
		wheel_static_friction_factor 			= wheel_static_friction_factor_COMMON,
		wheel_side_friction_factor 				= wheel_side_friction_factor_COMMON,
		wheel_roll_friction_factor 				= wheel_roll_friction_factor_COMMON,
		wheel_glide_friction_factor 			= wheel_glide_friction_factor_COMMON,
		wheel_damage_force_factor 				= 250.0,
		wheel_damage_speed 						= 200.0, 
		wheel_brake_moment_max 					= brake_moment_main,
		wheel_moment_of_inertia 				= main_wheel_moment_of_inertia,
		wheel_kz_factor							= main_wheel_kz_factor,
		noise_k									= main_noise_k,

		damper_coeff 							= main_damper_coeff,

		--damper_coeff = damper_coeff_main_wheel,
		--arg_post = 3,
		arg_amortizer 							= 4,
		arg_wheel_rotation 						= 102,
		arg_wheel_yaw 							= -1,
		collision_shell_name 					= "WHEEL_R",
    },
}