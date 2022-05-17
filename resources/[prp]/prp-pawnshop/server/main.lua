local ItemList = {
    ["goldchain"] = math.random(300, 550),
    ["diamond_ring"] = math.random(600, 1200),
    ["rolex"] = math.random(250, 350),
    ["10kgoldchain"] = math.random(300, 500),
}

local ItemListHardware = {
    ["tablet"] = math.random(50, 100),
    ["iphone"] = math.random(50, 125),
    ["samsungphone"] = math.random(75, 150),
    ["laptop"] = math.random(50, 135),
    ["gameboy"] = math.random(50, 135),
}

local MeltItems = {
    ["rolex"] = 24,
    ["goldchain"] = 32,
}

local GoldBarsAmount = 0

RegisterServerEvent("prp-pawnshop:server:sellPawnItems")
AddEventHandler("prp-pawnshop:server:sellPawnItems", function()
    local src = source
    local price = 0
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Player.PlayerData.items[k].name], "remove")
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold pawnable items")
        TriggerClientEvent('ProjectRP:Notify', src, "You have sold your items")
    end
end)

RegisterServerEvent("prp-pawnshop:server:sellHardwarePawnItems")
AddEventHandler("prp-pawnshop:server:sellHardwarePawnItems", function()
    local src = source
    local price = 0
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemListHardware[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemListHardware[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[Player.PlayerData.items[k].name], "remove")
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold pawnable items")
        TriggerClientEvent('ProjectRP:Notify', src, "You have sold your items")
    end

end)

RegisterServerEvent("prp-pawnshop:server:getGoldBars")
AddEventHandler("prp-pawnshop:server:getGoldBars", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if GoldBarsAmount > 0 then
        if Player.Functions.AddItem("goldbar", GoldBarsAmount) then
            GoldBarsAmount = 0
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["goldbar"], "add")
            Config.IsMelting = false
            Config.CanTake = false
            Config.MeltTime = 300
            TriggerClientEvent("prp-pawnshop:client:SetTakeState", -1, false)
        else
            TriggerClientEvent('ProjectRP:Notify', src, "You have no space in your inventory", "error")
        end
    end
end)

RegisterServerEvent("prp-pawnshop:server:sellGold")
AddEventHandler("prp-pawnshop:server:sellGold", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "goldbar" then 
                    price = price + (math.random(3000, 4200) * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[Player.PlayerData.items[k].name], "remove")
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-gold")
        TriggerClientEvent('ProjectRP:Notify', src, "You have sold your items")
    end
end)

RegisterServerEvent("prp-pawnshop:server:meltItems")
AddEventHandler("prp-pawnshop:server:meltItems", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local goldbars = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if MeltItems[Player.PlayerData.items[k].name] ~= nil then 
                    local amount = (Player.PlayerData.items[k].amount / MeltItems[Player.PlayerData.items[k].name])
                    if amount < 1 then
                        TriggerClientEvent('ProjectRP:Notify', src, "You do not have enough " .. Player.PlayerData.items[k].label, "error")
                    else
                        amount = math.ceil(Player.PlayerData.items[k].amount / MeltItems[Player.PlayerData.items[k].name])
                        if amount > 0 then
                            if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                                goldbars = goldbars + amount
                            end
                        end
                    end
                end
            end
        end
        if goldbars > 0 then
            GoldBarsAmount = goldbars
            TriggerClientEvent('prp-pawnshop:client:startMelting', -1)
            Config.IsMelting = true
            Config.MeltTime = 300
            Citizen.CreateThread(function()
                while Config.IsMelting do
                    Config.MeltTime = Config.MeltTime - 1
                    if Config.MeltTime <= 0 then
                        Config.IsMelting = false
                        Config.CanTake = true
                        Config.MeltTime = 300
                        TriggerClientEvent('prp-pawnshop:client:SetTakeState', -1, true)
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
    end
end)

ProjectRP.Functions.CreateCallback('prp-pawnshop:server:getSellPrice', function(source, cb)
    local retval = 0
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
    cb(retval)
end)

ProjectRP.Functions.CreateCallback('prp-pawnshop:melting:server:GetConfig', function(source, cb)
    cb(Config.IsMelting, Config.MeltTime, Config.CanTake)
end)

ProjectRP.Functions.CreateCallback('prp-pawnshop:server:getSellHardwarePrice', function(source, cb)
    local retval = 0
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemListHardware[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemListHardware[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
    cb(retval)
end)

ProjectRP.Functions.CreateCallback('prp-pawnshop:server:hasGold', function(source, cb)
	local retval = false
    local Player = ProjectRP.Functions.GetPlayer(source)
    local gold = Player.Functions.GetItemByName('goldbar')
    if gold ~= nil then
        retval = true
    end
    cb(retval)
end)
