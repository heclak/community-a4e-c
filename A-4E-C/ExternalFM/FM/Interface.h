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
#include "Globals.h"

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
		m_cp741Power = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_CP741_POWER" );
		m_inRange = m_api.pfn_ed_cockpit_get_parameter_handle( "D_ADVISORY_INRANGE" );

		m_dumpingFuel = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_DUMPING_FUEL" );
		m_avionicsAlive = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_AVIONICS_ALIVE" );

		m_lTankCapacity = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_L_TANK_CAPACITY" );
		m_cTankCapacity = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_C_TANK_CAPACITY" );
		m_rTankCapacity = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_R_TANK_CAPACITY" );

		m_sndCockpitRattle = m_api.pfn_ed_cockpit_get_parameter_handle( "SND_ALWS_COCKPIT_RATTLE" );

		m_leftSlat = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_SLAT_LEFT" );
		m_rightSlat = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_SLAT_RIGHT" );

		m_usingFFB = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_USING_FFB" );

		m_elecPrimaryAC = m_api.pfn_ed_cockpit_get_parameter_handle( "ELEC_PRIMARY_AC_OK" );
		m_elecPrimaryDC = m_api.pfn_ed_cockpit_get_parameter_handle( "ELEC_PRIMARY_DC_OK" );
		m_elecMonitoredAC = m_api.pfn_ed_cockpit_get_parameter_handle( "ELEC_AFT_MON_AC_OK" );
		m_masterTest = m_api.pfn_ed_cockpit_get_parameter_handle( "D_MASTER_TEST" );

		m_fuelTransferCaution = m_api.pfn_ed_cockpit_get_parameter_handle( "D_FUELTRANS_CAUTION" );
		m_fuelBoostCaution = m_api.pfn_ed_cockpit_get_parameter_handle( "D_FUELBOOST_CAUTION" );

		m_gForce = m_api.pfn_ed_cockpit_get_parameter_handle( "FM_GFORCE" );

	}

	cockpit_param_api& api()
	{
		return m_api;
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

	inline void* getPointer( void* handle )
	{
		char buffer[20];
		uintptr_t ptr = NULL;
		getParamString( handle, buffer, 20 );
		printf( "%s\n", buffer );
		//printf( "%s\n", buffer );
		if ( sscanf_s( buffer, "%p.0", &ptr ) )
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
		else
		{
			LOG("Pointer could not be found from string: %s\n", buffer)
		}

		return NULL;
	}

	inline void* getIntercomPointer()
	{
		printf( "Intercom: " );
		return getPointer( m_intercom );
	}

	inline void* getRadioPointer()
	{
		printf( "Radio: " );
		return getPointer( m_radio );
	}

	inline void* getElecPointer()
	{
		printf( "Elec: " );
		return getPointer( m_elec );
	}

	inline void* getWeapPointer()
	{
		printf( "Weapon: " );
		return getPointer( m_weapon );
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

	inline void setUsingFFB( bool ffb )
	{
		setParamNumber( m_usingFFB, (double)ffb );
	}

	inline void setInRange( bool inRange )
	{
		setParamNumber( m_inRange, (double)inRange );
	}

	inline void setFuelTransferCaution( bool caution )
	{
		setParamNumber( m_fuelTransferCaution, (double)caution );
	}

	inline void setFuelBoostCaution( bool caution )
	{
		setParamNumber( m_fuelBoostCaution, (double)caution );
	}

	inline double getGForce()
	{
		return getParamNumber( m_gForce );
	}

	inline bool getCP741Power()
	{
		return getParamNumber( m_cp741Power ) > 0.5;
	}

	inline bool getElecPrimaryAC()
	{
		return getParamNumber( m_elecPrimaryAC ) > 0.5;
	}

	inline bool getElecPrimaryDC()
	{
		return getParamNumber( m_elecPrimaryDC ) > 0.5;
	}

	inline bool getElecMonitoredAC()
	{
		return getParamNumber( m_elecMonitoredAC ) > 0.5;
	}

	inline bool getMasterTest()
	{
		return getParamNumber( m_masterTest ) > 0.5;
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
	void* m_cp741Power = NULL;
	void* m_inRange = NULL;

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

	void* m_usingFFB = NULL;

	//Electrics
	void* m_fuelTransferCaution = NULL;
	void* m_fuelBoostCaution = NULL;

	void* m_elecPrimaryAC = NULL;
	void* m_elecPrimaryDC = NULL;
	void* m_elecMonitoredAC = NULL;

	void* m_masterTest = NULL;

	void* m_gForce = NULL;
};


}//namepsace end
#endif 
