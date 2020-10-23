#include <vector>
#include <stdio.h>
#include <algorithm>
#include <fstream>
#include "FlightModel.h"
#include "Globals.h"
#include "Data.h"
#include "Maths.h"

#undef min

//Set everything to zero.
//Vectors already constructor to zero vector.
Skyhawk::FlightModel::FlightModel
(
	AircraftState& state,
	Input& controls,
	Airframe& airframe,
	Engine2& engine,
	Interface& inter
):
	m_state(state),
	m_controls(controls),
	m_airframe(airframe),
	m_engine(engine),
	m_interface( inter ),
	m_scalarVSquared(0.0),
	m_scalarV(0.0),
	m_q(0.0),
	m_p(0.0),
	m_k(0.0),
	m_kL(0.0),
	m_kR(0.0),
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
	m_cockpitShake(0.0),

	m_elementLW(m_state, CLalpha, CDalpha, Vec3(0, 0, -3.0), m_wingSurfaceNormalL, 0, m_totalWingArea/2),
	m_elementRW(m_state, CLalpha, CDalpha, Vec3(0, 0, 3.0), m_wingSurfaceNormalR, 0, m_totalWingArea/2),
	m_elementLSlat(m_state, dCLslat, CDslat, Vec3(0, 0, -3.0), m_wingSurfaceNormalL, 0, m_totalWingArea / 2),
	m_elementRSlat(m_state, dCLslat, CDslat, Vec3(0, 0, 3.0), m_wingSurfaceNormalR, 0, m_totalWingArea / 2),
	m_elementLFlap(m_state, dCLflap, CDflap, Vec3(0, 0, -3.0), m_wingSurfaceNormalL, 0, m_totalWingArea / 2),
	m_elementRFlap(m_state, dCLflap, CDflap, Vec3(0, 0, 3.0), m_wingSurfaceNormalR, 0, m_totalWingArea / 2),
	m_elementLSpoiler(m_state, dCLspoiler, dCDspoiler, Vec3(0, 0, -3.0), m_wingSurfaceNormalL, 0, m_totalWingArea / 2),
	m_elementRSpoiler(m_state, dCLspoiler, dCDspoiler, Vec3(0, 0, 3.0), m_wingSurfaceNormalR, 0, m_totalWingArea / 2),

	//Setup tables
	CLalpha(d_CLalpha, -0.26981317, 1.57079633),
	dCLflap(d_CLflap, -0.26981317, 1.57079633),
	dCLslat(d_CLslat, -0.26981317, 1.57079633),
	dCLspoiler({-0.35}, 0, 1),
	CLde(d_CLde, 0.157982, 1.000377),
	CDalpha(d_CDalpha, -1.57079633, 1.57079633),
	CDi({0.015}, 0, 1),
	CDmach(d_CDmach,0.0, 1.8),
	CDflap(d_CDflap, -1.57079633, 1.57079633),
	CDslat(d_CDslat, -1.57079633, 1.57079633),
	dCDspoiler({ 0.05 }, 0, 1),
	dCDspeedBrake({0.08}, 0.0, 1.0),
	CDbeta(d_CDbeta,-1.57, 1.57),
	CDde({0.005}, c_elevatorDown, c_elevatorUp),

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
	Cnr({-0.08}, 0.0, 1.0), //-0.15
	Cndr({-0.1}, 0.0, 1.0),
	Cnda({0.2}, 0.0, 1.0),

	//slats
	slatCL({-0.15, 0.15}, 0.261799, 0.436332313),

	rnd_aoa(d_rnd_aoa, -0.34906585, 0.41887902)

{
	/*m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -0.1067866894), m_wingSurfaceNormalL, 0, 1.9737953980));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -0.5399751247), m_wingSurfaceNormalL, 0, 1.8047195280));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -0.9731336040), m_wingSurfaceNormalL, 0, 1.6356436570));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -1.4062517670), m_wingSurfaceNormalL, 0, 1.4665677860));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -1.8393138510), m_wingSurfaceNormalL, 0, 1.2974919160));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -2.2722946510), m_wingSurfaceNormalL, 0, 1.1284160450));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -2.7051511890), m_wingSurfaceNormalL, 0, 0.9593401748));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -3.1378037070), m_wingSurfaceNormalL, 0, 0.7902643043));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -3.5700856160), m_wingSurfaceNormalL, 0, 0.6211884337));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, -4.0014189490), m_wingSurfaceNormalL, 0, 0.3500000000));

	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 0.1067866894), m_wingSurfaceNormalR, 0, 1.9737953980));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 0.5399751247), m_wingSurfaceNormalR, 0, 1.8047195280));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 0.9731336040), m_wingSurfaceNormalR, 0, 1.6356436570));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 1.4062517670), m_wingSurfaceNormalR, 0, 1.4665677860));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 1.8393138510), m_wingSurfaceNormalR, 0, 1.2974919160));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 2.2722946510), m_wingSurfaceNormalR, 0, 1.1284160450));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 2.7051511890), m_wingSurfaceNormalR, 0, 0.9593401748));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 3.1378037070), m_wingSurfaceNormalR, 0, 0.7902643043));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 3.5700856160), m_wingSurfaceNormalR, 0, 0.6211884337));
	m_elements.push_back(AeroElement(m_state, CLalpha, CDalpha, Vec3(0.0, 0.0, 4.0014189490), m_wingSurfaceNormalR, 0, 0.3500000000));*/

}

Skyhawk::FlightModel::~FlightModel()
{

}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Skyhawk::FlightModel::zeroInit()
{
	m_q = 0.0;
	m_p = 0.0;
	m_k = 0.0;
	m_kL = 0.0;
	m_kR = 0.0;

	m_scalarVSquared = 0.0;
	m_scalarV = 0.0;
	m_aoaPrevious = 0.0;
	m_betaPrevious = 0.0;
	m_betaDot = 0.0;

	m_scalarAirspeedLW = 0.0;
	m_scalarAirspeedRW = 0.0;

	m_aoaLW = 0.0;
	m_aoaRW = 0.0;

	m_LslatVel = 0.0;
	m_RslatVel = 0.0;

	m_moment = Vec3();
	m_force = Vec3();

	m_com = Vec3();
	m_airspeed = Vec3();

	m_LDwindAxesLW = Vec3();
	m_LDwindAxesRW = Vec3();
	m_CDwindAxesComp = Vec3();

	m_airspeedLW = Vec3();
	m_airspeedRW = Vec3();

	m_liftVecLW = Vec3();
	m_liftVecRW = Vec3();

	m_dragVecLW = Vec3();
	m_dragVecRW = Vec3();

	m_nLW = Vec3();
	m_nRW = Vec3();

	m_elementLW.zeroInit();
	m_elementRW.zeroInit();
	m_elementLSlat.zeroInit();
	m_elementRSlat.zeroInit();
	m_elementLFlap.zeroInit();
	m_elementRFlap.zeroInit();
	m_elementLSpoiler.zeroInit();
	m_elementRSpoiler.zeroInit();

}

void Skyhawk::FlightModel::coldInit()
{
	zeroInit();
}

void Skyhawk::FlightModel::hotInit()
{
	zeroInit();
}

void Skyhawk::FlightModel::airborneInit()
{
	zeroInit();
}

void Skyhawk::FlightModel::calculateLocalPhysicsParams()
{
	
	m_nRW = Vec3(0.0, cos(m_wingDihedral), -sin(m_wingDihedral));
	m_nLW = Vec3(0.0, cos(m_wingDihedral), sin(m_wingDihedral));

	m_airspeedLW = m_state.getLocalAirspeed() + cross(m_state.getOmega(), m_rLW);
	m_airspeedRW = m_state.getLocalAirspeed() + cross( m_state.getOmega(), m_rRW);
	
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

void Skyhawk::FlightModel::runThreads(int n)
{
	for (int i = n; i < 10 + n; i++)
	{
		m_elements[i].calculateElementPhysics();
	}
}

void Skyhawk::FlightModel::calculateElements()
{

	Vec3 LiftLW =  windAxisToBody(m_LDwindAxesLW, m_aoaLW, m_state.getBeta());
	//printf("old: %lf, %lf, %lf\n", LiftLW.x, LiftLW.y, LiftLW.z);
	
	Vec3 LiftRW =  windAxisToBody(m_LDwindAxesRW, m_aoaRW, m_state.getBeta() );
	//printf("RIGHT X: %lf Y: %lf Z: %lf\n", m_LDwindAxesRW.x, m_LDwindAxesRW.y, m_LDwindAxesRW.z);
	Vec3 dragElem = windAxisToBody(m_CDwindAxesComp, m_state.getAOA(), m_state.getBeta() );
	

	m_elementLSlat.setLDFactor(m_airframe.getSlatLPosition(), m_airframe.getSlatLPosition());
	m_elementRSlat.setLDFactor(m_airframe.getSlatRPosition(), m_airframe.getSlatRPosition());
	m_elementLFlap.setLDFactor(m_airframe.getFlapsPosition() * m_airframe.getFlapDamage(), m_airframe.getFlapsPosition());
	m_elementRFlap.setLDFactor(m_airframe.getFlapsPosition() * m_airframe.getFlapDamage(), m_airframe.getFlapsPosition());
	m_elementLSpoiler.setLDFactor(m_airframe.getSpoilerPosition() * m_airframe.getSpoilerDamage(), m_airframe.getSpoilerPosition());
	m_elementRSpoiler.setLDFactor(m_airframe.getSpoilerPosition() * m_airframe.getSpoilerDamage(), m_airframe.getSpoilerPosition());

	m_elementLW.setLDFactor(m_airframe.getLWingDamage(), 0.7);
	m_elementRW.setLDFactor(m_airframe.getRWingDamage(), 0.7);

	m_elementLSlat.calculateElementPhysics();
	m_elementRSlat.calculateElementPhysics();
	m_elementLFlap.calculateElementPhysics();
	m_elementRFlap.calculateElementPhysics();
	m_elementLSpoiler.calculateElementPhysics();
	m_elementRSpoiler.calculateElementPhysics();
	m_elementLW.calculateElementPhysics();
	m_elementRW.calculateElementPhysics();

	//m_elementRW.calculateElementPhysics();

	
	Vec3 oldLiftcombined = LiftLW + LiftRW;
	Vec3 newLift = m_elementLSlat.getForce()
							+ m_elementRSlat.getForce()
							+ m_elementLFlap.getForce()
							+ m_elementRFlap.getForce()
							+ m_elementLSpoiler.getForce()
							+ m_elementRSpoiler.getForce()
							+ m_elementLW.getForce()
							+ m_elementRW.getForce();

	Vec3 liftDelta = newLift - oldLiftcombined;
	double liftDeltaMag = liftDelta * liftDelta;

	if (liftDeltaMag > 0.01)
	{
		LOG("oldLift: %lf, %lf, %lf  newLift: %lf, %lf, %lf, mag: %lf\n", oldLiftcombined.x, oldLiftcombined.y, oldLiftcombined.z, newLift.x, newLift.y, newLift.z, liftDeltaMag);
	}


	//addForceDir(, m_rLW);
	//addForceDir(LiftRW, m_rRW);

	addForceElement(m_elementLSlat);
	addForceElement(m_elementRSlat);
	addForceElement(m_elementLFlap);
	addForceElement(m_elementRFlap);
	addForceElement(m_elementLSpoiler);
	addForceElement(m_elementRSpoiler);
	addForceElement(m_elementLW);
	addForceElement(m_elementRW);

	addForce(dragElem);
}

//This calculates all forces and moments. Including landing gear.
void Skyhawk::FlightModel::calculateForcesAndMoments(double dt)
{
	//Reset at the start of the frame.
	m_force = Vec3();
	m_moment = Vec3();
	
	calculateLocalPhysicsParams();

	double dAOA = m_state.getAOA() - m_aoaPrevious;
	double dAOAOpposite;
	
	if ( dAOA >= 0.0 )
	{
		dAOAOpposite = 2.0 * PI - dAOA;
	}
	else
	{
		dAOAOpposite = - 2.0 * PI - dAOA;
	}

	if ( fabs( dAOA ) > fabs( dAOAOpposite ) )
	{
		dAOA = dAOAOpposite;
		printf( "Took opposite: %lf\n", dAOA );
	}


	double dBeta = m_state.getBeta() - m_betaPrevious;
	double dBetaOpposite;

	if ( dBeta >= 0.0 )
	{
		dBetaOpposite = 2.0 * PI - dBeta;
	}
	else
	{
		dBetaOpposite = - 2.0 * PI - dBeta;
	}

	if ( fabs( dBeta ) > fabs( dBetaOpposite ) )
	{
		dBeta = dBetaOpposite;
		printf( "Took opposite: %lf\n", dBeta );
	}

	m_aoaDot = dAOA / dt;
	m_betaDot = dBeta / dt;

	//Get airspeed and scalar speed squared.
	m_airspeed = m_state.getWorldVelocity() - m_state.getWorldWindVelocity();

	m_scalarVSquared = m_airspeed.x * m_airspeed.x + m_airspeed.y * m_airspeed.y + m_airspeed.z * m_airspeed.z;

	m_scalarV = sqrt(m_scalarVSquared);
	m_engine.setAirspeed( m_scalarV );
	m_interface.setAirspeed( m_scalarV );
	m_state.setMach( m_scalarV / m_state.getSpeedOfSound() );

	m_k = m_scalarVSquared * m_state.getAirDensity() * 0.5 * m_totalWingArea;
	m_kL = pow(m_scalarAirspeedLW, 2) * m_state.getAirDensity() * 0.5 * m_totalWingArea;
	m_kR = pow(m_scalarAirspeedRW, 2) * m_state.getAirDensity() * 0.5 * m_totalWingArea;
	m_q = m_k * m_totalWingSpan;
	m_p = m_scalarV * m_state.getAirDensity() * 0.25 * m_totalWingArea * m_totalWingSpan * m_totalWingSpan;

	//printf("orig: %lf ", );

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
	m_aoaPrevious = m_state.getAOA();
	m_betaPrevious = m_state.getAOA();
}

void Skyhawk::FlightModel::slats(double& dt)
{
	double forceL = (m_kL / m_totalWingArea) * m_slatArea * slatCL(m_aoaLW);
	double forceR = (m_kR / m_totalWingArea) * m_slatArea * slatCL(m_aoaRW);

	Vec3 accDirection(-0.94, 0.34, 0.0);
	double accAircraft = normalize(accDirection) * m_state.getLocalAcceleration();

	double x_L = m_airframe.getSlatLPosition();
	double x_R = m_airframe.getSlatRPosition();

	double a_L = accAircraft + (0.09 * forceL - m_slatDamping * m_LslatVel - 0.09 * m_slatSpring * (x_L-1.5) ) / m_slatMass;
	double a_R = accAircraft + (0.09 * forceR - m_slatDamping * m_RslatVel - 0.09 * m_slatSpring * (x_R-1.5) ) / m_slatMass;

	m_LslatVel += a_L * dt;
	m_RslatVel += a_R * dt;

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

	m_airframe.setSlatLPosition( x_L );
	m_airframe.setSlatRPosition( x_R );
}

void Skyhawk::FlightModel::calculateShake()
{
	double shakeAmplitude{ 0.0 };
	double buffetAmplitude = 0.3 * m_cockpitShakeModifier;
	double x{ 0.0 };

	// 19 - 28
	double aoa = std::abs(m_state.getAOA());
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