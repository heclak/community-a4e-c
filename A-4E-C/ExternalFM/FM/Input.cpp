//=========================================================================//
//
//		FILE NAME	: Input.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Updates control axes as appropriate for keyboard.
//
//================================ Includes ===============================//
#include "Input.h"
#include <stdio.h>
//=========================================================================//

Scooter::Input::Input():
	m_pitchAxis( 0.015, -1.0, 1.0, 0.0, 1.0 ),
	m_rollAxis( 0.015, -1.0, 1.0, 0.0, 1.0 ),
	m_yawAxis(0.015, -1.0, 1.0, 0.0, 1.0),
	m_throttleAxis(0.005, -1.0, 1.0, 1.0, 0.0),
	m_leftBrakeAxis(0.02, 0.0, 1.0, 0.0, 0.0),
	m_rightBrakeAxis(0.02, 0.0, 1.0, 0.0, 0.0),
	m_mouseX(0.04, -1.0, 1.0, 0.0, 0.0),
	m_mouseY(0.04, -1.0, 1.0, 0.0, 0.0)

{

}


void Scooter::Input::update(bool brakeAssist)
{
	m_brakeAssist = brakeAssist;

	m_pitchAxis.update();
	m_rollAxis.update();
	m_yawAxis.update();
	m_throttleAxis.update();
	m_leftBrakeAxis.update();
	m_rightBrakeAxis.update();
}