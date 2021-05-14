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
	//Fetch the ID
	uint32_t id = m_interface.getTCNObjectID();

	//Fetch the name
	char name[50] = "";
	const unsigned int size = 50;
	m_interface.getTCNObjectName( name, size );

	Vec3 pos;
	double heading = 0.0;


	bool valid = false;
#ifdef USE_OBJECT_FINDER
	void* ptr = m_finder.find( id, name );
	valid = m_finder.findPosition( id, name, pos, heading );
	printf( "ID: %d, PTR: %p, x: %lf, y: %lf, z: %lf\n", id, ptr, pos.x, pos.y, pos.z );
#endif

	m_interface.setTacanValid( valid );
	m_interface.setTacanX( pos.x );
	m_interface.setTacanY( pos.y );
	m_interface.setTacanZ( pos.z );
	m_interface.setICLSHeading( heading );
}