//=========================================================================//
//
//		FILE NAME	: Maths.cpp
//		AUTHOR		: TerjeTL
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Utility maths functions.
//
//================================ Includes ===============================//
#include <math.h>
#include "Maths.h"
//=========================================================================//

namespace Scooter
{	// start namespace

const Vec3 windAxisToBody(const Vec3& force, const double& alpha, const double& beta)
{
	double sin_b = sin(beta);
	double cos_b = cos(beta);
	double sin_a = sin(-alpha);
	double cos_a = cos(-alpha);

	double res_x = cos_b * cos_a * force.x + sin_b * force.z - cos_b * sin_a * force.y;
	double res_z = -cos_a * sin_b * force.x + cos_b * force.z + sin_a * sin_b * force.y;
	double res_y = sin_a * force.x + cos_a * force.y;

	return Vec3(res_x, res_y, res_z);
}


const Vec3 directionVector( const double pitch, const double yaw )
{
	double cosPitch = cos( pitch );
	double sinPitch = sin( pitch );
	double cosYaw = cos( yaw );
	double sinYaw = sin( -yaw );

	Vec3 newV;
	newV.x = cosYaw * cosPitch;
	newV.z = sinYaw * cosPitch;
	newV.y = sinPitch;

	return normalize(newV);
}

}	// end namespace

