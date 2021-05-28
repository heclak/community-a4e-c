//=========================================================================//
//
//		FILE NAME	: Scooter.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: March 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Contains the exported function definitions called by 
//						Eagle Dynamics.
//
//================================ Includes ===============================//
#include "stdafx.h"
#include "Globals.h"
#include "Scooter.h"
#include <Math.h>
#include <stdio.h>
#include <string>
#include "Vec3.h"
#include "Input.h"
#include "FlightModel.h"
#include "Airframe.h"
#include "Avionics.h"
#include "Interface.h"
#include "AircraftState.h"
#include "Radio.h"
#include "FuelSystem2.h"
#include "Maths.h"
#include "LuaVM.h"
#include "LERX.h"
#include "ILS.h"
#include "Commands.h"
#include "Beacon.h"

//============================= Statics ===================================//
static Scooter::AircraftState* s_state = NULL;
static Scooter::Interface* s_interface = NULL;
static Scooter::Input* s_input = NULL;
static Scooter::Engine2* s_engine = NULL;
static Scooter::Airframe* s_airframe = NULL;
static Scooter::FlightModel* s_fm = NULL;
static Scooter::Avionics* s_avionics = NULL;
static Scooter::Radio* s_radio = NULL;
static Scooter::FuelSystem2* s_fuelSystem = NULL;
static LuaVM* s_luaVM = NULL;
static Scooter::ILS* s_ils = NULL;

static std::vector<LERX> s_splines;

static Scooter::Beacon* s_beacon = NULL;

//========================== Static Functions =============================//
static void init( const char* config );
static void cleanup();
static inline double rawAOAToUnits( double rawAOA );

//=========================================================================//

//Courtesy of SilentEagle
static inline int decodeClick( float& value )
{
	float deviceID;
	float normalised = modf( value, &deviceID );
	value = normalised * 8.0f - 2.0f;
	return (int)deviceID;
}

void init(const char* config)
{
	srand( 741 );
	s_luaVM = new LuaVM;

	char configFile[200];
	sprintf_s( configFile, 200, "%s/Config/config.lua", config );
	s_luaVM->dofile( configFile );
	s_luaVM->getSplines( "splines", s_splines );

	s_state = new Scooter::AircraftState;
	s_interface = new Scooter::Interface;
	s_input = new Scooter::Input;
	s_engine = new Scooter::Engine2( *s_state );
	s_airframe = new Scooter::Airframe( *s_state, *s_input, *s_engine );
	s_avionics = new Scooter::Avionics( *s_input, *s_state, *s_interface );
	s_fm = new Scooter::FlightModel( *s_state, *s_input, *s_airframe, *s_engine, *s_interface, s_splines );
	s_radio = new Scooter::Radio(*s_interface);
	s_ils = new Scooter::ILS(*s_interface);
	s_fuelSystem = new Scooter::FuelSystem2( *s_engine, *s_state );
	s_beacon = new Scooter::Beacon(*s_interface);
	
}

void cleanup()
{
	delete s_luaVM;
	delete s_state;
	delete s_interface;
	delete s_input;
	delete s_engine;
	delete s_airframe;
	delete s_avionics;
	delete s_fm;
	delete s_radio;
	delete s_ils;
	delete s_fuelSystem;
	delete s_beacon;

	s_luaVM = NULL;
	s_state = NULL;
	s_interface = NULL;
	s_input = NULL;
	s_engine = NULL;
	s_airframe = NULL;
	s_avionics = NULL;
	s_fm = NULL;
	s_radio = NULL;
	s_ils = NULL;
	s_fuelSystem = NULL;
	s_beacon = NULL;

	s_splines.clear();
}

double rawAOAToUnits( double rawAOA )
{
	return c_gradAOA* toDegrees(rawAOA) + c_constAOA;
}

void ed_fm_add_local_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{
	x = s_fm->getForce().x;
	y = s_fm->getForce().y;
	z = s_fm->getForce().z;

	pos_x = s_fm->getCOM().x;
	pos_y = s_fm->getCOM().y;
	pos_z = s_fm->getCOM().z;
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
	x = s_fm->getMoment().x;
	y = s_fm->getMoment().y;
	z = s_fm->getMoment().z + s_airframe->getCatMoment();
}

void ed_fm_simulate(double dt)
{
	if ( ! g_safeToRun )
		return;

	//Pre update
	if ( s_interface->getAvionicsAlive() )
	{
		//s_sidewinder->init();
		//s_sidewinder->update();
		//s_ils->test();
		//s_ils->update();
		s_state->setRadarAltitude( s_interface->getRadarAltitude() );
		s_avionics->setYawDamperPower( s_interface->getYawDamper() > 0.5 );
		s_fm->setCockpitShakeModifier( s_interface->getCockpitShake() );
		s_airframe->setFlapsPosition( s_interface->getFlaps() );
		s_airframe->setSpoilerPosition( s_interface->getSpoilers() );
		s_airframe->setAirbrakePosition( s_interface->getSpeedBrakes() );
		s_airframe->setGearLPosition( s_interface->getGearLeft() );
		s_airframe->setGearRPosition( s_interface->getGearRight() );
		s_airframe->setGearNPosition( s_interface->getGearNose() );

		s_fuelSystem->setFuelCapacity( 
			s_interface->getLTankCapacity(),
			s_interface->getCTankCapacity(),
			s_interface->getRTankCapacity() 
		);

		s_avionics->getComputer().setGunsightAngle( s_interface->getGunsightAngle() );
		s_avionics->getComputer().setTarget( s_interface->getSetTarget(), s_interface->getSlantRange() );
		s_avionics->getComputer().setPower( s_interface->getCP741Power() );

		s_input->pitchTrim() = s_interface->getPitchTrim();
		s_input->rollTrim() = s_interface->getRollTrim();
		s_input->yawTrim() = s_interface->getRudderTrim();


		//printf( "x: %lf, y: %lf, z: %lf, mass: %lf\n", s_state->getCOM().x, s_state->getCOM().y, s_state->getCOM().z, s_airframe->getMass() );
		s_engine->setThrottle( s_interface->getEngineThrottlePosition() );
		s_engine->setBleedAir( s_interface->getBleedAir() > 0.1 );
		s_engine->setIgnitors( s_interface->getIgnition() > 0.1 );

		s_state->setGForce( s_interface->getGForce() );

		s_fuelSystem->setBoostPumpPower( s_interface->getElecMonitoredAC() );


	}

	//Update
	s_input->update();
	s_radio->update();
	s_engine->updateEngine(dt);
	s_airframe->airframeUpdate(dt);
	s_fuelSystem->update( dt );
	s_avionics->updateAvionics(dt);
	s_fm->calculateAero(dt);
	s_beacon->update();

	//Post update
	s_interface->setRPM(s_engine->getRPMNorm()*100.0);
	s_interface->setFuelFlow( s_engine->getFuelFlow() );

	s_interface->setThrottlePosition(s_input->throttleNorm());
	s_interface->setStickPitch(s_airframe->getElevator());
	s_interface->setStickRoll(s_airframe->getAileron());
	s_interface->setRudderPedals(s_input->yawAxis().getValue());
	s_interface->setLeftBrakePedal( s_input->brakeLeft() );
	s_interface->setRightBrakePedal( s_input->brakeRight() );

	s_interface->setStickInputPitch( s_input->pitch() );
	s_interface->setStickInputRoll( s_input->roll() );

	s_interface->setInternalFuel( s_fuelSystem->getFuelQtyInternal() );
	s_interface->setExternalFuel( s_fuelSystem->getFuelQtyExternal() );
	s_interface->setAOA( s_state->getAOA() );
	s_interface->setBeta( s_state->getBeta() );
	s_interface->setAOAUnits( rawAOAToUnits(s_state->getAOA()) );
	s_interface->setValidSolution( s_avionics->getComputer().getSolution() );
	s_interface->setTargetSet( s_avionics->getComputer().getTargetSet() );
	s_interface->setInRange( s_avionics->getComputer().inRange() );

	s_interface->setLeftSlat( s_airframe->getSlatLPosition() );
	s_interface->setRightSlat( s_airframe->getSlatRPosition() );

	s_interface->setUsingFFB( s_input->getFFBEnabled() );

	//s_interface->setEngineStall( s_engine->stalled() ); Disabled for beta-5 re-enable when ready.

	//Starting to try to move some of these tests into the cpp. Make it less spaghetti.
	//Ultimately we should move this into the avionics class.
	s_interface->setFuelTransferCaution( s_interface->getElecPrimaryAC() && (s_interface->getMasterTest() || s_fuelSystem->getFuelTransferCaution()) );
	s_interface->setFuelBoostCaution( s_interface->getElecPrimaryAC() && (s_interface->getMasterTest() || s_fuelSystem->getFuelBoostCaution()) );
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

	s_state->setCurrentAtmosphere( t, a, ro, p, Vec3( wind_vx, wind_vy, wind_vz ) );
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
	//printf( "Mass: %lf\n", mass );
	s_airframe->setMass(mass);
	Vec3 com = Vec3( center_of_mass_x, center_of_mass_y, center_of_mass_z );
	s_state->setCOM( com );
	s_fm->setCOM(com);
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
	Vec3 direction;

	double x = quaternion_x;
	double y = quaternion_y;
	double z = quaternion_z;
	double w = quaternion_w;

	double y2 = y + y;
	double z2 = z + z;

	double yy = y * y2;
	double zz = z * z2;

	double xy = x * y2;
	double xz = x * z2;

	double wz = w * z2;
	double wy = w * y2;


	direction.x = 1.0 - (yy + zz);
	direction.y = xy + wz;
	direction.z = xz - wy;

	s_state->setCurrentStateWorldAxis(Vec3(px, py, pz), Vec3(vx, vy, vz), direction);

	s_interface->setWorldAcceleration( Vec3( ax, ay, az ) );
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
	s_state->setCurrentStateBodyAxis(common_angle_of_attack, common_angle_of_slide, Vec3(roll, yaw, pitch), Vec3(omegax, omegay, omegaz), Vec3(omegadotx, omegadoty, omegadoty), Vec3(vx, vy, vz), Vec3(vx - wind_vx, vy - wind_vy, vz - wind_vz), Vec3(ax, ay, az));
}

void ed_fm_on_damage( int element, double element_integrity_factor )
{
	s_airframe->setIntegrityElement((Scooter::Airframe::Damage)element, (float)element_integrity_factor);
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
	case Scooter::Control::PITCH:
		s_input->pitch( value );
		break;
	case Scooter::Control::ROLL:
		s_input->roll( value );
		break;
	case Scooter::Control::YAW:
		s_input->yaw( value );
		break;
	case Scooter::Control::THROTTLE:
		s_input->throttle( value );
		break;
	case Scooter::Control::BRAKE:
		s_input->brakeLeft( value );
		s_input->brakeRight( value );
		break;
	case Scooter::Control::LEFT_BRAKE:
		s_input->brakeLeft( value );
		break;
	case Scooter::Control::RIGHT_BRAKE:
		s_input->brakeRight( value );
		break;
	case DEVICE_COMMANDS_WHEELBRAKE_AXIS:
		s_input->brakeLeft( value );
		s_input->brakeRight( value );
		break;
	case Scooter::Control::RUDDER_LEFT_START:
		s_input->yawAxis().keyDecrease();
		break;
	case Scooter::Control::RUDDER_LEFT_STOP:
		s_input->yawAxis().reset();
		break;
	case Scooter::Control::RUDDER_RIGHT_START:
		s_input->yawAxis().keyIncrease();
		break;
	case Scooter::Control::RUDDER_RIGHT_STOP:
		s_input->yawAxis().reset();
		break;
	case Scooter::Control::ROLL_LEFT_START:
		s_input->rollAxis().keyDecrease();
		break;
	case Scooter::Control::ROLL_LEFT_STOP:
		s_input->rollAxis().reset();
		break;
	case Scooter::Control::ROLL_RIGHT_START:
		s_input->rollAxis().keyIncrease();
		break;
	case Scooter::Control::ROLL_RIGHT_STOP:
		s_input->rollAxis().reset();
		break;
	case Scooter::Control::PITCH_DOWN_START:
		s_input->pitchAxis().keyDecrease();
		break;
	case Scooter::Control::PITCH_DOWN_STOP:
		s_input->pitchAxis().stop();
		break;
	case Scooter::Control::PITCH_UP_START:
		s_input->pitchAxis().keyIncrease();
		break;
	case Scooter::Control::PITCH_UP_STOP:
		s_input->pitchAxis().stop();
		break;
	case Scooter::Control::THROTTLE_DOWN_START:
		//Throttle is inverted for some reason in DCS
		s_input->throttleAxis().keyIncrease();
		break;
	case Scooter::Control::THROTTLE_STOP:
		s_input->throttleAxis().stop();
		break;
	case Scooter::Control::THROTTLE_UP_START:
		s_input->throttleAxis().keyDecrease();
		break;
	case KEYS_BRAKESON:
		s_input->leftBrakeAxis().keyIncrease();
		s_input->rightBrakeAxis().keyIncrease();
		break;
	case KEYS_BRAKESOFF:
		s_input->leftBrakeAxis().reset();
		s_input->rightBrakeAxis().reset();
		break;

	case KEYS_BRAKESONLEFT:
		s_input->leftBrakeAxis().keyIncrease();
		break;
	case KEYS_BRAKESOFFLEFT:
		s_input->leftBrakeAxis().reset();
		break;
	case KEYS_BRAKESONRIGHT:
		s_input->rightBrakeAxis().keyIncrease();
		break;
	case KEYS_BRAKESOFFRIGHT:
		s_input->rightBrakeAxis().reset();
		break;
	case KEYS_RADIO_PTT:
		s_radio->toggleRadioMenu();
		break;
	case KEYS_TOGGLESLATSLOCK:
		//Weight on wheels plus lower than 50 kts.
		if ( s_airframe->getNoseCompression() > 0.01 && magnitude(s_state->getLocalSpeed()) < 25.0 )
			s_airframe->toggleSlatsLocked();
		break;
	default:
		;// printf( "number %d: %lf\n", command, value );
	}

	if ( command >= 3000 && command < 4000 )
	{
		int deviceId = decodeClick( value );

		//Do this when we have more than one device to check.
		/*switch ( deviceId )
		{

		}*/

		if ( s_fuelSystem->handleInput( command, value ) )
			return;

		if ( s_avionics->handleInput( command, value ) )
			return;

		if ( s_engine->handleInput( command, value ) )
			return;
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
	Scooter::FuelSystem2::Tank tank = s_fuelSystem->getSelectedTank();
	if ( tank == Scooter::FuelSystem2::NUMBER_OF_TANKS )
	{
		s_fuelSystem->setSelectedTank( Scooter::FuelSystem2::TANK_FUSELAGE );
		return false;
	}

	Vec3 pos = s_fuelSystem->getFuelPos(tank);
	//Vec3 r = pos - s_state->getCOM();
	
	delta_mass = s_fuelSystem->getFuelQtyDelta(tank);
	s_fuelSystem->setFuelPrevious( tank );

	//printf( "Tank %d, Pos: %lf, %lf, %lf, dm: %lf\n", tank, pos.x, pos.y, pos.z, delta_mass );

	delta_mass_pos_x = pos.x;
	delta_mass_pos_y = pos.y;
	delta_mass_pos_z = pos.z;

	s_fuelSystem->setSelectedTank((Scooter::FuelSystem2::Tank)((int)tank + 1));
	return true;
}
/*
	set internal fuel volume , init function, called on object creation and for refueling , 
	you should distribute it inside at different fuel tanks
*/
void ed_fm_set_internal_fuel(double fuel)
{
	//printf( "Set internal fuel: %lf\n", fuel );
	s_fuelSystem->setInternal( fuel );
}

void ed_fm_refueling_add_fuel( double fuel )
{
	//printf( "Add fuel: %lf\n", fuel);
	bool airborne = ! (s_airframe->getNoseCompression() > 0.0) ;
	s_fuelSystem->addFuel( fuel, airborne );
}

/*
	get internal fuel volume 
*/
double ed_fm_get_internal_fuel()
{
	return s_fuelSystem->getFuelQtyInternal();
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
	//printf( "Station: %d, Fuel: %lf, Z: %lf, COM %lf\n", station, fuel, z, s_state->getCOM().z );
	s_fuelSystem->setFuelQty( (Scooter::FuelSystem2::Tank)(station + 1), Vec3( x, y, z ), fuel );
}
/*
	get external fuel volume 
*/
double ed_fm_get_external_fuel ()
{
	return s_fuelSystem->getFuelQtyExternal();
}

void ed_fm_set_draw_args (EdDrawArgument * drawargs,size_t size)
{

	if (size > 616)
	{	
		drawargs[611].f = drawargs[0].f;
		drawargs[614].f = drawargs[3].f;
		drawargs[616].f = drawargs[5].f;
	}

	drawargs[LEFT_AILERON].f = -s_airframe->getAileron();
	drawargs[RIGHT_AILERON].f = s_airframe->getAileron();

	drawargs[LEFT_ELEVATOR].f = s_airframe->getElevator();
	drawargs[RIGHT_ELEVATOR].f = s_airframe->getElevator();

	drawargs[RUDDER].f = -s_airframe->getRudder();

	drawargs[LEFT_FLAP].f = s_airframe->getFlapsPosition();
	drawargs[RIGHT_FLAP].f = s_airframe->getFlapsPosition();

	drawargs[LEFT_SLAT].f = s_airframe->getSlatLPosition();
	drawargs[RIGHT_SLAT].f = s_airframe->getSlatRPosition();

	drawargs[AIRBRAKE].f = s_airframe->getSpeedBrakePosition();

	//drawargs[HOOK].f = s_airframe->getHookPosition();

	drawargs[STABILIZER_TRIM].f = s_airframe->getStabilizerAnim();

	//Fan 325 RPM
	//drawargs[325].f = 1.0;

	//This is the launch bar argument.
	drawargs[85].f = 1.0;

	//This is the refueling probe argument.
	drawargs[22].f = 1.0;

}

double ed_fm_get_param(unsigned index)
{

	switch (index)
	{
	case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_0_DOWN_LOCK:
	case ED_FM_SUSPENSION_0_UP_LOCK:
		return s_airframe->getGearNPosition();
	case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_1_DOWN_LOCK:
	case ED_FM_SUSPENSION_1_UP_LOCK:
		return s_airframe->getGearLPosition();
	case ED_FM_SUSPENSION_2_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_2_DOWN_LOCK:
	case ED_FM_SUSPENSION_2_UP_LOCK:
		return s_airframe->getGearRPosition();

	case ED_FM_ANTI_SKID_ENABLE:
		break;
	case ED_FM_CAN_ACCEPT_FUEL_FROM_TANKER:
		return 1000.0;

	case ED_FM_ENGINE_1_CORE_RPM:
	case ED_FM_ENGINE_1_RPM:
		return s_engine->getRPM();

	case ED_FM_ENGINE_1_TEMPERATURE:
		return 23.0;

	case ED_FM_ENGINE_1_OIL_PRESSURE:
		return 600.0;

	case ED_FM_OXYGEN_SUPPLY:
		return s_avionics->getOxygen() ? 101000.0 : 0.0;

	case ED_FM_FLOW_VELOCITY:
		return s_avionics->getOxygen() ? 1.0 : 0.0;

	case ED_FM_ENGINE_1_FUEL_FLOW:
		return s_engine->getFuelFlow();

	case ED_FM_ENGINE_1_RELATED_THRUST:
	case ED_FM_ENGINE_1_CORE_RELATED_THRUST:
		return s_engine->getThrust() / c_maxStaticThrust;
	case ED_FM_ENGINE_1_RELATED_RPM:
		return s_engine->getRPMNorm();
	case ED_FM_ENGINE_1_CORE_RELATED_RPM:
		//return 0.0;
		return s_engine->getRPMNorm();

	case ED_FM_ENGINE_1_CORE_THRUST:
	case ED_FM_ENGINE_1_THRUST:
		return s_engine->getThrust();
	case ED_FM_ENGINE_1_COMBUSTION:
		return s_engine->getFuelFlow() / c_fuelFlowMax;
	case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT:
		return s_interface->getChocks() ? 1.0 : s_input->brakeLeft();
	case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT:
		return s_interface->getChocks() ? 1.0 : s_input->brakeRight();
	case ED_FM_SUSPENSION_0_WHEEL_SELF_ATTITUDE:
		return s_interface->getNWS() > 0.5 ? 0.0 : 1.0;
	case ED_FM_SUSPENSION_0_WHEEL_YAW:
		return s_interface->getNWS() > 0.5 ? -s_input->yaw() * 0.5 : 0.0; //rotation to 45 degrees, half 90 (range of the wheel)
	case ED_FM_STICK_FORCE_CENTRAL_PITCH:  // i.e. trimmered position where force feeled by pilot is zero
		s_input->setFFBEnabled(true);
		return s_airframe->getElevatorZeroForceDeflection();
	case ED_FM_STICK_FORCE_FACTOR_PITCH:
		return s_input->getFFBPitchFactor();
	//case ED_FM_STICK_FORCE_SHAKE_AMPLITUDE_PITCH:
	//case ED_FM_STICK_FORCE_SHAKE_FREQUENCY_PITCH:

	case ED_FM_STICK_FORCE_CENTRAL_ROLL:   // i.e. trimmered position where force feeled by pilot is zero
		return s_input->rollTrim();
	case ED_FM_STICK_FORCE_FACTOR_ROLL:
		return s_input->getFFBRollFactor();
	//case ED_FM_STICK_FORCE_SHAKE_AMPLITUDE_ROLL:
	//case ED_FM_STICK_FORCE_SHAKE_FREQUENCY_ROLL:
	}

	return 0;

}

bool ed_fm_pop_simulation_event(ed_fm_simulation_event& out)
{
	if (s_airframe->catapultState() == Scooter::Airframe::ON_CAT_NOT_READY && !s_airframe->catapultStateSent())
	{
		out.event_type = ED_FM_EVENT_CARRIER_CATAPULT;
		out.event_params[0] = 0;
		s_airframe->catapultStateSent() = true;
		return true;
	}
	else if (s_airframe->catapultState() == Scooter::Airframe::ON_CAT_READY)
	{
		out.event_type = ED_FM_EVENT_CARRIER_CATAPULT;
		out.event_params[0] = 1;
		out.event_params[1] = 3.0f;
		out.event_params[2] = 60.0f + 20.0 * std::min(s_airframe->getMass() / c_maxTakeoffMass, 1.0);
		out.event_params[3] = s_engine->getThrust();
		s_airframe->catapultState() = Scooter::Airframe::ON_CAT_WAITING;
		return true;
	}
	else
	{
		Scooter::Airframe::Damage damage;
		float integrity;
		if ( s_airframe->processDamageStack( damage, integrity ) )
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
			s_airframe->catapultState() = Scooter::Airframe::ON_CAT_NOT_READY;
		}
		else if (in.event_params[0] == 2)
		{
			s_airframe->catapultState() = Scooter::Airframe::ON_CAT_LAUNCHING;
		}
		else if (in.event_params[0] == 3)
		{
			if (s_airframe->catapultState() == Scooter::Airframe::ON_CAT_LAUNCHING)
			{
				s_airframe->catapultState() = Scooter::Airframe::OFF_CAT;
			}
			else
			{
				s_airframe->catapultState() = Scooter::Airframe::OFF_CAT;
			}
		}
	}
	return true;
}


void ed_fm_cold_start()
{
	s_input->coldInit();
	s_fm->coldInit();
	s_airframe->coldInit();
	s_engine->coldInit();
	s_avionics->coldInit();
	s_state->coldInit();
	s_fuelSystem->coldInit();
}

void ed_fm_hot_start()
{
	s_input->hotInit();
	s_fm->hotInit();
	s_airframe->hotInit();
	s_engine->hotInit();
	s_avionics->hotInit();
	s_state->hotInit();
	s_fuelSystem->hotInit();
}

void ed_fm_hot_start_in_air()
{
	s_input->airborneInit();
	s_fm->airborneInit();
	s_airframe->airborneInit();
	s_engine->airborneInit();
	s_avionics->airborneInit();
	s_state->airborneInit();
	s_fuelSystem->airborneInit();
}

void ed_fm_repair()
{
	s_airframe->resetDamage();
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
	return s_fm->getCockpitShake();
}

bool ed_fm_enable_debug_info()
{
	return false;
}

void ed_fm_suspension_feedback(int idx, const ed_fm_suspension_info* info)
{
	if ( idx == 0 )
	{
		s_airframe->setNoseCompression( info->struct_compression );
	}
		
	//
	//("Force(%lf, %lf, %lf)\n", info->acting_force[0], info->acting_force[1], info->acting_force[2]);
	//printf("Position(%lf, %lf, %lf)\n", info->acting_force_point[0], info->acting_force_point[1], info->acting_force_point[2]);
	//printf("Struct Compression %d: %lf\n", idx, info->struct_compression);
	//printf("Integrity Factor: %lf", info->integrity_factor);
}

void ed_fm_set_plugin_data_install_path ( const char* path )
{
#ifdef LOGGING
	char logFile[200];
	sprintf_s( logFile, 200, "%s/efm_log.txt", path );
	fopen_s( &g_log, logFile, "a+" );
#endif
	printf( "%s\n", srcvers );

	LOG_BREAK();
	LOG( "Begin Log, %s\n", srcvers );
	LOG( "Initialising Components...\n" );

	init(path);

	g_safeToRun = isSafeContext();
}

void ed_fm_configure ( const char* cfg_path )
{

}

void ed_fm_release ()
{
	cleanup();
	g_safeToRun = false;
#ifdef LOGGING
	LOG( "Releasing Components...\n" );
	LOG( "Closing Log...\n" );
	if ( g_log )
	{
		fclose( g_log );
		g_log = NULL;
	}
#endif
}

bool ed_fm_LERX_vortex_update( unsigned idx, LERX_vortex& out )
{
	if ( idx < s_splines.size() )
	{
		out.opacity = s_splines[idx].getOpacity();//clamp((s_state->getAOA() - 0.07) / 0.174533, 0.0, 0.8);
		out.explosion_start = 10.0;
		out.spline = s_splines[idx].getArrayPointer();
		out.spline_points_count = s_splines[idx].size();
		out.spline_point_size_in_bytes = LERX_vortex_spline_point_size;
		out.version = 0;
		return true;
	}

	return false;
}

void ed_fm_set_immortal( bool value )
{
	if ( value )
		printf( "Nice try!\n" );
}
