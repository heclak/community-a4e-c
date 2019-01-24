dofile(LockOn_Options.common_script_path.."../../../Database/wsTypes.lua")

------------------------------------------------
----------------  CONSTANTS  -------------------
------------------------------------------------
cbu_mult = 5
dispenser_data =
{
    --use shapename,         bomblet,          bomblet_count
    ["{CBU-1/A}"]           = { bomblet = BLU_4B, bomblet_count = math.floor(509/cbu_mult), number_of_tubes = 19, tubes_per_pulse = 2, variant = "CBU-1/A" },
    ["{CBU-2/A}"]           = { bomblet = BLU_3B, bomblet_count = math.floor(360/cbu_mult), number_of_tubes = 17, tubes_per_pulse = 1, variant = "CBU-2/A" },
    ["{CBU-2B/A}"]          = { bomblet = BLU_3B, bomblet_count = math.floor(409/cbu_mult), number_of_tubes = 19, tubes_per_pulse = 2, variant = "CBU-2B/A" },
    ["{CBU-1/A_TER_2_L}"]   = { bomblet = BLU_4B, bomblet_count = math.floor(509/cbu_mult), number_of_tubes = 19, tubes_per_pulse = 2, variant = "CBU-1/A" },
    ["{CBU-2/A_TER_2_L}"]   = { bomblet = BLU_3B, bomblet_count = math.floor(360/cbu_mult), number_of_tubes = 17, tubes_per_pulse = 1, variant = "CBU-2/A" },
    ["{CBU-2B/A_TER_2_L}"]  = { bomblet = BLU_3B, bomblet_count = math.floor(409/cbu_mult), number_of_tubes = 19, tubes_per_pulse = 2, variant = "CBU-2B/A" },
    ["{CBU-1/A_TER_2_R}"]   = { bomblet = BLU_4B, bomblet_count = math.floor(509/cbu_mult), number_of_tubes = 19, tubes_per_pulse = 2, variant = "CBU-1/A" },
    ["{CBU-2/A_TER_2_R}"]   = { bomblet = BLU_3B, bomblet_count = math.floor(360/cbu_mult), number_of_tubes = 17, tubes_per_pulse = 1, variant = "CBU-2/A" },
    ["{CBU-2B/A_TER_2_R}"]  = { bomblet = BLU_3B, bomblet_count = math.floor(409/cbu_mult), number_of_tubes = 19, tubes_per_pulse = 2, variant = "CBU-2B/A" },
}

------------------------------------------------
--------------  END CONSTANTS  -----------------
------------------------------------------------




------------------------------------------------
-----------  AIRCRAFT DEFINITION  --------------
------------------------------------------------
num_stations = 5

------------------------------------------------
---------  END AIRCRAFT DEFINITION  ------------
------------------------------------------------