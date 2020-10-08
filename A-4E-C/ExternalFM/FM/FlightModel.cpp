#include <vector>
#include <stdio.h>
#include <algorithm>
#include <fstream>
#include "FlightModel.h"
#include "Globals.h"
#include "Data.h"

#undef min

//Set everything to zero.
//Vectors already constructor to zero vector.
Skyhawk::FlightModel::FlightModel
(
	Input& controls,
	Airframe& airframe,
	Engine& engine,
	Interface& inter
):
	m_controls(controls),
	m_airframe(airframe),
	m_engine(engine),
	m_interface( inter ),
	m_density(1.0),
	m_speedOfSound(340.0),
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
	m_kL(0.0),
	m_kR(0.0),
	m_mach(0.0),
	m_aoaDot(0.0),
	m_aoaPrevious(0.0),
	m_scalarAirspeedLW(0.0),
	m_scalarAirspeedRW(0.0),
	m_rLW(0, 0, -3.0),	//directional vbector from CG to CP of aerodynamic element (LW) 2
	m_rRW(0, 0, 3.0),	//directional vbector from CG to CP of aerodynamic element (RW)
	m_aoaLW(0.0),
	m_aoaRW(0.0),
	m_LslatVel(0.0),
	m_RslatVel(0.0),
	m_integrityLW(1.0),
	m_integrityRW(1.0),
	m_integrityRud(1.0),

	//Setup tables
	CLalpha(d_CLalpha, -0.26981317, 1.57079633),
	dCLflap(d_CLflap, -0.26981317, 1.57079633),
	dCLslat(d_CLslat, -0.26981317, 1.57079633),
	dCLspoiler({-0.35}, 0, 1),
	CLde(d_CLde, 0.157982, 1.000377),
	CDalpha(d_CDalpha, -1.57079633, 1.57079633),
	CDi({0.09}, 0, 1),
	CDmach(d_CDmach,0.0, 1.8),
	CDflap(d_CDflap, -1.57079633, 1.57079633),
	CDslat(d_CDslat, -1.57079633, 1.57079633),
	dCDspoiler({ 0.05 }, 0, 1),
	dCDspeedBrake({0.10}, 0.0, 1.0),
	CDbeta(d_CDbeta,-1.57, 1.57),
	CDde({0.12}, c_elevatorDown, c_elevatorUp),

	CYb({-1}, 0.0, 1.0),

	Clb({ -0.01 }, 0.0, 1.0),
	Clp({ -0.0 }, 0.0, 1.0), //-0.3
	Clr({ 0.0 }, 0.0, 1.0), //0.15
	//Cla({ 0.220, 0.037 }, 0.0, 2.0), //110
	Cla({ 0.220 }, 0.0, 1.0),
	Cldr({ 0.01 }, 0.0, 1.0),
	Cla_a({1.0, 0.3}, 0.436332313, 0.698131701),

	Cmalpha(d_Cmalpha, 0.1, 1.0019),
	Cmde(d_Cmde, 0, 1.00216078), //x = mach
	Cmq(d_Cmq, 0.13176098, 1.0006616),
	Cmadot(d_Cmadot, 0.1618916, 0.99790229),
	CmM(d_CmM, 0.06761245, 1.0),
	Cmde_a({1.2, 0.4}, 0.34906585, 1.04719755),
	
	//Cnb({0.36}, 0.0, 1.0), //0.12
	Cnb(d_Cnb, -0.785398163, 0.785398163),
	Cnr({-0.3}, 0.0, 1.0), //-0.15
	Cndr({-0.1}, 0.0, 1.0),
	Cnda({0.2}, 0.0, 1.0),

	//slats
	slatCL({-0.15, 0.15}, 0.261799, 0.436332313),

	rnd_aoa(d_rnd_aoa, -0.34906585, 0.41887902)

{

}

Skyhawk::FlightModel::~FlightModel()
{

}

void Skyhawk::FlightModel::zeroInit()
{
	m_moment = Vec3();
	m_force = Vec3();
}

void Skyhawk::FlightModel::coldInit()
{
	zeroInit();
}

void Skyhawk::FlightModel::hotInit()
{
	zeroInit();
}

void Skyhawk::FlightModel::airbornInit()
{
	zeroInit();
}

void Skyhawk::FlightModel::calculateLocalPhysicsParams()
{
	double m_wingDihedral = 0.046774824; // 2.68 deg

	
	m_nRW = Vec3(0.0, cos(m_wingDihedral), -sin(m_wingDihedral));
	m_nLW = Vec3(0.0, cos(m_wingDihedral), sin(m_wingDihedral));

	m_airspeedLW = m_airspeedLocal + cross(m_omega, m_rLW);
	m_airspeedRW = m_airspeedLocal + cross(m_omega, m_rRW);
	
	m_dragVecLW = -normalize(m_airspeedLW);
	m_dragVecRW = -normalize(m_airspeedRW);

	Vec3 tmpNormalLW{ normalize(cross(m_dragVecLW, m_nLW)) };
	Vec3 tmpNormalRW{ normalize(cross(m_dragVecRW, m_nRW)) };
	m_liftVecLW = normalize(cross(tmpNormalLW, m_dragVecLW));
	m_liftVecRW = normalize(cross(tmpNormalRW, m_dragVecRW));

	m_scalarAirspeedLW = sqrt(m_airspeedLW.x * m_airspeedLW.x + m_airspeedLW.y * m_airspeedLW.y + m_airspeedLW.z * m_airspeedLW.z);
	m_scalarAirspeedRW = sqrt(m_airspeedRW.x * m_airspeedRW.x + m_airspeedRW.y * m_airspeedRW.y + m_airspeedRW.z * m_airspeedRW.z);
	m_aoaLW = atan2(cross(m_nLW, m_liftVecLW) * tmpNormalLW, m_liftVecLW * m_nLW);
	m_aoaRW = atan2(cross(m_nRW, m_liftVecRW) * tmpNormalRW, m_liftVecRW * m_nRW);

	//random-test
	/*m_aoaLW = m_aoaLW + rnd_aoa(m_aoaLW) * getRandomNumber(-2, 2)/8.0;
	m_aoaRW = m_aoaRW + rnd_aoa(m_aoaRW) * getRandomNumber(-2, 2)/8.0;*/

}


//This calculates only aerodynamic forces and moments.
void Skyhawk::FlightModel::calculateAero()
{

	lift();
	drag();
	calculateElements();
	sideForce();
	thrustForce();

	L_stab();
	M_stab();
	N_stab();
	//printf("moment.z: %lf, beta: %lf, m_q: %lf, m_p: %lf, omegax: %lf, omegay: %lf, Cla(mach): %lf\n", 
		//m_moment.z, m_beta, m_q, m_p, m_omega.x, m_omega.y, Cla(m_mach));

	calculateShake();
}

void Skyhawk::FlightModel::calculateElements()
{
	Vec3 LiftLW =  windAxisToBody(m_LDwindAxesLW, m_aoaLW, m_beta);
	//printf("LEFT X: %lf Y: %lf Z: %lf\n", m_LDwindAxesLW.x, m_LDwindAxesLW.y, m_LDwindAxesLW.z);
	Vec3 LiftRW =  windAxisToBody(m_LDwindAxesRW, m_aoaRW, m_beta);
	//printf("RIGHT X: %lf Y: %lf Z: %lf\n", m_LDwindAxesRW.x, m_LDwindAxesRW.y, m_LDwindAxesRW.z);
	Vec3 dragElem = windAxisToBody(m_CDwindAxesComp, m_aoa, m_beta);
	
	//printf("lw: %lf, rw: %lf\n", m_aoaLW, m_aoaRW);
	//printf("lw: %lf, %lf, %lf rw: %lf, %lf, %lf\n", LiftLW.x, LiftLW.y, LiftLW.z, LiftRW.x, LiftRW.y, LiftRW.z);

	//if (m_localAcc.y/9.81 >= 10)
	//{
	//	printf("acc: %lf, force: %lf", m_localAcc.y / 9.81, LiftLW.y); // 320 000
	//}

	addForceDir(LiftLW, m_rLW);
	addForceDir(LiftRW, m_rRW);
	addForce(dragElem, getCOM());
}

//This calculates all forces and moments. Including landing gear.
void Skyhawk::FlightModel::calculateForcesAndMoments(double dt)
{
	//Reset at the start of the frame.
	m_force = Vec3();
	m_moment = Vec3();
	
	calculateLocalPhysicsParams();

	m_aoaDot = (m_aoa - m_aoaPrevious) / dt;
	m_betaDot = (m_beta - m_betaPrevious) / dt;

	//Get airspeed and scalar speed squared.
	m_airspeed = m_worldVelocity - m_wind;
	m_scalarVSquared = m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z;

	m_scalarV = sqrt(m_scalarVSquared);
	m_mach = m_scalarV / m_speedOfSound;

	m_k = m_scalarVSquared * m_density * 0.5 * m_totalWingArea;
	m_kL = pow(m_scalarAirspeedLW, 2) * m_density * 0.5 * m_totalWingArea;
	m_kR = pow(m_scalarAirspeedRW, 2) * m_density * 0.5 * m_totalWingArea;
	m_q = m_k * m_totalWingSpan;
	m_p = m_scalarV * m_density * 0.25 * m_totalWingArea * m_totalWingSpan * m_totalWingSpan;

	//Slats logic (legacy - dance)
	//double slatPositionL = (m_aoaLW - 0.2268)/0.069813; //full actuation ~17 deg, onset ~13 deg aoa
	//double slatPositionR = (m_aoaRW - 0.2268)/0.069813; //full actuation ~17 deg, onset ~13 deg aoa
	//slatPositionL = std::min(slatPositionL, 1.0);
	//slatPositionL = std::max(slatPositionL, 0.0);
	//slatPositionR = std::min(slatPositionR, 1.0);
	//slatPositionR = std::max(slatPositionR, 0.0);


	////printf("slats: %lf\n", slatPosition);
	//m_controls.slatL() = slatPositionL;
	//m_controls.slatR() = slatPositionR;
	slats(dt);

	calculateAero();
	m_aoaPrevious = m_aoa;
	m_betaPrevious = m_beta;
}

void Skyhawk::FlightModel::slats(double& dt)
{
	double forceL = (m_kL / m_totalWingArea) * m_slatArea * slatCL(m_aoaLW);
	double forceR = (m_kR / m_totalWingArea) * m_slatArea * slatCL(m_aoaRW);

	Vec3 accDirection = (0.94, 0.34, 0.0);
	double accAircraft = accDirection * m_localAcc;

	double x_L = m_airframe.getSlatLPosition();
	double x_R = m_airframe.getSlatRPosition();

	double a_L = accAircraft + (forceL - m_slatDamping * m_LslatVel - m_slatSpring * (x_L-1.5) ) / m_slatMass;
	double a_R = accAircraft + (forceR - m_slatDamping * m_RslatVel - m_slatSpring * (x_R-1.5) ) / m_slatMass;

	m_LslatVel += a_L * dt;
	m_RslatVel += a_R * dt;

	//if ( x_L < 0.00 ) { m_LslatVel = -m_LslatVel / 100); }
	//if ( x_R < 0.00 ) { m_RslatVel = -m_RslatVel / 100); }
	//if ( x_L > 1.00 ) { m_LslatVel = -abs(m_LslatVel / 100); }
	//if ( x_R > 1.00 ) { m_RslatVel = -abs(m_RslatVel / 100); }

	x_L += m_LslatVel * dt;
	x_R += m_RslatVel * dt;
	
	if ( x_L < 0.0 )
	{
		x_L = 0.0;
		m_LslatVel = -m_LslatVel*0.3;
	}
	else if ( x_L > 1.0 )
	{
		x_L = 1.0;
		m_LslatVel = -m_LslatVel*0.3;
	}

	if ( x_R < 0.0 )
	{
		x_R = 0.0;
		m_RslatVel = -m_RslatVel*0.3;
	}
	else if ( x_R > 1.0 )
	{
		x_R = 1.0;
		m_RslatVel = -m_RslatVel*0.3;
	}

	//x_L = std::min(x_L, 1.0);
	//x_L = std::max(x_L, 0.0);
	//x_R = std::min(x_R, 1.0);
	//x_R = std::max(x_R, 0.0);


	m_airframe.setSlatLPosition( x_L );
	m_airframe.setSlatRPosition( x_R );

	//printf("acc: %lf, f: %lf\n", accAircraft, slatCL(m_aoaLW));
	//printf("force: %lf, x: %lf, a: %lf, vel: %lf, dt: %lf\n", forceL, x_L, a_L, m_LslatVel, dt);
}

void Skyhawk::FlightModel::structuralIntegrity(Vec3& liftLW, Vec3& liftRW)
{

}

void Skyhawk::FlightModel::calculateShake()
{
	double shakeAmplitude{ 0.0 };
	double buffetAmplitude = 0.3 * m_cockpitShakeModifier;
	double x{ 0.0 };

	// 19 - 28
	double aoa = std::abs(m_aoa);
	if (aoa >= 0.332 && m_scalarV > 30.0)
	{
		x = std::min(aoa - 0.332, 0.157)/0.157;
		shakeAmplitude += x * buffetAmplitude;
	}

	m_cockpitShake = shakeAmplitude;
}

void Skyhawk::FlightModel::csvData(std::vector<double>& data)
{
	

	
}