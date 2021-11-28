//=========================================================================//
//
//		FILE NAME	: Axis.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Added axis class to support keyboard users more easily.
//
//================================ Includes ===============================//
#include "Axis.h"
#include <algorithm>
//=========================================================================//

Axis::Axis( 
	double sensitivity, 
	double min, 
	double max,
	double reset,
	double linear
):
	m_sensitivity(sensitivity),
	m_min(min),
	m_max(max),
	m_reset(reset),
	m_linear(linear),
	m_value(reset)
{

}

void Axis::zeroInit()
{
	m_dir = 0;
	m_value = m_reset;
}

void Axis::coldInit()
{
	zeroInit();
}

void Axis::hotInit()
{
	zeroInit();
}

void Axis::airborneInit()
{
	zeroInit();
}

void Axis::update()
{
	m_value += m_sensitivity * (double)m_dir * (0.2 + fabs(m_value) * m_linear);
	m_value = std::max( std::min( m_max, m_value ), m_min );



	if ( m_slowReset )
	{
		int sign = (int)copysign( 1.0, m_reset - m_value );

		if ( sign != m_dir )
		{
			m_dir = 0;
			m_value = m_reset;
			m_slowReset = false;
		}
	}
}