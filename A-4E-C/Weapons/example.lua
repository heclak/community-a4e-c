-- Defining ammunition



    local tracer_on_time = 0.01
    local barrel_smoke_level = 1.0
    local barrel_smoke_opacity = 0.1



    -- MG 131
    declare_weapon({category = CAT_SHELLS, name = "MG_13x64_APT", user_name = _("MG_13x64_APT"),
        model_name      = "tracer_bullet_green",
        mass            = 0.038, -- Bullet mass
        round_mass      = 0.076 + 0.009, -- Assembled shell + link
        cartridge_mass  = 0.031 + 0.009, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.0000,
        v0              = 710.0,
        Dv0             = 0.0080,
        Da0             = 0.00045,
        Da1             = 0.0,
        life_time       = 7.0,
        caliber         = 13,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.0, 0.912, 0.7, 0.25, 1.80},
        k1              = 4.8e-08,
        tracer_off      = 1.5,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0.5,
        scale_tracer    = 1,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

    declare_weapon({category = CAT_SHELLS, name = "MG_13x64_API", user_name = _("MG_13x64_API"),
        model_name      = "tracer_bullet_yellow",
        mass            = 0.034, -- Bullet mass
        round_mass      = 0.086 + 0.009, -- Assembled shell + link
        cartridge_mass  = 0.031 + 0.009, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.0000,
        v0              = 750.0,
        Dv0             = 0.0080,
        Da0             = 0.00045,
        Da1             = 0.0,
        life_time       = 7.0,
        caliber         = 13,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.0, 0.912, 0.7, 0.25, 1.80},
        k1              = 4.3e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

    declare_weapon({category = CAT_SHELLS, name = "MG_13x64_HEI", user_name = _("MG_13x64_HEI"),
        model_name      = "tracer_bullet_white",
        mass            = 0.034, -- Bullet mass
        round_mass      = 0.086 + 0.009, -- Assembled shell + link
        cartridge_mass  = 0.031 + 0.009, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.0070,
        v0              = 750.0,
        Dv0             = 0.0080,
        Da0             = 0.00045,
        Da1             = 0.0,
        life_time       = 7.0,
        caliber         = 13,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.0, 0.912, 0.7, 0.25, 1.80},
        k1              = 4.3e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })
    -- end of MG 131



    -- MG 151/20
    -- 113-1945 Brsprgr. Patr. L'spur El. m. Zerl
    declare_weapon({category = CAT_SHELLS, name = "MG_20x82_HEI_T", user_name = _("MG_20x82_HEI_T"),
        model_name      = "tracer_bullet_crimson",
        mass            = 0.117, -- Bullet mass
        round_mass      = 0.220, -- Assembled shell + link
        cartridge_mass  = 0.056, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.0090,
        v0              = 720.0,
        Dv0             = 0.0080,
        Da0             = 0.0006,
        Da1             = 0.0,
        life_time       = 3.5,
        caliber         = 20,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {0.6, 0.94, 0.65, 0.29, 1.88},
        k1              = 3.3e-08,
        tracer_off      = 3,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0.7,
        scale_tracer    = 1,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

    -- 113-1946 Pzgr. Patr. 151 El. o. Zerl
    declare_weapon({category = CAT_SHELLS, name = "MG_20x82_API", user_name = _("MG_20x82_API"),
        model_name      = "tracer_bullet_yellow",
        mass            = 0.117, -- Bullet mass
        round_mass      = 0.220, -- Assembled shell + link
        cartridge_mass  = 0.056, -- Empty shell (+ link if links are stored as well)
        explosive       = 0,
        v0              = 720.0,
        Dv0             = 0.0080,
        Da0             = 0.0006,
        Da1             = 0.0,
        life_time       = 7.0,
        caliber         = 20,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.3, 0.93, 0.55, 0.36, 1.8},
        k1              = 3.6e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

    -- 113-1979 M-Gsch. Patr. 151 El. m. Zerl
    declare_weapon({category = CAT_SHELLS, name = "MG_20x82_MGsch", user_name = _("MG_20x82_MGsch"),
        model_name      = "tracer_bullet_white",
        mass            = 0.092, -- Bullet mass
        round_mass      = 0.190, -- Assembled shell + link
        cartridge_mass  = 0.056, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.0350,
        v0              = 790.0,
        Dv0             = 0.0080,
        Da0             = 0.0006,
        Da1             = 0.0,
        life_time       = 3.0,
        caliber         = 20,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.0, 1.22, 0.3, 0.36, 1.9},
        k1              = 5.2e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity	= barrel_smoke_opacity,
    })
    -- end of MG 151/20



    -- MK 108
    -- 3 cm M-Gesch. Patr. 108 m. Zerl Ausf. A
    declare_weapon({category = CAT_SHELLS, name = "MK_108_MGsch", user_name = _("MK_108_MGsch"),
        model_name      = "tracer_bullet_yellow",
        mass            = 0.330, -- Bullet mass
        round_mass      = 0.470 + 0.110, -- Assembled shell + link
        cartridge_mass  = 0.125 + 0.110, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.1275,
        v0              = 500.0,
        Dv0             = 0.008,
        Da0             = 0.0004,
        Da1             = 0.0,
        life_time       = 4.0,
        caliber         = 30,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.5, 0.99, 0.36, 0.55, 1.8},
        k1              = 4.9e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

    -- 3 cm M-Gesch. Patr. L.Spur 108 m. Zerl
    declare_weapon({category = CAT_SHELLS, name = "MK_108_MGsch_T", user_name = _("MK_108_MGsch_T"),
        model_name      = "tracer_bullet_yellow",
        mass            = 0.330, -- Bullet mass
        round_mass      = 0.470 + 0.110, -- Assembled shell + link
        cartridge_mass  = 0.125 + 0.110, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.1275,
        v0              = 500.0,
        Dv0             = 0.008,
        Da0             = 0.0004,
        Da1             = 0.0,
        life_time       = 4.0,
        caliber         = 30,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.0, 0.5, 0.66, 0.25, 1.7},
        k1              = 2.2e-08,
        tracer_off      = 2.7,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 2.7,
        scale_tracer    = 1,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

    -- 3 cm Brgr. Patr. 108 m. Zerl
    declare_weapon({category = CAT_SHELLS, name = "MK_108_HEI", user_name = _("MK_108_HEI"),
        model_name      = "tracer_bullet_yellow",
        mass            = 0.370, -- Bullet mass
        round_mass      = 0.470 + 0.110, -- Assembled shell + link
        cartridge_mass  = 0.125 + 0.110, -- Empty shell (+ link if links are stored as well)
        explosive       = 0.0360,
        v0              = 485.0,
        Dv0             = 0.008, -- медиан относительного разброса скорости - [v0-V0*Dv0, v0+v0*Dv0] содержит 50% скоростей
        Da0             = 0.0004,
        Da1             = 0.0,
        life_time       = 4.0,
        caliber         = 30,
        s               = 0.0,
        j               = 0.0,
        l               = 0.0,
        charTime        = 0,
        cx              = {1.2, 0.72, 0.6, 0.62, 1.4},
        k1              = 4.8e-08,
        tracer_off      = -1,
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 0,
        scale_tracer    = 0,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })
    -- end of MK 108



-- end of Defining ammunition



-- Defining guns



    -- MG 131
    function MG_131 ( tbl )
        tbl.category = CAT_GUN_MOUNT
        tbl.name = "MG_131"
        tbl.supply = {
            shells = {"MG_13x64_APT", "MG_13x64_API", "MG_13x64_HEI"},
            mixes = {{3, 1, 3, 2}},
            count = 450,
        }
        if tbl.mixes then
            tbl.supply.mixes = tbl.mixes
            tbl.mixes = nil
        end
        if tbl.count then
            tbl.supply.count = tbl.count
            tbl.count = nil
        end
        tbl.gun = {
            max_burst_length = 65535,
            rates = {900}, -- unsynchronized mount
            recoil_coeff = 1.0,
            barrels_count = 1,
        }
        if tbl.rates then
            tbl.gun.rates = tbl.rates
            tbl.rates = nil
        end
        tbl.ejector_pos = tbl.ejector_pos or {0.0, 0.05, 0.0}
        tbl.ejector_dir = tbl.ejector_dir or {0, -1, 0}
        --tbl.effect_arg_number = tbl.effect_arg_number or 436
        tbl.supply_position = tbl.supply_position or {0, 0.3, -0.3}
        tbl.aft_gun_mount = false
        tbl.effective_fire_distance = 1000
        --tbl.drop_cartridge = 0 -- 204
        tbl.muzzle_pos = {0, 0, 0} -- all position from connector
        tbl.azimuth_initial = tbl.azimuth_initial or 0
        tbl.elevation_initial = tbl.elevation_initial or 0
        --if tbl.effects == nil then
        --    tbl.effects = {synchronizer, {name = "FireEffect", arg = tbl.effect_arg_number or 436}, {name = "HeatEffectExt", shot_heat = 4.103, barrel_k = 0.462 * 3.7, body_k = 0.462 * 14.3}, {name = "SmokeEffect"}}
        --end

        return declare_weapon(tbl)
    end
    -- end of MG 131



    -- MG 151/20
    function MG_151_20 ( tbl )
        tbl.category = CAT_GUN_MOUNT 
        tbl.name = "MG_151_20"
        tbl.supply = {
            shells = {"MG_20x82_HEI_T", "MG_20x82_API", "MG_20x82_MGsch"},
            mixes = {{1, 2, 3, 1, 2, 3}},
            count = 250,
        }
        if tbl.mixes then
            tbl.supply.mixes = tbl.mixes
            tbl.mixes = nil
        end
        if tbl.count then
            tbl.supply.count = tbl.count
            tbl.count = nil
        end
        tbl.gun = {
            max_burst_length = 150,
            rates = {700}, -- unsynchronized mount
            recoil_coeff = 1.0,
            barrels_count = 1,
        }
        if tbl.rates then
            tbl.gun.rates = tbl.rates
            tbl.rates = nil
        end
        tbl.ejector_pos = tbl.ejector_pos or {0.0, 0.05, 0.0}
        tbl.ejector_dir = tbl.ejector_dir or {0, -1, 0}
        tbl.supply_position = tbl.supply_position or {0, -0.3, -1.5}
        tbl.aft_gun_mount = false
        tbl.effective_fire_distance = 1000
        --tbl.drop_cartridge = 204
        tbl.muzzle_pos = {0, 0, 0} -- all position from connector
        tbl.azimuth_initial = tbl.azimuth_initial or 0
        tbl.elevation_initial = tbl.elevation_initial or 0
        --tbl.effects = {
        --    synchronizer,
        --    {name = "FireEffect", arg = tbl.effect_arg_number or 436},
        --    {name = "HeatEffectExt", shot_heat = 20.9, barrel_k = 0.462 * 16.6, body_k = 0.462 * 35.4},
        --    {name = "SmokeEffect"}
        --}

        return declare_weapon(tbl)
    end
    -- end of MG 151/20



    -- MK 108
    function MK_108 ( tbl )
        tbl.category = CAT_GUN_MOUNT
        tbl.name = "MK_108"
        tbl.supply = {
            shells = {"MK_108_MGsch", "MK_108_MGsch_T", "MK_108_HEI"},
            mixes = {{2, 2}},
            count = 60,
        }
        if tbl.mixes then
            tbl.supply.mixes = tbl.mixes
            tbl.mixes        = nil
        end
        if tbl.count then
            tbl.supply.count = tbl.count
            tbl.count = nil
        end
        tbl.gun = {
            max_burst_length = 65535,
            rates = {660}, -- unsynchronized mount
            recoil_coeff = 1.0,
            barrels_count = 1,
        }
        if tbl.rates then
            tbl.gun.rates = tbl.rates
            tbl.rates = nil
        end
        tbl.ejector_pos = tbl.ejector_pos or {0.0, 0.05, 0.0}
        tbl.ejector_dir = {0, -1, 0}
        --tbl.effect_arg_number = tbl.effect_arg_number or 436
        tbl.supply_position = tbl.supply_position or {0, -0.3, -1.5}
        tbl.aft_gun_mount = false
        tbl.effective_fire_distance = 1000
        --tbl.drop_cartridge = 0 -- 204
        tbl.muzzle_pos = {0, 0, 0} -- all position from connector
        tbl.azimuth_initial = tbl.azimuth_initial or 0
        tbl.elevation_initial = tbl.elevation_initial or 0

        return declare_weapon(tbl)
    end
    -- end of MK 108



-- end of Defining guns



-- Defining drop ordinance



    -- SC 50
    SC_50 = {category = CAT_BOMBS, name = "SC 50", user_name = _("SC-50"),
        model           = "SC50",
        wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
        scheme          = "bomb-common",
        type            = 0,
        mass            = 50.0,
        hMin            = 1000.0,
        hMax            = 12000.0,
        Cx              = 0.00124,
        VyHold          = -100.0,
        Ag              = -1.23,
        fm              = {
            mass        = 50.0, -- Empty weight with warhead, W/O fuel, kg
            caliber     = 0.200, -- Calibre, meters 
            cx_coeff    = {1.000000, 0.390000, 0.60000, 0.1680000, 1.310000}, -- Cx
            L           = 3.365, -- Length, meters 
            I           = 443.4929, -- kgm2 - moment of inertia  I = 1/12 ML2
            Ma          = 0.42,  -- dependence moment coefficient of  by  AoA angular acceleration  T / I
            Mw          = 5.04, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t
            wind_sigma  = 5, -- dispersion coefficient
            cx_factor   = 100,
        },
        warhead         = {
            mass        = 25.0; 
            expl_mass   = 25;
            other_factors = {1.0, 1.0, 1.0};
            obj_factors = {1, 1};
            concrete_factors = {1.0, 1.0, 1.0};
            cumulative_factor = 1;
            concrete_obj_factor = 1.0;
            cumulative_thickness = 1.0;
            piercing_mass = 1.0;
            caliber     = 200;
        },
        shape_table_data = {
            {
                name    = "SC_50";
                file    = "SC50";
                life    = 1;
                fire    = {0, 1};
                username = "SC-50";
                index   = WSTYPE_PLACEHOLDER;
            },
        },
        targeting_data  = {
            char_time   = 20.60, -- characteristic time for sights 
        },
    }

    declare_weapon(SC_50)
    -- end of SC 50



    -- SC 250
    SC_250 = {category = CAT_BOMBS, name = "SC 250", user_name = _("SC-250"),
        model           = "SC-250",
        wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
        scheme          = "bomb-common",
        type            = 0,
        mass            = 250.0,
        hMin            = 300.0,
        hMax            = 12000.0,
        Cx              = 0.00124,
        VyHold          = -100.0,
        Ag              = -1.23,
        fm              = {
            mass        = 250, -- Empty weight with warhead, W/O fuel, kg
            caliber     = 0.368, -- Calibre, meters 
            cx_coeff    = {1.000000, 0.390000, 0.380000, 0.236000, 1.310000}, -- Cx
            L           = 1.640000, -- Length, meters 
            I           = 43.077867, -- kgm2 - moment of inertia - I = 1/12 ML2
            Ma          = 0.141338,  -- dependence moment coefficient of  by  AoA angular acceleration  T / I
            Mw          = 2.244756, --  rad/s  - 57.3°/s - dependence moment coefficient by angular velocity (|V|*sin(?))/|r| -  Mw  =  Ma * t
            wind_sigma  = 30, -- dispersion coefficient  
            cx_factor   = 100,  
        },
        warhead         = {
            mass        = 135.0; 
            expl_mass   = 135.0;
            other_factors = {1.0, 1.0, 1.0};
            obj_factors = {1, 1};
            concrete_factors = {1.0, 1.0, 1.0};
            cumulative_factor = 1;
            concrete_obj_factor = 1.0;
            cumulative_thickness = 1.0;
            piercing_mass = 1.0;
            caliber     = 368;
        },
        shape_table_data = {
            {
                name    = "SC_250";
                file    = "SC-250";
                life    = 1;
                fire    = {0, 1};
                username = "SC-250";
                index   = WSTYPE_PLACEHOLDER;
            },
        },
        targeting_data  = {
            char_time   = 20.60, -- characteristic time for sights 
        },
    }

    declare_weapon(SC_250)
    -- end of SC 250



    -- SC 500
    SC_500 = {category = CAT_BOMBS, name = "SC 500", user_name = _("SC-500"),
        model           = "SC-500",
        wsTypeOfWeapon  = {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, WSTYPE_PLACEHOLDER},
        scheme          = "bomb-common",
        type            = 0,
        mass            = 500.0,
        hMin            = 300.0,
        hMax            = 12000.0,
        Cx              = 0.00133,
        VyHold          = -100.0,
        Ag              = -1.23,
        fm              = {
            mass        = 500.0,
            caliber     = 0.47,
            cx_coeff    = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
            L           = 2.01,
            I           = 246.037500,
            Ma          = 0.324570,
            Mw          = 3.139597,
            wind_sigma  = 100.0,
            cx_factor   = 300,
        },
        warhead         = {
            mass        = 260.0; 
            expl_mass   = 260;
            other_factors = {1.0, 1.0, 1.0};
            obj_factors = {1, 1};
            concrete_factors = {1.0, 1.0, 1.0};
            cumulative_factor = 1;
            concrete_obj_factor = 1.0;
            cumulative_thickness = 1.0;
            piercing_mass = 1.0;
            caliber     = 470;
        },
        shape_table_data = {
            {
                name    = "SC_500";
                file    = "SC-500";
                life    = 1;
                fire    = {0, 1};
                username = "SC-500";
                index   = WSTYPE_PLACEHOLDER;
            },
        },
        targeting_data = {
            char_time   = 20.35, -- characteristic time for sights 
        },
    }

    declare_weapon(SC_500)
    -- end of SC 500



-- end of Defining drop ordinance
