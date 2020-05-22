#pragma once

/*/////////////////////////////////////////////////////////////////////////
Pointer to function of force source in body axis 
x,y,z			  - force components in body coordinate system
pos_x,pos_y,pos_z - position of force source in body coordinate system 

body coordinate system system is always X - positive forward ,
										Y - positive up,
										Z - positive to right 
prototype for 		

ed_fm_add_local_force
ed_fm_add_global_force
*/
typedef void (*PFN_FORCE_SOURCE)			(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);

/* same but in component form , return value bool : function will be called until return value is true
while (ed_fm_add_local_force_component(x,y,z,pos_xpos_y,pos_z))
{
	--collect 
}
ed_fm_add_local_force_component
ed_fm_add_global_force_component
*/
typedef bool (*PFN_FORCE_COMPONENT_SOURCE)  (double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);

/*
Pointer to function of moment source in body axis 
prototype for 
ed_fm_add_local_moment
ed_fm_add_global_moment
*/
typedef void (*PFN_MOMENT_SOURCE) (double & x,double &y,double &z);

/* same but in component form , return value bool : function will be called until return value is true
while (ed_fm_add_local_moment_component(x,y,z))
{
	--collect 
}
ed_fm_add_local_moment_component
ed_fm_add_global_moment_component
*/
typedef bool (*PFN_MOMENT_COMPONENT_SOURCE)  (double & x,double &y,double &z);

/*
simulate will be called on each step, all your FM should be evaluated here,
result of simulation will be called later as forces and moment sources

prototype for

ed_fm_simulate
*/
typedef void (*PFN_SIMULATE)	  (double dt);


/*
called before simulation to set up your environment for the next step

prototype for

ed_fm_set_surface    give parameters of surface under your aircraft usefull for ground effect
*/
typedef void (*PFN_SET_SURFACE)	  (double		h,//surface height under the center of aircraft
								   double		h_obj,//surface height with objects
								   unsigned		surface_type,
								   double		normal_x,//components of normal vector to surface
								   double		normal_y,//components of normal vector to surface
								   double		normal_z//components of normal vector to surface
								  );

/*
called before simulation to set up your environment for the next step

prototype for

ed_fm_set_atmosphere
*/
typedef void (*PFN_SET_ATMOSPHERE)(double h,//altitude above sea level
								   double t,//current atmosphere temperature , Kelwins
								   double a,//speed of sound
								   double ro,// atmosphere density
								   double p,// atmosphere pressure
								   double wind_vx,//components of velocity vector, including turbulence in world coordinate system
								   double wind_vy,//components of velocity vector, including turbulence in world coordinate system
								   double wind_vz //components of velocity vector, including turbulence in world coordinate system
								   );

enum class WNDVF_SPACE
{
	IN_BODY_SPACE, // pos expected to be in aircraft body space , wind  will be filled as wind converted to body space
	IN_WORLD_SPACE,// pos expected to be in global space , wind  will be filled as wind in globalspace
};

struct wind_vector_field_component
{
	double pos [3]; // x,y,z components in DCS coordinates system (x positive forward ,y positive up , z positive to the right)
	double wind[3]; // x,y,z components in DCS coordinates system (x positive forward ,y positive up , z positive to the right)
};

const unsigned wind_vector_field_component_size = sizeof(wind_vector_field_component);


struct wind_vector_field
{
	wind_vector_field_component	  * field				= nullptr;
	//amount of points
	unsigned						field_points_count  = 0;
	///sizeof  wind_vector_field_component 
	///used when you store more data in derived structure
	unsigned 						field_point_size_in_bytes = wind_vector_field_component_size;
	//indicates in which coordinates system you want to have data
	WNDVF_SPACE	space = WNDVF_SPACE::IN_BODY_SPACE;
};
/*
called before simulation to set up your environment for the next step

prototype for
void ed_fm_wind_vector_field_update_request(wind_vector_field & in_out);
void ed_fm_wind_vector_field_done()

DCS will  call ed_fm_wind_vector_field_update_request first,
after that it will read  in_out  structure and  fill all "field_points_count" points starting from "field"
and fill wind  array with actual atmosphere state in that point 

after that ed_fm_wind_vector_field_done  will be called :

wind_vector_field wind_data;
ed_fm_wind_vector_field_update_request(wind_data);
if (wind_data.field)
{
	for (int i = 0; i < wind_data.field_points_count; ++i)
	{
		wind_vector_field_component * pnt = (wind_vector_field_component*)((BYTE*)wind_data.field + i * (wind_data.field_point_size_in_bytes));

		...DCS will request  atmosphere here for  wind in   pnt->pos with respect of wind_data.space
	}
}
ed_fm_wind_vector_field_done();
*/
typedef void(*PFN_WIND_VECTOR_FIELD_UPDATE_REQUEST)(wind_vector_field & in_out);
typedef void(*PFN_WIND_VECTOR_FIELD_DONE)();



/*
called before simulation to set up your environment for the next step

prototype for

ed_fm_set_current_mass_state
*/
typedef void (*PFN_CURRENT_MASS_STATE) (double mass,
										double center_of_mass_x,
										double center_of_mass_y,
										double center_of_mass_z,
										double moment_of_inertia_x,
										double moment_of_inertia_y,
										double moment_of_inertia_z
										);
/*
called before simulation to set up your environment for the next step

prototype for

ed_fm_set_current_state
*/
typedef void (*PFN_CURRENT_STATE) (double ax,//linear acceleration component in world coordinate system
								   double ay,//linear acceleration component in world coordinate system
								   double az,//linear acceleration component in world coordinate system
								   double vx,//linear velocity component in world coordinate system
								   double vy,//linear velocity component in world coordinate system
								   double vz,//linear velocity component in world coordinate system
								   double px,//center of the body position in world coordinate system
								   double py,//center of the body position in world coordinate system
								   double pz,//center of the body position in world coordinate system
								   double omegadotx,//angular accelearation components in world coordinate system
								   double omegadoty,//angular accelearation components in world coordinate system
								   double omegadotz,//angular accelearation components in world coordinate system
								   double omegax,//angular velocity components in world coordinate system
								   double omegay,//angular velocity components in world coordinate system
								   double omegaz,//angular velocity components in world coordinate system
								   double quaternion_x,//orientation quaternion components in world coordinate system
								   double quaternion_y,//orientation quaternion components in world coordinate system
								   double quaternion_z,//orientation quaternion components in world coordinate system
								   double quaternion_w //orientation quaternion components in world coordinate system
								   );
/*
additional state information in body axis

ed_fm_set_current_state_body_axis
*/
typedef void (*PFN_CURRENT_STATE_BODY_AXIS) (double ax,//linear acceleration component in body coordinate system
											 double ay,//linear acceleration component in body coordinate system
											 double az,//linear acceleration component in body coordinate system
											 double vx,//linear velocity component in body coordinate system
											 double vy,//linear velocity component in body coordinate system
											 double vz,//linear velocity component in body coordinate system
											 double wind_vx,//wind linear velocity component in body coordinate system
											 double wind_vy,//wind linear velocity component in body coordinate system
											 double wind_vz,//wind linear velocity component in body coordinate system

											 double omegadotx,//angular accelearation components in body coordinate system
											 double omegadoty,//angular accelearation components in body coordinate system
											 double omegadotz,//angular accelearation components in body coordinate system
											 double omegax,//angular velocity components in body coordinate system
											 double omegay,//angular velocity components in body coordinate system
											 double omegaz,//angular velocity components in body coordinate system
											 double yaw,  //radians
											 double pitch,//radians
											 double roll, //radians
											 double common_angle_of_attack, //AoA radians
											 double common_angle_of_slide   //AoS radians
	);
/*
input handling

prototype for 

ed_fm_set_command
*/
typedef void (*PFN_SET_COMMAND) (int command,
								 float value);

/*
 Mass handling 

 will be called  after ed_fm_simulate :
 you should collect mass changes in ed_fm_simulate 

 double delta_mass = 0;
 double x = 0;
 double y = 0; 
 double z = 0;
 double piece_of_mass_MOI_x = 0;
 double piece_of_mass_MOI_y = 0; 
 double piece_of_mass_MOI_z = 0;
 
 //
 while (ed_fm_change_mass(delta_mass,x,y,z,piece_of_mass_MOI_x,piece_of_mass_MOI_y,piece_of_mass_MOI_z))
 {
	//internal DCS calculations for changing mass, center of gravity,  and moments of inertia
 }

*/
typedef bool (*PFN_CHANGE_MASS) (double & delta_mass,
							 	 double & delta_mass_pos_x,
								 double & delta_mass_pos_y,
								 double & delta_mass_pos_z,
								 double & delta_mass_moment_of_inertia_x,
								 double & delta_mass_moment_of_inertia_y,
								 double & delta_mass_moment_of_inertia_z
								 );
/*
	set internal fuel volume , init function, called on object creation and for refueling , 
	you should distribute it inside at different fuel tanks
	
	prototype for ed_fm_set_internal_fuel

*/
typedef void   (*PFN_SET_INTERNAL_FUEL)  (double fuel);

/*
	get internal fuel volume 
	
	prototype for ed_fm_get_internal_fuel

*/
typedef double (*PFN_GET_INTERNAL_FUEL)  ();

/*
	set external fuel volume for each payload station , called for weapon init and on reload
	
	prototype for ed_fm_set_external_fuel

*/
typedef void   (*PFN_SET_EXTERNAL_FUEL)  (int	 station,
										  double fuel,
										  double x,
										  double y,
										  double z);
/*
	get external fuel volume 
	
	prototype for ed_fm_get_external_fuel
*/
typedef double (*PFN_GET_EXTERNAL_FUEL)  ();


/*
	incremental adding of fuel in case of refueling process 
	
	prototype for ed_fm_refueling_add_fuel(double fuel);

	(optional , if function doesnt exist  ed_fm_set_internal_fuel will be called in the next manner 

		ed_fm_set_internal_fuel(ed_fm_get_internal_fuel() + additional_fuel);
	)
*/
typedef void (*PFN_REFUELING_ADD_FUEL)  (double fuel);



struct EdDrawArgument
{
	union 
	{
		float f;
		void *p;
		int   i;
	};
};
/*
	update draw arguments for your aircraft 

	prototype for ed_fm_set_draw_args
	also same prototype is used for ed_fm_set_fc3_cockpit_draw_args  : direct control over cockpit arguments , it can be use full for FC3 cockpits reintegration with new flight model 
*/
typedef void (*PFN_SET_DRAW_ARGS)  (EdDrawArgument * array,size_t size);


/*
shake level amplitude for head simulation , 
prototype for ed_fm_get_shake_amplitude 
*/
typedef double (*PFN_GET_SHAKE_AMPLITUDE) ();  

/*
will be called for your internal configuration
ed_fm_configure
*/
typedef void (*PFN_CONFIGURE)  (const char * cfg_path);
/*
will be called for your internal configuration
void ed_fm_release   called when fm not needed anymore : aircraft death etc.
*/
typedef void (*PFN_FM_RELEASE) ();


/*
various param call back to proper integrate your FM to DCS , like engine RPM , thrust etc
ed_fm_get_param
*/

enum ed_fm_param_enum
{
	ED_FM_ENGINE_0_RPM = 0,					//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_RELATED_RPM,				//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_CORE_RPM,				//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_CORE_RELATED_RPM,		//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_THRUST,					//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_RELATED_THRUST,			//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_CORE_THRUST,				//NOTE!!!! engine at index 0 is APU
	ED_FM_ENGINE_0_CORE_RELATED_THRUST,		//NOTE!!!! engine at index 0 is APU

	ED_FM_PROPELLER_0_RPM,    // propeller RPM , for helicopter it is main rotor RPM
	ED_FM_PROPELLER_0_PITCH,  // propeller blade pitch
	ED_FM_PROPELLER_0_TILT,   // for helicopter
	ED_FM_PROPELLER_0_INTEGRITY_FACTOR,   // for 0 to 1 , 0 is fully broken , 

	ED_FM_ENGINE_0_TEMPERATURE,//Celcius
	ED_FM_ENGINE_0_OIL_PRESSURE,
	ED_FM_ENGINE_0_FUEL_FLOW,
	ED_FM_ENGINE_0_COMBUSTION,//level of combustion for engine  , 0 - 1

	ED_FM_PISTON_ENGINE_0_MANIFOLD_PRESSURE,//

    ED_FM_ENGINE_0_STARTER_RELATED_RPM,
    ED_FM_ENGINE_0_STARTER_RELATED_TORQUE,
    ED_FM_ENGINE_0_STARTER_SPIN_DOWN_RELATED_RPM,
    ED_FM_ENGINE_0_STARTER_SPIN_DOWN_RELATED_TORQUE,
    ED_FM_ENGINE_0_STARTER_CLUTCH_ENGAGED_RELATED_RPM,
    ED_FM_ENGINE_0_STARTER_CLUTCH_ENGAGED_RELATED_TORQUE,


	/*RESERVED PLACE FOR OTHER ENGINE PARAM*/
	ED_FM_ENGINE_1_RPM = 100,	
	ED_FM_ENGINE_1_RELATED_RPM,				
	ED_FM_ENGINE_1_CORE_RPM,				
	ED_FM_ENGINE_1_CORE_RELATED_RPM,		
	ED_FM_ENGINE_1_THRUST,					
	ED_FM_ENGINE_1_RELATED_THRUST,			
	ED_FM_ENGINE_1_CORE_THRUST,				
	ED_FM_ENGINE_1_CORE_RELATED_THRUST,	

	ED_FM_PROPELLER_1_RPM,    // propeller RPM , for helicopter it is main rotor RPM
	ED_FM_PROPELLER_1_PITCH,  // propeller blade pitch
	ED_FM_PROPELLER_1_TILT,   // for helicopter
	ED_FM_PROPELLER_1_INTEGRITY_FACTOR,   // for 0 to 1 , 0 is fully broken , 
	
	ED_FM_ENGINE_1_TEMPERATURE,//Celcius
	ED_FM_ENGINE_1_OIL_PRESSURE,
	ED_FM_ENGINE_1_FUEL_FLOW,
	ED_FM_ENGINE_1_COMBUSTION,//level of combustion for engine  , 0 - 1

	ED_FM_PISTON_ENGINE_1_MANIFOLD_PRESSURE,

    ED_FM_ENGINE_1_STARTER_RELATED_RPM,
    ED_FM_ENGINE_1_STARTER_RELATED_TORQUE,
    ED_FM_ENGINE_1_STARTER_SPIN_DOWN_RELATED_RPM,
    ED_FM_ENGINE_1_STARTER_SPIN_DOWN_RELATED_TORQUE,
    ED_FM_ENGINE_1_STARTER_CLUTCH_ENGAGED_RELATED_RPM,
    ED_FM_ENGINE_1_STARTER_CLUTCH_ENGAGED_RELATED_TORQUE,

	//.................................
	ED_FM_ENGINE_2_RPM = 2 * (ED_FM_ENGINE_1_RPM - ED_FM_ENGINE_0_RPM),
	ED_FM_ENGINE_2_RELATED_RPM,				
	ED_FM_ENGINE_2_CORE_RPM,				
	ED_FM_ENGINE_2_CORE_RELATED_RPM,		
	ED_FM_ENGINE_2_THRUST,					
	ED_FM_ENGINE_2_RELATED_THRUST,			
	ED_FM_ENGINE_2_CORE_THRUST,				
	ED_FM_ENGINE_2_CORE_RELATED_THRUST,

	ED_FM_PROPELLER_2_RPM,    // propeller RPM , for helicopter it is main rotor RPM
	ED_FM_PROPELLER_2_PITCH,  // propeller blade pitch
	ED_FM_PROPELLER_2_TILT,   // for helicopter
	ED_FM_PROPELLER_2_INTEGRITY_FACTOR,   // for 0 to 1 , 0 is fully broken , 

	ED_FM_ENGINE_2_TEMPERATURE,//Celcius
	ED_FM_ENGINE_2_OIL_PRESSURE,
	ED_FM_ENGINE_2_FUEL_FLOW,
	ED_FM_ENGINE_2_COMBUSTION,//level of combustion for engine , 0 - 1

	ED_FM_PISTON_ENGINE_2_MANIFOLD_PRESSURE,

    ED_FM_ENGINE_2_STARTER_RELATED_RPM,
    ED_FM_ENGINE_2_STARTER_RELATED_TORQUE,
    ED_FM_ENGINE_2_STARTER_SPIN_DOWN_RELATED_RPM,
    ED_FM_ENGINE_2_STARTER_SPIN_DOWN_RELATED_TORQUE,
    ED_FM_ENGINE_2_STARTER_CLUTCH_ENGAGED_RELATED_RPM,
    ED_FM_ENGINE_2_STARTER_CLUTCH_ENGAGED_RELATED_TORQUE,

	//.................................
	ED_FM_ENGINE_3_RPM = 3 * (ED_FM_ENGINE_1_RPM - ED_FM_ENGINE_0_RPM),
	/*	
		up to 20 engines
	*/
	ED_FM_END_ENGINE_BLOCK = 20 * (ED_FM_ENGINE_1_RPM - ED_FM_ENGINE_0_RPM),
	/*
	suspension block
	*/
	ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT,
	ED_FM_SUSPENSION_0_GEAR_POST_STATE, // from 0 to 1 : from fully retracted to full released
	ED_FM_SUSPENSION_0_UP_LOCK,
	ED_FM_SUSPENSION_0_DOWN_LOCK,
	ED_FM_SUSPENSION_0_WHEEL_YAW,
	ED_FM_SUSPENSION_0_WHEEL_SELF_ATTITUDE,

	ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT + 10,
	ED_FM_SUSPENSION_1_GEAR_POST_STATE, // from 0 to 1 : from fully retracted to full released
	ED_FM_SUSPENSION_1_UP_LOCK,
	ED_FM_SUSPENSION_1_DOWN_LOCK,
	ED_FM_SUSPENSION_1_WHEEL_YAW,
	ED_FM_SUSPENSION_1_WHEEL_SELF_ATTITUDE,


	ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_2_GEAR_POST_STATE, // from 0 to 1 : from fully retracted to full released
	ED_FM_SUSPENSION_2_UP_LOCK,
	ED_FM_SUSPENSION_2_DOWN_LOCK,
	ED_FM_SUSPENSION_2_WHEEL_YAW,
	ED_FM_SUSPENSION_2_WHEEL_SELF_ATTITUDE,


	ED_FM_SUSPENSION_3_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_4_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_3_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_5_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_4_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_6_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_5_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_7_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_6_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_8_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_7_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_9_RELATIVE_BRAKE_MOMENT  = ED_FM_SUSPENSION_8_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),
	ED_FM_SUSPENSION_10_RELATIVE_BRAKE_MOMENT = ED_FM_SUSPENSION_9_RELATIVE_BRAKE_MOMENT + (ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT),


	ED_FM_OXYGEN_SUPPLY, // oxygen provided from on board oxygen system, pressure - pascal
	ED_FM_FLOW_VELOCITY,

	ED_FM_CAN_ACCEPT_FUEL_FROM_TANKER,// return positive value if all conditions are matched to connect to tanker and get fuel

	// Groups for fuel indicator
	ED_FM_FUEL_FUEL_TANK_GROUP_0_LEFT,			// Values from different group of tanks
	ED_FM_FUEL_FUEL_TANK_GROUP_0_RIGHT,
	ED_FM_FUEL_FUEL_TANK_GROUP_1_LEFT,
	ED_FM_FUEL_FUEL_TANK_GROUP_1_RIGHT,
	ED_FM_FUEL_FUEL_TANK_GROUP_2_LEFT,
	ED_FM_FUEL_FUEL_TANK_GROUP_2_RIGHT,
	ED_FM_FUEL_FUEL_TANK_GROUP_3_LEFT,
	ED_FM_FUEL_FUEL_TANK_GROUP_3_RIGHT,
	ED_FM_FUEL_FUEL_TANK_GROUP_4_LEFT,
	ED_FM_FUEL_FUEL_TANK_GROUP_4_RIGHT,
	ED_FM_FUEL_FUEL_TANK_GROUP_5_LEFT,
	ED_FM_FUEL_FUEL_TANK_GROUP_5_RIGHT,
	ED_FM_FUEL_FUEL_TANK_GROUP_6_LEFT,
	ED_FM_FUEL_FUEL_TANK_GROUP_6_RIGHT,
	ED_FM_FUEL_INTERNAL_FUEL,
	ED_FM_FUEL_TOTAL_FUEL,
	ED_FM_FUEL_LOW_SIGNAL,						// Low fuel signal

	
	
	ED_FM_ANTI_SKID_ENABLE,/* return positive value if anti skid system is on , it also corresspond with suspension table "anti_skid_installed"  parameter for each gear post .i.e 
	
	anti skid system will be applied only for those wheels who marked with   anti_skid_installed = true
	
	*/

	ED_FM_STICK_FORCE_CENTRAL_PITCH,  // i.e. trimmered position where force feeled by pilot is zero
	ED_FM_STICK_FORCE_FACTOR_PITCH,
	ED_FM_STICK_FORCE_SHAKE_AMPLITUDE_PITCH,
	ED_FM_STICK_FORCE_SHAKE_FREQUENCY_PITCH,
	
	ED_FM_STICK_FORCE_CENTRAL_ROLL,   // i.e. trimmered position where force feeled by pilot is zero
	ED_FM_STICK_FORCE_FACTOR_ROLL,
	ED_FM_STICK_FORCE_SHAKE_AMPLITUDE_ROLL,
	ED_FM_STICK_FORCE_SHAKE_FREQUENCY_ROLL,
	
	
	ED_FM_COCKPIT_PRESSURIZATION_OVER_EXTERNAL, // additional pressure from pressurization system , pascal , actual cabin pressure will be AtmoPressure + COCKPIT_PRESSURIZATION_OVER_EXTERNAL

	ED_FM_COCKPIT_ALTIMETER_PRESSURE_SETTING_MM_HG, // baro altimeter setting in mm hg
	
	//params to integrate with old FC style cockpits
	ED_FM_FC3_RESERVED_SPACE 	 = 10000,
	ED_FM_FC3_GEAR_HANDLE_POS,
	ED_FM_FC3_FLAPS_HANDLE_POS,
	ED_FM_FC3_SPEED_BRAKE_HANDLE_POS,
	
	ED_FM_FC3_STICK_PITCH,
	ED_FM_FC3_STICK_ROLL,
	ED_FM_FC3_RUDDER_PEDALS,
	ED_FM_FC3_THROTTLE_LEFT,
	ED_FM_FC3_THROTTLE_RIGHT,
	
	ED_FM_FC3_CAS_FAILURE_PITCH_CHANNEL,
	ED_FM_FC3_CAS_FAILURE_ROLL_CHANNEL,
	ED_FM_FC3_CAS_FAILURE_YAW_CHANNEL,
	
	ED_FM_FC3_AUTOPILOT_STATUS,
	ED_FM_FC3_AUTOPILOT_FAILURE_ATTITUDE_STABILIZATION,

	ED_FM_FC3_STICK_PITCH_LIMITER,	//ограничение РУС на себя (-1 .. 0 .. 1, 1 - не ограничивает)
	ED_FM_FC3_STICK_ROLL_L_LIMITER,	//ограничение РУС по крену (0 .. 1, 1 - не ограничивает)
	ED_FM_FC3_PEDAL_L_LIMITER,		//ограничение левой педали (0 .. 1, 1 - не ограничивает)
	ED_FM_FC3_PEDAL_R_LIMITER,		//ограничение правой педали (0 .. 1, 1 - не ограничивает)

	ED_FM_FC3_BREAKE_CHUTE_STATUS,
	ED_FM_FC3_BREAKE_CHUTE_VALUE,

	ED_FM_FC3_WHEEL_BRAKE_LEFT,
    ED_FM_FC3_WHEEL_BRAKE_RIGHT,
	ED_FM_FC3_WHEEL_BRAKE_COMMAND_LEFT,
    ED_FM_FC3_WHEEL_BRAKE_COMMAND_RIGHT,

	ED_FM_FC3_AR_DOOR_PROBE_HANDLE_POS, // Air refuel door/probe commanded position

	ED_FM_FC3_RESERVED_SPACE_END = 11000,
};

typedef double (*PFN_GET_PARAM)  (unsigned param_enum);



/*
prepare your FM for different start conditions:
ed_fm_cold_start
ed_fm_hot_start
ed_fm_hot_start_in_air

next functions will be called before 

ed_fm_set_current_state
ed_fm_set_current_mass_state
ed_fm_set_atmosphere
*/
typedef void (*PFN_COLD_START)  ();
typedef void (*PFN_HOT_START)   ();
typedef void (*PFN_HOT_START_IN_AIR)   ();

/* 
ed_fm_make_balance
for experts only : called  after ed_fm_hot_start_in_air for balance FM at actual speed and height , it is directly force aircraft dynamic data in case of success 
*/
typedef bool (*PFN_MAKE_BALANCE) (double & ax,//linear acceleration component in world coordinate system);
								  double & ay,//linear acceleration component in world coordinate system
								  double & az,//linear acceleration component in world coordinate system
								  double & vx,//linear velocity component in world coordinate system
								  double & vy,//linear velocity component in world coordinate system
								  double & vz,//linear velocity component in world coordinate system
								  double & omegadotx,//angular accelearation components in world coordinate system
								  double & omegadoty,//angular accelearation components in world coordinate system
								  double & omegadotz,//angular accelearation components in world coordinate system
								  double & omegax,//angular velocity components in world coordinate system
								  double & omegay,//angular velocity components in world coordinate system
								  double & omegaz,//angular velocity components in world coordinate system
								  double & yaw,  //radians
								  double & pitch,//radians
								  double & roll);//radians

//some utility 


//bool ed_fm_enable_debug_info()
/*
enable additional information like force vector visualization , etc.
*/
typedef bool   (*PFN_ENABLE_DEBUG_INFO)();



/*debuf watch output for topl left corner DCS window info  (Ctrl + Pause to show)
ed_fm_debug_watch(int level, char *buffer,char *buf,size_t maxlen)
level - Watch verbosity level.
ED_WATCH_BRIEF   = 0,
ED_WATCH_NORMAL  = 1,
ED_WATCH_FULL	 = 2,

return value  - amount of written bytes

using

size_t ed_fm_debug_watch(int level, char *buffer,size_t maxlen)
{
	float  value_1 = .. some value;
	float  value_2 = .. some value;
	//optional , you can change depth of displayed information with level 
	switch (level)
	{
		case 0:     //ED_WATCH_BRIEF,
			..do something
			break;
		case 1:     //ED_WATCH_NORMAL,
			..do something
		break;
		case 2:     //ED_WATCH_FULL,
			..do something
		break;
	}
	... do something 
	if (do not want to display)
	{	
		return 0;
	}
	else // ok i want to display some vars 
	{    
		return sprintf_s(buffer,maxlen,"var value1 %f ,var value2 %f",value_1,value_2);
	}
}
*/
typedef size_t (*PFN_DEBUG_WATCH)(int level, char *buffer,size_t maxlen);


// void ed_fm_set_plugin_data_install_path(const char * )  path to your plugin installed
typedef void (*PFN_SET_PLUGIN_DATA_INSTALL_PATH) (const char *);

// damages and failures
// void ed_fm_on_planned_failure(const char * ) callback when preplaneed failure triggered from mission 
typedef void (*PFN_ON_PLANNED_FAILURE) (const char *);

// void ed_fm_on_damage(int Element, double element_integrity_factor) callback when damage occurs for airframe element 
typedef void (*PFN_ON_DAMAGE) (int Element, double element_integrity_factor);

// void ed_fm_repair()  called in case of repair routine 
typedef void (*PFN_REPAIR)  ();

// bool ed_fm_need_to_be_repaired()  in case of some internal damages or system failures this function return true , to switch on repair process
typedef bool (*PFN_NEED_TO_BE_REPAIRED) ();

// void ed_fm_set_immortal(bool value)  inform about  invulnerability settings
typedef void (*PFN_FM_SET_IMMORTAL) (bool value);
// void ed_fm_unlimited_fuel(bool value)  inform about  unlimited fuel
typedef void (*PFN_FM_SET_UNLIMITED_FUEL) (bool value);
// void ed_fm_set_easy_flight(bool value)  inform about simplified flight model request 
typedef void (*PFN_FM_SET_EASY_FLIGHT) (bool value);


// void ed_fm_set_property_numeric(const char * property_name,float value)   custom properties sheet 
typedef void (*PFN_FM_SET_PROPERTY_NUMERIC) (const char * property_name,float value);
// void ed_fm_set_property_string(const char * property_name,const char * value)   custom properties sheet 
typedef void (*PFN_FM_SET_PROPERTY_STRING) (const char * property_name,const char * value);


//inform DCS about internal simulation event, like structure damage , failure , or effect

struct ed_fm_simulation_event 
{
	unsigned     event_type;
	char         event_message[512];    // optional 
	float 		 event_params [16]; // type specific data  , like coordinates , scales etc 
};

// bool ed_fm_pop_simulation_event(ed_fm_simulation_event & out)  called on each sim step 
/*
	ed_fm_simulation_event event;
	while (ed_fm_pop_simulation_event(event))
	{
		do some with event data;
	}
*/
typedef bool (*PFN_FM_POP_SIMULATION_EVENT) (ed_fm_simulation_event & out);
// event type declaration
enum ed_fm_simulation_event_type
{
	ED_FM_EVENT_INVALID = 0,
	ED_FM_EVENT_FAILURE,
	ED_FM_EVENT_STRUCTURE_DAMAGE,
	ED_FM_EVENT_FIRE,
	ED_FM_EVENT_CARRIER_CATAPULT
};
/*
ED_FM_EVENT_FAILURE 

event_message  - failure id , like "autopilot" or "r-engine"
event_params   - not used for failure


ED_FM_EVENT_STRUCTURE_DAMAGE

event_message - not used 
event_params[0]  damage element number like in ed_fm_on_damage 
event_params[1]  integrity factor      like in ed_fm_on_damage 


ED_FM_EVENT_FIRE
event_message - not used , but you can send something like "engine fire" or "left wing tank fire"
event_params[0] fire control handle, index used to control change of effect in time 

event_params[1] 
event_params[2] 
event_params[3]  x , y ,z  coordinates of fire origin in aircraft body space
 
event_params[4] 
event_params[5] 
event_params[6]  x , y ,z  components of orientation of emitter direction

event_params[7]  emitted particles speed 

event_params[8]  scale of fire , if scale will less or equal to zero , fire with this index will be stopped 


ED_FM_EVENT_CARRIER_CATAPULT
--event_message - "engine fire" or "left wing tank fire"
--event_params[0] fire control handle, index used to control change of effect in time 
--event_params[1] 
--event_params[2] 
--event_params[3]  x , y ,z  coordinates of fire origin in aircraft body space



*/
/*

ED_FM_EVENT_CARRIER_CATAPULT

comments from developer for latest available realization - from 2.5.1
For takeoff from carrier:

 1. Add connector "launch_bar_point" to nose gearpost connect point to catapult shuttle. Use draw argument 85 for launch bar animation.

 2. Catch the event after born on carrier with catapult (use ed_fm_push_simulation_event) 
 you can use it for example to init launch bar state

 in.event_type = ED_FM_EVENT_CARRIER_CATAPULT 
 in.event_params[0] = 1; 

 3. Catapult will ask you start conditions (throttle or thrust has takeoff value), so throw the event any time that conditions changed:

 out.event_type = ED_FM_EVENT_CARRIER_CATAPULT 
 out.event_params[0] = (1 if ready for takeoff, 0 if not) 


 and here you can give additional params for physics (if not or zero - then default):

 out.event_params[1] = 3; //start delay [sec] 
 out.event_params[2] = 67; //required velocity after takeoff [meters per sec] (+ with safety reserve; func of mass) 
 out.event_params[3] = 0.5*9.8*mass; //mean engines thrust during takeoff [N] (func of mass) 

 without this event catapult is waiting for afterburner flag

 4. Catch the event after start running if you want:

 in.event_type = ED_FM_EVENT_CARRIER_CATAPULT 
 in.event_params[0] = 2; 

 5. Catch the event after end of running (leaving carrier) if you want:

 in.event_type = ED_FM_EVENT_CARRIER_CATAPULT 
 in.event_params[0] = 3; 


 ---------------------------------------------------------------------------
 For landing to carrier:

 1. Add connector "hook_point" to the end of hook. Use draw argument 25 for hook animation.
 2. Add the segment element "HOOK" to collision model.
*/

// bool ed_fm_push_simulation_event(const ed_fm_simulation_event & in) // same as pop . but function direction is reversed -> DCS will call it for your FM when ingame event occurs
typedef bool (*PFN_FM_PUSH_SIMULATION_EVENT) (const ed_fm_simulation_event & in);


struct ed_fm_suspension_info
{
	double acting_force		[3];
	double acting_force_point[3];
	double integrity_factor;
	double struct_compression;
	double wheel_speed_X;
};
/*
	void ed_fm_suspension_feedback(int idx,const ed_fm_suspension_info * info)
	feedback to your fm about suspension state
*/
typedef void (*PFN_FM_SUSPENSION_FEEDBACK) (int idx,const ed_fm_suspension_info * info);



/*
LERX VORTEX EFFECT DATA , as it complex effect with very specific realization for each aircraft , we decide to make separate API
*/
struct LERX_vortex_spline_point
{
	///location in aircraft body frame
	float pos[3];
	///speed in aircraft body frame
	float vel[3];
	///vortex radius in that point
	float radius;
	///opacity per point , will be modulated by LERX_vortex::opacity , used only in LERX_vortex::version > 0
	float opacity;
	
};

const unsigned LERX_vortex_spline_point_size = sizeof(LERX_vortex_spline_point);

struct LERX_vortex
{	
	///overall vortex opacity level
	float opacity 											= 1.0f;
	///distance of vortex burst point location - in meters from spline start
	float explosion_start									= 1.0f;
	//pointer to points data , when spline is NULL - existed vortex will be detached 
	LERX_vortex_spline_point * spline 			   		   = nullptr;
	//amount of points
	unsigned 				   spline_points_count 		   = 0;
	///sizeof  LERX_vortex_spline_point 
	///used when you store more data in derived structure
	unsigned 				   spline_point_size_in_bytes = LERX_vortex_spline_point_size;
	///versioning : > 0 - per point opacity 
	unsigned 				   version 					  = 0;
};

/*
	bool ed_fm_LERX_vortex_update(unsigned idx,LERX_vortex & out)
	idx - index of vortex ; 0 - left side , 1 - right side , others is not specified 
	control animation of lerx vortex effects of your airframe

	LERX_vortex out;

	while (ed_fm_LERX_vortex_update(idx,out))
	{	
		if (!out.spline || !out.spline_points_count)
		{
			if (vortex_exist(idx))
				vortex_detach(idx);
		}
		else
		{
			if (vortex_exist(idx))
				vortex_update(idx,out);
			else
				vortex_create(idx,out);
		}
		++idx;
	}
*/
typedef bool (*PFN_FM_LERX_VORTEX_UPDATE) (unsigned idx,LERX_vortex & out);

