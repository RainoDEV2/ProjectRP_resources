RegisterServerEvent('__ProjectRP:Logan')
AddEventHandler('__ProjectRP:Logan', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

        -- print("triggered")
        Player.Functions.RemoveItem('aluminum', 2)
        -- print("removing aluminium")
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['aluminum'], "remove")
        Player.Functions.AddItem('lockpick', 1)
        -- print("adding lockpick")
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['lockpick'], "add")


    -- ply.Functions.AddItem("lockpick", 1)
    -- TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["lockpick"], "add")
    TriggerEvent("prp-log:server:CreateLog", "default", "[NPC] Logan", "orange", "** ID: ".. source .. "\r Name: " .. GetPlayerName(source) .."**\n has traded in 2 Aluminium and recieved a Lockpick!..")

end)



-- =========  R E N T A L ===========

RegisterServerEvent('prp-rental:rentalpapers')
AddEventHandler('prp-rental:rentalpapers', function(plate, model, money)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local info = {}
    info.citizenid = Player.PlayerData.citizenid
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.plate = plate
    info.model = model
    TriggerClientEvent('inventory:client:ItemBox', src,  ProjectRP.Shared.Items["rentalpapers"], 'add')
    Player.Functions.AddItem('rentalpapers', 1, false, info)
    Player.Functions.RemoveMoney('bank', money, "vehicle-rental")
end)

RegisterServerEvent('prp-rental:removepapers')
AddEventHandler('prp-rental:removepapers', function(plate, model, money)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  ProjectRP.Shared.Items["rentalpapers"], 'remove')
    Player.Functions.RemoveItem('rentalpapers', 1, false, info)
end)
