//=========================================================================//
//
//		FILE NAME	: CP741.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	CP-741/A bombing computer class. Calculates bomb travel
//						distance using the current aircraft state vector.
//						This just solves the equation for a parabola, so no
//						air resistance is taken into account.
//
//================================ Includes ===============================//
#include "CP741.h"
#include <stdio.h>
#include <math.h>
#include "Maths.h"
//=========================================================================//

//             angle from weapons dataum + fudge factor
#define c_weaponDatum (0.05235987756 + 0.01)
#define PULL_UP_ANGLE 0.785398

Scooter::CP741::CP741( AircraftState& state ):
	m_state(state)
{
	
}

void Scooter::CP741::zeroInit()
{
	m_solution = false;
	m_power = false;
	m_targetSet = false;
	m_target = Vec3();
	m_gunsightAngle = 0.0;
}

void Scooter::CP741::coldInit()
{

}

void Scooter::CP741::hotInit()
{

}

void Scooter::CP741::airborneInit()
{

}

void Scooter::CP741::updateSolution()
{
	//Must be turned on
	if ( ! m_power )
		return;

	//Target must be set otherwise we can't range to anything.
	if ( ! m_targetSet )
		return;

	//We already have a solution
	if ( m_solution )
		return;

	//Target must be below us.
	if ( m_target.y > m_state.getWorldPosition().y )
		return;

	double error = fabs( calculateHorizontalDistance() - calculateImpactDistance( 0.0 ));

	if ( error < 5.0 )
	{
		m_solution = true;
		//printf( "Bomb away!\n" );
	}
}

double Scooter::CP741::calculateHorizontalDistance()
{
	Vec3 distance = m_target - m_state.getWorldPosition();
	distance.y = 0.0;
	Vec3 velocity = m_state.getWorldVelocity();
	velocity.y = 0.0;

	double sign = distance * velocity > 0.0 ? 1.0 : -1.0;
	//Horizontal component
	return sign*magnitude( distance );
}

void Scooter::CP741::setTarget( bool set, double slant )
{
	if ( ! m_power )
	{
		m_solution = false;
		m_targetSet = false;
		m_targetFound = false;
		return;
	}

	//Pitch - weapon datum
	double weaponAngle = m_state.getAngle().z - c_weaponDatum - m_gunsightAngle;

	//If there is no radar data and we are not going to create a singularity
	//then use the radar altimiter.
	if ( slant <= 10.0 && weaponAngle != 0.0 )
	{
		if ( weaponAngle < 0.0 )
		{
			slant = m_state.getRadarAltitude() / fabs(sin( weaponAngle ));
		}
	}

	//If the target is already set we do not want to set it again.
	if ( m_targetSet )
	{
		//If the target is set and the command is to unset then
		//we need to unset the target and reset solution.
		if ( ! set )
		{
			m_targetSet = false;
			m_solution = false;
			m_targetFound = false;
		}
	}
	else if ( slant > 10.0)
	{
		//Reset solution.
		m_solution = false;
		m_targetFound = true;

		//Set target to what was passed. We need to continually update the position
		//tracked by the radar, this is to give a valid inrange light.
		m_targetSet = set;
		
		Vec3 direction = directionVector( weaponAngle, m_state.getAngle().y );
		m_target = direction * slant + m_state.getWorldPosition();
	}
	else
	{
		m_targetFound = false;
	}
}

double Scooter::CP741::calculateImpactDistance( double angle ) const
{
	Vec3 velocity = rotateVectorIntoXYPlane(m_state.getWorldVelocity());

	if ( angle != 0.0 )
	{
		velocity = rotate( velocity, angle, 0.0 );
	}

	//Calculate time until impact.
	double ua = velocity.y / (-9.81);
	double h = m_target.y - m_state.getWorldPosition().y;
	double t = -ua + sqrt( ua * ua + (2.0*h) / (-9.81) );


	//Get horizontal component distance.
	double distHoriz = velocity.x * t;
	return distHoriz;
}


bool Scooter::CP741::inRange()
{
	//printf( "Found: %d Power: %d\n", m_targetFound, m_power );

	if ( ! m_targetFound || ! m_power )
		return false;

	double impactAt45 = calculateImpactDistance( PULL_UP_ANGLE );
	double distance = calculateHorizontalDistance();
	//printf("%lf, %lf\n", impactAt45, distance );
	return impactAt45 >= distance;
}

