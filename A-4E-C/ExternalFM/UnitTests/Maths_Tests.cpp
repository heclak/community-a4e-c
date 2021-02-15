//=========================================================================//
//
//		FILE NAME	: Maths_Tests.cpp
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
#include "../FM/Maths.h"
//=========================================================================//

#define FLOAT_TOLERANCE 0.001
#define TARGET_TOLERANCE 0.1

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTests
{

	TEST_CLASS( MathsTests )
	{
	public:

		/// DESCRIPTION		:	
		/// EXPECTED RESULT	:	
		/// FAILED RESULT	:	
		TEST_METHOD( RotateVectorIntoXYPlane1 ) //rename
		{
			Vec3 input(4.0, 1.0, 3.0);
			Vec3 result = Scooter::rotateVectorIntoXYPlane(input);
			
			Assert::AreEqual( result.x, 5.0 );
			Assert::AreEqual( result.y, 1.0 );
			Assert::AreEqual( result.z, 0.0 );
		}

		/// DESCRIPTION		:	
		/// EXPECTED RESULT	:	
		/// FAILED RESULT	:	
		TEST_METHOD( RotateVectorIntoXYPlane2 ) //rename
		{
			Vec3 input( -4.0, 1.0, -3.0 );
			Vec3 result = Scooter::rotateVectorIntoXYPlane( input );

			Assert::AreEqual( 5.0, result.x );
			Assert::AreEqual(  1.0, result.y );
			Assert::AreEqual( 0.0, result.z );
		}

	};

} //end UnitTests namespace
