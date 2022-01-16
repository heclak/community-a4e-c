#pragma once
#include <stdio.h>

static constexpr bool c_loggerEnabled = false;

class Logger
{
public:
	Logger( const char* file )
	{
		if constexpr ( ! c_loggerEnabled )
			return;

		if ( s_instance == nullptr )
			s_instance = this;

		fopen_s( &m_file, file, "w+" );
	}

	~Logger()
	{
		if constexpr ( ! c_loggerEnabled )
			return;

		if ( s_instance == this )
			s_instance = nullptr;

		fclose( m_file );
	}

	void logTime( double dt )
	{
		if constexpr ( ! c_loggerEnabled )
			return;

		fprintf( m_file, "%lf", m_t );
		m_t += dt;
	}

	void logEntry( double value ) 
	{  
		if constexpr ( ! c_loggerEnabled )
			return;

		fprintf( m_file, ",%lf", value );
	}

	void logEnd()
	{
		fprintf( m_file, "\n" );
	}

	//static inline Logger* instance() { return s_instance; }

	static inline void time( double dt )
	{
		if ( s_instance )
			s_instance->logTime( dt );
	}

	static inline void entry( double value )
	{
		if ( s_instance )
			s_instance->logEntry( value );
	}

	static inline void end()
	{
		if ( s_instance )
			s_instance->logEnd();
	}

	static Logger* s_instance;

private:
	FILE* m_file;
	double m_t = 0.0;
};