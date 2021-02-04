#pragma once
#ifndef INTERFACE_H
#define INTERFACE_H
//=========================================================================//
//
//		FILE NAME	: Interface.h
//		AUTHOR		: Joshua Nelson
//		DATE		: June 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Class for handling interface between lua and C/C++.
//						See equivelent file for lua EFM_Data_Bus.lua.
//
//================================ Includes ===============================//
#include <stdlib.h>
#include <stdio.h>
#include "../include/Cockpit/ccParametersAPI.h"

//=========================================================================//

extern "C"
{
	void _set_radio(void* ptr, bool on);
	bool _get_radio(void* ptr);
	bool _get_intercom(void* ptr);
	bool _is_on_intercom(void* ptr, void* fooPtr);
	void _switch_radio(void* ptr, void* fnc);
	int _get_gun_shells(void* ptr, void* fnc);
	bool _ext_is_on(void* ptr, void* fnc);

	void _connect_radio_power( void* radio, void* elec, void* fnc );
	void _set_radio_power( void* radio, bool value, void* fnc );
}

namespace Scooter
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
		m_leftBrakePedal		= m_api.pfn_ed_cockpit_get_parameter_handle("LEFT_BRAKE_PEDAL");
		m_rightBrakePedal		= m_api.pfn_ed_cockpit_get_parameter_handle("RIGHT_BRAKE_PEDAL");

		m_stickInputPitch       = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_STICK_INPUT_PITCH" );
		m_stickInputRoll        = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_STICK_INPUT_ROLL" );

		m_pitchTrim				= m_api.pfn_ed_cockpit_get_parameter_handle("PITCH_TRIM");
		m_rollTrim				= m_api.pfn_ed_cockpit_get_parameter_handle("ROLL_TRIM");
		m_rudderTrim			= m_api.pfn_ed_cockpit_get_parameter_handle("RUDDER_TRIM");

		m_nws					= m_api.pfn_ed_cockpit_get_parameter_handle("FM_NWS");

		m_internalFuel = m_api.pfn_ed_cockpit_get_parameter_handle("FM_INTERNAL_FUEL");
		m_externalFuel = m_api.pfn_ed_cockpit_get_parameter_handle("FM_EXTERNAL_FUEL");

		m_radio                 = m_api.pfn_ed_cockpit_get_parameter_handle("THIS_RADIO_PTR");
		m_elec = m_api.pfn_ed_cockpit_get_parameter_handle( "THIS_ELEC_PTR" );

		m_radioPower = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_RADIO_POWER" );

		m_intercom                 = m_api.pfn_ed_cockpit_get_parameter_handle("THIS_INTERCOM_PTR");
		m_weapon                 = m_api.pfn_ed_cockpit_get_parameter_handle("THIS_WEAPON_PTR");

		m_cockpitShake = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_COCKPIT_SHAKE" );

		m_airspeed = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_AIRSPEED" );

		m_yawDamper = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_YAW_DAMPER" );

		m_beta = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_BETA" );
		m_aoa = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_AOA" );
		m_aoaUnits = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_AOA_UNITS" );

		m_validSolution = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_VALID_SOLUTION" );
		m_setTarget = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_SET_TARGET" );
		m_slantRange = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_SLANT_RANGE" );

		m_radarAltitude = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_RADAR_ALTITUDE" );
		m_gunsightAngle = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_GUNSIGHT_ANGLE" );
		m_targetSet = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_TARGET_SET" );

		m_dumpingFuel = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_DUMPING_FUEL" );
		m_avionicsAlive = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_AVIONICS_ALIVE" );

		m_lTankCapacity = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_L_TANK_CAPACITY" );
		m_cTankCapacity = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_C_TANK_CAPACITY" );
		m_rTankCapacity = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_R_TANK_CAPACITY" );

		m_sndCockpitRattle = m_api.pfn_ed_cockpit_get_parameter_handle( "SND_ALWS_COCKPIT_RATTLE" );

		m_leftSlat = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_SLAT_LEFT" );
		m_rightSlat = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_SLAT_RIGHT" );

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

	inline int getGunShells()
	{
		void* ptr = NULL;
		static char buffer[100];
		getParamString(m_intercom, buffer, 100);
		sscanf(buffer, "%p", &ptr);
		printf("Weapon Pointer is: %p\n", ptr);
		int shells = 0;
		if (ptr)
		{

		}
			//shells = _get_gun_shells(ptr,)
		return shells;
	}

	inline void* getPointer( void* handle )
	{
		char buffer[20];
		uintptr_t ptr = NULL;
		getParamString( handle, buffer, 20 );
		//printf( "%s\n", buffer );
		if ( sscanf( buffer, "%p.0", &ptr ) )
		{
			if ( ptr )
			{
				//0x20 is the offset from the lua virtual
				//function table to the primary virtual function
				//table.
				//                                                           
				//primary table | 16 bytes of data | global context pointer | lua table 
				return (void*)(ptr - 0x20);
			}
		}

		return NULL;
	}

	inline void* getIntercomPointer()
	{
		return getPointer( m_intercom );
	}

	inline void* getRadioPointer()
	{
		return getPointer( m_radio );
	}

	inline void* getElecPointer()
	{
		return getPointer( m_elec );
	}

	inline void connectAndSetRadioPower()
	{
		char buffer[100];
		void* ptr_radio = NULL;
		void* ptr_elec = NULL;
		void* ptr_intercom = NULL;
		getParamString( m_radio, buffer, 100 );
		sscanf( buffer, "%p", &ptr_radio );
		getParamString( m_elec, buffer, 100 );
		sscanf( buffer, "%p", &ptr_elec );
		printf( "Radio ptr: %p, Elec ptr: %p\n", ptr_radio, ptr_elec );
		//-0x20 since we get the pointer to the lua vfptr table


		printf( "Global Table %p\n", m_api.device_array );
		intptr_t ptr = (intptr_t)m_api.device_array + 0x30;
		ptr = (intptr_t)(*((void**)ptr));
		printf( "Cockpit Table %p\n", (void*)ptr );
		ptr_elec = *((void**)((intptr_t)ptr + 0x10));
		ptr_intercom = *((void**)((intptr_t)ptr + 0x18));
		ptr_radio = *((void**)((intptr_t)ptr + 0x20));
		

		//intptr_t cur = ptr;
		//for ( int i = 0; i < 10; i++ )
		//{
		//	void** p = (void**)cur;
		//	printf( "Offset: %p, Pointer: %p\n", (void*)(i*0x8), *p );
		//	//printf( "Offset: %p, Pointer: %p, DC1 %p, DC2 %p\n", (i * 0x8), *p, m_api.pfn_get_dc_wire( *p, 1 ), m_api.pfn_get_dc_wire( *p, 2 ) );
		//	cur += 0x8;
		//}
		//0x10 elec
		//0x18 intercom
		//0x20 radio
		printf( "Radio ptr: %p, Elec ptr: %p\n", ptr_radio, ptr_elec );


		void* ptr_wire = NULL;
		if ( ptr_elec )
		{
			ptr_wire = m_api.pfn_get_dc_wire( ptr_elec, 1 );
			printf( "AC_1 %p\n", m_api.pfn_get_ac_wire( ptr_elec, 1 ) );
			printf( "AC_2 %p\n", m_api.pfn_get_ac_wire( ptr_elec, 2 ) );
			printf( "DC_1 %p\n", m_api.pfn_get_dc_wire( ptr_elec, 1 ) );
			printf( "DC_2 %p\n", m_api.pfn_get_dc_wire( ptr_elec, 2 ) );
		}

		printf( "Wire ptr: %p\n", ptr_wire );
		
		
		//printf( "Freq %d\n", m_api.pfn_get_freq( ptr_radio ) );
		if ( ptr_radio && ptr_wire )
		{
			
			printf( "Calling %p\n", m_api.pfn_connect_electric );
			m_api.pfn_connect_electric( ptr_radio, ptr_wire );
			//_connect_radio_power( ptr_radio, ptr_elec, m_api.pfn_connect_electric );
			printf( "Radio should be connected!\n" );
			//_set_radio_power( ptr_radio, true, m_api.pfn_set_elec_power );
			printf( "Calling %p\n", m_api.pfn_set_elec_power );


			void* ptr_baseRadio = (void*)((intptr_t)ptr_radio + 0xB8);

			m_api.pfn_set_elec_power = (PFN_SET_ELEC_POWER)*(*((void***)ptr_baseRadio));

			m_api.pfn_set_elec_power( ptr_baseRadio, true );


			printf( "Radio should be powered on!\n" );

			void* ptr_communicator = m_api.pfn_get_communicator( ptr_radio );

			printf( "Communicator %p\n", ptr_communicator);
			m_api.pfn_set_communicator_as_current( ptr_communicator );

		}
		else
		{
			printf( "Something went wrong!\n" );
		}
		
	}

	inline void setIntercomPower(bool value)
	{
		void* ptr = nullptr;
		char buffer[100];
		getParamString(m_intercom, buffer, 100);
		sscanf(buffer, "%p", &ptr);
		printf("Intercom Pointer is: %p\n", ptr);
		static int x = 0;
		x++;
		if (ptr && x > 10)
		{
			//_set_radio(ptr, m_api.setRadioPowerFncPtr, true);
			if (_is_on_intercom(ptr, m_api.isOnIntercom))
			{
				printf("Intercom On\n");
				//_set_radio(ptr,false);
			}
			else
			{
				printf("Intercom Off\n");
				//_set_radio(ptr, true);
			}
		}
	}

	inline void setRadioPower(bool value)
	{
		//printf("Radio Power Pointer: %p", m_api.setRadioPowerFncPtr);
		//__asm {MOV ECX, m_radio}
		void* ptr = nullptr;
		char buffer[100];
		getParamString(m_radio, buffer, 100);
		sscanf(buffer, "%p", &ptr);
		

		void* deref = *((void**)ptr);
		void* deref2 = *((void**)deref);
		printf("Pointer is: %p\n", ptr);

		static int x = 0;
		x++;
		if (ptr && x > 10)
		{
			//_set_radio(ptr, m_api.setRadioPowerFncPtr, true);
			if (_ext_is_on(ptr, m_api.getRadioPowerFncPtr))
			{
				printf("Radio On\n");
				//_set_radio(ptr,false);
			}
			else
			{
				printf("Radio Off\n");
				//_set_radio(ptr, true);
			}
		}
	}

	inline void setLeftSlat( double number )
	{
		setParamNumber( m_leftSlat, number );
	}

	inline void setRightSlat( double number )
	{
		setParamNumber( m_rightSlat, number );
	}

	inline void setCockpitRattle( double number )
	{
		setParamNumber( m_sndCockpitRattle, number );
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

	inline void setAirspeed( double number )
	{
		setParamNumber( m_airspeed, number );
	}

	inline void setAOA( double number )
	{
		setParamNumber( m_aoa, number );
	}

	inline void setBeta( double number )
	{
		setParamNumber( m_beta, number );
	}

	inline void setAOAUnits( double number )
	{
		setParamNumber( m_aoaUnits, number );
	}

	inline void setValidSolution( bool solution )
	{
		setParamNumber( m_validSolution, (double)solution );
	}

	inline void setTargetSet( bool targetSet )
	{
		setParamNumber( m_targetSet, (double)targetSet );
	}

	inline void setStickInputPitch( double number )
	{
		setParamNumber( m_stickInputPitch, number );
	}

	inline void setStickInputRoll( double number )
	{
		setParamNumber( m_stickInputRoll, number );
	}

	inline void setLeftBrakePedal( double number )
	{
		setParamNumber( m_leftBrakePedal, number );
	}

	inline void setRightBrakePedal( double number )
	{
		setParamNumber( m_rightBrakePedal, number );
	}

	inline bool getRadioPower()
	{
		return getParamNumber( m_radioPower ) > 0.5;
	}

	inline double getSlantRange()
	{
		return getParamNumber( m_slantRange );
	}

	inline bool getSetTarget()
	{
		return getParamNumber( m_setTarget ) > 0.5;
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

	inline double getCockpitShake()
	{
		return getParamNumber( m_cockpitShake );
	}

	inline double getYawDamper()
	{
		return getParamNumber( m_yawDamper );
	}

	inline double getRadarAltitude()
	{
		return getParamNumber( m_radarAltitude );
	}

	inline double getGunsightAngle()
	{
		return getParamNumber( m_gunsightAngle );
	}

	inline bool getDumpingFuel()
	{
		return getParamNumber( m_dumpingFuel ) > 0.5;
	}

	inline bool getAvionicsAlive()
	{
		return getParamNumber( m_avionicsAlive ) > 0.5;
	}

	inline double getLTankCapacity()
	{
		return getParamNumber( m_lTankCapacity );
	}

	inline double getCTankCapacity()
	{
		return getParamNumber( m_cTankCapacity );
	}

	inline double getRTankCapacity()
	{
		return getParamNumber( m_rTankCapacity );
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

	void* m_leftBrakePedal = NULL;
	void* m_rightBrakePedal = NULL;

	void* m_stickInputPitch = NULL;
	void* m_stickInputRoll = NULL;

	void* m_engineThrottlePosition = NULL;
	void* m_engineIgnition = NULL;
	void* m_engineBleedAir = NULL;

	void* m_rollTrim = NULL;
	void* m_pitchTrim = NULL;
	void* m_rudderTrim = NULL;

	void* m_nws = NULL;

	void* m_internalFuel = NULL;
	void* m_externalFuel = NULL;

	void* m_airspeed = NULL;

	//Radio Pointer for the Radio Device.
	void* m_radio = NULL;
	void* m_elec = NULL;
	void* m_intercom = NULL;
	void* m_radioPower = NULL;
	void* m_weapon = NULL;
	void* m_cockpitShake = NULL;

	void* m_yawDamper = NULL;

	void* m_beta = NULL;
	void* m_aoa = NULL;
	void* m_aoaUnits = NULL;

	void* m_setTarget = NULL;
	void* m_validSolution = NULL;
	void* m_slantRange = NULL;

	void* m_radarAltitude = NULL;
	void* m_gunsightAngle = NULL;
	void* m_targetSet = NULL;

	void* m_dumpingFuel = NULL;

	void* m_avionicsAlive = NULL;

	void* m_lTankCapacity = NULL;
	void* m_cTankCapacity = NULL;
	void* m_rTankCapacity = NULL;

	void* m_sndCockpitRattle = NULL;

	void* m_leftSlat = NULL;
	void* m_rightSlat = NULL;

};


}//namepsace end
#endif 
