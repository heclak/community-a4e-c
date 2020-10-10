#pragma once
#ifndef ENGINE_2_H
#define ENGINE_2_H

#include "Table.h"
#include "Input.h"
#include "Data.h"
#include <algorithm>

#undef max
#undef min

#define PI 3.14159

#define c_lpInertia 3.0
#define c_hpInertia 3.0

#define c_fuelFlowInertia 1.0

namespace Skyhawk
{

class Engine2
{
public:
	Engine2();
	~Engine2();

	void zeroInit();
	void coldInit();
	void hotInit();
	void airbornInit();

	inline void setThrottle(double throttle);
	inline void setHasFuel( bool hasFuel );
	inline void setAirspeed( double airspeed );
	inline void setBleedAir( bool bleedAir );
	inline void setIgnitors( bool ignitors );
	inline void setTemperature( double temperature );

	inline double getThrust();
	inline double getFuelFlow();
	inline double getPID( double desiredFractionalRPM, double dt );
	inline double getRPMNorm();
	inline double getRPM();

	void updateEngine( double dt );
private:
	ZeroTable thrustToFFOverSqrtTemp;
	ZeroTable fuelToHPOmega;
	ZeroTable airspeedToHPOmega;

	ZeroTable lpOmegaToMassFlow;
	ZeroTable hpOmegaToMassFlow;

	ZeroTable massFlowToStaticThrust;

	double m_lpOmega = 0.0;
	double m_hpOmega = 0.0;

	double m_throttle = 0.0;
	double m_fuelFlow = 0.0;
	double m_correctedFuelFlow = 0.0;

	double m_massFlow = 0.0;
	double m_thrust = 0.0;

	bool m_hasFuel = true;
	bool m_ignitors = true;
	bool m_bleedAir = false;

	//Environment
	double m_airspeed = 0.0;
	double m_temperature = 15.0 + 273.0;

	//PID
	double m_pGain = 3.0;
	double m_iGain = 0.0;
	double m_dGain = 3.0;
	double m_errPrev = 0.0;

	static inline double hpOmegaToLPOmega( double hpOmega );

	inline void updateShafts(double hpTarget, double lowOmegaInertia, double dt);
};

void Engine2::setThrottle( double throttle )
{
	m_throttle = throttle;
}

void Engine2::setHasFuel( bool hasFuel )
{
	m_hasFuel = hasFuel;
}

void Engine2::setAirspeed( double airspeed )
{
	m_airspeed = airspeed;
}

void Engine2::setBleedAir( bool bleedAir )
{
	m_bleedAir = bleedAir;
}

void Engine2::setIgnitors( bool ignitors )
{
	m_ignitors = ignitors;
}

void Engine2::setTemperature( double temperature )
{
	m_temperature = temperature;
}

double Engine2::getRPMNorm()
{
	return m_hpOmega / c_maxHPOmega;
}

double Engine2::getRPM()
{
	return 60.0 * m_hpOmega / (2.0 * PI);
}

double Engine2::getThrust()
{
	return m_thrust;
}

double Engine2::getFuelFlow()
{
	return m_correctedFuelFlow;
}

double Engine2::getPID( double desiredFractionalRPM, double dt )
{
	//Error between setpoint and process variable
	double error = c_maxHPOmega * desiredFractionalRPM - m_hpOmega;

	//dError/dt
	double errDeriv = (error - m_errPrev) / dt;
	m_errPrev = error;

	//     proportional        derrivative
	return error * m_pGain + errDeriv * m_dGain;
}

double Engine2::hpOmegaToLPOmega( double x )
{
	//This function was found using python this is just a 4th order polynomial fit. These magic numbers are the coefficients that came out.
	return -2.46586697e-09 * pow( x, 4.0 ) + 7.31933906e-06 * pow( x, 3.0 ) - 6.38483117e-03 * pow( x, 2.0 ) + 2.25049813 * x;
}

void Engine2::updateShafts( double hpTarget, double lowOmegaInertia, double dt )
{
	m_hpOmega += (hpTarget - m_hpOmega) * dt / (c_hpInertia * lowOmegaInertia);
	m_lpOmega += (hpOmegaToLPOmega( m_hpOmega ) - m_lpOmega) * dt / (c_lpInertia * lowOmegaInertia);
}

}
#endif