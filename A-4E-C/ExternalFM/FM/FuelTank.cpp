#include "FuelTank.h"

double FuelTank::updateFlow( double pressureDelta, Edge* from )
{
	double draw = 0.0;

	for ( int i = 0; i < m_edges.size(); i++ )
	{
		if ( m_edges[i] != from )
			draw += m_edges[i]->updateFlow( pressureDelta, this );
	}

	if ( m_fuel < m_capacity )
	{
		double diff = m_capacity - m_fuel;

		if ( diff > draw )
			m_fuel += draw;
		else
		{
			m_fuel += diff;
			draw -= diff;
		}
	}

	//Base case.
	if ( draw == 0.0 && m_fuel > 10.0 )
	{
		draw = (m_pressure + pressureDelta) * 3e-5 ;
		m_fuel -= draw;
	}

	return draw;
}