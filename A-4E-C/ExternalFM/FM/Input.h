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

class Input
{
public:

	enum class GearPos
	{
		DOWN,
		UP
	};

	enum class ThrottleState
	{
		CUTOFF,
		START,
		IDLE
	};


	Input()
	{

	}
	~Input()
	{

	}

	void zeroInit()
	{
		m_flaps = 0.0;
		m_pitchTrim = 0.0;
		m_rollTrim = 0.0;
		m_yawTrim = 0.0;
		m_pitch = 0.0;
		m_roll = 0.0;
		m_yaw = 0.0;
		m_throttle = 1.0;
		m_yawDamper = 0.0;
	}

	void coldInit()
	{
		zeroInit();
		m_gear = GearPos::DOWN;
		m_hook = false;
		m_nosewheelSteering = false;
		m_throttleState = ThrottleState::CUTOFF;
		m_starter = false;
	}

	void hotInit()
	{
		zeroInit();
		m_gear = GearPos::DOWN;
		m_hook = false;
		m_nosewheelSteering = false;
		m_throttleState = ThrottleState::IDLE;
		m_starter = false;
	}

	void airbornInit()
	{
		zeroInit();
		m_gear = GearPos::UP;
		m_hook = false;
		m_nosewheelSteering = false;
		m_throttleState = ThrottleState::IDLE;
		m_starter = false;
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
	inline const double& slatL() const
	{
		return m_slatL;
	}
	inline double& slatL()
	{
		return m_slatL;
	}
	inline const double& slatR() const
	{
		return m_slatR;
	}
	inline double& slatR()
	{
		return m_slatR;
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
	inline const ThrottleState& throttleState() const
	{
		return m_throttleState;
	}
	inline ThrottleState& throttleState()
	{
		return m_throttleState;
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
	double m_airbrake = 0.0;
	double m_flaps = 0.0;
	double m_slatL = 0.0; //desired by fm
	double m_slatR = 0.0; //desired by fm
	GearPos m_gear = GearPos::UP;
	ThrottleState m_throttleState = ThrottleState::CUTOFF;
	bool m_hook = false;
	bool m_nosewheelSteering = false;
	bool m_starter = false;
};

}//end namespace

#endif