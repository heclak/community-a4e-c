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
	m_decrease = false;
	m_increase = false;
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
	int dir = (int)m_increase - (int)m_decrease;

	m_value += m_sensitivity * (double)dir * (0.2 + fabs(m_value) * m_linear);
	m_value = std::max( std::min( m_max, m_value ), m_min );
}