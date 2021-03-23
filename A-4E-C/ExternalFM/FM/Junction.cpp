#include "Junction.h"

double Junction::updateFlow( double pressureDelta, Edge* from )
{
	double draw = 0.0;

	for ( int i = 0; i < m_edges.size(); i++ )
	{
		if ( m_edges[i] != from )
			draw += m_edges[i]->updateFlow( pressureDelta, this );
	}

	return draw;
}