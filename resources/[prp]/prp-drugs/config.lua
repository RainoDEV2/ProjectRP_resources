Config = Config or {}
Config.MinimumDrugSalePolice = 0

Config.Products = {
    [1] = {
        name = "weed_white-widow",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 1,
        minrep = 0,
    },
    [2] = {
        name = "weed_skunk",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 2,
        minrep = 20,
    },
    [3] = {
        name = "weed_purple-haze",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 3,
        minrep = 40,
    },
    [4] = {
        name = "weed_og-kush",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 4,
        minrep = 60,
    },
    [5] = {
        name = "weed_amnesia",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 5,
        minrep = 80,
    },
    [6] = {
        name = "weed_white-widow_seed",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 6,
        minrep = 100,
    },
    [7] = {
        name = "weed_skunk_seed",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 7,
        minrep = 120,
    },
    [8] = {
        name = "weed_purple-haze_seed",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 8,
        minrep = 140,
    },
    [9] = {
        name = "weed_og-kush_seed",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 9,
        minrep = 160,
    },
    [10] = {
        name = "weed_amnesia_seed",
        price = 15,
        amount = 100,
        info = {},
        type = "item",
        slot = 10,
        minrep = 180,
    },
}

Config.Dealers = {}

Config.CornerSellingDrugsList = {
    "weed_bag",
    "weed_white-widow",
    "weed_skunk",
    "weed_purple-haze",
    "weed_og-kush",
    "weed_amnesia",
    "weed_ak47",
    "weed_baggy",
    "crack_baggy",
    "coke_baggy",
    "meth_baggy",
    "xtcbaggy"
}

Config.DrugsPrice = {
    ["weed_bag"] = {
        min = 15,
        max = 20,
    },
    ["xtcbaggy"] = {
        min = 96,
        max = 101,
    },
    ["weed_white-widow"] = {
        min = 50,
        max = 68,
    },
    ["weed_og-kush"] = {
        min = 54,
        max = 75,
    },
    ["weed_skunk"] = {
        min = 60,
        max = 80,
    },
    ["weed_amnesia"] = {
        min = 66,
        max = 88,
    },
    ["weed_purple-haze"] = {
        min = 70,
        max = 93,
    },
    ["weed_ak47"] = {
        min = 75,
        max = 100,
    },
    ["weed_baggy"] = {
        min = 150,
        max = 180,
    },
    ["crack_baggy"] = {
        min = 190,
        max = 220,
    },
    ["coke_baggy"] = {
        min = 160,
        max = 200,
    },
    ["meth_baggy"] = {
        min = 140,
        max = 180,
    },
}

Config.DeliveryLocations = {
    [1] = {
        ["label"] = "Stripclub",
        ["coords"] = vector3(106.24, -1280.32, 29.24),
    },
    [2] = {
        ["label"] = "Vinewood Video",
        ["coords"] = vector3(223.98, 121.53, 102.76),
    },
    [3] = {
        ["label"] = "Taxi",
        ["coords"] = vector3(871.51, -157.96, 78.34),
    },
    [4] = {
        ["label"] = "Resort",
        ["coords"] = vector3(-1245.63, 376.21, 75.34),
    },
    [5] = {
        ["label"] = "Bahama Mamas",
        ["coords"] = vector3(-1383.1, -639.99, 28.67),
    },
    [6] = {
        ["label"] = "GSF",
        ["coords"] = vector3(-234.24, -1490.73, 32.96),
    },
    [7] = {
        ["label"] = "Ballas",
        ["coords"] = vector3(6.52, -1816.71, 25.35),
    },
    [8] = {
        ["label"] = "Vagos",
        ["coords"] = vector3(415.33, -2052.05, 22.22),
    },
    [9] = {
        ["label"] = "Back of Church",
        ["coords"] = vector3(-1679.63, -264.31, 51.88),
    },
    [10] = {
        ["label"] = "Opposite MRPD",
        ["coords"] = vector3(328.46, -994.62, 29.31),
    },
}

Config.CornerSellingZones = {
    [1] = {
        ["coords"] = vector3(-1415.53, -1041.51, 4.62),
        ["time"] = {
            ["min"] = 10,
            ["max"] = 23,
        },
    },
}

Config.DeliveryItems = {
    [1] = {
        ["item"] = "weed_brick",
        ["minrep"] = 0,
    },
}
