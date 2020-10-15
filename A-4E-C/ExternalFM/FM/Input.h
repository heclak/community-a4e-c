#ifndef CONTROL_H
#define CONTROL_H
#pragma once
#include "BaseComponent.h"
namespace Skyhawk
{//begin namespace

enum Control
{
	//Axis
	PITCH = 2001, //Stick pitch axis
	ROLL = 2002, //Stick roll axis
	YAW = 2003, //Pedals yaw axis
	THROTTLE = 2004, //Throttle axis
	GEAR_TOGGLE = 68, //68
	GEAR_UP = 430, //
	GEAR_DOWN = 431, //
	BRAKE = 2111,
	LEFT_BRAKE = 3162,
	RIGHT_BRAKE = 3163,
	FLAPS_INCREASE = 10001,
	FLAPS_DECREASE = 10002,
	FLAPS_DOWN = 145,
	FLAPS_UP = 146,
	FLAPS_TOGGLE = 72,
	AIRBRAKE_EXTEND = 147,
	AIRBRAKE_RETRACT = 148,
	HOOK_TOGGLE = 69,
	CONNECT_TO_CAT = 120,
	NOSEWHEEL_STEERING_ENGAGE = 3133,
	NOSEWHEEL_STEERING_DISENGAGE = 3134,
	STARTER_BUTTON = 3013,
	THROTTLE_DETEND = 3087,
};

class Input : public BaseComponent
{
public:

	Input()
	{

	}

	virtual void zeroInit()
	{
		m_pitch = 0.0;
		m_roll = 0.0;
		m_yaw = 0.0;

		m_pitchTrim = 0.0;
		m_rollTrim = 0.0;
		m_yawTrim = 0.0;

		m_yawDamper = 0.0;
		m_throttle = 0.0;
		m_brakeLeft = 0.0;
		m_brakeRight = 0.0;

		m_hook = false;
		m_nosewheelSteering = false;
		m_starter = false;
	}

	virtual void coldInit()
	{
		zeroInit();
	}

	virtual void hotInit()
	{
		zeroInit();
	}

	virtual void airborneInit()
	{
		zeroInit();
	}

	static inline double normalise(double value)
	{
		return (value + 1.0) / 2.0;
	}

	inline const double throttleNorm() const
	{
		return normalise( -m_throttle );
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
	inline const double& pitchTrim() const
	{
		return m_pitchTrim;
	}
	inline double& pitchTrim()
	{
		return m_pitchTrim;
	}

	inline const double& rollTrim() const
	{
		return m_rollTrim;
	}
	inline double& rollTrim()
	{
		return m_rollTrim;
	}

	inline const double& yawTrim() const
	{
		return m_yawTrim;
	}
	inline double& yawTrim()
	{
		return m_yawTrim;
	}
	inline const double& yawDamper() const
	{
		return m_yawDamper;
	}
	inline double& yawDamper()
	{
		return m_yawDamper;
	}
	inline const double& throttle() const
	{
		return m_throttle;
	}
	inline double& throttle()
	{
		return m_throttle;
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
	inline double getFFBPitchFactor()
	{
		return m_FFBPitchFactor;
	}
	inline double getFFBPitchAmplitude()
	{
		return m_FFBPitchAmplitude;
	}
	inline double getFFBPitchFrequency()
	{
		return m_FFBPitchFrequency;
	}
	inline double getFFBRollFactor()
	{
		return m_FFBRollFactor;
	}
	inline double getFFBRollAmplitude()
	{
		return m_FFBRollAmplitude;
	}
	inline double getFFBRollFrequency()
	{
		return m_FFBRollFrequency;
	}
	inline const bool& hook() const
	{
		return m_hook;
	}
	inline bool& hook()
	{
		return m_hook;
	}
	inline const bool& nosewheelSteering() const
	{
		return m_nosewheelSteering;
	}
	inline bool& nosewheelSteering()
	{
		return m_nosewheelSteering;
	}
	inline const bool& starter() const
	{
		return m_starter;
	}
	inline bool& starter()
	{
		return m_starter;
	}
private:
	double m_pitch = 0.0;
	double m_roll = 0.0;
	double m_yaw = 0.0;

	double m_pitchTrim = 0.0;
	double m_rollTrim = 0.0;
	double m_yawTrim = 0.0;

	double m_yawDamper = 0.0;
	double m_throttle = 0.0;
	double m_brakeLeft = 0.0;
	double m_brakeRight = 0.0;

	double m_FFBPitchFactor = 1.0;
	double m_FFBPitchAmplitude = 0.0;
	double m_FFBPitchFrequency = 0.0;
	double m_FFBRollFactor = 1.0;
	double m_FFBRollAmplitude = 0.0;
	double m_FFBRollFrequency = 0.0;


	bool m_hook = false;
	bool m_nosewheelSteering = false;
	bool m_starter = false;
};

}//end namespace

#endif