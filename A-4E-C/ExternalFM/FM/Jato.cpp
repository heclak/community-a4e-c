//=========================================================================//
//
//		FILE NAME	: Jato.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Implementation for the Jato system.
//
//================================ Includes ===============================//
#include "Jato.h"
#include "Commands.h"

Scooter::Jato::Jato( Scooter::FlightModel& fm ) :
	m_fm( fm ),
	m_forceLeft( 20017.0, 0.0, 0.0 ),
	m_forceRight( 20017.0, 0.0, 0.0 ),
	m_positionLeft( -4.0, -0.3, -0.5),
	m_positionRight( -4.0, -0.3, 0.5)
{

}

void Scooter::Jato::update(double dt)
{
	if ( m_fuelLeft <= 0.0 )
		m_leftLit = false;

	if ( m_fuelRight <= 0.0 )
		m_rightLit = false;


	if ( m_leftLit )
	{
		m_fm.addForce( m_forceLeft, m_positionLeft );
		m_fuelLeft -= dt;
	}

	if ( m_rightLit )
	{
		m_fm.addForce( m_forceRight, m_positionRight );
		m_fuelRight -= dt;
	}
}