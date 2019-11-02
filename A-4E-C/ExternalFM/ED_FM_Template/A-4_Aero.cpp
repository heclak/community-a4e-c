#include "A-4_Aero.h"

///Lift and Drag function definitions
///==============================================
inline double Skyhawk::liftWing(const APars& params)

{
	double coeffLift; //lerp the table
	return params.q * wingLeft.area * coeffLift;
}

inline double Skyhawk::liftHorizontalStab(const APars& params)

{
	double coeffLift; //lerp the table
	return params.q * horizontalStabLeft.area * coeffLift;
}

inline double Skyhawk::liftVerticalStab(const APars& params)

{
	double coeffLift; //lerp the table
	return params.q * verticalStab.area * coeffLift;
}

inline double Skyhawk::liftFlaps(const APars& params, const double& flapsPosition) //flapsPosition between 0 and 1

{
	double flapsAngle = flapLeft.throwUp * flapsPosition;
	double coeffLift; //lerp the table
	return params.q * flapLeft.area * coeffLift;
}

inline double Skyhawk::liftAileron(const APars& params, const double& aileronPosition) //aileronPosition between -1 and 1

{
	double aileronAngle = aileronPosition >= 0.0 ? aileronLeft.throwUp * aileronPosition : aileronLeft.throwDown * aileronPosition;
	double coeffLift; //lerp the table
	return params.q * aileronLeft.area * coeffLift;
}

inline double Skyhawk::liftElevator(const APars& params, const double& elevatorPosition) //elevatorPosition between -1 and 1

{
	double elevatorAngle = elevatorPosition >= 0.0 ? elevatorLeft.throwUp * elevatorPosition : elevatorLeft.throwDown * elevatorPosition;
	double coeffLift; //lerp the table
	return params.q * elevatorLeft.area * coeffLift;
}

inline double Skyhawk::liftRudder(const APars& params, const double& rudderPosition) //rudderPosition between -1 and 1

{
	double rudderAngle = rudder.throwUp * rudderPosition;
	double coeffLift; //lerp the table
	return params.q * rudder.area * coeffLift;
}

///==============================================
inline double Skyhawk::dragWing(const APars& params)

{
	double coeffDrag; //lerp the table
	return params.q * wingLeft.area * coeffDrag;
}

inline double Skyhawk::dragHorizontalStab(const APars& params)

{
	double coeffDrag; //lerp the table
	return params.q * horizontalStabLeft.area * coeffDrag;
}

inline double Skyhawk::dragVerticalStab(const APars& params)

{
	double coeffDrag; //lerp the table
	return params.q * verticalStab.area * coeffDrag;
}

inline double Skyhawk::dragFlaps(const APars& params, const double& flapsPosition) //flapsPosition between 0 and 1

{
	double flapsAngle = flapLeft.throwUp * flapsPosition;
	double coeffDrag; //lerp the table
	return params.q * flapLeft.area * coeffDrag;
}

inline double Skyhawk::dragAileron(const APars& params, const double& aileronPosition) //aileronPosition between -1 and 1

{
	double aileronAngle = aileronPosition >= 0.0 ? aileronLeft.throwUp * aileronPosition : aileronLeft.throwDown * aileronPosition;
	double coeffDrag; //lerp the table
	return params.q * aileronLeft.area * coeffDrag;
}

inline double Skyhawk::dragElevator(const APars& params, const double& elevatorPosition) //elevatorPosition between -1 and 1

{
	double elevatorAngle = elevatorPosition >= 0.0 ? elevatorLeft.throwUp * elevatorPosition : elevatorLeft.throwDown * elevatorPosition;
	double coeffDrag; //lerp the table
	return params.q * elevatorLeft.area * coeffDrag;
}

inline double Skyhawk::dragRudder(const APars& params, const double& rudderPosition) //rudderPosition between -1 and 1

{
	double rudderAngle = rudder.throwUp * rudderPosition;
	double coeffDrag; //lerp the table
	return params.q * rudder.area * coeffDrag;
}
///==============================================

///==============================================
///Calculate Forces and Moments
inline void Skyhawk::calculate(const APars& params,
	const double& flapsPosition,
	const double& aileronPosition,
	const double& elevatorPosition,
	const double& rudderPosition,
	const Vec3& centerOfGravity)

{

}
///==============================================