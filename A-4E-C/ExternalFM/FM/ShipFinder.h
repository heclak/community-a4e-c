#pragma once
//=========================================================================//
//
//		FILE NAME	: ShipFinder.h
//		AUTHOR		: Joshua Nelson
//		DATE		: Novemeber 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	: Finds the ships using the avionics dll. This is intentionally hidden because
//					  sharing the reverse engineered content would break the ED EULA.
// 
//
//================================ Includes ===============================//

// This is an optional include. If the Avionics/ShipFinder.h class is not found stubs will be used.
// If anyone from Eagle Dynamics wishes to know how the underlying mechanism works please contact 
// me at joshnel123@gmail.com and I would be more than willing to share the code.

#define USE_HACKS
#ifdef USE_HACKS

#if __has_include("Avionics/ShipFinder.h")
#define USE_SHIP_FINDER
#pragma comment(lib, "AvionicsUtils.lib")
#include "Avionics/ShipFinder.h"
#endif

#endif // end USE_HACKS
#include "Ship.h"
#include <vector>


inline const std::vector<Ship>* getShips()
{
#ifdef USE_SHIP_FINDER
	return findShips();
#else
	return nullptr;
#endif
}