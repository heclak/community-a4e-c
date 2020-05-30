#ifndef AVIONICS_H
#define AVIONICS_H
#pragma once
#include "Input.h"
#include "Airframe.h"
#include "Engine.h"
#include "FlightModel.h"
namespace Skyhawk
{//begin namespace

class Avionics
{
public:
	Avionics(Input& input, FlightModel& flightModel, Engine& engine, Airframe& airframe);
	~Avionics();
	void coldInit();
	void hotInit();
	void airbornInit();


	void updateAvionics(double dt);
	void yawCAS();

private:

	//constants
	const double m_timeConstant = 4.5;
	const double m_baseGain = 1.0;

	inline double washoutFilter(double input, double dt);
	double m_x = 0.0;

	//Ties to all other systems
	Input& m_input;
	FlightModel& m_flightModel;
	Engine& m_engine;
	Airframe& m_airframe;

};

double Avionics::washoutFilter(double input, double dt)
{
	double sampleRatio = dt / m_timeConstant;
	m_x = (1.0 - (sampleRatio)) * m_x + sampleRatio * input;
	return input - m_x;
}


}//end namespace
#endif