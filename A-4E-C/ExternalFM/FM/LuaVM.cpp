#include "LuaVM.h"
#include <stdio.h>

LuaVM::LuaVM()
{
	m_state = luaL_newstate();
	luaL_openlibs( m_state );
	//m_api = ed_get_cockpit_param_api();

	//m_state = m_api.pfn_create_lua_vm();
}

LuaVM::~LuaVM()
{
	lua_close( m_state );
	//m_api.pfn_destroy_lua_vm( m_state );
	m_state = NULL;
}

double LuaVM::getGlobalTableNumber( const char* table, const char* key, bool& success )
{
	lua_getglobal( m_state, table );
	float result;
	success = getTableNumber( key, result );
	return result;
}

bool LuaVM::getTableValue( const char* key )
{
	if ( lua_istable( m_state, -1 ) )
	{
		lua_pushstring( m_state, key );
		lua_gettable( m_state, -2 );
		return true;
	}

	return false;
}

bool LuaVM::getTableNumber( const char* key, float& value )
{

	if ( ! getTableValue( key ) || ! lua_isnumber( m_state, -1 ) )
	{
		lua_pop( m_state, 1 );
		return false;
	}

	value = lua_tonumber( m_state, -1 );
	lua_pop( m_state, 1 );
	return true;
}

bool LuaVM::dofile( const char* path )
{
	return luaOkay( luaL_dofile( m_state, path ) );
}

bool LuaVM::luaOkay( const int status )
{
	if ( status !=  0 )
	{
		printf( "%s\n", lua_tostring( m_state, -1 ) );
		return false;
	}

	return true;
}

void LuaVM::getSplines( const char* name, std::vector<LERX>& vec )
{
	lua_getglobal( m_state, name );

	if ( ! lua_istable( m_state, -1 ) )
	{
		return;
	}

	vec.clear();

	int tableIdx = lua_gettop( m_state );
	lua_pushnil( m_state );

	while ( lua_next( m_state, tableIdx ) )
	{
		std::vector<LERX_vortex_spline_point> spline;

		getSpline( spline );

		if ( spline.size() )
		{
			vec.push_back( LERX(spline) );
		}
		
		lua_pop( m_state, 1 );
	}
}

void LuaVM::getSpline( std::vector<LERX_vortex_spline_point>& vec )
{
	if ( ! lua_istable( m_state, -1 ) )
	{
		return;
	}

	int tableIdx = lua_gettop( m_state );

	lua_pushnil( m_state );

	while ( lua_next( m_state, tableIdx ) )
	{
		LERX_vortex_spline_point point;

		if ( processSplinePoint( point ) )
		{
			vec.push_back( point );
		}

		lua_pop( m_state , 1 );
	}
}

bool LuaVM::getTableVec3( const char* name, float* vec )
{
	if ( ! getTableValue( name ) )
	{
		return false;
	}

	if ( ! lua_istable( m_state, -1 ) )
	{
		return false;
	}

	int tableIdx = lua_gettop( m_state );

	lua_pushnil( m_state );

	for ( int i = 0; i < 3 && lua_next( m_state, tableIdx ); i++ )
	{
		if ( ! lua_isnumber( m_state, -1 ) )
			return false;

		vec[i] = lua_tonumber( m_state, -1 );
		lua_pop( m_state, 1 );
	}
	
	lua_pop( m_state, 2 );

	return true;
}

bool LuaVM::processSplinePoint( LERX_vortex_spline_point& point )
{
	if ( ! getTableVec3( "pos", point.pos ) )
		return false;

	if ( ! getTableVec3( "vel", point.vel ) )
		return false;

	if ( ! getTableNumber("radius", point.radius ) )
		return false;

	if ( ! getTableNumber( "opacity", point.opacity ) )
		return false;
	
	return true;
}