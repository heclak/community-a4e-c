#ifndef ENGINE_H
#define ENGINE_H
#pragma once
#include "Table.h"
#include "Input.h"
#include <algorithm>

#undef max
namespace Skyhawk
{//begin namespace

#define PI 3.14159

//kgm^2
#define c_momentOfIntertiaTurbine 500.0


#define c_thrustCoeff 5.0
#define c_combustionCoeff 306400.0
#define c_engineDragCoeff 100.0
#define c_constantEngineDragCoeff 2000.0
#define c_starterTorque 10000.0

#define c_maxFuelFlow 0.8779
#define c_maxOmega 1152.0

#define c_maxAirflow 50.0

class Engine
{
public:
	Engine(Input& input);
	~Engine();
	void zeroInit();
	void coldInit();
	void hotInit();
	void airbornInit();
	void updateEngine(double dt);

	inline double getThrust();
	inline double getRPM();
	inline double getRPMNorm();
	inline double getTemperature();
	inline double getFuelFlow();
	inline void setHasFuel(bool fuel);
	inline void setThrottle(double throttle);
	inline void setIgnitors(bool ignitors);
	inline void setBleedAir(bool bleedAir);
	inline void setAirspeed(double airspeed);

private:
	//Constants
	const double m_throttleResponseTime = 7.0;
	const double m_pGain = 3.0;


	//Special Classes
	Input& m_input;
	Table m_omegaVThrust;

	//Variables
	double m_oilPressure = 0.0;
	double m_fuelFlow = 0.0;
	double m_desiredFuelFlow = 0.0;
	double m_temperature = 23.0;
	double m_omega = 0.0;
	double m_nozzle = 1.0;
	bool m_cutoff = true;
	bool m_ignitors = false;
	bool m_haveFuel = true;
	double m_startAir = 0.0;
	double m_throttle = 0.0;
	double m_airspeed = 0.0;

};

double Engine::getThrust()
{
	return std::max(m_omegaVThrust(m_omega)*m_nozzle - 0.0*c_maxAirflow*(m_airspeed)*0.2, 0.0);
}

double Engine::getRPM()
{
	return 60.0 * m_omega / (2.0 * PI);
}

double Engine::getRPMNorm()
{
	return m_omega / c_maxOmega;
}

double Engine::getTemperature()
{
	return m_temperature;
}

double Engine::getFuelFlow()
{
	return m_fuelFlow;
}

void Engine::setHasFuel(bool fuel)
{
	m_haveFuel = fuel;
}

void Engine::setThrottle(double throttle)
{
	m_throttle = throttle;
}

void Engine::setIgnitors(bool ignitors)
{
	m_ignitors = ignitors;
}

void Engine::setBleedAir(bool bleedAir)
{
	m_startAir = bleedAir ? 1.0 : 0.0;
}

void Engine::setAirspeed(double airspeed)
{
	m_airspeed = airspeed;
}

}//end namespace
#endif
