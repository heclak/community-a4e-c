#pragma once
#ifndef AXIS_H
#define AXIS_H
//=========================================================================//
//
//		FILE NAME	: Axis.h
//		AUTHOR		: Joshua Nelson
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Added axis class to support keyboard users more easily.
//
//================================ Includes ===============================//
#include "BaseComponent.h"
#include <math.h>
//=========================================================================//

class Axis : public BaseComponent
{
public:
	Axis(double sensitivity, double min, double max, double reset, double linear);
	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	void update();
	inline void updateAxis(double axis);
	inline void keyIncrease();
	inline void keyDecrease();
	inline void reset();
	inline void slowReset();
	inline void stop();
	inline const double getValue() const;

private:
	double m_value = 0.0;

	int m_dir = 0;
	bool m_slowReset = false;

	const double m_sensitivity;
	const double m_min;
	const double m_max;
	const double m_reset;
	const double m_linear;
};

void Axis::updateAxis( double axis )
{
	m_value = axis;
	m_dir = 0;
}

void Axis::stop()
{
	m_dir = 0;
	m_slowReset = false;
}

void Axis::reset()
{
	m_value = m_reset;
	m_dir = 0;
	m_slowReset = false;
}

void Axis::slowReset()
{
	m_dir = (int)copysign( 1.0, m_reset - m_value );
	m_slowReset = true;
}

void Axis::keyIncrease()
{
	if ( m_slowReset )
		m_dir = 0;

	m_dir += 1;
	m_slowReset = false;
}

void Axis::keyDecrease()
{
	if ( m_slowReset )
		m_dir = 0;

	m_dir -= 1;
	m_slowReset = false;
}

const double Axis::getValue() const
{
	return m_value;
}

#endif //AXIS_H