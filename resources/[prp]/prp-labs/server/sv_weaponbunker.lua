RegisterNetEvent('prp-labs:server:craftItem', function(data)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local hasItems = false
    if Player.Functions.GetItemByName(Config.CraftingCost[data].item1) then
        if Player.Functions.GetItemByName(Config.CraftingCost[data].item2) then
            if Player.Functions.GetItemByName(Config.CraftingCost[data].item3) then
                if Player.Functions.GetItemByName(Config.CraftingCost[data].item1).amount >= Config.CraftingCost[data].cost1 then
                    if Player.Functions.GetItemByName(Config.CraftingCost[data].item2).amount >= Config.CraftingCost[data].cost2 then
                        if Player.Functions.GetItemByName(Config.CraftingCost[data].item3).amount >= Config.CraftingCost[data].cost3 then
                            hasItems = true
                        end
                    end
                end
            end
        end
    end
    if hasItems then
        Player.Functions.RemoveItem(Config.CraftingCost[data].item1,Config.CraftingCost[data].cost1)
        Player.Functions.RemoveItem(Config.CraftingCost[data].item2,Config.CraftingCost[data].cost2)
        Player.Functions.RemoveItem(Config.CraftingCost[data].item3,Config.CraftingCost[data].cost3)
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.CraftingCost[data].item1], "remove")
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.CraftingCost[data].item2], "remove")
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.CraftingCost[data].item3], "remove")

        Player.Functions.AddItem(data, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[data], "add")
        TriggerClientEvent('ProjectRP:Notify', source, 'You crafted 1'..data)
        TriggerEvent("prp-log:server:CreateLog", 'keylabs', "Guncrafting", "black", "**"..Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *(" .. Player.PlayerData.source .. "))*: has crafted a "..data)
    else
        TriggerClientEvent('ProjectRP:Notify', source, 'You do not have the correct items.')
    end
end)

RegisterNetEvent('prp-labs:server:craftAmmo', function(data)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local hasItems = false
    if Player.Functions.GetItemByName(Config.CraftingCost[data].item1) then
        if Player.Functions.GetItemByName(Config.CraftingCost[data].item2) then
            if Player.Functions.GetItemByName(Config.CraftingCost[data].item3) then
                if Player.Functions.GetItemByName(Config.CraftingCost[data].item1).amount >= Config.CraftingCost[data].cost1 then
                    if Player.Functions.GetItemByName(Config.CraftingCost[data].item2).amount >= Config.CraftingCost[data].cost2 then
                        if Player.Functions.GetItemByName(Config.CraftingCost[data].item3).amount >= Config.CraftingCost[data].cost3 then
                            hasItems = true
                        end
                    end
                end
            end
        end
    end
    if hasItems then
        Player.Functions.RemoveItem(Config.CraftingCost[data].item1,Config.CraftingCost[data].cost1)
        Player.Functions.RemoveItem(Config.CraftingCost[data].item2,Config.CraftingCost[data].cost2)
        Player.Functions.RemoveItem(Config.CraftingCost[data].item3,Config.CraftingCost[data].cost3)
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.CraftingCost[data].item1], "remove")
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.CraftingCost[data].item2], "remove")
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.CraftingCost[data].item3], "remove")
        
        local receiveAmount = 10
        Player.Functions.AddItem(data, receiveAmount, false)
        TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[data], "add")
        TriggerClientEvent('ProjectRP:Notify', source, 'You crafted ' .. receiveAmount .. ' '..data)
        TriggerEvent("prp-log:server:CreateLog", 'keylabs', "Guncrafting", "black", "**"..Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *(" .. Player.PlayerData.source .. "))*: has crafted " .. receiveAmount .. " "..data)
    else
        TriggerClientEvent('ProjectRP:Notify', source, 'You do not have the correct items.')
    end
end)