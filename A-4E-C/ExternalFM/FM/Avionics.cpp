#include "Avionics.h"

Skyhawk::Avionics::Avionics
(
	Input& input,
	AircraftMotionState& state
) :
	m_input(input),
	m_state(state)
{
	zeroInit();
}

Skyhawk::Avionics::~Avionics()
{

}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Skyhawk::Avionics::zeroInit()
{
	m_x = 0.0;
}

void Skyhawk::Avionics::coldInit()
{
	zeroInit();
}

void Skyhawk::Avionics::hotInit()
{
	zeroInit();
}

void Skyhawk::Avionics::airborneInit()
{
	zeroInit();
}

void Skyhawk::Avionics::updateAvionics(double dt)
{
	if ( m_damperEnabled )
	{
		double f = washoutFilter( m_state.getOmega().y, dt ) * m_baseGain * (1.0 / (m_state.getMach() + 1));
		m_input.yawDamper() = f; //f
	}
	else
	{
		m_x = 0.0;
		m_input.yawDamper() = 0.0;
	}
	

	//printf("Filter: %lf, Rudder: %lf\n", f, m_flightModel.yawRate());
}