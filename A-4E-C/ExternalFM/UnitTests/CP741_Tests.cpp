//=========================================================================//
//
//		FILE NAME	: CP741_Tests.cpp
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
#include "../FM/AircraftState.h"
#include "../FM/CP741.h"
//=========================================================================//

#define FLOAT_TOLERANCE 0.001
#define TARGET_TOLERANCE 0.1

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTests
{
TEST_CLASS( CP741Tests )
{
public:

	//////////////////////////////////////////////////////////
	//
	//				     SET TARGET TESTS
	//
	//////////////////////////////////////////////////////////
	void setupTargetTestData
	(
		Scooter::AircraftState& state,
		Scooter::CP741& computer,
		Vec3 velocity,
		double altitude,
		double radarAltitude,
		double pitchAngle,
		double gunsightAngle
	)
	{
		state.setCurrentStateWorldAxis( { 0.0, altitude, 0.0 }, velocity, Vec3(), Vec3() );
		state.setRadarAltitude( radarAltitude );
		state.setCurrentStateBodyAxis( 0.0, 0.0, { 0.0, 0.0, toRad( pitchAngle ) }, Vec3(), Vec3(), Vec3(), Vec3(), Vec3() );
		computer.setGunsightAngle( gunsightAngle );
		computer.setPower( true );
	}

	/// DESCRIPTION		:	Set Target using slant ranging from radar.
	/// EXPECTED RESULT	:	Target is set.
	/// FAILED RESULT	:	Target not set.
	TEST_METHOD( SetTarget1 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = -45.0;
		double slantRange = 1000.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle);

		computer.setTarget( true, slantRange );

		Assert::IsTrue( computer.getTargetSet(), L"Target was not set.");
	}

	/// DESCRIPTION		:	Set Target using radar altimiter.
	/// EXPECTED RESULT	:	Target is set.
	/// FAILED RESULT	:	Target not set.
	TEST_METHOD( SetTarget2 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = altitude;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );

		Assert::IsTrue( computer.getTargetSet(), L"Target was not set." );
	}

	/// DESCRIPTION		:	Try to set Target but no radar altimiter or slant
	///						ranging information is available.
	/// EXPECTED RESULT	:	Target is not set.
	/// FAILED RESULT	:	Target is set.
	TEST_METHOD( SetTarget3 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );

		Assert::IsFalse( computer.getTargetSet(), L"Target was set." );
	}

	/// DESCRIPTION		:	Try to set Target with radar altimiter but aircraft
	///						is pointing upwards meaning no solution should be
	///						possible.
	/// EXPECTED RESULT	:	Target is not set.
	/// FAILED RESULT	:	Target is set.
	TEST_METHOD( SetTarget4 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = 45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );

		Assert::IsFalse( computer.getTargetSet(), L"Target was set." );
	}

	/// DESCRIPTION		:	Set target then unset the target.
	///						possible.
	/// EXPECTED RESULT	:	Target is not set.
	/// FAILED RESULT	:	Target is set.
	TEST_METHOD( SetTarget5 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 1000.0;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );

		Assert::IsTrue( computer.getTargetSet(), L"Target was not set." );

		computer.setTarget( false, slantRange );

		Assert::IsFalse( computer.getTargetSet(), L"Target was still set." );
	}

	//////////////////////////////////////////////////////////
	//
	//				CALCULATE BOMB RANGE TESTS
	//
	//////////////////////////////////////////////////////////


	/// DESCRIPTION		:	Calculate range of bomb falling with forwards down
	///						velocity.
	/// EXPECTED RESULT	:	Correct distance calculated.
	/// FAILED RESULT	:	Incorrect distance calculated.
	TEST_METHOD( CalculateBombRange1 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = 45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		Assert::AreEqual( 470.852, computer.calculateImpactDistance( 0.0 ), TARGET_TOLERANCE, L"Bomb range was not correct." );
	}

	/// DESCRIPTION		:	Calculate range of bomb falling with forwards up
	///						velocity.
	/// EXPECTED RESULT	:	Correct distance calculated.
	/// FAILED RESULT	:	Incorrect distance calculated.
	TEST_METHOD( CalculateBombRange2 )
	{
		//Data
		Vec3 velocity = { 50, 60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = 45.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		Assert::AreEqual( 1082.472 , computer.calculateImpactDistance( 0.0 ), TARGET_TOLERANCE, L"Bomb range was not correct." );
	}

	//////////////////////////////////////////////////////////
	//
	//		     CALCULATE TARGET RANGE TESTS
	//
	//////////////////////////////////////////////////////////

	/// DESCRIPTION		:	Calculate range to target using radar altimiter.
	///						possible.
	/// EXPECTED RESULT	:	Target range is correct.
	/// FAILED RESULT	:	Target range is incorrect.
	TEST_METHOD( CalculateTargetRange1 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = -45.0;
		double slantRange = 1000.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );
		Assert::IsTrue( computer.getTargetSet(), L"Target was not set." );


		Assert::AreEqual( 661.666, computer.calculateHorizontalDistance(), TARGET_TOLERANCE, L"Target range was not correct." );
	}

	/// DESCRIPTION		:	Calculate range to target using radar slant range.
	/// EXPECTED RESULT	:	Solution is found.
	/// FAILED RESULT	:	Solution is not found.
	TEST_METHOD( CalculateTargetRange2 )
	{
		//Data
		Vec3 velocity = { 50, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = altitude;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );
		
		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );
		Assert::IsTrue( computer.getTargetSet(), L"Target was not set." );


		Assert::AreEqual( 882.458, computer.calculateHorizontalDistance() , TARGET_TOLERANCE, L"Target range was not correct." );
	}

	//////////////////////////////////////////////////////////
	//
	//		         CHECK TARGET SOLUTION
	//
	//////////////////////////////////////////////////////////

	/// DESCRIPTION		:	Check for valid bombing solution using radar altitude.
	/// EXPECTED RESULT	:	Solution is found.
	/// FAILED RESULT	:	Solution is not found.
	TEST_METHOD( CheckTargetSolution1 )
	{
		//Data 86.0
		Vec3 velocity = { 86.0 , -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = 0.0;
		double pitchAngle = -45.0;
		double slantRange = 1000.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );
		Assert::IsTrue( computer.getTargetSet(), L"Target was not set." );

		
		computer.updateSolution();

		Assert::IsTrue( computer.getSolution(), L"No bombing solution found." );
	}

	/// DESCRIPTION		:	Check for valid bombing solution using radar altitude.
	/// EXPECTED RESULT	:	Solution is found.
	/// FAILED RESULT	:	Solution not found.
	TEST_METHOD( CheckTargetSolution2 )
	{
		//Data
		Vec3 velocity = { 94, -60.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = altitude;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( true, slantRange );
		Assert::IsTrue( computer.getTargetSet(), L"Target was not set." );

		computer.updateSolution();

		Assert::IsTrue( computer.getSolution(), L"No bombing solution found."  );
	}

	//////////////////////////////////////////////////////////
	//
	//		            IN RANGE TESTS
	//
	//////////////////////////////////////////////////////////

	/// DESCRIPTION		:	Confirm whether a pull up of 45 degrees
	///						would release the bomb.
	/// EXPECTED RESULT	:	Target is in range.
	/// FAILED RESULT	:	Target is not in range.
	TEST_METHOD( InRange1 )
	{
		//Data
		Vec3 velocity = { 0, -60.0, 74.0 };
		double altitude = 1000.0;
		double radarAltitude = altitude;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( false, slantRange );

		Assert::IsTrue( computer.inRange(), L"Not in range." );
	}

	/// DESCRIPTION		:	Confirm whether a pull up of 45 degrees
	///						would release the bomb.
	/// EXPECTED RESULT	:	Target is not in range.
	/// FAILED RESULT	:	Target is in range.
	TEST_METHOD( InRange2 )
	{
		//Data
		Vec3 velocity = { 34, -30.0, 0.0 };
		double altitude = 1000.0;
		double radarAltitude = altitude;
		double pitchAngle = -45.0;
		double slantRange = 0.0;
		double gunsightAngle = 0.0;

		Scooter::AircraftState state;
		Scooter::CP741 computer( state );

		setupTargetTestData( state, computer,
			velocity, altitude, radarAltitude, pitchAngle, gunsightAngle );

		computer.setTarget( false, slantRange );

		Assert::IsFalse( computer.inRange(), L"In range." );
	}
};

} //end UnitTests namespace
