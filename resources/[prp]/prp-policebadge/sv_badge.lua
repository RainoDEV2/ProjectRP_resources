local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterServerEvent('policebadge:server:open')
AddEventHandler('policebadge:server:open', function(item, targetID, type)
	local Player = ProjectRP.Functions.GetPlayer(ID)

	local data = {
		name = item.info.name,
		rank = item.info.rank
	}

	TriggerClientEvent('policebadge:client:open', targetID, data)
	TriggerClientEvent('policebadge:client:show', targetID, source)
end)

RegisterServerEvent('policebadge:server:create')
AddEventHandler('policebadge:server:create', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

	local info = {
		name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
		rank = Player.PlayerData.job.grade.name.." ("..Player.PlayerData.metadata['callsign']..")"
	}

	Player.Functions.AddItem("policebadge", 1, false, info)
	TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["policebadge"], "add")
end)

ProjectRP.Functions.CreateUseableItem('policebadge', function(source, item)
    TriggerClientEvent('policebadge:client:openPD', source, item)
end)
