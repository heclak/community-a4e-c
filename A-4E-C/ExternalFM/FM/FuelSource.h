#pragma once
#include "Node.h"

class FuelSource : public Node
{
public:
	FuelSource(const char* name):
		Node( name ) {}
	double FuelSource::updateFlow( double pressureDelta, Edge* from );
	void addFuel( double fuel );
private:
	double m_fuelDelta = 0.0;

};