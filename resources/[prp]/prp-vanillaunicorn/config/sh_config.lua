Config = {}

Config.debug = false -- Debug mode, disable on prod servers

Config.Drinks = {
    ['coke'] = {
        name = 'Coke', -- The name of the drink
        item = 'cocacola', -- The actual item name (in shared.lua)
        amount = 1, -- The amount it gives
        price = 200 -- THe price of the drink
    },
    ['whiskey'] = {
        name = 'Whiskey',
        item = 'whiskey',
        amount = 1,
        price = 100 
    },
    ['vodka'] = {
        name = 'Vodka',
        item = 'vodka',
        amount = 1,
        price = 100
    },
    ['rum'] = {
        name = 'Rum',
        item = 'rum',
        amount = 1,
        price = 100
    },
}

Config.Settings = {
    ['vanillaUnicorn'] = {
        ['duty'] = { 
            coords = vector3(96.12, -1292.81, 29.27), -- On Duty settings
            minZ = 25, 
            maxZ = 35,
            length = 0.5,
            width = 0.5,
            heading = 120
        },
        ['stash'] = { 
            coords = vector3(109.26, -1304.87, 28.77), -- Coords for worker stash
            minZ = 25, 
            maxZ = 35,
            length = 4,
            width = 0.5,
            heading = 120
        },
        ['bossSettings'] = { -- Boss Action Settings
            hash = `a_m_y_business_02`,
            coords = vector4(92.97, -1292.39, 28.27, 298.99),
            spawnped = false, -- Spawn the boss ped? Leave as false for now (waiting for prp-bossmenu fix)
            bossJob = 'vu' -- Name of the job that can access the boss menu
        },
        ['barSettings'] = { -- Bartender Settings
            hash = `a_m_y_business_02`,
            coords = vector4(128.72, -1282.9, 28.27, 123.15),
            playAnimation = true
        },
        ['strippers'] = { -- WIP
            enabled = true, -- Enable Strippers
            coords = {
                vector4(108.14, -1289.31, 29.25, 298.63),
                vector4(105.13, -1294.33, 29.25, 299.35),
                vector4(102.71, -1290.6, 29.25, 320.38),
            }
        }
    },
}

Config.Translation = 'en'

Translation = {
    ['en'] = {
        -- Drinks + bar handling
        ['coke'] = "CoCa Cola",
        ['vodka'] = "Vodka",
        ['vodkaDesc'] = "You russian or something?",
        ['rumDesc'] = "I'm sure that person wants to fight!",
        ['whiskeyDesc'] = "What are you? 60?",
        ['rum'] = "Rum",
        ['whiskey'] = "Whiskey",
        ['cokedesc'] = "Designated Driver? No worries, have this!",
        ['browseDrinks'] = "Browse the drinks",
        ['browseDesc'] = "Click here to browse what the bartender has to offer",
        ['barMenu'] = "Bar Menu",
        ['confirmDrink'] = "Are you sure you wish to purchase a ",
        ['yes'] = "Yes",
        ['no'] = "No",
        ['accessBarMenu'] = "Access Bar Menu",
        ['cost'] = "This will cost $", 
        -- Employee Management
        ['employeeTitle'] = "Boss Menu",
        ['employeeHire'] = "Open Boss Menu",
        ['openEmployee'] = "Open Employee Management",
        ['employeeHireDesc'] = "Click here to open the boss menu",
        ['goBack'] = "< Go Back",
        -- prp-target settings
        ['toggleDuty'] = "Clock On/Clock Off",
        ['openStash'] = "Open Stash",
    }
}