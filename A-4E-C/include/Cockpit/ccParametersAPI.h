#pragma once
#include <windows.h>
#ifdef COCKPITBASE_EXPORTS
#include "CockpitBase.h"
//prototypes as they declared in CockpitBase.dll
extern "C" {
	COCKPITBASE_API void * ed_cockpit_get_parameter_handle			  (const char * name);
	COCKPITBASE_API void   ed_cockpit_update_parameter_with_string    (void		  * handle	,const char * string_value);
	COCKPITBASE_API void   ed_cockpit_update_parameter_with_number    (void		  * handle	,double   number_value);
	COCKPITBASE_API bool   ed_cockpit_parameter_value_to_number       (const void * handle	,double & res	,bool interpolated = false);
	COCKPITBASE_API bool   ed_cockpit_parameter_value_to_string       (const void * handle	,char * buffer	,unsigned buffer_size);
	COCKPITBASE_API int    ed_cockpit_compare_parameters			  (void		  * handle_1,void * handle_2);  //return 0 if equal , -1 if first less than second 1 otherwise
};
#endif

//params handling
typedef void * (*PFN_ED_COCKPIT_GET_PARAMETER_HANDLE		)  (const char * name);
typedef void   (*PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_STRING)  (void		  * handle	,const char * string_value);
typedef void   (*PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER)  (void		  * handle	,double   number_value);
typedef bool   (*PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER   )  (const void * handle	,double & res	,bool interpolated);
typedef bool   (*PFN_ED_COCKPIT_PARAMETER_VALUE_TO_STRING   )  (const void * handle	,char * buffer	,unsigned buffer_size);
typedef int    (*PFN_ED_COCKPIT_COMPARE_PARAMETERS			)  (void		  * handle_1,void * handle_2);

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
};

inline cockpit_param_api  ed_get_cockpit_param_api()
{
	HMODULE	cockpit_dll								= GetModuleHandle("CockpitBase.dll"); //assume that we work inside same process
	cockpit_param_api ret;
	ret.pfn_ed_cockpit_get_parameter_handle			= (PFN_ED_COCKPIT_GET_PARAMETER_HANDLE)		   GetProcAddress(cockpit_dll,"ed_cockpit_get_parameter_handle");
	ret.pfn_ed_cockpit_update_parameter_with_number = (PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER)GetProcAddress(cockpit_dll,"ed_cockpit_update_parameter_with_number");
	ret.pfn_ed_cockpit_update_parameter_with_string = (PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_STRING)GetProcAddress(cockpit_dll,"ed_cockpit_update_parameter_with_string");
	ret.pfn_ed_cockpit_parameter_value_to_number    = (PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER)   GetProcAddress(cockpit_dll,"ed_cockpit_parameter_value_to_number");
	ret.pfn_ed_cockpit_parameter_value_to_string	= (PFN_ED_COCKPIT_PARAMETER_VALUE_TO_STRING)   GetProcAddress(cockpit_dll,"ed_cockpit_parameter_value_to_string");   
	return ret;
}