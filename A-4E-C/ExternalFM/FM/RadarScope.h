#pragma once
#include "Interface.h"

#define MAX_BLOBS 2500

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


private:
	Interface& m_interface;

	void** m_xParams;
	void** m_yParams;
	void** m_opacityParams;
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

}