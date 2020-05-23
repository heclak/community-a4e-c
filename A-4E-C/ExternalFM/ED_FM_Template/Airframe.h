#ifndef AIRFRAME_H
#define AIRFRAME_H
#pragma once
#include "Input.h"
namespace Skyhawk
{//begin namespace

class Airframe
{
public:
	Airframe(Input& controls);
	~Airframe();

	//Utility
	inline void setGearPosition(double position); //for airstart or ground start
	inline double getGearPosition(); //returns gear pos


	//Update
	void airframeUpdate(double dt); //performs calculations and updates



private:

	//Airframe Constants
	const double m_gearExtendTime = 3.0;




	//Airframe Variables
	double m_gearPosition = 0.0; //0 -> 1





	Input& m_controls;
};

void Airframe::setGearPosition(double position)
{
	m_gearPosition = position;
}

double Airframe::getGearPosition()
{
	return m_gearPosition;
}

}//end namespace

#endif
