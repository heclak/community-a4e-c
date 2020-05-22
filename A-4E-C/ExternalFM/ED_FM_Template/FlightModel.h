#ifndef FLIGHTMODEL_H
#define FLIGHTMODEL_H
#pragma once
#include "Vec3.h"
#include "Table.h"
#include "Input.h"
namespace Skyhawk
{//begin namespace

class FlightModel
{
public:
	FlightModel(Input& controls);
	~FlightModel();

	//Utility.


	//Adds a force (and moment caused by it)
	//in the local reference frame of the aircraft.
	inline void addForce(const Vec3& force, const Vec3& pos);
	

	//Setup parameters before calculation.
	inline void setAtmosphericParams(const double density, const double speedOfSound, const Vec3& wind);
	inline void setCOM(const Vec3& com);
	inline void setWorldVelocity(const Vec3& worldVelocity);
	inline void setPhysicsParams(const double aoa, const double beta, const Vec3& angle, const Vec3& omega, const Vec3& omegaDot);


	//Actually calculate something.
	inline void L_stab();
	inline void M_stab();
	inline void N_stab();

	inline void lift();
	inline void drag();
	inline void sideForce();
	inline void thrustForce();

	inline double elevator();
	inline double aileron();
	inline double rudder();
	inline double thrust();

	void calculateAero();
	void calculateForcesAndMoments(double dt);

	//Get forces for ED physics engine.
	inline const Vec3& getForce() const;
	inline const Vec3& getMoment() const;

	//Get COM for ED physics engine.
	inline const Vec3& getCOM() const;

private:

	//=====================BIG WARNING=====================//
	//       DO NOT CHANGE THE ORDER OF THESE CONSTANTS
	//DOING SO MAY RESULT IN THE TABLES USING ININTIALISED DATA
	//This is because the constructor constructs based on the order
	//of declaration not the order of the list in the constructor.
	//=====================BIG WARNING=====================//
	//Aircraft constants (METRIC and RADIANS)
	const double m_aileronUp = 0.35;
	const double m_aileronDown = -0.35;
				 
	const double m_elevatorUp = 0.3;
	const double m_elevatorDown = -0.35;
				 
	const double m_rudderRight = 0.35;
	const double m_rudderLeft = -0.35;
				 
	const double m_flapUp = 0.0;
	const double m_flapDown = 0.52;
				 
	const double m_speedBrakeIn = 0.0;
	const double m_speedBrakeOut = 1.0;
				 
	const double m_totalWingArea = 24;
	const double m_totalWingSpan = 8.3;
	const double m_chord = 2.9;
				 
	const double m_horizontalTailArea = 4.8;
	const double m_horizontalTailArm = 5.1;
				 
	const double m_verticalTailArea = 2.9;
	const double m_verticalTailArm = 5.1;

	const double m_wingIncidence = 0.035;
				 
	const double m_thrust = 38000;

	//Atmospheric Parameters
	double m_density; //atmospheric density
	double m_speedOfSound; //
	Vec3 m_wind; //

	//
	double m_q; //0.5*V^2 * s * b
	double m_p; //0.25*V * s * b^2
	double m_k; //0.5V^2 * s
	//Aircraft Parameters
	Vec3 m_com; //Centre of mass
	double m_fuel;
	double m_previousFuel;

	Vec3 m_worldVelocity; //velocity in the world frame
	Vec3 m_airspeed; //speed through the air
	double m_mach;
	double m_scalarVSquared;
	double m_aoa; //angle of attack
	double m_aoaPrevious; //previous frame angle of attack
	double m_aoaDot; //aoa per unit time
	double m_beta; //angle of slip

	Vec3 m_omegaDot;
	Vec3 m_omega;
	Vec3 m_angle;

	Vec3 m_moment; //total moment of aircraft
	Vec3 m_force; //total force on the aircraft

	double m_aileronLeft;
	double m_aileronRight;
	double m_elevator;
	double m_rudder;

	//Tables m_ removed for easy of use

	//Lift
	Table CLalpha; //lift with alpha (RADIANS)
	Table dCLflap; //delta lift with flap (DEGREE) CHANGEME
	Table CLde; //lift elevator deflection

	//Drag
	Table CDalpha; //drag with alpha (RADIANS)
	Table CDi; //induced drag constant
	Table CDmach; //drag with mach
	Table CDflap; //drag with angle of flap (RADIANS)
	Table CDspeedBrake; //drag with position of speedbrake normalised 0 - 1
	Table CDbeta; //drag with beta (RADIANS)
	Table CDde; //drag due to elevator deflection

	//Side Force
	Table CYb; //side force with beta

	//Stability Derrivatives
	//Roll
	Table Clb; //roll moment with beta (RADIANS)
	Table Clp; //roll moment due to roll rate (RADIANS per Second)
	Table Clr; //roll moment due to yaw rate (RADIANS per Second)
	Table Cla; //roll moment due to aileron (RADIANS)
	Table Cldr; //roll moment due to rudder (RADIANS)

	//Pitch
	Table Cmalpha; //pitch moment with alpha (RADIANS)
	Table Cmde; //pitch moment due to elevator (RADIANS)
	Table Cmq; //pitch moment due to pitch rate (RADIANS per Second)
	Table Cmadot; //pitch moment due to alpha rate (RADIANS per second)

	//Yaw
	Table Cnb; //yaw moment due to beta (RADIANS)
	Table Cnr; //yaw moment due to yaw rate (RADIANS per Second)
	Table Cndr; //yaw moment due to rudder (RADIANS)
	Table Cnda; //yaw moment due to aileron deflection (Adverse Yaw) (RADIANS)

	Input& m_controls; //for now
};

void FlightModel::setAtmosphericParams
(
	const double density,
	const double speedOfSound,
	const Vec3& wind
)
{
	m_density = density;
	m_speedOfSound = speedOfSound;
	m_wind = wind;
}

void FlightModel::setCOM(const Vec3& com)
{
	m_com = com;
}

void FlightModel::setWorldVelocity(const Vec3& worldVelocity)
{
	m_worldVelocity = worldVelocity;
}

void FlightModel::setPhysicsParams
(
	const double aoa,
	const double beta,
	const Vec3& angle, //angle
	const Vec3& omega, //angular velocity
	const Vec3& omegaDot //angular acceleration
)
{
	m_aoa = aoa;
	m_beta = beta;
	m_angle = angle;
	m_omega = omega;
	m_omegaDot = omegaDot;
}

const Vec3& FlightModel::getForce() const
{
	return m_force;
}

const Vec3& FlightModel::getMoment() const
{
	return m_moment;
}

const Vec3& FlightModel::getCOM() const
{
	return m_com;
}

void FlightModel::addForce(const Vec3& force, const Vec3& pos)
{
	//Add the force to the overall force
	m_force += force;

	//Calculate the relative position to the centre of mass
	Vec3 relativePos = pos - m_com;

	//Calculate the "moment" (actually torque)
	Vec3 moment = cross(relativePos, force);

	//Add it on
	m_moment += moment;
}

void FlightModel::L_stab()
{
	//m_moment.x
	m_moment.x += m_q * (Clb(0.0)*m_beta + Cla(m_mach)*aileron() + Cldr(0.0)*rudder()) + m_p * (Clp(0.0)*m_omega.x + Clr(0.0)*m_omega.y);
}

void FlightModel::M_stab()
{
	//m_moment.z
	m_moment.z += 0.5 * m_scalarVSquared * m_totalWingArea * m_chord * (Cmalpha(m_aoa) * m_aoa + Cmde(m_mach) * elevator()) + 0.25 * m_mach * m_speedOfSound * m_totalWingArea * m_chord * m_chord * (Cmq(0.0)*m_omega.z + Cmadot(0.0)*m_aoaDot);
}

void FlightModel::N_stab()
{
	//m_moment.y
	m_moment.y += m_q * (-Cnb(m_mach)*m_beta + Cnda(0.0)*aileron() + Cndr(0.0)*rudder() ) + m_p * (Cnr(0.0)*m_omega.y);
	//printf("m_moment.y: %lf, m_beta: %lf, Cnb(mach)*m_beta: %lf, Cndr*rudder: %lf, Cnr*m_omega.y: %lf\n",
		//m_moment.y, m_beta, Cnb(m_mach)*m_beta, Cndr(0.0)*rudder(), Cnr(0.0)*m_omega.y);
}

double FlightModel::elevator()
{
	return m_controls.pitch() > 0.0 ? -m_elevatorUp * m_controls.pitch() : m_elevatorDown * m_controls.pitch();
}

double FlightModel::aileron()
{
	return m_controls.roll() > 0.0 ? m_aileronUp * m_controls.roll() : -m_aileronDown * m_controls.roll();
}

double FlightModel::rudder()
{
	return m_controls.yaw() > 0.0 ? m_rudderRight * m_controls.yaw() : -m_rudderLeft * m_controls.yaw();
}

double FlightModel::thrust()
{

	printf("thrust: %lf, force: %lf\n", m_controls.throttle(), (-m_controls.throttle() + 1) * m_thrust / 2.0);
	return (-m_controls.throttle() + 1) * m_thrust / 2.0;
}

void FlightModel::lift()
{
	addForce(Vec3(0.0, m_k*CLalpha(m_aoa), 0.0), getCOM());
}

void FlightModel::drag()
{
	double CD = CDi(0.0)*CLalpha(m_aoa) * CLalpha(m_aoa) + CDalpha(m_aoa) + CDbeta(m_beta) + CDde(0.0)*elevator() + CDmach(m_mach);
	printf("CDI*CL*CL: %lf, CDalpha: %lf, CDbeta: %lf, CDde*elevator: %lf, CDmach: %lf",
		CDi(0.0) * CLalpha(m_aoa) * CLalpha(m_aoa), CDalpha(m_aoa), CDbeta(m_beta), CDde(0.0) * elevator(), CDmach(m_mach));
	addForce(Vec3(-m_k * CD, 0.0, 0.0), getCOM());
}

void FlightModel::sideForce()
{
	addForce(Vec3(0.0, 0.0, m_k*CYb(0.0)*m_beta), getCOM());
}

void FlightModel::thrustForce()
{
	addForce(Vec3(thrust(), 0.0, 0.0), getCOM());
}

}//end namespace

#endif