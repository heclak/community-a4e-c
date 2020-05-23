#ifndef AIRFRAME_H
#define AIRFRAME_H
#pragma once
#include "Input.h"
#include <stdio.h>
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


class Airframe
{
public:
	Airframe(Input& controls);
	~Airframe();
	void zeroInit();
	void coldInit();
	void hotInit();
	void airborneInit();

	//Utility
	inline void setGearPosition(double position); //for airstart or ground start
	inline void setSpoilerPosition(double position);
	inline void setSlatsPosition(double position);

	inline double getGearPosition(); //returns gear pos
	inline double getFlapsPosition();
	inline double getSpoilerPosition();
	inline double getSpeedBrakePosition();
	inline double getHookPosition();
	inline double getSlatsPosition();
	inline double aileron();
	inline double elevator();
	inline double rudder();

	inline double aileronAngle();
	inline double elevatorAngle();
	inline double rudderAngle();

	//Update
	void airframeUpdate(double dt); //performs calculations and updates

	//Airframe Angles

private:

	//Airframe Constants
	const double m_gearExtendTime = 3.0;
	const double m_flapsExtendTime = 5.0;
	const double m_airbrakesExtendTime = 3.0;



	//Airframe Variables
	double m_gearPosition = 0.0; //0 -> 1
	double m_flapsPosition = 0.0;
	double m_spoilerPosition = 0.0;
	double m_speedBrakePosition = 0.0;
	double m_hookPosition = 0.0;
	double m_slatsPosition = 0.0;

	double m_aileronLeft = 0.0;
	double m_aileronRight = 0.0;
	double m_elevator = 0.0;
	double m_rudder = 0.0;

	Input& m_controls;
};

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

double Airframe::getSlatsPosition()
{
	return m_slatsPosition;
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

void Airframe::setSpoilerPosition(double position)
{
	m_spoilerPosition = position;
}

}//end namespace

#endif
