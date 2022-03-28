RegisterNetEvent("prp-arcade:ticketResult")
AddEventHandler("prp-arcade:ticketResult", function(ticket)
    showNotification(_U("bought_ticket", ticket, Config.ticketPrice[ticket].time))

    -- Will set time player can be in arcade from Config
    seconds = 1
    minutes = Config.ticketPrice[ticket].time

    -- Tell the script that player has Ticket and can enter.
    gotTicket = true
end)

RegisterNetEvent("prp-arcade:nomoney")
AddEventHandler("prp-arcade:nomoney", function()
    showNotification(_U("not_enough_money"))
end)

RegisterNUICallback('exit', function()
    SendNUIMessage({
        type = "off",
        game = "",
    })
    SetNuiFocus(false, false)
end)