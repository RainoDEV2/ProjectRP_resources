local ProjectRP = exports['prp-core']:GetCoreObject()


-- Events

RegisterServerEvent("decrypto:server:removeitem")
AddEventHandler("decrypto:server:removeitem", function(data)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local item = data
	Player.Functions.RemoveItem(item, 1)
	TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item], 'remove', 1)
	if not Player.PlayerData.metadata['stress'] then
		Player.PlayerData.metadata['stress'] = 0
	end
	local newStress = Player.PlayerData.metadata['stress'] + Config.AddStress
	if newStress <= 0 then newStress = 0 end
	if newStress > 100 then newStress = 100 end
	Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
	TriggerClientEvent('ProjectRP:Notify', src, "You are feeling more stressed!", 'error', 1500)
end)

RegisterNetEvent('decrypto:server:givecash')
AddEventHandler('decrypto:server:givecash', function()
	local src = source
	local pData = ProjectRP.Functions.GetPlayer(src)
	TriggerClientEvent("ProjectRP:Notify", src, "ATM cash received: $" .. Config.Withdrawal, "success", 7000)
	pData.Functions.AddMoney('cash', Config.Withdrawal, "ATM")
end)
