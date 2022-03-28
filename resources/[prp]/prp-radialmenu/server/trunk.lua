local trunkBusy = {}

RegisterServerEvent('prp-trunk:server:setTrunkBusy')
AddEventHandler('prp-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

ProjectRP.Functions.CreateCallback('prp-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)

RegisterServerEvent('prp-trunk:server:KidnapTrunk')
AddEventHandler('prp-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('prp-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

ProjectRP.Commands.Add("getintrunk", "Get In Trunk", {}, false, function(source, args)
    TriggerClientEvent('prp-trunk:client:GetIn', source)
end)

ProjectRP.Commands.Add("putintrunk", "Put Player In Trunk", {}, false, function(source, args)
    TriggerClientEvent('prp-trunk:server:KidnapTrunk', source)
end)