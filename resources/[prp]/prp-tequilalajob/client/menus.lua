local ProjectRP = exports['prp-core']:GetCoreObject()

-- prp-target

Citizen.CreateThread(function()
    -- GALAXY STUFF
    exports['prp-target']:AddBoxZone("galaxyDuty", vector3(391.38, 269.45, 94.88), 1.5, 1.5, {
        name = "galaxyDuty",
        heading = 32,
        debugPoly = false,
        minZ=94.0,
        maxZ=96.0,
    }, {
        options = {
            {  
                event = "prp-galaxy:ToggleDuty",
                icon = "far fa-clipboard",
                label = "Clock On/Off",
                job = "galaxy",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("galaxyFridge1", vector3(351.8, 289.0, 91.19), 3, 1, {
        name = "galaxyFridge1",
        heading = 76,
        debugPoly = true,
        minZ=90.0,
        maxZ=92.0,
    }, {
        options = {
            {  
                event = "prp-galaxy:client:openShop",
                icon = "fas fa-box",
                label = "Storage",
                job = "galaxy",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("galaxyFridge2", vector3(355.26, 282.5, 94.61), 2, 3, {
        name = "galaxyFridge2",
        heading = 76,
        debugPoly = false,
        minZ=93.0,
        maxZ=95.0,
    }, {
        options = {
            {  
                event = "prp-galaxy:client:openShop",
                icon = "fas fa-box",
                label = "Storage",
                job = "galaxy",
            },
        },
        distance = 1.5
    })

    -- TEQUI-LA-LA STUFF
    exports['prp-target']:AddBoxZone("tequilalaDuty", vector3(-564.37, 278.34, 83.14), 1, 1.2, {
        name = "tequilalaDuty",
        heading = 32,
        debugPoly = false,
        minZ=83.0,
        maxZ=84.0,
    }, {
        options = {
            {  
                event = "prp-menu:TequilalaDutyMenu",
                icon = "far fa-clipboard",
                label = "Clock On/Off",
                job = "tequilala",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("tequilala_tray_1", vector3(-561.03, 286.61, 81.93), 1.05, 1.0, {
        name = "tequilala_tray_1",
        heading = 35.0,
        debugPoly = false,
        minZ=81.0,
        maxZ=83.3,
    }, {
        options = {
            {
                event = "prp-tequilalajob:Tray1",
                icon = "far fa-clipboard",
                label = "Pick Up Order",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("tequilalapump", vector3(-561.1, 288.11, 82.18), 1.05, 0.7, {
        name ="tequilalapump",
        heading = 10,
        debugPoly = false,
        minZ=82.0,
        maxZ=82.8,
    }, {
        options = {
            {
                event = "prp-menu:TequilalaBeerMenu",
                icon = "fas fa-filter",
                label = "Pour a Pint",
                job = "tequilala",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("tequilalamixer", vector3(-562.94, 285.7, 82.18), 1.05, 0.5, {
        name ="tequilalamixer",
        heading = 10,
        debugPoly = false,
        minZ=82.0,
        maxZ=82.8,
    }, {
        options = {
            {
                event = "prp-menu:TequilalaMixerMenu",
                icon = "fas fa-box",
                label = "Make Cocktails",
                job = "tequilala",
            },
        },
        distance = 2.5
    })

    exports['prp-target']:AddBoxZone("tequilalafridge", vector3(-562.79, 289.55, 82.23), 1.05, 1.0, {
        name ="tequilalafridge",
        heading = 25,
        debugPoly = false,
        minZ=82.0,
        maxZ=82.8,
    }, {
        options = {
            {
                event = "prp-menu:TequilalaMenu",
                icon = "fas fa-laptop",
                label = "Buy Items Or Check Storage!",
                job = "tequilala",
            },
        },
        distance = 2.5
    })

    -- Uncomment if you want to include a storage (not tested / needs minZ and MaxZ changing probably)

    --[[exports['prp-target']:AddBoxZone("tequilalastorage", vector3(-575.77, 286.25, 79.18), 1.05, 0.5, {
        name ="tequilalastorage",
        heading = 10,
        debugPoly = false,
        minZ=78.2,
        maxZ=79.5,
    }, {
        options = {
            {
                event = "prp-tequilalajob:Storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "tequilala",
            },
        },
        distance = 1.5
    })]]

    exports['prp-target']:AddBoxZone("tequilala_register_1", vector3(-563.16, 287.5, 82.18), 0.5, 0.4, {
        name ="tequilala_register_1",
        heading = 125,
        debugPoly = false,
        minZ=82.0,
        maxZ=82.8,
    }, {
        options = {
            {
                event = "prp-tequilalajob:bill",
                parms = "1",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "tequilala",
            },
        },
        distance = 1.5
    })

    -- Cloakroom / Entrance Fee
    exports['prp-target']:AddBoxZone("tequilala_register_2", vector3(-563.37, 278.79, 82.91), 0.5, 0.4, {
        name ="tequilala_register_2",
        heading = 125,
        debugPoly = false,
        minZ=82.6,
        maxZ=83.4,
    }, {
        options = {
            {
                event = "prp-tequilalajob:bill",
                parms = "1",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "tequilala",
            },
        },
        distance = 1.5
    })

-- Upstairs Bar

    --[[exports['prp-target']:AddBoxZone("tequilala_tray_2", vector3(-564.32, 285.46, 85.33), 1.05, 0.5, {
        name = "tequilala_tray_2",
        heading = 25,
        debugPoly = false,
        minZ=83.0,
        maxZ=86.0,
    }, {
        options = {
            {
                event = "prp-tequilalajob:Tray2",
                icon = "far fa-clipboard",
                label = "Pick Up Order",
            },
        },
        distance = 2.5
    })

    exports['prp-target']:AddBoxZone("tequilalapump2", vector3(-564.05, 286.28, 85.37), 1.05, 0.5, { 
        name ="tequilalapump2",
        heading = 34,
        debugPoly = false,
        minZ=85.0,
        maxZ=86.0,
    }, {
        options = {
            {
                event = "prp-menu:TequilalaBeerMenu",
                icon = "fas fa-filter",
                label = "Pour a Pint",
                job = "tequilala",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("tequilalamixer2", vector3(-566.04, 286.01, 85.33), 1.05, 0.5, {
        name ="tequilalamixer2",
        heading = 10,
        debugPoly = false,
        minZ=85.0,
        maxZ=86.0,
    }, {
        options = {
            {
                event = "prp-menu:TequilalaMixerMenu",
                icon = "fas fa-box",
                label = "Make Cocktails",
                job = "tequilala",
            },
        },
        distance = 2.5
    })

    exports['prp-target']:AddBoxZone("tequilala_register_3", vector3(-566.39, 284.74, 85.35), 0.5, 0.4, {
        name ="tequilala_register_3",
        heading = 125,
        debugPoly = false,
        minZ=84.0,
        maxZ=86.0,
    }, {
        options = {
            {
                event = "prp-tequilalajob:bill",
                parms = "1",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "tequilala",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("tequilalafridge2", vector3(-566.12, 287.48, 85.36), 1.05, 1.0, {
        name ="tequilalafridge2",
        heading = 25,
        debugPoly = false,
        minZ=85.0,
        maxZ=86.0,
    }, {
        options = {
            {
                event = "prp-menu:TequilalaMenu",
                icon = "fas fa-laptop",
                label = "Buy Items Or Check Storage!",
                job = "tequilala",
            },
        },
        distance = 2.5
    })]]

end)


-- prp-menu --

RegisterNetEvent('prp-menu:TequilalaMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Fridge |",
            isMenuHeader = true
        },
        { 
            header = "• Order Items",
            txt = "Buy items from the shop!",
            params = {
                event = "prp-tequilalajob:shop"
            }
        },
        { 
            header = "• Open Fridge",
            txt = "See what you have in storage",
            params = { 
                event = "prp-tequilalajob:Storage2"
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('prp-menu:TequilalaBeerMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Beer Menu |",
            isMenuHeader = true
        },
        { 
            header = "• A.M. Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:am-beer"
            }
        },
        { 
            header = "• Logger Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:logger-beer"
            }
        },
        { 
            header = "• Stronzo Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:stronzo-beer"
            }
        },
        { 
            header = "• Dusche Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:dusche-beer"
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('prp-menu:TequilalaMixerMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Mixer Menu |",
            isMenuHeader = true
        },
        { 
            header = "• Sunny Cocktail",
            txt = "Cocktail Glass",
            params = {
                event = "prp-tequilalajob:sunny-cocktail"
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('prp-menu:TequilalaDutyMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Clocking in/Off work |",
            isMenuHeader = true
        },
        { 
            header = "• Sign In/Off",
            txt = "",
            params = {
                event = "prp-tequilalajob:Duty",
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

local function closeMenuFull()
    exports['prp-menu']:closeMenu()
end


-- Register Stuff --
RegisterNetEvent("prp-tequilalajob:bill", function()
    local dialog = exports['prp-input']:ShowInput({
        header = "Till",
        submitText = "Bill Person",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'id',
                text = 'paypal id'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = '$ amount!'
            }
        }
    })
    if dialog then
        if not dialog.id or not dialog.amount then return end
        TriggerServerEvent("prp-tequilalajob:bill:player", dialog.id, dialog.amount)
    end
end)