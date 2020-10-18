#include "AircraftState.h"

Skyhawk::AircraftState::AircraftState()
{
	zeroInit();
}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Skyhawk::AircraftState::zeroInit()
{
	m_worldPosition = Vec3();
	m_worldVelocity = Vec3();
	m_worldDirection = Vec3();
	m_worldWind = Vec3();
	m_angle = Vec3();
	m_omega = Vec3();
	m_omegaDot = Vec3();
	m_localSpeed = Vec3();
	m_localAirspeed = Vec3();
	m_localAcceleration = Vec3();

	m_aoa = 0.0;
	m_beta = 0.0;
	m_mach = 0.0;
	m_airDensity = 0.0;
	m_pressure = 0.0;
	m_temperature = 0.0;
	m_speedOfSound = 0.0;
	m_radarAltitude = 0.0;
}

void Skyhawk::AircraftState::coldInit()
{
	zeroInit();
}

void Skyhawk::AircraftState::hotInit()
{
	zeroInit();
}

void Skyhawk::AircraftState::airborneInit()
{
	zeroInit();
}