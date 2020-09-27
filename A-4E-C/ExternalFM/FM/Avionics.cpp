#include "Avionics.h"

Skyhawk::Avionics::Avionics
(
	Input& input,
	FlightModel& flightModel,
	Engine& engine,
	Airframe& airframe
) :
	m_input(input),
	m_flightModel(flightModel),
	m_engine(engine),
	m_airframe(airframe)
{

}

Skyhawk::Avionics::~Avionics()
{

}

void Skyhawk::Avionics::coldInit()
{

}

void Skyhawk::Avionics::hotInit()
{

}

void Skyhawk::Avionics::airbornInit()
{

}

void Skyhawk::Avionics::updateAvionics(double dt)
{
	double f = washoutFilter(m_flightModel.yawRate(), dt)*m_baseGain*(1.0/(m_flightModel.mach() + 1));

	m_input.yawDamper() = f; //f

	//printf("Filter: %lf, Rudder: %lf\n", f, m_flightModel.yawRate());
}