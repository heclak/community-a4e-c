#include "Engine.h"

#define omegaVThrust {0.0,35.2958834461,60.6808968978,80.3483226095,98.4914428355,119.30353983,146.977895848,185.707793144,239.686513972,313.240418883,411.561495923,540.187942268,704.658869066,907.077997848,1120.66530037,1304.18923563,1430.60255667,1525.59483616,1627.0169181,1772.71964649,2000.55386531,2348.37041858,2854.02015027,3548.76327074,4409.23622039,5385.07029634,6425.70496981,7482.89962353,8519.87937455,9503.40523571,10400.269179,11223.5246047,12125.8690171,13286.2451342,14847.669971,16536.8371464,17861.2665198,19236.6328692,21833.4995808,24683.636654,26527.1099522,28271.1388107,30276.3023091,32134.8361841,33720.57214,35131.7414845,36470.7491328,37840.0}
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
	m_startAir = m_input.starter() && getRPMNorm() < 0.5 ? 1.0 : 0.0;

	if (m_input.starter() && getRPMNorm() < 0.15 && m_input.throttleState() == Input::ThrottleState::IDLE)
	{
		m_startAir = 0.2;
	}

	switch (m_input.throttleState())
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
	}

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

	m_nozzle = m_input.throttleNorm() > 0.1 ? 1.0 : 0.4;

	//double combustionTorque = m_omega > 0.4 * c_maxOmega ? c_combustionCoeff * m_fuelFlow : c_combustionCoeff * m_fuelFlow*0.2;
	double combustionTorque = c_combustionCoeff * m_fuelFlow;
	combustionTorque *= m_ignitors ? 1.0 : 0.0;

	double engineDrag = getRPMNorm() > 0.15 ? 1.0 : 0.0;

	double omegaDot = (m_startAir*c_starterTorque + combustionTorque - c_thrustCoeff * getThrust() - c_engineDragCoeff * m_omega - c_constantEngineDragCoeff*engineDrag) / c_momentOfIntertiaTurbine;
	m_omega += omegaDot * dt;
	m_temperature = 400*(m_fuelFlow / c_maxFuelFlow) + 400*(m_omega/c_maxOmega) + 23.0;
	//printf("Omega: %lf, RPM %: %lf, Fuel Flow(kg/s): %lf\n", m_omega, 100.0 * m_omega / 1152.0, m_fuelFlow);
}