#pragma once
#ifndef AVIONICS_H
#define AVIONICS_H
//=========================================================================//
//
//		FILE NAME	: Avionics.h
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Avionics class handles the any C/C++ side avionics. This
//						is the the yaw damper and the CP741/A bombing computer.
//
//================================ Includes ===============================//
#include "Maths.h"
#include "BaseComponent.h"
#include "Input.h"
#include "AircraftState.h"
#include "CP741.h"
#include "Interface.h"
#include "AirDataComputer.h"
//=========================================================================//

namespace Scooter
{//begin namespace

class Avionics : public BaseComponent
{
public:
	Avionics(Input& input, AircraftState& state, Interface& inter);
	~Avionics();
	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	void updateAvionics(double dt);
	inline void setYawDamperPower( bool power );
	inline bool getValidBombingSolution();
	inline bool getOxygen();
	
	bool handleInput( int command, float value );

	inline CP741& getComputer();
private:

	//constants
	const double m_timeConstant = 4.5; //was 4.5
	const double m_baseGain = 2.5;

	inline double washoutFilter(double input, double dt);
	double m_x = 0.0;

	Input& m_input;
	AircraftState& m_state;
	Interface& m_interface;

	CP741 m_bombingComputer;
	AirDataComputer m_adc;

	bool m_damperEnabled = false;

	bool m_oxygen = true;
};

bool Avionics::getOxygen()
{
	return m_oxygen;
}

double Avionics::washoutFilter(double input, double dt)
{
	double sampleRatio = dt / m_timeConstant;
	m_x = clamp((1.0 - (sampleRatio)) * m_x + sampleRatio * input, -0.1,0.1);
	return input - m_x;
}

void Avionics::setYawDamperPower( bool power )
{
	m_damperEnabled = power;
}

bool Avionics::getValidBombingSolution()
{

}

CP741& Avionics::getComputer()
{
	return m_bombingComputer;
}

}//end namespace
#endif