ProjectRP.Functions.CreateCallback('prp-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            AvailableDrugs[#AvailableDrugs+1] = {
                item = item.name,
                amount = item.amount,
                label = ProjectRP.Shared.Items[item.name]["label"]
            }
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

RegisterServerEvent('prp-drugs:server:sellCornerDrugs')
AddEventHandler('prp-drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local hasItem = Player.Functions.GetItemByName(item)
    local AvailableDrugs = {}
    if hasItem.amount >= amount then

        TriggerClientEvent('ProjectRP:Notify', src, 'Offer accepted!', 'success')
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item], "remove")

        for i = 1, #Config.CornerSellingDrugsList, 1 do
            local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

            if item ~= nil then
                AvailableDrugs[#AvailableDrugs+1] = {
                    item = item.name,
                    amount = item.amount,
                    label = ProjectRP.Shared.Items[item.name]["label"]
                }
            end
        end

        TriggerClientEvent('prp-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
    else
        TriggerClientEvent('prp-drugs:client:cornerselling', src)
    end
end)

RegisterServerEvent('prp-drugs:server:robCornerDrugs')
AddEventHandler('prp-drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            AvailableDrugs[#AvailableDrugs+1] = {
                item = item.name,
                amount = item.amount,
                label = ProjectRP.Shared.Items[item.name]["label"]
            }
        end
    end

    TriggerClientEvent('prp-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)