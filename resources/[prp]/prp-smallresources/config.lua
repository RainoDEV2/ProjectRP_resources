Config = {}
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0
Config.DamageNeeded = 100.0
Config.EnableProne = false
Config.JointEffectTime = 45
Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25
Config.DefaultPrice = 20 -- carwash

ConsumeablesEat = {
    ["sandwich"] = math.random(35, 54),
    ["toastie"] = math.random(40, 50),
    ["twerks_candy"] = math.random(35, 54),
    ["snikkel_candy"] = math.random(40, 50),
    ["crisps"] = math.random(10, 20),
}

ConsumeablesDrink = {
    ["water_bottle"] = math.random(35, 54),
    ["cola"] = math.random(35, 54),
    ["coffee"] = math.random(40, 50),
}

ConsumeablesAlcohol = {
    ["whiskey"] = math.random(20, 30),
    ["beer"] = math.random(30, 40),
    ["vodka"] = math.random(20, 40),
    ["dusche-beer"] = math.random(5, 15),
    ["stronzo-beer"] = math.random(5, 15),
    ["am-beer"] = math.random(5, 15),
    ["logger-beer"] = math.random(5, 15),
    ["sunny-cocktail"] = math.random(5, 15),
}


Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

Config.BlacklistedVehs = {
    [`JET`] = true,
    [`LAZER`] = true,
    [`ANNIHILATOR`] = true,
    [`SAVAGE`] = true,
    [`TITAN`] = true,
    [`MAVERICK`] = true,
    [`BLIMP`] = true,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

Config.Teleports = {
    --Elevator @ labs
    [1] = {
        [1] = {
            coords = vector4(3540.74, 3675.59, 20.99, 167.5),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(3540.74, 3675.59, 28.11, 172.5),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Down'
        },
    },
    --Coke Processing Enter/Exit
    [2] = {
        [1] = {
            coords = vector4(909.49, -1589.22, 30.51, 92.24),
            ["AllowVehicle"] = false, 
            drawText = '[E] Enter Coke Processing'
        },
        [2] = {
            coords = vector4(1088.81, -3187.57, -38.99, 181.7),
            ["AllowVehicle"] = false,
            drawText = '[E] Leave'
        },
    },
    -- Estate Agents Office Enter/Exit
    [3] = {
        [1] = {
            coords = vector4(-116.61, -603.16, 36.28, 249.09),
            ["AllowVehicle"] = false, 
            drawText = '[E] Enter Office'
        },
        [2] = {
            coords = vector4(-141.56, -620.97, 168.82, 276.82),
            ["AllowVehicle"] = false,
            drawText = '[E] Leave Office'
        },
    },
}

Config.Locations = { -- carwash
    [1] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(26.5906, -1392.0261, 27.3634),
    },
    [2] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(167.1034, -1719.4704, 27.2916),
    },
    [3] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-74.5693, 6427.8715, 29.4400),
    },
    [4] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-1200.4, -1720.46, 3.40),
    },
    [5] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(1363.22, 3592.7, 34.41),
    },
    [6] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-699.6325, -932.7043, 17.0139),
    }
}

Config.PropList = {
    -- Casual Props
    ['Drill'] = {
        ['name'] = 'DrilBoor',
        ['prop'] = 'hei_prop_heist_drill',
        ['hash'] = GetHashKey('hei_prop_heist_drill'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.14,
            ['Y'] = 0.0,
            ['Z'] = -0.01,
            ['XR'] = 90.0,
            ['YR'] = -90.0,
            ['ZR'] = 180.0,
        },
    },
    ['Sekspop'] = {
        ['name'] = 'Sekspop',
        ['prop'] = 'v_61_bth_mesh_sexdoll',
        ['hash'] = GetHashKey('v_61_bth_mesh_sexdoll'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.14,
            ['Y'] = 0.0,
            ['Z'] = -0.01,
            ['XR'] = 90.0,
            ['YR'] = -90.0,
            ['ZR'] = 180.0,
        },
    },
    ['Duffel'] = {
        ['name'] = 'DuffelBag',
        ['prop'] = 'xm_prop_x17_bag_01a',
        ['hash'] = GetHashKey('xm_prop_x17_bag_01a'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.27,
            ['Y'] = 0.15,
            ['Z'] = 0.05,
            ['XR'] = 35.0,
            ['YR'] = -125.0,
            ['ZR'] = 50.0,
        },
    },
    ['Boombox'] = {
        ['name'] = 'Boombox',
        ['prop'] = 'prop_boombox_01',
        ['hash'] = GetHashKey('prop_boombox_01'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.27,
            ['Y'] = 0.15,
            ['Z'] = 0.05,
            ['XR'] = 35.0,
            ['YR'] = -125.0,
            ['ZR'] = 50.0,
        },
    },
	['Pizzabox'] = {
        ['name'] = 'Pizzabox',
        ['prop'] = 'prop_pizza_box_02',
        ['hash'] = GetHashKey('prop_pizza_box_02'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.30,
            ['Y'] = 0.15,
            ['Z'] = -0.20,
            ['XR'] = -50.00,
            ['YR'] = 250.00,
            ['ZR'] = 10.00,
        },
    },
	['Pizzadoos'] = {
        ['name'] = 'Pizzadoos',
        ['prop'] = 'prop_pizza_box_02',
        ['hash'] = GetHashKey('prop_pizza_box_02'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.30,
            ['Y'] = 0.15,
            ['Z'] = -0.20,
            ['XR'] = -50.00,
            ['YR'] = 250.00,
            ['ZR'] = 10.00,
        },
    },
    ['Cup'] = {
        ['name'] = 'Cup',
        ['prop'] = 'prop_cs_paper_cup',
        ['hash'] = GetHashKey('prop_cs_paper_cup'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['FishingRod'] = {
        ['name'] = 'Fishing Rod',
        ['prop'] = 'prop_fishing_rod_01',
        ['hash'] = GetHashKey('prop_fishing_rod_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.08,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = -100.0,
            ['YR'] = 0.0,
            ['ZR'] = -20.0,
        },
    },
    ['Boombox'] = {
        ['name'] = 'Boombox',
        ['prop'] = 'prop_boombox_01',
        ['hash'] = GetHashKey('prop_boombox_01'),
        ['bone-index'] = {
            ['bone'] = 1,
            ['X'] = 1,
            ['Y'] = 1,
            ['Z'] = 1,
            ['XR'] = 1,
            ['YR'] = 1,
            ['ZR'] = 1,
        },
    },
    ['Pills'] = {
        ['name'] = 'Pills',
        ['prop'] = 'prop_cs_pills',
        ['hash'] = GetHashKey('prop_cs_pills'),
        ['bone-index'] = {
            ['bone'] = 1,
            ['X'] = 1,
            ['Y'] = 1,
            ['Z'] = 1,
            ['XR'] = 1,
            ['YR'] = 1,
            ['ZR'] = 1,
        },
    },
    ['ShoppingBag'] = {
        ['name'] = 'Shopping bag',
        ['prop'] = 'prop_shopping_bags01', 
        ['hash'] = GetHashKey('prop_shopping_bags01'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.05,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 35.0,
            ['YR'] = -125.0,
            ['ZR'] = 0.0,
        },
    },
    ['CrackPipe'] = {
        ['name'] = 'Crack Pipe',
        ['prop'] = 'prop_cs_crackpipe',
        ['hash'] = GetHashKey('prop_cs_crackpipe'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.05,
            ['Z'] = 0.0,
            ['XR'] = 135.0,
            ['YR'] = -100.0,
            ['ZR'] = 0.0,
        },
    },
    ['Bong'] = {
        ['name'] = 'Bong',
        ['prop'] = 'prop_bong_01',
        ['hash'] = GetHashKey('prop_bong_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.11,
            ['Y'] = -0.23,
            ['Z'] = 0.01,
            ['XR'] = -90.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['HealthPack'] = {
        ['name'] = 'EHBO Kit',
        ['prop'] = 'prop_ld_health_pack',
        ['hash'] = GetHashKey('prop_ld_health_pack'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.15,
            ['Y'] = 0.08,
            ['Z'] = 0.1,
            ['XR'] = 180.0,
            ['YR'] = 220.0,
            ['ZR'] = 0.0,
        },
    },
    ['ReporterCam'] = {
        ['name'] = 'Weazel News Camera',
        ['prop'] = 'prop_v_cam_01',
        ['hash'] = GetHashKey('prop_v_cam_01'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.13,
            ['Y'] = 0.25,
            ['Z'] = -0.03,
            ['XR'] = -85.0,
            ['YR'] = 0.0,
            ['ZR'] = -80.0,
        },
    },
    ['ReporterMic'] = {
        ['name'] = 'Weazel News Mic',
        ['prop'] = 'p_ing_microphonel_01',
        ['hash'] = GetHashKey('p_ing_microphonel_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.1,
            ['Y'] = 0.05,
            ['Z'] = 0.0,
            ['XR'] = -85.0,
            ['YR'] = -80.0,
            ['ZR'] = -80.0,
        },
    },
    ['BriefCase'] = {
        ['name'] = 'Briefcase',
        ['prop'] = 'prop_ld_case_01',
        ['hash'] = GetHashKey('prop_ld_case_01'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.09,
            ['Y'] = -0.012,
            ['Z'] = 0.01,
            ['XR'] = 320.0,
            ['YR'] = -100.0,
            ['ZR'] = 0.0,
        },
    },
    ['GunCase'] = {
        ['name'] = 'Gun Case',
        ['prop'] = 'prop_box_guncase_01a',
        ['hash'] = GetHashKey('prop_box_guncase_01a'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.18,
            ['Y'] = 0.05,
            ['Z'] = 0.0,
            ['XR'] = 215.0,
            ['YR'] = -175.0,
            ['ZR'] = 100.0,
        },
    },
    ['Tablet'] = {
        ['name'] = 'Police Tablet',
        ['prop'] = 'prop_cs_tablet',
        ['hash'] = GetHashKey('prop_cs_tablet'),
        ['bone-index'] = {
            ['bone'] = 60309,
            ['X'] = 0.03,
            ['Y'] = 0.002,
            ['Z'] = -0.0,
            ['XR'] = 0.0,
            ['YR'] = 160.0,
            ['ZR'] = 0.0,
        },
    }, 
    ['StolenTv'] = {
        ['name'] = 'A tv',
        ['prop'] = 'prop_tv_flat_02',
        ['hash'] = GetHashKey('prop_tv_flat_02'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.15,
            ['Y'] = 0.10,
            ['Z'] = -0.20,
            ['XR'] = -50.00,
            ['YR'] = 250.00,
            ['ZR'] = 10.00,
        },
    },
    ['StolenPc'] = {
        ['name'] = 'A computer',
        ['prop'] = 'prop_dyn_pc_02',
        ['hash'] = GetHashKey('prop_dyn_pc_02'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.15,
            ['Y'] = 0.10,
            ['Z'] = -0.22,
            ['XR'] = -80.00,
            ['YR'] = -15.00,
            ['ZR'] = -60.00,
        },
    },
    ['StolenMicro'] = {
        ['name'] = 'A microwave',
        ['prop'] = 'prop_microwave_1',
        ['hash'] = GetHashKey('prop_microwave_1'),
        ['bone-index'] = {
            ['bone'] = 57005,
            ['X'] = 0.30,
            ['Y'] = 0.15,
            ['Z'] = -0.20,
            ['XR'] = -50.00,
            ['YR'] = 250.00,
            ['ZR'] = 10.00,
        },
    },
    ['Schaar'] = {
        ['name'] = 'Scissors',
        ['prop'] = 'prop_cs_scissors',
        ['hash'] = GetHashKey('prop_cs_scissors'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.07,
            ['Z'] = 0.02,
            ['XR'] = 120.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
    -- Food Props
    ['hamburger'] = {
        ['name'] = 'Hamburger',
        ['prop'] = 'prop_cs_burger_01',
        ['hash'] = GetHashKey('prop_cs_burger_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.07,
            ['Z'] = 0.02,
            ['XR'] = 120.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
    ['sandwich'] = {
        ['name'] = 'Sandwich',
        ['prop'] = 'prop_sandwich_01',
        ['hash'] = GetHashKey('prop_sandwich_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.05,
            ['Z'] = 0.02,
            ['XR'] = -50.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
	['pizza'] = {
        ['name'] = 'Pizza',
        ['prop'] = 'prop_sandwich_01',
        ['hash'] = GetHashKey('prop_sandwich_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.05,
            ['Z'] = 0.02,
            ['XR'] = -50.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
    ['chocolade'] = {
        ['name'] = 'Chocolade',
        ['prop'] = 'prop_choc_meto',
        ['hash'] = GetHashKey('prop_choc_meto'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.05,
            ['Z'] = 0.02,
            ['XR'] = -50.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
    ['donut'] = {
        ['name'] = 'Donut',
        ['prop'] = 'prop_amb_donut',
        ['hash'] = GetHashKey('prop_amb_donut'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.05,
            ['Z'] = 0.02,
            ['XR'] = -50.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
    ['taco'] = {
        ['name'] = 'Tacootje',
        ['prop'] = 'prop_taco_01',
        ['hash'] = GetHashKey('prop_taco_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.07,
            ['Z'] = 0.02,
            ['XR'] = 160.0,
            ['YR'] = 0.0,
            ['ZR'] = -50.0,
        },
    },
    ['burger-fries'] = {
        ['name'] = 'Frietekes',
        ['prop'] = 'prop_food_bs_chips',
        ['hash'] = GetHashKey('prop_food_bs_chips'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.12,
            ['Y'] = 0.04,
            ['Z'] = 0.05,
            ['XR'] = 130.0,
            ['YR'] = 8.0,
            ['ZR'] = 200.0,
        },
    },
	['burger'] = {
        ['name'] = 'Burger',
        ['prop'] = 'prop_cs_burger_01',
        ['hash'] = GetHashKey('prop_cs_burger_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.07,
            ['Z'] = 0.02,
            ['XR'] = 120.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
    ['footlong'] = {
        ['name'] = 'Foot Long',
        ['prop'] = 'prop_cs_hotdog_01',
        ['hash'] = GetHashKey('prop_cs_hotdog_01'),
        ['bone-index'] = {
            ['bone'] = 18905,
            ['X'] = 0.13,
            ['Y'] = 0.07,
            ['Z'] = 0.02,
            ['XR'] = 120.0,
            ['YR'] = 16.0,
            ['ZR'] = 60.0,
        },
    },
	
    -- Drink Props
    ['water'] = {
        ['name'] = 'Flesje Water',
        ['prop'] = 'prop_ld_flow_bottle',
        ['hash'] = GetHashKey('prop_ld_flow_bottle'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['glasschampagne'] = {
        ['name'] = 'Glas Champagne',
        ['prop'] = 'prop_drink_whisky',
        ['hash'] = GetHashKey('prop_drink_whisky'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['whiskey'] = {
        ['name'] = 'Glas Whisky',
        ['prop'] = 'prop_drink_whisky',
        ['hash'] = GetHashKey('prop_drink_whisky'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['tequila'] = {
        ['name'] = 'Tequila',
        ['prop'] = 'prop_tequila',
        ['hash'] = GetHashKey('prop_tequila'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['mojito'] = {
        ['name'] = 'Mojito Cocktail',
        ['prop'] = 'prop_cocktail',
        ['hash'] = GetHashKey('prop_cocktail'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['coffee'] = {
        ['name'] = 'KOFFIEEE',
        ['prop'] = 'p_amb_coffeecup_01',
        ['hash'] = GetHashKey('p_amb_coffeecup_01'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['cola'] = {
        ['name'] = 'Lekker blikkie cola',
        ['prop'] = 'prop_ecola_can',
        ['hash'] = GetHashKey('prop_ecola_can'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = 0.0,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
    ['burger-soft'] = {
        ['name'] = 'Soft Drink',
        ['prop'] = 'ng_proc_sodacup_01a',
        ['hash'] = GetHashKey('ng_proc_sodacup_01a'),
        ['bone-index'] = {
            ['bone'] = 28422,
            ['X'] = 0.0,
            ['Y'] = 0.0,
            ['Z'] = -0.07,
            ['XR'] = 0.0,
            ['YR'] = 0.0,
            ['ZR'] = 0.0,
        },
    },
}