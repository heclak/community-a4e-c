#include "CP741.h"

Skyhawk::CP741::CP741( AircraftState& state ):
	m_state(state)
{

}

void Skyhawk::CP741::zeroInit()
{

}

void Skyhawk::CP741::coldInit()
{

}

void Skyhawk::CP741::hotInit()
{

}

void Skyhawk::CP741::airborneInit()
{

}

void Skyhawk::CP741::updateSolution( double slant, double dt )
{
	m_solution = true;

	//Must be turned on
	m_solution &= m_power;

	//Must be pointing down
	m_solution &= m_state.getAngle().z < 0.0;

	//Must have a slant 
	m_solution &= slant > 0.0;

	double xDistance = calculateHorizontalDistance( slant );



}

double Skyhawk::CP741::calculateHorizontalDistance( double slant )
{
	return cos(m_state.getAngle().z) * slant;
}

void Skyhawk::CP741::setTarget( double slant )
{
	Vec3 direction = normalize( m_state.getAngle() );
	m_target = direction * slant + m_state.getWorldPosition();
}


