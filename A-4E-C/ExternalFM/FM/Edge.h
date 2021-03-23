#pragma once
#include "Node.h"

class Node;

class Edge
{
public:
	Edge(){}
	virtual double updateFlow(double pressureDelta, Node* node);
	void setBlocked( bool state )
	{
		m_blocked = state;
	}

	void addFuel( double delta )
	{

	}

	void setPressureDelta( double pressureDelta )
	{
		m_pressureDelta = pressureDelta;
	}

	//virtual void updatePressureFactor()=0;
	inline void setUp( Node* node )
	{
		m_up = node;
	}
	inline void setDown( Node* node )
	{
		m_down = node;
	}

private:
	double m_pressureDelta = 0.0;
	bool m_blocked = false;
	Node* m_up = nullptr;
	Node* m_down = nullptr;
};