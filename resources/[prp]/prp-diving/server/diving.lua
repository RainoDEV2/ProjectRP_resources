local CurrentDivingArea = math.random(1, #PRPDiving.Locations)

ProjectRP.Functions.CreateCallback('prp-diving:server:GetDivingConfig', function(source, cb)
    cb(PRPDiving.Locations, CurrentDivingArea)
end)

RegisterNetEvent('prp-diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local CoralType = math.random(1, #PRPDiving.CoralTypes)
    local Amount = math.random(1, PRPDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = ProjectRP.Shared.Items[PRPDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
            Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    end

    if (PRPDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(PRPDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        PRPDiving.Locations[CurrentDivingArea].TotalCoral = PRPDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #PRPDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Wait(3)
            newLocation = math.random(1, #PRPDiving.Locations)
        end
        CurrentDivingArea = newLocation

        TriggerClientEvent('prp-diving:client:NewLocations', -1)
    else
        PRPDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        PRPDiving.Locations[Area].TotalCoral = PRPDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('prp-diving:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterNetEvent('prp-diving:server:RemoveGear', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["diving_gear"], "remove")
end)

RegisterNetEvent('prp-diving:server:GiveBackGear', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["diving_gear"], "add")
end)
