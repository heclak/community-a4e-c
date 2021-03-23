#pragma once
#include "Node.h"
class FuelTank : public Node
{
public:
	FuelTank( const char* name ) : Node( name ) {}
	virtual double updateFlow( double pressureDelta, Edge* from );

private:

	double m_fuel = 50.0;
	double m_capacity = 100.0;
};