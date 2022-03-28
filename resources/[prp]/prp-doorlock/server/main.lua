RegisterServerEvent('prp-doorlock:server:setupDoors')
AddEventHandler('prp-doorlock:server:setupDoors', function()
	TriggerClientEvent("prp-doorlock:client:setDoors", PRP.Doors)
end)

RegisterServerEvent('prp-doorlock:server:updateState')
AddEventHandler('prp-doorlock:server:updateState', function(doorID, state)
	PRP.Doors[doorID].locked = state

	TriggerClientEvent('prp-doorlock:client:setState', -1, doorID, state)
end)
