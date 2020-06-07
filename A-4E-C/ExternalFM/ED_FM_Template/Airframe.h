#ifndef AIRFRAME_H
#define AIRFRAME_H
#pragma once
#include "Input.h"
#include <stdio.h>
#include "Engine.h"
namespace Skyhawk
{//begin namespace



#define c_aileronUp 0.35
#define c_aileronDown -0.35

#define c_elevatorUp 0.3
#define c_elevatorDown -0.35

#define c_rudderRight 0.35
#define c_rudderLeft -0.35

#define c_flapUp 0.0
#define c_flapDown 0.52

#define c_speedBrakeIn 0.0
#define c_speedBrakeOut 1.0

#define c_maxfuel 2137.8

class Airframe
{
public:

	enum CatapultState
	{
		ON_CAT_READY,
		ON_CAT_NOT_READY,
		ON_CAT_WAITING,
		ON_CAT_LAUNCHING,
		OFF_CAT
	};



	Airframe(Input& controls, Engine& engine);
	~Airframe();
	void zeroInit();
	void coldInit();
	void hotInit();
	void airborneInit();

	//Utility
	inline void setGearPosition(double position); //for airstart or ground start
	inline void setSpoilerPosition(double position);
	inline void setSlatLPosition(double position);
	inline void setSlatRPosition(double position);
	inline void setFuelState(double fuel);
	inline void setFuelStateNorm(double fuel);

	inline double getGearPosition(); //returns gear pos
	inline double getFlapsPosition();
	inline double getSpoilerPosition();
	inline double getSpeedBrakePosition();
	inline double getHookPosition();
	inline double getSlatLPosition();
	inline double getSlatRPosition();
	inline double getFuelState();
	inline double getPrevFuelState();
	inline double getFuelStateNorm();
	inline double aileron();
	inline double elevator();
	inline double rudder();

	inline double aileronAngle();
	inline double elevatorAngle();
	inline double rudderAngle();

	inline const CatapultState& catapultState() const;
	inline CatapultState& catapultState();
	inline const bool& catapultStateSent() const;
	inline bool& catapultStateSent();
	inline void setCatStateFromKey();

	//Update
	void airframeUpdate(double dt); //performs calculations and updates
	inline void fuelUpdate(double dt);
	//Airframe Angles

private:

	//Airframe Constants
	const double m_gearExtendTime = 3.0;
	const double m_flapsExtendTime = 5.0;
	const double m_airbrakesExtendTime = 3.0;
	const double m_hookExtendTime = 1.5;
	const double m_slatsExtendTime = 0.25;


	//Airframe Variables
	double m_gearPosition = 0.0; //0 -> 1
	double m_flapsPosition = 0.0;
	double m_spoilerPosition = 0.0;
	double m_speedBrakePosition = 0.0;
	double m_hookPosition = 0.0;
	double m_slatLPosition = 0.0;
	double m_slatRPosition = 0.0;

	double m_aileronLeft = 0.0;
	double m_aileronRight = 0.0;
	double m_elevator = 0.0;
	double m_rudder = 0.0;

	double m_fuel = 0.0;
	double m_fuelPrevious = 0.0;

	CatapultState m_catapultState = OFF_CAT;
	bool m_catStateSent = false;

	Engine& m_engine;
	Input& m_controls;
};

void Airframe::fuelUpdate(double dt)
{
	m_fuel -= m_engine.getFuelFlow() * dt;
}

void Airframe::setFuelState(double fuel)
{
	printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nFUEL: %lf, this: %p\n", fuel, this);
	m_fuel = fuel;
	m_fuelPrevious = fuel;
}

void Airframe::setFuelStateNorm(double fuel)
{
	m_fuel = c_maxfuel * fuel;
	m_fuelPrevious = c_maxfuel * fuel;
}

void Airframe::setGearPosition(double position)
{
	m_gearPosition = position;
}

double Airframe::getGearPosition()
{
	return m_gearPosition;
}

double Airframe::getFlapsPosition()
{
	return m_flapsPosition;
}

double Airframe::getSpoilerPosition()
{
	return m_spoilerPosition;
}

double Airframe::getSpeedBrakePosition()
{
	return m_speedBrakePosition;
}

double Airframe::getHookPosition()
{
	return m_hookPosition;
}

double Airframe::getSlatLPosition()
{
	return m_slatLPosition;
}

double Airframe::getSlatRPosition()
{
	return m_slatRPosition;
}

double Airframe::aileron()
{
	return m_aileronLeft;
}

double Airframe::elevator()
{
	return m_elevator;
}

double Airframe::rudder()
{
	return m_rudder;
}

double Airframe::aileronAngle()
{
	return 	m_aileronLeft > 0.0 ? c_aileronUp * m_aileronLeft : -c_aileronDown * m_aileronLeft;
}

double Airframe::elevatorAngle()
{
	return m_elevator > 0.0 ? -c_elevatorUp * m_elevator : c_elevatorDown * m_elevator;
}

double Airframe::rudderAngle()
{
	return m_rudder > 0.0 ? c_rudderRight * m_rudder : -c_rudderLeft * m_rudder;
}

void Airframe::setSlatLPosition(double position)
{
	m_slatLPosition = position;
}

void Airframe::setSlatRPosition(double position)
{
	m_slatRPosition = position;
}

void Airframe::setSpoilerPosition(double position)
{
	m_spoilerPosition = position;
}

const Airframe::CatapultState& Airframe::catapultState() const
{
	return m_catapultState;
}

Airframe::CatapultState& Airframe::catapultState()
{
	return m_catapultState;
}

const bool& Airframe::catapultStateSent() const
{
	return m_catStateSent;
}

bool& Airframe::catapultStateSent()
{
	return m_catStateSent;
}

void Airframe::setCatStateFromKey()
{
	switch (m_catapultState)
	{
	case ON_CAT_NOT_READY:
	case ON_CAT_READY:
	case ON_CAT_WAITING:
		printf("OFF_CAT\n");
		m_catapultState = OFF_CAT;
		break;
	case OFF_CAT:
		printf("ON_CAT_NOT_READY\n");
		m_catapultState = ON_CAT_NOT_READY;
		break;
	}
}

double Airframe::getFuelState()
{
	return m_fuel;
}

double Airframe::getPrevFuelState()
{
	return m_fuelPrevious;
}

double Airframe::getFuelStateNorm()
{
	return m_fuel / c_maxfuel;
}

}//end namespace

#endif
