#include "ED_FM_TemplateAPI.h"
#include "../../include/FM/wHumanCustomPhysicsAPI.h"

extern "C" 
{
	/*/////////////////////////////////////////////////////////////////////////
	function of force source in body axis 
	x,y,z			  - force components in body coordinate system
	pos_x,pos_y,pos_z - position of force source in body coordinate system 

	body coordinate system system is always X - positive forward ,
											Y - positive up,
											Z - positive to right 
	*/
	ED_FM_TEMPLATE_API void ed_fm_add_local_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);
	ED_FM_TEMPLATE_API void ed_fm_add_global_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);
	
	/* same but in component form , return value bool : function will be called until return value is true
		while (ed_fm_add_local_force_component(x,y,z,pos_xpos_y,pos_z))
		{
			--collect 
		}
		ed_fm_add_local_force_component
		ed_fm_add_global_force_component
	*/
	ED_FM_TEMPLATE_API bool ed_fm_add_local_force_component(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);
	ED_FM_TEMPLATE_API bool ed_fm_add_global_force_component(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z);

	ED_FM_TEMPLATE_API void ed_fm_add_global_moment(double & x,double &y,double &z);
	ED_FM_TEMPLATE_API void ed_fm_add_local_moment(double & x,double &y,double &z);
	
	/* same but in component form , return value bool : function will be called until return value is true
	while (ed_fm_add_local_moment_component(x,y,z))
	{
		--collect 
	}
	ed_fm_add_local_moment_component
	ed_fm_add_global_moment_component
	*/
	ED_FM_TEMPLATE_API bool ed_fm_add_local_moment_component(double & x,double &y,double &z);
	
	ED_FM_TEMPLATE_API bool ed_fm_add_global_moment_component(double & x,double &y,double &z);

	ED_FM_TEMPLATE_API void ed_fm_simulate(double dt);

	ED_FM_TEMPLATE_API void ed_fm_set_atmosphere(double h,//altitude above sea level
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
	*/
	ED_FM_TEMPLATE_API void ed_fm_set_current_mass_state (double mass,
										double center_of_mass_x,
										double center_of_mass_y,
										double center_of_mass_z,
										double moment_of_inertia_x,
										double moment_of_inertia_y,
										double moment_of_inertia_z
										);
	/*
	called before simulation to set up your environment for the next step
	*/
	ED_FM_TEMPLATE_API void ed_fm_set_current_state (double ax,//linear acceleration component in world coordinate system
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
	ED_FM_TEMPLATE_API void ed_fm_set_current_state_body_axis(double ax,//linear acceleration component in body coordinate system
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
	*/
	ED_FM_TEMPLATE_API void ed_fm_set_command (int command,
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
	ED_FM_TEMPLATE_API bool ed_fm_change_mass  (double & delta_mass,
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
	*/
	ED_FM_TEMPLATE_API void   ed_fm_set_internal_fuel(double fuel);
	/*
		get internal fuel volume 
	*/
	ED_FM_TEMPLATE_API double ed_fm_get_internal_fuel();
	/*
		set external fuel volume for each payload station , called for weapon init and on reload
	*/
	ED_FM_TEMPLATE_API void  ed_fm_set_external_fuel (int	 station,
														double fuel,
														double x,
														double y,
														double z);
	/*
		get external fuel volume 
	*/
	ED_FM_TEMPLATE_API double ed_fm_get_external_fuel ();
	
	ED_FM_TEMPLATE_API void ed_fm_set_draw_args (EdDrawArgument * drawargs,size_t size);
	ED_FM_TEMPLATE_API void ed_fm_configure		(const char * cfg_path);


	ED_FM_TEMPLATE_API double ed_fm_get_param(unsigned index);

	/*
	call backs for diffrenrt starting conditions
	*/
	ED_FM_TEMPLATE_API void ed_fm_cold_start();
	ED_FM_TEMPLATE_API void ed_fm_hot_start();
	ED_FM_TEMPLATE_API void ed_fm_hot_start_in_air();

};