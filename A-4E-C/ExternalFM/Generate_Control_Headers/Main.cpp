#include "../FM/LuaVM.h"
#include <stdio.h>

#define STR_LEN 200

static bool generateCommandsHeader( const char* root );
static bool generateDevicesHeader( const char* root );

int main(int argc, char** argv)
{
	char str[STR_LEN];
	char path[STR_LEN] = "";
	strcpy_s( str, STR_LEN, argv[0] );

	char* next = NULL;
	char* tok = strtok_s( str, "\\", &next );
	strcat_s( path, STR_LEN, tok );

	while ( tok != NULL )
	{
		tok = strtok_s( NULL, "\\", &next );
		strcat_s( path, STR_LEN, "/" );
		strcat_s( path, STR_LEN, tok );

		if ( strcmp( tok, "A-4E-C" ) == 0 )
			break;
	}

	

	generateCommandsHeader( path );
	generateDevicesHeader( path );

	return 0;
}

bool generateDevicesHeader( const char* root )
{
	char out[STR_LEN];
	char devices[STR_LEN];

	strcpy_s( out, STR_LEN, root );
	strcpy_s( devices, STR_LEN, root );

	strcat_s( devices, STR_LEN, "/Cockpit/Scripts/devices.lua" );
	strcat_s( out, STR_LEN, "/ExternalFM/FM/Devices.h" );

	LuaVM vm;
	vm.dofile( devices );
	return vm.outputDevices( out );
}

bool generateCommandsHeader( const char* root )
{
	char out[STR_LEN];
	char commands[STR_LEN];

	strcpy_s( out, STR_LEN, root );
	strcpy_s( commands, STR_LEN, root );

	strcat_s( commands, STR_LEN, "/Cockpit/Scripts/command_defs.lua" );
	strcat_s( out, STR_LEN, "/ExternalFM/FM/Commands.h" );

	LuaVM vm;
	vm.dofile( commands );
	return vm.outputCommands( out );

}