local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterNetEvent('prp-stealshoes:server:TheftShoe', function(playerId)
    local source = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    local Receiver = ProjectRP.Functions.GetPlayer(playerId)
    if Receiver then 
        TriggerClientEvent("prp-stealshoes:client:StoleShoe", Receiver.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterNetEvent("prp-stealshoes:server:Complete", function(playerId)
    local source = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    local Receiver = ProjectRP.Functions.GetPlayer(playerId)
    if Receiver then
        Receiver.Functions.AddItem("weapon_shoe", 2)
        TriggerClientEvent('inventory:client:ItemBox', Receiver.PlayerData.source, ProjectRP.Shared.Items["weapon_shoe"], 'add')
    end
end)