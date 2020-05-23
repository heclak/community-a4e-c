#ifndef CONTROL_H
#define CONTROL_H
#pragma once
namespace Skyhawk
{//begin namespace

enum Control
{
	PITCH = 2001, //Stick pitch axis
	ROLL = 2002, //Stick roll axis
	YAW = 2003, //Pedals yaw axis
	THROTTLE = 2004, //Throttle axis
	GEAR_TOGGLE = 68,
	GEAR_UP = 430,
	GEAR_DOWN = 431,
};

class Input
{
public:

	enum class GearPos
	{
		DOWN,
		UP
	};


	Input():
		m_pitch(0.0),
		m_roll(0.0),
		m_yaw(0.0),
		m_throttle(0.0)
	{

	}
	~Input()
	{

	}

	inline const double& pitch() const
	{
		return m_pitch;
	}
	inline double& pitch()
	{
		return m_pitch;
	}

	inline const double& roll() const
	{
		return m_roll;
	}
	inline double& roll()
	{
		return m_roll;
	}

	inline const double& yaw() const
	{
		return m_yaw;
	}
	inline double& yaw()
	{
		return m_yaw;
	}
	inline const double& throttle() const
	{
		return m_throttle;
	}
	inline double& throttle()
	{
		return m_throttle;
	}

	inline const double& throttleNorm() const
	{
		return (-throttle() + 1)/2.0;
	}
	inline const GearPos& gear() const
	{
		return m_gear;
	}
	inline GearPos& gear()
	{
		return m_gear;
	}
private:
	double m_pitch;
	double m_roll;
	double m_yaw;
	double m_throttle;
	GearPos m_gear;
};

}//end namespace

#endif