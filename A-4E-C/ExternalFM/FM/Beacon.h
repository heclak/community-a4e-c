#pragma once
//=========================================================================//
//
//		FILE NAME	: Beacon.h
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	This is for providing an interface to get moving beacon info
//						namely TACAN and ICLS information.
//
//================================ Includes ===============================//

// This is an optional include. If the ObjectFinder.h class is not found stubs will be used.
// If anyone from Eagle Dynamics wishes to know how this works please contact me at joshnel123@gmail.com.
#if __has_include("optional_headers/ObjectFinder.h")
#define USE_OBJECT_FINDER
#include "optional_headers/ObjectFinder.h"
#endif

#include "Vec3.h"
#include "Interface.h"

#ifndef USE_OBJECT_FINDER
typedef bool ObjectFinder;
#endif

namespace Scooter
{

class Beacon
{
public:
	Beacon( Interface& inter );

	void update();
	void updateTacan();
	void updateMCL();

	inline const Vec3& getPosition() const;
	inline const float getHeading() const; //degrees

private:
	Interface& m_interface;

	float m_heading = 0.0;
	Vec3 m_position;
	

	ObjectFinder m_finder;
};

inline const Vec3& Beacon::getPosition() const
{
	return m_position;
}

inline const float Beacon::getHeading() const
{
	return m_heading;
}

} //end namespace Scooter

