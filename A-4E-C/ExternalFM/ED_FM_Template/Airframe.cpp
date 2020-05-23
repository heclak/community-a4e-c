#include "Airframe.h"
#include <algorithm>
Skyhawk::Airframe::Airframe(Input& controls):
	m_controls(controls)
{

}

Skyhawk::Airframe::~Airframe()
{

}

void Skyhawk::Airframe::zeroInit()
{
	m_gearPosition = 0.0;
	m_flapsPosition = 0.0;
	m_spoilerPosition = 0.0;
	m_speedBrakePosition = 0.0;
	m_hookPosition = 0.0;
	m_slatsPosition = 0.0;
	m_flapsPosition = 0.0;
}

void Skyhawk::Airframe::coldInit()
{
	zeroInit();
	m_controls.gear() = Input::GearPos::DOWN;
	m_gearPosition = 1.0;
}

void Skyhawk::Airframe::hotInit()
{
	zeroInit();
	m_controls.gear() = Input::GearPos::DOWN;
	m_gearPosition = 1.0;
}

void Skyhawk::Airframe::airborneInit()
{
	zeroInit();
	m_controls.gear() = Input::GearPos::UP;
}

void Skyhawk::Airframe::airframeUpdate(double dt)
{
	if (m_controls.gear() == Skyhawk::Input::GearPos::UP)
	{
		m_gearPosition -= dt / m_gearExtendTime;
		m_gearPosition = std::max(m_gearPosition, 0.0);
	}
	else
	{
		m_gearPosition += dt / m_gearExtendTime;
		m_gearPosition = std::min(m_gearPosition, 1.0);
	}

	if (m_controls.airbrake() > m_speedBrakePosition)
	{
		m_speedBrakePosition += dt / m_airbrakesExtendTime;
		m_speedBrakePosition = std::min(m_speedBrakePosition, 1.0);
	}
	else
	{
		m_speedBrakePosition -= dt / m_airbrakesExtendTime;
		m_speedBrakePosition = std::max(m_speedBrakePosition, 0.0);
	}

	if (m_controls.flaps() > m_flapsPosition)
	{
		m_flapsPosition += dt / m_flapsExtendTime;
		m_flapsPosition = std::min(m_flapsPosition, 1.0);
	}
	else
	{
		m_flapsPosition -= dt / m_flapsExtendTime;
		m_flapsPosition = std::max(m_flapsPosition, 0.0);
	}

	
	m_elevator = m_controls.pitch();
	m_aileronLeft = m_controls.roll();
	m_aileronRight = -m_aileronLeft;
	m_rudder = m_controls.yaw();
	m_slatsPosition = m_controls.slats();
}