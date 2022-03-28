ProjectRP.Commands.Add("fix", "Repair your vehicle (Admin Only)", {}, false, function(source, args)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

ProjectRP.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("prp-vehiclefailure:client:RepairVehicle", source)
    end
end)

ProjectRP.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("prp-vehiclefailure:client:CleanVehicle", source)
    end
end)

ProjectRP.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("prp-vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterServerEvent('prp-vehiclefailure:removeItem')
AddEventHandler('prp-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = ProjectRP.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('prp-vehiclefailure:server:removewashingkit')
AddEventHandler('prp-vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = ProjectRP.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('prp-vehiclefailure:client:SyncWash', -1, veh)
end)

