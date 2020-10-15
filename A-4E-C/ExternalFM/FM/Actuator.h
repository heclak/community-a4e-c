#pragma once
#include "BaseComponent.h"


namespace Skyhawk
{

class Actuator : public BaseComponent
{
public:
	Actuator();
	~Actuator();

	virtual void Actuator::zeroInit();
	virtual void Actuator::coldInit();
	virtual void Actuator::hotInit();
	virtual void Actuator::airborneInit();


	double inputUpdate(double targetPosition, double dt);
	void physicsUpdate(double dt);
	double getPosition();
private:
	const double m_actuatorSpeed = 10;
	double m_actuatorPos;
	double m_actuatorTargetPos;
};

}

