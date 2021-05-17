name = "Community A-4E I: Autumn Splinter"
countries = {
    "ABH",  --Abkhazia
    "ARG",  --Argentina
    "AUS",  --Australia
    "AUT",  --Austria
    "BLR",  --Belarus
    "BEL",  --Belgium
    "BGR",  --Bulgaria
    "CAN",  --Canada
    "CHL",  --Chile
    "CHN",  --China
    "HRV",  --Croatia
    "CZE",  --Czech Republic
    "DEN",  --Denmark
    "EGY",  --Egypt
    "FIN",  --Finland
    "FRA",  --France
    "GRG",  --Georgia
    "GER",  --Germany
    "GRC",  --Greece
    "HUN",  --Hungary
    "IND",  --India
    "INS",  --Insurgents
    "IRN",  --Iran
    "IRQ",  --Iraq
    "ISR",  --Israel
    "ITA",  --Italy
    "JPN",  --Japan
    "KAZ",  --Kazakhstan
    "NETH", --Netherlands
    "PRK",  --North Korea
    "NOR",  --Norway
    "PAK",  --Pakistan
    "POL",  --Poland
    "ROU",  --Romania
    "RUS",  --Russia
    "SAU",  --Saudi Arabia
    "SRB",  --Serbia
    "SVK",  --Slovakia
    "KOR",  --South Korea
    "RSO",  --South Ossetia
    "SPN",  --Spain
    "SWE",  --Sweden
    "SUI",  --Switzerland
    "SYR",  --Syria
    "TUR",  --Turkey
    "UK",   --UK
    "UKR",  --Ukraine
    "USA",  --USA
    "AUSAF" --USAF Aggressors
}

livery =
{
  {"Top", DIFFUSE, "a4e_community_top", true};
  {"Top", ROUGHNESS_METALLIC, "a4e_ext_top_RoughMet_hi", true};
  {"Bottom", DIFFUSE, "a4e_community_bot", true};
  {"Bottom", ROUGHNESS_METALLIC, "a4e_ext_bottom_RoughMet_hi", true};
  {"Gear and metal", DIFFUSE, "a4e_community_bot", true};
  {"Cockpit", DIFFUSE, "a4e_community_bot", true};
  --{"Front",	0, "a4e_ext_front", true};
  --{"cockpitWheelHardpoints", DIFFUSE, "a4e_ext_wheels_bays", true};
  --{"Gear Bay", DIFFUSE, "a4e_ext_wheels_bays", true};

  -- flaps, used on most liveries
  {"flaps_001", DIFFUSE, "a4e_bort_white_smooth", true};
  {"flaps_010", DIFFUSE, "a4e_bort_white_smooth", true};
  {"flaps_100", DIFFUSE, "empty", true};

  -- three digit, smaller nose numbers, used on most liveries
  {"nose_001", DIFFUSE, "empty", true};
  {"nose_010", DIFFUSE, "empty", true};
  {"nose_100", DIFFUSE, "empty", true};

  -- two digit top-of-tail, used on most USMC liveries
  {"tail_aggressor_001", DIFFUSE, "a4e_bort_grey_smooth", true};
  {"tail_aggressor_010", DIFFUSE, "a4e_bort_grey_smooth", true};

  -- three digit top-of-rudder, used on most USN liveries
  {"rudder_001", DIFFUSE, "empty", true};
  {"rudder_010", DIFFUSE, "empty", true};
  {"rudder_100", DIFFUSE, "empty", true};

  -- wing bort used on most USN liveries
  {"wing_001", DIFFUSE, "empty", true};
  {"wing_010", DIFFUSE, "empty", true};
  {"wing_100", DIFFUSE, "empty", true};

  -- 2-digit large nose numbers, used on USN/USMC aggressors
  {"nose_aggressor_001", DIFFUSE, "a4e_bort_red-white_smooth", true};
  {"nose_aggressor_010", DIFFUSE, "a4e_bort_red-white_smooth", true};

  -- 3-digit large tail numbers, used on some USN/USMC aggressors
  {"tail_001", DIFFUSE, "empty", true};
  {"tail_010", DIFFUSE, "empty", true};
  {"tail_100", DIFFUSE, "empty", true};

  -- custom fuel tanks: 150 gallon
  {"fuel_150_a4e", DIFFUSE, "a4e_ft_community_ft", true};

  -- custom fuel tank: 300 gallon left/right
  {"fuel_300lr_a4e", DIFFUSE, "a4e_ft_community_ft", true};

  -- custom fuel tank: 300 gallon center
  {"fuel_300c_a4e", DIFFUSE, "a4e_ft_community_ft", true};
}
