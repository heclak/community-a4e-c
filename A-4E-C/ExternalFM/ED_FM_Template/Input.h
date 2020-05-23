#ifndef CONTROL_H
#define CONTROL_H
#pragma once
namespace Skyhawk
{//begin namespace

enum Control
{
	//Axis
	PITCH = 2001, //Stick pitch axis
	ROLL = 2002, //Stick roll axis
	YAW = 2003, //Pedals yaw axis
	THROTTLE = 2004, //Throttle axis
	GEAR_TOGGLE = 68,
	GEAR_UP = 430,
	GEAR_DOWN = 431,
	BRAKE = 2111,
	LEFT_BRAKE = 2112,
	RIGHT_BRAKE = 2113,
	FLAPS_INCREASE = 10001,
	FLAPS_DECREASE = 10002,
	FLAPS_DOWN = 145,
	FLAPS_UP = 146,
	FLAPS_TOGGLE = 72,
	AIRBRAKE_EXTEND = 147,
	AIRBRAKE_RETRACT = 148
};

class Input
{
public:

	enum class GearPos
	{
		DOWN,
		UP
	};


	Input()
	{

	}
	~Input()
	{

	}

	void coldInit()
	{
		m_gear = GearPos::DOWN;
	}

	void hotInit()
	{
		m_gear = GearPos::DOWN;
	}

	void airbornInit()
	{
		m_gear = GearPos::UP;
	}

	inline double normalise(double value)
	{
		return (value + 1.0) / 2.0;
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
	inline const double& brakeLeft() const
	{
		return m_brakeLeft;
	}
	inline double& brakeLeft()
	{
		return m_brakeLeft;
	}
	inline const double& brakeRight() const
	{
		return m_brakeRight;
	}
	inline double& brakeRight()
	{
		return m_brakeRight;
	}
	inline const double& airbrake() const
	{
		return m_airbrake;
	}
	inline double& airbrake()
	{
		return m_airbrake;
	}
	inline const double& flaps() const
	{
		return m_flaps;
	}
	inline double& flaps()
	{
		return m_flaps;
	}
	inline const double& slats() const
	{
		return m_slats;
	}
	inline double& slats()
	{
		return m_slats;
	}
private:
	double m_pitch = 0.0;
	double m_roll = 0.0;
	double m_yaw = 0.0;
	double m_throttle = 0.0;
	double m_brakeLeft = 0.0;
	double m_brakeRight = 0.0;
	double m_airbrake = 0.0;
	double m_flaps = 0.0;
	double m_slats = 0.0; //desired by fm
	GearPos m_gear = GearPos::UP;
};

}//end namespace

#endif