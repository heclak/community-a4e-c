#include "AircraftMotionState.h"

Skyhawk::AircraftMotionState::AircraftMotionState()
{
	zeroInit();
}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Skyhawk::AircraftMotionState::zeroInit()
{
	m_worldVelocity = Vec3();
	m_angle = Vec3();
	m_omega = Vec3();
	m_omegaDot = Vec3();
	m_localAirspeed = Vec3();
	m_localAcceleration = Vec3();

	m_aoa = 0.0;
	m_beta = 0.0;
	m_mach = 0.0;
}

void Skyhawk::AircraftMotionState::coldInit()
{
	zeroInit();
}

void Skyhawk::AircraftMotionState::hotInit()
{
	zeroInit();
}

void Skyhawk::AircraftMotionState::airborneInit()
{
	zeroInit();
}