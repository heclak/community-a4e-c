#include "FuelSource.h"

void FuelSource::addFuel( double fuel )
{
	m_fuelDelta = fuel;
	updateFlow( 1e6, nullptr );
}

double FuelSource::updateFlow( double pressureDelta, Edge* from )
{
	double draw = 0.0;

	for ( int i = 0; i < m_edges.size(); i++ )
	{
		draw += m_edges[i]->updateFlow( pressureDelta, this );
	}

	return draw;
}