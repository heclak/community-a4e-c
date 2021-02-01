#pragma once
//=========================================================================//
//
//		FILE NAME	: AeroElement.cpp
//		AUTHOR		: TerjeTL
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Provides element classes for aerodynamics simulation.
//
//================================ Includes ===============================//
#include "AeroElement.h"
#include "Maths.h"
//=========================================================================//

Scooter::AeroElement::AeroElement
(
	AircraftState& state,
	Table& CLalpha,
	Table& CDalpha,
	Vec3 cp,
	Vec3 surfaceNormal,
	double area,
	LERX* lerx
) :
	m_state{ state },
	m_CLalpha{ CLalpha },
	m_CDalpha{ CDalpha },
	m_cp{ cp },
	m_surfaceNormal{ surfaceNormal },
	m_area{ area },
	m_dragFactor{ 1.0 },
	m_liftFactor{ 1.0 }
{

}

Scooter::AeroElement::AeroElement
(
	AircraftState& state,
	Table& CLalpha,
	Table& CDalpha,
	Vec3 cp,
	Vec3 surfaceNormal,
	double area
) :
	m_state{ state },
	m_CLalpha{ CLalpha },
	m_CDalpha{ CDalpha },
	m_cp{ cp },
	m_surfaceNormal{ surfaceNormal },
	m_area{ area },
	m_dragFactor{ 1.0 },
	m_liftFactor{ 1.0 }
{

}

Scooter::AeroElement::~AeroElement()
{

}

Scooter::AeroSurface::AeroSurface
(
	AircraftState& state,
	Table& CLalpha,
	Table& CDalpha,
	Vec3 cp,
	Vec3 surfaceNormal,
	double area
) :
	AeroElement(state, CLalpha, CDalpha, cp, surfaceNormal, area)
{

}

Scooter::AeroVerticalSurface::AeroVerticalSurface
(
	AircraftState& state,
	Airframe& airframe,
	Table& CLalpha,
	Table& CDalpha,
	Vec3 cp,
	Vec3 surfaceNormal,
	double area
) :
	AeroElement(state, CLalpha, CDalpha, cp, surfaceNormal, area), m_airframe{ airframe }
{

}

Scooter::AeroHorizontalTail::AeroHorizontalTail
(
	AircraftState& state,
	Airframe& airframe,
	Table& CLalpha,
	Table& CDalpha,
	Table& compress,
	Vec3 cp,
	Vec3 surfaceNormal,
	double area
) :
	AeroElement(state, CLalpha, CDalpha, cp, surfaceNormal, area), m_airframe{ airframe }, m_compressElev{ compress }
{

}

Scooter::AeroControlSurface::AeroControlSurface
(
	AircraftState& state,
	Airframe& airframe,
	Table& CLalpha,
	Table& CDalpha,
	Vec3 cp,
	Vec3 surfaceNormal,
	double area
) :
	AeroElement(state, CLalpha, CDalpha, cp, surfaceNormal, area), m_airframe{ airframe }
{

}

void Scooter::AeroElement::zeroInit()
{
	m_dragFactor = 1.0;
	m_liftFactor = 1.0;
	m_scalarAirspeed = 0.0;
	m_aoa = 0.0;
	m_beta = 0.0;
	m_kElem = 0.0;
	m_damageElem = 1.0f;

	m_airspeed = Vec3();
	m_liftVec = Vec3();
	m_dragVec = Vec3();
	m_LDwindAxes = Vec3();
	m_RForceElement = Vec3();
	m_moment = Vec3();
}
void Scooter::AeroElement::coldInit()
{

}
void Scooter::AeroElement::hotInit()
{

}
void Scooter::AeroElement::airborneInit()
{

}

void Scooter::AeroElement::elementLift()
{
	m_LDwindAxes.y = m_kElem * ( m_CLalpha(m_aoa) * abs(cos(m_beta)) * m_liftFactor * m_damageElem );
}

void Scooter::AeroVerticalSurface::elementLift()
{
	m_LDwindAxes.z = m_kElem * ( m_CLalpha(m_aoa) * abs(cos(m_beta)) * m_liftFactor * m_damageElem);
}

void Scooter::AeroElement::elementDrag()
{
	m_LDwindAxes.x = -m_kElem * ( m_CDalpha(m_aoa) * abs(cos(m_beta)) * m_dragFactor);
}

void Scooter::AeroVerticalSurface::elementDrag()
{
	m_LDwindAxes.x = -m_kElem * ( m_CDalpha(m_aoa) * abs(cos(m_beta)) * m_dragFactor);
}

void Scooter::AeroElement::calculateElementPhysics()
{

	// calculate member variables
	m_airspeed = m_state.getLocalAirspeed() + cross(m_state.getOmega(), m_cp);
	m_scalarAirspeed = sqrt(m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z);
	m_dragVec = -normalize(m_airspeed);
	m_kElem = pow(m_scalarAirspeed, 2) * m_state.getAirDensity() * m_area * 0.5;

	//calculate aoa and beta
	Vec3 forwardVec(1.0, 0.0, 0.0);
	Vec3 spanVec = normalize(cross(m_surfaceNormal, forwardVec));
	Vec3 flightPath = m_airspeed;
	Vec3 flightPathProjectedAOA = flightPath - ((flightPath * spanVec) / (spanVec * spanVec)) * spanVec;
	Vec3 flightPathProjectedBeta = flightPath - ((flightPath * m_surfaceNormal) / (m_surfaceNormal * m_surfaceNormal)) * m_surfaceNormal;

	m_aoa = atan2(cross(forwardVec, flightPathProjectedAOA) * spanVec, forwardVec * flightPathProjectedAOA);

	//m_beta = atan2(cross(forwardVec, flightPathProjectedBeta)*m_surfaceNormal, forwardVec*flightPathProjectedBeta);
	m_beta = m_state.getBeta();
	elementLift();
	elementDrag();

	//printf("new: LDVec = %lf, %lf, %lf\n", m_LDwindAxes.x, m_LDwindAxes.y, m_LDwindAxes.z);
	Vec3 deltaCentreOfPressure = m_cp - Vec3(0.0, 0.0, m_state.getCOM().z);
	m_RForceElement = windAxisToBody(m_LDwindAxes, m_aoa, m_beta);
	m_moment = cross(deltaCentreOfPressure, m_RForceElement);
	updateLERX();
}

void Scooter::AeroControlSurface::calculateElementPhysics()
{

	// calculate member variables
	m_airspeed = m_state.getLocalAirspeed() + cross(m_state.getOmega(), m_cp);
	m_scalarAirspeed = sqrt(m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z);
	m_dragVec = -normalize(m_airspeed);
	m_kElem = pow(m_scalarAirspeed, 2) * m_state.getAirDensity() * m_area * 0.5;

	//calculating aoa&beta
	Vec3 forwardVec(1.0, 0.0, 0.0);
	Vec3 spanVec = normalize(cross(m_surfaceNormal, forwardVec));
	Vec3 flightPath = m_airspeed;
	Vec3 flightPathProjectedAOA = flightPath - ((flightPath * spanVec) / (spanVec * spanVec)) * spanVec;
	Vec3 flightPathProjectedBeta = flightPath - ((flightPath * m_surfaceNormal) / (m_surfaceNormal * m_surfaceNormal)) * m_surfaceNormal;
	
	float defToDeg = 0.0;
	if (m_cp.z > 0)
	{
		defToDeg = -m_airframe.getAileron() * toRad(14);
	}
	else
	{
		defToDeg = m_airframe.getAileron() * toRad(14);
	}
	//printf("defToDeg: %lf\n", defToDeg);

	m_aoa = atan2(cross(forwardVec, flightPathProjectedAOA) * spanVec, forwardVec * flightPathProjectedAOA);
	m_aoa += defToDeg;
	//m_beta = atan2(cross(forwardVec, flightPathProjectedBeta)*m_surfaceNormal, forwardVec*flightPathProjectedBeta);
	m_beta = m_state.getBeta();
	elementLift();
	elementDrag();

	//printf("new: LDVec = %lf, %lf, %lf\n", m_LDwindAxes.x, m_LDwindAxes.y, m_LDwindAxes.z);
	Vec3 deltaCentreOfPressure = m_cp - Vec3(0.0, 0.0, m_state.getCOM().z);
	m_RForceElement = windAxisToBody(m_LDwindAxes, m_aoa, m_beta);
	m_moment = cross(deltaCentreOfPressure, m_RForceElement);
	updateLERX();
}

void Scooter::AeroHorizontalTail::calculateElementPhysics()
{

	// calculate member variables
	m_airspeed = m_state.getLocalAirspeed() + cross(m_state.getOmega(), m_cp);
	m_scalarAirspeed = sqrt(m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z);
	m_dragVec = -normalize(m_airspeed);
	m_kElem = pow(m_scalarAirspeed, 2) * m_state.getAirDensity() * m_area * 0.5;
	
	//calculating aoa&beta
	Vec3 forwardVec(1.0, 0.0, 0.0);
	Vec3 spanVec = normalize(cross(m_surfaceNormal, forwardVec));
	Vec3 flightPath = m_airspeed;
	Vec3 flightPathProjectedAOA = flightPath - ((flightPath*spanVec) / (spanVec*spanVec)) * spanVec;
	Vec3 flightPathProjectedBeta = flightPath - ((flightPath*m_surfaceNormal) / (m_surfaceNormal*m_surfaceNormal)) * m_surfaceNormal;
	
	float defToDeg = -m_airframe.getElevator() * toRad(30) * m_compressElev(m_state.getMach());

	//printf("defToDeg: %lf\n", defToDeg);

	m_aoa = atan2(cross(forwardVec, flightPathProjectedAOA) * spanVec, forwardVec * flightPathProjectedAOA);
	m_aoa += defToDeg;
	m_aoa += -m_airframe.getStabilizer();
	//m_beta = atan2(cross(forwardVec, flightPathProjectedBeta)*m_surfaceNormal, forwardVec*flightPathProjectedBeta);
	m_beta = m_state.getBeta();
	elementLift();
	elementDrag();
	
	//printf("new: LDVec = %lf, %lf, %lf\n", m_LDwindAxes.x, m_LDwindAxes.y, m_LDwindAxes.z);
	Vec3 deltaCentreOfPressure = m_cp - Vec3(0.0, 0.0, m_state.getCOM().z);
	m_RForceElement = windAxisToBody(m_LDwindAxes, m_aoa, m_beta);
	m_moment = cross(deltaCentreOfPressure, m_RForceElement);
	
}

void Scooter::AeroVerticalSurface::calculateElementPhysics()
{

	// calculate member variables
	m_airspeed = m_state.getLocalAirspeed() + cross(m_state.getOmega(), m_cp);
	m_scalarAirspeed = sqrt(m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z);
	m_dragVec = -normalize(m_airspeed);
	m_kElem = pow(m_scalarAirspeed, 2) * m_state.getAirDensity() * m_area * 0.5;

	//calculating aoa&beta
	Vec3 forwardVec(1.0, 0.0, 0.0);
	Vec3 spanVec = normalize(cross(m_surfaceNormal, forwardVec));
	Vec3 flightPath = m_airspeed;
	Vec3 flightPathProjectedAOA = flightPath - ((flightPath*spanVec) / (spanVec*spanVec)) * spanVec;
	Vec3 flightPathProjectedBeta = flightPath - ((flightPath*m_surfaceNormal) / (m_surfaceNormal*m_surfaceNormal)) * m_surfaceNormal;

	float defToDeg = -m_airframe.getRudder() * toRad(17);

	//printf("defToDeg: %lf\n", defToDeg);

	m_aoa = atan2(cross(forwardVec, flightPathProjectedAOA)*spanVec, forwardVec*flightPathProjectedAOA);
	m_aoa += defToDeg;
	//m_beta = atan2(cross(forwardVec, flightPathProjectedBeta)*m_surfaceNormal, forwardVec*flightPathProjectedBeta);
	m_beta = m_state.getAOA();

	elementLift();
	elementDrag();

	//printf("new: LDVec = %lf, %lf, %lf\n", m_LDwindAxes.x, m_LDwindAxes.y, m_LDwindAxes.z);
	Vec3 deltaCentreOfPressure = m_cp - Vec3(0.0, 0.0, m_state.getCOM().z);
	m_RForceElement = windAxisToBody(m_LDwindAxes, m_beta, m_aoa);
	m_moment = cross(deltaCentreOfPressure, m_RForceElement);
}

