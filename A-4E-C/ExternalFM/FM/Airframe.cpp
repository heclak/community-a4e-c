//=========================================================================//
//
//		FILE NAME	: Airframe.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Airframe class handles the current state of each parameter
//						for the airframe. This includes things like fuel, control
//						surfaces and damage.
//
//================================ Includes ===============================//
#include "Airframe.h"
#include <algorithm>
//=========================================================================//

Scooter::Airframe::Airframe(AircraftState& state, Input& controls, Engine2& engine) :
	m_state(state),
	m_controls(controls),
	m_engine(engine),
	m_actuatorElev(5.0)
{
	m_integrityElement = new float[(int)Damage::COUNT];
	zeroInit();

	m_damageStack.reserve( 10 );
}

Scooter::Airframe::~Airframe()
{
	delete[] m_integrityElement;
}

void Scooter::Airframe::printDamageState()
{
	printf( "===========================================\n" );

	printf( "            ||\n" );
	printf( "            ||\n" );
	printf( "%.1lf %.1lf %.1lf || %.1lf %.1lf %.1lf\n", 
		DMG_ELEM(Damage::WING_L_OUT), 
		DMG_ELEM(Damage::WING_L_CENTER), 
		DMG_ELEM(Damage::WING_L_IN),
		DMG_ELEM( Damage::WING_R_IN ),
		DMG_ELEM( Damage::WING_R_CENTER ),
		DMG_ELEM( Damage::WING_R_OUT ) );

	printf( "        %.1f || %.1f\n", DMG_ELEM(Damage::AILERON_L), DMG_ELEM(Damage::AILERON_R) );
	printf( "            ||\n" );
	printf( "        %.1f || %.1f\n", DMG_ELEM( Damage::STABILIZATOR_L ), DMG_ELEM( Damage::STABILIZATOR_R ) );
	printf( "        %.1f || %.1f\n", DMG_ELEM( Damage::ELEVATOR_L ), DMG_ELEM( Damage::ELEVATOR_R ) );
	printf( "            %.1f\n", getVertStabDamage() );
	printf( "            %.1f\n", getRudderDamage() );
}

void Scooter::Airframe::resetDamage()
{
	for ( int i = 0; i < (int)Damage::COUNT; i++ )
	{
		m_integrityElement[i] = 1.0f;
	}
}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Scooter::Airframe::zeroInit()
{
	m_gearLPosition = 0.0;
	m_gearRPosition = 0.0;
	m_gearNPosition = 0.0;

	m_flapsPosition = 0.0;
	m_spoilerPosition = 0.0;
	m_speedBrakePosition = 0.0;
	m_hookPosition = 0.0;
	m_slatLPosition = 0.0;
	m_slatRPosition = 0.0;

	m_aileronLeft = 0.0;
	m_aileronRight = 0.0;
	m_elevator = 0.0;
	m_rudder = 0.0;
	m_stabilizer = 0.0;
	m_noseWheelAngle = 0.0;

	resetDamage();

	m_mass = 1.0;


	m_catapultState = CatapultState::OFF_CAT;
	m_catStateSent = false;
	m_catMoment = 0.0;
	m_angle = 0.0;
	m_noseCompression = 0.0;

	m_damageStack.clear();
	m_slatsLocked = false;
}

void Scooter::Airframe::coldInit()
{
	zeroInit();
}

void Scooter::Airframe::hotInit()
{
	zeroInit();
}

void Scooter::Airframe::airborneInit()
{
	zeroInit();
}

void Scooter::Airframe::airframeUpdate(double dt)
{
	//printf( "I %lf, L %lf, C %lf, R %lf\n", m_fuel[0], m_fuel[1], m_fuel[2], m_fuel[3] );

	if (m_controls.hook())
	{
		m_hookPosition += dt / m_hookExtendTime;
		m_hookPosition = std::min(m_hookPosition, 1.0);
	}
	else
	{
		m_hookPosition -= dt / m_hookExtendTime;
		m_hookPosition = std::max(m_hookPosition, 0.0);
	}

	//printf("LEFT: %lf, CENTRE: %lf, RIGHT: %lf, INTERNAL: %lf\n", m_fuel[Tank::LEFT_EXT], m_fuel[Tank::CENTRE_EXT], m_fuel[Tank::RIGHT_EXT], m_fuel[Tank::INTERNAL]);
	//m_engine.setHasFuel(m_fuel[Tank::INTERNAL] > 20.0);

	//printf( "Compressor Damage %lf, Turbine Damage: %lf\n", getCompressorDamage(), getTurbineDamage() );


	//m_engine.setCompressorDamage( getCompressorDamage() );
	//m_engine.setCompressorDamage( 1.0 );
	m_engine.setIntegrity( DMG_ELEM( Damage::ENGINE ) );
	//m_engine.setTurbineDamage( getTurbineDamage() );
	//m_engine.setTurbineDamage( 1.0 );
	
	m_stabilizer = setStabilizer(dt);
	m_elevator = setElevator(dt);
	m_aileronLeft = setAileron(dt);
	m_aileronRight = -m_aileronLeft;
	m_rudder = setRudder(dt);


	if (m_catapultState == ON_CAT_NOT_READY && m_engine.getRPMNorm() > 0.9)
	{
		m_catapultState = ON_CAT_READY;
	}

	

	if (m_catapultState != OFF_CAT)
	{
		if ( m_catapultState != ON_CAT_LAUNCHING )
		{
			m_catAngle = m_state.getAngle().z;
			//m_catMoment = -c_catConstantMoment;
		}
		else
		{
			m_catMoment = -c_catConstantMoment + std::max ( pow( ( m_catAngle - m_state.getAngle().z - 0.07 ) * 60.0, 3.0 ) * c_catConstrainingForce, -500000.0 );
		}
		//printf( "Cat Moment: %lf\n", m_catMoment );
	}
	else
	{
		m_catMoment = 0.0;
		m_catMomentVelocity = 0.0; 
		m_prevAccel = 0.0;
		m_catForce = 0.0;
	}
	//printf("Cat Moment: %lf\n", m_catMoment);

	m_catStateSent = false;

	//printDamageState();
}