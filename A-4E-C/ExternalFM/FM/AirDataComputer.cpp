#include "AirDataComputer.h"

#define c_speedOfSound 340.29 //m/s
#define c_standardTemp 288.15 //K

Scooter::AirDataComputer::AirDataComputer
(
	Interface& inter,
	AircraftState& state
) :
	m_interface( inter ),
	m_state( state )
{

}

void Scooter::AirDataComputer::calculateTAS()
{
	m_tas = c_speedOfSound* m_state.getMach() * sqrt( m_state.getTemperature() / c_standardTemp );
}

void Scooter::AirDataComputer::update(double dt)
{
	calculateTAS();

	m_interface.ADC_setTAS( m_tas );
}

