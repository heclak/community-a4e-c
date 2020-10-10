#include "Engine2.h"
Skyhawk::Engine2::Engine2():
	fuelToHPOmega( c_fuelToHPOmega, c_fuelToHPOmegaMin, c_fuelToHPOmegaMax ),
	lpOmegaToMassFlow( c_lpOmegaToMassFlow, c_lpOmegaToMassFlowMin, c_lpOmegaToMassFlowMax ),
	hpOmegaToMassFlow( c_hpOmegaToMassFlow, c_hpOmegaToMassFlowMin, c_hpOmegaToMassFlowMax ),
	massFlowToStaticThrust(c_massFlowToStaticThrust, c_massFlowToStaticThrustMin, c_massFlowToStaticThrustMax ),
	airspeedToHPOmega( c_windmill, c_windmillMin, c_windmillMax )
{

}

Skyhawk::Engine2::~Engine2()
{

}

void Skyhawk::Engine2::zeroInit()
{
	m_lpOmega = 0.0;
	m_hpOmega = 0.0;
	m_fuelFlow = 0.0;
	m_massFlow = 0.0;
	m_hasFuel = true;
	m_ignitors = false;
	m_bleedAir = false;
	m_airspeed = 0.0;
	m_temperature = 23.0;
}

void Skyhawk::Engine2::coldInit()
{
	zeroInit();
	m_hpOmega = c_maxHPOmega * 0.55;
	m_lpOmega = hpOmegaToLPOmega( m_hpOmega );
	m_ignitors = true;
}

void Skyhawk::Engine2::hotInit()
{
	zeroInit();
	m_hpOmega = c_maxHPOmega * 0.55;
	m_lpOmega = hpOmegaToLPOmega( m_hpOmega );
	m_ignitors = true;
}

void Skyhawk::Engine2::airbornInit()
{
	zeroInit();
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
	if ( getRPMNorm() < 0.50 )
	{
		lowOmegaInertia = 7.0;
	}

	if ( m_hasFuel && m_ignitors && m_hpOmega > c_startOmega/2.0 )
	{
		double desiredFractionalOmega = 0.0;
		
		if ( m_throttle >= -0.01 )
		{
			desiredFractionalOmega = (1 - c_throttleIdle) * m_throttle + c_throttleIdle;
		}
		else
		{
			desiredFractionalOmega = (m_throttle + 1.0) / 1.5;
		}

		double desiredFuelFlow = getPID( desiredFractionalOmega, dt );

		//Add inertia in here
		m_fuelFlow += (std::max( std::min( desiredFuelFlow, c_fuelFlowMax ), 0.0 ) - m_fuelFlow) * dt / c_fuelFlowInertia;

		m_hpOmega += (fuelToHPOmega( m_fuelFlow ) - m_hpOmega) * dt / (c_hpInertia * lowOmegaInertia);
		m_lpOmega += (hpOmegaToLPOmega( m_hpOmega ) - m_lpOmega) * dt / (c_lpInertia * lowOmegaInertia);
		m_massFlow = (lpOmegaToMassFlow( m_lpOmega ) + hpOmegaToMassFlow( m_hpOmega )) / 2.0;
	}
	else if ( m_bleedAir )
	{
		m_fuelFlow = 0.0;
		m_hpOmega += (c_startOmega - m_hpOmega) * dt / (c_hpInertia * lowOmegaInertia);
		m_lpOmega += (hpOmegaToLPOmega( m_hpOmega ) - m_lpOmega) * dt / (c_lpInertia * lowOmegaInertia);
		m_massFlow = (lpOmegaToMassFlow( m_lpOmega ) + hpOmegaToMassFlow( m_hpOmega )) / 2.0;
	}
	else
	{
		printf( "Airspeed: %lf, Omega Airspeed %lf\n", m_airspeed, airspeedToHPOmega( m_airspeed ) );
		m_fuelFlow = 0.0;
		m_hpOmega += (airspeedToHPOmega( m_airspeed ) - m_hpOmega) * dt / c_hpInertia;
		m_lpOmega += (hpOmegaToLPOmega( m_hpOmega ) - m_lpOmega) * dt / c_lpInertia;
		m_massFlow = 0.0;
	}

	//printf( "THROTTLE: %lf, FF: %lf, HP: %lf, LP: %lf, MF: %lf, THRUST: %lf\n", m_throttle, m_fuelFlow, m_hpOmega, m_lpOmega, m_massFlow, getThrust() );
}