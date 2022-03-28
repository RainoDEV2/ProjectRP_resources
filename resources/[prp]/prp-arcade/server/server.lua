-- Variables
local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterNetEvent("prp-arcade:buyTicket")
AddEventHandler("prp-arcade:buyTicket", function(ticket)
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local data = Config.ticketPrice[ticket]
        if cash > data.price then
            player.Functions.RemoveMoney('cash', data.price)
            TriggerClientEvent("prp-arcade:ticketResult", source, ticket);
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
        end

end)