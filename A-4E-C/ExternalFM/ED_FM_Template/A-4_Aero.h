#pragma once
#include <vector>
#include <iostream>
#include <fstream>
#include "Vec3.h"
///==================================================================================================///
///		A-4E-C Flight Model By Joshua Nelson and Terje Lindviejt
///==================================================================================================///
///		Units are in metric, angles are in radians.
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
		const std::vector<double> Wing = { // min = -4.0, max = 28.0
		-0.235503, -0.17103972, -0.10600414, -0.04096856,  0.02426257,  0.08977953,
		0.15529648,  0.22081344,  0.28523292,  0.34768906,  0.41014928,  0.47265691,
		0.53516453,  0.59767215,  0.65970055,  0.72137852,  0.78265532,  0.84240641,
		0.89301242,  0.92530644,  0.94080849,  0.9381811,   0.91642789,  0.89734787,
		0.88484958,  0.87374059,  0.86385029,  0.85688194,  0.85352097,  0.85259 };
		const std::vector<double> HorizontalStab = {
		-0.235503, -0.17103972, -0.10600414, -0.04096856,  0.02426257,  0.08977953,
		0.15529648,  0.22081344,  0.28523292,  0.34768906,  0.41014928,  0.47265691,
		0.53516453,  0.59767215,  0.65970055,  0.72137852,  0.78265532,  0.84240641,
		0.89301242,  0.92530644,  0.94080849,  0.9381811,   0.91642789,  0.89734787,
		0.88484958,  0.87374059,  0.86385029,  0.85688194,  0.85352097,  0.85259 };
		const std::vector<double> VerticalStab = {
		-0.235503, -0.17103972, -0.10600414, -0.04096856,  0.02426257,  0.08977953,
		0.15529648,  0.22081344,  0.28523292,  0.34768906,  0.41014928,  0.47265691,
		0.53516453,  0.59767215,  0.65970055,  0.72137852,  0.78265532,  0.84240641,
		0.89301242,  0.92530644,  0.94080849,  0.9381811,   0.91642789,  0.89734787,
		0.88484958,  0.87374059,  0.86385029,  0.85688194,  0.85352097,  0.85259 };
		
		const std::vector<double> Aileron = {
		-0.235503, -0.17103972, -0.10600414, -0.04096856,  0.02426257,  0.08977953,
		0.15529648,  0.22081344,  0.28523292,  0.34768906,  0.41014928,  0.47265691,
		0.53516453,  0.59767215,  0.65970055,  0.72137852,  0.78265532,  0.84240641,
		0.89301242,  0.92530644,  0.94080849,  0.9381811,   0.91642789,  0.89734787,
		0.88484958,  0.87374059,  0.86385029,  0.85688194,  0.85352097,  0.85259 };
		const std::vector<double> Elevator = {
		-0.235503, -0.17103972, -0.10600414, -0.04096856,  0.02426257,  0.08977953,
		0.15529648,  0.22081344,  0.28523292,  0.34768906,  0.41014928,  0.47265691,
		0.53516453,  0.59767215,  0.65970055,  0.72137852,  0.78265532,  0.84240641,
		0.89301242,  0.92530644,  0.94080849,  0.9381811,   0.91642789,  0.89734787,
		0.88484958,  0.87374059,  0.86385029,  0.85688194,  0.85352097,  0.85259 };
	}
	namespace CD

	{
		const std::vector<double> Wing = { 0.0432188,
			0.039785703465217113,0.03666546788102608,0.0345089045612839,
			0.032625678647603365,0.031178329323174703,0.03016698711579917,
			0.029383990827010206,0.029086075336303828,0.028886678369678825,
			0.029194669173189927,0.029799544588417878,0.03070454338371813,
			0.03235690178723757,0.03481445811178912,0.037272014436340664,
			0.0404480911742845,0.043691892378550375,0.047335820825453276,
			0.05172946310897772,0.05612310539250216,0.061144351162320185,
			0.06635729049654547,0.07181799093661752,0.07798571339514473,
			0.08518281549892626,0.09352614276622763,0.10356634160410436,
			0.11609317557810656,0.399976 };
		const std::vector<double> HorizontalStab = { 0.0432188,
			0.039785703465217113,0.03666546788102608,0.0345089045612839,
			0.032625678647603365,0.031178329323174703,0.03016698711579917,
			0.029383990827010206,0.029086075336303828,0.028886678369678825,
			0.029194669173189927,0.029799544588417878,0.03070454338371813,
			0.03235690178723757,0.03481445811178912,0.037272014436340664,
			0.0404480911742845,0.043691892378550375,0.047335820825453276,
			0.05172946310897772,0.05612310539250216,0.061144351162320185,
			0.06635729049654547,0.07181799093661752,0.07798571339514473,
			0.08518281549892626,0.09352614276622763,0.10356634160410436,
			0.11609317557810656,0.399976 };
		const std::vector<double> VerticalStab = { 0.0432188,
			0.039785703465217113,0.03666546788102608,0.0345089045612839,
			0.032625678647603365,0.031178329323174703,0.03016698711579917,
			0.029383990827010206,0.029086075336303828,0.028886678369678825,
			0.029194669173189927,0.029799544588417878,0.03070454338371813,
			0.03235690178723757,0.03481445811178912,0.037272014436340664,
			0.0404480911742845,0.043691892378550375,0.047335820825453276,
			0.05172946310897772,0.05612310539250216,0.061144351162320185,
			0.06635729049654547,0.07181799093661752,0.07798571339514473,
			0.08518281549892626,0.09352614276622763,0.10356634160410436,
			0.11609317557810656,0.399976 };

		const std::vector<double> Aileron = { 0.0432188,
			0.039785703465217113,0.03666546788102608,0.0345089045612839,
			0.032625678647603365,0.031178329323174703,0.03016698711579917,
			0.029383990827010206,0.029086075336303828,0.028886678369678825,
			0.029194669173189927,0.029799544588417878,0.03070454338371813,
			0.03235690178723757,0.03481445811178912,0.037272014436340664,
			0.0404480911742845,0.043691892378550375,0.047335820825453276,
			0.05172946310897772,0.05612310539250216,0.061144351162320185,
			0.06635729049654547,0.07181799093661752,0.07798571339514473,
			0.08518281549892626,0.09352614276622763,0.10356634160410436,
			0.11609317557810656,0.399976 };
		const std::vector<double> Elevator = { 0.0432188,
			0.039785703465217113,0.03666546788102608,0.0345089045612839,
			0.032625678647603365,0.031178329323174703,0.03016698711579917,
			0.029383990827010206,0.029086075336303828,0.028886678369678825,
			0.029194669173189927,0.029799544588417878,0.03070454338371813,
			0.03235690178723757,0.03481445811178912,0.037272014436340664,
			0.0404480911742845,0.043691892378550375,0.047335820825453276,
			0.05172946310897772,0.05612310539250216,0.061144351162320185,
			0.06635729049654547,0.07181799093661752,0.07798571339514473,
			0.08518281549892626,0.09352614276622763,0.10356634160410436,
			0.11609317557810656,0.399976 };
	}
	namespace CM

	{
		const std::vector<double> StabilityPitch;
		const std::vector<double> StabilityYaw;
		const std::vector<double> StabilityRoll;
	}
	///========================================
	double lerp(const double& x, const double& min, const double& max, const std::vector<double>& table)

	{
		double diff = max - min;
		double step = diff / ((double)table.size() - 1);
		int minIndex = min / step;
		double index = x / step - minIndex;

		int lower = floor(index);
		int upper = ceil(index);

		if (lower == upper) upper++;

		double lowerX = (double)(lower + minIndex) * step;
		double upperX = (double)(upper + minIndex) * step;

		if (upper > (table.size() - 1)) return table.back();
		if (lower < 0) return table.front();

		return (x - lowerX) * ((table[upper] - table[lower]) / (upperX - lowerX)) + table[lower];
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
	const Surface elevatorLeft(0.66, Vec3(-5.5, 1.0, -0.8), 30.0);
	const Surface elevatorRight(0.66, Vec3(-5.5, 1.0, 0.8), 30.0);
	//Aileron
	const Surface aileronLeft(0.66, Vec3(-2.0, -0.7, -3.1), 30.0);
	const Surface aileronRight(0.66, Vec3(-2.0, -0.7, 3.1), 30.0);
	//Rudder
	const Surface rudder(0.66, Vec3(-5.5, 2.0, 0.0), 30.0);
	//Flaps
	const Surface flapLeft(2.0, Vec3(), 30.0);
	const Surface flapRight(2.0, Vec3(), 30.0);
	//Wings
	const Surface wingLeft(24.15, Vec3(-0.0, -0.7, -1.94));
	const Surface wingRight(24.15, Vec3(-0.0, -0.7, 1.94));
	//Horizontal Stabiliser
	const Surface horizontalStabLeft(4.260, Vec3(-5.0, 1.0, -0.5));
	const Surface horizontalStabRight(4.260, Vec3(-5.0, 1.0, 0.5));
	//Vertical Stabiliser
	const Surface verticalStab(4.641, Vec3(-5.0, 1.5, 0.0));
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

	inline void addForce(const Vec3& position, const Vec3& force, const Vec3& centerOfGravity);
	inline void addMoment(const Vec3& moment);

	///==============================================
	///Calculate Forces and Moments
	inline void calculate(const APars& params, 
		const double& flapsPosition, 
		const double& aileronPosition,
		const double& elevatorPosition,
		const double& rudderPosition,
		const double& throttlePosition,
		const Vec3& centerOfGravity);
	///==============================================
}


///Lift and Drag function declerations
///==============================================
inline double Skyhawk::liftWing(const APars& params)

{
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * wingLeft.area * coeffLift;
}

inline double Skyhawk::liftHorizontalStab(const APars& params)

{
	//double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
	double coeffLift = params.alpha / 50.0;
	return params.q * horizontalStabLeft.area * coeffLift;
}

inline double Skyhawk::liftVerticalStab(const APars& params)

{
	double coeffLift = 0.05 * (params.beta); //lerp the table
	return params.q * verticalStab.area * coeffLift;
}

inline double Skyhawk::liftFlaps(const APars& params, const double& flapsPosition) //flapsPosition between 0 and 1

{
	double flapsAngle = flapLeft.throwUp * flapsPosition;
	double coeffLift = lerp(params.alpha + flapsAngle, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * flapLeft.area * coeffLift;
}

inline double Skyhawk::liftAileron(const APars& params, const double& aileronPosition) //aileronPosition between -1 and 1

{
	double aileronAngle = aileronPosition >= 0.0 ? aileronLeft.throwUp * aileronPosition : aileronLeft.throwDown * aileronPosition;
	double coeffLift = lerp(params.alpha + aileronAngle, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * aileronLeft.area * coeffLift;
}

inline double Skyhawk::liftElevator(const APars& params, const double& elevatorPosition) //elevatorPosition between -1 and 1

{
	double elevatorAngle = elevatorPosition >= 0.0 ? elevatorLeft.throwUp * elevatorPosition : elevatorLeft.throwDown * elevatorPosition;
	double coeffLift = lerp(params.alpha + elevatorAngle, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * elevatorLeft.area * coeffLift;
}

inline double Skyhawk::liftRudder(const APars& params, const double& rudderPosition) //rudderPosition between -1 and 1

{
	double rudderAngle = rudder.throwUp * rudderPosition;
	double coeffLift = 0.05 * (params.beta + rudderAngle); //lerp the table
	return params.q * rudder.area * coeffLift;
}

///==============================================
inline double Skyhawk::dragWing(const APars& params)

{
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing);
	double coeffDrag = lerp(coeffLift, -4.0, 28.0, CD::Wing); //lerp the table
	return params.q * wingLeft.area * coeffDrag;
}

inline double Skyhawk::dragHorizontalStab(const APars& params)

{
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing);
	double coeffDrag = lerp(coeffLift, -4.0, 28.0, CD::Wing); //lerp the table
	return params.q * horizontalStabLeft.area * coeffDrag;
}

inline double Skyhawk::dragVerticalStab(const APars& params)

{
	double coeffLift = 0.05 * (params.beta);
	double coeffDrag = coeffLift * 0.1; //lerp the table
	return params.q * verticalStab.area * coeffDrag;
}

inline double Skyhawk::dragFlaps(const APars& params, const double& flapsPosition) //flapsPosition between 0 and 1

{
	double flapsAngle = flapLeft.throwUp * flapsPosition;
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing);
	double coeffDrag = lerp(coeffLift, -4.0, 28.0, CD::Wing); //lerp the table
	return params.q * flapLeft.area * coeffDrag;
}

inline double Skyhawk::dragAileron(const APars& params, const double& aileronPosition) //aileronPosition between -1 and 1

{
	double aileronAngle = aileronPosition >= 0.0 ? aileronLeft.throwUp * aileronPosition : aileronLeft.throwDown * aileronPosition;
	double coeffLift = lerp(params.alpha + aileronAngle, -4.0, 28.0, CL::Wing);
	double coeffDrag = lerp(coeffLift, -4.0, 28.0, CD::Wing); //lerp the table
	return params.q * aileronLeft.area * coeffDrag;
}

inline double Skyhawk::dragElevator(const APars& params, const double& elevatorPosition) //elevatorPosition between -1 and 1

{
	double elevatorAngle = elevatorPosition >= 0.0 ? elevatorLeft.throwUp * elevatorPosition : elevatorLeft.throwDown * elevatorPosition;
	double coeffLift = lerp(params.alpha + elevatorAngle, -4.0, 28.0, CL::Wing);
	double coeffDrag = lerp(coeffLift, -4.0, 28.0, CD::Wing); //lerp the table
	return params.q * elevatorLeft.area * coeffDrag;
}

inline double Skyhawk::dragRudder(const APars& params, const double& rudderPosition) //rudderPosition between -1 and 1

{
	double rudderAngle = rudder.throwUp * rudderPosition;
	double coeffLift = 0.05 * (params.beta + rudderAngle);
	double coeffDrag = coeffLift * 0.1; //lerp the table
	return params.q * rudder.area * coeffDrag;
}
///==============================================

inline void Skyhawk::addForce(const Vec3& position, const Vec3& force, const Vec3& centerOfGravity)

{
	netForce += force;
	Vec3 deltaPos = position - centerOfGravity;
	Vec3 deltaMoment = cross(deltaPos, force);
	netMoment += deltaMoment;
}

inline void Skyhawk::addMoment(const Vec3& moment)

{
	netMoment += moment;
}

///==============================================
///Calculate Forces and Moments
inline void Skyhawk::calculate(const APars& params,
	const double& flapsPosition,
	const double& aileronPosition,
	const double& elevatorPosition,
	const double& rudderPosition,
	const double& throttlePosition,
	const Vec3& centerOfGravity)

{
	netForce = Vec3();
	netMoment = Vec3();

	//netMoment -= Vec3(params.rollRate * 10000.0, 0, 0);

	double elev = liftElevator(params, elevatorPosition);
	//addForce(elevatorLeft.position, Vec3(0.0, elev, 0.0), centerOfGravity);
	//addForce(elevatorRight.position, Vec3(0.0, elev, 0.0), centerOfGravity);

	double ailL = liftElevator(params, aileronPosition);
	double ailR = liftElevator(params, -aileronPosition);
	//addForce(aileronLeft.position, Vec3(0.0, ailL, 0.0), centerOfGravity);
	//addForce(aileronRight.position, Vec3(0.0, ailR, 0.0), centerOfGravity);

	double rud = liftElevator(params, rudderPosition);
	//addForce(rudder.position, Vec3(0.0, 0.0, -rud), centerOfGravity);

	double wing = liftWing(params);
	double wingD = dragWing(params);
	addForce(wingLeft.position, Vec3(-wingD, wing, 0.0), centerOfGravity);
	addForce(wingRight.position, Vec3(-wingD, wing, 0.0), centerOfGravity);

	double horiz = liftHorizontalStab(params);
	double horizD = dragHorizontalStab(params);
	addForce(horizontalStabLeft.position, Vec3(0.0, horiz*3, 0.0), centerOfGravity);
	addForce(horizontalStabRight.position, Vec3(0.0, horiz*3, 0.0), centerOfGravity);

	double vert = liftVerticalStab(params);
	double vertD = dragVerticalStab(params);
	addForce(verticalStab.position, Vec3(0.0, 0.0, -vert), centerOfGravity);
	Vec3 thrust_pos(-5.0,centerOfGravity.y,0);
	Vec3 thrust(throttlePosition * 38000, 0 , 0);
	addForce(thrust_pos, thrust, centerOfGravity);
}
///==============================================