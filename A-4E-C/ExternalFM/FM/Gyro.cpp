#include "Gyro.h"
#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <cockpit_base_api.h>

Gyro::Gyro(double mass, double radius, double rpm_factor) :
    m_mass( mass ),
    m_radius( radius ),
    m_rpm_factor( rpm_factor )
{
    CalculateMomentOfInertia();
}

void Gyro::SetGimbalOmega( const Vec3& gimbal_omega )
{
    const Vec3 omega_aircraft = m_to_body * (gimbal_omega);
    m_T = -( omega_aircraft + m_w ) * gimbal_friction;
}

void Gyro::GetPitchRoll( const Quat& world_orientation, double& yaw, double& pitch, double& roll )
{

    Quat rotation = m_to_body.inverse() * world_orientation.inverse();


    const Mat3 rotation_matrix = rotation.inverse().toRotationMatrix();
    Vec3 angles = rotation_matrix.canonicalEulerAngles( m_a0, m_a1, m_a2 );

    roll = 180.0 * angles.x() / M_PI;
    pitch = 180.0 * angles.y() / M_PI;
    yaw = 180.0 * angles.z() / M_PI;
}

void Gyro::CalculateMomentOfInertia()
{
    const double symetric_I = m_mass * m_radius * m_radius;

    Quat ident = Quat::Identity();
    //Quat ident( 0.01, Vec3( 0.0, 1.0, 0.0 ) );

    m_state.q0 = ident.w();
    m_state.q1 = ident.x();
    m_state.q2 = ident.y();
    m_state.q3 = ident.z();

    NormalizeQ();

    m_state.q0d = 0.0;
    m_state.q1d = 0.0;
    m_state.q2d = 0.0;
    m_state.q3d = 0.0;

    m_to_body.w() = m_state.q0;
    m_to_body.x() = m_state.q1;
    m_to_body.y() = m_state.q2;
    m_to_body.z() = m_state.q3;


    m_I.z() = symetric_I * m_rpm_factor;


    m_I.x() = symetric_I / 2.0;
    m_I.y() = symetric_I / 2.0;

    SetBodyOmega( Vec3( 0.0, 0.0, 1.0 ) );

}

void Gyro::UpdateVectors()
{
    m_w = GetOmegaFromState( m_state );
    m_L.x() = m_I.x() * m_w.x();
    m_L.y() = m_I.y() * m_w.y();
    m_L.z() = m_I.z() * m_w.z();
}

Gyro::Vec3 Gyro::GetOmegaFromState( const State& state )
{
    const double q0 = state.q0;
    const double q1 = state.q1;
    const double q2 = state.q2;
    const double q3 = state.q3;

    // dq/dt
    const double q0d = state.q0d;
    const double q1d = state.q1d;
    const double q2d = state.q2d;
    const double q3d = state.q3d;

    Vec3 result;

    result.x() = 2.0 * ( -q1 * q0d + q0 * q1d + q3 * q2d - q2 * q3d );
    result.y() = 2.0 * ( -q2 * q0d - q3 * q1d + q0 * q2d + q1 * q3d );
    result.z() = 2.0 * ( -q3 * q0d + q2 * q1d - q1 * q2d + q0 * q3d );

    return result;
}


void Gyro::SetBodyOmega( const Vec3& omega )
{
    const double q0 = m_state.q0;
    const double q1 = m_state.q1;
    const double q2 = m_state.q2;
    const double q3 = m_state.q3;

    const double wx = omega.x();
    const double wy = omega.y();
    const double wz = omega.z();

    m_state.q0d = 0.5 * ( -q1 * wx - q2 * wy - q3 * wz );
    m_state.q1d = 0.5 * ( q0 * wx - q3 * wy + q2 * wz );
    m_state.q2d = 0.5 * ( q3 * wx + q0 * wy - q1 * wz );
    m_state.q3d = 0.5 * ( -q2 * wx + q1 * wy + q0 * wz );

    UpdateVectors();

}

void Gyro::NormalizeQ()
{

    const double sum_sqr = m_state.q0 * m_state.q0 +
        m_state.q1 * m_state.q1 +
        m_state.q2 * m_state.q2 +
        m_state.q3 * m_state.q3;

    const double sum = sqrt( sum_sqr );

    if ( sum == 0.0 )
        return;

    m_state.q0 /= sum;
    m_state.q1 /= sum;
    m_state.q2 /= sum;
    m_state.q3 /= sum;

}

void Gyro::Update( double dt )
{

    static constexpr size_t sub_step_quantity = 1000;
    static constexpr double sub_step_quantity_f = static_cast<double>( sub_step_quantity );
    const double sub_step_dt = dt / sub_step_quantity_f;

    for ( size_t i = 0; i < sub_step_quantity; i++ )
    {
        Solve( sub_step_dt );
        // solver.step();

        NormalizeQ();
        UpdateVectors();

        m_to_body.w() = m_state.q0;
        m_to_body.x() = m_state.q1;
        m_to_body.y() = m_state.q2;
        m_to_body.z() = m_state.q3;


        //Vec3 up{ 0.0, 0.0, 1.0 };

        //Vec3 up_lab = m_to_body * up;
        //printf( "%.02lf,%.02lf %.02lf | %.02lf,%.02lf %.02lf\n", up_lab.x(), up_lab.y(), up_lab.z(), m_L.x(), m_L.y(), m_L.z() );
    }
}

void Gyro::ComputeBodyFrameTorque( const State& state )
{
    /*Vec3 down{ 0.0, 0.0, 1.0 };

    Vec3 force = m_to_body * down;

    m_T.x() = force.y();
    m_T.y() = force.x();
    m_T.z() = 0.0;*/
}

void Gyro::ComputeBodyFrameAcceleration( const State& state )
{
    const Vec3 omega = GetOmegaFromState( state );
    ComputeBodyFrameTorque( state );


    const double I1 = m_I.x();
    const double I2 = m_I.y();
    const double I3 = m_I.z();

    const double T1 = m_T.x();
    const double T2 = m_T.y();
    const double T3 = m_T.z();

    const double wx = 0.0; //omega.x();
    const double wy = 0.0; //omega.y();
    const double wz = 0.0; //omega.z();

    m_w_dot.x() = ( T1 - ( I3 - I2 ) * wx * wy ) / I1;
    m_w_dot.y() = ( T2 - ( I1 - I3 ) * wx * wz ) / I2;
    m_w_dot.z() = ( T3 - ( I2 - I1 ) * wy * wx ) / I3;
}

void Gyro::GetRate( const State& state, Rate& rate )
{
    ComputeBodyFrameAcceleration( state );

    double sum = state.q0d * state.q0d + state.q1d * state.q1d + state.q2d * state.q2d + state.q3d * state.q3d;
    sum = -2.0 * sum;

    const double q0 = state.q0;
    const double q1 = state.q1;
    const double q2 = state.q2;
    const double q3 = state.q3;

    // dq/dt
    const double q0d = state.q0d;
    const double q1d = state.q1d;
    const double q2d = state.q2d;
    const double q3d = state.q3d;

    rate.q0d = q0d;
    rate.q1d = q1d;
    rate.q2d = q2d;
    rate.q3d = q3d;

    const double wxdot = m_w_dot.x();
    const double wydot = m_w_dot.y();
    const double wzdot = m_w_dot.z();

    rate.q0dd = 0.5 * ( -q1 * wxdot - q2 * wydot - q3 * wzdot + q0 * sum );
    rate.q1dd = 0.5 * ( q0 * wxdot - q3 * wydot + q2 * wzdot + q1 * sum );
    rate.q2dd = 0.5 * ( q3 * wxdot + q0 * wydot - q1 * wzdot + q2 * sum );
    rate.q3dd = 0.5 * ( -q2 * wxdot + q1 * wydot + q0 * wzdot + q3 * sum );
    rate.t = 1.0;

}

void Gyro::Solve( double dt )
{

    Rate rate;

    GetRate( m_state, rate );


    m_state.q0d += dt * rate.q0dd;
    m_state.q1d += dt * rate.q1dd;
    m_state.q2d += dt * rate.q2dd;
    m_state.q3d += dt * rate.q3dd;

    m_state.q0 += dt * rate.q0d;
    m_state.q1 += dt * rate.q1d;
    m_state.q2 += dt * rate.q2d;
    m_state.q3 += dt * rate.q3d;
}
