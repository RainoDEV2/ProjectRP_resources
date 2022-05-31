AutoRespawn = false --True == auto respawn cars that are outside into your garage on script restart, false == does not put them into your garage and players have to go to the impound
SharedGarages = false   --True == Gang and job garages are shared, false == Gang and Job garages are personal

Garages = {
    -- ["motelgarage"] = {
    --     label = "Motel Parking",
    --     takeVehicle = vector3(273.43, -343.99, 44.91),
    --     spawnPoint = vector4(270.94, -342.96, 43.97, 161.5),
    --     putVehicle = vector3(276.69, -339.85, 44.91),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["sapcounsel"] = {
    --     label = "San Andreas Parking",
    --     takeVehicle = vector3(-330.01, -780.33, 33.96),
    --     spawnPoint = vector4(-334.44, -780.75, 33.96, 137.5),
    --     putVehicle = vector3(-336.31, -774.93, 33.96),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["spanishave"] = {
    --     label = "Spanish Ave Parking",
    --     takeVehicle = vector3(-1160.86, -741.41, 19.63),
    --     spawnPoint = vector4(-1163.88, -749.32, 18.42, 35.5),
    --     putVehicle = vector3(-1147.58, -738.11, 19.31),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["caears24"] = {
    --     label = "Caears 24 Parking",
    --     takeVehicle = vector3(69.84, 12.6, 68.96),
    --     spawnPoint = vector4(73.21, 10.72, 68.83, 163.5),
    --     putVehicle = vector3(65.43, 21.19, 69.47),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["caears242"] = {
    --     label = "Caears 24 Parking",
    --     takeVehicle = vector3(-475.31, -818.73, 30.46),
    --     spawnPoint = vector4(-472.03, -815.47, 30.5, 177.5),
    --     putVehicle = vector3(-453.6, -817.08, 30.61),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["lagunapi"] = {
    --     label = "Laguna Parking",
    --     takeVehicle = vector3(364.37, 297.83, 103.49),
    --     spawnPoint = vector4(367.49, 297.71, 103.43, 340.5),
    --     putVehicle = vector3(363.04, 283.51, 103.38),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["airportp"] = {
    --     label = "Airport Parking",
    --     takeVehicle = vector3(-796.86, -2024.85, 8.88),
    --     spawnPoint = vector4(-800.41, -2016.53, 9.32, 48.5),
    --     putVehicle = vector3(-804.84, -2023.21, 9.16),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["beachp"] = {
    --     label = "Beach Parking",
    --     takeVehicle = vector3(-1183.1, -1511.11, 4.36),
    --     spawnPoint = vector4(-1181.0, -1505.98, 4.37, 214.5),
    --     putVehicle = vector3(-1176.81, -1498.63, 4.37),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["themotorhotel"] = {
    --     label = "The Motor Hotel Parking",
    --     takeVehicle = vector3(1137.77, 2663.54, 37.9),            
    --     spawnPoint = vector4(1137.69, 2673.61, 37.9, 359.5),      
    --     putVehicle = vector3(1137.75, 2652.95, 37.9),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["liqourparking"] = {
    --     label = "Liqour Parking",
    --     takeVehicle = vector3(934.95, 3606.59, 32.81),
    --     spawnPoint = vector4(941.57, 3619.99, 32.5, 141.5),
    --     putVehicle = vector3(939.37, 3612.25, 32.69),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["shoreparking"] = {
    --     label = "Shore Parking",
    --     takeVehicle = vector3(1726.21, 3707.16, 34.17),
    --     spawnPoint = vector4(1730.31, 3711.07, 34.2, 20.5),
    --     putVehicle = vector3(1737.13, 3718.91, 34.04),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["haanparking"] = {
    --     label = "Bell Farms Parking",
    --     takeVehicle = vector3(78.34, 6418.74, 31.28),
    --     spawnPoint = vector4(70.71, 6425.16, 30.92, 68.5), 
    --     putVehicle = vector3(85.3, 6427.52, 31.33),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["dumbogarage"] = {
    --     label = "Dumbo Private Parking",
    --     takeVehicle = vector3(157.26, -3240.00, 7.00),
    --     spawnPoint = vector4(165.32, -3236.10, 5.93, 268.5), 
    --     putVehicle = vector3(165.32, -3230.00, 5.93),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["pillboxgarage"] = {
    --     label = "Pillbox Garage Parking",
    --     takeVehicle = vector3(215.9499, -809.698, 30.731),
    --     spawnPoint = vector4(234.1942, -787.066, 30.193, 159.6),
    --     putVehicle = vector3(218.0894, -781.370, 30.389),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },
    -- ["southrockford"] = {
    --     label = "South Rockford Drive Parking",
    --     takeVehicle = vector3(-701.71, -1108.17, 14.53),
    --     spawnPoint = vector4(-701.71, -1108.17, 14.53, 213.79),
    --     putVehicle = vector3(-696.59, -1104.93, 14.53),
    --     showBlip = true,
    --     blipName = "Public Parking",
    --     blipNumber = 357,
    --     type = 'public',                --public, job, gang, depot
    --     vehicle = 'car'                 --car, air, sea
    -- },

    ["impoundlot"] = {
        label = "Impound Lot",
        takeVehicle = vector3(-191.86, -1162.3, 23.67),
        spawnPoint = vector4(-205.3176, -1165.6792, 22.4647, 178.4752),
        showBlip = true,
        blipName = "Impound Lot",
        blipNumber = 498,
        type = 'depot',                --public, job, gang, depot
        vehicle = 'car'                 --car, air, sea
    },
    -- ["ballas"] = {
    --     label = "Ballas",
    --     takeVehicle = vector3(85.53, -1970.19, 20.75),
    --     spawnPoint = vector4(85.53, -1970.19, 20.75, 319.78),
    --     putVehicle = vector3(91.21, -1964.09, 20.75),
    --     showBlip = false,
    --     blipName = "Ballas",
    --     blipNumber = 357,
    --     type = 'gang',                --public, job, gang, depot
    --     vehicle = 'car',              --car, air, sea
    --     job = "ballas"
    -- },
    ["ssk"] = {
        label = "South Side Kings",
        takeVehicle = vector3(85.53, -1970.19, 20.75),
        spawnPoint = vector4(85.53, -1970.19, 20.75, 319.78),
        putVehicle = vector3(91.21, -1964.09, 20.75),
        showBlip = false,
        blipName = "South Side Kings",
        blipNumber = 357,
        type = 'gang',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "ssk"
    },
    ["families"] = {
        label = "La Familia",
        takeVehicle = vector3(-229.44, -1700.25, 33.94),
        spawnPoint = vector4(-229.44, -1700.25, 33.94, 287.29),
        putVehicle = vector3(-216.25, -1692.15, 34.0),
        showBlip = false,
        blipName = "La Familia",
        blipNumber = 357,
        type = 'gang',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "families"
    },
    ["lostmc"] = {
        label = "Lost MC",
        takeVehicle = vector3(957.25, -129.63, 74.39),
        spawnPoint = vector4(957.25, -129.63, 74.39, 199.21),
        putVehicle = vector3(950.47, -122.05, 74.36),
        showBlip = false,
        blipName = "Lost MC",
        blipNumber = 357,
        type = 'gang',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "lostmc"
    },
    ["cartel"] = {
        label = "Cartel",
        takeVehicle = vector3(1407.11, 1118.29, 114.84),
        spawnPoint = vector4(1407.11, 1118.29, 114.84, 88.93),
        putVehicle = vector3(1414.52, 1118.16, 114.84),
        showBlip = false,
        blipName = "Cartel",
        blipNumber = 357,
        type = 'gang',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "cartel"
    },
    ["zerotolerance"] = {
        label = "Zero Tolerance",
        takeVehicle = vector3(994.9, -1533.39, 30.48),
        spawnPoint = vector4(994.9, -1533.39, 30.48, 92.71),
        putVehicle = vector4(1000.79, -1533.17, 29.83, 91.25),
        showBlip = false,
        blipName = "Zero Tolerance",
        blipNumber = 357,
        type = 'gang',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "zerotolerance"
    },
    ["police"] = {
        label = "Police",
        takeVehicle = vector3(464.97, -1106.48, 29.2),
        spawnPoint = vector4(464.97, -1106.48, 29.2, 180.4),
        putVehicle = vector3(465.36, -1088.62, 29.2),
        showBlip = false,
        blipName = "Police",
        blipNumber = 357,
        type = 'job',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "police"
    },
    ["mechanic"] = {
        label = "Mechanic",
        takeVehicle = vector3(-20.68, -1028.51, 28.93),
        spawnPoint = vector4(-20.62, -1028.35, 28.93, 340.9),
        putVehicle = vector3(-29.37, -1025.14, 28.86),
        showBlip = false,
        blipName = "Mechanic Garage",
        blipNumber = 357,
        type = 'job',                --public, job, gang, depot
        vehicle = 'car',              --car, air, sea
        job = "mechanic"
    },
    ["intairport"] = {
        label = "Airport Hangar", 
        takeVehicle = vector3(-1025.92, -3017.86, 13.95),
        spawnPoint = vector4(-979.2, -2995.51, 13.95, 52.19),
        putVehicle = vector3(-1003.38, -3008.87, 13.95),
        showBlip = true,
        blipName = "Hangar",
        blipNumber = 360,
        type = 'public',                --public, job, gang, depot
        vehicle = 'air'                 --car, air, sea
    },
    ["higginsheli"] = {
        label = "Higgins Helitours", 
        takeVehicle = vector3(-722.15, -1472.79, 5.0),
        spawnPoint = vector4(-724.83, -1443.89, 5.0, 140.1),
        putVehicle = vector3(-745.48, -1468.46, 5.0),
        showBlip = true,
        blipName = "Hangar",
        blipNumber = 360,
        type = 'public',                --public, job, gang, depot
        vehicle = 'air'                 --car, air, sea
    },
    ["airsshores"] = {
        label = "Sandy Shores Hangar", 
        takeVehicle = vector3(1758.19, 3296.66, 41.14),
        spawnPoint = vector4(1740.98, 3279.08, 41.75, 106.77),
        putVehicle = vector3(1740.4, 3283.92, 41.1),
        showBlip = true,
        blipName = "Hangar",
        blipNumber = 360,
        type = 'public',                --public, job, gang, depot
        vehicle = 'air'                 --car, air, sea
    },
    ["airdepot"] = {
        label = "Air Depot", 
        takeVehicle = vector3(-1243.29, -3392.3, 13.94),
        spawnPoint = vector4(-1269.67, -3377.74, 13.94, 327.88),
        showBlip = true,
        blipName = "Air Depot",
        blipNumber = 359,
        type = 'depot',                --public, job, gang, depot
        vehicle = 'air'                 --car, air, sea
    },
    ["lsymc"] = {
        label = "LSYMC Boathouse",               
        takeVehicle = vector3(-794.66, -1510.83, 1.59),
        spawnPoint = vector4(-793.58, -1501.4, 0.12, 111.5),
        putVehicle = vector3(-793.58, -1501.4, 0.12),
        showBlip = true,
        blipName = "Boathouse",
        blipNumber = 356,
        type = 'public',                --public, job, gang, depot
        vehicle = 'sea'                 --car, air, sea
    },
    ["paleto"] = {
        label = "Paleto Boathouse",               
        takeVehicle = vector3(-277.46, 6637.2, 7.48),
        spawnPoint = vector4(-289.2, 6637.96, 1.01, 45.5),
        putVehicle = vector3(-289.2, 6637.96, 1.01),
        showBlip = true,
        blipName = "Boathouse",
        blipNumber = 356,
        type = 'public',                --public, job, gang, depot
        vehicle = 'sea'                 --car, air, sea
    },
    ["millars"] = {
        label = "Millars Boathouse",               
        takeVehicle = vector3(1299.24, 4216.69, 33.9),
        spawnPoint = vector4(1297.82, 4209.61, 30.12, 253.5),
        putVehicle = vector3(1297.82, 4209.61, 30.12),
        showBlip = true,
        blipName = "Boathouse",
        blipNumber = 356,
        type = 'public',                --public, job, gang, depot
        vehicle = 'sea'                 --car, air, sea
    },
    ["seadepot"] = {
        label = "LSYMC Depot",               
        takeVehicle = vector3(-772.98, -1430.76, 1.59),
        spawnPoint = vector4(-729.77, -1355.49, 1.19, 142.5),
        putVehicle = vector3(-729.77, -1355.49, 1.19),
        showBlip = true,
        blipName = "LSYMC Depot",
        blipNumber = 356,
        type = 'depot',                --public, job, gang, depot
        vehicle = 'sea'                 --car, air, sea
    },
}
HouseGarages = {}
