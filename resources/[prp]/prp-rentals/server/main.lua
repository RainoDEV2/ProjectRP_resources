local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterServerEvent('prp-rental:rentalpapers')
AddEventHandler('prp-rental:rentalpapers', function(plate, model, money)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local info = {}
    info.citizenid = Player.PlayerData.citizenid
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.plate = plate
    info.model = model
    TriggerClientEvent('inventory:client:ItemBox', src,  ProjectRP.Shared.Items["rentalpapers"], 'add')
    Player.Functions.AddItem('rentalpapers', 1, false, info)
    Player.Functions.RemoveMoney('bank', money, "vehicle-rental")
end)

RegisterServerEvent('prp-rental:removepapers')
AddEventHandler('prp-rental:removepapers', function(plate, model, money)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  ProjectRP.Shared.Items["rentalpapers"], 'remove')
    Player.Functions.RemoveItem('rentalpapers', 1, false, info)
end)
