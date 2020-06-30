#include "Engine.h"

#define omegaVThrust {0.0,19.4604511406,42.2804624633,68.3445406972,97.5371925717,129.742924816,164.846244159,202.731657331,243.28367106,286.89213332,337.233959076,399.300731092,478.087502792,575.145270199,663.068403396,699.96331447,659.111266375,570.18651733,475.867722112,418.833535502,441.762612279,587.333607221,898.225175108,1407.11924044,2063.84391977,2777.26569417,3455.96008145,4036.28157715,4591.87714156,5238.73309535,6092.78119503,7167.12909199,8164.50102575,8729.28666345,8635.32694431,9156.60305635,12385.6168475,17680.5442949,22014.3353849,24524.8424703,26434.7948705,28301.5315981,30290.851386,32120.794306,33712.0269526,35142.0363197,36491.2261035,37840.0}
#include <algorithm>
Skyhawk::Engine::Engine(Input& input):
	m_input(input),
	m_omegaVThrust(omegaVThrust, 0,1152)
{

}

Skyhawk::Engine::~Engine()
{

}

void Skyhawk::Engine::zeroInit()
{
	m_oilPressure = 0.0;
	m_fuelFlow = 0.0;
	m_temperature = 23.0;
	m_omega = 0.0;
	m_cutoff = true;
	m_ignitors = false;
	m_startAir = 0.0;
	m_desiredFuelFlow = 0.0;
	m_haveFuel = true;
}

void Skyhawk::Engine::coldInit()
{
	zeroInit();
}

void Skyhawk::Engine::hotInit()
{
	zeroInit();
	m_cutoff = false;
	m_ignitors = true;
	m_omega = 600;
}

void Skyhawk::Engine::airbornInit()
{
	zeroInit();
	m_cutoff = false;
	m_ignitors = true;
	m_omega = 600;
}

void Skyhawk::Engine::updateEngine(double dt)
{
	//m_startAir = m_input.starter() && getRPMNorm() < 0.5 ? 1.0 : 0.0;

	/*if (m_input.starter() && getRPMNorm() < 0.15 && m_input.throttleState() == Input::ThrottleState::IDLE)
	{
		m_startAir = 0.2;
	}*/

	/*switch (m_input.throttleState())
	{
	case Input::ThrottleState::CUTOFF:
		m_ignitors = false;
		m_desiredFuelFlow = 0.0;
		break; 
	case Input::ThrottleState::START:
		m_ignitors = getRPMNorm() > 0.10;
		m_desiredFuelFlow = 0.3;
		break;
	case Input::ThrottleState::IDLE:
		m_ignitors = m_ignitors = getRPMNorm() > 0.10;
		double correctedThrottle = (m_input.throttleNorm() + 0.55) / 1.55;
		m_desiredFuelFlow = std::max(m_pGain*(correctedThrottle - getRPMNorm()) + c_maxFuelFlow * correctedThrottle, 0.25);
		break;
	}*/

	double correctedThrottle = ((m_throttle + 1.0)/2.0);

	if (m_throttle >= 0.0)
		m_desiredFuelFlow = std::max(m_pGain * (correctedThrottle - getRPMNorm()) + c_maxFuelFlow * correctedThrottle, 0.25);
	else
		m_desiredFuelFlow = c_maxFuelFlow * correctedThrottle;


	if (m_fuelFlow >= m_desiredFuelFlow)
	{
		m_fuelFlow -= 4.0*dt / m_throttleResponseTime;
		m_fuelFlow = std::max(m_fuelFlow, m_desiredFuelFlow);
	}
	else
	{
		m_fuelFlow += dt / m_throttleResponseTime;
		m_fuelFlow = std::min(m_fuelFlow, m_desiredFuelFlow);
	}

	m_fuelFlow = m_haveFuel ? m_fuelFlow : 0.0;

	//double cutoffValue = m_cutoff ? 0.0 : 1.0;
	//m_fuelFlow = cutoffValue*c_maxFuelFlow*(m_input.throttleNorm() + 0.4)/1.4;

	//m_nozzle = m_input.throttleNorm() > 0.1 ? 1.0 : 0.4;
	m_nozzle = 1.0;


	//double combustionTorque = m_omega > 0.4 * c_maxOmega ? c_combustionCoeff * m_fuelFlow : c_combustionCoeff * m_fuelFlow*0.2;
	double combustionTorque = c_combustionCoeff * m_fuelFlow;
	combustionTorque *= m_ignitors ? 1.0 : 0.0;

	double engineDrag = getRPMNorm() > 0.15 ? 1.0 : 0.0;

	double omegaDot = (m_startAir*c_starterTorque + combustionTorque - c_thrustCoeff * getThrust() - c_engineDragCoeff * m_omega - c_constantEngineDragCoeff*engineDrag) / c_momentOfIntertiaTurbine;
	m_omega += omegaDot * dt;
	m_temperature = 400*(m_fuelFlow / c_maxFuelFlow) + 400*(m_omega/c_maxOmega) + 23.0;
	//printf("Omega: %lf, RPM %: %lf, Fuel Flow(kg/s): %lf\n", m_omega, 100.0 * m_omega / 1152.0, m_fuelFlow);
}