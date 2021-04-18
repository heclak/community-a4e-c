#pragma once
#define ED_COCKPIT_API_IMPORT __declspec(dllimport)


extern "C"
{
	ED_COCKPIT_API_IMPORT void ed_cockpit_dispatch_action_digital( int command );
	ED_COCKPIT_API_IMPORT void ed_cockpit_dispatch_action_analog( int command, float value );
	ED_COCKPIT_API_IMPORT void ed_cockpit_dispatch_action_to_device(unsigned char dev, int command, float value );
	
}
