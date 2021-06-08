#pragma once
#include "RadarScope.h"
#include "AircraftState.h"
#include "Units.h"
#include "Maths.h"
#include "BaseComponent.h"

#define NM_TO_METRE 1852.0

struct Vec3f
{
	Vec3f() {}
	Vec3f( const Vec3& v ) :
		x( v.x ), y( v.y ), z( v.z )
	{}

	float x = 0.0;
	float y = 0.0;
	float z = 0.0;
};

namespace Scooter
{

class Radar : public BaseComponent
{
public:
	Radar( Interface& inter, AircraftState& state );

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();
	
	bool handleInput( int command, float value );
	void update(double dt);
	inline void setDisable( bool disabled );
	

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

	enum Mode
	{
		MODE_OFF,
		MODE_STBY,
		MODE_SRCH,
		MODE_TC,
		MODE_AG
	};

	enum State
	{
		STATE_OFF,
		STATE_STBY,
		STATE_SRCH,
		STATE_TC,
		STATE_AG,
	};


	inline double rangeToDisplay( double range );
	inline double typeReflectivity( TerrainType type );
	inline State getState();
	inline void warmup( double rate );

	static inline bool findIndex( size_t horizontalScanIndex, size_t verticalScanIndex, size_t& index );
	static inline void indexToScreenCoords( size_t index, double& x, double& y );
	static inline bool screenCoordToIndex( double x, double y, size_t& index );

	void scan();
	void drawScan();
	void clearScan();


	RadarScope m_scope;
	AircraftState& m_state;
	Interface& m_interface;
	void* m_terrain = nullptr;

	double m_scale = 1.0;

	int m_xIndex = 25;
	double m_y = 0.0;
	int m_direction = -1;
	int m_scanned = 0;
	bool m_disabled = true;

	//Vec3f m_scanLine[SIDE_LENGTH];
	double m_scanLine[SIDE_LENGTH];

	//Constants
	const double m_warmupTime = 180.0;
	const double m_angularResolution = 1.0_deg;

	//Internal States
	double m_warmup = 0.0;
	double m_scanHeight = 2.5_deg;

	//Switches
	Mode m_modeSwitch = MODE_OFF;
	bool m_rangeSwitch = false;
	bool m_aoaCompSwitch = false;
	double m_angle = 0.0;
	double m_detail = 1.0;
	double m_gain = 1.0;
	double m_brilliance = 1.0;
	double m_storage = 1.0;
	bool m_cleared = false;

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

void Radar::setDisable( bool disabled )
{
	m_disabled = disabled;
}

Radar::State Radar::getState()
{
	//if ( ! m_interface.getElecMonitoredAC() )
		//return STATE_OFF;

	return (State)m_modeSwitch;
}

void Radar::warmup( double rate )
{
	m_warmup += rate;
	m_warmup = clamp( m_warmup, 0.0, m_warmupTime );
}

void Radar::indexToScreenCoords( size_t index, double& x, double& y )
{
	size_t xI = index % SIDE_LENGTH;
	size_t yI = index / SIDE_LENGTH;

	x = ((double)xI / (double)SIDE_LENGTH) * 2.0 - 1.0;
	y = ((double)yI / (double)SIDE_LENGTH) * 2.0 - 1.0;
}

bool Radar::screenCoordToIndex( double x, double y, size_t& index )
{
	size_t xI = round(((x + 1.0) / 2.0) * SIDE_LENGTH);
	size_t yI = round(((y + 1.0) / 2.0) * SIDE_LENGTH);

	return findIndex( xI, yI, index);
}

bool Radar::findIndex( size_t horizontalScanIndex, size_t verticalScanIndex, size_t& index )
{
	index = horizontalScanIndex + verticalScanIndex * SIDE_LENGTH;

	if ( index >= 0 && index < MAX_BLOBS )
		return true;
	else
		return false;
}

} // end namespace scooter