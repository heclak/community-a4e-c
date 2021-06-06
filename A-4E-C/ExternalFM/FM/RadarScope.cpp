#include "RadarScope.h"
#include "Globals.h"




Scooter::RadarScope::RadarScope( Interface& inter ) :
	m_interface( inter )
{
	m_xParams = new void*[MAX_BLOBS];
	m_yParams = new void*[MAX_BLOBS];
	m_opacityParams = new void*[MAX_BLOBS];

	char paramName[50];

	for ( size_t i = 0; i < MAX_BLOBS; i++ )
	{
		sprintf_s( paramName, 50, "RADAR_BLOB_%llu_LR", i );
		m_xParams[i] = m_interface.api().pfn_ed_cockpit_get_parameter_handle( paramName );


		sprintf_s( paramName, 50, "RADAR_BLOB_%llu_UD", i );
		m_yParams[i] = m_interface.api().pfn_ed_cockpit_get_parameter_handle( paramName );

		sprintf_s( paramName, 50, "RADAR_BLOB_%llu_OP", i );
		m_opacityParams[i] = m_interface.api().pfn_ed_cockpit_get_parameter_handle( paramName );
	}

	

}

Scooter::RadarScope::~RadarScope()
{
	delete[] m_xParams;
	delete[] m_yParams;
	delete[] m_opacityParams;
}