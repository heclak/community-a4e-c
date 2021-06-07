#pragma once
#include "Interface.h"

#define SIDE_LENGTH 50
#define MAX_BLOBS (SIDE_LENGTH * SIDE_LENGTH)


namespace Scooter
{

class RadarScope
{
public:
	RadarScope( Interface& inter );
	~RadarScope();

	inline void setBlobOpacity( size_t index, double value );
	inline void setBlob( size_t index, double x, double y, double opacity );
	inline void setBlobPos( size_t index, double x, double y );
	inline void setGlow( bool glow );
	inline void setFilter( bool filter );

private:
	Interface& m_interface;

	void** m_xParams;
	void** m_yParams;
	void** m_opacityParams;
	void* m_radarGlow = NULL;
	void* m_filter = NULL;
};

void RadarScope::setBlobOpacity( size_t index, double value )
{
	m_interface.setParamNumber( m_opacityParams[index], value );
}

void RadarScope::setBlob( size_t index, double x, double y, double opacity )
{
	m_interface.setParamNumber( m_xParams[index], x );
	m_interface.setParamNumber( m_yParams[index], y );
	m_interface.setParamNumber( m_opacityParams[index], opacity );
}

void RadarScope::setBlobPos( size_t index, double x, double y )
{
	m_interface.setParamNumber( m_xParams[index], x );
	m_interface.setParamNumber( m_yParams[index], y );
}

void RadarScope::setGlow( bool glow )
{
	m_interface.setParamNumber( m_radarGlow, (double)glow );
}

void RadarScope::setFilter( bool filter )
{
	m_interface.setParamNumber( m_filter, (double)filter );
}

}