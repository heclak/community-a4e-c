#include <vector>
#include <stdio.h>
#include "FlightModel.h"

//Tables
#define d_CLalpha {-0.62,-0.5947392075708984,-0.5675771299341925,-0.5385885510528816,-0.5078482548899637,-0.4754310254084371,-0.44141164657130005,-0.4058649023415509,-0.3688655766821883,-0.33048845355621,-0.2908083169266149,-0.24989995075640117,-0.2078381390085669,-0.16469766564611082,-0.12055331463203112,-0.07547986992932598,-0.0295521176899364,0.017023231771716982,0.06355159013081219,0.10932102451170776,0.1544885852894077,0.19966954826918962,0.24514258050647947,0.2906720672349855,0.33603435270669924,0.3811085250390099,0.4257924504585681,0.47011694646496943,0.5142275016728124,0.5582733638977925,0.6024030414111063,0.6465792358912462,0.6903348396852592,0.7331808949364504,0.7753905716028519,0.8179337168579023,0.8601253087681116,0.8943746002196665,0.9216917068670982,0.9393219829087708,0.945816743157252,0.9414754437225115,0.9292445951179886,0.9160754932794964,0.9046258530725731,0.8959360873027399,0.8892390777567745,0.8834775676024099,0.8778158519417267,0.8714772750583659,0.8636851817751569,0.8536629169149292,0.8406338253005127,0.8238212517547367,0.8024485411004316,0.7757390381604263,0.7429160877575512,0.7032030347146356,0.6558232238545084,0.6 }
#define d_CDalpha {1.5,0.949092356575,0.555425325175,0.292578924413,0.134133172902,0.0536680892537,0.0247636920822,0.021,0.0247636920822,0.0536680892537,0.134133172902,0.292578924413,0.555425325175,0.949092356575,1.5 }
#define d_CDmach {0.0,0.0,0.0,0.0,0.0,0.000940909090909,0.0197590909091,0.0216283084005,0.0199712313003,0.0183141542002,0.0166570771001,0.015 }
#define d_CDbeta {1.23,0.978284308116,0.731177185308,0.501113771365,0.300529206075,0.141858629225,0.0375371806043,0.0,0.0375371806043,0.141858629225,0.300529206075,0.501113771365,0.731177185308,0.978284308116,1.23 }

//Set everything to zero.
//Vectors already constructor to zero vector.
Skyhawk::FlightModel::FlightModel(Input& controls, Airframe& airframe) :
	m_controls(controls),
	m_airframe(airframe),
	m_density(0.0),
	m_speedOfSound(0.0),
	m_aoa(0.0),
	m_beta(0.0),
	m_scalarVSquared(0.0),
	m_scalarV(0.0),
	m_aileronLeft(0.0),
	m_aileronRight(0.0),
	m_elevator(0.0),
	m_rudder(0.0),
	m_q(0.0),
	m_p(0.0),
	m_k(0.0),
	m_mach(0.0),
	m_aoaDot(0.0),
	m_aoaPrevious(0.0),

	//Setup tables
	CLalpha(d_CLalpha, -0.2698, 0.6),
	dCLflap({0.669}, c_flapUp, c_flapDown),
	CLde({0.2}, c_elevatorDown, c_elevatorUp),

	CDalpha(d_CDalpha,-1.57, 1.57),
	CDi({0.09}, 0, 1),
	CDmach(d_CDmach,0.0, 1.8),
	CDflap({0.153}, c_flapUp, c_flapDown),
	CDspeedBrake({0.021}, 0.0, 1.0),
	CDbeta(d_CDbeta,-1.57, 1.57),
	CDde({0.12}, c_elevatorDown, c_elevatorUp),

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

void Skyhawk::FlightModel::coldInit()
{

}

void Skyhawk::FlightModel::hotInit()
{

}

void Skyhawk::FlightModel::airbornInit()
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

	m_scalarV = sqrt(m_scalarVSquared);
	m_mach = m_scalarV / m_speedOfSound;

	m_k = m_scalarVSquared * m_density * 0.5 * m_totalWingArea;
	m_q = m_k * m_totalWingSpan;
	m_p = sqrt(m_scalarVSquared) * m_density * 0.25 * m_totalWingArea * m_totalWingSpan * m_totalWingSpan;

	calculateAero();

	m_aoaPrevious = m_aoa;
}