
--NOSEGEAR
nose_amortizer_min_length = 0.00
nose_amortizer_max_length = 0.32
nose_amortizer_basic_length = 0.32
nose_amortizer_reduce_length = 0.32


nose_amortizer_spring_force_factor = 4.2e+06
nose_amortizer_spring_force_factor_rate = 2.0

--nose_amortizer_static_force = 5e+4
nose_amortizer_static_force = 5e+4
nose_damper_force = 1e+4
nose_amortizer_direct_damper_force_factor =  nose_damper_force * 1.2
nose_amortizer_back_damper_force_factor =  nose_damper_force * 1.0


--MAINGEAR2
main_amortizer_min_length = 0.00
main_amortizer_max_length = 0.70
main_amortizer_basic_length = 0.70
main_amortizer_reduce_length = 0.70

--main_amortizer_max_length = 0.60
--main_amortizer_basic_length = 0.60
--main_amortizer_reduce_length = 0.60


main_amortizer_spring_force_factor = 1.2e+6
main_amortizer_spring_force_factor_rate = 2.5

main_amortizer_static_force = 1.0e+3
main_damper_force = 5.5e+4 --3e+4
main_amortizer_direct_damper_force_factor = main_damper_force * 1.2
main_amortizer_back_damper_force_factor = main_damper_force * 1.0

main_damper_coeff = 300.0

--[[ Semi good settings
--NOSEGEAR
nose_amortizer_min_length = 0.00
nose_amortizer_max_length = 0.32
nose_amortizer_basic_length = 0.32
nose_amortizer_reduce_length = 0.32


nose_amortizer_spring_force_factor = 1.2e+06
nose_amortizer_spring_force_factor_rate = 2.0

nose_amortizer_static_force = 5e+4
nose_damper_force = 1e+4
nose_amortizer_direct_damper_force_factor =  nose_damper_force * 1.2
nose_amortizer_back_damper_force_factor =  nose_damper_force * 1.0


--MAINGEAR2
main_amortizer_min_length = 0.00
main_amortizer_max_length = 0.60
main_amortizer_basic_length = 0.60
main_amortizer_reduce_length = 0.60


main_amortizer_spring_force_factor = 5e+5
main_amortizer_spring_force_factor_rate = 2.0

main_amortizer_static_force = 1e+3
main_damper_force = 3e+4
main_amortizer_direct_damper_force_factor = main_damper_force * 1.2
main_amortizer_back_damper_force_factor = main_damper_force * 1.0
]]--

wheel_static_friction_factor_COMMON = 1.50
wheel_side_friction_factor_COMMON = 1.00
wheel_roll_friction_factor_COMMON = 0.04
wheel_glide_friction_factor_COMMON = 0.40

brake_moment_main = 10000.0

wheel_radius_factor = 1.2

suspension = 
{
    --NOSEGEAR
    {
        anti_skid_installed = false,	
		
		mass = 50,
		damage_element = 83,
		moment_of_inertia = {10.0,1.0,10.0},--leg
		wheel_axle_offset = 0.1,
		self_attitude = true,
		yaw_limit = math.rad(90.0),
		
		amortizer_min_length = nose_amortizer_min_length,
		amortizer_max_length = nose_amortizer_max_length,
		amortizer_basic_length = nose_amortizer_basic_length,
		amortizer_reduce_length = nose_amortizer_reduce_length,
		
		amortizer_spring_force_factor = nose_amortizer_spring_force_factor,
		amortizer_spring_force_factor_rate = nose_amortizer_spring_force_factor_rate,

		amortizer_static_force = nose_amortizer_static_force,
		amortizer_direct_damper_force_factor = nose_amortizer_direct_damper_force_factor,
		amortizer_back_damper_force_factor = nose_amortizer_back_damper_force_factor,
	
		wheel_radius = 0.441,
		wheel_static_friction_factor = wheel_static_friction_factor_COMMON,
		wheel_side_friction_factor = wheel_side_friction_factor_COMMON * 0.7,--affects the abillity to slide in turns - decrease for better turning
		wheel_roll_friction_factor = wheel_roll_friction_factor_COMMON,
		wheel_glide_friction_factor = wheel_glide_friction_factor_COMMON,
		wheel_damage_force_factor = 250.0,--/N/ 250 Su-25, damage to tires
		wheel_damage_speed = 200.0,
		wheel_brake_moment_max = 0.0,
		wheel_moment_of_inertia = 7,

		damper_coeff = main_damper_coeff,

		--damper_coeff = damper_coeff_tail_wheel,
		--arg_post = 0,
		arg_amortizer = 1,
		arg_wheel_rotation = 76,
		arg_wheel_yaw = 2,
		collision_shell_name = "WHEEL_F",
    },

    --MAINGEAR LEFT
    {
        anti_skid_installed = true,
	
		mass = 200.0,
		damage_element = 84,
		moment_of_inertia = {100.0,10.0,100.0},--leg
		wheel_axle_offset 	= 0.0,
		yaw_limit	 = 0.0,
		self_attitude	 = false,

		amortizer_min_length = main_amortizer_min_length,
		amortizer_max_length = main_amortizer_max_length,
		amortizer_basic_length = main_amortizer_basic_length,
		amortizer_reduce_length = main_amortizer_reduce_length,
		
		amortizer_spring_force_factor = main_amortizer_spring_force_factor,
		amortizer_spring_force_factor_rate = main_amortizer_spring_force_factor_rate,
		
		amortizer_static_force = main_amortizer_static_force,
		amortizer_direct_damper_force_factor = main_amortizer_direct_damper_force_factor/2.0,
		amortizer_back_damper_force_factor = main_amortizer_back_damper_force_factor,
	
		wheel_radius = 0.609 * wheel_radius_factor,
		wheel_static_friction_factor = wheel_static_friction_factor_COMMON,
		wheel_side_friction_factor = wheel_side_friction_factor_COMMON,
		wheel_roll_friction_factor = wheel_roll_friction_factor_COMMON,
		wheel_glide_friction_factor = wheel_glide_friction_factor_COMMON,
		wheel_damage_force_factor = 250.0,
		wheel_damage_speed = 200.0, 
		wheel_brake_moment_max = brake_moment_main,
		wheel_moment_of_inertia = 10,

		damper_coeff = main_damper_coeff,

		--damper_coeff = damper_coeff_main_wheel,
		--arg_post = 5,
		arg_amortizer = 6,
		arg_wheel_rotation = 77,
		arg_wheel_yaw = -1,
		collision_shell_name = "WHEEL_R",
    },

    --MAINGEAR RIGHT
    {
        anti_skid_installed = true,
		
		mass = 200.0,
		damage_element = 84,--?
		moment_of_inertia = {100.0,10.0,100.0},--leg
		wheel_axle_offset 	= 0.0,
		yaw_limit	 = 0.0,
		self_attitude	 = false,

		amortizer_min_length = main_amortizer_min_length,
		amortizer_max_length = main_amortizer_max_length,
		amortizer_basic_length = main_amortizer_basic_length,
		amortizer_reduce_length = main_amortizer_reduce_length,
		
		amortizer_spring_force_factor = main_amortizer_spring_force_factor,
		amortizer_spring_force_factor_rate = main_amortizer_spring_force_factor_rate,
		
		amortizer_static_force = main_amortizer_static_force,
		amortizer_direct_damper_force_factor = main_amortizer_direct_damper_force_factor/2.0,
		amortizer_back_damper_force_factor = main_amortizer_back_damper_force_factor,
		
		wheel_radius = 0.609 * wheel_radius_factor,
		wheel_static_friction_factor = wheel_static_friction_factor_COMMON,
		wheel_side_friction_factor = wheel_side_friction_factor_COMMON,
		wheel_roll_friction_factor = wheel_roll_friction_factor_COMMON,
		wheel_glide_friction_factor = wheel_glide_friction_factor_COMMON,
		wheel_damage_force_factor = 250.0,
		wheel_damage_speed = 200.0, 
		wheel_brake_moment_max = brake_moment_main,
		wheel_moment_of_inertia = 10,

		damper_coeff = main_damper_coeff,

		--damper_coeff = damper_coeff_main_wheel,
		--arg_post = 3,
		arg_amortizer = 4,
		arg_wheel_rotation = 77,
		arg_wheel_yaw = -1,
		collision_shell_name = "WHEEL_R",
    },
}