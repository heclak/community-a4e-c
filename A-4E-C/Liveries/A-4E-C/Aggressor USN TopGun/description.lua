name = "USN Aggressor TOPGUN, 1982"
countries = {"USA", "AUSAF"}

livery = {
  {"Top", DIFFUSE, "a4e_aggr_usn_topgun_top", true};
  {"Top", ROUGHNESS_METALLIC, "a4e_ext_top_RoughMet_lo", true};
  {"Bottom", DIFFUSE, "a4e_aggr_usn_topgun_bot", true};
  {"Bottom", ROUGHNESS_METALLIC, "a4e_ext_bottom_RoughMet_lo", true};
  {"Cockpit", DIFFUSE, "a4e_aggr_usn_topgun_bot", true};
  {"Gear and metal", DIFFUSE, "a4e_aggr_usn_topgun_bot", true};
  --{"cockpitWheelHardpoints", DIFFUSE, "a4e_ext_wheels_bays", true};
  --{"Gear Bay", DIFFUSE, "a4e_ext_wheels_bays", true};
  {"Pilot",	DIFFUSE, "a4e_pilot_usn", true};

  -- flaps, used on most liveries
  {"flaps_001", DIFFUSE, "a4e_bort_black", true};
  {"flaps_010", DIFFUSE, "a4e_bort_black", true};
  {"flaps_100", DIFFUSE, "empty", true};

  -- three digit, smaller nose numbers, used on most liveries
  {"nose_001", DIFFUSE, "empty", true};
  {"nose_010", DIFFUSE, "empty", true};
  {"nose_100", DIFFUSE, "empty", true};

  -- two digit top-of-tail, used on most USMC liveries
  {"tail_aggressor_001", DIFFUSE, "a4e_bort_black", true};
  {"tail_aggressor_010", DIFFUSE, "a4e_bort_black", true};

  -- three digit top-of-rudder, used on most USN liveries
  {"rudder_001", DIFFUSE, "empty", true};
  {"rudder_010", DIFFUSE, "empty", true};
  {"rudder_100", DIFFUSE, "empty", true};

  -- wing bort used on most USN liveries
  {"wing_001", DIFFUSE, "empty", true};
  {"wing_010", DIFFUSE, "empty", true};
  {"wing_100", DIFFUSE, "empty", true};

  -- 2-digit large nose numbers, used on USN/USMC aggressors
  {"nose_aggressor_001", DIFFUSE, "a4e_bort_black", true};
  {"nose_aggressor_010", DIFFUSE, "a4e_bort_black", true};

  -- 3-digit large tail numbers, used on some USN/USMC aggressors
  {"tail_001", DIFFUSE, "empty", true};
  {"tail_010", DIFFUSE, "empty", true};
  {"tail_100", DIFFUSE, "empty", true};

  -- custom fuel tanks: 150 gallon
  {"fuel_150_a4e", DIFFUSE, "a4e_aggr_usn_topgun_ft", true};

  -- custom fuel tank: 300 gallon left/right
  {"fuel_300lr_a4e", DIFFUSE, "a4e_aggr_usn_topgun_ft", true};

  -- custom fuel tank: 300 gallon center
  {"fuel_300c_a4e", DIFFUSE, "a4e_aggr_usn_topgun_ft", true};
}
