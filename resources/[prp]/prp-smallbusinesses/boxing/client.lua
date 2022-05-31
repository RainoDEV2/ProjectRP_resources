local ProjectRP = exports['prp-core']:GetCoreObject()

FightClubItems = {
    [1] = {
        name = "bandage",
        price = 50,
        amount = 3,
        info = {},
        type = "item",
        slot = 1,
    },
}

-- prp-target

Citizen.CreateThread(function()
    exports['prp-target']:AddBoxZone("fightClubDuty", vector3(4.86, -1669.25, 29.89), 0.5, 2, {
        name = "fightClubDuty",
        heading = 230,
        debugPoly = false,
        minZ=30.0,
        maxZ=31.2,
    }, {
        options = {
            {  
                event = "fightclub:client:ToggleDuty",
                icon = "far fa-clipboard",
                label = "Clock On/Off",
                job = "fightclub",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("fightClubGloves", vector3(-7.2, -1665.8, 28.7), 0.6, 1, {
        name = "fightClubGloves",
        heading = 320,
        debugPoly = false,
        minZ=28.5,
        maxZ=29.5,
    }, {
        options = {
            {  
                event = "fightclub:client:ToggleGloves",
                icon = "far fa-boxing-glove",
                label = "Put Gloves On/Off",
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("fightClubShop", vector3(-12.9, -1660.9, 29.29), 0.5, 1.2, {
        name = "fightClubShop",
        heading = 320,
        debugPoly = false,
        minZ=28.5,
        maxZ=29.5,
    }, {
        options = {
            {  
                event = "fightclub:client:openShop",
                icon = "fas fa-box",
                label = "Storage"
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("fightPunchBag1", vector3(-21.8, -1667.6, 29.29), 0.6, 0.6, {
        name = "fightPunchBag1",
        heading = 50,
        debugPoly = false,
        minZ=28.6,
        maxZ=30.4,
    }, {
        options = {
            {  
                event = "fightclub:client:punchBag",
                icon = "fas fa-glove",
                label = "Use Punching Bag"
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("fightPunchBag2", vector3(-19.39, -1664.82, 29.42), 0.6, 0.6, {
        name = "fightPunchBag2",
        heading = 50,
        debugPoly = false,
        minZ=28.6,
        maxZ=30.4,
    }, {
        options = {
            {  
                event = "fightclub:client:punchBag",
                icon = "fas fa-glove",
                label = "Use Punching Bag"
            },
        },
        distance = 1.5
    })

    exports['prp-target']:AddBoxZone("fightPunchBag2", vector3(-17.40, -1662.40, 29.4), 0.6, 0.6, {
        name = "fightPunchBag2",
        heading = 50,
        debugPoly = false,
        minZ=28.6,
        maxZ=30.4,
    }, {
        options = {
            {  
                event = "fightclub:client:punchBag",
                icon = "fas fa-glove",
                label = "Use Punching Bag"
            },
        },
        distance = 1.5
    })
end)

RegisterNetEvent("fightclub:client:ToggleDuty")
AddEventHandler("fightclub:client:ToggleDuty", function()
    TriggerServerEvent("ProjectRP:ToggleDuty")
end)

RegisterNetEvent('fightclub:client:openShop')
AddEventHandler('fightclub:client:openShop', function()
    local ShopItems = {}
    ShopItems.label = "Parlays Fight Club"
    ShopItems.items = FightClubItems
    ShopItems.slots = #FightClubItems
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "ParlaysFightClub", ShopItems)
end)

local Gloves = {}
local hasGloves = false
RegisterNetEvent('fightclub:client:ToggleGloves')
AddEventHandler('fightclub:client:ToggleGloves', function()
	while not HasAnimDictLoaded("nmt_3_rcm-10") do RequestAnimDict("nmt_3_rcm-10") Wait(100) end
    if hasGloves then
        for k, v in pairs(Gloves) do DeleteObject(v); end
        Gloves = {}
        hasGloves = false
    else
        local ped = GetPlayerPed(-1)
		local playerPedId = PlayerPedId()
		TaskPlayAnim(playerPedId, "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 1200, 51, 0, false, false, false)
        Wait(600)
        local hash = GetHashKey('prop_boxing_glove_01')
        while not HasModelLoaded(hash) do RequestModel(hash); Citizen.Wait(0); end
        local pos = GetEntityCoords(ped)
        local gloveA = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
        local gloveB = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
        table.insert(Gloves,gloveA)
        table.insert(Gloves,gloveB)
        SetModelAsNoLongerNeeded(hash)
        FreezeEntityPosition(gloveA,false)
        SetEntityCollision(gloveA,false,true)
        ActivatePhysics(gloveA)
        FreezeEntityPosition(gloveB,false)
        SetEntityCollision(gloveB,false,true)
        ActivatePhysics(gloveB)
        if not ped then ped = GetPlayerPed(-1); end -- gloveA = L, gloveB = R
        AttachEntityToEntity(gloveA, ped, GetPedBoneIndex(ped, 0xEE4F), 0.05, 0.00,  0.04,     00.0, 90.0, -90.0, true, true, false, true, 1, true) -- object is attached to right hand 
        AttachEntityToEntity(gloveB, ped, GetPedBoneIndex(ped, 0xAB22), 0.05, 0.00, -0.04,     00.0, 90.0,  90.0, true, true, false, true, 1, true) -- object is attached to right hand
        hasGloves = true 
    end
end)

function PunchBagGame()
    Citizen.CreateThread(function()
        Citizen.Wait(800)
        local seconds = math.random(4,10)
        local circles = math.random(15,20)
        exports['prp-lock']:StartLockPickCircle(circles, seconds, success)
    end)
end

RegisterNetEvent('fightclub:client:punchBag')
AddEventHandler('fightclub:client:punchBag', function()
    PunchBagGame()
	ProjectRP.Functions.Progressbar("punch_bag", "Using Punch Bag...", 20000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "anim@mp_player_intcelebrationmale@shadow_boxing",
		anim = "shadow_boxing",
		flags = 25,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "anim@mp_player_intcelebrationmale@shadow_boxing", "shadow_boxing", 1.0)
		ProjectRP.Functions.Notify("Wow your strong!", "success")
		InProcess = false
	end, function()
		StopAnimTask(PlayerPedId(), "anim@mp_player_intcelebrationmale@shadow_boxing", "shadow_boxing", 1.0)
		ProjectRP.Functions.Notify("Cancelled.", "error")
		InProcess = false
	end)
end)

-- Citizen.CreateThread(function()
--     local vuBlip = AddBlipForCoord(134.1635, -1302.5160, 29.2144)
--     SetBlipAsFriendly(vuBlip, true)
--     SetBlipSprite(vuBlip, 121)
--     SetBlipColour(vuBlip, 8)
--     SetBlipScale(vuBlip, 0.8)
--     SetBlipAsShortRange(vuBlip,true)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString(tostring("Boxing Gym"))
--     EndTextCommandSetBlipName(vuBlip)
-- end)
