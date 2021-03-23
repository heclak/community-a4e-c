#pragma once
//=========================================================================//
//
//		FILE NAME	: Input.h
//		AUTHOR		: Joshua Nelson
//		DATE		: May 2020
//
//		This file falls under the licence found in the root ExternalFM directory.
//
//		DESCRIPTION	:	Class for handling control inputs.
//
//================================ Includes ===============================//
#include "Edge.h"
#include "FuelTank.h"
#include "Junction.h"
#include "FuelSource.h"

//=========================================================================//
// FUEL SYSTEM
// 
// Fuel Pump, PU
// Boost Pump, B
// Fuselage Tank, F
// Refueling Probe, P
// Integral Wing Tank, W
// Pressure Fueling Receptacle, PF
// Left External Tank, L
// Centre External Tank, C
// Right External Tank, R
// Generics Junctions, O
//
// To engine
//   ^
//   |
//   PU
//   |   
//   B   /-----------\
//    \ /             W--<-PF
//     F---O----\     |
//        /      O----O-----
// P->---/       |    |    |
//               L    C    R
//
//
//
//=========================================================================//


class FuelSystem
{
public:
	FuelSystem();
	~FuelSystem();


	double drawToEngine();
	void pumpInProbe(double rate);
	void pumpInTank( double rate );

	static void joinNodes( Node& up, Node& down, Edge& edge );
private:
	Edge m_enginePump;
	Edge m_boostPump;
	Edge m_externalLeftValve;
	Edge m_externalCentreValve;
	Edge m_externalRightValve;
	Edge m_wingToFuselageValve;
	Edge m_probeToFuselage;


	std::vector<Edge*> m_edges;
	std::vector<Node*> m_nodes;

	Junction m_pumpJunction;
	FuelTank m_wingTank;
	FuelTank m_fuselageTank;

	FuelTank m_externalLeft;
	FuelTank m_externalCentre;
	FuelTank m_externalRight;
	FuelSource m_probe;

};
