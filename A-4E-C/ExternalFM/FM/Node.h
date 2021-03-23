#pragma once
#include <vector>
#include "Edge.h"

class Edge;

class Node
{
public:

	Node( const char* name ) : m_name(name) {}

	inline double getPressure()
	{
		return m_pressure;
	}

	inline void setPressure( double pressure )
	{
		m_pressure = pressure;
	}

	virtual double updateFlow(double deltaPressure, Edge* from)=0;
	inline void addEdge( Edge* edge )
	{
		m_edges.push_back( edge );
	}

protected:
	const char* m_name;
	double m_pressure;
	std::vector<Edge*> m_edges;
};