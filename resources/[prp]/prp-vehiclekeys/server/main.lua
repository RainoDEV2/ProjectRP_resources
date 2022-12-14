-- Variables

local ProjectRP = exports['prp-core']:GetCoreObject()
local VehicleList = {}

-- Functions

function CheckOwner(plate, identifier)
    local retval = false
    if VehicleList then
        local found = VehicleList[plate]
        if found then
            retval = found.owners[identifier] ~= nil and found.owners[identifier]
        end
    end

    return retval
end

-- Events

RegisterNetEvent('vehiclekeys:server:SetVehicleOwner', function(plate)
    if plate then
        local src = source
        local Player = ProjectRP.Functions.GetPlayer(src)
        if VehicleList then
            -- VehicleList exists so check for a plate
            local val = VehicleList[plate]
            if val then
                -- The plate exists
                VehicleList[plate].owners[Player.PlayerData.citizenid] = true
            else
                -- Plate not currently tracked so store a new one with one owner
                VehicleList[plate] = {
                    owners = {}
                }
                VehicleList[plate].owners[Player.PlayerData.citizenid] = true
            end
        else
            -- Initialize new VehicleList
            VehicleList = {}
            VehicleList[plate] = {
                owners = {}
            }
            VehicleList[plate].owners[Player.PlayerData.citizenid] = true
        end
    else
        print('vehiclekeys:server:SetVehicleOwner - plate argument is nil')
    end
end)

RegisterNetEvent('vehiclekeys:server:GiveVehicleKeys', function(plate, target)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if CheckOwner(plate, Player.PlayerData.citizenid) then
        if ProjectRP.Functions.GetPlayer(target) ~= nil then
            TriggerClientEvent('vehiclekeys:client:SetOwner', target, plate)
            TriggerClientEvent('ProjectRP:Notify', src, "You gave the keys!")
            TriggerClientEvent('ProjectRP:Notify', target, "You got the keys!")
        else
            TriggerClientEvent('ProjectRP:Notify', source,  "Player Not Online", "error")
        end
    else
        TriggerClientEvent('ProjectRP:Notify', source,  "You Dont Own This Vehicle", "error")
    end
end)

-- callback

ProjectRP.Functions.CreateCallback('vehiclekeys:CheckOwnership', function(source, cb, plate)
    local check = VehicleList[plate]
    local retval = check ~= nil

    cb(retval)
end)

ProjectRP.Functions.CreateCallback('vehiclekeys:CheckHasKey', function(source, cb, plate)
    local Player = ProjectRP.Functions.GetPlayer(source)
    cb(CheckOwner(plate, Player.PlayerData.citizenid))
end)

-- command

ProjectRP.Commands.Add("engine", "Toggle Engine", {}, false, function(source, args)
	TriggerClientEvent('vehiclekeys:client:ToggleEngine', source)
end)

ProjectRP.Commands.Add("givecarkeys", "Give Car Keys", {{name = "id", help = "Player id"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('vehiclekeys:client:GiveKeys', src, target)
end)
