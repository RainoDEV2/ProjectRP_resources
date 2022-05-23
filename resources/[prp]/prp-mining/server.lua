ProjectRP = nil

ProjectRP = exports['prp-core']:GetCoreObject()

RegisterServerEvent('prp-mining:MineReward')
AddEventHandler('prp-mining:MineReward', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    -- local randomChance = math.random(1, 3)
    local randomChance = math.random(1, 2)
    Player.Functions.AddItem('stone', randomChance)
    TriggerClientEvent("inventory:client:ItemBox", source, ProjectRP.Shared.Items["stone"], "add", randomChance)
end)

--Stone Cracking Checking Triggers
--Command here to check if any stone is in inventory

RegisterServerEvent('prp-mining:CrackReward')
AddEventHandler('prp-mining:CrackReward', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, ProjectRP.Shared.Items["stone"], "remove", 1)
    local oreToGive = nil
    oreToGive = math.random(1,#Config.RewardPool)
    local amount = math.random(1, 3)
    Player.Functions.AddItem(Config.RewardPool[oreToGive], amount)
    TriggerClientEvent("inventory:client:ItemBox", source, ProjectRP.Shared.Items[Config.RewardPool[oreToGive]], "add", amount)
end)

RegisterNetEvent("prp-mining:Selling")
AddEventHandler("prp-mining:Selling", function(data)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local currentitem = data
    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.SellItems[data])
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay, "Mining Job")
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[data], 'remove', amount)
    else
        TriggerClientEvent("ProjectRP:Notify", src, "You don't have any "..ProjectRP.Shared.Items[data].label, "error")
    end
    Citizen.Wait(1000)
end)

RegisterNetEvent("prp-mining:SellJewel")
AddEventHandler("prp-mining:SellJewel", function(data)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local currentitem = data
    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.SellItems[data])
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay, "Jewel Sell")
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[data], 'remove', amount)
    else
        TriggerClientEvent("ProjectRP:Notify", src, "You don't have any "..ProjectRP.Shared.Items[data].label, "error")
    end
    Citizen.Wait(1000)
end)

--Attempt at making simple crafting/smelting recipies
--Basically choose from the menus which provides an ID, it reads what is required, then gives the result
--shows error if requirements aren't met

--These command checks the requirements for each recipe, had to keep separate to keep control of when it happens.
ProjectRP.Functions.CreateCallback('prp-mining:Smelting:Check:1', function(source, cb)
	local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('copperore') ~= nil then cb(true)
	else cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Smelting:Check:2', function(source, cb)
	local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
	local item = Player.Functions.GetItemByName('goldore')
	if item ~= nil and item.amount >= 6 then cb(true)
	else cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Smelting:Check:3', function(source, cb)
	local src = source
    local Player = ProjectRP.Functions.GetPlayer(source) 
	if Player.Functions.GetItemByName('ironore') ~= nil then cb(true)
	else cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Smelting:Check:4', function(source, cb)
	local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('ironore') ~= nil and Player.Functions.GetItemByName('carbon') ~= nil then cb(true)
	else cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Smelting:Check:5', function(source, cb)
	local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
	local item = Player.Functions.GetItemByName('bottle')
	if item ~= nil and item.amount >= 10 then cb(true)
	else cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Smelting:Check:6', function(source, cb)
	local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
	local item = Player.Functions.GetItemByName('can')
	if item ~= nil and item.amount >= 5 then cb(true)
	else cb(false)
	end
end)

--These obviously are the rewards for each ID
--This is called after the animation/progressbar is completed
RegisterServerEvent('prp-mining:Smelting:Reward')
AddEventHandler('prp-mining:Smelting:Reward', function(data)
    local src = source
	local Player = ProjectRP.Functions.GetPlayer(source)
	if data == 1 then
		Player.Functions.RemoveItem('copperore', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['copperore'], 'remove', 1)
		Player.Functions.AddItem("copper", 5)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["copper"], 'add', 5)
	elseif data == 2 then
		Player.Functions.RemoveItem('goldore', 6)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldore'], 'remove', 6)
		Player.Functions.AddItem("goldbar", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["goldbar"], 'add', 1)
	elseif data == 3 then
		Player.Functions.RemoveItem('ironore', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['ironore'], 'remove', 1)
		Player.Functions.AddItem("iron", 5)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["iron"], 'add', 5)
	elseif data == 4 then
		Player.Functions.RemoveItem('ironore', 1)
		Player.Functions.RemoveItem('carbon', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['ironore'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['carbon'], 'remove', 1)
		Player.Functions.AddItem("steel", 4)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["steel"], 'add', 4)
	elseif data == 5 then
		Player.Functions.RemoveItem('bottle', 20)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['bottle'], 'remove', 10)
		Player.Functions.AddItem("glass", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["glass"], 'add', 1)
	elseif data == 6 then
		Player.Functions.RemoveItem('can', 10)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['can'], 'remove', 5)
		Player.Functions.AddItem("aluminum", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["aluminum"], 'add', 1)
	end
end)

------------------------------------------------------------

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:Tools', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('handdrill') ~= nil and Player.Functions.GetItemByName('drillbit') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:1', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_emerald') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:2', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_ruby') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:3', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_diamond') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:4', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_sapphire') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:5', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldbar') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:6', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('gold_ring') ~= nil and Player.Functions.GetItemByName('diamond') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:7', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('gold_ring') ~= nil and Player.Functions.GetItemByName('emerald') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:8', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('gold_ring') ~= nil and Player.Functions.GetItemByName('ruby') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:9', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('gold_ring') ~= nil and Player.Functions.GetItemByName('sapphire') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:10', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldbar') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:11', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldbar') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:12', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldchain') ~= nil and Player.Functions.GetItemByName('diamond') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:13', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldchain') ~= nil and Player.Functions.GetItemByName('emerald') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:14', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldchain') ~= nil and Player.Functions.GetItemByName('ruby') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

ProjectRP.Functions.CreateCallback('prp-mining:Cutting:Check:15', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldchain') ~= nil and Player.Functions.GetItemByName('sapphire') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

RegisterServerEvent('prp-mining:Cutting:Reward')
AddEventHandler('prp-mining:Cutting:Reward', function(data)
    local src = source
	local Player = ProjectRP.Functions.GetPlayer(source)
	local breackChance = math.random(1,10)
	if breackChance >= 9 then
		Player.Functions.RemoveItem('drillbit', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['drillbit'], 'remove', 1)
	end
	if data == 1 then
		Player.Functions.RemoveItem('uncut_emerald', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['uncut_emerald'], 'remove', 1)
		Player.Functions.AddItem("emerald", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["emerald"], 'add', 1)
	elseif data == 2 then
		Player.Functions.RemoveItem('uncut_ruby', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['uncut_ruby'], 'remove', 1)
		Player.Functions.AddItem("ruby", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["ruby"], 'add', 1)
	elseif data == 3 then
		Player.Functions.RemoveItem('uncut_diamond', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['uncut_diamond'], 'remove', 1)
		Player.Functions.AddItem("diamond", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["diamond"], 'add', 1)
	elseif data == 4 then
		Player.Functions.RemoveItem('uncut_sapphire', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['uncut_sapphire'], 'remove', 1)
		Player.Functions.AddItem("sapphire", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["sapphire"], 'add', 1)
	elseif data == 5 then
		Player.Functions.RemoveItem('goldbar', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldbar'], 'remove', 1)
		Player.Functions.AddItem("gold_ring", 3)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["gold_ring"], 'add', 3)
	elseif data == 6 then
		Player.Functions.RemoveItem('gold_ring', 1)
		Player.Functions.RemoveItem('diamond', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['gold_ring'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['diamond'], 'remove', 1)
		Player.Functions.AddItem("diamond_ring", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["diamond_ring"], 'add', 1)
	elseif data == 7 then
		Player.Functions.RemoveItem('gold_ring', 1)
		Player.Functions.RemoveItem('emerald', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['gold_ring'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['emerald'], 'remove', 1)
		Player.Functions.AddItem("emerald_ring", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["emerald_ring"], 'add', 1)
	elseif data == 8 then
		Player.Functions.RemoveItem('gold_ring', 1)
		Player.Functions.RemoveItem('ruby', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['gold_ring'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['ruby'], 'remove', 1)
		Player.Functions.AddItem("ruby_ring", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["ruby_ring"], 'add', 1)
	elseif data == 9 then
		Player.Functions.RemoveItem('gold_ring', 1)
		Player.Functions.RemoveItem('sapphire', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['gold_ring'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['sapphire'], 'remove', 1)
		Player.Functions.AddItem("sapphire_ring", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["sapphire_ring"], 'add', 1)
	elseif data == 10 then
		Player.Functions.RemoveItem('goldbar', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldbar'], 'remove', 1)
		Player.Functions.AddItem("goldchain", 3)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["goldchain"], 'add', 3)
	elseif data == 11 then
		Player.Functions.RemoveItem('goldbar', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldbar'], 'remove', 1)
		Player.Functions.AddItem("10kgoldchain", 2)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["10kgoldchain"], 'add', 2)
	elseif data == 12 then
		Player.Functions.RemoveItem('goldchain', 1)
		Player.Functions.RemoveItem('diamond', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldchain'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['diamond'], 'remove', 1)
		Player.Functions.AddItem("diamond_necklace", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["diamond_necklace"], 'add', 1)
	elseif data == 13 then
		Player.Functions.RemoveItem('goldchain', 1)
		Player.Functions.RemoveItem('emerald', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldchain'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['emerald'], 'remove', 1)
		Player.Functions.AddItem("emerald_necklace", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["emerald_necklace"], 'add', 1)
	elseif data == 14 then
		Player.Functions.RemoveItem('goldchain', 1)
		Player.Functions.RemoveItem('ruby', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldchain'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['ruby'], 'remove', 1)
		Player.Functions.AddItem("ruby_necklace", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["ruby_necklace"], 'add', 1)
	elseif data == 15 then
		Player.Functions.RemoveItem('goldchain', 1)
		Player.Functions.RemoveItem('sapphire', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['goldchain'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['sapphire'], 'remove', 1)
		Player.Functions.AddItem("sapphire_necklace", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["sapphire_necklace"], 'add', 1)
	end
end)