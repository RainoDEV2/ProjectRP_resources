RegisterServerEvent('json:dataStructure')
AddEventHandler('json:dataStructure', function(data)
    -- ??
end)

RegisterServerEvent('prp-radialmenu:trunk:server:Door')
AddEventHandler('prp-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('prp-radialmenu:trunk:client:Door', -1, plate, door, open)
end)