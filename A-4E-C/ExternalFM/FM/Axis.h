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
	inline void stop();
	inline const double getValue() const;

private:
	double m_value = 0.0;

	bool m_increase = false;
	bool m_decrease = false;

	const double m_sensitivity;
	const double m_min;
	const double m_max;
	const double m_reset;
	const double m_linear;
};

void Axis::updateAxis( double axis )
{
	m_value = axis;
	m_increase = false;
	m_decrease = false;
}

void Axis::stop()
{
	m_increase = false;
	m_decrease = false;
}

void Axis::reset()
{
	m_value = m_reset;
	m_increase = false;
	m_decrease = false;
}

void Axis::keyIncrease()
{
	m_increase = true;
}

void Axis::keyDecrease()
{
	m_decrease = true;
}

const double Axis::getValue() const
{
	return m_value;
}

#endif //AXIS_H