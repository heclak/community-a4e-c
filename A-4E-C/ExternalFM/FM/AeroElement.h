#pragma once

#include "BaseComponent.h"
#include <iostream>
#include "Vec3.h"
#include "Table.h"
#include "Interface.h"
#include "AircraftState.h"
#include <fstream>

namespace Skyhawk
{//begin namespace


class FlightModel;

class AeroElement : public BaseComponent
{
public:
	AeroElement(AircraftState& state, Table& CLalpha, Table& CDalpha, Vec3 cp, Vec3 surfaceNormal, double MAC, double m_area);
	~AeroElement();

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	void elementLift();
	void elementDrag();
	void calculateElementPhysics();
	Vec3 getForce() { return m_RForceElement; }
	

private:
	const Vec3 m_cp;
	const Vec3 m_surfaceNormal;
	const double m_MAC;
	const double m_area;
	double m_liftFactor;
	double m_dragFactor;
	Vec3 m_airspeed;
	Vec3 m_liftVec;
	Vec3 m_dragVec;
	Vec3 m_LDwindAxes;
	Vec3 m_RForceElement;
	double m_scalarAirspeed;
	double m_aoa;
	double m_beta;
	double m_kElem; // m_k
	double m_damageElem;


	Table& m_CLalpha;
	Table& m_CDalpha;


	AircraftState& m_state;
};


} //end namespace
