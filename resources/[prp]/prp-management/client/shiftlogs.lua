RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    TriggerServerEvent('prp-shiftlog:server:OnPlayerUnload')
end)

RegisterNetEvent('ProjectRP:Player:SetPlayerData', function(Player)
    TriggerServerEvent('prp-shiftlog:server:SetPlayerData', Player)
end)