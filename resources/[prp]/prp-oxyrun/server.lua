RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function()
	local player = ProjectRP.Functions.GetPlayer(source)

	if player.PlayerData.money['cash'] >= Config.StartOxyPayment then
		player.Functions.RemoveMoney('cash', Config.StartOxyPayment)
		
		TriggerClientEvent("oxydelivery:startDealing", source)
	else
		TriggerClientEvent('ProjectRP:Notify', source, 'You Dont Have Enough Money', 'error')
	end
end)

RegisterServerEvent('oxydelivery:receiveBigRewarditem')
AddEventHandler('oxydelivery:receiveBigRewarditem', function()
	local player = ProjectRP.Functions.GetPlayer(source)

	player.PlayerData.AddItem(Config.BigRewarditem, 1)
	TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.BigRewarditem], "add")
end)

RegisterServerEvent('oxydelivery:receiveoxy')
AddEventHandler('oxydelivery:receiveoxy', function()
	local player = ProjectRP.Functions.GetPlayer(source)

	player.Functions.AddMoney('cash', math.random(Config.PaymentMin, Config.PaymentMax))
	player.Functions.AddItem(Config.Item, math.random(Config.OxyAmountMin, Config.OxyAmountMax))
	TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.Item], "add")
end)

RegisterServerEvent('oxydelivery:receivemoneyyy')
AddEventHandler('oxydelivery:receivemoneyyy', function()
	local player = ProjectRP.Functions.GetPlayer(source)

	player.Functions.AddMoney('cash', math.random(Config.PaymentMin, Config.PaymentMax))
end)