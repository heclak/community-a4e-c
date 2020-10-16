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
	void updateSolution(double slant, double dt);
	void setTarget( double slant );

	double calculateHorizontalDistance( double slant );


private:

	AircraftState& m_state;
	bool m_power = false;
	bool m_solution = false;
	Vec3 m_target;
};

void CP741::setPower( bool power )
{
	m_power = power;
}

}