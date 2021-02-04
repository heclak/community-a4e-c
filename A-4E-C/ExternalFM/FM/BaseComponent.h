#pragma once
//=========================================================================//
//
//		FILE NAME	: BaseComponent.h
//		AUTHOR		: Joshua Nelson
//		DATE		: October 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	All components should inherit from this so they can be
//						reset on init.
//
//================================ Includes ===============================//
//=========================================================================//

class BaseComponent
{
public:
	BaseComponent() {}
	virtual void zeroInit() = 0;
	virtual void coldInit() = 0;
	virtual void hotInit() = 0;
	virtual void airborneInit() = 0;

private:
};