#include "Radar.h"
#include "Maths.h"

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


extern "C"
{
	void* _find_vfptr_fnc( void*, intptr_t );
}

typedef bool (*FNC_INTERSECTION)(void* object, Vec3f* point, Vec3f* direction, float maxDist, Vec3f* out);
typedef unsigned char (*FNC_TYPE)(void* object, float x, float z);
typedef void ( *FNC_GET_NORMAL )(void* object, Vec3f* n, float x, float z);

Scooter::Radar::Radar( Interface& inter, AircraftState& state ):
	m_scope(inter),
	m_state(state)
{


	HMODULE dll = GetModuleHandleA( "worldgeneral.dll" );

	if ( ! dll )
		return;

	m_terrain = *(void**)GetProcAddress( dll, "?globalLand@@3PEAVwTerrain@@EA" );
	printf( "Terrain pointer: %p\n", m_terrain );
}

void Scooter::Radar::update( double dt )
{
	if ( ! m_terrain )
		return;

	FNC_INTERSECTION getIntersection = (FNC_INTERSECTION)_find_vfptr_fnc( m_terrain, 0x68 );
	FNC_TYPE getType = (FNC_TYPE)_find_vfptr_fnc( m_terrain, 0x50 );
	FNC_GET_NORMAL getNormal = (FNC_GET_NORMAL)_find_vfptr_fnc( m_terrain, 0x58 );


	m_xIndex += m_direction;

	if ( m_xIndex >= 49 )
	{
		m_xIndex = 49;
		m_direction = -1;
	}
	else if ( m_xIndex <= 0 )
	{
		m_xIndex = 0;
		m_direction = 1;
	}

	Vec3 pos = m_state.getWorldPosition();
	Vec3f posf(pos);

	

	Vec3f out;
	out.x = 0.0;
	out.y = 0.0;
	out.z = 0.0;

	printf( "Start Scan\n" );

	float x = -1.0 + 2.0 * (float)m_xIndex / 50.0;
	float maxrange = 0.0;
	unsigned char type = 0;
	for ( size_t i = 0; i < 50; i++ )
	{
		
		float y = -1.0 + 2.0 * (float)i / 50.0;
		size_t index = i + m_xIndex * 50;//(size_t)((m_x + 1.0) * 25.0);

		double pitch = m_state.getAngle().z + 2.5_deg * y;
		//printf( "Index : %lld\n", index );
		Vec3 dir = directionVector( pitch, m_state.getAngle().y + 30.0_deg * x );
		Vec3f dirf( dir );
		
		bool found = getIntersection( m_terrain, &posf, &dirf, 20.0_nauticalMile * m_scale, &out );
		if ( found )
		{
			Vec3 ground( out.x, out.y, out.z );
			double range = magnitude( ground - pos );
			double displayRange = rangeToDisplay( range );

			
			type = getType( m_terrain, out.x, out.z );

			//printf( "x: %lf, z: %lf\n", out.x, out.z );
			Vec3f normalf;
			getNormal( m_terrain, &normalf, out.x, out.z );
			//printf( "Normal: %lf, %lf, %lf\n", normalf.x, normalf.y, normalf.z );

			Vec3 normal( normalf.x, normalf.y, normalf.z );

			double reflectivity = typeReflectivity((TerrainType)type) * normalize(-dir) * normalize(normal);

			if ( range > maxrange )
				maxrange = range;
			m_scope.setBlob( index, -x, displayRange, clamp(reflectivity, 0.0, 1.0) );
		}
		else
			m_scope.setBlobOpacity( index, 0.0 );

		
	}

	printf( "Terrain Type: %d\n", type );

	//printf( "Max Range: %lf\n", maxrange );


	//printf( "%lf, %lf, %lf\n", out.x, out.y, out.z );
}
