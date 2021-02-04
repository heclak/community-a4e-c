ViewSettings = {

	Cockpit = {

	[1] = {-- player slot 1
		CameraViewAngleLimits  = {20,140}, -- FOV Mini Maxi
		CockpitLocalPoint      = {3.065, 0.585, 0.000000},
		CameraAngleRestriction = {false,90,0.4},
		CameraAngleLimits      = {200,-90,90}, -- max wiew right/left, max view down, max view up
		EyePoint               = {0.0000000,0.000000,0.000000},
		ShoulderSize 		   = 0.25,
		Allow360rotation		= false,
		limits_6DOF            = {x = {-0.05,0.30},y = {-0.3,0.1},z = {-0.17,0.17},roll = 90.000000}, -- movement back,front bottom,top right,left																
	},	

	}, -- Cockpit 

	Chase = {
	--	LocalPoint      = {-10.000000,1.100000,-0.300000}, -- Vue F4
	--	AnglesDefault   = {180.000000,-8.000000},
		--LocalPoint      = {-8.0,3.0,-5.0},
		--AnglesDefault   = {-90.000000,-20.000000},
						--Left/right	up/down	front/back
		LocalPoint      = {-8.0,3.0,-4.0},
		AnglesDefault   = {-60.000000,-30.000000},

	}, -- Chase 

	Arcade = {
		LocalPoint      = {-20.000000,5.000000,0.000000},
		AnglesDefault   = {0.000000,-8.000000},
	}, -- Arcade 

}



SnapViews = {
[1] = {-- player slot 1
	[1] = {
		viewAngle = 70.611748,--FOV
		hAngle	 = -1.240272,
		vAngle	 = 0.850250,
		x_trans	 = 0.164295,
		y_trans	 = -0.074373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[2] = {
		viewAngle = 32.704346,--FOV
		hAngle	 = 25.696522,
		vAngle	 = -34.778103,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,

	},

	[3] = {
		viewAngle = 32.704346,--FOV
		hAngle	 = 0.000000,
		vAngle	 = -47.845268,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[4] = {
		viewAngle = 36.106045,--FOV
		hAngle	 = -28.878576,
		vAngle	 = -36.780628,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[5] = {
		viewAngle = 88.727844,--FOV
		hAngle	 = 128.508865,
		vAngle	 = 13.131046,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[6] = {
		viewAngle = 41.928593,--FOV
		hAngle	 = 0.000000,
		vAngle	 = -4.630446,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[7] = {
		viewAngle = 88.727844,--FOV
		hAngle	 = -128.508865,
		vAngle	 = 13.131046,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[8] = {
		viewAngle = 88.727844,--FOV
		hAngle	 = 81.648369,
		vAngle	 = -9.500000,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[9] = {
		viewAngle = 88.727844,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 34.180634,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[10] = {
		viewAngle = 88.727844,--FOV
		hAngle	 = -80.997551,
		vAngle	 = -9.500000,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

	[11] = {--look at left  mirror
		viewAngle = 56.032040,--FOV
		hAngle	 = 14.803060,
		vAngle	 = 3.332499,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,

	},

	[12] = {--look at right mirror
		viewAngle = 56.032040,--FOV
		hAngle	 = -14.414484,
		vAngle	 = 3.332499,
		x_trans	 = 0.264295,
		y_trans	 = -0.064373,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,

	},

	[13] = {--default view
		viewAngle = 75.000000,-- FOV when spawning in pit (auto dezoom) (FOV arrivée Cockpit (une fois dézoom fait par DCS) ) 95
		hAngle	 = 0.000000,
		vAngle	 = -13.000000, -- horizontal cockpit view (Vue horizontale cockpit) -10
		x_trans	 = 0,
		y_trans	 = 0,  -- base height of the cockpit view (Hauteur de base de la vue cockpit)
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},

},

}
