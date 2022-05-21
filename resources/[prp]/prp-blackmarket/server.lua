-------------------- Core --------------------

local ProjectRP = exports['prp-core']:GetCoreObject()

-------------------- Events --------------------

RegisterServerEvent('prp-blackmarket:server:itemgo', function(money, itemcode, itemstring)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local moneyPlayer = tonumber(Player.PlayerData.money.crypto)

    if moneyPlayer <= money then
        TriggerClientEvent('ProjectRP:Notify', src, "You don't have enough Crypto!", 'error')
    else
        Player.Functions.RemoveMoney('crypto', tonumber(money), 'black-market')
        Player.Functions.AddItem(itemcode, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[itemcode], "add")
    end
end)

RegisterServerEvent('prp-blackmarket:server:CreatePed', function(x, y, z, w) --- Ped Sync
    TriggerClientEvent('prp-blackmarket:client:CreatePed', -1, x, y, z, w)
end)
