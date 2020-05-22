#include "A-4_Aero.h"
///Lift and Drag function definitions
///==============================================
inline double Skyhawk::liftWing(const APars& params)

{
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * wingLeft.area * coeffLift;
}

inline double Skyhawk::liftHorizontalStab(const APars& params)

{
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
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
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * flapLeft.area * coeffLift;
}

inline double Skyhawk::liftAileron(const APars& params, const double& aileronPosition) //aileronPosition between -1 and 1

{
	double aileronAngle = aileronPosition >= 0.0 ? aileronLeft.throwUp * aileronPosition : aileronLeft.throwDown * aileronPosition;
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
	return params.q * aileronLeft.area * coeffLift;
}

inline double Skyhawk::liftElevator(const APars& params, const double& elevatorPosition) //elevatorPosition between -1 and 1

{
	double elevatorAngle = elevatorPosition >= 0.0 ? elevatorLeft.throwUp * elevatorPosition : elevatorLeft.throwDown * elevatorPosition;
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing); //lerp the table
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
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing);
	double coeffDrag = lerp(coeffLift, -4.0, 28.0, CD::Wing); //lerp the table
	return params.q * aileronLeft.area * coeffDrag;
}

inline double Skyhawk::dragElevator(const APars& params, const double& elevatorPosition) //elevatorPosition between -1 and 1

{
	double elevatorAngle = elevatorPosition >= 0.0 ? elevatorLeft.throwUp * elevatorPosition : elevatorLeft.throwDown * elevatorPosition;
	double coeffLift = lerp(params.alpha, -4.0, 28.0, CL::Wing);
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

	netMoment -= Vec3(params.rollRate * 10000.0, 0, 0);

	double elev = liftElevator(params, elevatorPosition);
	addForce(elevatorLeft.position, elev, centerOfGravity);
	addForce(elevatorRight.position, elev, centerOfGravity);

	double ail = liftElevator(params, aileronPosition);
	addForce(aileronLeft.position, ail, centerOfGravity);
	addForce(aileronRight.position, -ail, centerOfGravity);

	double rud = liftElevator(params, rudderPosition);
	addForce(rudder.position, rud, centerOfGravity);

	double wing = liftWing(params);
	addForce(wingLeft.position, wing, centerOfGravity);
	addForce(wingRight.position, wing, centerOfGravity);

	double horiz = liftHorizontalStab(params);
	addForce(horizontalStabLeft.position, horiz, centerOfGravity);
	addForce(horizontalStabRight.position, horiz, centerOfGravity);

	double vert = liftVerticalStab(params);
	addForce(verticalStab.position, vert, centerOfGravity);
}
///==============================================