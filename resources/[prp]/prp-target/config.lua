Config, Types, Bones = {}, {}, {}
Types[1], Types[2], Types[3] = {}, {}, {}

-- This is the vehicle bones table, this is needed to verify if the vehicle bone exists when checking them, here is a list of vehicle bones you can use, all of them are included in this table: https://wiki.rage.mp/index.php?title=Vehicle_Bones
Config.VehicleBones = {'chassis', 'chassis_lowlod', 'chassis_dummy', 'seat_dside_f', 'seat_dside_r', 'seat_dside_r1', 'seat_dside_r2', 'seat_dside_r3', 'seat_dside_r4', 'seat_dside_r5', 'seat_dside_r6', 'seat_dside_r7', 'seat_pside_f', 'seat_pside_r', 'seat_pside_r1', 'seat_pside_r2', 'seat_pside_r3', 'seat_pside_r4', 'seat_pside_r5', 'seat_pside_r6', 'seat_pside_r7', 'window_lf1', 'window_lf2', 'window_lf3', 'window_rf1', 'window_rf2', 'window_rf3', 'window_lr1', 'window_lr2', 'window_lr3', 'window_rr1', 'window_rr2', 'window_rr3', 'door_dside_f', 'door_dside_r', 'door_pside_f', 'door_pside_r', 'handle_dside_f', 'handle_dside_r', 'handle_pside_f', 'handle_pside_r', 'wheel_lf', 'wheel_rf', 'wheel_lm1', 'wheel_rm1', 'wheel_lm2', 'wheel_rm2', 'wheel_lm3', 'wheel_rm3', 'wheel_lr', 'wheel_rr', 'suspension_lf', 'suspension_rf', 'suspension_lm', 'suspension_rm', 'suspension_lr', 'suspension_rr', 'spring_rf', 'spring_lf', 'spring_rr', 'spring_lr', 'transmission_f', 'transmission_m', 'transmission_r', 'hub_lf', 'hub_rf', 'hub_lm1', 'hub_rm1', 'hub_lm2', 'hub_rm2', 'hub_lm3', 'hub_rm3', 'hub_lr', 'hub_rr', 'windscreen', 'windscreen_r', 'window_lf', 'window_rf', 'window_lr', 'window_rr', 'window_lm', 'window_rm', 'bodyshell', 'bumper_f', 'bumper_r', 'wing_rf', 'wing_lf', 'bonnet', 'boot', 'exhaust', 'exhaust_2', 'exhaust_3', 'exhaust_4', 'exhaust_5', 'exhaust_6', 'exhaust_7', 'exhaust_8', 'exhaust_9', 'exhaust_10', 'exhaust_11', 'exhaust_12', 'exhaust_13', 'exhaust_14', 'exhaust_15', 'exhaust_16', 'engine', 'overheat', 'overheat_2', 'petrolcap', 'petrolcap', 'petroltank', 'petroltank_l', 'petroltank_r', 'steering', 'hbgrip_l', 'hbgrip_r', 'headlight_l', 'headlight_r', 'taillight_l', 'taillight_r', 'indicator_lf', 'indicator_rf', 'indicator_lr', 'indicator_rr', 'brakelight_l', 'brakelight_r', 'brakelight_m', 'reversinglight_l', 'reversinglight_r', 'extralight_1', 'extralight_2', 'extralight_3', 'extralight_4', 'numberplate', 'interiorlight', 'siren1', 'siren2', 'siren3', 'siren4', 'siren5', 'siren6', 'siren7', 'siren8', 'siren9', 'siren10', 'siren11', 'siren12', 'siren13', 'siren14', 'siren15', 'siren16', 'siren17', 'siren18', 'siren19', 'siren20', 'siren_glass1', 'siren_glass2', 'siren_glass3', 'siren_glass4', 'siren_glass5', 'siren_glass6', 'siren_glass7', 'siren_glass8', 'siren_glass9', 'siren_glass10', 'siren_glass11', 'siren_glass12', 'siren_glass13', 'siren_glass14', 'siren_glass15', 'siren_glass16', 'siren_glass17', 'siren_glass18', 'siren_glass19', 'siren_glass20', 'spoiler', 'struts', 'misc_a', 'misc_b', 'misc_c', 'misc_d', 'misc_e', 'misc_f', 'misc_g', 'misc_h', 'misc_i', 'misc_j', 'misc_k', 'misc_l', 'misc_m', 'misc_n', 'misc_o', 'misc_p', 'misc_q', 'misc_r', 'misc_s', 'misc_t', 'misc_u', 'misc_v', 'misc_w', 'misc_x', 'misc_y', 'misc_z', 'misc_1', 'misc_2', 'weapon_1a', 'weapon_1b', 'weapon_1c', 'weapon_1d', 'weapon_1a_rot', 'weapon_1b_rot', 'weapon_1c_rot', 'weapon_1d_rot', 'weapon_2a', 'weapon_2b', 'weapon_2c', 'weapon_2d', 'weapon_2a_rot', 'weapon_2b_rot', 'weapon_2c_rot', 'weapon_2d_rot', 'weapon_3a', 'weapon_3b', 'weapon_3c', 'weapon_3d', 'weapon_3a_rot', 'weapon_3b_rot', 'weapon_3c_rot', 'weapon_3d_rot', 'weapon_4a', 'weapon_4b', 'weapon_4c', 'weapon_4d', 'weapon_4a_rot', 'weapon_4b_rot', 'weapon_4c_rot', 'weapon_4d_rot', 'turret_1base', 'turret_1barrel', 'turret_2base', 'turret_2barrel', 'turret_3base', 'turret_3barrel', 'ammobelt', 'searchlight_base', 'searchlight_light', 'attach_female', 'roof', 'roof2', 'soft_1', 'soft_2', 'soft_3', 'soft_4', 'soft_5', 'soft_6', 'soft_7', 'soft_8', 'soft_9', 'soft_10', 'soft_11', 'soft_12', 'soft_13', 'forks', 'mast', 'carriage', 'fork_l', 'fork_r', 'forks_attach', 'frame_1', 'frame_2', 'frame_3', 'frame_pickup_1', 'frame_pickup_2', 'frame_pickup_3', 'frame_pickup_4', 'freight_cont', 'freight_bogey', 'freightgrain_slidedoor', 'door_hatch_r', 'door_hatch_l', 'tow_arm', 'tow_mount_a', 'tow_mount_b', 'tipper', 'combine_reel', 'combine_auger', 'slipstream_l', 'slipstream_r', 'arm_1', 'arm_2', 'arm_3', 'arm_4', 'scoop', 'boom', 'stick', 'bucket', 'shovel_2', 'shovel_3', 'Lookat_UpprPiston_head', 'Lookat_LowrPiston_boom', 'Boom_Driver', 'cutter_driver', 'vehicle_blocker', 'extra_1', 'extra_2', 'extra_3', 'extra_4', 'extra_5', 'extra_6', 'extra_7', 'extra_8', 'extra_9', 'extra_ten', 'extra_11', 'extra_12', 'break_extra_1', 'break_extra_2', 'break_extra_3', 'break_extra_4', 'break_extra_5', 'break_extra_6', 'break_extra_7', 'break_extra_8', 'break_extra_9', 'break_extra_10', 'mod_col_1', 'mod_col_2', 'mod_col_3', 'mod_col_4', 'mod_col_5', 'handlebars', 'forks_u', 'forks_l', 'wheel_f', 'swingarm', 'wheel_r', 'crank', 'pedal_r', 'pedal_l', 'static_prop', 'moving_prop', 'static_prop2', 'moving_prop2', 'rudder', 'rudder2', 'wheel_rf1_dummy', 'wheel_rf2_dummy', 'wheel_rf3_dummy', 'wheel_rb1_dummy', 'wheel_rb2_dummy', 'wheel_rb3_dummy', 'wheel_lf1_dummy', 'wheel_lf2_dummy', 'wheel_lf3_dummy', 'wheel_lb1_dummy', 'wheel_lb2_dummy', 'wheel_lb3_dummy', 'bogie_front', 'bogie_rear', 'rotor_main', 'rotor_rear', 'rotor_main_2', 'rotor_rear_2', 'elevators', 'tail', 'outriggers_l', 'outriggers_r', 'rope_attach_a', 'rope_attach_b', 'prop_1', 'prop_2', 'elevator_l', 'elevator_r', 'rudder_l', 'rudder_r', 'prop_3', 'prop_4', 'prop_5', 'prop_6', 'prop_7', 'prop_8', 'rudder_2', 'aileron_l', 'aileron_r', 'airbrake_l', 'airbrake_r', 'wing_l', 'wing_r', 'wing_lr', 'wing_rr', 'engine_l', 'engine_r', 'nozzles_f', 'nozzles_r', 'afterburner', 'wingtip_1', 'wingtip_2', 'gear_door_fl', 'gear_door_fr', 'gear_door_rl1', 'gear_door_rr1', 'gear_door_rl2', 'gear_door_rr2', 'gear_door_rml', 'gear_door_rmr', 'gear_f', 'gear_rl', 'gear_lm1', 'gear_rr', 'gear_rm1', 'gear_rm', 'prop_left', 'prop_right', 'legs', 'attach_male', 'draft_animal_attach_lr', 'draft_animal_attach_rr', 'draft_animal_attach_lm', 'draft_animal_attach_rm', 'draft_animal_attach_lf', 'draft_animal_attach_rf', 'wheelcover_l', 'wheelcover_r', 'barracks', 'pontoon_l', 'pontoon_r', 'no_ped_col_step_l', 'no_ped_col_strut_1_l', 'no_ped_col_strut_2_l', 'no_ped_col_step_r', 'no_ped_col_strut_1_r', 'no_ped_col_strut_2_r', 'light_cover', 'emissives', 'neon_l', 'neon_r', 'neon_f', 'neon_b', 'dashglow', 'doorlight_lf', 'doorlight_rf', 'doorlight_lr', 'doorlight_rr', 'unknown_id', 'dials', 'engineblock', 'bobble_head', 'bobble_base', 'bobble_hand', 'chassis_Control'}

----------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------

-- Set to true to enable standalone functionality
Config.Standalone = false

-- It's possible to interact with entities through walls so this should be low
Config.MaxDistance = 3.0

-- Enable debug options and distance preview
Config.Debug = false

-- Enable outlines around the entity you're looking at
Config.EnableOutline = false

-- Enable default options (Toggling vehicle doors)
Config.EnableDefaultOptions = false

-- Key to open the target
Config.OpenKey = 'LMENU' -- Left Alt
Config.OpenControlKey = 19 -- Control for keypress detection also Left Alt, controls are found here https://docs.fivem.net/docs/game-references/controls/

-- Key to open the menu
Config.MenuControlKey = 238 -- Control for keypress detection, this is the Right Mouse Button, controls are found here https://docs.fivem.net/docs/game-references/controls/

----------------------------------------------------------------------------------------
-- Target Configs
----------------------------------------------------------------------------------------

-- These are all empty for you to fill in, refer to the .md files for help in filling these in

Config.CircleZones = {

}

Config.BoxZones = {
	-- Burgershot
	["fries"] = {
    name = "fries",
    coords = vector3(-1202.0, -898.69, 13.98),
    length = 1.7,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.18,
    maxZ=14.18,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:bake:fries",
        icon = "fas fa-drumstick-bite",
        label = "Frying french fries",
        job = "burger",
      },
    },
    distance = 2.0
  },
  ["meat"] = {
    name = "meat",
    coords = vector3(-1203.0, -897.32, 13.98),
    length = 1.7,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.38,
    maxZ=14.38,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:create:meat1",
        icon = "fas fa-drumstick-bite",
        label = "Bake Meat Carcass 1 Star",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:create:meat2",
        icon = "fas fa-drumstick-bite",
        label = "Bake Meat Carcass 2 Stars",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:create:meat3",
        icon = "fas fa-drumstick-bite",
        label = "Bake Meat Carcass 3 Stars",
        job = "burger",
      },
    },
    distance = 1.0
  },
	["drinks"] = {
    name = "drinks",
    coords = vector3(-1200.04, -895.42, 13.98),
    length = 2.5,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.98,
    maxZ=14.98,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:create:soda",
        icon = "fas fa-wine-bottle",
        label = "Make Soda",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:create:coffee",
        icon = "fas fa-wine-bottle",
        label = "Make Coffee",
        job = "burger",
      },
    },
    distance = 1.0
  },
  ["burgers"] = {
    name = "burgers",
    coords = vector3(-1198.37, -898.0, 13.98),
    length = 1.7,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.18,
    maxZ=14.18,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:create:burgerbleeder",
        icon = "fas fa-wine-bottle",
        label = "Make a Bleeder Burger",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:create:burger-heartstopper",
        icon = "fas fa-wine-bottle",
        label = "Make a Heart Stopper Burger",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:create:burger-moneyshot",
        icon = "fas fa-wine-bottle",
        label = "Make a Money Shot Burger",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:create:burger-torpedo",
        icon = "fas fa-wine-bottle",
        label = "Make a Torpedo Burger",
        job = "burger",
      },
    },
    distance = 1.0
  },
  ["register"] = {
    name = "register",
    coords = vector3(-1196.34, -890.9, 13.98),
    length = 0.5,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.58,
    maxZ=14.58,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:open:register",
        icon = "fas fa-coins",
        label = "Register",
        job = "burger",
      },
      {
        type = "client",
        event = "prp-burgershot:client:open:payment",
        icon = "fas fa-coins",
        label = "Payment",
      },
    },
    distance = 1.5
  },
  ["sell"] = {
    name = "sell",
    coords = vector3(-1194.91, -892.83, 13.98),
    length = 1,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.58,
    maxZ=14.58,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:open:tray",
        icon = "fas fa-utensils",
        label = "Tray",
      },
    },
    distance = 1.0
  },
  ["sell2"] = {
    name = "sell2",
    coords = vector3(-1193.73, -906.91, 13.7),
    length = 1,
    width = 1,
    heading = 350,
    debugPoly = false,
    minZ=10.9,
    maxZ=14.9,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:open:box",
        icon = "fas fa-utensils",
        label = "Window",
      },
    },
    distance = 1.0
  },
	["storage"] = {
    name = "storage",
    coords = vector3(-1197.45, -894.62, 13.98),
    length = 1.5,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ=10.78,
    maxZ=14.78,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:open:hot:storage",
        icon = "fas fa-hamburger",
        label = "BurgerShot Storage",
        job = "burger",
      },
    },
    distance = 1.0
  },
  ["burgshop"] = {
    name = "burgshop",
    coords = vector3(-1196.6, -902.14, 13.98),
    length = 1,
    width = 1.7,
    heading = 35,
    debugPoly = false,
    minZ=11.18,
    maxZ=15.18,
    options = {
      {
        type = "client",
        event = "prp-burgershot:client:open:shop",
        icon = "fas fa-box-open",
        label = "BurgerShot Fridge",
        job = "burger",
      },
    },
    distance = 1.0
  },
	--Cityhall
	["cityhall"] = {
    name = "cityhall",
    coords = vector3(-555.23, -186.5, 38.28),
    length = 1,
    width = 1,
    heading = 35,
    debugPoly = false,
    minZ= 34.88,
    maxZ= 38.88,
    options = {
      {
        type = "client",
        event = "prp-cityhall:client:OpenCityMenu",
        icon = "fas fa-briefcase",
        label = "City Services Menu",
      },
    },
    distance = 1.0
  },
  -- Pizzeria
  ["pregister"] = {
    name = "pregister",
    coords = vector3(290.69, -976.84, 29.43),
    length = 1,
    width = 0.6,
    heading = 0,
    debugPoly = false,
    minZ=26.03,
    maxZ=30.03,
    options = {
      {
        type = "client",
        event = "prp-pizzeria:client:open:register",
        icon = "fas fa-coins",
        label = "Register",
        job = "pizza",
      },
      {
        type = "client",
        event = "prp-pizzeria:client:open:payment",
        icon = "fas fa-coins",
        label = "Payment",
      },
    },
    distance = 1.5
  },
  ["deliverp"] = {
    name = "deliverp",
    coords = vector3(286.68, -976.8, 29.43),
    length = 1,
    width = 0.6,
    heading = 0,
    debugPoly = false,
    minZ=25.83,
    maxZ=29.83,
    options = {
      {
        type = "client",
        event = "prp-pizzeria:client:deliver",
        icon = "fas fa-comments",
        label = "Deliver",
        job = "pizza",
      },
    },
    distance = 1.0
  },
  ["bakepizza"] = {
    name = "bakepizza",
    coords = vector3(288.07, -980.56, 29.43),
    length = 1,
    width = 2,
    heading = 0,
    debugPoly = false,
    minZ=26.23,
    maxZ=30.23,
    options = {
      {
        type = "client",
        event = "prp-pizzeria:client:bakingpizza",
        icon = "fas fa-comments",
        label = "Baking Pizza",
        job = "pizza",
      },
    },
    distance = 1.0
  },
  ["cutv"] = {
    name = "cutv",
    coords = vector3(284.06, -983.5, 29.43),
    length = 0.4,
    width = 0.5,
    heading = 0,
    debugPoly = false,
    minZ=25.63,
    maxZ=29.63,
    options = {
        {
          type = "client",
          event = "prp-pizzeria:client:cutvegetables",
          icon = "fas fa-comments",
          label = "Cut vegetables",
          job = "pizza",
        },
    },
    distance = 1.0
  },
  ["pizzameat"] = {
    name = "pizzameat",
    coords = vector3(962.89, -2121.2, 31.47),
    length = 1,
    width = 1,
    heading = 0,
    debugPoly = false,
    minZ=30.07,
    maxZ=34.07,
    options = {
      {
        type = "client",
        event = "prp-pizzeria:client:takemeat",
        icon = "fas fa-comments",
        label = "Get Meat",
        job = "pizza",
      },
    },
    distance = 1.0
  },
  ["pizzadrinks"] = {
    name = "pizzadrinks",
    coords = vector3(285.24, -985.35, 29.43),
    length = 1,
    width = 1.5,
    heading = 0,
    debugPoly = false,
    minZ=26.03,
    maxZ=30.03,
    options = {
      {
        type = "client",
        event = "prp-pizzeria:client:drinks",
        icon = "fas fa-comments",
        label = "Make Drinks",
        job = "pizza",
      },
    },
    distance = 1.0
  },
  ["pizzatogo"] = {
    name = "pizzatogo",
    coords = vector3(286.79, -984.26, 29.43),
    length = 1,
    width = 1,
    heading = 0,
    debugPoly = false,
    minZ=25.23,
    maxZ=29.23,
    options = {
      {
        type = "client",
        event = "prp-pizzeria:client:togo",
        icon = "fas fa-comments",
        label = "Packing pizza",
        job = "pizza",
      },
    },
    distance = 1.0
  },
  ["hunter"] = {
    name = "hunter",
    coords = vector3(-678.94, 5839.91, 17.33),
    length = 1,
    width = 1,
    heading = 0,
    debugPoly = false,
    minZ=14.33,
    maxZ=18.33,
    options = {
      {
        type = "server",
        event = "prp-hunting:server:sell",
        icon = "fas fa-dollar-sign",
        label = "Hunting Sell",
      },
      {
        type = "client",
        event = "prp-hunting:client:huntingshop",
        icon = "fas fa-shopping-basket",
        label = "Hunting Shop",
      },      
    },
    distance = 2.0
  },
  ["policeforensic"] = {
    name = "policeforensic",
    coords = vector3(485.49, -989.26, 30.69),
    length = 1,
    width = 1,
    heading = 0,
    debugPoly = false,
    -- minZ=14.33,
    -- maxZ=18.33,
    options = {
      {
        type = "client",
        event = "Axel:Get:weapon:Dialog",
        icon = "fas fa-comments",
        label = "Search Weapon Serial",
        job = "police",
      },
      {
        type = "client",
        event = "Axel:Get:Fingerprint:Dialog",
        icon = "fas fa-comments",
        label = "Search Fingerprint",
        job = "police",
      }, 
    },
    distance = 2.0
  },
  ["impound"] = {
    name = "impound",
    coords = vector3(-192.6, -1162.23, 23.67),
    length = 2,
    width = 1,
    heading = 0,
    debugPoly = false,
    -- minZ=14.33,
    -- maxZ=18.33,
    options = {
      {
        type = "client",
        event = "Axel:Impound",
        icon = "fas fa-comments",
        label = "Check impound for your Car.",
      },
    },
    distance = 2.0
  },
}

Config.PolyZones = {

}

Config.TargetBones = {

}

Config.TargetEntities = {

}

Config.TargetModels = {
	["atm"] = {
		models = {-870868698, -1126237515, -1364697528, 506770882},
		options = {
      {
        type = 'command',
        event = 'atm',
        icon = 'fab fa-cc-visa',
        label = 'Use ATM'
      }
		},
    distance = 1.0
  },
  ["hotdog"] = {
    models = {-1581502570},
    options = {
      {
        type = 'client',
        event = 'prp-hotdog:client:hotdogshop',
        icon = 'fas fa-hotdog',
        label = 'Buy Hotdog'
      }
    },
    distance = 1.0
  },
  ["jerrycan"] = {
    models = {-531344027},
    options = {
      {
        type = 'client',
        event = 'prp-fuel:client:fuelshop',
        icon = 'fas fa-hotdog',
        label = 'Buy JerryCan'
      }
    },
    distance = 1.0
  },
  ["VehicleRental"] = {
    models = {`a_m_y_business_03`},
    options = {
      {
        type = "client",
        event = "prp-rental:openMenu",
        icon = "fas fa-car",
        label = "Rent Vehicle",
      },
    },
    distance = 4.0
  },
  ["BMXRental"] = {
    models = {`a_m_y_gay_02`},
    options = {
      {
        type = "client",
        event = "Bike:Rental",
        icon = "fas fa-car",
        label = "Rent BMX",
      },
    },
    distance = 4.0
  },
  ["SelfRepair"] = {
    models = {`s_m_m_lathandy_01`},
    options = {
      {
        type = "client",
        event = "prp-mechanic:quickrepair",
        icon = "fas fa-tools",
        label = "Repair Vehicle",
      },
    },
    distance = 4.0
  },
}

Config.GlobalPedOptions = {

}

Config.GlobalVehicleOptions = {

}

Config.GlobalObjectOptions = {

}

Config.GlobalPlayerOptions = {

}

Config.Peds = {

}

----------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------

if Config.EnableDefaultOptions then
	function Config.ToggleDoor(vehicle, door)
		if GetVehicleDoorLockStatus(vehicle) ~= 2 then
			if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
				SetVehicleDoorShut(vehicle, door, false)
			else
				SetVehicleDoorOpen(vehicle, door, false)
			end
		end
	end
end

----------------------------------------------------------------------------------------
-- Default options
----------------------------------------------------------------------------------------

-- These options don't represent the actual way of making TargetBones or filling out Config.TargetBones, refer to the TEMPLATES.md for a template on that, this is only the way to add it without affecting the config table

if Config.EnableDefaultOptions then
	Bones['seat_dside_f'] = {
		["Toggle Front Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Front Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_dside_f') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 0)
			end,
			distance = 1.2
		}
	}

	Bones['seat_pside_f'] = {
		["Toggle Front Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Front Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_pside_f') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 1)
			end,
			distance = 1.2
		}
	}

	Bones['seat_dside_r'] = {
		["Toggle Rear Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Rear Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_dside_r') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 2)
			end,
			distance = 1.2
		}
	}

	Bones['seat_pside_r'] = {
		["Toggle Rear Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Rear Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_pside_r') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 3)
			end,
			distance = 1.2
		}
	}

	Bones['bonnet'] = {
		["Toggle Hood"] = {
			icon = "fa-duotone fa-engine",
			label = "Toggle Hood",
			action = function(entity)
				Config.ToggleDoor(entity, 4)
			end,
			distance = 0.9
		}
	}
end