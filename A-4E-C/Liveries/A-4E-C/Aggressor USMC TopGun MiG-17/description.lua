name = "USMC TOPGUN MiG-17"
countries = {"USA", "AUSAF"}

livery = {
  {"Top", 0, "a4e-aggr-usmc-topgun-mig-17-top", true};
  {"Top", ROUGHNESS_METALLIC, "fus_top_v494_RoughMet_lo", true};
  {"Bottom", 0, "a4e-aggr-usmc-topgun-mig-17-bot", true};
  {"Bottom", ROUGHNESS_METALLIC, "fus_bot_v472_RoughMet_lo", true};
  {"Cockpit", 0, "a4e-aggr-usmc-topgun-mig-17-bot", true};
  {"Gear and metal", 0, "a4e-aggr-usmc-topgun-mig-17-bot", true};
  --{"Front",	0, "fus_front", true};
  --{"cockpitWheelHardpoints", 0, "details1cockpitwheelshardpoints", true};
  --{"Gear Bay", 0, "details1cockpitwheelshardpoints", true};

  -- flaps, used on most liveries
  {"flaps_001", 0, "a4e_bort_red", true};
  {"flaps_010", 0, "a4e_bort_red", true};
  {"flaps_100", 0, "empty", true};

  -- three digit, smaller nose numbers, used on most liveries
  {"nose_001", 0, "empty", true};
  {"nose_010", 0, "empty", true};
  {"nose_100", 0, "empty", true};

  -- two digit top-of-tail, used on most USMC liveries
  {"tail_aggressor_001", 0, "a4e_bort_black", true};
  {"tail_aggressor_010", 0, "a4e_bort_black", true};

  -- three digit top-of-rudder, used on most USN liveries
  {"rudder_001", 0, "empty", true};
  {"rudder_010", 0, "empty", true};
  {"rudder_100", 0, "empty", true};

  -- wing bort used on most USN liveries
  {"wing_001", 0, "empty", true};
  {"wing_010", 0, "empty", true};
  {"wing_100", 0, "empty", true};

  -- 2-digit large nose numbers, used on USN/USMC aggressors
  {"nose_aggressor_001", 0, "a4e_bort_red-gold", true};
  {"nose_aggressor_010", 0, "a4e_bort_red-gold", true};

  -- 3-digit large tail numbers, used on some USN/USMC aggressors
  {"tail_001", 0, "empty", true};
  {"tail_010", 0, "empty", true};
  {"tail_100", 0, "empty", true};

  -- custom fuel tanks: 150 gallon
  {"fuel_150_a4e", 0, "a4e-aggr-usmc-topgun-mig-17-ft", true};

  -- custom fuel tank: 300 gallon left/right
  {"fuel_300lr_a4e", 0, "a4e-aggr-usmc-topgun-mig-17-ft", true};

  -- custom fuel tank: 300 gallon center
  {"fuel_300c_a4e", 0, "a4e-aggr-usmc-topgun-mig-17-ft", true};
}
