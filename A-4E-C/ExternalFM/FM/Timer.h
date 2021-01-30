#pragma once
//=========================================================================//
//
//		FILE NAME	: Timer.h
//		AUTHOR		: TerjeTL
//		DATE		: January 2021
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Utility class for timer.
//
//================================ Includes ===============================//
#include "BaseComponent.h"
//=========================================================================//

namespace Scooter
{

	class Timer : public BaseComponent
	{
	public:
		Timer(double time);
		~Timer();

		virtual void Timer::zeroInit();
		virtual void Timer::coldInit();
		virtual void Timer::hotInit();
		virtual void Timer::airborneInit();

		void updateLoop(double& dt);
		void startTimer();

		inline double getTime() { return m_time; };
		inline bool getState() { return m_isActive; };
		
	private:
		double m_time;
		double m_timeElapsed;
		bool m_isActive;
	};

}
