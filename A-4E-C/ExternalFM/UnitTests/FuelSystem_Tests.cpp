//=========================================================================//
//
//		FILE NAME	: FuelSystem_Tests.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: February 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Unit tests for the fuel system.
//
//================================ Includes ===============================//
#include "CppUnitTest.h"

//Allow access of private member variables.
#define private public
#include "../FM/FuelSystem2.h"
#include "../FM/Engine2.h"
#include <iostream>
#include <sstream>
//=========================================================================//

#define FLOAT_TOLERANCE 0.001
#define TARGET_TOLERANCE 0.1

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTests
{

	TEST_CLASS( FuelSystemTests )
	{
	public:

		/// DESCRIPTION		:	Add fuel so only wing tank is partially full.
		/// EXPECTED RESULT	:	Wing tank is filled to the expected value.
		/// FAILED RESULT	:	Wing tank not filled to expected value.
		TEST_METHOD( AddFuel1 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine(state);

			Scooter::FuelSystem2 system(engine, state );
			system.addFuel( 1000.0, true );

			Assert::AreEqual( 1000.0, system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not filled correctly.");
		}

		/// DESCRIPTION		:	Add fuel so wing tank is completely full and fuselage tank is partially fuel.
		/// EXPECTED RESULT	:	Wing tank full, fuselage tank partially full.
		/// FAILED RESULT	:	Wing tank not full and/or fuselage tank not partially full.
		TEST_METHOD( AddFuel2 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );
			system.addFuel( 2000.0, true );

			Assert::AreEqual( system.m_fuelCapacity[Scooter::FuelSystem2::TANK_WING], system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not completely filled." );
			Assert::AreEqual( 2000 - system.m_fuelCapacity[Scooter::FuelSystem2::TANK_WING], system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not filled correctly." );
		}

		/// DESCRIPTION		:	Add fuel to 1 centreline tank.
		/// EXPECTED RESULT	:	Centreline tank is partially filled.
		/// FAILED RESULT	:	Centerline tank is not partially filled.
		TEST_METHOD( AddFuelExternal1 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );
			//Set 1000 kg tank on centreline.
			system.setFuelCapacity( 0.0, 1000.0, 0.0 );

			//Flight refuel must be enabled.
			system.setExternalTankFlightRefuel( true );

			system.addFuel( 500.0, true );

			Assert::AreEqual( 500.0, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_CENTRE], L"Centreline tank not filled correctly." );
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage not empty." );
		}

		/// DESCRIPTION		:	Add fuel to 2 wing tanks.
		/// EXPECTED RESULT	:	2 wing tanks are partially filled.
		/// FAILED RESULT	:	2 wing tanks are not partially filled.
		TEST_METHOD( AddFuelExternal2 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );
			//Set 500 kg tank on wing tanks.
			system.setFuelCapacity( 500.0, 0.0, 500.0 );

			//Flight refuel must be enabled.
			system.setExternalTankFlightRefuel( true );

			system.addFuel( 500.0, true );

			Assert::AreEqual( 250.0, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_LEFT], L"Left tank not filled correctly." );
			Assert::AreEqual( 250.0, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_RIGHT], L"Right tank not filled correctly." );
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage not empty." );
		}

		/// DESCRIPTION		:	Set internal fuel so that fuselage tank is partially filled.
		/// EXPECTED RESULT	:	Fuselage tank has correct amount.
		/// FAILED RESULT	:	Fuselage tank has incorrect amount.
		TEST_METHOD( SetInternal1 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );
			Scooter::FuelSystem2 system( engine, state );

			system.setInternal( 500.0 );

			Assert::AreEqual( 500.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage not set correctly." );
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not empty." );
		}

		/// DESCRIPTION		:	Set internal fuel so that fuselage is fully filled and wing is partially filled.
		/// EXPECTED RESULT	:	Fuselage tank is full and wing tank is partially filled.
		/// FAILED RESULT	:	Fuselage tank is not full and/or wing tank is not partially filled.
		TEST_METHOD( SetInternal2 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );
			Scooter::FuelSystem2 system( engine, state );

			system.setInternal( 1000.0 );

			Assert::AreEqual( system.m_fuelCapacity[Scooter::FuelSystem2::TANK_FUSELAGE], system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage not set correctly." );
			Assert::AreEqual( 1000.0 - system.m_fuelCapacity[Scooter::FuelSystem2::TANK_FUSELAGE], system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not set correctly." );
		}

		/// DESCRIPTION		:	Overfill both tanks.
		/// EXPECTED RESULT	:	Fuselage tank and wing tank are full.
		/// FAILED RESULT	:	Fuselage tank and wing tank are not full, overfilled or less than full.
		TEST_METHOD( SetInternal3 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );
			Scooter::FuelSystem2 system( engine, state );

			//Overfill the tanks.
			system.setInternal( 3000 );

			Assert::AreEqual( system.m_fuelCapacity[Scooter::FuelSystem2::TANK_FUSELAGE], system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage not set correctly." );
			Assert::AreEqual( system.m_fuelCapacity[Scooter::FuelSystem2::TANK_WING], system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not set correctly." );
		}

		/// DESCRIPTION		:	Remove fuel so fuselage tank is partially full.
		/// EXPECTED RESULT	:	Fuselage tank is filled to the expected value.
		/// FAILED RESULT	:	Fuselage tank not filled to expected value.
		TEST_METHOD( RemoveFuel1 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );
			system.setInternal( 200 );

			system.addFuel( -100.0 );

			Assert::AreEqual( 100.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not filled correctly." );
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not empty." );
		}

		/// DESCRIPTION		:	Remove fuel so wing tank becomes empty and fuselage is partially full.
		/// EXPECTED RESULT	:	Fuselage tank is filled to expected value and wing tank is empty.
		/// FAILED RESULT	:	Fuselage tank is not filled to expected value and/or wing tank is not empty.
		TEST_METHOD( RemoveFuel2 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );

			//Fuselage tank is full and wing tank is partially filled
			system.setInternal( 1000 );

			system.addFuel( -300.0 );

			//700 (minimum usable fuel).
			Assert::AreEqual( 700.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not filled correctly." );

			//15.0 is the minimum usable fuel.
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not empty." );
		}

		/// DESCRIPTION		:	Remove fuel so external centre tank becomes empty and fuselage is partially full.
		/// EXPECTED RESULT	:	Fuselage tank is filled to expected value and external centre tank is empty.
		/// FAILED RESULT	:	Fuselage tank is not filled to expected value and/or external centre tank is not empty.
		TEST_METHOD( RemoveFuelExternal1 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );

			//Fuselage tank is full and wing tank is partially filled
			system.setInternal( 500 );
			system.setFuelCapacity( 0.0, 1000.0, 0.0 );
			system.setFuelQty( Scooter::FuelSystem2::TANK_EXTERNAL_CENTRE, Vec3(), 200 );
			system.setExternalTankFlightRefuel( true );

			system.addFuel( -300.0 );

			//500 - 115.0 (minimum usable fuel), since 115 is left over from centre tank.
			Assert::AreEqual( 400.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not filled correctly." );

			//15.0 is the minimum usable fuel.
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_CENTRE], L"External Centre tank not empty." );
		}

		/// DESCRIPTION		:	Remove fuel so 2 external wing tanks become empty and fuselage is partially full.
		/// EXPECTED RESULT	:	Fuselage tank is filled to expected value and 2 external wing tank are empty.
		/// FAILED RESULT	:	Fuselage tank is not filled to expected value and/or 2 external wing tank are not empty.
		TEST_METHOD( RemoveFuelExternal2 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );

			Scooter::FuelSystem2 system( engine, state );

			//Fuselage tank is full and wing tank is partially filled
			system.setInternal( 500 );
			system.setFuelCapacity( 500.0, 0.0, 500.0 );
			system.setFuelQty( Scooter::FuelSystem2::TANK_EXTERNAL_LEFT, Vec3(), 100 );
			system.setFuelQty( Scooter::FuelSystem2::TANK_EXTERNAL_RIGHT, Vec3(), 100 );
			system.setExternalTankFlightRefuel( true );

			system.addFuel( -300.0 );

			//500 (minimum usable fuel)
			Assert::AreEqual( 400.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not filled correctly." );

			//0.0 is the minimum usable fuel.
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_LEFT], L"External Left tank not empty." );
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_RIGHT], L"External Right tank not empty." );
		}

		/// DESCRIPTION		:	Update with only fuselage tank with any fuel.
		/// EXPECTED RESULT	:	Fuselage tank is filled to expected value and 2 external wing tank are empty.
		/// FAILED RESULT	:	Fuselage tank is not filled to expected value and/or 2 external wing tank are not empty.
		TEST_METHOD( Update1 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );
			engine.m_hpOmega = 1000;
			engine.m_lpOmega = 1000;

			Scooter::FuelSystem2 system( engine, state );
			system.setInternal( 500 );
			engine.m_correctedFuelFlow = 1.0;
			engine.m_fuelFlow = 1.0;
			//dt = 1.0 s dm = 1.0 kg
			system.update( 1.0 );
			system.update( 1.0 );
			system.update( 1.0 );

			Assert::AreEqual( 497.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not at correct value." );
			Assert::AreEqual( 0.0, system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not empty." );
		}

		/// DESCRIPTION		:	Update with only fuselage tank with any fuel.
		/// EXPECTED RESULT	:	Fuselage and wing tanks are filled to expected value.
		/// FAILED RESULT	:	Fuselage and/or wing tanks are not filled to expected value.
		TEST_METHOD( Update2 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );
			engine.m_hpOmega = 1000;
			engine.m_lpOmega = 1000;
			engine.m_fuelFlow = 100.0;

			Scooter::FuelSystem2 system( engine, state );
			system.setInternal( 800 );
			engine.m_correctedFuelFlow = 1.0;
			engine.m_fuelFlow = 1.0;
			//dt = 1.0 s dm = 100.0 kg
			system.update( 1.0 );
			system.update( 1.0 );
			system.update( 1.0 );

			Assert::AreEqual( 731.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not at correct value." );
			Assert::AreEqual( 66.0, system.m_fuel[Scooter::FuelSystem2::TANK_WING], L"Wing tank not empty." );
		}

		/// DESCRIPTION		:	Update with only fuselage tank with any fuel.
		/// EXPECTED RESULT	:	Fuselage and wing tanks are filled to expected value.
		/// FAILED RESULT	:	Fuselage and/or wing tanks are not filled to expected value.
		TEST_METHOD( Update3 )
		{
			Scooter::AircraftState state;
			Scooter::Engine2 engine( state );
			engine.m_hpOmega = 1000;
			engine.m_lpOmega = 1000;

			Scooter::FuelSystem2 system( engine, state );
			system.setInternal( 3000 );
			system.setFuelCapacity( 100.0, 100.0, 100.0 );
			system.setFuelQty( Scooter::FuelSystem2::TANK_EXTERNAL_LEFT, Vec3(), 100.0 );
			system.setFuelQty( Scooter::FuelSystem2::TANK_EXTERNAL_CENTRE, Vec3(), 100.0 );
			system.setFuelQty( Scooter::FuelSystem2::TANK_EXTERNAL_RIGHT, Vec3(), 100.0 );
			//dt = 1.0 s dm = 1.0 kg
			engine.m_fuelFlow = 1.0;
			engine.m_correctedFuelFlow = 1.0;
			system.update( 1.0 );
			system.update( 1.0 );
			system.update( 1.0 );
			system.update( 1.0 );

			Assert::AreEqual( 731.0, system.m_fuel[Scooter::FuelSystem2::TANK_FUSELAGE], L"Fuselage tank not at correct value." ); // tank has 1.8 transfered to it from wing
			Assert::AreEqual( 1736.78, system.m_fuel[Scooter::FuelSystem2::TANK_WING], FLOAT_TOLERANCE, L"Wing tank not at correct value." ); // tank is filled by external tanks
			Assert::AreEqual( 98.8, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_LEFT], FLOAT_TOLERANCE, L"Left External tank not at correct value." );
			Assert::AreEqual( 98.62, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_CENTRE], FLOAT_TOLERANCE, L"Centre External tank not at correct value." );
			Assert::AreEqual( 98.8, system.m_fuel[Scooter::FuelSystem2::TANK_EXTERNAL_RIGHT], FLOAT_TOLERANCE, L"Right External tank not at correct value." );
		}

		//Still need more test coverage. I cba for now.

	};

} //end UnitTests namespace

