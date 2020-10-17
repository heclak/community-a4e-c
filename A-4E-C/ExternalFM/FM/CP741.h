#pragma once
#include "BaseComponent.h"
#include "AircraftState.h"
#include "Vec3.h"

namespace Skyhawk
{

class CP741 : public BaseComponent
{
public:
	CP741( AircraftState& state );

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	inline void setPower( bool power );
	void updateSolution( double dt );
	void setTarget( bool set, double slant );

	inline bool getSolution();

	double calculateHorizontalDistance();
	double calculateImpactDistance(double dt);

private:

	AircraftState& m_state;
	bool m_power = false;
	bool m_solution = false;
	bool m_targetSet = false;

	Vec3 m_target;
};

void CP741::setPower( bool power )
{
	m_power = power;
}

bool CP741::getSolution()
{
	return m_solution;
}

}