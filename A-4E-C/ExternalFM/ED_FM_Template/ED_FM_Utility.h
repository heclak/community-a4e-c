#pragma once

struct Vec3 
{
	Vec3(double x_ = 0,double y_ = 0,double z_ = 0) :x(x_),y(y_),z(z_){}
	double x;
	double y;
	double z;
};


inline Vec3 cross(const Vec3 & a, const Vec3 & b)
{
	return Vec3 (a.y * b.z - a.z * b.y,
				 a.z * b.x - a.x * b.z,
				 a.x * b.y - a.y * b.x);
}


struct Matrix33
{
	Vec3 x;
	Vec3 y;
	Vec3 z;
};

struct Quaternion
{
	double x;
	double y;
	double z;
	double w;
};


Matrix33 quaternion_to_matrix(const Quaternion & v)
{
	Matrix33 mtrx;
	double wx, wy, wz, xx, yy, yz, xy, xz, zz, x2, y2, z2;
	x2 = v.x + v.x;
	y2 = v.y + v.y;
	z2 = v.z + v.z;
	xx = v.x * x2;   xy = v.x * y2;   xz = v.x * z2;
	yy = v.y * y2;   yz = v.y * z2;   zz = v.z * z2;
	wx = v.w * x2;   wy = v.w * y2;   wz = v.w * z2;


	mtrx.x.x  = 1.0 - (yy + zz);
	mtrx.x.y  = xy+wz;
	mtrx.x.z  = xz-wy;

	mtrx.y.x = xy-wz;
	mtrx.y.y = 1.0 - (xx + zz);
	mtrx.y.z = yz + wx;

	mtrx.z.x = xz+wy;
	mtrx.z.y = yz-wx;
	mtrx.z.z = 1.0 - (xx+yy);

	return mtrx;
}



double lerp(double * x,double * f, unsigned sz, double t)
{
	for (unsigned i = 0; i < sz; i++)
	{
		if (t <= x[i])
		{
			if (i > 0)
			{
				return ((f[i] - f[i - 1]) / (x[i] - x[i - 1]) * t +
					(x[i] * f[i - 1] - x[i - 1] * f[i]) / (x[i] - x[i - 1]));
			}
			return f[0];
		}
	}
	return f[sz-1];
}