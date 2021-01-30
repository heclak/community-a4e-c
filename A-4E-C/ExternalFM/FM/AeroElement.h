#pragma once
//=========================================================================//
//
//		FILE NAME	: AeroElement.h
//		AUTHOR		: TerjeTL
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Provides element classes for aerodynamics simulation.
//
//================================ Includes ===============================//
#include "BaseComponent.h"
#include <iostream>
#include "Vec3.h"
#include "Table.h"
#include "Interface.h"
#include "Airframe.h"
#include "AircraftState.h"
#include "Maths.h"
#include <fstream>
//=========================================================================//

namespace Scooter
{//begin namespace


class FlightModel;

class AeroElement : public BaseComponent
{
public:
	//AeroElement(AircraftState& state, Table& CLalpha, Table& CDalpha, Vec3 cp, Vec3 surfaceNormal, double surfaceConstant, bool isSurface);
	~AeroElement();

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	virtual void elementLift();
	virtual void elementDrag();
	virtual void calculateElementPhysics();

	double getAOA() { return m_aoa; }
	double getBeta() { return m_beta; }
	Vec3 getForce() { return m_RForceElement; }
	Vec3 getMoment() { return m_moment; }

	inline void setLDFactor(double liftFactor, double dragFactor);
	inline void setLFactor(double liftFactor);
	inline void setDFactor(double dragFactor);
	
	double m_kElem = 0.0; // m_k
	double m_aoa = 0.0;
protected:
	AeroElement(AircraftState& state, Table& CLalpha, Table& CDalpha, Vec3 cp, Vec3 surfaceNormal, double area);

	const Vec3 m_cp;
	const Vec3 m_surfaceNormal;
	const double m_area;
	double m_liftFactor;
	double m_dragFactor;
	Vec3 m_airspeed;
	Vec3 m_liftVec;
	Vec3 m_dragVec;
	Vec3 m_LDwindAxes;
	Vec3 m_RForceElement;
	Vec3 m_moment;
	double m_scalarAirspeed = 0.0;
	
	double m_beta = 0.0;
	
	float m_damageElem = 1.0f;
	Table& m_CLalpha;
	Table& m_CDalpha;

	AircraftState& m_state;
};

class AeroSurface : public AeroElement
{
public:
	AeroSurface(AircraftState& state, Table& CLalpha, Table& CDalpha, Vec3 cp, Vec3 surfaceNormal, double area);
};

class AeroVerticalSurface : public AeroElement
{
public:
	AeroVerticalSurface(AircraftState& state, Airframe& airframe, Table& CLalpha, Table& CDalpha, Vec3 cp, Vec3 surfaceNormal, double area);
	void calculateElementPhysics() override;
	void elementLift() override;
	void elementDrag() override;
private:
	Airframe& m_airframe;
};

class AeroHorizontalTail : public AeroElement
{
public:
	AeroHorizontalTail(AircraftState& state, Airframe& airframe, Table& CLalpha, Table& CDalpha, Table& compress, Vec3 cp, Vec3 surfaceNormal, double area);
	void calculateElementPhysics() override;
private:
	Airframe& m_airframe;
	Table& m_compressElev;
};

class AeroControlSurface : public AeroElement
{
public:
	AeroControlSurface(AircraftState& state, Airframe& airframe, Table& CLalpha, Table& CDalpha, Vec3 cp, Vec3 surfaceNormal, double area);
	void calculateElementPhysics() override;
private:
	Airframe& m_airframe;
};

void AeroElement::setLDFactor(double liftFactor, double dragFactor)
{
	m_liftFactor = liftFactor;
	m_dragFactor = dragFactor;
}

void AeroElement::setLFactor(double liftFactor)
{
	m_liftFactor = liftFactor;
}

void AeroElement::setDFactor(double dragFactor)
{
	m_dragFactor = dragFactor;
}

} //end namespace
