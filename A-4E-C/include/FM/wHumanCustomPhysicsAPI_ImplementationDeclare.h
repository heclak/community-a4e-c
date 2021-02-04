#pragma once
#include "FM\wHumanCustomPhysicsAPI.h"

#ifndef EXPORT_ED_FM_PHYSICS_IMP
//declare as classic declspec prior including this file 
#define EXPORT_ED_FM_PHYSICS_IMP	 
#endif
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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_add_local_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_add_global_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);

/* same but in component form , return value bool : function will be called until return value is true
while (ed_fm_add_local_force_component(x,y,z,pos_xpos_y,pos_z))
{
	--collect 
}
ed_fm_add_local_force_component
ed_fm_add_global_force_component
*/
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_add_local_force_component (double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_add_global_force_component(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);

/*
Pointer to function of moment source in body axis 
prototype for 
ed_fm_add_local_moment
ed_fm_add_global_moment
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_add_local_moment (double & x,double &y,double &z);
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_add_global_moment(double & x,double &y,double &z);

/* same but in component form , return value bool : function will be called until return value is true
while (ed_fm_add_local_moment_component(x,y,z))
{
	--collect 
}
ed_fm_add_local_moment_component
ed_fm_add_global_moment_component
*/
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_add_local_moment_component  (double & x,double &y,double &z);
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_add_global_moment_component (double & x,double &y,double &z);

/*
simulate will be called on each step, all your FM should be evaluated here,
result of simulation will be called later as forces and moment sources

prototype for

ed_fm_simulate
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_simulate (double dt);


/*
called before simulation to set up your environment for the next step

prototype for

ed_fm_set_surface    give parameters of surface under your aircraft usefull for ground effect
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_surface (double		h,//surface height under the center of aircraft
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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_atmosphere(double h,//altitude above sea level
								   double t,//current atmosphere temperature , Kelwins
								   double a,//speed of sound
								   double ro,// atmosphere density
								   double p,// atmosphere pressure
								   double wind_vx,//components of velocity vector, including turbulence in world coordinate system
								   double wind_vy,//components of velocity vector, including turbulence in world coordinate system
								   double wind_vz //components of velocity vector, including turbulence in world coordinate system
								   );
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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_wind_vector_field_update_request(wind_vector_field & in_out);
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_wind_vector_field_done();


/*
called before simulation to set up your environment for the next step

prototype for

ed_fm_set_current_mass_state
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_current_mass_state(double mass,
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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_current_state(double ax,//linear acceleration component in world coordinate system
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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_current_state_body_axis (double ax,//linear acceleration component in body coordinate system
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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_command(int command,
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
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_change_mass(double & delta_mass,
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
EXPORT_ED_FM_PHYSICS_IMP void   ed_fm_set_internal_fuel  (double fuel);

/*
	get internal fuel volume 
	
	prototype for ed_fm_get_internal_fuel

*/
EXPORT_ED_FM_PHYSICS_IMP double ed_fm_get_internal_fuel  ();

/*
	set external fuel volume for each payload station , called for weapon init and on reload
	
	prototype for ed_fm_set_external_fuel

*/
EXPORT_ED_FM_PHYSICS_IMP void   ed_fm_set_external_fuel  (int	 station,
										  double fuel,
										  double x,
										  double y,
										  double z);
/*
	get external fuel volume 
	
	prototype for ed_fm_get_external_fuel
*/
EXPORT_ED_FM_PHYSICS_IMP double ed_fm_get_external_fuel  ();


/*
	incremental adding of fuel in case of refueling process 
	
	prototype for ed_fm_refueling_add_fuel(double fuel);

	(optional , if function doesnt exist  ed_fm_set_internal_fuel will be called in the next manner 

		ed_fm_set_internal_fuel(ed_fm_get_internal_fuel() + additional_fuel);
	)
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_refueling_add_fuel  (double fuel);

/*
	update draw arguments for your aircraft 
	prototype for ed_fm_set_draw_args
	also same prototype is used for ed_fm_set_fc3_cockpit_draw_args  : direct control over cockpit arguments , it can be use full for FC3 cockpits reintegration with new flight model 
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_draw_args  (EdDrawArgument * array,size_t size);
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_fc3_cockpit_draw_args  (EdDrawArgument * array,size_t size);

/*
shake level amplitude for head simulation , 
prototype for ed_fm_get_shake_amplitude 
*/
EXPORT_ED_FM_PHYSICS_IMP double ed_fm_get_shake_amplitude ();  

/*
will be called for your internal configuration
ed_fm_configure
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_configure (const char * cfg_path);
/*
will be called for your internal configuration
void ed_fm_release   called when fm not needed anymore : aircraft death etc.
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_release ();


/*
various param call back to proper integrate your FM to DCS , like engine RPM , thrust etc
ed_fm_get_param
*/

EXPORT_ED_FM_PHYSICS_IMP double ed_fm_get_param  (unsigned param_enum);

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
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_cold_start ();
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_hot_start   ();
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_hot_start_in_air   ();

/* 
ed_fm_make_balance
for experts only : called  after ed_fm_hot_start_in_air for balance FM at actual speed and height , it is directly force aircraft dynamic data in case of success 
*/
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_make_balance (double & ax,//linear acceleration component in world coordinate system);
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
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_enable_debug_info();

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
EXPORT_ED_FM_PHYSICS_IMP size_t ed_fm_debug_watch(int level, char *buffer,size_t maxlen);

// void ed_fm_set_plugin_data_install_path(const char * )  path to your plugin installed
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_plugin_data_install_path (const char *);

// damages and failures
// void ed_fm_on_planned_failure(const char * ) callback when preplaneed failure triggered from mission 
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_on_planned_failure (const char *);

// void ed_fm_on_damage(int Element, double element_integrity_factor) callback when damage occurs for airframe element 
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_on_damage (int Element, double element_integrity_factor);

// void ed_fm_repair()  called in case of repair routine 
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_repair ();

// bool ed_fm_need_to_be_repaired()  in case of some internal damages or system failures this function return true , to switch on repair process
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_need_to_be_repaired ();

// void ed_fm_set_immortal(bool value)  inform about  invulnerability settings
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_immortal(bool value);
// void ed_fm_unlimited_fuel(bool value)  inform about  unlimited fuel
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_unlimited_fuel(bool value);
// void ed_fm_set_easy_flight(bool value)  inform about simplified flight model request 
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_easy_flight(bool value);

// void ed_fm_set_property_numeric(const char * property_name,float value)   custom properties sheet 
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_property_numeric(const char * property_name,float value);
// void ed_fm_set_property_string(const char * property_name,const char * value)   custom properties sheet 
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_set_property_string(const char * property_name,const char * value);

//inform DCS about internal simulation event, like structure damage , failure , or effect
// bool ed_fm_pop_simulation_event(ed_fm_simulation_event & out)  called on each sim step 
/*
	ed_fm_simulation_event event;
	while (ed_fm_pop_simulation_event(event))
	{
		do some with event data;
	}
*/
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_pop_simulation_event (ed_fm_simulation_event & out);

// bool ed_fm_push_simulation_event(const ed_fm_simulation_event & in) // same as pop . but function direction is reversed -> DCS will call it for your FM when ingame event occurs
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_push_simulation_event(const ed_fm_simulation_event & in);
/*
	void ed_fm_suspension_feedback(int idx,const ed_fm_suspension_info * info)
	feedback to your fm about suspension state
*/
EXPORT_ED_FM_PHYSICS_IMP void ed_fm_suspension_feedback (int idx,const ed_fm_suspension_info * info);

/*
	bool ed_fm_LERX_vortex_update(unsigned idx,LERX_vortex & out)
	control animation of lerx vortex effects of your airframe
*/
EXPORT_ED_FM_PHYSICS_IMP bool ed_fm_LERX_vortex_update(unsigned idx,LERX_vortex & out);

