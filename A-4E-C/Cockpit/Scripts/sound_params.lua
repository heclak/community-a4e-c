sound_params = {

    --ENVIRONMENTAL
    --debug test sounds
    snd_cont_test_05 = get_param_handle("SND_CONT_TEST_05"),
    snd_cont_test_10 = get_param_handle("SND_CONT_TEST_10"),
    snd_cont_test_15 = get_param_handle("SND_CONT_TEST_15"),
    snd_cont_test_20 = get_param_handle("SND_CONT_TEST_20"),
    --damage
    snd_inst_damage_gear_overspeed = get_param_handle("SND_INST_DAMAGE_GEAR_OVERSPEED"),
    snd_alws_damage_airframe_stress = get_param_handle("SND_ALWS_DAMAGE_AIRFRAME_STRESS"),
    --engine
    snd_inst_avionics_whine = get_param_handle("SND_INST_AVIONICS_WHINE"),
    snd_inst_engine_igniter_whirr = get_param_handle("SND_INST_ENGINE_IGNITER_WHIRR"),
    snd_alws_engine_igniter_spark = get_param_handle("SND_ALWS_ENGINE_IGNITER_SPARK"),
    snd_inst_engine_wind_up = get_param_handle("SND_INST_ENGINE_WIND_UP"),
    snd_inst_engine_wind_down = get_param_handle("SND_INST_ENGINE_WIND_DOWN"),
    snd_alws_engine_wind_on = get_param_handle("SND_ALWS_ENGINE_WIND_ON"),
    snd_alws_engine_operation_lo = get_param_handle("SND_ALWS_ENGINE_OPERATION_LO"),
    snd_alws_engine_operation_hi = get_param_handle("SND_ALWS_ENGINE_OPERATION_HI"),
    snd_inst_engine_stall = get_param_handle("SND_INST_ENGINE_STALL"),
    --gear pod doors
    snd_inst_l_gear_pod_open = get_param_handle("SND_INST_L_GEAR_POD_OPEN"),
    snd_inst_l_gear_pod_close = get_param_handle("SND_INST_L_GEAR_POD_CLOSE"),
    snd_inst_r_gear_pod_open = get_param_handle("SND_INST_R_GEAR_POD_OPEN"),
    snd_inst_r_gear_pod_close = get_param_handle("SND_INST_R_GEAR_POD_CLOSE"),
    snd_inst_c_gear_pod_open = get_param_handle("SND_INST_C_GEAR_POD_OPEN"),
    snd_inst_c_gear_pod_close = get_param_handle("SND_INST_C_GEAR_POD_CLOSE"),
    --gear pod travel end
    snd_inst_l_gear_end_in = get_param_handle("SND_INST_L_GEAR_END_IN"),
    snd_inst_l_gear_end_out = get_param_handle("SND_INST_L_GEAR_END_OUT"),
    snd_inst_r_gear_end_in = get_param_handle("SND_INST_R_GEAR_END_IN"),
    snd_inst_r_gear_end_out = get_param_handle("SND_INST_R_GEAR_END_OUT"),
    snd_inst_c_gear_end_in = get_param_handle("SND_INST_C_GEAR_END_IN"),
    snd_inst_c_gear_end_out = get_param_handle("SND_INST_C_GEAR_END_OUT"),
    --refueling
    snd_cont_fuel_intake = get_param_handle("SND_CONT_FUEL_INTAKE"),
    --slats
    snd_inst_l_slat_in = get_param_handle("SND_INST_L_SLAT_IN"),
    snd_inst_l_slat_out = get_param_handle("SND_INST_L_SLAT_OUT"),
    snd_inst_r_slat_in = get_param_handle("SND_INST_R_SLAT_IN"),
    snd_inst_r_slat_out = get_param_handle("SND_INST_R_SLAT_OUT"),
    --wheels
    snd_inst_wheels_touchdown_n = get_param_handle("SND_INST_WHEELS_TOUCHDOWN_N"),
    snd_inst_wheels_touchdown_l = get_param_handle("SND_INST_WHEELS_TOUCHDOWN_L"),
    snd_inst_wheels_touchdown_r = get_param_handle("SND_INST_WHEELS_TOUCHDOWN_R"),

    --HYDRAULICS
    --canopy
    snd_cont_canopy_mov_open = get_param_handle("SND_CONT_CANOPY_MOV_OPEN"),
    snd_cont_canopy_mov_close = get_param_handle("SND_CONT_CANOPY_MOV_CLOSE"),
    snd_inst_canopy_mov_seal_open = get_param_handle("SND_INST_CANOPY_MOV_SEAL_OPEN"),
    snd_inst_canopy_mov_seal_close = get_param_handle("SND_INST_CANOPY_MOV_SEAL_CLOSE"),
    snd_inst_canopy_close_stop = get_param_handle("SND_INST_CANOPY_CLOSE_STOP"),
    snd_inst_canopy_open_stop = get_param_handle("SND_INST_CANOPY_OPEN_STOP"),
    --seat
    snd_cont_seat_mov = get_param_handle("SND_CONT_SEAT_MOVE"),
    --flaps
    snd_cont_flaps_mov = get_param_handle("SND_CONT_FLAPS_MOVE"),
    snd_inst_flaps_stop = get_param_handle("SND_INST_FLAPS_STOP"),
    --gear
    snd_cont_gear_mov = get_param_handle("SND_CONT_GEAR_MOV"),
    snd_inst_gear_stop = get_param_handle("SND_INST_GEAR_STOP"),
    --guns
    snd_inst_guns_charge_l = get_param_handle("SND_INST_GUNS_CHARGE_L"),
    snd_inst_guns_charge_r = get_param_handle("SND_INST_GUNS_CHARGE_R"),
    snd_inst_guns_safe_l = get_param_handle("SND_INST_GUNS_SAFE_L"),
    snd_inst_guns_safe_r = get_param_handle("SND_INST_GUNS_SAFE_R"),
    --supplemental (speedbrake or tailhook)
    snd_inst_emer_speedbrake_in = get_param_handle("SND_INST_EMER_SPEEDBRAKE_IN"),
    snd_inst_emer_speedbrake_out = get_param_handle("SND_INST_EMER_SPEEDBRAKE_OUT"),
    snd_cont_hydraulic_mov = get_param_handle("SND_CONT_HYD_MOV"),
    snd_inst_hydraulic_stop = get_param_handle("SND_INST_HYD_STOP"),

    --rwr hum
    snd_alws_rwr_hum = get_param_handle("SND_ALWS_RWR_HUM"),
    snd_cont_rwr_msl_volume = get_param_handle("SND_CONT_RWR_MSL_VOLUME"),

    --radar altimieter
    snd_inst_radar_altimeter_warning = get_param_handle("SND_INST_RADAR_ALTIMITER_WARNING"),

}