#ifndef FLIGHTMODEL_H
#define FLIGHTMODEL_H
#pragma once
#include <iostream>
#include "Vec3.h"
#include "Table.h"
#include "Input.h"
#include "Airframe.h"
#include "Engine.h"
#include "Interface.h"
#include <fstream>

namespace Skyhawk
{//begin namespace

class FlightModel
{
public:
	FlightModel(Input& controls, Airframe& airframe, Engine& engine, Interface& inter);
	~FlightModel();

	void zeroInit();
	void coldInit();
	void hotInit();
	void airbornInit();


	//Utility.
	//Used to snap gear into place for say cold start or airstart.
	void setGearPosition();

	//Adds a force (and moment caused by it)
	//in the local reference frame of the aircraft.
	inline void addForce(const Vec3& force, const Vec3& pos);
	inline void addForceDir(const Vec3& force, const Vec3& dir);

	//Setup parameters before calculation.
	inline void setAtmosphericParams(const double density, const double speedOfSound, const Vec3& wind);
	inline void setCOM(const Vec3& com);
	inline void setWorldVelocity(const Vec3& worldVelocity);
	inline void setPhysicsParams(const double aoa, const double beta, const Vec3& angle, const Vec3& omega, const Vec3& omegaDot, const Vec3& airspeedLocal, const Vec3& accLocal);
	inline const Vec3 windAxisToBody(const Vec3& force, const double& alpha, const double& beta) const;
	void calculateLocalPhysicsParams();

	//Actually calculate something.
	inline void L_stab();
	inline void M_stab();
	inline void N_stab();

	inline void lift();
	inline void drag();
	void calculateElements();
	inline void sideForce();
	inline void thrustForce();

	inline double elevator();
	inline double aileron();
	inline double rudder();
	void slats(double& dt);
	inline double thrust();

	void calculateAero();
	void calculateForcesAndMoments(double dt);
	void calculateShake();

	//Get forces for ED physics engine.
	inline const Vec3& getForce() const;
	inline const Vec3& getMoment() const;

	//Get COM for ED physics engine.
	inline const Vec3& getCOM() const;

	//get yaw rate
	inline double yawRate();
	inline double mach();

	//other
	void csvData(std::vector<double>& data);
	inline double toDegrees(double angle);
	inline double toRad(double angle);
	inline int getRandomNumber(int min, int max);
	inline double getCockpitShake();
	inline void setCockpitShakeModifier( double mod );

private:

	//=====================BIG WARNING=====================//
	//       DO NOT CHANGE THE ORDER OF THESE CONSTANTS
	//DOING SO MAY RESULT IN THE TABLES USING ININTIALISED DATA
	//This is because the constructor constructs based on the order
	//of declaration not the order of the list in the constructor.
	//=====================BIG WARNING=====================//
	//Aircraft constants (METRIC and RADIANS)
				 
	const double m_totalWingArea = 24;
	const double m_totalWingSpan = 8.3;
	const double m_chord = 2.9;
				 
	const double m_horizontalTailArea = 4.8;
	const double m_horizontalTailArm = 5.1;
				 
	const double m_verticalTailArea = 2.9;
	const double m_verticalTailArm = 5.1;

	const double m_wingIncidence = 0.0;
				 
	const double m_thrust = 38000;

	//Atmospheric Parameters
	double m_density; //atmospheric density
	double m_speedOfSound; //
	Vec3 m_wind; //

	//
	double m_q; //0.5*p*V^2 * s * b
	double m_p; //0.25*p*V * s * b^2
	double m_k; //0.5*p*V^2 * s
	double m_kL;
	double m_kR;

	//Aircraft Parameters
	Vec3 m_com; //Centre of mass

	Vec3 m_localAcc;
	Vec3 m_worldVelocity; //velocity in the world frame
	Vec3 m_airspeed; //speed through the air (world frame)
	Vec3 m_airspeedLocal; //speed through the air (local aircraft frame)
	double m_mach;
	double m_scalarVSquared;
	double m_scalarV;
	double m_aoa; //angle of attack
	double m_aoaPrevious; //previous frame angle of attack
	double m_aoaDot; //aoa per unit time
	double m_beta; //angle of slip
	double m_betaPrevious;
	double m_betaDot;

	Vec3 m_LDwindAxesLW; //Lift and drag, calculated in wind axes
	Vec3 m_LDwindAxesRW; //Lift and drag, calculated in wind axes
	Vec3 m_CDwindAxesComp; //Drag from various elements, calculated in wind axes
	Vec3 m_airspeedLW; //local airspeed left wing (local)
	Vec3 m_airspeedRW; //local airspeed right wing (local)
	double m_scalarAirspeedLW;
	double m_scalarAirspeedRW;
	Vec3 m_liftVecLW; //Direction of lift from LW
	Vec3 m_liftVecRW; //Direction of lift from RW
	Vec3 m_dragVecLW;
	Vec3 m_dragVecRW;
	Vec3 m_nLW;
	Vec3 m_nRW;
	Vec3 m_rLW;	//directional vector from CG to CP of aerodynamic element (LW)
	Vec3 m_rRW;	//directional vector from CG to CP of aerodynamic element (RW)
	double m_aoaLW;
	double m_aoaRW;
	double m_integrityLW;
	double m_integrityRW;
	double m_integrityRud;
	double m_integrityAil;
	double m_integrityElev;
	double m_integrityHStab;
	double m_integrityHstab;
	double m_integrityFlapL;
	double m_integrityFlapR;

	//slats
	const double m_slatMass = 20.0; //mass (kg)
	const double m_slatDamping = 10.0; //damping (-)
	const double m_slatSpring = 1000.0; //spring (-)
	const double m_slatArea = 3.0; //flat plate
	const double m_aoaZero = 0.261799388;//0.261799; //aoa in body frame at which slat has zero lift (rad)
	double m_LslatVel; //speed of slat (m/s)
	double m_RslatVel;
	Table slatCL; //lift coefficient for slat airfoil

	Vec3 m_omegaDot;
	Vec3 m_omega;
	Vec3 m_angle;

	Vec3 m_moment; //total moment of aircraft
	Vec3 m_force; //total force on the aircraft

	//Aircraft Settings
	Engine& m_engine;
	Airframe& m_airframe;
	double m_aileronLeft;
	double m_aileronRight;
	double m_elevator;
	double m_rudder;

	double m_gearPosition = 0.0;

	//Tables m_ removed for easy of use

	//Lift
	Table CLalpha; //lift with alpha (RADIANS)
	Table dCLflap; //delta lift with flap, alpha (RADIANS)
	Table dCLslat; //delta lift with slat, alpha (RADIANS)
	Table dCLspoiler;
	Table CLde; //lift elevator deflection

	//Drag
	Table CDalpha; //drag with alpha (RADIANS)
	Table CDi; //induced drag constant
	Table CDmach; //drag with mach
	Table CDflap; //drag with angle of flap (RADIANS)
	Table CDslat;
	Table dCDspoiler;
	Table dCDspeedBrake; //drag with position of speedbrake normalised 0 - 1
	Table CDbeta; //drag with beta (RADIANS)
	Table CDde; //drag due to elevator deflection
	double CDgear = 0.03;

	//Side Force
	Table CYb; //side force with beta

	//Stability Derrivatives
	//Roll
	Table Clb; //roll moment with beta (RADIANS)
	Table Clp; //roll moment due to roll rate (RADIANS per Second)
	Table Clr; //roll moment due to yaw rate (RADIANS per Second)
	Table Cla; //roll moment due to aileron (RADIANS)
	Table Cldr; //roll moment due to rudder (RADIANS)
	Table Cla_a;

	//Pitch
	Table Cmalpha; //pitch moment with alpha (MACH)
	Table Cmde; //pitch moment due to elevator (RADIANS)
	Table Cmq; //pitch moment due to pitch rate (RADIANS per Second) [MACH]
	Table Cmadot; //pitch moment due to alpha rate (MACH)
	Table CmM; //pitch moment due to mach number (-)

	//Yaw
	Table Cnb; //yaw moment due to beta (RADIANS)
	Table Cnr; //yaw moment due to yaw rate (RADIANS per Second)
	Table Cndr; //yaw moment due to rudder (RADIANS)
	Table Cnda; //yaw moment due to aileron deflection (Adverse Yaw) (RADIANS)

	Table Cmde_a;
	Table rnd_aoa;

	Input& m_controls; //for now

	//Misc
	double m_cockpitShake;
	double m_cockpitShakeModifier = 0.0;
	Interface m_interface;
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
	const Vec3& omegaDot, //angular acceleration
	const Vec3& localAirspeed, //
	const Vec3& localAcc
)
{
	m_aoa = aoa;
	m_beta = beta;
	m_angle = angle;
	m_omega = omega;
	m_omegaDot = omegaDot;
	m_airspeedLocal = localAirspeed;
	m_localAcc = localAcc;
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

const Vec3 FlightModel::windAxisToBody(const Vec3& force, const double& alpha, const double& beta) const
{
	double sin_b = sin(beta);
	double cos_b = cos(beta);
	double sin_a = sin(-alpha);
	double cos_a = cos(-alpha);

	double res_x = cos_b * cos_a * force.x + sin_b * force.z - cos_b * sin_a * force.y;
	double res_z = -cos_a * sin_b * force.x + cos_b * force.z + sin_a * sin_b * force.y;
	double res_y = sin_a * force.x + cos_a * force.y;

	return Vec3(res_x, res_y, res_z);
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

void FlightModel::addForceDir(const Vec3& force, const Vec3& dir)
{
	//Add the force to the overall force
	m_force += force;

	//Calculate the "moment" (actually torque)
	Vec3 moment = cross(dir, force);

	//Add it on
	m_moment += moment;
}


void FlightModel::L_stab()
{
	//m_moment.x
	m_moment.x += m_q * (Clb(0.0)*m_beta*m_airframe.getVertStabDamage() + Cla(m_mach)*Cla_a(std::abs(m_aoa))*aileron() * m_airframe.getAileronDamage() + Cldr(0.0)*rudder() * m_airframe.getRudderDamage()) + m_p * (Clp(0.0)*m_omega.x + Clr(0.0)*m_omega.y);

}

void FlightModel::M_stab()
{
	//m_moment.z
	double horizDamage = m_airframe.getHoriStabDamage();
	double wingDamage = (m_airframe.getLWingDamage() + m_airframe.getRWingDamage())/2.0;
	m_moment.z += m_k * m_chord * (Cmalpha(m_mach) * m_aoa * wingDamage * 1.5 + Cmde(m_mach)*Cmde_a(std::abs(m_aoa))*elevator()*m_airframe.getElevatorDamage() + CmM(m_mach)*0.2) + 0.25 * m_scalarV * m_totalWingArea * m_chord * m_chord * horizDamage * (Cmq(m_mach)*m_omega.z + Cmadot(m_mach)*m_aoaDot);

}

void FlightModel::N_stab()
{
	//m_moment.y
	double vertDamage = m_airframe.getVertStabDamage();
	m_moment.y += m_q * m_integrityRud * (-Cnb(m_beta) * vertDamage * 0.8 + Cndr(0.0) * rudder() * m_airframe.getRudderDamage()) + m_p * (Cnr(0.0) * m_omega.y * vertDamage);//(Cnr(0.0)*m_omega.y); //This needs to be fixed, constants like 0.8 are temporary!!!
	
	printf("beta: %lf, Cnb: %lf\n", toDegrees(m_beta), -Cnb(m_beta));

	//printf("beta: %lf, betaDot: %lf\n", m_q * (-Cnb(m_beta) * 0.8), m_p * (Cnr(0.0) * m_betaDot));
	//printf("m_moment.y: %lf, m_beta: %lf, Cnb(mach)*m_beta: %lf, Cndr*rudder: %lf, Cnr*m_omega.y: %lf\n",
		//m_moment.y, m_beta, Cnb(m_mach)*m_beta, Cndr(0.0)*rudder(), Cnr(0.0)*m_omega.y);
}

double FlightModel::elevator()
{
	return m_airframe.elevatorAngle();
}

double FlightModel::aileron()
{
	return m_airframe.aileronAngle();
}

double FlightModel::rudder()
{
	return m_airframe.rudderAngle();
}

double FlightModel::thrust()
{
	return m_controls.throttleNorm() * m_thrust;
}

void FlightModel::lift()
{
	//printf("vL: %lf, v: %lf, vR: %lf\n", m_liftVecRW.x, m_liftVecRW.y, m_liftVecRW.z);
	//printf("CL: %lf\n", CLalpha(m_aoa, true));
	addForce(Vec3(0.0, m_k*(CLde(m_mach)*elevator()), 0.0), getCOM());
	
	m_LDwindAxesLW.z = 0;
	m_LDwindAxesRW.z = 0;

	double flapsDamage = m_airframe.getFlapDamage();

	m_LDwindAxesRW.y = m_kR / 2 * (m_airframe.getRWingDamage() * CLalpha(m_aoaRW) + dCLslat(m_aoaRW) * m_airframe.getSlatRPosition() + dCLflap(m_aoaRW) * m_airframe.getFlapsPosition() * flapsDamage + dCLspoiler(0.0) * m_airframe.getSpoilerPosition());
	m_LDwindAxesLW.y = m_kL / 2 * (m_airframe.getLWingDamage() * CLalpha(m_aoaLW) + dCLslat(m_aoaLW) * m_airframe.getSlatLPosition() + dCLflap(m_aoaLW) * m_airframe.getFlapsPosition() * flapsDamage + dCLspoiler(0.0) * m_airframe.getSpoilerPosition());


	//printf("%lf, %lf\n", m_LDwindAxesRW.y / (m_kR / 2 * (CLalpha(m_aoa) + dCLslat(m_aoa) * m_airframe.getSlatRPosition() + dCLflap(m_aoa) * m_airframe.getFlapsPosition())), m_LDwindAxesLW.y / (m_kR / 2 * (CLalpha(m_aoa) + dCLslat(m_aoa) * m_airframe.getSlatRPosition() + dCLflap(m_aoa) * m_airframe.getFlapsPosition())));

	//addForceDir(m_kR / 2 * (CLalpha(m_aoaRW) + dCLslat(m_aoaRW) * m_airframe.getSlatRPosition() + dCLflap(m_aoaRW) * m_airframe.getFlapsPosition()) * m_liftVecRW, m_rRW);
	//addForceDir(m_kL / 2 * (CLalpha(m_aoaLW) + dCLslat(m_aoaLW) * m_airframe.getSlatLPosition() + dCLflap(m_aoaLW) * m_airframe.getFlapsPosition()) * m_liftVecLW, m_rLW);
	
	//printf("CLde: %lf\n", CLde(m_mach) * elevator());
}

void FlightModel::drag()
{
	//printf( "Mach %lf, drag %lf\n", m_mach, CDmach( m_mach ) );
	double CD = dCDspeedBrake( 0.0 ) * m_airframe.getSpeedBrakePosition() + CDbeta( m_beta ) + CDde( 0.0 ) * abs( elevator() ) + CDmach( m_mach ) + CDi( 0.0 ) * pow( CLalpha( m_aoa ), 2.0 ) + m_airframe.getGearPosition() * CDgear;
	
	m_CDwindAxesComp.y = 0;
	m_CDwindAxesComp.z = 0;
	m_CDwindAxesComp.x = -m_k * CD;

	m_LDwindAxesLW.x = -m_k / 2 * (CDalpha(m_aoaLW) * 0.7 + CDflap(m_aoaLW) * m_airframe.getFlapsPosition() + CDslat(m_aoaLW) * m_airframe.getSlatLPosition() + dCDspoiler(0.0) * m_airframe.getSpoilerPosition());
	m_LDwindAxesRW.x = -m_k / 2 * (CDalpha(m_aoaRW) * 0.7 + CDflap(m_aoaRW) * m_airframe.getFlapsPosition() + CDslat(m_aoaRW) * m_airframe.getSlatRPosition() + dCDspoiler(0.0) * m_airframe.getSpoilerPosition());
}

void FlightModel::sideForce()
{
	addForce(Vec3(0.0, 0.0, m_k*CYb(0.0)*m_beta), getCOM());
}

void FlightModel::thrustForce()
{
	m_engine.setAirspeed(m_scalarV);
	//addForce(Vec3(thrust(), 0.0, 0.0), getCOM());
	addForce(Vec3(m_engine.getThrust(), 0.0, 0.0), getCOM());
}

double FlightModel::yawRate()
{
	return m_omega.y;
}

double FlightModel::mach()
{
	return m_mach;
}

double FlightModel::toDegrees(double angle)
{
	return 360 * angle / (2 * PI);
}

double FlightModel::toRad(double angle)
{
	return (2 * PI) * angle / 360;
}

int FlightModel::getRandomNumber(int min, int max)
{
	static constexpr double fraction{ 1.0 / (RAND_MAX + 1.0) };
	
	return min + static_cast<int>((max - min + 1) * (std::rand() * fraction));
}

double FlightModel::getCockpitShake()
{
	return m_cockpitShake;
}

void FlightModel::setCockpitShakeModifier( double mod )
{
	m_cockpitShakeModifier = mod;
}

}//end namespace

#endif