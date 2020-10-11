// ED_FM_Template.cpp : Defines the exported functions for the DLL application.
//#include "ED_FM_Utility.h"
#include "stdafx.h"
//#include "A-4_Aero.h"
#include "Globals.h"
#include "Skyhawk.h"
#include <Math.h>
#include <stdio.h>
#include <string>
#include "Vec3.h"
#include "Input.h"
#include "FlightModel.h"
#include "Airframe.h"
#include "Engine.h"
#include "Avionics.h"
#include "Interface.h"
//============================ Skyhawk Statics ============================//
static Skyhawk::Interface s_interface;
static Skyhawk::Input s_input;
static Skyhawk::Engine2 s_engine;
static Skyhawk::Airframe s_airframe(s_input, s_engine);
static Skyhawk::FlightModel s_fm(s_input, s_airframe, s_engine, s_interface);
static Skyhawk::Avionics s_avionics(s_input, s_fm, s_engine, s_airframe);


//========================================================================//

double  throttle		  = 0;
double  stick_roll		  = 0;
double  stick_pitch		  = 0;

double  internal_fuel     = 0;
double  fuel_consumption_since_last_time  = 0;
double s_mass = 0;
Vec3 s_pos;


void ed_fm_add_local_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{
	x = s_fm.getForce().x;
	y = s_fm.getForce().y;
	z = s_fm.getForce().z;

	pos_x = s_fm.getCOM().x;
	pos_y = s_fm.getCOM().y;
	pos_z = s_fm.getCOM().z;
}

void ed_fm_add_global_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{
	/*y = s_mass * 9.81;
	Vec3 pos = s_pos - s_fm.getCOM();
	pos_x = pos.x;
	pos_y = pos.y;
	pos_z = pos.z;*/
}

void ed_fm_add_global_moment(double & x,double &y,double &z)
{

}

void ed_fm_add_local_moment(double & x,double &y,double &z)
{
	x = s_fm.getMoment().x;
	y = s_fm.getMoment().y;
	z = s_fm.getMoment().z + s_airframe.getCatMoment();
}

void ed_fm_simulate(double dt)
{
	if ( ! g_safeToRun )
		return;

	//Pre update
	s_fm.setCockpitShakeModifier( s_interface.getCockpitShake() );
	s_airframe.setFlapsPosition(s_interface.getFlaps());
	s_airframe.setSpoilerPosition(s_interface.getSpoilers());
	s_airframe.setAirbrakePosition(s_interface.getSpeedBrakes());
	s_airframe.setGearLPosition( s_interface.getGearLeft() );
	s_airframe.setGearRPosition( s_interface.getGearRight() );
	s_airframe.setGearNPosition( s_interface.getGearNose() );


	s_input.pitchTrim() = s_interface.getPitchTrim();
	s_input.rollTrim() = s_interface.getRollTrim();
	s_input.yawTrim() = s_interface.getRudderTrim();


	//printf("Throttle: %lf\n", s_interface.getEngineThrottlePosition());
	s_engine.setThrottle(s_interface.getEngineThrottlePosition());
	s_engine.setBleedAir(s_interface.getBleedAir() > 0.1);
	s_engine.setIgnitors(s_interface.getIgnition() > 0.1);

	//Update
	s_engine.updateEngine(dt);
	s_airframe.airframeUpdate(dt);
	s_avionics.updateAvionics(dt);
	s_fm.calculateForcesAndMoments(dt);

	//Post update
	s_interface.setRPM(s_engine.getRPMNorm()*100.0);
	s_interface.setThrottlePosition(s_input.throttleNorm());
	s_interface.setStickPitch(s_input.pitch() + s_input.pitchTrim());
	s_interface.setStickRoll(s_input.roll() + s_input.rollTrim());
	s_interface.setRudderPedals(s_input.yaw() + s_input.yawTrim());
	s_interface.setInternalFuel(s_airframe.getFuelQty(Skyhawk::Airframe::Tank::INTERNAL));
	s_interface.setExternalFuel(s_airframe.getFuelQtyExternal());
}

void ed_fm_set_atmosphere(
							double h,//altitude above sea level
							double t,//current atmosphere temperature , Kelwins
							double a,//speed of sound
							double ro,// atmosphere density
							double p,// atmosphere pressure
							double wind_vx,//components of velocity vector, including turbulence in world coordinate system
							double wind_vy,//components of velocity vector, including turbulence in world coordinate system
							double wind_vz //components of velocity vector, including turbulence in world coordinate system
						)
{
	s_fm.setAtmosphericParams(ro, a, Vec3(wind_vx, wind_vy, wind_vz));
	s_engine.setTemperature( t );
}
/*
called before simulation to set up your environment for the next step
*/
void ed_fm_set_current_mass_state 
(
	double mass,
	double center_of_mass_x,
	double center_of_mass_y,
	double center_of_mass_z,
	double moment_of_inertia_x,
	double moment_of_inertia_y,
	double moment_of_inertia_z
)
{
	s_mass = mass;
	s_airframe.setMass(mass);
	s_fm.setCOM(Vec3(center_of_mass_x, center_of_mass_y, center_of_mass_z));
}
/*
called before simulation to set up your environment for the next step
*/
void ed_fm_set_current_state
(
	double ax,//linear acceleration component in world coordinate system
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
)
{
	s_fm.setWorldVelocity(Vec3(vx, vy, vz));
	s_pos = Vec3(px, py, pz);
}


void ed_fm_set_current_state_body_axis
(
	double ax,//linear acceleration component in body coordinate system
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
)
{
	s_fm.setPhysicsParams(common_angle_of_attack, common_angle_of_slide, Vec3(yaw, pitch, roll), Vec3(omegax, omegay, omegaz), Vec3(omegadotx, omegadoty, omegadoty), Vec3(vx - wind_vx, vy - wind_vy, vz - wind_vz), Vec3(ax, ay, az));
	s_airframe.setAngle(pitch);

	//aoa = common_angle_of_attack;
	//beta = common_angle_of_slide;
	//rx = omegax;
	//ry = omegay;
	//rz = omegaz;
}

void ed_fm_on_damage( int element, double element_integrity_factor )
{
	s_airframe.setIntegrityElement((Skyhawk::Airframe::Damage)element, (float)element_integrity_factor);
}

/*
input handling
*/
void ed_fm_set_command
(
	int command,
	float value
)
{
	switch (command)
	{
	case Skyhawk::Control::PITCH:
		s_input.pitch() = value;
		break;
	case Skyhawk::Control::ROLL:
		s_input.roll() = value;
		break;
	case Skyhawk::Control::YAW:
		s_input.yaw() = value;
		break;
	case Skyhawk::Control::THROTTLE:
		s_input.throttle() = value;
		break;
	case Skyhawk::Control::BRAKE:
		s_input.brakeLeft() = value;
		s_input.brakeRight() = value;
		break;
	case Skyhawk::Control::LEFT_BRAKE:
		s_input.brakeLeft() = value;
		break;
	case Skyhawk::Control::RIGHT_BRAKE:
		s_input.brakeRight() = value;
		break;
	case Skyhawk::Control::HOOK_TOGGLE:
		s_input.hook() = !s_input.hook();
		break;
	case Skyhawk::Control::NOSEWHEEL_STEERING_ENGAGE:
		//s_input.nosewheelSteering() = true;
		break;
	case Skyhawk::Control::NOSEWHEEL_STEERING_DISENGAGE:
		//s_input.nosewheelSteering() = false;
		break;
	default:
		;// printf( "number %d: %lf\n", command, value );
	}
}

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

bool ed_fm_change_mass  (double & delta_mass,
						double & delta_mass_pos_x,
						double & delta_mass_pos_y,
						double & delta_mass_pos_z,
						double & delta_mass_moment_of_inertia_x,
						double & delta_mass_moment_of_inertia_y,
						double & delta_mass_moment_of_inertia_z
						)
{
	Skyhawk::Airframe::Tank tank = s_airframe.getSelectedTank();
	Vec3 pos = s_airframe.getFuelPos(tank);
	Vec3 r = pos - s_fm.getCOM();

	delta_mass = s_airframe.getFuelQtyDelta(tank);
	s_airframe.setFuelPrevious( tank );
	//printf( "dm = %lf\n", delta_mass );
	delta_mass_pos_x = pos.x;
	delta_mass_pos_y = pos.y;
	delta_mass_pos_z = pos.z;

	if (tank == Skyhawk::Airframe::Tank::RIGHT_EXT)
	{
		s_airframe.setSelectedTank(Skyhawk::Airframe::Tank::INTERNAL);
		return false;
	}
	else
	{
		s_airframe.setSelectedTank((Skyhawk::Airframe::Tank)((int)tank + 1));
		return true;
	}
}
/*
	set internal fuel volume , init function, called on object creation and for refueling , 
	you should distribute it inside at different fuel tanks
*/
void ed_fm_set_internal_fuel(double fuel)
{
	s_airframe.setFuelState(Skyhawk::Airframe::Tank::INTERNAL, s_fm.getCOM(), fuel);
	//printf("INTERNAL: %lf\n", s_airframe.getFuelQty(Skyhawk::Airframe::Tank::INTERNAL));
}
/*
	get internal fuel volume 
*/
double ed_fm_get_internal_fuel()
{
	return s_airframe.getFuelQty(Skyhawk::Airframe::Tank::INTERNAL);

}
/*
	set external fuel volume for each payload station , called for weapon init and on reload
*/
void  ed_fm_set_external_fuel (int	 station,
								double fuel,
								double x,
								double y,
								double z)
{
	s_airframe.setFuelState((Skyhawk::Airframe::Tank)station, Vec3(x, y, z), fuel);
	printf("Station: %d, Fuel: %lf, x: %lf y: %lf z: %lf\n", station, fuel, x, y, z);
	printf("EXTERNAL TOTAL: %lf\n", ed_fm_get_external_fuel());
}
/*
	get external fuel volume 
*/
double ed_fm_get_external_fuel ()
{
	return s_airframe.getFuelQty(Skyhawk::Airframe::Tank::LEFT_EXT) + s_airframe.getFuelQty(Skyhawk::Airframe::Tank::CENTRE_EXT) + s_airframe.getFuelQty(Skyhawk::Airframe::Tank::RIGHT_EXT);
}

void ed_fm_set_draw_args (EdDrawArgument * drawargs,size_t size)
{
	drawargs[28].f   = (float)throttle;
	drawargs[29].f   = (float)throttle;

	if (size > 616)
	{	
		drawargs[611].f = drawargs[0].f;
		drawargs[614].f = drawargs[3].f;
		drawargs[616].f = drawargs[5].f;
	}

	drawargs[LEFT_AILERON].f = -s_airframe.aileron();
	drawargs[RIGHT_AILERON].f = s_airframe.aileron();

	drawargs[LEFT_ELEVATOR].f = s_airframe.elevator();
	drawargs[RIGHT_ELEVATOR].f = s_airframe.elevator();

	drawargs[RUDDER].f = -s_airframe.rudder();

	drawargs[LEFT_FLAP].f = s_airframe.getFlapsPosition();
	drawargs[RIGHT_FLAP].f = s_airframe.getFlapsPosition();

	drawargs[LEFT_SLAT].f = s_airframe.getSlatLPosition();
	drawargs[RIGHT_SLAT].f = s_airframe.getSlatRPosition();

	drawargs[AIRBRAKE].f = s_airframe.getSpeedBrakePosition();



	//s_airframe.setSpoilerPosition((drawargs[LEFT_SPOILER].f + drawargs[RIGHT_SPOILER].f)/2.0);

	drawargs[HOOK].f = s_airframe.getHookPosition();

	drawargs[85].f = 1.0;
	/*drawargs[LEFT_GEAR].f = s_airframe.getGearPosition();
	drawargs[RIGHT_GEAR].f = s_airframe.getGearPosition();
	drawargs[NOSE_GEAR].f = s_airframe.getGearPosition();
	drawargs[LEFT_GEAR_SHOCK].f = s_airframe.getGearPosition();
	drawargs[RIGHT_GEAR_SHOCK].f = s_airframe.getGearPosition();
	drawargs[NOSE_GEAR_SHOCK].f = s_airframe.getGearPosition();*/

}


void ed_fm_configure(const char * cfg_path)
{

}

double test_gear_state = 0;
double ed_fm_get_param(unsigned index)
{


	switch (index)
	{/*
	case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_2_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_0_DOWN_LOCK:
	case ED_FM_SUSPENSION_1_DOWN_LOCK:
	case ED_FM_SUSPENSION_2_DOWN_LOCK:
	case ED_FM_SUSPENSION_0_UP_LOCK:
	case ED_FM_SUSPENSION_1_UP_LOCK:
	case ED_FM_SUSPENSION_2_UP_LOCK:
		return s_airframe.getGearPosition();*/


	case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_0_DOWN_LOCK:
	case ED_FM_SUSPENSION_0_UP_LOCK:
		return s_airframe.getGearNPosition();
	case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_1_DOWN_LOCK:
	case ED_FM_SUSPENSION_1_UP_LOCK:
		return s_airframe.getGearLPosition();
	case ED_FM_SUSPENSION_2_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_2_DOWN_LOCK:
	case ED_FM_SUSPENSION_2_UP_LOCK:
		return s_airframe.getGearRPosition();

	case ED_FM_ANTI_SKID_ENABLE:
	case ED_FM_CAN_ACCEPT_FUEL_FROM_TANKER:
		return 1.0;
	case ED_FM_ENGINE_1_CORE_RPM:
	case ED_FM_ENGINE_1_RPM:
		return s_engine.getRPM();

	case ED_FM_ENGINE_1_TEMPERATURE:
		return 23.0;

	case ED_FM_ENGINE_1_OIL_PRESSURE:
		return 600.0;

	case ED_FM_OXYGEN_SUPPLY:
		return 101000.0;

	case ED_FM_FLOW_VELOCITY:
		return 1.0;

	case ED_FM_ENGINE_1_FUEL_FLOW:
		return s_engine.getFuelFlow();

	case ED_FM_ENGINE_1_CORE_RELATED_THRUST:
	case ED_FM_ENGINE_1_RELATED_THRUST:
	case ED_FM_ENGINE_1_RELATED_RPM:
	case ED_FM_ENGINE_1_CORE_RELATED_RPM:
		return s_engine.getRPMNorm();

	case ED_FM_ENGINE_1_CORE_THRUST:
	case ED_FM_ENGINE_1_THRUST:
		return s_fm.thrust();
	case ED_FM_ENGINE_1_COMBUSTION:
		return s_engine.getFuelFlow() / c_maxFuelFlow;
	case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT:
		//printf("BrakeLeft: %lf\n", s_input.normalise(s_input.brakeLeft()));
		return s_input.normalise(s_input.brakeLeft());
	case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT:
		//printf("BrakeRight: %lf\n", s_input.normalise(s_input.brakeRight()));
		return s_input.normalise(s_input.brakeRight());
	case ED_FM_SUSPENSION_0_WHEEL_SELF_ATTITUDE:
		//return 1.0;
		return s_interface.getNWS() > 0.5 ? 0.0 : 1.0;
	case ED_FM_SUSPENSION_0_WHEEL_YAW:
		return s_interface.getNWS() > 0.5 ? -s_input.yaw()/4.0 : 0.0;
	}

	return 0;

}

bool ed_fm_pop_simulation_event(ed_fm_simulation_event& out)
{
	if (s_airframe.catapultState() == Skyhawk::Airframe::ON_CAT_NOT_READY && !s_airframe.catapultStateSent())
	{
		out.event_type = ED_FM_EVENT_CARRIER_CATAPULT;
		out.event_params[0] = 0;
		s_airframe.catapultStateSent() = true;
		return true;
	}
	else if (s_airframe.catapultState() == Skyhawk::Airframe::ON_CAT_READY)
	{
		out.event_type = ED_FM_EVENT_CARRIER_CATAPULT;
		out.event_params[0] = 1;
		out.event_params[1] = 3.0f;
		out.event_params[2] = 70.0f;
		out.event_params[3] = s_airframe.getMass()*9.81*0.5;
		//out.event_params[3] = 300000.0f; //fucking lol
		s_airframe.catapultState() = Skyhawk::Airframe::ON_CAT_WAITING;
		return true;
	}
	else
	{
		Skyhawk::Airframe::Damage damage;
		float integrity;
		if ( s_airframe.processDamageStack( damage, integrity ) )
		{
			out.event_type = ED_FM_EVENT_STRUCTURE_DAMAGE;
			out.event_params[0] = (float)damage;
			out.event_params[1] = integrity;

			return true;
		}
	}

	return false;
}

bool ed_fm_push_simulation_event(const ed_fm_simulation_event& in)
{
	if (in.event_type == ED_FM_EVENT_CARRIER_CATAPULT)
	{
		if (in.event_params[0] == 1)
		{
			s_airframe.catapultState() = Skyhawk::Airframe::ON_CAT_NOT_READY;
		}
		else if (in.event_params[0] == 2)
		{
			s_airframe.catapultState() = Skyhawk::Airframe::ON_CAT_LAUNCHING;
		}
		else if (in.event_params[0] == 3)
		{
			if (s_airframe.catapultState() == Skyhawk::Airframe::ON_CAT_LAUNCHING)
			{
				s_airframe.catapultState() = Skyhawk::Airframe::OFF_CAT;
			}
			else
			{
				s_airframe.catapultState() = Skyhawk::Airframe::OFF_CAT;
			}
		}
	}
	return true;
}


void ed_fm_cold_start()
{
	s_input.coldInit();
	s_fm.coldInit();
	s_airframe.coldInit();
	s_engine.coldInit();
	s_avionics.coldInit();
}

void ed_fm_hot_start()
{
	s_input.hotInit();
	s_fm.hotInit();
	s_airframe.hotInit();
	s_engine.hotInit();
	s_avionics.hotInit();
}

void ed_fm_hot_start_in_air()
{
	s_input.airbornInit();
	s_fm.airbornInit();
	s_airframe.airborneInit();
	s_engine.airbornInit();
	s_avionics.airbornInit();
}

void ed_fm_repair ()
{
	s_airframe.resetDamage();
}

bool ed_fm_add_local_force_component( double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z )
{
	return false;
}

bool ed_fm_add_global_force_component( double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z )
{
	return false;
}

bool ed_fm_add_local_moment_component( double & x,double &y,double &z )
{
	return false;
}

bool ed_fm_add_global_moment_component( double & x,double &y,double &z )
{
	return false;
}

double ed_fm_get_shake_amplitude()
{
	return s_fm.getCockpitShake();
}

bool ed_fm_enable_debug_info()
{
	return false;
}

void ed_fm_suspension_feedback(int idx, const ed_fm_suspension_info* info)
{
	//printf("Force(%lf, %lf, %lf)\n", info->acting_force[0], info->acting_force[1], info->acting_force[2]);
	//printf("Position(%lf, %lf, %lf)\n", info->acting_force_point[0], info->acting_force_point[1], info->acting_force_point[2]);
	//printf("Struct Compression %d: %lf\n", idx, info->struct_compression);
	//printf("Integrity Factor: %lf", info->integrity_factor);
}
