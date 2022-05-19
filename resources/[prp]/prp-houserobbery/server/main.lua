local ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-houserobbery:server:GetHouseConfig', function(source, cb)
    cb(Config.Houses)
end)

RegisterServerEvent('prp-houserobbery:server:enterHouse')
AddEventHandler('prp-houserobbery:server:enterHouse', function(house)
    local src = source
    local itemInfo = ProjectRP.Shared.Items["lockpick"]
    local Player = ProjectRP.Functions.GetPlayer(src)
    
    if not Config.Houses[house]["opened"] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('prp-houserobbery:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('prp-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]["opened"] = true
end)

function ResetHouseStateTimer(house)
    -- Cannot parse math.random "directly" inside the tonumber function
    local num = math.random(3333333, 11111111)
    local time = tonumber(num)
    Citizen.SetTimeout(time, function()
        Config.Houses[house]["opened"] = false
        for k, v in pairs(Config.Houses[house]["furniture"]) do
            v["searched"] = false
        end
        TriggerClientEvent('prp-houserobbery:client:ResetHouseState', -1, house)
    end)
end

RegisterServerEvent('prp-houserobbery:server:searchCabin')
AddEventHandler('prp-houserobbery:server:searchCabin', function(cabin, house)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local luck = math.random(1, 10)
    local itemFound = math.random(1, 4)
    local itemCount = 1

    local Tier = 1
    if Config.Houses[house]["tier"] == 1 then
        Tier = 1
    elseif Config.Houses[house]["tier"] == 2 then
        Tier = 2
    elseif Config.Houses[house]["tier"] == 3 then
        Tier = 3
    end

    local cops = GetCurrentCops()
    if cops >= 1 then
        if math.random(1, 500) == 1 then
            Player.Functions.AddItem("gunkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "gunkey", "add")
        elseif math.random(1, 500) == 2 then
            Player.Functions.AddItem("cokekey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "cokekey", "add")
        elseif math.random(1, 250) == 3 then
            Player.Functions.AddItem("weedkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "weedkey", "add")
        elseif math.random(1, 500) == 4 then
            Player.Functions.AddItem("mwkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "mwkey", "add")
        elseif math.random(1, 500) == 5 then
            Player.Functions.AddItem("methkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "methkey", "add")
        end
    else
        if math.random(1, 2000) == 1 then
            Player.Functions.AddItem("gunkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "gunkey", "add")
        elseif math.random(1, 2000) == 2 then
            Player.Functions.AddItem("cokekey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "cokekey", "add")
        elseif math.random(1, 1500) == 3 then
            Player.Functions.AddItem("weedkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "weedkey", "add")
        elseif math.random(1, 2000) == 4 then
            Player.Functions.AddItem("mwkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "mwkey", "add")
        elseif math.random(1, 2000) == 5 then
            Player.Functions.AddItem("methkey", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, "methkey", "add")
        end
    end

    if itemFound < 4 then
        if luck == 10 then
            itemCount = 3
        elseif luck >= 6 and luck <= 8 then
            itemCount = 2
        end

        for i = 1, itemCount, 1 do
            local randomItem = Config.Rewards[Tier][Config.Houses[house]["furniture"][cabin]["type"]][math.random(1, #Config.Rewards[Tier][Config.Houses[house]["furniture"][cabin]["type"]])]
            local itemInfo = ProjectRP.Shared.Items[randomItem]
            if math.random(1, 100) == 69 then
                randomItem = "painkillers"
                itemInfo = ProjectRP.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 2)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            else
                if not itemInfo["unqiue"] then
                    local itemAmount = 1
                    if randomItem == "plastic" then
                        itemAmount = math.random(10, 16)
                    elseif randomItem == "pistol_ammo" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "cryptostick" then
                        itemAmount = 1
                    end
                    
                    Player.Functions.AddItem(randomItem, itemAmount)
                else
                    Player.Functions.AddItem(randomItem, 1)
                end
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            end
            Citizen.Wait(500)
            -- local weaponChance = math.random(1, 100)
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'The box is empty', 'error', 3500)
    end

    Config.Houses[house]["furniture"][cabin]["searched"] = true
    TriggerClientEvent('prp-houserobbery:client:setCabinState', -1, house, cabin, true)
end)

RegisterServerEvent('prp-houserobbery:server:SetBusyState')
AddEventHandler('prp-houserobbery:server:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
    TriggerClientEvent('prp-houserobbery:client:SetBusyState', -1, cabin, house, bool)
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end
