#ifndef AVIONICS_H
#define AVIONICS_H
#pragma once
#include "BaseComponent.h"
#include "Input.h"
#include "AircraftMotionState.h"
namespace Skyhawk
{//begin namespace

class Avionics : public BaseComponent
{
public:
	Avionics(Input& input, AircraftMotionState& state);
	~Avionics();
	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	void updateAvionics(double dt);
private:

	//constants
	const double m_timeConstant = 4.5;
	const double m_baseGain = 1.0;

	inline double washoutFilter(double input, double dt);
	double m_x = 0.0;

	Input& m_input;
	AircraftMotionState& m_state;
};

double Avionics::washoutFilter(double input, double dt)
{
	double sampleRatio = dt / m_timeConstant;
	m_x = (1.0 - (sampleRatio)) * m_x + sampleRatio * input;
	return input - m_x;
}


}//end namespace
#endif