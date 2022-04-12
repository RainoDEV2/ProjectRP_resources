Config = Config or {}

Config.MinZOffset = 40
Config.TakeoverPrice = 5000

Config.TrapHouses = {
    [1] = {
        coords = {
            ["enter"] = vector3(143.3499, -1656.0769, 29.4807),
            ["interaction"] = vector3(137.7848, -1657.5903, -8.0913),
        },
        keyholders = {},
        pincode = 5435,
        gang = "vagos",
        inventory = {},
        opened = false,
        reputation = 0,
        takingover = false,
        money = 0,
    }
}

Config.AllowedItems = {
    ["oxy"] = {
        name = "goldchain",
        wait = 3000,
        reward = 300,
    },
    ["diamond"] = {
        name = "diamond",
        wait = 5000,
        reward = 1000,
    },
    ["goldbar"] = {
        name = "goldbar",
        wait = 8000,
        reward = 1500,
    },
    ["weed_bag"] = {
        name = "Weed Bag",
        wait = 200,
        reward = 100,
    },
    ["cokebaggy"] = {
        name = "Coke Baggy",
        wait = 500,
        reward = 220,
    },
    ["10kgoldchain"] = {
        name = "10kgoldchain",
        wait = 3000,
        reward = 240,
    },
}
