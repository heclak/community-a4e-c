--[[ name your own skin in default language (en)
     you can also name the skin in more than one language,
     replace xx with the appropriate country code, e.g.
     ru, cn, cs, de, es, fr, or it ]]
name = "0 Unmarked"
--name_xx = ""

--[[ assign the countries ]]
countries = {
    "ABH",   --Abkhazia
    "DZA",   --Algeria
    "ARG",   --Argentina
    "AUS",   --Australia
    "AUT",   --Austria
    "BLR",   --Belarus
    "BEL",   --Belgium
    "BGR",   --Bulgaria
    "CAN",   --Canada
    "CUB",   --Cuba
    "CHL",   --Chile
    "CHN",   --China
    "HRV",   --Croatia
    "CZE",   --Czech Republic
    "CYP",   --Cyprus
    "DEN",   --Denmark
    "EGY",   --Egypt
    "FIN",   --Finland
    "FRA",   --France
    "GRG",   --Georgia
    "GER",   --Germany
    "GHN",   --Ghana
    "GRC",   --Greece
    "HND",   --Honduras
    "HUN",   --Hungary
    "IND",   --India
    "IDN",   --Indonesia
    "INS",   --Insurgents
    "IRN",   --Iran
    "IRQ",   --Iraq
    "ISR",   --Israel
    "ITA",   --Italy
    "JOR",   --Jordan
    "JPN",   --Japan
    "KAZ",   --Kazakhstan
    "LBN",   --Lebanon
    "LBY",   --Libya
    "MYS",   --Malaysia
    "MAR",   --Moroccoo
    "MEX",   --Mexico
    "NETH",  --Netherlands
    "PRK",   --North Korea
    "NOR",   --Norway
    "NGA",   --Nigeria
    "OMN",   --Oman
    "PAK",   --Pakistan
    "PER",   --Peru
    "PHL",   --Phllipines
    "POL",   --Poland
    "QAT",   --Qatar
    "ROU",   --Romania
    "RUS",   --Russia
    "SAU",   --Saudi Arabia
    "SRB",   --Serbia
    "SVK",   --Slovakia
    "SVN",   --Slovenia
    "RSA",   --South Africa
    "KOR",   --South Korea
    "RSO",   --South Ossetia
    "SPN",   --Spain
    "SDN",   --Sudan
    "SWE",   --Sweden
    "SUI",   --Switzerland
    "SYR",   --Syria
    "THA",   --Thailand
    "TUN",   --Tunisia
    "TUR",   --Turkey
    "UK",    --UK
    "UKR",   --Ukraine
    "ARE",   --United Arab Emirates
    "UN",    --United Nations Peacekeepers
    "USA",   --USA
    "AUSAF", --USAF Aggressors
    "VEN",   --Venezuela
    "VNM",   --Vietnam
    "YEM"    --Yemen
}

livery = {
  --{"Top", DIFFUSE, "a4e_ext_top", true};
  --{"Top", ROUGHNESS_METALLIC, "a4e_ext_top_RoughMet", true};
  --{"Bottom", DIFFUSE, "a4e_ext_bottom", true};
  --{"Bottom", ROUGHNESS_METALLIC, "a4e_ext_bottom_RoughMet", true};
  --{"Gear and metal", DIFFUSE, "a4e_ext_bottom", true};
  --{"Cockpit", DIFFUSE, "a4e_ext_bottom", true};
  --{"Front", 0, "a4e_ext_front", true};
  --{"cockpitWheelHardpoints", DIFFUSE, "a4e_ext_wheels_bays", true};
  --{"Gear Bay", DIFFUSE, "a4e_ext_wheels_bays", true};
 --{"Pilot", DIFFUSE, "a4e_pilot", true};

  -- flaps, used on most liveries
  {"flaps_001", DIFFUSE, "a4e_bort_white", true};
  {"flaps_010", DIFFUSE, "a4e_bort_white", true};
  {"flaps_100", DIFFUSE, "a4e_bort_white", true};

  -- three digit, smaller nose numbers, used on most liveries
  {"nose_001", DIFFUSE, "a4e_bort_black", true};
  {"nose_010", DIFFUSE, "a4e_bort_black", true};
  {"nose_100", DIFFUSE, "a4e_bort_black", true};

  -- two digit top-of-tail, used on most USMC liveries
  {"tail_aggressor_001", DIFFUSE, "empty", true};
  {"tail_aggressor_010", DIFFUSE, "empty", true};

  -- three digit top-of-rudder, used on most USN liveries
  {"rudder_001", DIFFUSE, "a4e_bort_black", true};
  {"rudder_010", DIFFUSE, "a4e_bort_black", true};
  {"rudder_100", DIFFUSE, "a4e_bort_black", true};

  -- wing bort used on most USN liveries
  {"wing_001", DIFFUSE, "a4e_bort_black", true};
  {"wing_010", DIFFUSE, "a4e_bort_black", true};
  {"wing_100", DIFFUSE, "a4e_bort_black", true};

  -- 2-digit large nose numbers, used on USN/USMC aggressors
  {"nose_aggressor_001", DIFFUSE, "empty", true};
  {"nose_aggressor_010", DIFFUSE, "empty", true};

  -- 3-digit large tail numbers, used on some USN/USMC aggressors
  {"tail_001", DIFFUSE, "empty", true};
  {"tail_010", DIFFUSE, "empty", true};
  {"tail_100", DIFFUSE, "empty", true};

  -- custom fuel tanks: 150 gallon
  --{"fuel_150_a4e", DIFFUSE, "uvmapsfueltank_dft150_dft300", true};

  -- custom fuel tank: 300 gallon left/right
  --{"fuel_300lr_a4e", DIFFUSE, "uvmapsfueltank_dft150_dft300", true};

  -- custom fuel tank: 300 gallon center
  --{"fuel_300c_a4e", DIFFUSE, "uvmapsfueltank_dft150_dft300", true};

  -- custom fuel tank: 400 gallon
  --{"fuel_400_a4e", DIFFUSE, "uvmapsfueltank_dft400", true};

  -- custom mer
  --{"MER-A4E", DIFFUSE, "a4e_mer", true};

  -- custom mk4 hipeg gun pod
  --{"mk4 HIPEG", DIFFUSE, "mk4", true};

  -- custom mk77 mod 0
  --{"mk77mod0", DIFFUSE, "uv_mk77_jones_002", true};

  -- custom mk77 mod 1
  --{"mk77mod1", DIFFUSE, "uv_mk77_jones_002", true};

  -- custom mk-81
  --{"MK_noses", DIFFUSE, "mk_noses_diff", true};
  --{"MK_81", DIFFUSE, "mk-81_diff", true};

  -- custom mk-81 snakeye
  --{"01 - Default", DIFFUSE, "mk81-se_uvw-01", true};

  -- custom mk-82
  --{"MK_82", DIFFUSE, "mk_82_diff", true};
  --{"MK_noses", DIFFUSE, "mk_noses_diff", true};
  --{"MK_82BT", DIFFUSE, "mk_82t_diff", true};
  --{"MK_82T_grey", DIFFUSE, "mk_82t_grey_diff", true};

  -- custom mk-82 snakeye
  --{"MK_noses", DIFFUSE, "mk_noses_diff", true};
  --{"MK_82_Snakeye", DIFFUSE, "mk_82snak_diff", true};
  --{"MK_82SnakTermo", DIFFUSE, "mk_82snakt_diff", true};
  --{"MK_82SnakT_gray", DIFFUSE, "mk_82snakt_grey_diff", true};

  -- custom mk-83
  --{"mk_83", DIFFUSE, "mk_83_diff", true};
  --{"MK_noses", DIFFUSE, "mk_noses_diff", true};
  --{"mk_83T", DIFFUSE, "mk_83t_diff", true};
  --{"MK_83Tgrey", DIFFUSE, "mk_83tgrey_diff", true};

  -- custom mk-84
  --{"mk_84", DIFFUSE, "mk_84_diff", true};
  --{"MK_noses", DIFFUSE, "mk_noses_diff", true};
  --{"mk_84T", DIFFUSE, "mk_84termo_diff", true};

  -- custom lau-3 rocket launcher
  --{"LAU-3", DIFFUSE, "lau-3_diffuse", true};
  --{"LAU-3", NORMAL_MAP, "lau-3_normal", true};
  --{"LAU-3", SPECULAR, "lau-3_specular", true};

  -- custom lau-10 rocket launcher
  --{"LAU_10", DIFFUSE, "lau_10_dif", true};
  --{"LAU_10", SPECULAR, "lau_10_dif_roughmet", true};

  -- custom lau-68 rocket launcher
  --{"LAU-68", DIFFUSE, "lau_68_diff", true};
  --{"LAU-68", NORMAL_MAP, "lau_68_nm", true};
  --{"LAU-68", SPECULAR, "lau_68_diff_roughmet", true};

  -- custom suu-7 cbu dispenser
  --{"SUU-7", DIFFUSE, "suu-7", true};

}
