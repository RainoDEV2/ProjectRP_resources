RegisterServerEvent('prp-sound:server:play')
AddEventHandler('prp-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('prp-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('prp-sound:server:play:source')
AddEventHandler('prp-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('prp-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('prp-sound:server:play:distance')
AddEventHandler('prp-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('prp-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)