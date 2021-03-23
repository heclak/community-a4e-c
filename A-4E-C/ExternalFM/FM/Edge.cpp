#include "Edge.h"

double Edge::updateFlow(double pressureDelta, Node* node)
{
	pressureDelta += m_pressureDelta;

	if ( m_blocked )
		return 0.0;

	if ( node != m_down )
	{
		if ( m_down )
			return m_down->updateFlow( pressureDelta, this );
		else
			return 0.0;
	}
	else
	{
		if ( m_up )
			return m_up->updateFlow( pressureDelta, this );
		else
			return 0.0;
	}
		
}