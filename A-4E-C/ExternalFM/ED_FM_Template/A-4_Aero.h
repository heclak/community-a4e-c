#pragma once
#include "ED_FM_Utility.h"
#include <vector>
///==================================================================================================///
///		A-4E-C Flight Model By Joshua Nelson and Terje Lindviejt
///==================================================================================================///
///		Units are in metric, angles are in initialised in degrees and converted to radians.
///
///
///
///
///
///
///
///
///=================================================================================================///

namespace Skyhawk

{
	///========================================
	///Coefficient Tables
	namespace CL

	{
		std::vector<double> Wing;
		std::vector<double> HorizontalStab;
		std::vector<double> VerticalStab;
		
		std::vector<double> Aileron;
		std::vector<double> Elevator;
	}
	namespace CD

	{
		std::vector<double> Wing;
		std::vector<double> HorizontalStab;
		std::vector<double> VerticalStab;

		std::vector<double> Aileron;
		std::vector<double> Elevator;
	}
	namespace CM

	{
		std::vector<double> StabilityPitch;
		std::vector<double> StabilityYaw;
		std::vector<double> StabilityRoll;
	}
	///========================================


	struct APars //Common Aircraft Parameters

	{
		APars(double q_, double alpha_, double beta_, double mach_, double rollRate_) : 
			q(q_), alpha(alpha_), beta(beta_), mach(mach_), rollRate(rollRate_)

		{

		}
		double q, alpha, beta, mach, rollRate;
	};

	struct Surface //Control Surface Parameters

	{
		Surface(double a, Vec3 pos, double tU = 0.0, double tD = -1) : 
			area(a), position(pos), throwUp(tU), throwDown(tD)

		{
			if (tD < 0) throwDown = tU;
		}
		double throwUp, throwDown, area;
		Vec3 position;
	};

	///==============================================
	///Global Parameters
	Vec3 netForce = Vec3();
	Vec3 netMoment = Vec3();
	///==============================================

	///==============================================
	///Control Surface Definitions
	//Elevator
	const Surface elevatorLeft(2.0, Vec3(), 30.0);
	const Surface elevatorRight(2.0, Vec3(), 30.0);
	//Aileron
	const Surface aileronLeft(2.0, Vec3(), 30.0);
	const Surface aileronRight(2.0, Vec3(), 30.0);
	//Rudder
	const Surface rudder(2.0, Vec3(), 30.0);
	//Flaps
	const Surface flapLeft(2.0, Vec3(), 30.0);
	const Surface flapRight(2.0, Vec3(), 30.0);
	//Wings
	const Surface wingLeft(24.15, Vec3());
	const Surface wingRight(24.15, Vec3());
	//Horizontal Stabiliser
	const Surface horizontalStabLeft(4.260, Vec3());
	const Surface horizontalStabRight(4.260, Vec3());
	//Vertical Stabiliser
	const Surface verticalStab(4.641, Vec3());
	///==============================================

	///Lift and Drag function definitions
	///==============================================
	inline double liftWing(const APars& params);
	inline double liftHorizontalStab(const APars& params);
	inline double liftVerticalStab(const APars& params);
	inline double liftFlaps(const APars& params, const double& flapsPosition); //flapsPosition between 0 and 1
	inline double liftAileron(const APars& params, const double& aileronPosition); //aileronPosition between -1 and 1
	inline double liftElevator(const APars& params, const double& elevatorPosition); //elevatorPosition between -1 and 1
	inline double liftRudder(const APars& params, const double& rudderPosition); //rudderPosition between -1 and 1
	///==============================================
	inline double dragWing(const APars& params);
	inline double dragHorizontalStab(const APars& params);
	inline double dragVerticalStab(const APars& params);
	inline double dragFlaps(const APars& params, const double& flapsPosition); //flapsPosition between 0 and 1
	inline double dragAileron(const APars& params, const double& aileronPosition); //aileronPosition between -1 and 1
	inline double dragElevator(const APars& params, const double& elevatorPosition); //elevatorPosition between -1 and 1
	inline double dragRudder(const APars& params, const double& rudderPosition); //rudderPosition between -1 and 1
	///==============================================

	///==============================================
	///Calculate Forces and Moments
	inline void calculate(const APars& params, 
		const double& flapsPosition, 
		const double& aileronPosition,
		const double& elevatorPosition,
		const double& rudderPosition,
		const Vec3& centerOfGravity);
	///==============================================
}