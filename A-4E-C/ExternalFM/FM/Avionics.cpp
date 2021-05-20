//=========================================================================//
//
//		FILE NAME	: Avionics.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Avionics class handles the any C/C++ side avionics. This
//						is the the yaw damper and the CP741/A bombing computer.
//
//================================ Includes ===============================//
#include "Avionics.h"
#include "Maths.h"
#include "Commands.h"
#include "Devices.h"
#include "cockpit_base_api.h"
//=========================================================================//

#define STAB_AUG_MAX_AUTHORITY 0.3
#define MAX_ROTATION_RATE 1.6

Scooter::Avionics::Avionics
(
	Input& input,
	AircraftState& state,
	Interface& inter
) :
	m_input(input),
	m_state(state),
	m_interface(inter),
	m_bombingComputer(state),
	m_adc(inter, state)
{
	zeroInit();
}

Scooter::Avionics::~Avionics()
{

}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Scooter::Avionics::zeroInit()
{
	m_x = 0.0;
}

void Scooter::Avionics::coldInit()
{
	zeroInit();
	ed_cockpit_dispatch_action_to_device( DEVICES_AVIONICS, DEVICE_COMMANDS_OXYGEN_SWITCH, 0.0 );
}

void Scooter::Avionics::hotInit()
{
	zeroInit();
	ed_cockpit_dispatch_action_to_device( DEVICES_AVIONICS, DEVICE_COMMANDS_OXYGEN_SWITCH, 1.0 );
}

void Scooter::Avionics::airborneInit()
{
	zeroInit();
	ed_cockpit_dispatch_action_to_device( DEVICES_AVIONICS, DEVICE_COMMANDS_OXYGEN_SWITCH, 1.0 );
}

bool Scooter::Avionics::handleInput( int command, float value )
{
	switch ( command )
	{
	case DEVICE_COMMANDS_OXYGEN_SWITCH:
		m_oxygen = (value == 1.0f);
		return true;
	}

	return false;
}

void Scooter::Avionics::updateAvionics(double dt)
{

	//printf( "Omega.y: %lf\n", m_state.getOmega().y );
	if ( m_damperEnabled )
	{
		double omega = m_state.getOmega().y;
		if ( fabs( omega ) > MAX_ROTATION_RATE )
		{
			omega = 0.0;
		}


		double f = washoutFilter( omega, dt ) * m_baseGain * (1.0 / (m_state.getMach() + 1));
		m_input.yawDamper() = clamp(f,-STAB_AUG_MAX_AUTHORITY, STAB_AUG_MAX_AUTHORITY); //f
	}
	else
	{
		m_x = 0.0;
		m_input.yawDamper() = 0.0;
	}
	m_bombingComputer.updateSolution();
	m_adc.update(dt);

	//printf("Filter: %lf, Rudder: %lf\n", f, m_flightModel.yawRate());
}