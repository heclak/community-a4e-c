#pragma once
#include "Interface.h"
#include "AircraftState.h"

namespace Scooter
{

class AirDataComputer
{
public:
	AirDataComputer(Interface& inter, AircraftState& state);
	void update(double dt);

private:

	void calculateTAS();
	void calculateEAS();
	void calculateCAS();
	void calculateTASXZComponents();

	Interface& m_interface;
	AircraftState& m_state;

	double m_tas = 0.0;
	double m_eas = 0.0;
	double m_cas = 0.0;

	double m_tasX = 0.0;
	double m_tasZ = 0.0;
};

} //end namespace Scooter

