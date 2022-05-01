ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-labs:server:GetConfig', function(source, cb)
    cb(Config)
end)

local function FetchStock()
    local result = MySQL.Sync.fetchScalar('SELECT config FROM configs WHERE name = ?', {"keylabs"})
    local stockTable = json.decode(result)
    Config.Labs["methlab"].ingredients.stock = stockTable.methlab
    Config.Labs["methlab2"].ingredients.stock = stockTable.methlab2
    Config.Labs["cokelab"].ingredients.stock = stockTable.cokelab
    Config.Labs["weedlab"].ingredients.stock = stockTable.weedlab
    Config.Labs["moneywash"].washers[1].moneybags = stockTable.washer1
    Config.Labs["moneywash"].washers[2].moneybags = stockTable.washer2
    Config.Labs["moneywash"].washers[3].moneybags = stockTable.washer3
    Config.Labs["moneywash"].washers[4].moneybags = stockTable.washer4
    Config.Labs["moneywash"].washers[1].worth = stockTable.worth1
    Config.Labs["moneywash"].washers[2].worth = stockTable.worth2
    Config.Labs["moneywash"].washers[3].worth = stockTable.worth3
    Config.Labs["moneywash"].washers[4].worth = stockTable.worth4
    print("^3[prp-labs] ^5Data Fetched^7")
end

local function StoreStock()
    local stock = {
        methlab = Config.Labs["methlab"].ingredients.stock,
        methlab2 = Config.Labs["methlab2"].ingredients.stock,
        cokelab = Config.Labs["cokelab"].ingredients.stock,
        weedlab = Config.Labs["weedlab"].ingredients.stock,
        washer1 = Config.Labs["moneywash"].washers[1].moneybags,
        washer2 = Config.Labs["moneywash"].washers[2].moneybags,
        washer3 = Config.Labs["moneywash"].washers[3].moneybags,
        washer4 = Config.Labs["moneywash"].washers[4].moneybags,
        worth1 = Config.Labs["moneywash"].washers[1].worth,
        worth2 = Config.Labs["moneywash"].washers[2].worth,
        worth3 = Config.Labs["moneywash"].washers[3].worth,
        worth4 = Config.Labs["moneywash"].washers[4].worth
    }
    MySQL.Async.execute('UPDATE configs SET config = ? WHERE name = ?', {json.encode(stock), "keylabs"})
    print("^3[prp-labs] ^5Data Stored^7")
end

local function AddStock()
    Config.Labs["methlab"].ingredients.stock = Config.Labs["methlab"].ingredients.stock + Config.Resupply.amount
    TriggerClientEvent("prp-labs:client:UpdateStock", -1, 'methlab', Config.Labs["methlab"].ingredients.stock)
    Config.Labs["methlab2"].ingredients.stock = Config.Labs["methlab2"].ingredients.stock + Config.Resupply.amount
    TriggerClientEvent("prp-labs:client:UpdateStock", -1, 'methlab2', Config.Labs["methlab2"].ingredients.stock)
    Config.Labs["cokelab"].ingredients.stock = Config.Labs["cokelab"].ingredients.stock + Config.Resupply.amount
    TriggerClientEvent("prp-labs:client:UpdateStock", -1, 'cokelab', Config.Labs["cokelab"].ingredients.stock)
    Config.Labs["weedlab"].ingredients.stock = Config.Labs["weedlab"].ingredients.stock + Config.Resupply.amount
    TriggerClientEvent("prp-labs:client:UpdateStock", -1, 'weedlab', Config.Labs["weedlab"].ingredients.stock)
    print("^3[prp-labs] ^5Adding "..Config.Resupply.amount.." stock to labs^7")
    SetTimeout(Config.Resupply.time * (60 * 1000), AddStock) -- 30 minutes
end

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        StoreStock()
        CreateThread(function() 
            Wait(55000)
            StoreStock()
        end)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    StoreStock()
end)

RegisterNetEvent('prp-labs:server:lock', function(data)
    Config.Labs[data.lab].locked = true
    TriggerClientEvent('prp-labs:client:lock', -1, data.lab)
    TriggerClientEvent('prp-labs:client:DoorAnimation', source)
end)

RegisterNetEvent('prp-labs:server:unlock', function(data)
    Config.Labs[data.lab].locked = false
    TriggerClientEvent('prp-labs:client:unlock', -1, data.lab)
    TriggerClientEvent('prp-labs:client:DoorAnimation', source)
end)

-- Meth Baggies
ProjectRP.Functions.CreateUseableItem("meth_cured", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('meth_cured') ~= nil then
        TriggerClientEvent('prp-labs:client:MakeMethBags', source)
    end
end)

RegisterNetEvent('prp-labs:server:MakeMethBags', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('meth_cured')
    local baggies = Player.Functions.GetItemByName('empty_plastic_bag')
    if item and baggies then
        if baggies.amount >= 150 then
            local info = {purity = item.info.purity}
            Player.Functions.RemoveItem(item.name, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item.name], "remove")
            Player.Functions.RemoveItem("empty_plastic_bag", 150)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["empty_plastic_bag"], "remove")
            Player.Functions.AddItem("meth_baggy", 150, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["meth_baggy"], "add")
        else
            TriggerClientEvent('ProjectRP:Notify', src, "You need more plastic baggies (150)...", "error", 2500)
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, "You don't have any smaller plastic bags...", "error", 2500)
    end
end)

-- Coke baggies
ProjectRP.Functions.CreateUseableItem("coke_cured", function(source, item)
    print('test')
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('coke_cured') ~= nil then
        TriggerClientEvent('prp-labs:client:MakeCokeBags', source)
    end
end)

RegisterNetEvent('prp-labs:server:MakeCokeBags', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('coke_cured')
    local baggies = Player.Functions.GetItemByName('empty_plastic_bag')
    if item and baggies then
        if baggies.amount >= 150 then
            local info = {purity = item.info.purity}
            Player.Functions.RemoveItem(item.name, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item.name], "remove")
            Player.Functions.RemoveItem("empty_plastic_bag", 150)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["empty_plastic_bag"], "remove")
            Player.Functions.AddItem("coke_baggy", 150, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["coke_baggy"], "add")
        else
            TriggerClientEvent('ProjectRP:Notify', src, "You need more plastic baggies (150)...", "error", 2500)
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, "You don't have any smaller plastic bags...", "error", 2500)
    end
end)

-- Weed baggies
ProjectRP.Functions.CreateUseableItem("weed_cured", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('weed_cured') ~= nil then
        TriggerClientEvent('prp-labs:client:MakeWeedBags', source)
    end
end)

RegisterNetEvent('prp-labs:server:MakeWeedBags', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('weed_cured')
    local baggies = Player.Functions.GetItemByName('empty_plastic_bag')
    if item and baggies then
        if baggies.amount >= 150 then
            local info = {purity = item.info.purity}
            Player.Functions.RemoveItem(item.name, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item.name], "remove")
            Player.Functions.RemoveItem("empty_plastic_bag", 150)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["empty_plastic_bag"], "remove")
            Player.Functions.AddItem("weed_baggy", 150, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["weed_baggy"], "add")
        else
            TriggerClientEvent('ProjectRP:Notify', src, "You need more plastic baggies (150)...", "error", 2500)
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, "You don't have any smaller plastic bags...", "error", 2500)
    end
end)

CreateThread(function()
    FetchStock()
    if Config.Resupply.enable then
        print("^3[prp-labs] ^5Adding "..Config.Resupply.amount.." stock every "..Config.Resupply.time.." minutes^7")
        Wait(Config.Resupply.time*60*1000)
        AddStock()
    end
end)

-- Server Console Commands to force storing and fetching from the database (think about sudden server restarts)
RegisterCommand('keylabs_fetch', function(source)
    FetchStock()
end, true)

RegisterCommand('keylabs_store', function(source)
    StoreStock()
end, true)