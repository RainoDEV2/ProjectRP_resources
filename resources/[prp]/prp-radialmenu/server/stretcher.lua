RegisterServerEvent('prp-radialmenu:server:RemoveStretcher')
AddEventHandler('prp-radialmenu:server:RemoveStretcher', function(PlayerPos, StretcherObject)
    TriggerClientEvent('prp-radialmenu:client:RemoveStretcherFromArea', -1, PlayerPos, StretcherObject)
end)

RegisterServerEvent('prp-radialmenu:Stretcher:BusyCheck')
AddEventHandler('prp-radialmenu:Stretcher:BusyCheck', function(id, type)
    local MyId = source
    TriggerClientEvent('prp-radialmenu:Stretcher:client:BusyCheck', id, MyId, type)
end)

RegisterServerEvent('prp-radialmenu:server:BusyResult')
AddEventHandler('prp-radialmenu:server:BusyResult', function(IsBusy, OtherId, type)
    TriggerClientEvent('prp-radialmenu:client:Result', OtherId, IsBusy, type)
end)
