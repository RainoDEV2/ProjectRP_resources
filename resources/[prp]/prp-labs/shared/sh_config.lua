Config = {}

Locales = { -- Interaction locales
    ["methlab"] = {
        parameter = "Temperature",
        unit = "°C.",
        tasks = {
            [1] = "Start Machine",
            [2] = "Start Machine",
            [3] = "Start Machine"
        },
        curelabel = "Curing",
        cureBatchType = "cured"
    },
    ["methlab2"] = {
        parameter = "Temperature",
        unit = "°C.",
        tasks = {
            [1] = "Start Machine",
            [2] = "Start Machine",
            [3] = "Start Machine"
        },
        curelabel = "Curing",
        cureBatchType = "cured"
    },
    ["cokelab"] = {
        parameter = "Chemicals",
        unit = "%",
        tasks = {
            [1] = "Start Process",
            [2] = "Start Process",
            [3] = "Start Process"
        },
        curelabel = "Crystalizing",
        cureBatchType = "crystalized"
    },
    ["weedlab"] = {
        parameter = "Nutrition",
        unit = "kg",
        tasks = {
            [1] = "Start Growing",
            [2] = "Start Nurturing",
            [3] = "Start Picking"
        },
        curelabel = "Drying",
        cureBatchType = "dried"
    }
}

Config.Resupply = {
    enable = true,
    amount = 4, -- Amount of ingredients that get added every x minutes in the druglabs.
    time = 30 -- In minutes
}

Config.Labs = {
    ["methlab"] = {
        entrance = vector4(996.3, -1486.73, 31.3, 93.3),
        exit = vector4(996.61, -3200.65, -36.4, 90.0),
        locked = true,
        tasks = {
            [1] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 8
                },
                temperature = 30,
                timeremaining = 180,
                duration = 180
            },
            [2] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 4,
                },
                temperature = 80,
                timeremaining = 120,
                duration = 120
            },
            [3] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 6
                },
                temperature = 20,
                timeremaining = 60,
                duration = 60
            }, 
        },
        ingredients = {
            stock = 0,
            taken = false,
            busy = false
        },
        curing = {
            busy = false,
            started = false,
            completed = false,
            timeremaining = 480,
            duration = 480,
            purity = nil,
            batchItem = 'meth_batch',
            curedItem = 'meth_cured'
        }
    },
    ["methlab2"] = {
        entrance = vector4(1233.82, 1876.07, 78.97, 220.6),
        exit = vector4(969.08, -147.09, -46.4, 269.95),
        locked = true,
        tasks = {
            [1] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 8
                },
                temperature = 30,
                timeremaining = 180,
                duration = 180
            },
            [2] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 4,
                },
                temperature = 80,
                timeremaining = 120,
                duration = 120
            },
            [3] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 6
                },
                temperature = 20,
                timeremaining = 60,
                duration = 60
            }, 
        },
        ingredients = {
            stock = 0,
            taken = false,
            busy = false
        },
        curing = {
            busy = false,
            started = false,
            completed = false,
            timeremaining = 480,
            duration = 480,
            purity = nil,
            batchItem = 'meth_batch',
            curedItem = 'meth_cured'
        }
    },
    ["cokelab"] = {
        entrance = vector4(167.84, -2221.52, 7.32, 358.48),
        exit = vector4(1088.7, -3187.5, -38.99, 180.00),
        locked = true,
        tasks = {
            [1] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 8
                },
                temperature = 30,
                timeremaining = 180,
                duration = 180
            },
            [2] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 4,
                },
                temperature = 80,
                timeremaining = 120,
                duration = 120
            },
            [3] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 6
                },
                temperature = 20,
                timeremaining = 60,
                duration = 60
            }, 
        },
        ingredients = {
            stock = 0,
            taken = false,
            busy = false
        },
        curing = {
            busy = false,
            started = false,
            completed = false,
            timeremaining = 480,
            duration = 480,
            purity = nil,
            batchItem = 'coke_batch',
            curedItem = 'coke_cured'
        }
    },
    ["weedlab"] = {
        entrance = vector4(-325.93, -1300.48, 31.5, 269.88),
        exit = vector4(1066.39, -3183.5, -39.16, 90.00),
        locked = true,
        tasks = {
            [1] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 8
                },
                temperature = 30,
                timeremaining = 180,
                duration = 180
            },
            [2] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 4,
                },
                temperature = 80,
                timeremaining = 120,
                duration = 120
            },
            [3] = {
                busy = false,
                completed = false,
                started = false,
                ingredients = {
                    current = 0,
                    needed = 6
                },
                temperature = 20,
                timeremaining = 60,
                duration = 60
            }, 
        },
        ingredients = {
            stock = 0,
            taken = false,
            busy = false
        },
        curing = {
            busy = false,
            started = false,
            completed = false,
            timeremaining = 480,
            duration = 480,
            purity = nil,
            batchItem = 'weed_batch',
            curedItem = 'weed_cured'
        }
    },
    ["moneywash"] = {
        entrance = vector4(-103.07, -12.4, 74.4, 162.68),
        exit = vector4(1138.04, -3199.44, -39.67, 180.00),
        locked = true,
        maxBags = 5,
        washers = {
            [1] = {
                coords = vector3(1122.373291, -3193.474365, -40.403080),
                busy = false,
                started = false,
                completed = false,
                duration = 180,
                moneybags = 0,
                worth = 0
            },
            [2] = {
                coords = vector3(1123.7697, -3193.351318, -40.403080),
                busy = false,
                started = false,
                completed = false,
                duration = 180,
                moneybags = 0,
                worth = 0
            },
            [3] = {
                coords = vector3(1125.5155, -3193.314209, -40.403080),
                busy = false,
                started = false,
                completed = false,
                duration = 180,
                moneybags = 0,
                worth = 0
            },
            [4] = {
                coords = vector3(1126.9450, -3193.314, -40.403080),
                busy = false,
                started = false,
                completed = false,
                duration = 180,
                moneybags = 0,
                worth = 0
            }
        }
    },
    ["gunbunker"] = {
        entrance = vector4(1657.02, 5.78, 166.12, 35.46),
        exit = vector4(903.19659, -3182.285, -97.05294, 90.00),
        locked = true,
        key = "gunkey",
        locations = {
            ammo = vector3(905.89, -3231.37, -97.42),
            pistol = vector3(908.6, -3210.18, -97.45),
            smg = vector3(896.08, -3217.17, -97.07),
            rifle = vector3(835.04, -3245.6, -97.9),
            weaponstash = vector3(892.16, -3228.9, -98.14)
        }
    }
}

Config.CraftingCost = {
    ["weapon_snspistol"] = {
        item1 = "plastic",
        cost1 = 30,
        item2 = "steel",
        cost2 = 40,
        item3 = "aluminum",
        cost3 = 55
    },
    ["weapon_vintagepistol"] = {
        item1 = "plastic",
        cost1 = 50,
        item2 = "iron",
        cost2 = 50,
        item3 = "aluminum",
        cost3 = 50
    },
    ["weapon_pistol"] = {
        item1 = "plastic",
        cost1 = 55,
        item2 = "iron",
        cost2 = 65,
        item3 = "aluminum",
        cost3 = 60
    },
    ["weapon_heavypistol"] = {
        item1 = "plastic",
        cost1 = 95,
        item2 = "steel",
        cost2 = 90,
        item3 = "aluminum",
        cost3 = 80
    },
    ["weapon_pistol50"] = {
        item1 = "plastic",
        cost1 = 115,
        item2 = "steel",
        cost2 = 145,
        item3 = "iron",
        cost3 = 120
    },
    ["pistol_ammo"] = {
        item1 = "metalscrap",
        cost1 = 25,
        item2 = "aluminum",
        cost2 = 18,
        item3 = "copper",
        cost3 = 30
    },
    ["smg_ammo"] = {
        item1 = "metalscrap",
        cost1 = 28,
        item2 = "aluminum",
        cost2 = 45,
        item3 = "copper",
        cost3 = 35
    },
    ["rifle_ammo"] = {
        item1 = "metalscrap",
        cost1 = 195,
        item2 = "aluminum",
        cost2 = 140,
        item3 = "copper",
        cost3 = 240
    },
    ["mg_ammo"] = {
        item1 = "metalscrap",
        cost1 = 210,
        item2 = "aluminum",
        cost2 = 265,
        item3 = "copper",
        cost3 = 260
    },
    ["weapon_microsmg"] = {
        item1 = "aluminum",
        cost1 = 85,
        item2 = "glass",
        cost2 = 200,
        item3 = "rubber",
        cost3 = 155
    },
    ["weapon_assaultsmg"] = {
        item1 = "aluminum",
        cost1 = 195,
        item2 = "glass",
        cost2 = 235,
        item3 = "rubber",
        cost3 = 110
    },
    ["weapon_minismg"] = {
        item1 = "aluminum",
        cost1 = 155,
        item2 = "glass",
        cost2 = 180,
        item3 = "rubber",
        cost3 = 85
    },
    ["weapon_machinepistol"] = {
        item1 = "aluminum",
        cost1 = 70,
        item2 = "glass",
        cost2 = 170,
        item3 = "rubber",
        cost3 = 115
    },
    ["weapon_assaultrifle"] = {
        item1 = "metalscrap",
        cost1 = 310,
        item2 = "steel",
        cost2 = 380,
        item3 = "rubber",
        cost3 = 280
    },
    ["weapon_specialcarbine"] = {
        item1 = "metalscrap",
        cost1 = 295,
        item2 = "steel",
        cost2 = 420,
        item3 = "rubber",
        cost3 = 295
    },
    ["weapon_advancedrifle"] = {
        item1 = "metalscrap",
        cost1 = 290,
        item2 = "steel",
        cost2 = 410,
        item3 = "rubber",
        cost3 = 255
    }
}