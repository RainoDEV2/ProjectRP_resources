-------------------- Core --------------------

local ProjectRP = exports['prp-core']:GetCoreObject()

-------------------- Events --------------------

RegisterServerEvent('prp-blackmarket:server:itemgo', function(money, itemcode, itemstring)
    local source = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    local moneyPlayer = tonumber(Player.PlayerData.money.crypto)

    if moneyPlayer <= money then
        TriggerClientEvent('ProjectRP:Notify', source, "You don't have enough Crypto!", 'error')
    else
        Player.Functions.RemoveMoney('crypto', tonumber(money), 'black-market')
        Player.Functions.AddItem(itemcode, 1, false)
    end
end)

RegisterServerEvent('prp-blackmarket:server:CreatePed', function(x, y, z, w) --- Ped Sync
    TriggerClientEvent('prp-blackmarket:client:CreatePed', -1, x, y, z, w)
end)
