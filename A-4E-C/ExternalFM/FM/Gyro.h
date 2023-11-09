#pragma once
#include <Eigen/Geometry>

class Gyro
{
public:

    using Quat = Eigen::Quaternion<double>;
    using Mat3 = Eigen::Matrix3d;
    using Vec3 = Eigen::Vector3<double>;

    Gyro( double mass, double radius, double rpm_factor );

    // Returns pitch and Roll in degrees
    void GetPitchRoll( const Quat& world_orientation, double& yaw, double& pitch, double& roll );

    void Update( double dt );

    Quat GetToBody() { return m_to_body; }

    void SetBodyOmega( const Vec3& omega );
    void SetBodyOmegaX( double x ) { m_w.x() = x; SetBodyOmega( m_w ); }
    void SetBodyOmegaY( double y ) { m_w.y() = y; SetBodyOmega( m_w ); }
    void SetBodyOmegaZ( double z ) { m_w.z() = z; SetBodyOmega( m_w ); }

    void SetGimbalOmega( const Vec3& gimbal_omega );

    Vec3 GetTorque() const { return m_T; }


    int m_a0 = 0;
    int m_a1 = 1;
    int m_a2 = 2;

    double gimbal_friction = 0.01;

private:

    union State
    {
        double state[8];

        struct
        {
            double q0;
            double q0d;
            double q1;
            double q1d;
            double q2;
            double q2d;
            double q3;
            double q3d;
        };
    };

    union Rate
    {
        double rate[9];
        struct
        {
            double q0d;
            double q0dd;
            double q1d;
            double q1dd;
            double q2d;
            double q2dd;
            double q3d;
            double q3dd;
            double q4d;
            double q4dd;
            double t;
        };
    };

    void Solve( double dt );
    void NormalizeQ();

    State m_state;

    double* GetState() { return m_state.state; }
    void GetRate( const State& state, Rate& rate );


    void CalculateMomentOfInertia();

    
   

    void ComputeBodyFrameTorque( const State& state );
    void ComputeBodyFrameAcceleration( const State& state );

    Vec3 GetOmegaFromState( const State& state );

    void UpdateVectors();
    
    

    const double m_mass;
    const double m_radius;
    const double m_rpm_factor;


    // From Book
    Quat m_to_body; // Rotation of Body in Lab frame.
    Vec3 m_w; // Angular Velocity Body Frame
    Vec3 m_w_dot; // Angular Velocity Body Frame
    Vec3 m_T; // Torque


    Vec3 m_L; // Momentum Body Frame

    Vec3 m_L_world; // Momentum World Frame

    Vec3 m_I; // Diagonal Moment of Inertia (Body frame)

};