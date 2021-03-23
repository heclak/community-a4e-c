#include "FuelSystem.h"
FuelSystem::FuelSystem() :
	m_pumpJunction( "Pump Junction" ),
	m_probe( "Probe" ),
	m_externalLeft( "External Left" ),
	m_externalCentre("External Centre"),
	m_externalRight("External Right"),
	m_wingTank("Wing Tank"),
	m_fuselageTank("Fuselage Tank")
{
    //m_root = new Edge;


	/*Node* internalTank = new FuelTank;
	Edge* wingToInternal = new Edge;
	Node* wingTank = new FuelTank;


	Node* leftExternal = new FuelTank;
	Edge* leftToWing = new Edge;

	Node* centreExternal = new FuelTank;
	Edge* centreToWing = new Edge;

	Node* rightExternal = new FuelTank;
	Edge* rightToWing = new Edge;*/

	/*m_root->setDown( internalTank );
	internalTank->addEdge( m_root );*/

	m_enginePump.setDown( &m_pumpJunction );
	m_pumpJunction.addEdge( &m_enginePump );

	joinNodes( m_probe, m_fuselageTank, m_probeToFuselage );

	joinNodes( m_pumpJunction, m_fuselageTank, m_boostPump );
	joinNodes( m_fuselageTank, m_wingTank, m_wingToFuselageValve );

	joinNodes( m_wingTank, m_externalLeft, m_externalLeftValve );
	joinNodes( m_wingTank, m_externalRight, m_externalRightValve );
	joinNodes( m_wingTank, m_externalCentre, m_externalCentreValve );
}

FuelSystem::~FuelSystem()
{
	for ( size_t i = 0; i < m_edges.size(); i++ )
		delete m_edges[i];

	for ( size_t i = 0; i < m_nodes.size(); i++ )
		delete m_nodes[i];
}

void FuelSystem::joinNodes( Node& up, Node& down, Edge& edge )
{
	edge.setUp( &up );
	edge.setDown( &down );

	up.addEdge( &edge );
	down.addEdge( &edge );
}

void FuelSystem::pumpInProbe( double rate )
{
	m_externalCentre.setPressure( 5e4 );
	m_externalLeft.setPressure( 5e4 );
	m_externalRight.setPressure( 5e4 );
	m_wingTank.setPressure( 5e4 );
	m_fuselageTank.setPressure( 5e4 );

	m_enginePump.setPressureDelta( -1e4 );
	m_boostPump.setPressureDelta( -1e4 );

	m_probe.addFuel( rate );
}

double FuelSystem::drawToEngine()
{
	m_externalCentre.setPressure( 5e4 );
	m_externalLeft.setPressure( 5e4 );
	m_externalRight.setPressure( 5e4 );
	m_wingTank.setPressure( 5e4 );
	m_fuselageTank.setPressure( 5e4 );

	m_enginePump.setPressureDelta( -1e4 );
	m_boostPump.setPressureDelta( -1e4 );


	return m_enginePump.updateFlow( 0.0, nullptr );
}