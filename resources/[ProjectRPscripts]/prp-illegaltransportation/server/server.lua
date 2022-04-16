local ProjectRP = exports['prp-core']:GetCoreObject()

AddEventHandler('playerDropped', function()
    TriggerClientEvent('prp-illegaltransportation:playerdropped', source)
end)

RegisterServerEvent('prp-illegaltransportation:PoliceNotfiy')
AddEventHandler('prp-illegaltransportation:PoliceNotfiy', function(coords)
    TriggerClientEvent('prp-illegaltransportation:PoliceNotifyC', -1, coords)
end)

ProjectRP.Functions.CreateCallback('prp-illegaltransportation:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.Payout
	xPlayer.Functions.AddMoney("cash", money,"Illegal Transport Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegaltransportation:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)