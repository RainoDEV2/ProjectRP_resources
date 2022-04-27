local ProjectRP = exports['prp-core']:GetCoreObject()

local hiddenprocess = vector3(1101.15, -3198.83, -38.99) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords
local hiddenstart = vector3(382.81, 2576.6, 44.53) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords

RegisterNetEvent('coke:updateTable')
AddEventHandler('coke:updateTable', function(bool)
    TriggerClientEvent('coke:syncTable', -1, bool)
end)

ProjectRP.Functions.CreateUseableItem('coke', function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent('coke:onUse', source)
	end
end)

ProjectRP.Functions.CreateCallback('coke:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

ProjectRP.Functions.CreateCallback('coke:startcoords', function(source, cb)
    cb(hiddenstart)
end)

ProjectRP.Functions.CreateCallback('coke:pay', function(source, cb)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local amount = Config.rentalAmount
	local cashamount = Player.PlayerData.money["cash"]
    local toamount = tonumber(amount)

	if cashamount >= amount then
		Player.Functions.RemoveMoney('cash', amount) 
		cb(true)
	else
		TriggerClientEvent("ProjectRP:Notify", src, "You dont have enough Money to Start", "error", 4000)
		cb(false)
	end
end)

RegisterServerEvent("coke:processed")
AddEventHandler("coke:processed", function(x,y,z)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local bags = math.random(Config.bagsPerBrickMin, Config.bagsPerBrickMax)

	if TriggerClientEvent("ProjectRP:Notify", src, "Made a Coke Bag!!", "Success", 8000) then
		Player.Functions.RemoveItem('coke_brick', 1) 
		Player.Functions.AddItem('cokebaggy', bags)
		TriggerClientEvent("inventory:client:ItemBox", source, ProjectRP.Shared.Items['coke_brick'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, ProjectRP.Shared.Items['cokebaggy'], "add")
	end
end)

ProjectRP.Functions.CreateCallback('coke:process', function(source, cb)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)

	if Player.PlayerData.item ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
			if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "coke_brick" then
					cb(true)
				else
					TriggerClientEvent("ProjectRP:Notify", src, "You do not have any coke bricks", "error", 10000)
					cb(false)
				end
			end
		end	
	end
end)

RegisterServerEvent("coke:GiveItem")
AddEventHandler("coke:GiveItem", function()
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local price = Config.rentalReturnPrice
	print(Config.bricksPerRunMin)
	print(Config.bricksPerRunMax)
	local bricks = math.random(Config.bricksPerRunMin, Config.bricksPerRunMax)
	Player.Functions.AddMoney('cash', price)
	Player.Functions.AddItem('coke_brick', bricks)
	TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['coke_brick'], "add")
end)
