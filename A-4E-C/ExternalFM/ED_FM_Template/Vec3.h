#ifndef VEC3_H
#define VEC3_H
#pragma once
struct Vec3
{
	Vec3() : x(0.0), y(0.0), z(0.0) {}
	Vec3(double x_, double y_, double z_) :x(x_), y(y_), z(z_) {}
	Vec3(double v) : x(v), y(v), z(v) {}
	double x;
	double y;
	double z;

	//Overloaded Operators for ED's silly vector struct.
	Vec3& operator- ()

	{
		this->x = -this->x;
		this->y = -this->y;
		this->z = -this->z;
		return *this;
	}

	Vec3& operator+= (const Vec3& v)

	{
		this->x += v.x;
		this->y += v.y;
		this->z += v.z;
		return *this;
	}

	Vec3& operator-= (const Vec3& v)

	{
		this->x -= v.x;
		this->y -= v.y;
		this->z -= v.z;
		return *this;
	}

	Vec3& operator*= (const double& s)

	{
		this->x *= s;
		this->y *= s;
		this->z *= s;
		return *this;
	}

	Vec3& operator/= (const double& s)

	{
		this->x /= s;
		this->y /= s;
		this->z /= s;
		return *this;
	}

	Vec3 operator+ (const Vec3& v) const

	{
		Vec3 result;
		result.x = this->x + v.x;
		result.y = this->y + v.y;
		result.z = this->z + v.z;
		return result;
	}

	Vec3 operator- (const Vec3& v) const

	{
		Vec3 result;
		result.x = this->x - v.x;
		result.y = this->y - v.y;
		result.z = this->z - v.z;
		return result;
	}

	Vec3 operator/ (const double& s) const

	{
		Vec3 result;
		result.x = this->x / s;
		result.y = this->y / s;
		result.z = this->z / s;
		return result;
	}
};

//Overloaded Operators for ED's silly vector struct.
inline Vec3 operator* (const double& s, const Vec3& v)

{
	Vec3 result;
	result.x = v.x * s;
	result.y = v.y * s;
	result.z = v.z * s;
	return result;
}

inline Vec3 operator* (const Vec3& v, const double& s)

{
	Vec3 result;
	result.x = v.x * s;
	result.y = v.y * s;
	result.z = v.z * s;
	return result;
}


inline Vec3 cross(const Vec3& a, const Vec3& b)
{
	return Vec3(a.y * b.z - a.z * b.y,
		a.z * b.x - a.x * b.z,
		a.x * b.y - a.y * b.x);
}
#endif

