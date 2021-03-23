#include "FuelSystem2.h"
#include "Commands.h"
#include <stdio.h>
namespace Scooter
{

FuelSystem2::FuelSystem2( Scooter::Engine2& engine ) :
	m_engine( engine )
{

}

void FuelSystem2::zeroInit()
{

}

void FuelSystem2::coldInit()
{

}

void FuelSystem2::hotInit()
{

}

void FuelSystem2::airborneInit()
{

}

void FuelSystem2::drawFuel( double dm )
{

}

//Return true if we handled an input. This is to make any other
//device input processing orthogonal to each device, to prevent
//needless input processing.
bool FuelSystem2::handleInput( int command, float value )
{
	switch ( command )
	{
	case DEVICE_COMMANDS_ENGINE_WING_FUEL_SW:
		m_dumpingFuel = false;
		m_wingTankPressure = false;

		if ( value == 1.0 )
			m_dumpingFuel = true;
		else if ( value == -1.0 )
			m_wingTankPressure = true;

		return true;
	case DEVICE_COMMANDS_ENGINE_DROP_TANKS_SW:
		m_externalTankPressure = true;
		m_wingTankBypass = false;

		if ( value == 1.0 )
			m_externalTankPressure = false;
		else if ( value == -1.0 )
			m_wingTankBypass = true;

		return true;
	}

	return false;
}

void FuelSystem2::addFuel( double dm, bool wingFirst )
{
	//If adding fuel add it before wing tanks.
	if ( dm > 0.0 && ! wingFirst )
		dm = addFuelToTank( TANK_FUSELAGE, dm );

	//If the wing tank bypass switch is enabled we
	//refuel the external tanks instead.
	if ( m_wingTankBypass )
	{
		int externalTanks = 0;
		for ( int i = TANK_EXTERNAL_LEFT; i < NUMBER_OF_TANKS; i++ )
		{
			externalTanks += m_fuelCapacity[i] > 15.0;
		}

		double fracDM = dm / (double)externalTanks;

		dm = 0.0;

		for ( int i = TANK_EXTERNAL_LEFT; i < NUMBER_OF_TANKS; i++ )
		{
			if ( m_fuelCapacity[i] > 15.0 )
				dm += addFuelToTank( (Tank)i, fracDM );
		}
	}
	else //Bypass is not enabled so refuel the wing tank, ignoring the externals.
	{
		dm = addFuelToTank( TANK_WING, dm );
	}

	//If removing fuel remove it from the wing tanks first.
	if ( dm < 0.0 || wingFirst )
		dm = addFuelToTank( TANK_FUSELAGE, dm );
}

void FuelSystem2::update( double dt )
{
	//The factor from the engine for transfer since all transfer relies on bleed,
	//either directly to pressurise the tank or to spin a turbopump.
	double rateFactor = transferRateFactor();

	double dm = m_engine.getFuelFlow() * dt;

	double enginePower = m_engine.getRPMNorm() > 0.40;

	//Draw from the Fuselage Tank to the engine, minimum usable fuel.
	if ( m_fuel[TANK_FUSELAGE] > 15.0 )
	{
		if ( dm > 0.0 )
			m_fuel[TANK_FUSELAGE] -= dm;

		m_hasFuel = true;
	}
	else
	{
		m_hasFuel = false;
	}

	m_engine.setHasFuel( m_hasFuel );

	//Divide by two so that at 70% RPM it has 100% transfer rate.
	double wingTransferRate = m_mechPumpPressure ? rateFactor * c_fuelTransferRateWingToFuse : 0.0;

	//Emergency Fuel Transfer
	if ( m_wingTankPressure )
		wingTransferRate += c_fuelTransferRateWingToFuseEmergency * rateFactor;

	wingTransferRate *= dt;

	if ( ! enginePower )
		wingTransferRate = 0.0;

	transferFuel( TANK_WING, TANK_FUSELAGE, wingTransferRate );

	if ( m_dumpingFuel )
		addFuelToTank( TANK_WING, -c_fuelDumpRate * dt, 15.0 );

	//External tanks being pressurised.
	if ( m_externalTankPressure && enginePower )
	{
		double externWingRate = rateFactor * c_fuelTransferRateExternWingToWing * dt;
		double externCentreRate = rateFactor * c_fuelTransferRateExternCentreToWing * dt;

		double transferAmount = 0.0;
		transferAmount += m_fuelCapacity[TANK_EXTERNAL_CENTRE] > 15.0 ? externCentreRate : 0.0;
		transferAmount += m_fuelCapacity[TANK_EXTERNAL_LEFT] > 15.0 ? externWingRate : 0.0;
		transferAmount += m_fuelCapacity[TANK_EXTERNAL_RIGHT] > 15.0 ? externWingRate : 0.0;

		if ( transferAmount <= m_fuelCapacity[TANK_WING] - m_fuel[TANK_WING] )
		{
			transferFuel( TANK_EXTERNAL_CENTRE, TANK_WING, externCentreRate );
			transferFuel( TANK_EXTERNAL_LEFT, TANK_WING, externWingRate );
			transferFuel( TANK_EXTERNAL_RIGHT, TANK_WING, externWingRate );
		}
		else
		{
			//Probably should transfer some fuel here but we can just avoid the problem by waiting for the next frame.
		}
	}

	printf( "Fus: %lf, Wing: %lf, Ex L: %lf, Ex C: %lf, Ex R: %lf\n", m_fuel[0], m_fuel[1], m_fuel[2], m_fuel[3], m_fuel[4] );
}

}//end scooter namespace