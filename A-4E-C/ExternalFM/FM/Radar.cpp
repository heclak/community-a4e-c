#include "Radar.h"
#include "Maths.h"
#include "Commands.h"
#include <math.h>
#include "cockpit_base_api.h"
#include "Devices.h"



extern "C"
{
	void* _find_vfptr_fnc( void*, intptr_t );
}

typedef bool (*FNC_INTERSECTION)(void* object, Vec3f* point, Vec3f* direction, float maxDist, Vec3f* out);
typedef unsigned char (*FNC_TYPE)(void* object, float x, float z);
typedef void ( *FNC_GET_NORMAL )(void* object, Vec3f* n, float x, float z);

Scooter::Radar::Radar( Interface& inter, AircraftState& state ):
	m_scope(inter),
	m_state(state),
	m_interface(inter)
{
	for ( size_t i = 0; i < SIDE_LENGTH; i++ )
		m_scanLine[i] = Vec3f();

	HMODULE dll = GetModuleHandleA( "worldgeneral.dll" );

	if ( ! dll )
		return;

	m_terrain = *(void**)GetProcAddress( dll, "?globalLand@@3PEAVwTerrain@@EA" );
	printf( "Terrain pointer: %p\n", m_terrain );
}

void Scooter::Radar::zeroInit()
{
	m_disabled = m_interface.getRadarDisabled();

	if ( m_disabled )
		return;

	ed_cockpit_dispatch_action_to_device( DEVICES_RADAR, DEVICE_COMMANDS_RADAR_GAIN, 0.85 );
	ed_cockpit_dispatch_action_to_device( DEVICES_RADAR, DEVICE_COMMANDS_RADAR_BRILLIANCE, 1.0 );
	ed_cockpit_dispatch_action_to_device( DEVICES_RADAR, DEVICE_COMMANDS_RADAR_DETAIL, 0.3 );
}

void Scooter::Radar::coldInit()
{
	zeroInit();
}

void Scooter::Radar::hotInit()
{
	zeroInit();
}

void Scooter::Radar::airborneInit()
{
	zeroInit();
}

bool Scooter::Radar::handleInput( int command, float value )
{
	if ( m_disabled )
		return false;

	switch ( command )
	{
	case DEVICE_COMMANDS_RADAR_RANGE:
		m_rangeSwitch = (bool)value;
		return true;
	case DEVICE_COMMANDS_RADAR_ANGLE:
		m_angle = -10.0_deg + 25.0_deg * value ;
		return true;
	case DEVICE_COMMANDS_RADAR_AOACOMP:
		m_aoaCompSwitch = (bool)value;
		return true;
	case DEVICE_COMMANDS_RADAR_MODE:
		m_modeSwitch = (Mode)round(value * 10.0);
		return true;
	case DEVICE_COMMANDS_RADAR_FILTER:
		m_scope.setFilter( ! (bool)value );
		return true;
	case DEVICE_COMMANDS_RADAR_DETAIL:
		m_detail = value * (5.0_deg - 0.1_deg) + 0.1_deg;
		printf( "Detail: %lf\n", m_detail );
		return true;
	case DEVICE_COMMANDS_RADAR_GAIN:
		m_gain = (1.0 - value) * 9.9 + 0.1;
			
			//1.9 * (1.0 - value) + 0.1;
		printf( "Gain: %lf\n", m_gain );
		return true;
	case DEVICE_COMMANDS_RADAR_BRILLIANCE:
		m_brilliance = value;
		return true;
	}

	return false;
}

void Scooter::Radar::update( double dt )
{
	if ( m_disabled )
		return;

	if ( ! m_interface.getElecMonitoredAC() )
		return;

	switch ( m_modeSwitch )
	{
	case MODE_OFF:
		warmup( -0.5 * dt );
		clearScan();
		return;

	case MODE_STBY:
		warmup( dt );
		clearScan();
		return;

	case MODE_SRCH:
		m_scale = m_rangeSwitch ? 2.0 : 1.0;
		warmup( dt );
		break;

	case MODE_TC:
		m_scale = m_rangeSwitch ? 1.0 : 0.5;
		warmup( dt );
		break;

	case MODE_AG:
		warmup( dt );
		return;
	}


	m_scanned = (m_scanned + 1) % 2;
	
	if ( m_scanned )
		return;

	m_xIndex += m_direction;

	if ( m_xIndex >= (SIDE_LENGTH - 1) )
	{
		m_xIndex = (SIDE_LENGTH - 1);
		m_direction = -1;
	}
	else if ( m_xIndex <= 0 )
	{
		m_xIndex = 0;
		m_direction = 1;
	}

	scan();
	drawScan();
}

void Scooter::Radar::scan()
{
	if ( ! m_terrain )
		return;

	FNC_INTERSECTION getIntersection = (FNC_INTERSECTION)_find_vfptr_fnc( m_terrain, 0x68 );
	FNC_TYPE getType = (FNC_TYPE)_find_vfptr_fnc( m_terrain, 0x50 );
	FNC_GET_NORMAL getNormal = (FNC_GET_NORMAL)_find_vfptr_fnc( m_terrain, 0x58 );

	Vec3 pos = m_state.getWorldPosition();
	Vec3f posf( pos );

	Vec3f out;



	float x = -1.0 + 2.0 * (float)m_xIndex / (float)SIDE_LENGTH;

	for ( size_t i = 0; i < SIDE_LENGTH; i++ )
	{

		float y = -1.0 + 2.0 * (float)i / (float)SIDE_LENGTH;

		size_t index = i + m_xIndex * SIDE_LENGTH;

		bool found = false;

		double pitchAngle = 2.5_deg * y;

		//TODO Break into separate function.
		if ( m_modeSwitch != MODE_TC ||  abs( pitchAngle ) <= m_detail )
		{
			double pitch;
			if ( m_aoaCompSwitch )
				pitch = m_state.getAngle().z + pitchAngle - m_state.getAOA() * cos( m_state.getAngle().x );
			else
				pitch = m_state.getAngle().z + pitchAngle;

			pitch += -m_angle;

			Vec3 dir = directionVector( pitch, m_state.getAngle().y + 30.0_deg * x );
			Vec3f dirf( dir );

			found = getIntersection( m_terrain, &posf, &dirf, 20.0_nauticalMile * m_scale, &out );

			if ( found )
			{
				Vec3 ground( out.x, out.y, out.z );
				double range = magnitude( ground - pos );
				double displayRange = rangeToDisplay( range );

				unsigned char type = getType( m_terrain, out.x, out.z );
				Vec3f normalf;
				getNormal( m_terrain, &normalf, out.x, out.z );

				Vec3 normal( normalf.x, normalf.y, normalf.z );

				double reflectivity = typeReflectivity( (TerrainType)type ) * normalize( -dir ) * normalize( normal );
				if ( reflectivity < m_gain )
					reflectivity /= m_gain;

				m_scanLine[i].x = -x;
				m_scanLine[i].y = displayRange;
				m_scanLine[i].z = clamp( reflectivity, 0.0, 1.0 );

			}
			else
			{
				m_scanLine[i].z = 0.0;
			}
		}
		else
		{
			m_scanLine[i].z = 0.0;
		}
	}
}

void Scooter::Radar::drawScan()
{
	m_cleared = false;

	for ( size_t i = 0; i < SIDE_LENGTH; i++ )
	{
		size_t index = i + m_xIndex * SIDE_LENGTH;

		if ( m_scanLine[i].z == 0.0 )
		{
			m_scope.setBlobOpacity( index, 0.0 );
		}
		else
		{
			m_scope.setBlob( index, m_scanLine[i].x, m_scanLine[i].y, m_brilliance * m_scanLine[i].z );
		}
	}
}

void Scooter::Radar::clearScan()
{
	if ( m_cleared )
		return;

	for ( size_t i = 0; i < MAX_BLOBS; i++ )
	{
		m_scope.setBlobOpacity( i, 0.0 );
	}

	m_cleared = true;
}


