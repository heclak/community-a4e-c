#include "Input.h"
#include <stdio.h>
Skyhawk::Input::Input():
	m_pitchAxis( 0.015, -1.0, 1.0, 0.0, 1.0 ),
	m_rollAxis( 0.015, -1.0, 1.0, 0.0, 1.0 ),
	m_yawAxis(0.015, -1.0, 1.0, 0.0, 1.0),
	m_throttleAxis(0.02, -1.0, 1.0, 1.0, 0.0),
	m_leftBrakeAxis(0.04, 0.0, 1.0, 0.0, 0.0),
	m_rightBrakeAxis(0.04, 0.0, 1.0, 0.0, 0.0)
{

}


void Skyhawk::Input::update()
{
	m_pitchAxis.update();
	m_rollAxis.update();
	m_yawAxis.update();
	m_throttleAxis.update();
	m_leftBrakeAxis.update();
	m_rightBrakeAxis.update();
}