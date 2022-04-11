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