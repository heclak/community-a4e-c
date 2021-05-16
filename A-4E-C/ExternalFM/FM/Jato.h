#pragma once
//=========================================================================//
//
//		FILE NAME	: Jato.h
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Implementation for the Jato system.
//
//================================ Includes ===============================//
#include "Vec3.h"
#include "FlightModel.h"

#define c_fuel 5.0;

namespace Scooter
{
class Jato
{

public:

	Jato(FlightModel& fm);

	inline void fireLeft();
	inline void fireRight();

	void update( double dt );

private:

	double m_fuelLeft = c_fuel;
	double m_fuelRight = c_fuel;

	bool m_leftLit = false;
	bool m_rightLit = false;

	Vec3 m_forceLeft;
	Vec3 m_forceRight;

	Vec3 m_positionLeft;
	Vec3 m_positionRight;

	FlightModel& m_fm;
};

inline void Jato::fireLeft()
{
	m_leftLit = true;
	m_fuelLeft = c_fuel;
}

inline void Jato::fireRight()
{
	m_rightLit = true;
	m_fuelRight = c_fuel;
}

}
