//=========================================================================//
//
//		FILE NAME	: Avionics.cpp
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Avionics class handles the any C/C++ side avionics. This
//						is the the yaw damper and the CP741/A bombing computer.
//
//================================ Includes ===============================//
#include "Avionics.h"

#include <corecrt_math_defines.h>

#include "Maths.h"
#include "Commands.h"
#include "Devices.h"
#include "cockpit_base_api.h"
#include <ImguiDisplay.h>
#include <imgui.h>
#define _USE_MATH_DEFINES
#include <math.h>
//=========================================================================//

#define STAB_AUG_MAX_AUTHORITY 0.3
#define MAX_ROTATION_RATE 1.6

Scooter::Avionics::Avionics
(
	Input& input,
	AircraftState& state,
	Interface& inter
) :
	m_input(input),
	m_state(state),
	m_interface(inter),
	m_bombingComputer(state),
	m_adc(inter, state),
    m_gyro( 1.0, 0.5, 100.0 )
{
	zeroInit();

	ImguiDisplay::AddImguiItem( "Avionics", "General", [this]() { ImGuiDebugWindow(); } );
}

Scooter::Avionics::~Avionics()
{

}

//Seriously need to set EVERY VARIABLE to zero (or approriate value if zero causes singularity) in the constructor and 
//in this function. Otherwise Track's become unusable because of the butterfly effect.
void Scooter::Avionics::zeroInit()
{
	m_x = 0.0;
}

void Scooter::Avionics::coldInit()
{
	zeroInit();
	ed_cockpit_dispatch_action_to_device( DEVICES_AVIONICS, DEVICE_COMMANDS_OXYGEN_SWITCH, 0.0 );
}

void Scooter::Avionics::hotInit()
{
	zeroInit();
	ed_cockpit_dispatch_action_to_device( DEVICES_AVIONICS, DEVICE_COMMANDS_OXYGEN_SWITCH, 1.0 );
}

void Scooter::Avionics::airborneInit()
{
	zeroInit();
	ed_cockpit_dispatch_action_to_device( DEVICES_AVIONICS, DEVICE_COMMANDS_OXYGEN_SWITCH, 1.0 );
}

bool Scooter::Avionics::handleInput( int command, float value )
{
	switch ( command )
	{
	case DEVICE_COMMANDS_OXYGEN_SWITCH:
		m_oxygen = (value == 1.0f);
		return true;
	}

	return false;
}

void Scooter::Avionics::updateAvionics(double dt)
{

	//printf( "Omega.y: %lf\n", m_state.getOmega().y );
	if ( m_damperEnabled )
	{
		double omega = m_state.getOmega().y;
		if ( fabs( omega ) > MAX_ROTATION_RATE )
		{
			omega = 0.0;
		}


		double f = washoutFilter( omega, dt ) * m_baseGain * (1.0 / (m_state.getMach() + 1));
		m_input.yawDamper() = clamp(f,-STAB_AUG_MAX_AUTHORITY, STAB_AUG_MAX_AUTHORITY); //f
	}
	else
	{
		m_x = 0.0;  
		m_input.yawDamper() = 0.0;
	}
	m_bombingComputer.updateSolution();
	m_adc.update(dt);

	//m_gyro.Update( dt );


	//const Vec3& omega = m_state.getOmega();
	//Gyro::Vec3 omega_gyro;
	//omega_gyro.x() = omega.x;
	//omega_gyro.y() = omega.y;
	//omega_gyro.z() = omega.z;
	//const Gyro::Vec3 omega_lab = m_state.GetOrientation() * omega_gyro;
	//m_gyro.SetGimbalOmega( omega_lab );

	//double pitch = 0.0;
	//double roll = 0.0;
	//double yaw = 0.0;
	//m_gyro.GetPitchRoll( m_state.GetOrientation(), yaw, pitch, roll );

	//pitch /= 90.0;
	//roll /= 180.0;


	//yaw = fmod( yaw + 180.0, 360.0 );
	//yaw /= 360.0;
	//yaw -= 0.5;
	//yaw *= 2.0;

	//if ( isnan( yaw ) )
	//	yaw = 0.0;

	//if ( isnan( pitch ) )
	//	pitch = 0.0;

	//if ( isnan( roll ) )
	//	roll = 0.0;

	//ed_cockpit_set_draw_argument( 384, static_cast<float>( roll ) );
	//ed_cockpit_set_draw_argument( 383, static_cast<float>( pitch ) );
	////ed_cockpit_set_draw_argument( 385, static_cast<float>( yaw ) );

	////printf("Filter: %lf, Rudder: %lf\n", f, m_flightModel.yawRate());
}

void Scooter::Avionics::ImGuiDebugWindow()
{
	double pitch = 0.0;
	double roll = 0.0;
	double yaw = 0.0;
	m_gyro.GetPitchRoll( m_state.GetOrientation(), yaw, pitch, roll );

	ImGui::Text( "Yaw: %lf", yaw );
	ImGui::Text( "Pitch: %lf", pitch );
	ImGui::Text( "Roll: %lf", roll );

	Gyro::Quat to_body = m_gyro.GetToBody();
	Gyro::Quat from_body = to_body.inverse();

	Gyro::Vec3 up = { 0.0, 0.0, 1.0 };
	Gyro::Vec3 up_body = to_body * up;
	Gyro::Vec3 up_lab = from_body * up;

	ImGui::Text( "Body: %.02lf,%.02lf,%.02lf", up_body.x(), up_body.y(), up_body.z() );
	ImGui::Text( "Lab: %.02lf,%.02lf,%.02lf", up_lab.x(), up_lab.y(), up_lab.z() );


	ImGui::SliderFloat( "Velocity", &m_gyro_debug_w, -720.0, 720.0 );

	const double angle = static_cast<double>( m_gyro_debug_w ) * M_PI / 180.0;

	if ( ImGui::Button("Set wx") )
	{
		m_gyro.SetBodyOmegaX( angle );
	}

	if ( ImGui::Button( "Set wy" ) )
	{
		m_gyro.SetBodyOmegaY( angle );
	}

	if ( ImGui::Button( "Set wz" ) )
	{
		m_gyro.SetBodyOmegaZ( angle );
	}

	float temp_friction = m_gyro.gimbal_friction;
	ImGui::SliderFloat( "Gimbal Friction", &temp_friction, 0.0, 0.5 );
	m_gyro.gimbal_friction = temp_friction;


	ImGui::InputInt( "a0", &m_gyro.m_a0 );
	ImGui::InputInt( "a1", &m_gyro.m_a1 );
	ImGui::InputInt( "a2", &m_gyro.m_a2 );

	ImGui::Text( "Gimbal Torque:  %.02lf,%.02lf,%.02lf", m_gyro.GetTorque().x(), m_gyro.GetTorque().y(), m_gyro.GetTorque().z() );
	
}
