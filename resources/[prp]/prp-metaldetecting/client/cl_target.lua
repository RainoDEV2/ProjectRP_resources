local ProjectRP = exports['prp-core']:GetCoreObject()

CreateThread(function()
    exports['prp-target']:SpawnPed({
        model = Config.CommonPed,
        coords = Config.CommonPedLocation, 
        minusOne = true, 
        freeze = true, 
        invincible = true, 
        blockevents = true,
        scenario = 'WORLD_HUMAN_DRUG_DEALER',
        target = { 
            options = {
                {
                    type="client",
                    event = "prp-metaldetector:CommonTradingMenu",
                    icon = "fas fa-user-secret",
                    label = "Trade your Finds"
                }
            },
            distance = 2.5,
        },
    })

    exports['prp-target']:SpawnPed({
        model = Config.RarePed, 
        coords = Config.RarePedLocation,
        minusOne = true, 
        freeze = true, 
        invincible = true, 
        blockevents = true,
        scenario = 'WORLD_HUMAN_DRUG_DEALER',
        target = { 
            options = {
                {
                    type = "client",
                    event = "prp-metaldetector:RareTradingMenu",
                    icon = "fas fa-user-secret",
                    label = "Trade your Rare Finds"
                }
            },
            distance = 2.5,
        },
    })
end)
