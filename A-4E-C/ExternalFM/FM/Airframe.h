#ifndef AIRFRAME_H
#define AIRFRAME_H
#pragma once
#include "Input.h"
#include <stdio.h>
#include "Engine.h"
#include "Vec3.h"
namespace Skyhawk
{//begin namespace



#define c_aileronUp 0.35
#define c_aileronDown -0.35

#define c_elevatorUp 0.3
#define c_elevatorDown -0.35

#define c_rudderRight 0.35
#define c_rudderLeft -0.35

#define c_flapUp 0.0
#define c_flapDown 0.52

#define c_speedBrakeIn 0.0
#define c_speedBrakeOut 1.0

#define c_maxfuel 2137.8

#define c_catAngle 0.0 //6 degrees
#define	c_catConstrainingForce 4000.0

#define NUM_ELEM 111

class Airframe
{
public:

	enum CatapultState
	{
		ON_CAT_READY,
		ON_CAT_NOT_READY,
		ON_CAT_WAITING,
		ON_CAT_LAUNCHING,
		OFF_CAT
	};

	//Don't touch this it's order dependent you will break the tank code.
	enum Tank
	{
		INTERNAL,
		LEFT_EXT,
		CENTRE_EXT,
		RIGHT_EXT,
		DONT_TOUCH //Seriously don't touch it.
	};


	Airframe(Input& controls, Engine& engine);
	~Airframe();
	void zeroInit();
	void coldInit();
	void hotInit();
	void airborneInit();

	//Utility
	inline void setGearPosition(double position); //for airstart or ground start
	inline void setFlapsPosition(double position);
	inline void setSpoilerPosition(double position);
	inline void setSlatLPosition(double position);
	inline void setSlatRPosition(double position);
	inline void setAirbrakePosition(double position);
	inline void setFuelState(Tank tank, Vec3 pos, double fuel);
	inline void setFuelStateNorm(double fuel);
	inline void setAngle(double angle);
	inline void setMass(double angle);

	inline void setFuelStateLExt(double fuel);
	inline void setFueCStateLExt(double fuel);
	inline void setFueRStateLExt(double fuel);

	inline void setLExtVec(Vec3 vec);
	inline void setCExtVec(Vec3 vec);
	inline void setRExtVec(Vec3 vec);

	inline const Vec3& getLExtVec() const;
	inline const Vec3& getCExtVec() const;
	inline const Vec3& getRExtVec() const;

	inline const Vec3& getLExtVecSqr() const;
	inline const Vec3& getCExtVecSqr() const;
	inline const Vec3& getRExtVecSqr() const;

	inline void setSelectedTank(Tank selected);

	inline const Vec3& getFuelPos(Tank tank) const;
	inline const Vec3& getFuelPosSqr(Tank tank) const;
	inline double getFuelQty(Tank tank) const;
	inline double getFuelQtyExternal() const;
	inline double getFuelQtyDelta(Tank tank) const;

	inline double getGearPosition(); //returns gear pos
	inline double getFlapsPosition();
	inline double getSpoilerPosition();
	inline double getSpeedBrakePosition();
	inline double getHookPosition();
	inline double getSlatLPosition();
	inline double getSlatRPosition();
	inline double getFuelState();
	inline double getPrevFuelState();
	inline double getLeftTankDelta();
	inline double getCentreTankDelta();
	inline double getRightTankDelta();
	inline double getFuelStateNorm();
	inline double getCatMoment();
	inline Tank getSelectedTank();
	inline double getMass();
	inline double aileron();
	inline double elevator();
	inline double rudder();

	inline double aileronAngle();
	inline double elevatorAngle();
	inline double rudderAngle();

	inline const CatapultState& catapultState() const;
	inline CatapultState& catapultState();
	inline const bool& catapultStateSent() const;
	inline bool& catapultStateSent();
	inline void setCatStateFromKey();

	inline void setIntegrityElement(int element, float integrity);
	inline float getIntegrityElement(int element);

	//Update
	void airframeUpdate(double dt); //performs calculations and updates
	inline void fuelUpdate(double dt);
	//Airframe Angles

private:

	//Airframe Constants
	const double m_gearExtendTime = 3.0;
	const double m_flapsExtendTime = 5.0;
	const double m_airbrakesExtendTime = 3.0;
	const double m_hookExtendTime = 1.5;
	const double m_slatsExtendTime = 0.25;


	//Airframe Variables
	double m_gearPosition = 0.0; //0 -> 1
	double m_flapsPosition = 0.0;
	double m_spoilerPosition = 0.0;
	double m_speedBrakePosition = 0.0;
	double m_hookPosition = 0.0;
	double m_slatLPosition = 0.0;
	double m_slatRPosition = 0.0;

	double m_aileronLeft = 0.0;
	double m_aileronRight = 0.0;
	double m_elevator = 0.0;
	double m_rudder = 0.0;



	Tank m_selected;

	double m_fuel[4] = { 0.0, 0.0, 0.0, 0.0 };
	double m_fuelPrev[4] = { 0.0, 0.0, 0.0, 0.0 };
	Vec3 m_fuelPos[4] = { Vec3(), Vec3(), Vec3(), Vec3() };
	Vec3 m_fuelPosSqr[4] = { Vec3(), Vec3(), Vec3(), Vec3() };

	float* m_integrityElement;

	//double m_fuel = 0.0;
	//double m_fuelPrevious = 0.0;

	double m_fuelExtL = 0.0;
	double m_fuelExtLPrev = 0.0;
	Vec3 m_fuelExtPosL;
	Vec3 m_fuelExtPosLSqr;

	double m_fuelExtC = 0.0;
	double m_fuelExtCPrev = 0.0;
	Vec3 m_fuelExtPosC;
	Vec3 m_fuelExtPosCSqr;

	double m_fuelExtR = 0.0;
	double m_fuelExtRPrev = 0.0;
	Vec3 m_fuelExtPosR;
	Vec3 m_fuelExtPosRSqr;



	double m_mass = 1.0;

	CatapultState m_catapultState = OFF_CAT;
	bool m_catStateSent = false;
	double m_catMoment = 0.0;
	double m_angle = 0.0;

	Engine& m_engine;
	Input& m_controls;
};

void Airframe::setSelectedTank(Tank selected)
{
	m_selected = selected;
}

void Airframe::setFuelState(Tank tank, Vec3 pos, double fuel)
{
	m_fuel[tank] = fuel;
	m_fuelPrev[tank] = fuel;
	m_fuelPos[tank] = pos;
	m_fuelPosSqr[tank] = Vec3(pos.x * pos.x, pos.y * pos.y, pos.z * pos.z);
}

void Airframe::setFlapsPosition(double position)
{
	m_flapsPosition = position;
}

void Airframe::setGearPosition(double position)
{
	m_gearPosition = position;
}

void Airframe::setAirbrakePosition(double position)
{
	m_speedBrakePosition = position;
}

void Airframe::setAngle(double angle)
{
	m_angle = angle;
}

void Airframe::setMass(double mass)
{
	m_mass = mass;
}

double Airframe::getGearPosition()
{
	return m_gearPosition;
}

double Airframe::getFlapsPosition()
{
	return m_flapsPosition;
}

double Airframe::getSpoilerPosition()
{
	return m_spoilerPosition;
}

double Airframe::getSpeedBrakePosition()
{
	return m_speedBrakePosition;
}

double Airframe::getHookPosition()
{
	return m_hookPosition;
}

double Airframe::getSlatLPosition()
{
	return m_slatLPosition;
}

double Airframe::getSlatRPosition()
{
	return m_slatRPosition;
}

double Airframe::aileron()
{
	return m_aileronLeft;
}

double Airframe::elevator()
{
	return m_elevator;
}

double Airframe::rudder()
{
	return m_rudder;
}

double Airframe::aileronAngle()
{
	return 	m_aileronLeft > 0.0 ? c_aileronUp * m_aileronLeft : -c_aileronDown * m_aileronLeft;
}

double Airframe::elevatorAngle()
{
	return m_elevator > 0.0 ? -c_elevatorUp * m_elevator : c_elevatorDown * m_elevator;
}

double Airframe::rudderAngle()
{
	return m_rudder > 0.0 ? c_rudderRight * m_rudder : -c_rudderLeft * m_rudder;
}

void Airframe::setSlatLPosition(double position)
{
	m_slatLPosition = position;
}

void Airframe::setSlatRPosition(double position)
{
	m_slatRPosition = position;
}

void Airframe::setSpoilerPosition(double position)
{
	m_spoilerPosition = position;
}

const Airframe::CatapultState& Airframe::catapultState() const
{
	return m_catapultState;
}

Airframe::CatapultState& Airframe::catapultState()
{
	return m_catapultState;
}

const bool& Airframe::catapultStateSent() const
{
	return m_catStateSent;
}

bool& Airframe::catapultStateSent()
{
	return m_catStateSent;
}

void Airframe::setCatStateFromKey()
{
	switch (m_catapultState)
	{
	case ON_CAT_NOT_READY:
	case ON_CAT_READY:
	case ON_CAT_WAITING:
		printf("OFF_CAT\n");
		m_catapultState = OFF_CAT;
		break;
	case OFF_CAT:
		printf("ON_CAT_NOT_READY\n");
		m_catapultState = ON_CAT_NOT_READY;
		break;
	}
}

double Airframe::getLeftTankDelta()
{
	return m_fuelExtL - m_fuelExtLPrev;
}

double Airframe::getCentreTankDelta()
{
	return m_fuelExtC - m_fuelExtCPrev;
}

double Airframe::getRightTankDelta()
{
	return m_fuelExtR - m_fuelExtRPrev;
}

const Vec3& Airframe::getFuelPos(Tank tank) const
{
	return m_fuelPos[tank];
}

const Vec3& Airframe::getFuelPosSqr(Tank tank) const
{
	return m_fuelPosSqr[tank];
}

double Airframe::getFuelQty(Tank tank) const
{
	return m_fuel[tank];
}

double Airframe::getFuelQtyExternal() const
{
	return m_fuel[Tank::LEFT_EXT] + m_fuel[Tank::CENTRE_EXT] + m_fuel[Tank::RIGHT_EXT];
}

double Airframe::getFuelQtyDelta(Tank tank) const
{
	return m_fuel[tank] - m_fuelPrev[tank];
}

double Airframe::getCatMoment()
{
	return m_catMoment;
}

double Airframe::getMass()
{
	return m_mass;
}

inline Airframe::Tank Airframe::getSelectedTank()
{
	return m_selected;
}

inline void Airframe::setLExtVec(Vec3 vec)
{
	m_fuelExtPosL = vec;
	m_fuelExtPosLSqr = Vec3(vec.x*vec.x, vec.y*vec.y, vec.z*vec.z);
}

inline void Airframe::setCExtVec(Vec3 vec)
{
	m_fuelExtPosC = vec;
	m_fuelExtPosCSqr = Vec3(vec.x * vec.x, vec.y * vec.y, vec.z * vec.z);
}

inline void Airframe::setRExtVec(Vec3 vec)
{
	m_fuelExtPosR = vec;
	m_fuelExtPosRSqr = Vec3(vec.x * vec.x, vec.y * vec.y, vec.z * vec.z);
}

inline const Vec3& Airframe::getLExtVec() const
{
	return m_fuelExtPosL;
}

inline const Vec3& Airframe::getCExtVec() const
{
	return m_fuelExtPosC;
}

inline const Vec3& Airframe::getRExtVec() const
{
	return m_fuelExtPosR;
}

inline const Vec3& Airframe::getLExtVecSqr() const
{
	return m_fuelExtPosLSqr;
}

inline const Vec3& Airframe::getCExtVecSqr() const
{
	return m_fuelExtPosCSqr;
}

inline const Vec3& Airframe::getRExtVecSqr() const
{
	return m_fuelExtPosRSqr;
}

inline void Airframe::setIntegrityElement(int element, float integrity)
{
	m_integrityElement[element] = integrity;
}

inline float Airframe::getIntegrityElement(int element)
{
	return m_integrityElement[element];
}

inline void setFuelStateLExt(double fuel);
inline void setFueCStateLExt(double fuel);
inline void setFueRStateLExt(double fuel);



}//end namespace

#endif
