#pragma once
#include "Node.h"
class Junction : public Node
{
public:
	Junction( const char* name ) : Node( name ) {}
	virtual double updateFlow( double pressureDelta, Edge* from );

private:
};