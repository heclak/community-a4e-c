//=========================================================================//
//
//		FILE NAME	: Radio.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: January 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Radio trickery.
//
//================================ Includes ===============================//
#include "Radio.h"
#include "Globals.h"
//=========================================================================//

Scooter::Radio::Radio(Interface& inter):
	m_interface(inter)
{
	m_api = ed_get_cockpit_param_api();
}

Scooter::Radio::~Radio()
{
	
}

// Steps for setting radio up
//
// The following steps were found by TheRealHarold.
//
// 1. Get wire from Electrical System
// 2. Connect wire to radio
// 3. Get communicator and then set it as current.
// 4. Get a pointer to the virtual function pointer table for the inherited radio.
// 5. Use this pointer to find the setElecPower function.
// 
void Scooter::Radio::setup( void* baseRadio, void* electricalSystem, void* intercom )
{
	if ( ! electricalSystem || ! baseRadio || ! intercom )
	{
		return;
	}

	m_intercom = intercom;

	//Get the 1st DC system wire.
	void* wire = m_api.pfn_get_dc_wire( electricalSystem, 2 );
	if ( wire )
	{
		//Connect the DC system wire to the radio.
		m_api.pfn_connect_electric( baseRadio, wire );
		LOG( "Connected Radio to Electrical System. Elec: %p, Wire: %p, Radio: %p.\n", electricalSystem, baseRadio, wire );
	}
	else
	{
		LOG( "Failed to find wire.\n" );
	}

	void* communicator = m_api.pfn_get_communicator( baseRadio );

	if ( communicator )
	{
		/*m_api.pfn_set_communicator_on( communicator, true );
		m_api.pfn_set_receiver_on( communicator, true );
		m_api.pfn_set_transmitter_on( communicator, true );*/


		//printf( "Communicator: %d, Receiver %d, Transmitter %d\n", m_api.pfn_is_communicator_on( communicator ), m_api.pfn_is_receiver_on( communicator ), m_api.pfn_is_transmitter_on( communicator ) );


		m_api.pfn_set_communicator_as_current( communicator );
		//m_api.pfn_send_net_message( communicator, true );
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

void Scooter::Radio::update()
{
	//In case anyone runs into crashes.
	if ( g_disableRadio )
		return;



	//DOESNT BRING UP THE MENU!!!!
	/*intptr_t ptr = (intptr_t)m_api.pfn_get_human_communicator();
	intptr_t table = *(intptr_t*)ptr;
	if ( ptr )
	{
		PFN_OPEN_RADIO_MENU fnc = (PFN_OPEN_RADIO_MENU)(*(intptr_t*)(table + 0x50));
		printf( "Communicator %p, fnc %p\n", ptr, fnc );
		fnc( (void*)ptr );
	}*/
	
	if ( m_interface.getAvionicsAlive() )
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
}

void Scooter::Radio::cleanup()
{
	m_setup = false;
	fnc_setElecPower = NULL;
	m_radio = NULL;
}

