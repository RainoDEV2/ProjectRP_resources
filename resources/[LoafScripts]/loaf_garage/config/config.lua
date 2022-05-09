Config = {
    Framework = "prp", --[[ framework to use.
        * esx - es_extended (v1 legacy)
        * prp - prpcore
    ]]
    MenuSystem = "prp", --[[
        * esx - esx_menu_default
        * prp - prp-menu
        * zf - zf_context https://github.com/zf-development/zf_context
    ]]
    MenuAlign = "bottom-right", -- esx_menu_default align
    TargetSystem = "prp-target", --[[
        * qtarget
        * prp-target
    ]]
    BrowseStyle = "menu", --[[
        * menu - a menu where you select the vehicle
        * browse - you will sit inside the vehicle and you can use the arrow keys to change vehicle
    ]]
    GarageStyle = "parking", --[[
        * garage - one circle to take out vehicle (retrieve), one circle to store vehicles (store), and a location where vehicles spawn (spawn) 
        * parking - multiple parking lots, use qtarget or prp-target to retrieve/store vehicle
    ]]

    PingAlreadyOut = false, -- should the vehicle be pinged if it is already out? false = don't ping, true = ping
    IndependentGarage = true, -- should you only be able to take out the car from the garage you stored it at?
    SaveDamages = true, -- https://www.youtube.com/watch?v=-gAgVyG7vJw Requires https://github.com/Kiminaze/VehicleDeformation
    DebugPoly = false, -- debug poly for qtarget / prp-target
    Passive = false, -- should vehicles be made "passive" (no collision) when taking them out?
    SpawnServer = true, -- should the vehicle be spawned server side? 
    SetImpoundedRetrieve = false,
    Impound = {
        enabled = false, -- enable impounds?
        price = 500, -- the price to retrieve a vehicle from the impound
    },

    Blip = {
        garage = {
            sprite = 357,
            color = 3,
            scale = 0.75,
        },
        impound = {
            sprite = 67,
            color = 47,
            scale = 0.75,
        },
    },

    Garages = {
        ["motelgarage"] = {
            retrieve = vector3(277.37646484375, -345.60275268555, 43.919891357422),
            spawn = vector4(290.06335449219, -339.18823242188, 44.506492614746, 156.48341369629),
            store = vector3(274.81018066406, -330.51040649414, 43.923034667969),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(266.17074584961, -332.22232055664, 44.49560546875, 250.17141723633),
                vector4(267.50012207031, -328.89996337891, 44.495601654053, 249.36679077148),
                vector4(268.79653930664, -325.70404052734, 44.4953956604, 249.70141601563),
                vector4(270.00717163086, -322.50653076172, 44.495899200439, 248.99468994141),
                vector4(270.97381591797, -319.23361206055, 44.495922088623, 249.1252746582),
                vector4(283.03857421875, -323.7873840332, 44.495681762695, 69.344871520996),
                vector4(281.77841186523, -327.06588745117, 44.495906829834, 69.702278137207),
                vector4(280.61965942383, -330.29125976563, 44.496337890625, 70.277946472168),
                vector4(279.57043457031, -333.63519287109, 44.495624542236, 70.283752441406),
                vector4(278.54858398438, -336.93417358398, 44.495487213135, 68.249633789063),
                vector4(277.59622192383, -340.21615600586, 44.496185302734, 68.87353515625),
                vector4(289.13952636719, -326.17449951172, 44.495029449463, 251.67984008789),
                vector4(288.20220947266, -329.30221557617, 44.495826721191, 248.34872436523),
                vector4(286.91821289063, -332.56475830078, 44.495872497559, 249.02827453613), 
                vector4(285.82528686523, -335.71481323242, 44.495780944824, 250.47790527344),
                vector4(284.76864624023, -339.08660888672, 44.495586395264, 250.08279418945),
                vector4(283.38931274414, -342.39611816406, 44.495704650879, 250.6480255127),
                vector4(300.0537109375, -330.12924194336, 44.495140075684, 70.874855041504),
                vector4(298.76043701172, -333.23919677734, 44.495574951172, 68.070129394531),
                vector4(297.87664794922, -336.53680419922, 44.495807647705, 68.751419067383),
                vector4(296.37661743164, -339.75686645508, 44.495864868164, 70.944961547852),
                vector4(295.32186889648, -342.93341064453, 44.49524307251, 70.466506958008),
                vector4(294.1520690918, -346.20217895508, 44.495761871338, 68.633094787598),
                vector4(293.28854370117, -349.62084960938, 44.514511108398, 69.956901550293),
            },
        },
        ["spanishave"] = {
            retrieve = vector3(-93.87, 89.32, 71.77),
            spawn = vector4(-93.86, 89.31, 71.77, 62.21),
            store = vector3(-103.41, 94.58, 71.82),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(-94.96, 82.59, 71.57, 330.63),
                vector4(-97.88, 84.25, 71.55, 327.44),
                vector4(-100.95, 85.94, 71.52, 340.36),
                vector4(-103.96, 87.74, 71.5, 332.9),
                vector4(-107.15, 89.33, 71.46, 327.82),
                vector4(-101.45, 99.92, 72.47, 160.47),
                vector4(-98.45, 98.25, 72.41, 155.4),
                vector4(-95.27, 96.42, 72.34, 158.85),
                vector4(-92.13, 94.65, 72.3, 154.81),
                vector4(-88.83, 93.53, 72.34, 160.03),
                vector4(-76.53, 89.21, 71.53, 242.28)
            },
        },
        ["caears24"] = {
            retrieve = vector3(-466.17, -803.3, 30.54),
            spawn = vector4(-466.17, -803.3, 30.54, 88.41),
            store = vector3(-460.41, -803.75, 30.54),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(-466.33, -806.8, 30.54, 88.82),
                vector4(-466.07, -803.5, 30.54, 89.81),
                vector4(-466.28, -800.22, 30.54, 90.49),
                vector4(-460.62, -800.43, 30.54, 270.64),
                vector4(-460.54, -803.5, 30.54, 270.65),
                vector4(-460.53, -806.67, 30.54, 270.6)
            },
        },
        ["lagunapi"] = {
            retrieve = vector3(374.9, 294.89, 103.28),
            spawn = vector4(374.9, 294.89, 103.28, 155.44),
            store = vector3(-460.41, -803.75, 30.54),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(374.9, 294.89, 103.28, 162.44),
                vector4(378.84, 293.5, 103.2, 162.64),
                vector4(382.63, 292.07, 103.12, 162.03),
                vector4(371.06, 284.86, 103.26, 339.08),
                vector4(375.04, 283.54, 103.18, 339.48),
                vector4(378.89, 282.0, 103.11, 342.7)
            },
        },
        ["beachp"] = {
            retrieve = vector3(-1183.16, -1495.65, 4.38),
            spawn = vector4(-1183.16, -1495.65, 4.38, 127.13),
            store = vector3(-1186.41, -1490.27, 4.38),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(-1182.98, -1495.8, 4.38, 125.73),
                vector4(-1184.77, -1493.0, 4.38, 125.05),
                vector4(-1186.41, -1490.27, 4.38, 125.05),
                vector4(-1188.43, -1487.69, 4.38, 124.52),
            },
        },
        ["themotorhotel"] = {
            retrieve = vector3(1124.39, 2648.1, 38.0),
            spawn = vector4(1124.25, 2647.52, 38.0, 359.05),
            store = vector3(1129.41, 2647.56, 38.0),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(1131.58, 2647.65, 38.0, 0.31),
                vector4(1127.63, 2647.82, 38.0, 358.36),
                vector4(1124.25, 2647.52, 38.0, 359.05),
                vector4(1120.6, 2647.24, 38.0, 1.12),
            },
        },
        ["mountainviewdrive"] = {
            retrieve = vector3(1707.42, 3762.61, 34.27),
            spawn = vector4(1707.42, 3762.61, 34.27, 318.43),
            store = vector3(1704.6, 3765.37, 34.38),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(1707.42, 3762.61, 34.27, 318.43),
                vector4(1704.6, 3765.37, 34.38, 316.72),
            },
        },
        ["bellfarm"] = {
            retrieve = vector3(75.51, 6401.56, 31.23),
            spawn = vector4(75.51, 6401.56, 31.23, 134.66),
            store = vector3(78.69, 6398.85, 31.23),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(72.42, 6404.19, 31.23, 135.48),
                vector4(75.51, 6401.56, 31.23, 134.66),
                vector4(78.55, 6398.97, 31.23, 131.01),
                vector4(81.21, 6396.25, 31.23, 136.36)
            },
        },
        ["voodooplace"] = {
            retrieve = vector3(163.3, -3182.76, 5.94),
            spawn = vector4(163.3, -3182.76, 5.94, 267.57),
            store = vector3(164.21, -3176.55, 5.92),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(163.3, -3182.76, 5.94, 267.57)
            },
        },
        ["pillboxgarage"] = {
            retrieve = vector3(216.33, -801.74, 30.79),
            spawn = vector4(216.33, -801.74, 30.79, 68.59),
            store = vector3(218.07, -798.06, 30.77),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(216.33, -801.74, 30.79, 68.59),
                vector4(217.71, -798.49, 30.77, 68.37),
                vector4(218.92, -795.28, 30.76, 72.68),
                vector4(221.78, -803.92, 30.68, 247.9),
                vector4(223.11, -800.64, 30.66, 250.14),
                vector4(224.66, -797.03, 30.66, 250.48)
            },
        },
        ["southrockford"] = {
            retrieve = vector3(-696.53, -1104.96, 14.53),
            spawn = vector4(-696.53, -1104.96, 14.53, 212.55),
            store = vector3(-700.05, -1106.97, 14.53),
            vehicleTypes = {"car"},
            jobs = "all", -- civ = only show vehicles without job in db. all = show all vehicles. you can also put a table with the allowed job vehicles, e.g.: {"police"}

            parkingLots = {
                vector4(-703.74, -1108.95, 14.53, 213.67),
                vector4(-700.46, -1106.47, 14.53, 210.37),
                vector4(-697.1, -1104.46, 14.53, 214.81),
                vector4(-693.51, -1102.1, 14.53, 214.86)
            },
        },
        ["Mission Row PD"] = {
            retrieve = vector3(458.62069702148, -1011.9958496094, 27.248506546021),
            spawn = vector4(441.84899902344, -1021.0112915039, 28.211936950684, 92.883972167969),
            store = vector3(450.14782714844, -1006.6174316406, 26.048715591431),
            vehicleTypes = {"car"},
            jobs = {"police"},

            parkingLots = {
                vector4(446.15393066406, -1024.90234375, 28.229749679565, 130.3737599849701),
                vector4(442.43511962891, -1025.4991455078, 28.305545806885, 6.4385643005371),
                vector4(438.65930175781, -1025.73828125, 28.375896453857, 3.7558765411377),
                vector4(434.86602783203, -1025.9569091797, 28.443691253662, 5.851438999176),
                vector4(431.13177490234, -1026.5302734375, 28.515933990479, 8.9433498382568),
                vector4(427.59909057617, -1026.4479980469, 28.571384429932, 3.5505225658417),
            },
        },
        ["Docks"] = {
            retrieve = vector3(-845.70098876953, -1497.6790771484, 0.6341668367386),
            spawn = vector4(-840.52972412109, -1485.4296875, -1.11102887988091, 202.31701660156),
            store = vector3(-847.10943603516, -1469.4711914063, -0.34531825780869),
            vehicleTypes = {"boat"},
            jobs = "all",

            parkingLots = {},
        },
        ["LSIA"] = {
            retrieve = vector3(-992.14, -2955.46, 13.0),
            spawn = vector4(-990.87, -2967.83, 13.9, 59.52),
            store = vector3(-1011.62, -3009.13, 13.0),
            vehicleTypes = {"airplane", "plane", "aircraft"},
            jobs = "all",
            parkingLots = {
                vector4(-990.87, -2967.83, 13.9, 59.52),
            }
        }
    },

    Impounds = {
        {
            retrieve = vector3(483.73, -1312.26, 28.23), -- where you open the menu to retrieve the car
            spawn = vector4(490.99, -1313.66, 28.83, 285.99), -- where the car spawns
            vehicleTypes = {"car"},
        },
        {
            retrieve = vector3(-1615.52, -3137.48, 13.00), -- where you open the menu to retrieve the plane
            spawn = vector4(-1654.096, -3146.48, 13.57, 329.89), -- where the plane spawns
            vehicleTypes = {"airplane", "plane", "aircraft"},
        },
        {
            retrieve = vector3(-944.03, -1375.26, 0.6), -- where you open the menu to retrieve the plane
            spawn = vector4(-947.69, -1365.79, 0.0, 290.0), -- where the plane spawns
            vehicleTypes = {"boat"},
        },
    },
}