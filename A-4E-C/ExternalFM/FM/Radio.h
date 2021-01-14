#pragma once
#include "Interface.h"
#include "../include/Cockpit/ccParametersAPI.h"
#include <stdlib.h>

namespace Skyhawk
{

class Radio
{
public:
	Radio(Interface& inter);
	
	void setup(void* radio, void* electricalSystem, void* intercom);
	void update();
	void cleanup();
	inline void setPower( bool power );
	inline bool isSetup();
	inline void toggleRadioMenu();

private:
	void* m_radio = NULL;
	void* m_intercom = NULL;
	bool m_setup = false;
	bool m_on = false;

	cockpit_param_api m_api;
	Interface& m_interface;
	PFN_SET_ELEC_POWER fnc_setElecPower = NULL;
};

void Radio::setPower( bool power )
{
	if ( power == m_on )
		return;

	if ( fnc_setElecPower && m_radio )
	{
		fnc_setElecPower( m_radio, power );
		m_on = power;
	}
}

bool Radio::isSetup()
{
	return m_setup;
}

void Radio::toggleRadioMenu()
{
	if ( m_intercom )
	{
		//m_api.pfn_push_to_talk( m_intercom, true );
		//printf( "Toggle Radio\n" );
	}
}


}//end namespace

