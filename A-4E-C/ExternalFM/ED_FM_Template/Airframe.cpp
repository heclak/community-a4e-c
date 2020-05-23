#include "Airframe.h"
#include <algorithm>
Skyhawk::Airframe::Airframe(Input& controls):
	m_controls(controls)
{

}

Skyhawk::Airframe::~Airframe()
{

}

void Skyhawk::Airframe::airframeUpdate(double dt)
{
	if (m_controls.gear() == Skyhawk::Input::GearPos::DOWN)
	{
		m_gearPosition -= dt / m_gearExtendTime;
		m_gearPosition = std::max(m_gearPosition, 0.0);
	}
	else
	{
		m_gearPosition += dt / m_gearExtendTime;
		m_gearPosition = std::min(m_gearPosition, 1.0);
	}
}