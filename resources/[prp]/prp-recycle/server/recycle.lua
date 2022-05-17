

local ProjectRP = exports['prp-core']:GetCoreObject()

local ItemTable = {
    "metalscrap",
    "plastic",
    -- "copper",
    -- "iron",
    -- "steel",
    "aluminum",
    "glass",
    "rubber",
	"bottle",
	"can",
}




--- Event For Getting Recyclable Material----

RegisterServerEvent("prp-recycle:getrecyclablematerial")
AddEventHandler("prp-recycle:getrecyclablematerial", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local amount = math.random(12, 18)
    Player.Functions.AddItem("recyclablematerial", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["recyclablematerial"], 'add', amount)
    Citizen.Wait(500)
end)

--------------------------------------------------

---- Trade Event Starts Over Here ------

RegisterServerEvent("prp-recycle:TradeItems")
AddEventHandler("prp-recycle:TradeItems", function(data)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	local randItem = ""
	local amount = 0
	if data == 1 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 10 then
			Player.Functions.RemoveItem("recyclablematerial", 10)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["recyclablematerial"], 'remove', 10)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.tenmin, Config.tenmax)
			Player.Functions.AddItem(randItem, amount)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.tenmin, Config.tenmax)
			Player.Functions.AddItem(randItem, amount)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			else
				TriggerClientEvent('ProjectRP:Notify', src, "You Don't Have Enough Items")
			end
	elseif data == 2 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 100 then
			Player.Functions.RemoveItem("recyclablematerial", "100")
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["recyclablematerial"], 'remove', 100)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000) 

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)
		else
			TriggerClientEvent('ProjectRP:Notify', src, "You Do Not Have Enough Items")
		end
    end
end)

---- Trade Event End Over Here ------

RegisterServerEvent("prp-recycle:Selling:All")
AddEventHandler("prp-recycle:Selling:All", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local payment = 0
	for k, v in pairs(Config.Prices) do
        if Player.Functions.GetItemByName(v.name) ~= nil then
            copper = Player.Functions.GetItemByName(v.name).amount
            pay = (copper * v.amount)
            Player.Functions.RemoveItem(v.name, copper)
            Player.Functions.AddMoney('cash', pay)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[v.name], 'remove', copper)
        payment = payment + pay
        end
    end
    Citizen.Wait(500)
	TriggerClientEvent("ProjectRP:Notify", src, "Total: $"..payment, 'success')
end)

RegisterNetEvent("prp-recycle:Selling:Mat")
AddEventHandler("prp-recycle:Selling:Mat", function(data)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.Prices[data].amount)
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[data], 'remove', amount)
        TriggerClientEvent("ProjectRP:Notify", src, "Total: $"..pay, "error")
    else
        TriggerClientEvent("ProjectRP:Notify", src, "You don't have any "..ProjectRP.Shared.Items[data].label.. "", "error")
    end
    Citizen.Wait(1000)
end)


RegisterServerEvent('prp-recycle:Dumpsters:Reward')
AddEventHandler('prp-recycle:Dumpsters:Reward', function(listKey)
    local src = source 
    local Player = ProjectRP.Functions.GetPlayer(src)
        for i = 1, math.random(1, 4), 1 do
            local item = Config.DumpItems[math.random(1, #Config.DumpItems)]
            local amount = math.random(1, 3)
            Player.Functions.AddItem(item, amount)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item], 'add', amount)
            Citizen.Wait(500)
        end
        local Luck = math.random(1, 7)
        local Odd = math.random(1, 7)
        if Luck == Odd then
            local random = math.random(1, 2)
            Player.Functions.AddItem("rubber", random)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["rubber"], 'add', random)
        end
end)
