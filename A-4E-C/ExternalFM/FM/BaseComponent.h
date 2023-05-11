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
#include <string>
class BaseComponent
{
public:
	BaseComponent(const std::string& name): m_name(name) {}
	BaseComponent() {}
	virtual void zeroInit() = 0;
	virtual void coldInit() = 0;
	virtual void hotInit() = 0;
	virtual void airborneInit() = 0;

	[[nodiscard]] const std::string& GetName() const { return m_name; }

private:
	std::string m_name = "Unknown";
};