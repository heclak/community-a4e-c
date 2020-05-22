#include <vector>
#include <stdio.h>
#include "FlightModel.h"

//Tables
#define d_CLalpha {-0.62,-0.405153232597,-0.138670982502,0.154384532168,0.448951093294,0.719966482757,0.94236848244,1.09109487422,1.14108343999,1.06727196162,0.844598220997,0.448 }
#define d_CDalpha {1.5,0.949092356575,0.555425325175,0.292578924413,0.134133172902,0.0536680892537,0.0247636920822,0.021,0.0247636920822,0.0536680892537,0.134133172902,0.292578924413,0.555425325175,0.949092356575,1.5 }
#define d_CDmach {0.0,0.0,0.0,0.0,0.0,0.000940909090909,0.0197590909091,0.0216283084005,0.0199712313003,0.0183141542002,0.0166570771001,0.015 }
#define d_CDbeta {1.23,0.978284308116,0.731177185308,0.501113771365,0.300529206075,0.141858629225,0.0375371806043,0.0,0.0375371806043,0.141858629225,0.300529206075,0.501113771365,0.731177185308,0.978284308116,1.23 }

//Set everything to zero.
//Vectors already constructor to zero vector.
Skyhawk::FlightModel::FlightModel(Input& controls) :
	m_controls(controls),
	m_density(0.0),
	m_speedOfSound(0.0),
	m_aoa(0.0),
	m_beta(0.0),
	m_fuel(0.0),
	m_previousFuel(0.0),
	m_scalarVSquared(0.0),
	m_aileronLeft(0.0),
	m_aileronRight(0.0),
	m_elevator(0.0),
	m_rudder(0.0),
	m_q(0.0),
	m_p(0.0),
	m_mach(0.0),
	m_aoaDot(0.0),
	m_aoaPrevious(0.0),

	//Setup tables
	CLalpha(d_CLalpha,-0.2, 0.6),
	dCLflap({0.669}, m_flapUp, m_flapDown),
	CLde({0.2}, m_elevatorDown, m_elevatorUp),

	CDalpha(d_CDalpha,-1.57, 1.57),
	CDi({0.09}, 0, 1),
	CDmach(d_CDmach,0.0, 1.8),
	CDflap({0.153}, m_flapUp, m_flapDown),
	CDspeedBrake({0.021}, 0.0, 1.0),
	CDbeta(d_CDbeta,-1.57, 1.57),
	CDde({0.12}, m_elevatorDown, m_elevatorUp),

	CYb({-1}, 0.0, 1.0),

	Clb({ -0.01 }, 0.0, 1.0),
	Clp({ -0.4 }, 0.0, 1.0),
	Clr({ 0.15 }, 0.0, 1.0),
	Cla({ 0.110, 0.037 }, 0.0, 2.0),
	Cldr({ 0.01 }, 0.0, 1.0),

	Cmalpha({-0.38}, 0.0, 1.0),
	Cmde({-0.5,-0.2}, 0.0, 2.0), //x = mach
	Cmq({-3.6}, 0.0, 1.0),
	Cmadot({-1.1}, 0.0, 1.0),

	Cnb({0.12}, 0.0, 1.0),
	Cnr({-0.15}, 0.0, 1.0),
	Cndr({-0.1}, 0.0, 1.0),
	Cnda({0.0}, 0.0, 1.0)
{
}

Skyhawk::FlightModel::~FlightModel()
{

}

//This calculates only aerodynamic forces and moments.
void Skyhawk::FlightModel::calculateAero()
{

	lift();
	drag();
	sideForce();
	thrustForce();

	L_stab();
	M_stab();
	N_stab();
	//printf("moment.z: %lf, beta: %lf, m_q: %lf, m_p: %lf, omegax: %lf, omegay: %lf, Cla(mach): %lf\n", 
		//m_moment.z, m_beta, m_q, m_p, m_omega.x, m_omega.y, Cla(m_mach));
}

//This calculates all forces and moments. Including landing gear.
void Skyhawk::FlightModel::calculateForcesAndMoments(double dt)
{
	//Reset at the start of the frame.
	m_force = Vec3();
	m_moment = Vec3();

	m_aoaDot = (m_aoa - m_aoaPrevious) / dt;

	//Get airspeed and scalar speed squared.
	m_airspeed = m_worldVelocity - m_wind;
	m_scalarVSquared = m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z;

	double V = sqrt(m_scalarVSquared);
	m_mach = V / m_speedOfSound;

	m_k = m_scalarVSquared * m_density * 0.5 * m_totalWingArea;
	m_q = m_k * m_totalWingSpan;
	m_p = sqrt(m_scalarVSquared) * m_density * 0.25 * m_totalWingArea * m_totalWingSpan * m_totalWingSpan;

	calculateAero();

	m_aoaPrevious = m_aoa;
}