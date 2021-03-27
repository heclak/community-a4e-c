#pragma once
#ifndef AIRCRAFT_MOTION_STATE_H
#define AIRCRAFT_MOTION_STATE_H
//=========================================================================//
//
//		FILE NAME	: AircraftState.h
//		AUTHOR		: Joshua Nelson
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	State class contains the current state for the aircraft
//						to make accessing certain parameters much easier from
//						different locations.
//
//================================ Includes ===============================//
#include "BaseComponent.h"
#include <math.h>
#include "Vec3.h"
//=========================================================================//

namespace Scooter
{

class AircraftState : public BaseComponent
{
public:
	AircraftState();
	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	inline void setCurrentStateBodyAxis(double aoa, double beta, const Vec3& angle, const Vec3& omega, const Vec3& omegaDot, const Vec3& speed, const Vec3& airspeed, const Vec3& acceleration);
	inline void setCurrentStateWorldAxis( const Vec3& worldPosition, const Vec3& worldVelocity, const Vec3& worldDirection );
	inline void setCurrentAtmosphere( double temperature, double speedOfSound, double density, double pressure, const Vec3& wind );

	inline void setMach( double mach );
	inline void setRadarAltitude( double altitude );
	inline void setCOM( const Vec3& com );
	inline void setGForce( const double gs );

	inline const Vec3& getWorldPosition() const;
	inline const Vec3& getWorldVelocity() const;
	inline const Vec3& getWorldDirection() const;
	inline const Vec3& getWorldWind() const;
	inline const Vec3& getAngle() const;
	inline const Vec3& getOmega() const;
	inline const Vec3& getOmegaDot() const;
	inline const Vec3& getLocalSpeed() const;
	inline const Vec3& getLocalAirspeed() const;
	inline const Vec3& getLocalAcceleration() const;

	inline const Vec3& getWorldWindVelocity() const;
	inline const double getPressure() const;
	inline const double getSpeedOfSound() const;
	inline const double getTemperature() const;
	inline const double getAirDensity() const;

	inline const double getAOA() const;
	inline const double getBeta() const;
	inline const double getMach() const;
	inline const double getRadarAltitude() const;

	inline const Vec3& getCOM() const;

	//This comes from lua, if you need faster updating g-force
	//Then calculate it from the global acceleration values.
	inline const double getGForce() const;




private:
	Vec3 m_worldPosition;
	Vec3 m_worldVelocity;
	Vec3 m_worldDirection;
	Vec3 m_worldWind;
	Vec3 m_angle;
	Vec3 m_omega;
	Vec3 m_omegaDot;
	Vec3 m_localSpeed;
	Vec3 m_localAirspeed;
	Vec3 m_localAcceleration;
	Vec3 m_com; //centre of mass
	double m_aoa;
	double m_beta;
	double m_mach;
	double m_speedOfSound;
	double m_airDensity;
	double m_temperature;
	double m_pressure;
	double m_radarAltitude;
	double m_gs;
};

	
void AircraftState::setCurrentStateBodyAxis( 
	double aoa, 
	double beta, 
	const Vec3& angle, 
	const Vec3& omega, 
	const Vec3& omegaDot,
	const Vec3& localSpeed,
	const Vec3& airspeed, 
	const Vec3& acceleration 
)
{
	m_aoa = aoa;
	m_beta = beta;
	m_angle = angle;
	m_omega = omega;
	m_omegaDot = omegaDot;
	m_localSpeed = localSpeed;
	m_localAirspeed = airspeed;
	m_localAcceleration = acceleration;
}

void AircraftState::setCurrentStateWorldAxis( 
	const Vec3& worldPosition,
	const Vec3& worldVelocity,
	const Vec3& worldDirection
)
{
	m_worldPosition = worldPosition;
	m_worldVelocity = worldVelocity;
	m_worldDirection = worldDirection;
}

void AircraftState::setCurrentAtmosphere( 
	double temperature, 
	double speedOfSound, 
	double density, 
	double pressure, 
	const Vec3& wind 
)
{
	m_temperature = temperature;
	m_speedOfSound = speedOfSound;
	m_airDensity = density;
	m_pressure = pressure;
	m_worldWind = wind;
}

void AircraftState::setMach( double mach )
{
	m_mach = mach;
}

void AircraftState::setCOM( const Vec3& com )
{
	m_com = com;
}

void AircraftState::setGForce( const double gs )
{
	m_gs = gs;
}

const Vec3& AircraftState::getWorldWindVelocity() const
{
	return m_worldWind;
}

const double AircraftState::getPressure() const
{
	return m_pressure;
}

const double AircraftState::getSpeedOfSound() const
{
	return m_speedOfSound;
}
const double AircraftState::getTemperature() const
{
	return m_temperature;
}

void AircraftState::setRadarAltitude( double altitude )
{
	m_radarAltitude = altitude;
}

const double AircraftState::getMach() const
{
	return m_mach;
}

const double AircraftState::getAirDensity() const
{
	return m_airDensity;
}

const Vec3& AircraftState::getWorldPosition() const
{
	return m_worldPosition;
}

const Vec3& AircraftState::getWorldVelocity() const
{
	return m_worldVelocity;
}

const Vec3& AircraftState::getWorldDirection() const
{
	return m_worldDirection;
}

const Vec3& AircraftState::getWorldWind() const
{
	return m_worldWind;
}

const Vec3& AircraftState::getAngle() const
{
	return m_angle;
}

const Vec3& AircraftState::getOmega() const
{
	return m_omega;
}

const Vec3& AircraftState::getOmegaDot() const
{
	return m_omegaDot;
}

const Vec3& AircraftState::getLocalSpeed() const
{
	return m_localSpeed;
}

const Vec3& AircraftState::getLocalAirspeed() const
{
	return m_localAirspeed;
}

const Vec3& AircraftState::getLocalAcceleration() const
{
	return m_localAcceleration;
}

const double AircraftState::getAOA() const
{
	return m_aoa;
}

const double AircraftState::getBeta() const
{
	return m_beta;
}

const double AircraftState::getRadarAltitude() const
{
	return m_radarAltitude;
}

const Vec3& AircraftState::getCOM() const
{
	return m_com;
}

const double AircraftState::getGForce() const
{
	return m_gs;
}

}




#endif