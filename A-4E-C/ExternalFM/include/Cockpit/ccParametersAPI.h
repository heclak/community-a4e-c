#pragma once
#include <windows.h>
namespace cockpit
{
	class avBaseRadio;
}

//params handling
typedef void * (*PFN_ED_COCKPIT_GET_PARAMETER_HANDLE		)  (const char * name);
typedef void   (*PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_STRING)  (void		  * handle	,const char * string_value);
typedef void   (*PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER)  (void		  * handle	,double   number_value);
typedef bool   (*PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER   )  (const void * handle	,double & res	,bool interpolated);
typedef bool   (*PFN_ED_COCKPIT_PARAMETER_VALUE_TO_STRING   )  (const void * handle	,char * buffer	,unsigned buffer_size);
typedef int    (*PFN_ED_COCKPIT_COMPARE_PARAMETERS			)  (void		  * handle_1,void * handle_2);
typedef void   (cockpit::avBaseRadio::*MemberFncBool)		   (bool value);
typedef void   (*RADIO_POWER_FUNC)							   (bool value);
typedef void* (*PFN_ED_COCKPIT_SET_ACTION_DIGITAL)(int value);

/* usage
HMODULE	cockpit_dll						= GetModuleHandle("CockpitBase.dll"); assume that we work inside same process

ed_cockpit_get_parameter_handle			= (PFN_ED_COCKPIT_GET_PARAMETER_HANDLE)		   GetProcAddress(cockpit_dll,"ed_cockpit_get_parameter_handle");
ed_cockpit_update_parameter_with_number = (PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER)GetProcAddress(cockpit_dll,"ed_cockpit_update_parameter_with_number");
ed_cockpit_parameter_value_to_number    = (PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER)   GetProcAddress(cockpit_dll,"ed_cockpit_parameter_value_to_number");
....

void * handle = ed_cockpit_get_parameter_handle("TEST_PARAM");
ed_cockpit_update_parameter_with_number(handle,0);

....
double val;
ed_cockpit_parameter_value_to_number   (handle,val);
ed_cockpit_update_parameter_with_number(handle,val + 1);
*/

struct cockpit_param_api
{
	PFN_ED_COCKPIT_GET_PARAMETER_HANDLE				 pfn_ed_cockpit_get_parameter_handle;		
	PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_STRING		 pfn_ed_cockpit_update_parameter_with_string;
	PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER		 pfn_ed_cockpit_update_parameter_with_number;
	PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER		 pfn_ed_cockpit_parameter_value_to_number;   
	PFN_ED_COCKPIT_PARAMETER_VALUE_TO_STRING		 pfn_ed_cockpit_parameter_value_to_string;
	RADIO_POWER_FUNC								 setRadioPowerFncPtr;
	PFN_ED_COCKPIT_SET_ACTION_DIGITAL				 pfn_ed_cockpit_set_action_digital;
};

inline cockpit_param_api  ed_get_cockpit_param_api()
{
	HMODULE	cockpit_dll								= GetModuleHandle(L"CockpitBase.dll"); //assume that we work inside same process
	cockpit_param_api ret;
	ret.pfn_ed_cockpit_get_parameter_handle			= (PFN_ED_COCKPIT_GET_PARAMETER_HANDLE)		   GetProcAddress(cockpit_dll,"ed_cockpit_get_parameter_handle");
	ret.pfn_ed_cockpit_update_parameter_with_number = (PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER)GetProcAddress(cockpit_dll,"ed_cockpit_update_parameter_with_number");
	ret.pfn_ed_cockpit_update_parameter_with_string = (PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_STRING)GetProcAddress(cockpit_dll,"ed_cockpit_update_parameter_with_string");
	ret.pfn_ed_cockpit_parameter_value_to_number    = (PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER)   GetProcAddress(cockpit_dll,"ed_cockpit_parameter_value_to_number");
	ret.pfn_ed_cockpit_parameter_value_to_string	= (PFN_ED_COCKPIT_PARAMETER_VALUE_TO_STRING)   GetProcAddress(cockpit_dll,"ed_cockpit_parameter_value_to_string");
	ret.setRadioPowerFncPtr = (RADIO_POWER_FUNC)GetProcAddress(cockpit_dll, "?setElecPower@avBaseRadio@cockpit@@UEAAX_N@Z");
	ret.pfn_ed_cockpit_set_action_digital = (PFN_ED_COCKPIT_SET_ACTION_DIGITAL)GetProcAddress(cockpit_dll, "ed_cockpit_set_action_digital");
	return ret;
}