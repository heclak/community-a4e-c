//=========================================================================//
//
//		FILE NAME	: Beacon.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	This is for providing an interface to get moving beacon info
//						namely TACAN and ICLS information.
//
//================================ Includes ===============================//
#include "Beacon.h"

Scooter::Beacon::Beacon( Interface& inter ) :
	m_interface( inter )
{

}

void Scooter::Beacon::update()
{
	updateTacan();
	updateMCL();
}

void Scooter::Beacon::updateTacan()
{
	char name[50] = "";
	const unsigned int size = 50;
	uint32_t id = m_interface.getTacanObjectID();
	m_interface.getTacanObjectName( name, size );

	Vec3 pos;
	double heading = 0.0; //dummy
	bool valid = false;
#ifdef USE_OBJECT_FINDER
	valid = m_finder.findPosition( id, name, pos, heading );
#endif

	m_interface.setTacanPosition( pos );
	m_interface.setTacanValid( valid );
}

void Scooter::Beacon::updateMCL()
{
	char name[50] = "";
	const unsigned int size = 50;
	uint32_t id = m_interface.getMCLObjectID();
	m_interface.getMCLObjectName( name, size );


	Vec3 pos;
	double heading = 0.0; //dummy
	bool valid = false;
#ifdef USE_OBJECT_FINDER
	valid = m_finder.findPosition( id, name, pos, heading );
	//printf( "Heading: %lf, Valid %d\n", heading, valid );
#endif

	m_interface.setMCLPosition( pos );
	m_interface.setMCLHeading( heading );
	m_interface.setMCLValid( valid );
}