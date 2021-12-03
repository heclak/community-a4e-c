#pragma once
#include <stdio.h>
class Logger
{
public:
	Logger( const char* file )
	{
		fopen_s( &m_file, file, "w+" );
	}

	~Logger()
	{
		fclose( m_file );
	}

	void time( double dt )
	{
		fprintf( m_file, "%lf,", m_t );
		m_t += dt;
	}

	void entry( double value, bool end = false ) 
	{  
		if ( end )
			fprintf( m_file, "%lf\n", value );
		else
			fprintf( m_file, "%lf,", value );
	}

private:
	FILE* m_file;
	double m_t = 0.0;
};