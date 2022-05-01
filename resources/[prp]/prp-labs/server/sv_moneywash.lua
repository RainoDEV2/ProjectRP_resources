-- MONEYWASH
RegisterNetEvent('prp-labs:server:BusyMoneyWash', function(index, bool)
    Config.Labs.moneywash.washers[index].busy = bool
    TriggerClientEvent('prp-labs:client:BusyMoneyWash', -1, index, bool)
end)

RegisterNetEvent('prp-labs:server:LoadMoneyWash', function(index)
    local bagAmount = 0
    local Player = ProjectRP.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("markedbills") then
        bagAmount = Player.Functions.GetItemByName("markedbills").amount
        local removeAmount = bagAmount
        local newAmount = Config.Labs.moneywash.washers[index].moneybags + bagAmount
        local addedWorth = Player.Functions.GetItemByName("markedbills").info.worth

        if newAmount > Config.Labs.moneywash.maxBags then
            removeAmount = Config.Labs.moneywash.maxBags - Config.Labs.moneywash.washers[index].moneybags
            newAmount = Config.Labs.moneywash.maxBags
        end
        print("^3[prp-labs] ^5Loaded Washer "..index.." with "..removeAmount.." bags worth: "..(removeAmount*addedWorth).."^7")
        Player.Functions.RemoveItem('markedbills', removeAmount)
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["markedbills"], "remove")

        Config.Labs.moneywash.washers[index].moneybags = newAmount
        Config.Labs.moneywash.washers[index].worth = Config.Labs.moneywash.washers[index].worth + (removeAmount*addedWorth)
        TriggerClientEvent('prp-labs:client:LoadMoneyWash', -1, index, newAmount, Config.Labs.moneywash.washers[index].worth)
    else
        TriggerClientEvent('ProjectRP:Notify', source, "You don't have any inked bills!", "error")
    end
end)

RegisterNetEvent('prp-labs:server:StartMoneyWash', function(data)
    Config.Labs.moneywash.washers[data.washer].started = true
    TriggerClientEvent('prp-labs:client:StartMoneyWash', -1, data.washer)
    print("^3[prp-labs] ^5Started Washer "..data.washer.." with "..Config.Labs.moneywash.washers[data.washer].moneybags.." bags worth: "..Config.Labs.moneywash.washers[data.washer].worth.."^7")
    CreateThread(function()
        Wait(1000*Config.Labs.moneywash.washers[data.washer].duration)
        Config.Labs.moneywash.washers[data.washer].started = false
        Config.Labs.moneywash.washers[data.washer].completed = true
        TriggerClientEvent('prp-labs:client:CompletedMoneyWash', -1, data.washer)
        print("^3[prp-labs] ^5Completed Washer "..data.washer.." with "..Config.Labs.moneywash.washers[data.washer].moneybags.." bags worth: "..Config.Labs.moneywash.washers[data.washer].worth.."^7")
    end)
end)

RegisterNetEvent('prp-labs:server:GrabMoney', function(index)
    -- PAY OUT
    local Player = ProjectRP.Functions.GetPlayer(source)
    local bags = Config.Labs.moneywash.washers[index].moneybags
    local payout = Config.Labs.moneywash.washers[index].worth
    Player.Functions.AddMoney('cash', payout)
    TriggerClientEvent('ProjectRP:Notify', source, "You received "..payout, "success")
    TriggerEvent("prp-log:server:CreateLog", 'keylabs', "Moneywash", "red", "**"..Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *(" .. Player.PlayerData.source .. "))*: has received " .. payout .. "$")  

    -- RESET WASHER(INDEX)
    Config.Labs.moneywash.washers[index].busy = false
    Config.Labs.moneywash.washers[index].started = false
    Config.Labs.moneywash.washers[index].completed = false
    Config.Labs.moneywash.washers[index].moneybags = 0
    Config.Labs.moneywash.washers[index].worth = 0
    TriggerClientEvent('prp-labs:client:ResetWasher', -1, index)
    print("^3[prp-labs] ^5"..Player.PlayerData.name.." took "..payout.." from washer "..index.."^7")   
end)