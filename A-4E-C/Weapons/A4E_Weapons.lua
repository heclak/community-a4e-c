-- Weapons definitions here

dofile("Scripts/Database/Weapons/warheads.lua")


print("WEAPON TEST")
-- Support Functions:

local GALLON_TO_KG = 3.785 * 0.8
local INCHES_TO_M = 0.0254
local POUNDS_TO_KG = 0.453592

---------FUEL TANKS-----------
declare_loadout(	--400 gal tank
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-400gal}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel400.png",
		displayName		= _("Fuel Tank 400 gallons"),
		Weight_Empty	= 240*POUNDS_TO_KG,                         -- "bobtail" configuration
		Weight			= 240*POUNDS_TO_KG + 400*GALLON_TO_KG,
		Cx_pil			= 0.0020,
		shape_table_data =
		{
			{
				name 	= "DFT_400_GAL_A4E",
				file	= "DFT_400gal_a4e";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_400_GAL_A4E";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_400_GAL_A4E",
			},
		},
	}
)

declare_loadout(	--300 gal tank
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-300gal}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel300.png",
		displayName		= _("Fuel Tank 300 gallons"),
		Weight_Empty	= 183*POUNDS_TO_KG,                       -- 2 fin configuration
		Weight			= 183*POUNDS_TO_KG + 300*GALLON_TO_KG,
		Cx_pil			= 0.0015,
		shape_table_data =
		{
			{
				name 	= "DFT_300_GAL_A4E",
				file	= "DFT_300gal_a4e_C";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_300_GAL_A4E";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_300_GAL_A4E",
			},
		},
	}
)

declare_loadout(	--300 gal tank LEFT RIGHT
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-300gal_LR}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel300.png",
		displayName		= _("Fuel Tank 300 gallons"),
		Weight_Empty	= 199*POUNDS_TO_KG,                       -- 2 fin configuration
		Weight			= 199*POUNDS_TO_KG + 300*GALLON_TO_KG,
		Cx_pil			= 0.0014,
		shape_table_data =
		{
			{
				name 	= "DFT_300_GAL_A4E_LR",
				file	= "DFT_300gal_a4e_LR";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_300_GAL_A4E_LR";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_300_GAL_A4E_LR",
			},
		},
	}
)

declare_loadout(	--150 gal tank
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-150gal}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel150.png",
		displayName		= _("Fuel Tank 150 gallons"),
		Weight_Empty	= 136*POUNDS_TO_KG,
		Weight			= 136*POUNDS_TO_KG + 150*GALLON_TO_KG,
		Cx_pil			= 0.0010,
		shape_table_data =
		{
			{
				name 	= "DFT_150_GAL_A4E",
				file	= "DFT_150gal_a4e";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_150_GAL_A4E";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_150_GAL_A4E",
			},
		},
	}
)

---------EMPTY FUEL TANKS-----------
declare_loadout(	--400 gal tank
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-400gal_EMPTY}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel400.png",
		displayName		= _("Fuel Tank 400 gallons (EMPTY)"),
		Weight_Empty	= 240*POUNDS_TO_KG,                         -- "bobtail" configuration
		Weight			= 240*POUNDS_TO_KG + 400*GALLON_TO_KG,
		Cx_pil			= 0.0020,
		shape_table_data =
		{
			{
				name 	= "DFT_400_GAL_A4E_EMPTY",
				file	= "DFT_400gal_a4e";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_400_GAL_A4E_EMPTY";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_400_GAL_A4E",
			},
		},
	}
)

declare_loadout(	--300 gal tank
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-300gal_EMPTY}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel300.png",
		displayName		= _("Fuel Tank 300 gallons (EMPTY)"),
		Weight_Empty	= 183*POUNDS_TO_KG,                       -- 2 fin configuration
		Weight			= 183*POUNDS_TO_KG + 300*GALLON_TO_KG,
		Cx_pil			= 0.0015,
		shape_table_data =
		{
			{
				name 	= "DFT_300_GAL_A4E_EMPTY",
				file	= "DFT_300gal_a4e_C";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_300_GAL_A4E_EMPTY";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_300_GAL_A4E",
			},
		},
	}
)

declare_loadout(	--300 gal tank LEFT RIGHT
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-300gal_LR_EMPTY}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel300.png",
		displayName		= _("Fuel Tank 300 gallons (EMPTY)"),
		Weight_Empty	= 199*POUNDS_TO_KG,                       -- 2 fin configuration
		Weight			= 199*POUNDS_TO_KG + 300*GALLON_TO_KG,
		Cx_pil			= 0.0014,
		shape_table_data =
		{
			{
				name 	= "DFT_300_GAL_A4E_LR_EMPTY",
				file	= "DFT_300gal_a4e_LR";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_300_GAL_A4E_LR_EMPTY";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_300_GAL_A4E_LR",
			},
		},
	}
)

declare_loadout(	--150 gal tank
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{DFT-150gal_EMPTY}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "fuel150.png",
		displayName		= _("Fuel Tank 150 gallons (EMPTY)"),
		Weight_Empty	= 136*POUNDS_TO_KG,
		Weight			= 136*POUNDS_TO_KG + 150*GALLON_TO_KG,
		Cx_pil			= 0.0010,
		shape_table_data =
		{
			{
				name 	= "DFT_150_GAL_A4E_EMPTY",
				file	= "DFT_150gal_a4e";
				life	= 1;
				fire	= { 0, 1};
				username	= "DFT_150_GAL_A4E_EMPTY";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "DFT_150_GAL_A4E",
			},
		},
	}
)


declare_loadout(	--D-704 BUDDY POD
	{
		category		= CAT_FUEL_TANKS,
		CLSID			= "{D-704_BUDDY_POD}",
		attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
		Picture			= "d-704.png",
		displayName		= _("D-704 Refueling Pod"),
		Weight_Empty	= 719*POUNDS_TO_KG,
		Weight			= 719*POUNDS_TO_KG + 300*GALLON_TO_KG,
		Cx_pil			= 0.0030,
		shape_table_data =
		{
			{
				name 	= "D-704_POD_A4E",
				file	= "D-704_pod_A4E";
				life	= 1;
				fire	= { 0, 1};
				username	= "D-704_POD_A4E";
				index	= WSTYPE_PLACEHOLDER;
			},
		},
		Elements	=
		{
			{
				ShapeName	= "D-704_POD_A4E",
			},
		},
	}
)


---------AIR AIR--------------
--[[
local AIM9B_WPN =   {
		category		= CAT_AIR_TO_AIR,
		name			= "AIM-9B", --[Checked]
		user_name		= _("AIM-9B"),
		wsTypeOfWeapon 	= {wsType_Weapon,wsType_Missile,wsType_AA_Missile,WSTYPE_PLACEHOLDER},
        Escort = 0,
        Head_Type = 1,
		sigma = {3, 3, 3},
        M = 74.3991, -- http://www.alternatewars.com/SAC/AIM-9B_Sidewinder_1A_SMC_-_January_1972.pdf [CHECKED]
        H_max = 18000.0, --Max operational height in (?)
        H_min = -1,
        Diam = 127.0, --Checked
        Cx_pil = 2.58,
        D_max = 4000.0,
        D_min = 300.0,
        Head_Form = 0,
        Life_Time = 30.0, --How long missile lasted before it exploded(?)
        Nr_max = 10, --Max turn acceleration
        v_min = 140.0,
        v_mid = 350.0, --Average Speed
        Mach_max = 2.2,
        t_b = 0.0, --Time of motor switch on
        t_acc = 2.2, -- LB 3880 of thrust, SEC: 2.2 | [Checked]
        t_marsh = 0.0, --
        Range_max = 11000.0,
        H_min_t = 1.0, --Min altitude above ground
        Fi_start = 0.3,
        Fi_rak = 3.14152,
        Fi_excort = 0.79,
        Fi_search = 0.09,
        OmViz_max = 0.2, --limit speed of sight line
        --warhead = warheads["AIM_9"],
		warhead = simple_aa_warhead(10.0),
        exhaust 		=  { 1, 1, 1, 1 },
        X_back = -1.455,
        Y_back = -0.062,
        Z_back = 0,
        Reflection = 0.0182,
        KillDistance = 7.0,

		--seeker sensivity params
		SeekerSensivityDistance = 20000, -- The range of target with IR value = 1. In meters. In forward hemisphere.
		SeekerCooled			= true, -- True is cooled seeker and false is not cooled seeker.

		shape_table_data =
		{
			{
				name	 = "AIM9B-SHAPE",
				file	 = "aim-9b", 	--fichier .EDM  Bazar/World/Shapes
				life	 = 1,
				fire	 = { 0, 1},
				username = "AIM-9B", 	--label
				index = WSTYPE_PLACEHOLDER,
			},
		},

		ModelData = {   58 ,  -- model params count
						0.35 ,   -- characteristic square (характеристическая площадь)

						-- параметры зависимости Сx
						0.04 , -- Cx_k0 планка Сx0 на дозвуке ( M << 1)
						0.08 , -- Cx_k1 высота пика волнового кризиса
						0.02 , -- Cx_k2 крутизна фронта на подходе к волновому кризису
						0.05, -- Cx_k3 планка Cx0 на сверхзвуке ( M >> 1)
						1.2 , -- Cx_k4 крутизна спада за волновым кризисом
						1.2 , -- коэффициент отвала поляры (пропорционально sqrt (M^2-1))

						-- параметры зависимости Cy
						0.5 , -- Cy_k0 планка Сy0 на дозвуке ( M << 1)
						0.4	 , -- Cy_k1 планка Cy0 на сверхзвуке ( M >> 1)
						1.2  , -- Cy_k2 крутизна спада(фронта) за волновым кризисом

						0.29 , -- 7 Alfa_max  максимальный балансировачный угол, радианы
						0.0, --угловая скорость создаваймая моментом газовых рулей

					-- Engine data. Time, fuel flow, thrust.
					--	t_statr		t_b		t_accel		t_march		t_inertial		t_break		t_end			-- Stage
						-1.0,		-1.0,	2.2, 		0.0,		0.0,			0.0,		1.0e9,         -- time of stage, sec
						 0.0,		0.0,	8.453,		0.0,		0.0,			0.0,		0.0,           -- fuel flow rate in second, kg/sec(секундный расход массы топлива кг/сек)
						 0.0,		0.0,	17800.0,	0.0,	    0.0,			0.0,		0.0,           -- thrust, newtons

						 25.0, -- таймер самоликвидации, сек
						 18.0, -- время работы энергосистемы, сек
						 0, -- абсолютная высота самоликвидации, м
						 2.0, -- время задержки включения управления (маневр отлета, безопасности), сек
						 1.0e9, -- дальность до цели в момент пуска, при превышении которой ракета выполняется маневр "горка", м
						 1.0e9, -- дальность до цели, при которой маневр "горка" завершается и ракета переходит на чистую пропорциональную навигацию (должен быть больше или равен предыдущему параметру), м
						 0.0,  -- синус угла возвышения траектории набора горки
						 30.0, -- продольное ускорения взведения взрывателя
						 0.0, -- модуль скорости сообщаймый катапультным устройством, вышибным зарядом и тд
						 1.19, -- характристика системы САУ-РАКЕТА,  коэф фильтра второго порядка K0
						 1.0, -- характристика системы САУ-РАКЕТА,  коэф фильтра второго порядка K1
						 2.0, -- характристика системы САУ-РАКЕТА,  полоса пропускания контура управления
						 0.0,
						 0.0,
						 0.0,
						 0.0,
						 0.0,
						 -- DLZ. Данные для рассчета дальностей пуска (индикация на прицеле)
						 9000.0, -- дальность ракурс   180(навстречу) град,  Н=10000м, V=900км/ч, м
						 4000.0, -- дальность ракурс 0(в догон) град,  Н=10000м, V=900км/ч, м
						 4000.0, -- дальность ракурс 	180(навстречу) град, Н=1000м, V=900км/ч, м
						 0.2, -- Уменьшение разрешенной дальности пуска при отклонении вектора скорости носителя от линии визирования цели.
						 1.0, -- Вертикальная плоскость. Наклон кривой разрешенной дальности пуска в нижнюю полусферу. Уменьшение дальности при стрельбе вниз.
						 1.4, -- Вертикальная плоскость. Наклон кривой разрешенной дальности пуска в верхнюю полусферу. Увеличение дальности при стрельбе вверх.
						-3.0, -- Вертикальная плоскость. Угол перегиба кривой разрешенной дальности, верхняя - нижняя полусфера.
						0.5, -- Изменение коэффициентов наклона кривой в верхнюю и нижнюю полусферы от высоты носителя.
					},
}
declare_weapon(AIM9B_WPN)


---------AIR TO AIR-------------
declare_loadout({	--AIM-9B
	category		=	CAT_AIR_TO_AIR,
	CLSID			= 	"{AIM-9B}",
	Picture			=	"aim9p.png",
	wsTypeOfWeapon	=	AIM9B_WPN.wsTypeOfWeapon,
	displayName		=	_("AIM-9B"),
	attribute		=	{4,	4,	32,	WSTYPE_PLACEHOLDER},
	Cx_pil			=	0.001959765625,
	Count			=	1,
	Weight			=	100,
	Elements	=
	{
		{	ShapeName	=	"AIM9B-SHAPE" ,	Position	=	{0,-0.124918,0}}, --name of the shape_table_data
	}, -- end of Elements
})
--]]

---------MISSILES-------------
--[[
declare_loadout({	--AGM 45 SHRIKE
	category	=	CAT_MISSILES,
	CLSID	=	"{AGM45_SHRIKE}",
	Picture	=	"agm45.png",
	wsTypeOfWeapon	=	{wsType_Weapon,wsType_Missile,wsType_AS_Missile, 60},
	displayName	=	_("AGM-45B"),
	attribute	=	{4,	4,	8,	60},
	Cx_pil	=	0.0007,
	Count	=	1,
	Weight	=	39.5 + 181, --AERO-5 + AGM 45
	Elements	=
	{
		{	ShapeName	=	"AGM-45" , Position	=	{0,	-0.22,	0} }, --{0,	-0.22,	0}
	}, -- end of Elements
})
--]]

---------ROCKETS--------------
declare_loadout({	--TER LAU-61
				category=	CAT_ROCKETS,
				CLSID	=	"{TER,LAU-61*3}",
				Picture	=	"LAU61.png",
				wsTypeOfWeapon	=	{wsType_Weapon, wsType_NURS, wsType_Rocket,	145},
				displayName	=	_("3*LAU-61"),
				--attribute	=	{4,	7,	32,	9},
				attribute	=	{wsType_Weapon,	wsType_NURS, wsType_Container,	9},
				Cx_pil	=	0.002,
				Count	=	57,
				Weight	=	98,
				Elements	=
				{
					[1]	=
					{
						Position	=	{0,	0,	0},
						ShapeName	=	"BRU-42_LS",
						IsAdapter 	= 	true,
					},
					[2]	=
					{
						DrawArgs	=
						{
							[1]	=	{1,	1},
							[2]	=	{2,	1},
						}, -- end of DrawArgs
						Position	=	{0,	-0.35,	0},
						ShapeName	=	"LAU-61",
					},
					[3]	=
					{
						DrawArgs	=
						{
							[1]	=	{1,	1},
							[2]	=	{2,	1},
						}, -- end of DrawArgs
						Position	=	{0,	-0.13,	0.1253},
						ShapeName	=	"LAU-61",
						Rotation	= 	{-45,0,0},
					},
					[4]	=
					{
						DrawArgs	=
						{
							[1]	=	{1,	1},
							[2]	=	{2,	1},
						}, -- end of DrawArgs
						Position	=	{0,	-0.13,	-0.125},
						ShapeName	=	"LAU-61",
						Rotation	= 	{45,0,0},
					},
				}, -- end of Elements
})


---------HIPEG----------------

--[[
References:  AD427049, AD601655, AD306170

Mk 4 Mod 0 gun pod fitted with Mk 11 Mod 5 20mm cannon and 750 rds ammunition
Fires Mk 100-series (Mk 101 to Mk 109) ammunition (20x110mm)
4200 rds/min per pod, twin barrel
22-1/2" in diameter, 16-1/2' long, weighs 1350 pounds loaded

3 pod total:
12,600 rounds/minute, 2250 total rounds of ammunition
--]]

    local tracer_on_time = 0.01
    local barrel_smoke_level = 1.0
    local barrel_smoke_opacity = 0.1

    -- Mk 106 mod 0 - 20x110mm High Explosive - Incendiary
    mk106mod0 = {
        category = CAT_SHELLS, name = "20x110mm HE-I", user_name = _("20x110mm HE-I"),
        model_name      = "tracer_bullet_white",
        mass            = 0.110,
        round_mass      = 0.268,
        cartridge_mass  = 0.158,    -- cartridges retained
        explosive       = 0.050,
        v0              = 1012.0,   -- 3350 fps
        Dv0             = 0.0060,
        Da0             = 0.0022,
        Da1             = 0.0,
        life_time       = 30,
        caliber         = 20.0,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {0.5,1.27,0.70,0.200,2.30},
        k1              = 2.0e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity
    }
    declare_weapon(mk106mod0)

    -- Mk 107 mod 0 - 20x110mm Armor Piercing - Incendiary
    mk107mod0 = {
        category = CAT_SHELLS, name = "20x110mm AP-I", user_name = _("20x110mm AP-I"),
        model_name      = "tracer_bullet_white",
        mass            = 0.110,
        round_mass      = 0.268,
        cartridge_mass  = 0.158,    -- cartridges retained
        explosive       = 0.000,
        v0              = 1012.0,   -- 3350 fps
        Dv0             = 0.0060,
        Da0             = 0.0022,
        Da1             = 0.0,
        life_time       = 30,
        caliber         = 20.0,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {0.5,1.27,0.70,0.200,2.30},
        k1              = 2.0e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity
    }
    declare_weapon(mk107mod0)

    -- Mk 108 mod 0 - 20x110mm Armor Piercing - Tracer
    mk108mod0 = {
        category = CAT_SHELLS, name = "20x110mm AP-T", user_name = _("20x110mm AP-T"),
        model_name      = "tracer_bullet_yellow",
        mass            = 0.110,
        round_mass      = 0.268,
        cartridge_mass  = 0.158,    -- cartridges retained
        explosive       = 0.000,
        v0              = 1012.0,   -- 3350 fps
        Dv0             = 0.0060,
        Da0             = 0.0022,
        Da1             = 0.0,
        life_time       = 30,
        caliber         = 20.0,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {0.5,1.27,0.70,0.200,2.30},
        k1              = 2.0e-08,
        tracer_off      = 1.7,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 1.7,
        scale_tracer    = 1,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity
    }
    declare_weapon(mk108mod0)


    -- Mk 11 mod 5 gun used in Mk 4 mod 0 gun pod
function Mk11mod0(tbl)
    tbl.category = CAT_GUN_MOUNT
    tbl.name      = "Mk11mod0"
    tbl.supply      =
    {
        shells = {"20x110mm HE-I", "20x110mm AP-I", "20x110mm AP-T"},
        mixes  = {{1,2,1,3}},   -- 50% HE-i, 25% AP-I, 25% AP-T
        count  = 750,
    }
    if tbl.mixes then
       tbl.supply.mixes = tbl.mixes
       tbl.mixes        = nil
    end
    tbl.gun =
    {
        max_burst_length    = 25,
        rates               = {4200},
        recoil_coeff        = 0.7*1.3,
        barrels_count       = 2,
    }
    if tbl.rates then
       tbl.gun.rates        =  tbl.rates
       tbl.rates            = nil
    end
    tbl.ejector_pos             = tbl.ejector_pos or {0, 0, 0}
    tbl.ejector_pos_connector   = tbl.ejector_pos_connector     or  "Gun_point"
    tbl.ejector_dir             = {-1, -6, 0} -- left/right; back/front;?/?
    tbl.supply_position         = tbl.supply_position   or {0,  0.3, -0.3}
    tbl.aft_gun_mount           = false
    tbl.effective_fire_distance = 1500
    tbl.drop_cartridge          = 204
    tbl.muzzle_pos              = tbl.muzzle_pos            or  {2.5,-0.4,0}     -- all position from connector
    tbl.muzzle_pos_connector    = tbl.muzzle_pos_connector  or  "Gun_point" -- all position from connector
    tbl.azimuth_initial         = tbl.azimuth_initial       or  0
    tbl.elevation_initial       = tbl.elevation_initial     or  0
    if  tbl.effects == nil then
        tbl.effects = {{ name = "FireEffect"     , arg = tbl.effect_arg_number or 436 },
                       { name = "HeatEffectExt"  , shot_heat = 7.823, barrel_k = 0.462 * 2.7, body_k = 0.462 * 14.3 },
                       { name = "SmokeEffect"}}
    end
    return declare_weapon(tbl)
end

mk4hipeg = {
    category        = CAT_PODS,
    CLSID           = "{Mk4 HIPEG}",
    attribute       = {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
    Picture         = "hipeg.png",
    displayName     = _("Mk4 HIPEG"),
    Weight          = 612.35,      -- 1350lb/612.35kg loaded (incl. 201kg of ammunition)
    Cx_pil          = 0.001220703125,
    Elements        = {{ShapeName = "A4E_Mk4_HIPEG"}},
    kind_of_shipping = 2,   -- SOLID_MUNITION
    gun_mounts      = {
        Mk11mod0({
            muzzle_pos_connector = "Point_Gun",
            rates = {4200}, mixes = {{1,2,1,3}},
            effect_arg_number = 1050,
            azimuth_initial = 0,
            elevation_initial = 0,
            supply_position = {2, -0.3, -0.4}})
    },
    shape_table_data = {{file = 'A4E_Mk4_HIPEG'; username = 'MK4 HIPEG'; index = WSTYPE_PLACEHOLDER;}}
}
declare_loadout(mk4hipeg)

---------BOMBS----------------
mk77mod0 =
{
	category  		= CAT_BOMBS,
	name      		= "MK77mod0-WPN",
	model     		= "A4E_Mk77mod0",
	user_name 		= _("Mk-77 mod 0"),
	wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_Fire, WSTYPE_PLACEHOLDER},
	scheme    		= "bomb-common",
	class_name		= "wAmmunitionBallute",
	type      		= 0,
	mass      		= 340,
	hMin      		= 10,
	hMax      		= 12000.0,
	Cx        		= 0.0030,
	VyHold    		= -100.0,
	Ag        		= -1.23,
	fm = {
            mass            = 340,
            caliber         = 0.2730000,
            cx_coeff        = {1.000000, 0.320000, 0.710000, 0.150000, 1.280000},
			cx_factor   	= 1,
            L               = 1.05,
            I               = 33.282267,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
	},
	control =
    {
        open_delay = 0.2,
    },
	warhead 		 = simple_warhead(300),-- 300 kg of explosive, based on 110 US gallons
	shape_table_data =
	{
		{
			file     = "A4E_Mk77mod0",
			index    = WSTYPE_PLACEHOLDER,
		},
	},
	targeting_data =
	{
		v0 = 200,
		data =
		{
			{1.000000, 21.147949, 0.002807},
			{10.000000, 28.262668, -0.017193},
			{20.000000, 29.687629, -0.016767},
			{30.000000, 30.394407, -0.015892},
			{40.000000, 30.826322, -0.015080},
			{50.000000, 31.133114, -0.014428},
			{60.000000, 31.361560, -0.013889},
			{70.000000, 31.543970, -0.013440},
			{80.000000, 31.690640, -0.013045},
			{90.000000, 31.814418, -0.012713},
			{100.000000, 31.920050, -0.012425},
			{200.000000, 32.511629, -0.010723},
			{300.000000, 32.789778, -0.009863},
			{400.000000, 32.963413, -0.009307},
			{500.000000, 33.086372, -0.008907},
			{600.000000, 33.179450, -0.008596},
			{700.000000, 33.253103, -0.008346},
			{800.000000, 33.312920, -0.008139},
			{900.000000, 33.362577, -0.007968},
			{1000.000000, 33.404350, -0.007824},
			{1100.000000, 33.439925, -0.007702},
			{1200.000000, 33.470498, -0.007599},
			{1300.000000, 33.496988, -0.007513},
			{1400.000000, 33.520106, -0.007440},
			{1500.000000, 33.540403, -0.007378},
			{1600.000000, 33.558365, -0.007327},
			{1700.000000, 33.574326, -0.007285},
			{1800.000000, 33.588629, -0.007251},
			{1900.000000, 33.601489, -0.007224},
			{2000.000000, 33.613137, -0.007202},
			{3000.000000, 33.690673, -0.007191},
			{4000.000000, 33.737805, -0.007357},
			{5000.000000, 33.773738, -0.007590},
			{6000.000000, 33.802367, -0.007864},
			{7000.000000, 33.824277, -0.008170},
			{8000.000000, 33.839206, -0.008505},
			{9000.000000, 33.846586, -0.008868},
			{10000.000000, 33.845625, -0.009258},
		}
	},
}
declare_weapon(mk77mod0)

declare_loadout({
	category 		= CAT_BOMBS,
	CLSID	 		= "{mk77mod0}",
	attribute		= mk77mod0.wsTypeOfWeapon,
	Count 			= 1,
	Cx_pil			= mk77mod0.Cx,
	Picture			= "mk77mod0.png",
	displayName		= mk77mod0.user_name,
	Weight			= mk77mod0.mass,
	Elements  		=
	{
		{
		Position	=	{0,	0,	0},
		ShapeName = mk77mod0.model
		}
	},
})



mk77mod1 =
{
    category  		= CAT_BOMBS,
    name      		= "MK77mod1-WPN",
    model     		= "A4E_Mk77mod1",
    user_name 		= _("Mk-77 mod 1"),
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_Fire, WSTYPE_PLACEHOLDER},
    scheme    		= "bomb-common",
    class_name		= "wAmmunitionBallute",
    type      		= 0,
    mass      		= 230,
    hMin      		= 10,
    hMax      		= 12000.0,
    Cx        		= 0.0030,
    VyHold    		= -100.0,
    Ag        		= -1.23,
    fm = {
            mass            = 230,
            caliber         = 0.2730000,
            cx_coeff        = {1.000000, 0.320000, 0.710000, 0.150000, 1.280000},
            cx_factor   	= 1,
            L               = 1.05,
            I               = 33.282267,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
    },
    control =
    {
        open_delay = 0.2,
    },
    warhead 		 = simple_warhead(220),-- 220 kg of fuel
    shape_table_data =
    {
        {
            file     = "A4E_Mk77mod1",
            index    = WSTYPE_PLACEHOLDER,
        },
    },
    targeting_data =
    {
        v0 = 200,
        data =
        {
            {1.000000, 21.147949, 0.002807},
            {10.000000, 28.262668, -0.017193},
            {20.000000, 29.687629, -0.016767},
            {30.000000, 30.394407, -0.015892},
            {40.000000, 30.826322, -0.015080},
            {50.000000, 31.133114, -0.014428},
            {60.000000, 31.361560, -0.013889},
            {70.000000, 31.543970, -0.013440},
            {80.000000, 31.690640, -0.013045},
            {90.000000, 31.814418, -0.012713},
            {100.000000, 31.920050, -0.012425},
            {200.000000, 32.511629, -0.010723},
            {300.000000, 32.789778, -0.009863},
            {400.000000, 32.963413, -0.009307},
            {500.000000, 33.086372, -0.008907},
            {600.000000, 33.179450, -0.008596},
            {700.000000, 33.253103, -0.008346},
            {800.000000, 33.312920, -0.008139},
            {900.000000, 33.362577, -0.007968},
            {1000.000000, 33.404350, -0.007824},
            {1100.000000, 33.439925, -0.007702},
            {1200.000000, 33.470498, -0.007599},
            {1300.000000, 33.496988, -0.007513},
            {1400.000000, 33.520106, -0.007440},
            {1500.000000, 33.540403, -0.007378},
            {1600.000000, 33.558365, -0.007327},
            {1700.000000, 33.574326, -0.007285},
            {1800.000000, 33.588629, -0.007251},
            {1900.000000, 33.601489, -0.007224},
            {2000.000000, 33.613137, -0.007202},
            {3000.000000, 33.690673, -0.007191},
            {4000.000000, 33.737805, -0.007357},
            {5000.000000, 33.773738, -0.007590},
            {6000.000000, 33.802367, -0.007864},
            {7000.000000, 33.824277, -0.008170},
            {8000.000000, 33.839206, -0.008505},
            {9000.000000, 33.846586, -0.008868},
            {10000.000000, 33.845625, -0.009258},
        }
    },
}
declare_weapon(mk77mod1)


declare_loadout({
	category 		= CAT_BOMBS,
	CLSID	 		= "{mk77mod1}",
	attribute		= mk77mod1.wsTypeOfWeapon,
	Count 			= 1,
	Cx_pil			= mk77mod1.Cx,
	Picture			= "mk77mod1.png",
	displayName		= mk77mod1.user_name,
	Weight			= mk77mod1.mass,
	Elements  		=
	{
		{
		Position	=	{0,	0,	0},
		ShapeName = mk77mod1.model
		}
	},
})


-- Mk-81 Snakeye   -- 250lb retarded GP HE bomb
-- 250# total weight, 96# of tritonal
MK_81SE = {
    category        = CAT_BOMBS,
    name            = "MK-81SE",
    user_name       = _("Mk-81SE"),
    model           = "A4E_MK-81SE",
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
    scheme          = "bomb-parashute",
    class_name      = "wAmmunitionBallute",
    type            = 0,
    mass            = 250 * POUNDS_TO_KG,
    hMin            = 300.0,
    hMax            = 12000.0,
    Cx              = 0.00018,
    VyHold          = -100.0,
    Ag              = -1.23,
    fm              = {
        mass        = 113.4,    -- Empty weight with warhead, W/O fuel, kg  (115 lb)
        caliber     = 0.2286,  -- Calibre, meters (8.2")
        cx_coeff    = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},  -- Cx
        L           = 1.8796,   -- Length, meters (36")
        I           = 33.3853,   -- kgm2 - moment of inertia - I = 1/12 ML2
        Ma          = 2.746331,  -- dependence moment coefficient of  by  AoA angular acceleration  T / I   (??? can't solve for torque w/o knowing rotation)
        Mw          = 2.146083, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t   (???)
        wind_sigma  = 80, -- dispersion coefficient  mk81=80, mk82=80, mk83=150, mk84=220 ... heavier = harder to push with wind?
        cx_factor   = 100,
    },
    warhead         = warheads["Mk_81"],
    control =
    {
        open_delay = 0.2,
    },
    shape_table_data = {
        {
            name    = "MK-81SE";
            file    = "A4E_MK-81SE";
            life    = 1;
            fire    = {0, 1};
            username = "Mk-81SE";
            index   = WSTYPE_PLACEHOLDER;
        },
    },
    targeting_data  = {
        char_time   = 20.60, -- characteristic time for sights
    },
}

declare_weapon(MK_81SE)

declare_loadout({
	category 		= CAT_BOMBS,
	CLSID	 		= "{MK-81SE}",
	attribute		= MK_81SE.wsTypeOfWeapon,
	Count 			= 1,
	Cx_pil			= MK_81SE.Cx,
	Picture			= "mk81se.png",
	displayName		= MK_81SE.user_name,
	Weight			= MK_81SE.mass,
	Elements  		=
	{
		{
		Position	=	{0,	0,	0},
		ShapeName = MK_81SE.model
		}
	},
})


-- AN-M66A2     -- 2000lb GP HE bomb, WW2 era
-- 2140.0# total weight, 1142# Comp. B filler
AN_M66A2 = {
    category        = CAT_BOMBS,
    name            = "AN-M66A2",
    user_name       = _("AN-M66A2"),
    model           = "A4E_AN-M66",
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
    scheme          = "bomb-common",
    type            = 0,
    mass            = 2140.0 * POUNDS_TO_KG,
    hMin            = 300.0,
    hMax            = 12000.0,
    Cx              = 0.00124,
    VyHold          = -100.0,
    Ag              = -1.23,
    fm              = {
        mass        = 970.7,    -- Empty weight with warhead, W/O fuel, kg
        caliber     = 0.59182,  -- Calibre, meters
        cx_coeff    = {1.000000, 0.390000, 0.380000, 0.236000, 1.310000}, -- Cx
        L           = 2.29616,  -- Length, meters
        I           = 426.4835, -- kgm2 - moment of inertia - I = 1/12 ML2
        Ma          = 2.746331,  -- dependence moment coefficient of  by  AoA angular acceleration  T / I   (??? can't solve for torque w/o knowing rotation)
        Mw          = 2.146083, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t   (???)
        wind_sigma  = 220, -- dispersion coefficient  mk81=80, mk82=80, mk83=150, mk84=220 ... heavier = harder to push with wind?
        cx_factor   = 100,
    },
    warhead         = {
        mass        = 2140.0 * POUNDS_TO_KG;
        expl_mass   = 1142.0 * POUNDS_TO_KG;
        other_factors = {1.0, 1.0, 1.0};
        obj_factors = {1, 1};
        concrete_factors = {1.0, 1.0, 1.0};
        cumulative_factor = 1;
        concrete_obj_factor = 1.0;
        cumulative_thickness = 1.0;
        piercing_mass = 1.0;
        caliber     = 59.182;   -- centimeters
    },
    shape_table_data = {
        {
            name    = "AN_M66A2";
            file    = "A4E_AN-M66";
            life    = 1;
            fire    = {0, 1};
            username = "AN-M66A2";
            index   = WSTYPE_PLACEHOLDER;
        },
    },
    targeting_data  = {
        char_time   = 20.60, -- characteristic time for sights
    },
}

declare_weapon(AN_M66A2)
declare_loadout({
    category        = CAT_BOMBS,
    CLSID           = "{AN-M66A2}",
    attribute       = AN_M66A2.wsTypeOfWeapon,
    Count           = 1,
    Cx_pil          = AN_M66A2.Cx,
    Picture         = "an-m66a2.png",
    displayName     = AN_M66A2.user_name,
    Weight          = AN_M66A2.mass,
    Elements        =
    {
        {
        Position    = {0, 0, 0},
        ShapeName   = AN_M66A2.model
        }
    },
})
-- end of AN-M66A2


-- AN-M81     -- 260lb HE fragmentation bomb, WW2 era
-- 260.0# total weight, 34.1# Comp. B filler
AN_M81 = {
    category        = CAT_BOMBS,
    name            = "AN-M81",
    user_name       = _("AN-M81"),
    model           = "A4E_AN-M81",
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
    scheme          = "bomb-common",
    type            = 0,
    mass            = 260.0 * POUNDS_TO_KG,
    hMin            = 300.0,
    hMax            = 12000.0,
    Cx              = 0.000124,
    Cx_pil          = 0.0,
    VyHold          = -100.0,
    Ag              = -1.23,
    fm              = {
        mass        = 117.9,    -- Empty weight with warhead, W/O fuel, kg
        caliber     = 0.2032,   -- Calibre, meters
        cx_coeff    = {1.000000, 0.390000, 0.380000, 0.236000, 1.310000}, -- Cx
        L           = 1.10998,  -- Length, meters
        I           = 12.1084,  -- kgm2 - moment of inertia - I = 1/12 ML2
        Ma          = 2.746331, -- dependence moment coefficient of  by  AoA angular acceleration  T / I   (??? can't solve for torque w/o knowing rotation)
        Mw          = 2.146083, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t   (???)
        wind_sigma  = 50, -- dispersion coefficient  mk81=80, mk82=80, mk83=150, mk84=220 ... heavier = harder to push with wind?
        cx_factor   = 100,
    },
    warhead         = {
        mass        = 260.0 * POUNDS_TO_KG;
        expl_mass   = 34.1 * POUNDS_TO_KG;
        other_factors = {1.0, 1.0, 1.0};
        obj_factors = {1, 1};
        concrete_factors = {1.0, 1.0, 1.0};
        cumulative_factor = 1;
        concrete_obj_factor = 1.0;
        cumulative_thickness = 1.0;
        piercing_mass = 1.0;
        caliber     = 20.32;   -- centimeters
    },
    shape_table_data = {
        {
            name    = "AN_M81";
            file    = "A4E_AN-M81";
            life    = 1;
            fire    = {0, 1};
            username = "AN-M81";
            index   = WSTYPE_PLACEHOLDER;
        },
    },
    targeting_data  = {
        char_time   = 20.60, -- characteristic time for sights
    },
}

declare_weapon(AN_M81)
declare_loadout({
    category        = CAT_BOMBS,
    CLSID           = "{AN-M81}",
    attribute       = AN_M81.wsTypeOfWeapon,
    Count           = 1,
    Cx_pil          = AN_M81.Cx,
    Picture         = "an-m81.png",
    displayName     = AN_M81.user_name,
    Weight          = AN_M81.mass,
    Elements        =
    {
        {
        Position    = {0, 0, 0},
        ShapeName = AN_M81.model
        }
    },
})
-- end of AN-M81


-- AN-M88     -- 216lb HE fragmentation bomb, WW2 era
-- 216.2# total weight, 46.69# Comp. B filler
AN_M88 = {
    category        = CAT_BOMBS,
    name            = "AN-M88",
    user_name       = _("AN-M88"),
    model           = "A4E_AN-M88",
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
    scheme          = "bomb-common",
    type            = 0,
    mass            = 216.2 * POUNDS_TO_KG,
    hMin            = 300.0,
    hMax            = 12000.0,
    Cx              = 0.000124,
    VyHold          = -100.0,
    Ag              = -1.23,
    fm              = {
        mass        = 98.1,    -- Empty weight with warhead, W/O fuel, kg
        caliber     = 0.2032,   -- Calibre, meters
        cx_coeff    = {1.000000, 0.390000, 0.380000, 0.236000, 1.310000}, -- Cx
        L           = 1.10998,  -- Length, meters
        I           = 10.0672,  -- kgm2 - moment of inertia - I = 1/12 ML2
        Ma          = 2.746331, -- dependence moment coefficient of  by  AoA angular acceleration  T / I   (??? can't solve for torque w/o knowing rotation)
        Mw          = 2.146083, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t   (???)
        wind_sigma  = 45, -- dispersion coefficient  mk81=80, mk82=80, mk83=150, mk84=220 ... heavier = harder to push with wind?
        cx_factor   = 100,
    },
    warhead         = {
        mass        = 216.2 * POUNDS_TO_KG;
        expl_mass   = 46.69 * POUNDS_TO_KG;
        other_factors = {1.0, 1.0, 1.0};
        obj_factors = {1, 1};
        concrete_factors = {1.0, 1.0, 1.0};
        cumulative_factor = 1;
        concrete_obj_factor = 1.0;
        cumulative_thickness = 1.0;
        piercing_mass = 1.0;
        caliber     = 20.32;   -- centimeters
    },
    shape_table_data = {
        {
            name    = "AN_M88";
            file    = "A4E_AN-M88";
            life    = 1;
            fire    = {0, 1};
            username = "AN-M88";
            index   = WSTYPE_PLACEHOLDER;
        },
    },
    targeting_data  = {
        char_time   = 20.60, -- characteristic time for sights
    },
}

declare_weapon(AN_M88)
declare_loadout({
    category        = CAT_BOMBS,
    CLSID           = "{AN-M88}",
    attribute       = AN_M88.wsTypeOfWeapon,
    Count           = 1,
    Cx_pil          = AN_M88.Cx,
    Picture         = "an-m88.png",
    displayName     = AN_M88.user_name,
    Weight          = AN_M88.mass,
    Elements        =
    {
        {
        Position    = {0, 0, 0},
        ShapeName = AN_M88.model
        }
    },
})
-- end of AN-M88

local cbu_mult = 5  -- multiply effect and divide count by X, for performance

-- BLU-3B   -- 1.75lb "pineapple" cluster munition used in CBU-2/A
-- ~1.3lb warhead of 250 steel pellets with 0.35lb RDX explosive
BLU_3B = {
    category        = CAT_BOMBS,
    name            = "BLU-3B",
    user_name       = _("BLU-3B"),
    model           = "A4E_BLU-3B",
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_Cluster, WSTYPE_PLACEHOLDER},
    scheme          = "bomb-parashute",
    class_name      = "wAmmunitionBallute",
    type            = 0,
    mass            = 1.75 * POUNDS_TO_KG * cbu_mult,
    hMin            = 500.0,
    hMax            = 12000.0,
    Cx              = 0.0, --this is the drag taken off the pod (must be zero since these bomblets are not in the airflow (mostly)).
    VyHold          = -100.0,
    Ag              = -1.23,
    fm              = {
        mass        = 1.75 * POUNDS_TO_KG * cbu_mult,    -- Empty weight with warhead, W/O fuel, kg
        caliber     = 0.07,  -- Calibre, meters (7cm / 2.75")
        cx_coeff    = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},  -- Cx
        L           = 0.095,   -- Length, meters (95mm / 3.75")
        I           = 0.004,   -- kgm2 - moment of inertia - I = 1/12 ML2
        Ma          = 1.5,  -- dependence moment coefficient of  by  AoA angular acceleration  T / I   (??? can't solve for torque w/o knowing rotation)
        Mw          = 1.0, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t   (???)
        wind_sigma  = 80, -- dispersion coefficient  mk81=80, mk82=80, mk83=150, mk84=220 ... heavier = harder to push with wind?
        cx_factor   = 50,
    },
    warhead         = {
        mass        = 1.3 * POUNDS_TO_KG * cbu_mult; -- estimated
        expl_mass   = 0.35 * POUNDS_TO_KG * cbu_mult;
        other_factors = {1.0, 1.0, 1.0};
        obj_factors = {1, 1};
        concrete_factors = {1.0, 1.0, 1.0};
        cumulative_factor = 1;
        concrete_obj_factor = 1.0;
        cumulative_thickness = 1.0;
        piercing_mass = 0.95 * POUNDS_TO_KG * cbu_mult;
        caliber     = 0.07;   -- 7 cm
    },
    control =
    {
        open_delay = 0.2,
    },
    shape_table_data = {
        {
            name    = "BLU-3B";
            file    = "A4E_BLU-3B";
            life    = 1;
            fire    = {0, 1};
            username = "BLU-3B";
            index   = WSTYPE_PLACEHOLDER;
        },
    },
    targeting_data  = {
        char_time   = 20.60, -- characteristic time for sights
    },
}

declare_weapon(BLU_3B)

-- CBU-2/A:  360x BLU-3/B submunitions in a SUU-7A launcher
-- CBU-2B/A: 409x BLU-3/B submunitions in a SUU-7A launcher



-- BLU-4/B   -- 1.2lb anti-personnel cluster munition used in CBU-1/A
-- ~0.8lb warhead with 0.18lb RDX explosive
BLU_4B = {
    category        = CAT_BOMBS,
    name            = "BLU-4B",
    user_name       = _("BLU-4B"),
    model           = "A4E_BLU-4B",
    wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_Cluster, WSTYPE_PLACEHOLDER},
    scheme          = "bomb-parashute",
    class_name      = "wAmmunitionBallute",
    type            = 0,
    mass            = 1.2 * POUNDS_TO_KG * cbu_mult,
    hMin            = 500.0,
    hMax            = 12000.0,
    Cx              = 0.0, --this is the drag taken off the pod (must be zero since these bomblets are not in the airflow (mostly)).
    VyHold          = -100.0,
    Ag              = -1.23,
    fm              = {
        mass        = 1.2 * POUNDS_TO_KG * cbu_mult,    -- Empty weight with warhead, W/O fuel, kg
        caliber     = 0.07,  -- Calibre, meters (7cm / 2.75")
        cx_coeff    = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},  -- Cx
        L           = 0.125,   -- Length, meters (125mm / 4.92")
        I           = 0.003,   -- kgm2 - moment of inertia - I = 1/12 ML2
        Ma          = 1.5,  -- dependence moment coefficient of  by  AoA angular acceleration  T / I   (??? can't solve for torque w/o knowing rotation)
        Mw          = 1.0, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t   (???)
        wind_sigma  = 80, -- dispersion coefficient  mk81=80, mk82=80, mk83=150, mk84=220 ... heavier = harder to push with wind?
        cx_factor   = 50,
    },
    warhead         = {
        mass        = 0.8 * POUNDS_TO_KG * cbu_mult; -- estimated
        expl_mass   = 0.18 * POUNDS_TO_KG * cbu_mult;
        other_factors = {1.0, 1.0, 1.0};
        obj_factors = {1, 1};
        concrete_factors = {1.0, 1.0, 1.0};
        cumulative_factor = 1;
        concrete_obj_factor = 1.0;
        cumulative_thickness = 1.0;
        piercing_mass = 0.8 * POUNDS_TO_KG * cbu_mult;
        caliber     = 0.07;   -- 7 cm
    },
    control =
    {
        open_delay = 0.2,
    },
    shape_table_data = {
        {
            name    = "BLU-4B";
            file    = "A4E_BLU-4B";
            life    = 1;
            fire    = {0, 1};
            username = "BLU-4B";
            index   = WSTYPE_PLACEHOLDER;
        },
    },
    targeting_data  = {
        char_time   = 20.60, -- characteristic time for sights
    },
}

declare_weapon(BLU_4B)

-- CBU-1/A: 509x BLU-4/B submunitions in a SUU-7A launcher



local bomblet_data =
{
    --use shapename,        mass,               wstype,                                                drag,
    ["BLU-3B"]          = { mass = BLU_3B.mass, wstype = BLU_3B.wsTypeOfWeapon, model = BLU_3B.model, cx = 0.0001, len = 0.095+0.05 },
    ["BLU-4B"]          = { mass = BLU_3B.mass, wstype = BLU_4B.wsTypeOfWeapon, model = BLU_4B.model, cx = 0.0001, len = 0.095+0.05 },
}

function make_cbu_a4e(dispenser,element,count) -- assemble a cluster dispenser
    local bomblet = bomblet_data[element] or bomblet_data["BLU-3B"]

    local data = {}

    data.category           = CAT_PODS
    data.CLSID              = "{"..dispenser.."}"
    data.attribute          = {wsType_Weapon, wsType_Bomb, wsType_Container, WSTYPE_PLACEHOLDER}
    data.Picture            = "suu-1a.png"
    data.Count              = count
    data.displayName        = dispenser
    data.wsTypeOfWeapon     = bomblet.wstype
    data.Weight             = (128 * POUNDS_TO_KG) + (count * bomblet.mass)
    data.Cx_pil             = 0.001887
    data.Elements           =
    {
        {
            Position	=	{0,	0,	0},
            ShapeName	=	"A4E_SUU-7",
            IsAdapter   =   true,
        },
    }

    local pos_bomblets = {
        { -0.9, -0.2, 0},
        { -0.9, -0.12, 0},
        { -0.9, -0.28, 0},
        { -0.9, -0.04, 0},
        { -0.9, -0.36, 0},
        
        { -0.9, -0.16, 0.06},
        { -0.9, -0.24, 0.06},
        { -0.9, -0.08, 0.06},
        { -0.9, -0.32, 0.06},

        { -0.9, -0.12, 0.12},
        { -0.9, -0.20, 0.12},
        { -0.9, -0.28, 0.12},

        { -0.9, -0.16, -0.06},
        { -0.9, -0.24, -0.06},
        { -0.9, -0.08, -0.06},
        { -0.9, -0.32, -0.06},

        { -0.9, -0.12, -0.12},
        { -0.9, -0.20, -0.12},
        { -0.9, -0.28, -0.12},
    }

    for i = 0,count do
        data.Elements[#data.Elements + 1] = {
            DrawArgs	=	{{1,1},{2,1}},
            Position	=	pos_bomblets[(i%19)+1],
            ShapeName	=	bomblet.model,
            Rotation	=   {0,0,0}
        }
    end

    return data
end

declare_loadout(make_cbu_a4e("CBU-1/A", "BLU-4B", math.floor(509/cbu_mult))) -- {CBU-1/A}
declare_loadout(make_cbu_a4e("CBU-2/A", "BLU-3B", math.floor(360/cbu_mult))) -- {CBU-2/A}
declare_loadout(make_cbu_a4e("CBU-2B/A", "BLU-3B", math.floor(409/cbu_mult))) -- {CBU-2B/A}


----------------------------------------------------
-- THESE FUNCTIONS MUST LIVE BELOW CUSTOM WEAPONS --
----------------------------------------------------

-- bombs that can go on MER or TER racks.
--
-- the "key" into the table is also used for display name of racked munitions in the mission editor, with the count appended
--
-- offset is the distance you'd have to move the model relative to origin to center the hangars about the origin, thus negative
-- numbers are used to fix models where the origin is too far back.
local bomb_data =
{
    --use shapename,        mass,       wstype,                 image,                  drag,               offset (m)
    ["Mk-81"]         = { mass = 118          ,   wstype = {4,5,9,30},              pic = 'mk81.png',      cx = 0.00018, ofs = -0.0508, PictureBlendColor = false },  -- 2" offset back
    ["Mk-81SE"]       = { mass = MK_81SE.mass ,   wstype = MK_81SE.wsTypeOfWeapon,  pic = 'mk81SE.png',    cx = MK_81SE.Cx, ofs = 0.0,     PictureBlendColor = false },  -- 0" offset back
    ["Mk-82"]         = { mass = 241          ,   wstype = {4,5,9,31},              pic = 'mk82.png',      cx = 0.00025, ofs = -0.0762, PictureBlendColor = false },  -- 3" offset back
    ["Mk-82 Snakeye"] = { mass = 241          ,   wstype = {4,5,9,79},              pic = 'mk82air.png',   cx = 0.00025, ofs = -0.2540, PictureBlendColor = false },  -- 10" offset back
    ["Mk-83"]         = { mass = 447          ,   wstype = {4,5,9,32},              pic = 'mk83.png',      cx = 0.00035, ofs = 0.0,     PictureBlendColor = false },  -- 0" offset, hangars are in wrong place
    ["Mk-77 mod 1"]   = { mass = mk77mod1.mass,   wstype = mk77mod1.wsTypeOfWeapon, pic = 'mk77mod1.png',  cx = mk77mod1.Cx,   ofs = 0.0,     PictureBlendColor = false },  -- drag number is garbage
    ["Mk-20"]         = { mass = 222          ,   wstype = {4,5,38,45},             pic = 'mk20.png',      cx = 0.00070, ofs = 0.0,     PictureBlendColor = false },
    ["AN-M57"]        = { mass = 113.0        ,   wstype = {4,5,9,271},             pic = 'us_AN-M57.png', cx = 0.00035, ofs = 0.0,     PictureBlendColor = true  },
    ["AN-M81"]        = { mass = AN_M81.mass  ,   wstype = AN_M81.wsTypeOfWeapon,   pic = 'an-m81.png',    cx = AN_M81.Cx, ofs = 0.0,     PictureBlendColor = false },
    ["AN-M88"]        = { mass = AN_M88.mass  ,   wstype = AN_M88.wsTypeOfWeapon,   pic = 'an-m88.png',    cx = AN_M88.Cx, ofs = 0.0,     PictureBlendColor = false },
}

local rack_data =
{
    ["BRU_41"]          = {mass = 99.8, shapename = "mer_a4e", wstype = {4, 5, 32, WSTYPE_PLACEHOLDER} },
    ["BRU_42"]          = {mass = 47.6, shapename = "BRU_42A", wstype = {4, 5, 32, WSTYPE_PLACEHOLDER} },
}

local rocket_data = 
{
    ["LAU-3 FFAR WP156"]       = { name = "FFAR M156 WP", mass = 100 + 19 * (24.7 * POUNDS_TO_KG),  wstype = {4,7,33,147}, payload_CLSID = "{LAU3_FFAR_WP156}",                      shapename = "LAU-3",  pic = 'LAU61.png', count = 19, cx = 0.00146484375},
    ["LAU-3 FFAR Mk1 HE"]      = { name = "FFAR Mk1 HE",  mass = 100 + 19 * (21.5 * POUNDS_TO_KG),  wstype = {4,7,33,147}, payload_CLSID = "{LAU3_FFAR_MK1HE}",                      shapename = "LAU-3",  pic = 'LAU61.png', count = 19, cx = 0.00146484375},
    ["LAU-3 FFAR Mk5 HEAT"]    = { name = "FFAR Mk5 HEAT",mass = 100 + 19 * (21.6 * POUNDS_TO_KG),  wstype = {4,7,33,147}, payload_CLSID = "{LAU3_FFAR_MK5HEAT}",                    shapename = "LAU-3",  pic = 'LAU61.png', count = 19, cx = 0.00146484375},
    ["LAU-68 FFAR WP156"]      = { name = "FFAR M156 WP", mass = 41.73 + 7 * (24.7 * POUNDS_TO_KG), wstype = {4,7,33,147}, payload_CLSID = "{LAU68_FFAR_WP156}",                     shapename = "LAU-68", pic = 'LAU68.png', count = 7,  cx = 0.00146484375},
    ["LAU-68 FFAR Mk1 HE"]     = { name = "FFAR Mk1 HE",  mass = 41.73 + 7 * (21.5 * POUNDS_TO_KG), wstype = {4,7,33,147}, payload_CLSID = "{LAU68_FFAR_MK1HE}",                     shapename = "LAU-68", pic = 'LAU68.png', count = 7,  cx = 0.00146484375},
    ["LAU-68 FFAR Mk5 HEAT"]   = { name = "FFAR Mk5 HEAT",mass = 41.73 + 7 * (21.6 * POUNDS_TO_KG), wstype = {4,7,33,147}, payload_CLSID = "{LAU68_FFAR_MK5HEAT}",                   shapename = "LAU-68", pic = 'LAU68.png', count = 7,  cx = 0.00146484375},
    ["LAU-10 ZUNI"]            = { name = "ZUNI MK 71",   mass = 440,                               wstype = {4,7,33,37},  payload_CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}", shapename = "LAU-10", pic = 'LAU10.png', count = 4,  cx = 0.001708984375},
}

local function bru_42_lau(element, count, side)
    local lau_variant  = rocket_data[element] or rocket_data["LAU3_FFAR_MK1HE"]
    local rack_variant = rack_data["BRU_42"]
    local sidestr      = {"L","C","R"}
    local data         = {}

    data.category           = CAT_ROCKETS
    data.CLSID              = "{"..element.."_TER_"..tostring(count).."_"..sidestr[2+side].."}"
    -- data.attribute          = rack_variant.wstype
    data.attribute          = {4,	7,	32,	WSTYPE_PLACEHOLDER}
    data.Picture            = lau_variant.pic
    data.Count              = count * lau_variant.count
    -- data.displayName        = element.." *"..tostring(count).." (TER)"
    data.displayName        = lau_variant.shapename.."*"..tostring(count).." - "..lau_variant.count.." "..lau_variant.name 
    data.wsTypeOfWeapon     = lau_variant.wstype
    data.Weight             = rack_variant.mass + count * lau_variant.mass
    data.Cx_pil             = 0.001887 + lau_variant.cx*(count*.9)     -- TER only counts 0.9 of the drag per mounted store
    data.Elements           =
    {
        {
            Position	=	{0,	0,	0},
            ShapeName	=	rack_variant.shapename,
            IsAdapter 	= 	true,
        },
    }

    local connectors   = {"Point03", "Point02", "Point01"}
    local rightorder2  = {2,1,3}
    local centerorder2 = {3,1,2}
    local leftorder2   = {1,2,3}

    -- for center, mount up to 3 ... if 2, do left and right
    -- for left, mount up to 2 skipping front right
    -- for right, mount up to 2 skipping front left
    
    local offset = 3-count
    local order = leftorder2 -- default, includes 3 bombs

    if count == 2 then
        if side == 0 then
            order = centerorder2
        elseif  side == 1 then
            order = rightorder2
        end
    end

    for i = 1,count do
        local j = order[i+offset]
        data.Elements[#data.Elements + 1] = {
                                                DrawArgs       = {{1,1},{2,1}},
                                                connector_name = connectors[j],
                                                payload_CLSID  = lau_variant.payload_CLSID,
                                                ShapeName      = lau_variant.shapename,
                                            }
    end

    return data
end

function rackme_a4e(element,count,side)
    if count <= 3 then
        return bru_42(element,count,side)
    elseif count <= 6 then
        return bru_41(element,count,side)
    end
end

function bru_41(element,count,side) -- build up to a 6x MER loadout of the specified bomb
    local bomb_variant = bomb_data[element] or bomb_data["Mk-81"]
    local rack_variant = rack_data["BRU_41"]
    local sidestr      = {"L","C","R"}
    local data         = {}

    data.category           = CAT_BOMBS
    data.CLSID              = "{"..element.."_MER_"..tostring(count).."_"..sidestr[2+side].."}"
    data.attribute          = rack_variant.wstype
    data.Picture            = bomb_variant.pic
    if bomb_variant.PictureBlendColor then
        data.PictureBlendColor  = "0xffffffff"
    end
    data.Count              = count
    data.displayName        = element.." *"..tostring(count).." (MER)"
    data.wsTypeOfWeapon     = bomb_variant.wstype
    data.Weight             = rack_variant.mass + count * bomb_variant.mass
    data.Cx_pil             = 0.001887 + bomb_variant.cx*(count*.85)            -- 6x MER has 15% less drag per bomb due to in-line mounting. NB: This isn't quite how it works. Since
    data.Elements           =                                                   -- DCS will subtract the cx from the pylon on release. This means if the total is less than cx * count
    {                                                                           -- you will actually have negative drag for this pylon.
        {
            Position	=	{0,	0,	0},
            ShapeName	=	rack_variant.shapename,
            IsAdapter   =   true,
        },
    }

    local fwd_offs  = 1.091
    local back_offs = 1.177

    local positions =  {{  bomb_variant.ofs + fwd_offs,  -0.112,  0.13 }, -- front right
                        {  bomb_variant.ofs - back_offs, -0.112,  0.13 }, -- back right
                        {  bomb_variant.ofs + fwd_offs,  -0.112, -0.13 }, -- front left
                        {  bomb_variant.ofs - back_offs, -0.112, -0.13 }, -- back left
                        {  bomb_variant.ofs + fwd_offs,  -0.309,  0    }, -- front center
                        {  bomb_variant.ofs - back_offs, -0.309,  0    }} -- back center

    local rotations =  {{ -45, 0, 0}, -- right side
                        { -45, 0, 0},
                        {  45, 0, 0}, -- left side
                        {  45, 0, 0},
                        {  0,  0, 0}, -- center
                        {  0,  0, 0}}

    local rightorder5  = {3,4,1,2,5,6}
    local centerorder4 = {5,6,1,2,3,4}
    local normalorder  = {1,2,3,4,5,6}

    -- for center, mount up to 6 ... if 4, do left and right
    -- for left, mount up to 5 skipping front right
    -- for right, mount up to 5 skipping front left

    local offset = 6-count
    local order = normalorder

    if count == 4 and side == 0 then
        order = centerorder4
    elseif (count == 5 or count == 4) and side == 1 then
        order = rightorder5
    end

    for i = 1,count do
        local j = order[i+offset]
        data.Elements[#data.Elements + 1] = {DrawArgs	=	{{1,1},{2,1}},
                                            Position	=	positions[j],
                                            ShapeName	=	element,
                                            Rotation	=   rotations[j]}
    end

    return data
end


function bru_42(element,count,side) -- build a TER setup for the specified bombs
    local bomb_variant = bomb_data[element] or bomb_data["Mk-82"]
    local rack_variant = rack_data["BRU_42"]
    local sidestr      = {"L","C","R"}
    local data         = {}

    data.category           = CAT_BOMBS
    data.CLSID              = "{"..element.."_TER_"..tostring(count).."_"..sidestr[2+side].."}"
    data.attribute          = rack_variant.wstype
    data.Picture            = bomb_variant.pic
    if bomb_variant.PictureBlendColor then
        data.PictureBlendColor  = "0xffffffff"
    end
    data.Count              = count
    data.displayName        = element.." *"..tostring(count).." (TER)"
    data.wsTypeOfWeapon     = bomb_variant.wstype
    data.Weight             = rack_variant.mass + count * bomb_variant.mass
    data.Cx_pil             = 0.001887 + bomb_variant.cx*(count*.9)     -- TER only counts 0.9 of the drag per mounted store, NB: This isn't quite how it works. Since
    data.Elements           =                                           -- DCS will subtract the cx from the pylon on release. This means if the total is less than cx * count
    {                                                                   -- you will actually have negative drag for this pylon.
        {
            Position	=	{0,	0,	0},
            ShapeName	=	rack_variant.shapename,
            IsAdapter   =   true,
        },
    }

    local connectors   = {"Point03", "Point02", "Point01"}
    local rightorder2  = {2,1,3}
    local centerorder2 = {3,1,2}
    local leftorder2   = {1,2,3}

    -- for center, mount up to 3 ... if 2, do left and right
    -- for left, mount up to 2 skipping front right
    -- for right, mount up to 2 skipping front left

    local offset = 3 - count
    local order = leftorder2 -- default, includes 3 bombs

    if count == 2 then
        if side == 0 then
            order = centerorder2
        elseif  side == 1 then
            order = rightorder2
        end
    end

    for i = 1,count do
        local j = order[i+offset]
        data.Elements[#data.Elements + 1] = {
                                                DrawArgs       = {{1,1},{2,1}},
                                                connector_name = connectors[j],
                                                ShapeName      = element,
                                            }
    end

    return data
end


local dispenser_data =
{
    --use shapename,         bomblet,          bomblet_count
    ["CBU-1/A"]          = { bomblet = BLU_4B, bomblet_count = math.floor(509/cbu_mult) },
    ["CBU-2/A"]          = { bomblet = BLU_3B, bomblet_count = math.floor(360/cbu_mult) },
    ["CBU-2B/A"]         = { bomblet = BLU_3B, bomblet_count = math.floor(409/cbu_mult) },
}

-- CLUSTER DISPENSER RACKING FUNCTION
--
-- dispenser = CBU-1/A etc.
-- count = number of dispensers
function make_cbu_a4e_multi(dispenser,count,side) -- assemble a rack of cluster dispensers
    local dispenser_variant = dispenser_data[dispenser] or dispenser_data["CBU-1/A"]
    local bomb_variant      = dispenser_variant.bomblet
    local rack_variant      = rack_data["BRU_42"]
    local sidestr           = {"L","C","R"}
    local data              = {}

    data.category           = CAT_PODS
    data.CLSID              = "{"..dispenser.."_TER_"..tostring(count).."_"..sidestr[2+side].."}"
    data.attribute          = {wsType_Weapon, wsType_Bomb, wsType_Container, WSTYPE_PLACEHOLDER}
    data.Picture            = "suu-1a.png"
    data.Count              = dispenser_variant.bomblet_count * count
    data.displayName        = dispenser.." *2"
    data.wsTypeOfWeapon     = bomb_variant.wsTypeOfWeapon
    data.Weight             = rack_variant.mass + 2 * ((128 * POUNDS_TO_KG) + bomb_variant.mass * dispenser_variant.bomblet_count)
    data.Cx_pil             = 0.0025
    data.Elements           =
    {
        {   -- first place the rack
            Position	=	{0,	0,	0},
            ShapeName	=	rack_variant.shapename,
            IsAdapter   =   true,
        },
    }

    local connectors   = {"Point03", "Point02", "Point01"}
    local rightorder2  = {2,1,3}
    local centerorder2 = {3,1,2}
    local leftorder2   = {1,2,3}

    -- for center, mount up to 3 ... if 2, do left and right
    -- for left, mount up to 2 skipping front right
    -- for right, mount up to 2 skipping front left

    local offset = 3-count
    local order = leftorder2 -- default, includes 3 bombs

    if count == 2 then
        if side == 0 then
            order = centerorder2
        elseif  side == 1 then
            order = rightorder2
        end
    end

    -- now mount the dispensers
    for i = 1,count do
        local j = order[i+offset]
        data.Elements[#data.Elements + 1] = {
                                                DrawArgs       = {{1,1},{2,1}},
                                                connector_name = connectors[j],
                                                payload_CLSID  = "{"..dispenser.."}",
                                                ShapeName      = "A4E_SUU-7",
                                                IsAdapter      = true
                                            }
    end

    return data
end



declare_loadout(bru_42_lau("LAU-10 ZUNI", 3, 0))           -- {LAU-10 ZUNI_TER_3_C}
declare_loadout(bru_42_lau("LAU-10 ZUNI", 2, 0))           -- {LAU-10 ZUNI_TER_2_C}
declare_loadout(bru_42_lau("LAU-10 ZUNI", 2, -1))          -- {LAU-10 ZUNI_TER_2_L}
declare_loadout(bru_42_lau("LAU-10 ZUNI", 2, 1))           -- {LAU-10 ZUNI_TER_2_R}

declare_loadout(bru_42_lau("LAU-3 FFAR WP156", 3, 0))      -- {LAU-3 FFAR WP156_TER_3_C}
declare_loadout(bru_42_lau("LAU-3 FFAR WP156", 2, 0))      -- {LAU-3 FFAR WP156_TER_2_C}
declare_loadout(bru_42_lau("LAU-3 FFAR WP156", 2, -1))     -- {LAU-3 FFAR WP156_TER_2_L}
declare_loadout(bru_42_lau("LAU-3 FFAR WP156", 2, 1))      -- {LAU-3 FFAR WP156_TER_2_R}

declare_loadout(bru_42_lau("LAU-3 FFAR Mk1 HE", 3, 0))     -- {LAU-3 FFAR Mk1 HE_TER_3_C}
declare_loadout(bru_42_lau("LAU-3 FFAR Mk1 HE", 2, 0))     -- {LAU-3 FFAR Mk1 HE_TER_2_C}
declare_loadout(bru_42_lau("LAU-3 FFAR Mk1 HE", 2, -1))    -- {LAU-3 FFAR Mk1 HE_TER_2_L}
declare_loadout(bru_42_lau("LAU-3 FFAR Mk1 HE", 2, 1))     -- {LAU-3 FFAR Mk1 HE_TER_2_R}

declare_loadout(bru_42_lau("LAU-3 FFAR Mk5 HEAT", 3, 0))   -- {LAU-3 FFAR Mk5 HEAT_TER_3_C}
declare_loadout(bru_42_lau("LAU-3 FFAR Mk5 HEAT", 2, 0))   -- {LAU-3 FFAR Mk5 HEAT_TER_2_C}
declare_loadout(bru_42_lau("LAU-3 FFAR Mk5 HEAT", 2, -1))  -- {LAU-3 FFAR Mk5 HEAT_TER_2_L}
declare_loadout(bru_42_lau("LAU-3 FFAR Mk5 HEAT", 2, 1))   -- {LAU-3 FFAR Mk5 HEAT_TER_2_R}

declare_loadout(bru_42_lau("LAU-68 FFAR WP156", 3, 0))     -- {LAU-68 FFAR WP156_TER_3_C}
declare_loadout(bru_42_lau("LAU-68 FFAR WP156", 2, 0))     -- {LAU-68 FFAR WP156_TER_2_C}
declare_loadout(bru_42_lau("LAU-68 FFAR WP156", 2, -1))    -- {LAU-68 FFAR WP156_TER_2_L}
declare_loadout(bru_42_lau("LAU-68 FFAR WP156", 2, 1))     -- {LAU-68 FFAR WP156_TER_2_R}

declare_loadout(bru_42_lau("LAU-68 FFAR Mk1 HE", 3, 0))    -- {LAU-68 FFAR Mk1 HE_TER_3_C}
declare_loadout(bru_42_lau("LAU-68 FFAR Mk1 HE", 2, 0))    -- {LAU-68 FFAR Mk1 HE_TER_2_C}
declare_loadout(bru_42_lau("LAU-68 FFAR Mk1 HE", 2, -1))   -- {LAU-68 FFAR Mk1 HE_TER_2_L}
declare_loadout(bru_42_lau("LAU-68 FFAR Mk1 HE", 2, 1))    -- {LAU-68 FFAR Mk1 HE_TER_2_R}

declare_loadout(bru_42_lau("LAU-68 FFAR Mk5 HEAT", 3, 0))  -- {LAU-68 FFAR Mk5 HEAT_TER_3_C}
declare_loadout(bru_42_lau("LAU-68 FFAR Mk5 HEAT", 2, 0))  -- {LAU-68 FFAR Mk5 HEAT_TER_2_C}
declare_loadout(bru_42_lau("LAU-68 FFAR Mk5 HEAT", 2, -1)) -- {LAU-68 FFAR Mk5 HEAT_TER_2_L}
declare_loadout(bru_42_lau("LAU-68 FFAR Mk5 HEAT", 2, 1))  -- {LAU-68 FFAR Mk5 HEAT_TER_2_R}

declare_loadout(rackme_a4e("AN-M57", 6,  0))               -- {AN-M57_MER_6_C}
declare_loadout(rackme_a4e("AN-M57", 5, -1))               -- {AN-M57_MER_5_L}
declare_loadout(rackme_a4e("AN-M57", 5,  1))               -- {AN-M57_MER_5_R}
declare_loadout(rackme_a4e("AN-M57", 3,  0))               -- {AN-M57_TER_3_C}
declare_loadout(rackme_a4e("AN-M57", 2, -1))               -- {AN-M57_TER_2_L}
declare_loadout(rackme_a4e("AN-M57", 2,  1))               -- {AN-M57_TER_2_R}

declare_loadout(rackme_a4e("AN-M81", 6,  0))               -- {AN-M81_MER_6_C}
declare_loadout(rackme_a4e("AN-M81", 5, -1))               -- {AN-M81_MER_5_L}
declare_loadout(rackme_a4e("AN-M81", 5,  1))               -- {AN-M81_MER_5_R}

declare_loadout(rackme_a4e("AN-M88", 6,  0))               -- {AN-M88_MER_6_C}
declare_loadout(rackme_a4e("AN-M88", 5, -1))               -- {AN-M88_MER_5_L}
declare_loadout(rackme_a4e("AN-M88", 5,  1))               -- {AN-M88_MER_5_R}

declare_loadout(rackme_a4e("Mk-81", 6, 0))                 -- {Mk-81_MER_6_C}
declare_loadout(rackme_a4e("Mk-81", 5,-1))                 -- {Mk-81_MER_5_L}
declare_loadout(rackme_a4e("Mk-81", 5, 1))                 -- {Mk-81_MER_5_R}

declare_loadout(rackme_a4e("Mk-81SE", 6, 0))               -- {Mk-81SE_MER_6_C}
declare_loadout(rackme_a4e("Mk-81SE", 5,-1))               -- {Mk-81SE_MER_5_L}
declare_loadout(rackme_a4e("Mk-81SE", 5, 1))               -- {Mk-81SE_MER_5_R}

declare_loadout(rackme_a4e("Mk-82", 6, 0))                 -- {Mk-82_MER_6_C}
declare_loadout(rackme_a4e("Mk-82", 4, 0))                 -- {Mk-82_MER_4_C}
declare_loadout(rackme_a4e("Mk-82", 3, 0))                 -- {Mk-82_TER_3_C}
declare_loadout(rackme_a4e("Mk-82", 2,-1))                 -- {Mk-82_TER_2_L}
declare_loadout(rackme_a4e("Mk-82", 2, 1))                 -- {Mk-82_TER_2_R}

declare_loadout(rackme_a4e("Mk-82 Snakeye", 6, 0))         -- {Mk-82 Snakeye_MER_6_C}
declare_loadout(rackme_a4e("Mk-82 Snakeye", 4, 0))         -- {Mk-82 Snakeye_MER_4_C}
declare_loadout(rackme_a4e("Mk-82 Snakeye", 3, 0))         -- {Mk-82 Snakeye_TER_3_C}
declare_loadout(rackme_a4e("Mk-82 Snakeye", 2,-1))         -- {Mk-82 Snakeye_TER_2_L}
declare_loadout(rackme_a4e("Mk-82 Snakeye", 2, 1))         -- {Mk-82 Snakeye_TER_2_R}

declare_loadout(rackme_a4e("Mk-83", 3, 0))                 -- {Mk-83_TER_3_C}
declare_loadout(rackme_a4e("Mk-83", 2, 0))                 -- {Mk-83_TER_2_C}

declare_loadout(rackme_a4e("Mk-77 mod 1", 4, 0))           -- {Mk-77 mod 1_MER_4_C}
declare_loadout(rackme_a4e("Mk-77 mod 1", 2,-1))           -- {Mk-77 mod 1_TER_2_L}
declare_loadout(rackme_a4e("Mk-77 mod 1", 2, 1))           -- {Mk-77 mod 1_TER_2_R}
declare_loadout(rackme_a4e("Mk-77 mod 1", 2, 0))           -- {Mk-77 mod 1_TER_2_C}

declare_loadout(rackme_a4e("Mk-20", 3, 0))                 -- {Mk-20_TER_3_C}
declare_loadout(rackme_a4e("Mk-20", 2,-1))                 -- {Mk-20_TER_2_L}
declare_loadout(rackme_a4e("Mk-20", 2, 1))                 -- {Mk-20_TER_2_R}
declare_loadout(rackme_a4e("Mk-20", 2, 0))                 -- {Mk-20_TER_2_C}

declare_loadout(make_cbu_a4e_multi("CBU-1/A",  2, -1))     -- {CBU-1/A_TER_2_L}
declare_loadout(make_cbu_a4e_multi("CBU-1/A",  2,  1))     -- {CBU-1/A_TER_2_R}
declare_loadout(make_cbu_a4e_multi("CBU-2/A",  2, -1))     -- {CBU-2/A_TER_2_L}
declare_loadout(make_cbu_a4e_multi("CBU-2/A",  2,  1))     -- {CBU-2/A_TER_2_R}
declare_loadout(make_cbu_a4e_multi("CBU-2B/A", 2, -1))     -- {CBU-2B/A_TER_2_L}
declare_loadout(make_cbu_a4e_multi("CBU-2B/A", 2,  1))     -- {CBU-2B/A_TER_2_R}
