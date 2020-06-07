#ifndef INTERFACE_H
#define INTERFACE_H
#pragma once
#include <stdlib.h>
#include <stdio.h>
#include "../include/Cockpit/ccParametersAPI.h"
namespace Skyhawk
{//namespace begin

class Interface
{
public:
	Interface()
	{
		m_api					= ed_get_cockpit_param_api();
		m_RPM					= m_api.pfn_ed_cockpit_get_parameter_handle("RPM");

		m_noseGear				= m_api.pfn_ed_cockpit_get_parameter_handle("GEAR_NOSE");
		m_leftGear				= m_api.pfn_ed_cockpit_get_parameter_handle("GEAR_LEFT");
		m_rightGear				= m_api.pfn_ed_cockpit_get_parameter_handle("GEAR_RIGHT");

		m_flaps					= m_api.pfn_ed_cockpit_get_parameter_handle("D_FLAPS_IND");
		m_airbrakes				= m_api.pfn_ed_cockpit_get_parameter_handle("BRAKE_EFF");
		m_spoiler				= m_api.pfn_ed_cockpit_get_parameter_handle("D_SPOILERS");

		m_test					= m_api.pfn_ed_cockpit_get_parameter_handle("TEST_TEST");
		m_throttlePosition		= m_api.pfn_ed_cockpit_get_parameter_handle("FM_THROTTLE_POSITION");

		m_stickPitch			= m_api.pfn_ed_cockpit_get_parameter_handle("STICK_PITCH");
		m_stickRoll				= m_api.pfn_ed_cockpit_get_parameter_handle("STICK_ROLL");
		m_rudderPedals			= m_api.pfn_ed_cockpit_get_parameter_handle("RUDDER_PEDALS");

	}

	inline void coldInit()
	{

	}

	inline void hotInit()
	{

	}

	inline void airbornInit()
	{

	}

	inline void setRPM(double number)
	{
		setParamNumber(m_RPM, number);
	}

	inline void setThrottlePosition(double number)
	{
		setParamNumber(m_throttlePosition, number);
	}

	inline void setStickPitch(double number)
	{
		setParamNumber(m_stickPitch, number);
		printf("%lf, %x", getParamNumber(m_stickPitch), m_stickPitch);
	}

	inline void setStickRoll(double number)
	{
		setParamNumber(m_stickRoll, number);
	}

	inline void setRudderPedals(double number)
	{
		setParamNumber(m_rudderPedals, number);
	}

	inline double getGearNose()
	{
		return getParamNumber(m_noseGear);
	}
	inline double getGearLeft()
	{
		return getParamNumber(m_leftGear);
	}
	inline double getGearRight()
	{
		return getParamNumber(m_rightGear);
	}

	inline double getFlaps()
	{
		return getParamNumber(m_flaps);
	}

	inline double getSpeedBrakes()
	{
		return getParamNumber(m_airbrakes);
	}

	inline double getSpoilers()
	{
		return getParamNumber(m_spoiler);
	}
		 
	void* m_test = NULL;
private:
	inline double getParamNumber(void* ptr)
	{
		double result;
		m_api.pfn_ed_cockpit_parameter_value_to_number(ptr, result, false);
		return result;
	}

	inline void getParamString(void* ptr, char* buffer, unsigned int bufferSize)
	{
		m_api.pfn_ed_cockpit_parameter_value_to_string(ptr, buffer, bufferSize);
	}

	inline void setParamNumber(void* ptr, double number)
	{
		m_api.pfn_ed_cockpit_update_parameter_with_number(ptr, number);
	}

	inline void setParamString(void* ptr, const char* string)
	{
		m_api.pfn_ed_cockpit_update_parameter_with_string(ptr, string);
	}


	cockpit_param_api m_api;

	void* m_RPM = NULL;
	void* m_noseGear = NULL;
	void* m_leftGear = NULL;
	void* m_rightGear = NULL;
	void* m_flaps = NULL;
	void* m_spoiler = NULL;
	void* m_airbrakes = NULL;

	void* m_rudderPedals = NULL;
	void* m_stickRoll = NULL;
	void* m_stickPitch = NULL;
	void* m_throttlePosition = NULL;
};


}//namepsace end
#endif 
