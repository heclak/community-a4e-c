#pragma once
#include <windows.h>
namespace cockpit
{
	struct avUHF_ARC_164;
}

namespace EagleFM
{
	namespace Elec
	{
		struct ItemBase;
	}
	
}

//params handling
typedef void * (*PFN_ED_COCKPIT_GET_PARAMETER_HANDLE		)  (const char * name);
typedef void   (*PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_STRING)  (void		  * handle	,const char * string_value);
typedef void   (*PFN_ED_COCKPIT_UPDATE_PARAMETER_WITH_NUMBER)  (void		  * handle	,double   number_value);
typedef bool   (*PFN_ED_COCKPIT_PARAMETER_VALUE_TO_NUMBER   )  (const void * handle	,double & res	,bool interpolated);
typedef bool   (*PFN_ED_COCKPIT_PARAMETER_VALUE_TO_STRING   )  (const void * handle	,char * buffer	,unsigned buffer_size);
typedef int    (*PFN_ED_COCKPIT_COMPARE_PARAMETERS			)  (void		  * handle_1,void * handle_2);
//typedef void   (cockpit::avBaseRadio::*MemberFncBool)		   (bool value);
typedef void   (*RADIO_POWER_FUNC)							   (void* value);
typedef bool  (*GET_RADIO_POWER_FUNC)							(void);
typedef bool  (*GET_SOMETHING)									(void);
typedef int   (*GET_SOMETHING_INT)								(void);
typedef void* (*PFN_ED_COCKPIT_SET_ACTION_DIGITAL)(int value);
typedef void  (*PFN_CONNECT_ELECTRIC)(void*, void*);
typedef void  (*PFN_SET_ELEC_POWER)(void*, bool);
typedef void*  (*PFN_GET_COMMUNICATOR)(void*);
typedef void  (*PFN_SET_COMMUNICATOR_AS_CURRENT)(void*);
typedef void*  (*PFN_GET_WIRE)(void*, int);
typedef int   (*PFN_GET_FREQ)(void*);
typedef void  (*PFN_PUSH_TO_TALK)(void*, bool);
typedef void  (*PFN_TRY_SET_COMMUNICATOR)(void*, unsigned int);


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
	GET_RADIO_POWER_FUNC								 getRadioPowerFncPtr;
	GET_RADIO_POWER_FUNC								 switchRadioPowerFncPtr;
	GET_SOMETHING	isOnIntercom;
	GET_SOMETHING_INT getGunShells;
	PFN_ED_COCKPIT_SET_ACTION_DIGITAL				 pfn_ed_cockpit_set_action_digital;
	PFN_CONNECT_ELECTRIC                             pfn_connect_electric;
	PFN_SET_ELEC_POWER                               pfn_set_elec_power;
	PFN_GET_COMMUNICATOR							 pfn_get_communicator;
	PFN_SET_COMMUNICATOR_AS_CURRENT                  pfn_set_communicator_as_current;
	PFN_GET_WIRE									 pfn_get_dc_wire;
	PFN_GET_WIRE									 pfn_get_ac_wire;
	PFN_GET_FREQ pfn_get_freq;
	PFN_PUSH_TO_TALK pfn_push_to_talk;
	PFN_TRY_SET_COMMUNICATOR pfn_try_set_communicator;
	void** device_array;
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
	//base: ?setElecPower@avBaseRadio@cockpit@@UEAAX_N@Z
	//?setElecPower@avBaseRadio@cockpit@@UEAAX_N@Z
	//?setElecPower@avBasicElectric@cockpit@@UEAAX_N@Z
	//?getElecPower@avBasicElectric@cockpit@@UEBA_NXZ
	ret.setRadioPowerFncPtr = (RADIO_POWER_FUNC)GetProcAddress(cockpit_dll, "?setElecPower@avRadio_MAC@cockpit@@UEAAX_N@Z");
	//?get_set_frequency@avRadio_MAC@cockpit@@MEBAHXZ
	//?getElecPower@avRadio_MAC@cockpit@@UEBA_NXZ
	ret.getRadioPowerFncPtr = (GET_RADIO_POWER_FUNC)GetProcAddress(cockpit_dll, "?ext_is_on@avBaseRadio@cockpit@@MEBA_NXZ");
	ret.switchRadioPowerFncPtr = (GET_RADIO_POWER_FUNC)GetProcAddress(cockpit_dll, "?perform_init_state@avRadio_MAC@cockpit@@MEAAXXZ");
	ret.pfn_ed_cockpit_set_action_digital = (PFN_ED_COCKPIT_SET_ACTION_DIGITAL)GetProcAddress(cockpit_dll, "ed_cockpit_set_action_digital");
	ret.isOnIntercom = (GET_SOMETHING)GetProcAddress(cockpit_dll, "?isOn@avIntercom@cockpit@@UEBA_NXZ");

	ret.pfn_set_elec_power = (PFN_SET_ELEC_POWER)GetProcAddress( cockpit_dll, "?setElecPower@avBaseRadio@cockpit@@UEAAX_N@Z" );
	ret.pfn_connect_electric = (PFN_CONNECT_ELECTRIC)GetProcAddress( cockpit_dll, "?connect_electric@avUHF_ARC_164@cockpit@@IEAAXAEAVItemBase@Elec@EagleFM@@@Z" );
	ret.pfn_get_communicator = (PFN_GET_COMMUNICATOR)GetProcAddress( cockpit_dll, "?getCommunicator@avBaseRadio@cockpit@@QEAAAEAVavCommunicator@2@XZ" );
	ret.pfn_set_communicator_as_current = (PFN_SET_COMMUNICATOR_AS_CURRENT)GetProcAddress( cockpit_dll, "?setAsCurrent@avCommunicator@cockpit@@QEAAXXZ" );
	ret.device_array = (void**)GetProcAddress( cockpit_dll, "?contexts@ccCockpitContext@cockpit@@0PAV12@A" );
	ret.pfn_get_dc_wire = (PFN_GET_WIRE)GetProcAddress( cockpit_dll, "?getDCbus@avSimpleElectricSystem@cockpit@@QEAAAEAVWire@Elec@EagleFM@@H@Z" );
	ret.pfn_get_ac_wire = (PFN_GET_WIRE)GetProcAddress( cockpit_dll, "?getACbus@avSimpleElectricSystem@cockpit@@QEAAAEAVWire@Elec@EagleFM@@H@Z" );
	ret.pfn_get_freq = (PFN_GET_FREQ)GetProcAddress( cockpit_dll, "?get_knobs_frequency@avUHF_ARC_164@cockpit@@IEBAHXZ" );
	ret.pfn_push_to_talk = (PFN_PUSH_TO_TALK)GetProcAddress( cockpit_dll, "?pushToTalk@avIntercom@cockpit@@IEAAX_N@Z" );
	ret.pfn_try_set_communicator = (PFN_TRY_SET_COMMUNICATOR)GetProcAddress(cockpit_dll, "?makeSetupForCommunicator@avIntercom@cockpit@@MEAA_NI@Z");
	//?makeSetupForCommunicator@avIntercom@cockpit@@MEAA_NI@Z
	//?trySetCommunicator@avIntercom@cockpit@@MEAAXI@Z
	//ret.getGunShells = (GET_SOMETHING_INT)GetProcAddress(cockpit_dll, "")
	return ret;
}