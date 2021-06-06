#pragma once
#include "RadarScope.h"
#include "AircraftState.h"
#include "Units.h"
#include "Maths.h"

#define NM_TO_METRE 1852.0

namespace Scooter
{

class Radar
{
public:
	Radar( Interface& inter, AircraftState& state );
	bool handleInput( int command, float value );
	void update(double dt);

private:

	enum TerrainType
	{
		LAND = 0,
		SEA = 1,
		ROAD = 2,
		RIVER = 4,
		CITY = 5,
		LAKE = 7,
		FOREST = 49,
		FARMLAND = 22
	};


	inline double rangeToDisplay( double range );
	inline double typeReflectivity( TerrainType type );


	RadarScope m_scope;
	AircraftState& m_state;
	void* m_terrain = nullptr;

	double m_scale = 1.0;

	double m_x = 0.0;
	int m_xIndex = 25;
	double m_y = 0.0;
	int m_direction = -1;
};


double Radar::rangeToDisplay( double range )
{
	return -1.0 + 2.0 * range / (20.0_nauticalMile * m_scale);
}

double Radar::typeReflectivity( TerrainType type )
{
	switch ( type )
	{
	case LAND:
		return 1.0;
	case ROAD:
		return 0.8;
	case SEA:
		return 0.01;
	case RIVER:
		return 0.001;
	case LAKE:
		return 0.001;
	case FOREST:
		return 1.0 + random() * 0.3;
	case CITY:
		return 1.0 + random();
	case FARMLAND:
		return 1.1;
	}

	return 1.0;
}

} // end namespace scooter