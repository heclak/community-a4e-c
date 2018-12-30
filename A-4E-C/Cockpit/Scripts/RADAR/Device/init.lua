range_scale 		  = 60000.0
TDC_range_carret_size = 2000.0


perfomance = 
{
	tracking_azimuth   = { -math.rad(30),math.rad(30)},
	tracking_elevation = { -math.rad(30),math.rad(30)},
	
	scan_volume_azimuth 	= math.rad(60),
	scan_volume_elevation	= math.rad(20),
	scan_beam				= math.rad(20)/3.0,-- three lines of scan
	scan_speed				= math.rad(150),
	max_available_distance  = 60000.0,
	dead_zone 				= 300.0,
	
	ground_clutter =
	{-- spot RCS = A + B * random + C * random 
		sea		   	   = {0 ,0,0},
		land 	   	   = {0 ,3,3},		
		artificial 	   = {1 ,5,5},
		max_distance   = 30000.0
	}
}

function SetCommand(command,value)

end