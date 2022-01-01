//=========================================================================//
//
//		FILE NAME	: AeroElement_Tests.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: February 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Unit tests for the CP741/A bombing computer.
//
//================================ Includes ===============================//
#include "CppUnitTest.h"

//Allow access of private member variables.
#define private public
#include "../FM/AircraftState.h"
#include "../FM/AeroElement.h"
//=========================================================================//

#define FLOAT_TOLERANCE 0.001
#define TARGET_TOLERANCE 0.1

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTests
{

TEST_CLASS( AeroElementTests )
{
public:

	void setupAeroElement( Scooter::AeroElement& element )
	{

	}

	/// DESCRIPTION		:	
	/// EXPECTED RESULT	:	
	/// FAILED RESULT	:	
	TEST_METHOD( Test1 ) //rename
	{
		Scooter::AircraftState state;
		Table table( {}, 0.0, 0.0 );
		//Scooter::AeroElement element(state, Scooter::AeroElement::HORIZONTAL, table, table, Vec3(), Vec3(), 0.0);
	}

};

} //end UnitTests namespace
