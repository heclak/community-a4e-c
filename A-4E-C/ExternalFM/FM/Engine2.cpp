#include "Engine2.h"
Skyhawk::Engine2::Engine2():
	fuelToHPOmega( c_fuelToHPOmega, c_fuelToHPOmegaMin, c_fuelToHPOmegaMax ),
	lpOmegaToMassFlow( c_lpOmegaToMassFlow, c_lpOmegaToMassFlowMin, c_lpOmegaToMassFlowMax ),
	hpOmegaToMassFlow( c_hpOmegaToMassFlow, c_hpOmegaToMassFlowMin, c_hpOmegaToMassFlowMax ),
	massFlowToStaticThrust(c_massFlowToStaticThrust, c_massFlowToStaticThrustMin, c_massFlowToStaticThrustMax ),
	airspeedToHPOmega( c_windmill, c_windmillMin, c_windmillMax ),
	thrustToFFOverSqrtTemp ( c_thrustToFFOverSqrtTemp, c_thrustToFFOverSqrtTempMin, c_thrustToFFOverSqrtTempMax )
{
	zeroInit();
}

Skyhawk::Engine2::~Engine2()
{

}

void Skyhawk::Engine2::zeroInit()
{
	m_lpOmega = 0.0;
	m_hpOmega = 0.0;
	m_throttle = 0.0;
	m_fuelFlow = 0.0;
	m_correctedFuelFlow = 0.0;
	m_massFlow = 0.0;
	m_thrust = 0.0;
	m_hasFuel = true;
	m_ignitors = false;
	m_bleedAir = false;
	m_airspeed = 0.0;
	m_temperature = 15.0 + 273.0;
	m_errPrev = 0.0;
}

void Skyhawk::Engine2::coldInit()
{
	zeroInit();
}

void Skyhawk::Engine2::hotInit()
{
	zeroInit();
	m_hpOmega = c_maxHPOmega * 0.55;
	m_lpOmega = hpOmegaToLPOmega( m_hpOmega );
	m_ignitors = true;
}

void Skyhawk::Engine2::airborneInit()
{
	zeroInit();
	m_hpOmega = c_maxHPOmega * 0.55;
	m_lpOmega = hpOmegaToLPOmega( m_hpOmega );
	m_ignitors = true;
}

void Skyhawk::Engine2::updateEngine( double dt )
{
	double correctedThrottle = 0.0;
	if ( m_throttle >= 0.0 )
	{
		correctedThrottle = (1 - c_throttleIdle) * m_throttle + c_throttleIdle;
	}
	else
	{
		correctedThrottle = (m_throttle + 1.0) / 2.0;
	}

	double lowOmegaInertia = 1.0;

	//This gives the engine a sluggish feeling when starting up due to the
	//low thrust produced when starting.
	if ( getRPMNorm() < 0.50 )
	{
		lowOmegaInertia = 7.0;
	}

	//Thrust or Drag
	double thrustSign = 1.0;

	if ( m_hasFuel && m_ignitors && m_hpOmega > c_startOmega/2.0 )
	{
		double desiredFractionalOmega = 0.0;
		
		
		if ( m_throttle >= -0.01 )
		{
			//Normal engine operation
			desiredFractionalOmega = (1 - c_throttleIdle) * m_throttle + c_throttleIdle;
		}
		else
		{
			//Throttle is in 1st detent.
			desiredFractionalOmega = (m_throttle + 1.0) / 1.5;
		}

		double desiredFuelFlow = getPID( desiredFractionalOmega, dt );

		//Update towards desired fuel flow with response time.
		m_fuelFlow += (std::max( std::min( desiredFuelFlow, c_fuelFlowMax ), 0.0 ) - m_fuelFlow) * dt / c_fuelFlowInertia;

		//Fuel Flow -> Shaft Speed
		updateShafts( fuelToHPOmega( m_fuelFlow ), lowOmegaInertia, dt );
	}
	else if ( m_bleedAir )
	{
		m_fuelFlow = 0.0;
		//Constant shaft Speed (bleed air from ground huffer)
		updateShafts( c_startOmega, lowOmegaInertia, dt );
	}
	else
	{
		//We are creating drag
		thrustSign = -1.0;
		
		m_fuelFlow = 0.0;

		//Airspeed -> Shaft Speed (Windmilling)
		updateShafts( airspeedToHPOmega( m_airspeed ), 1.0, dt );
	}

	//Mass flow is the average of the mass flows from hp and lp shafts.
	m_massFlow = (lpOmegaToMassFlow( m_lpOmega ) + hpOmegaToMassFlow( m_hpOmega )) / 2.0;

	//Thrust = staticThrust - massFlow * airspeed
	m_thrust = (1000.0*massFlowToStaticThrust( m_massFlow ) - abs( m_airspeed ) * m_massFlow) * thrustSign;

	//Correct fuel flow for temperature.
	m_correctedFuelFlow = m_fuelFlow * sqrt( m_temperature ) / c_sqrtStandardDayTemp;
}