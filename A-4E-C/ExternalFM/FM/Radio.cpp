#include "Radio.h"
#include "Globals.h"

Skyhawk::Radio::Radio(Interface& inter):
	m_interface(inter)
{
	m_api = ed_get_cockpit_param_api();
}

void Skyhawk::Radio::setup( void* baseRadio, void* electricalSystem, void* intercom )
{
	if ( ! electricalSystem || ! baseRadio || ! intercom )
	{
		return;
	}

	m_intercom = intercom;

	//Get the 1st DC system wire.
	void* wire = m_api.pfn_get_dc_wire( electricalSystem, 1 );
	if ( wire )
	{
		//Connect the DC system wire to the radio.
		m_api.pfn_connect_electric( baseRadio, wire );
		LOG( "Connected Radio to Electrical System.\n" );
	}
	else
	{
		LOG( "Failed to find wire.\n" );
	}

	void* communicator = m_api.pfn_get_communicator( baseRadio );

	if ( communicator )
	{
		m_api.pfn_set_communicator_as_current( communicator );
		LOG( "Set communicator as primary.\n" );
	}
	else
	{
		LOG( "Failed to find communicator.\n" );
	}
		

	//This will just crash if it goes wrong.

	//Get the pointer to the start of the radio data
	// primary table | 16 bytes of data | global context pointer | bunch more derrived members | radio vfptr table
	m_radio = (void*)((intptr_t)baseRadio + 0xB8);

	// *radioData -> ptr_radio_vfptr_table
	// *ptr_radio_vfptr_table -> first entry in table which is the set elec power.
	fnc_setElecPower = (PFN_SET_ELEC_POWER)(*(*(void***)m_radio));

	LOG( "Radio setup complete.\n" );
	m_setup = true;
}

void Skyhawk::Radio::update()
{
	if ( m_setup )
	{
		setPower( m_interface.getRadioPower() );
		//m_api.pfn_try_set_communicator( m_intercom, 1 );
		//m_api.pfn_push_to_talk( m_intercom, true );
	}
	else
	{
		setup( m_interface.getRadioPointer(), m_interface.getElecPointer(), m_interface.getIntercomPointer() );
	}
}

void Skyhawk::Radio::cleanup()
{
	m_setup = false;
	fnc_setElecPower = NULL;
	m_radio = NULL;
}

