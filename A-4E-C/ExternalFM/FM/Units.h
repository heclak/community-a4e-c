#pragma once
//=========================================================================//
//
//		FILE NAME	: Units.h
//		AUTHOR		: Joshua Nelson
//		DATE		: June 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Unit conversion literals.
//
//================================ Includes ===============================//

inline long double operator"" _deg( long double x )
{
	return x * 0.01745329252;
}

inline long double operator"" _nauticalMile( long double x )
{
	return x * 1852.0;
}