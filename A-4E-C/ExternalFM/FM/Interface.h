#ifndef INTERFACE_H
#define INTERFACE_H
#pragma once
#include <stdlib.h>
#include <stdio.h>
#include "../include/Cockpit/ccParametersAPI.h"

extern "C"
{
	void _set_radio(void* ptr, void* fnc, bool on);
	bool _get_radio(void* ptr, void* fnc);
	void _switch_radio(void* ptr, void* fnc);
}

namespace Skyhawk
{//namespace begin

class Interface
{
public:
	Interface()
	{
		m_api					= ed_get_cockpit_param_api();
		m_RPM					= m_api.pfn_ed_cockpit_get_parameter_handle("RPM");

		m_noseGear				= m_api.pfn_ed_cockpit_get_parameter_handle("FM_GEAR_NOSE");
		m_leftGear				= m_api.pfn_ed_cockpit_get_parameter_handle("FM_GEAR_LEFT");
		m_rightGear				= m_api.pfn_ed_cockpit_get_parameter_handle("FM_GEAR_RIGHT");

		m_flaps					= m_api.pfn_ed_cockpit_get_parameter_handle("FM_FLAPS");
		m_airbrakes				= m_api.pfn_ed_cockpit_get_parameter_handle("FM_BRAKES");
		m_spoiler				= m_api.pfn_ed_cockpit_get_parameter_handle("FM_SPOILERS");

		m_test					= m_api.pfn_ed_cockpit_get_parameter_handle("TEST_TEST");
		m_throttlePosition		= m_api.pfn_ed_cockpit_get_parameter_handle("FM_THROTTLE_POSITION");

		m_engineThrottlePosition = m_api.pfn_ed_cockpit_get_parameter_handle("FM_ENGINE_THROTTLE_POSITION");
		m_engineIgnition		= m_api.pfn_ed_cockpit_get_parameter_handle("FM_IGNITION");
		m_engineBleedAir		= m_api.pfn_ed_cockpit_get_parameter_handle("FM_BLEED_AIR");

		m_stickPitch			= m_api.pfn_ed_cockpit_get_parameter_handle("STICK_PITCH");
		m_stickRoll				= m_api.pfn_ed_cockpit_get_parameter_handle("STICK_ROLL");
		m_rudderPedals			= m_api.pfn_ed_cockpit_get_parameter_handle("RUDDER_PEDALS");

		m_pitchTrim				= m_api.pfn_ed_cockpit_get_parameter_handle("PITCH_TRIM");
		m_rollTrim				= m_api.pfn_ed_cockpit_get_parameter_handle("ROLL_TRIM");
		m_rudderTrim			= m_api.pfn_ed_cockpit_get_parameter_handle("RUDDER_TRIM");

		m_nws					= m_api.pfn_ed_cockpit_get_parameter_handle("FM_NWS");

		m_internalFuel = m_api.pfn_ed_cockpit_get_parameter_handle("FM_INTERNAL_FUEL");
		m_externalFuel = m_api.pfn_ed_cockpit_get_parameter_handle("FM_EXTERNAL_FUEL");

		m_radio                 = m_api.pfn_ed_cockpit_get_parameter_handle("THIS_RADIO_PTR");

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

	inline void testFnc()
	{
		m_api.pfn_ed_cockpit_set_action_digital(10);
	}

	inline void setRadioPower(bool value)
	{
		//printf("Radio Power Pointer: %p", m_api.setRadioPowerFncPtr);
		//__asm {MOV ECX, m_radio}
		void* ptr = nullptr;
		char buffer[100];
		getParamString(m_radio, buffer, 100);
		sscanf(buffer, "%p", &ptr);
		

		printf("Pointer is: %p\n", ptr);

		static int x = 0;
		x++;
		if (ptr && x > 10)
		{
			//_set_radio(ptr, m_api.setRadioPowerFncPtr, true);
			if (_get_radio(ptr, m_api.getRadioPowerFncPtr))
			{
				printf("Radio On\n");
				//_set_radio(ptr, m_api.setRadioPowerFncPtr, false);
				//_switch_radio(ptr, m_api.switchRadioPowerFncPtr);
			}
			else
			{
				printf("Radio Off\n");
				//_switch_radio(ptr, m_api.switchRadioPowerFncPtr);
				//_set_radio(ptr, m_api.setRadioPowerFncPtr, true);
			}
			//m_api.setRadioPowerFncPtr(ptr);
		}
	}

	inline void setInternalFuel(double number)
	{
		setParamNumber(m_internalFuel, number);
	}

	inline void setExternalFuel(double number)
	{
		setParamNumber(m_externalFuel, number);
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

	inline double getPitchTrim()
	{
		return getParamNumber(m_pitchTrim);
	}

	inline double getRollTrim()
	{
		return getParamNumber(m_rollTrim);
	}

	inline double getRudderTrim()
	{
		return getParamNumber(m_rudderTrim);
	}

	inline double getEngineThrottlePosition()
	{
		return getParamNumber(m_engineThrottlePosition);
	}

	inline double getBleedAir()
	{
		return getParamNumber(m_engineBleedAir);
	}

	inline double getIgnition()
	{
		return getParamNumber(m_engineIgnition);
	}

	inline double getNWS()
	{
		return getParamNumber(m_nws);
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

	//void* because C isn't a typed language kek
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

	void* m_engineThrottlePosition = NULL;
	void* m_engineIgnition = NULL;
	void* m_engineBleedAir = NULL;

	void* m_rollTrim = NULL;
	void* m_pitchTrim = NULL;
	void* m_rudderTrim = NULL;

	void* m_nws = NULL;

	void* m_internalFuel = NULL;
	void* m_externalFuel = NULL;


	//Radio Pointer for the Radio Device.
	void* m_radio = NULL;
};


}//namepsace end
#endif 
