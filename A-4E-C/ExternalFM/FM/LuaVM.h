#pragma once
#include "../include/Cockpit/ccParametersAPI.h"
#include "../include/FM/wHumanCustomPhysicsAPI.h"
#include <vector>
#include "Vec3.h"
#include "LERX.h"
class LuaVM
{
public:
	LuaVM();
	~LuaVM();

	lua_State* L();
	
	bool dofile( const char* path );
	double getGlobalNumber(const char* name);
	double getGlobalTableNumber( const char* table, const char* key, bool& success );
	void getSplines( const char* name, std::vector<LERX>& vec );

private:


	void getSpline( std::vector<LERX_vortex_spline_point>& vec );
	bool getTableVec3(const char* name, float* vec);
	bool processSplinePoint( LERX_vortex_spline_point& point );

	bool luaOkay( const int status );
	bool getTableValue( const char* key );
	bool getTableNumber( const char* key, float& value );

	lua_State* m_state = NULL;

	cockpit_param_api m_api;
};