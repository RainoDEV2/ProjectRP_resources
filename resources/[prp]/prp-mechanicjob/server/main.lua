local ProjectRP = exports['prp-core']:GetCoreObject()

local VehicleStatus = {}
local VehicleDrivingDistance = {}

ProjectRP.Functions.CreateCallback('prp-vehicletuning:server:GetDrivingDistances', function(source, cb)
    cb(VehicleDrivingDistance)
end)

RegisterServerEvent('prp-vehicletuning:server:SaveVehicleProps')
AddEventHandler('prp-vehicletuning:server:SaveVehicleProps', function(vehicleProps)
    if IsVehicleOwned(vehicleProps.plate) then
        exports.oxmysql:execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?',
            {json.encode(vehicleProps), vehicleProps.plate})
    end
end)

RegisterServerEvent("vehiclemod:server:setupVehicleStatus")
AddEventHandler("vehiclemod:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then
                statusInfo = {
                    ["engine"] = engineHealth,
                    ["body"] = bodyHealth,
                    ["radiator"] = Config.MaxStatusValues["radiator"],
                    ["axle"] = Config.MaxStatusValues["axle"],
                    ["brakes"] = Config.MaxStatusValues["brakes"],
                    ["clutch"] = Config.MaxStatusValues["clutch"],
                    ["fuel"] = Config.MaxStatusValues["fuel"]
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["engine"] = engineHealth,
                ["body"] = bodyHealth,
                ["radiator"] = Config.MaxStatusValues["radiator"],
                ["axle"] = Config.MaxStatusValues["axle"],
                ["brakes"] = Config.MaxStatusValues["brakes"],
                ["clutch"] = Config.MaxStatusValues["clutch"],
                ["fuel"] = Config.MaxStatusValues["fuel"]
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('prp-vehicletuning:server:UpdateDrivingDistance')
AddEventHandler('prp-vehicletuning:server:UpdateDrivingDistance', function(amount, plate)
    VehicleDrivingDistance[plate] = amount
    TriggerClientEvent('prp-vehicletuning:client:UpdateDrivingDistance', -1, VehicleDrivingDistance[plate], plate)
    local result = exports.oxmysql:executeSync('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] ~= nil then
        exports.oxmysql:execute('UPDATE player_vehicles SET drivingdistance = ? WHERE plate = ?', {amount, plate})
    end
end)

ProjectRP.Functions.CreateCallback('prp-vehicletuning:server:IsVehicleOwned', function(source, cb, plate)
    local retval = false
    local result = exports.oxmysql:scalarSync('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('prp-vehicletuning:server:LoadStatus')
AddEventHandler('prp-vehicletuning:server:LoadStatus', function(veh, plate)
    VehicleStatus[plate] = veh
    TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, veh)
end)

RegisterServerEvent("vehiclemod:server:updatePart")
AddEventHandler("vehiclemod:server:updatePart", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('prp-vehicletuning:server:SetPartLevel')
AddEventHandler('prp-vehicletuning:server:SetPartLevel', function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:fixEverything")
AddEventHandler("vehiclemod:server:fixEverything", function(plate)
    if VehicleStatus[plate] ~= nil then
        for k, v in pairs(Config.MaxStatusValues) do
            VehicleStatus[plate][k] = v
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:saveStatus")
AddEventHandler("vehiclemod:server:saveStatus", function(plate)
    if VehicleStatus[plate] ~= nil then
        exports.oxmysql:execute('UPDATE player_vehicles SET status = ? WHERE plate = ?',
            {json.encode(VehicleStatus[plate]), plate})
    end
end)

function IsVehicleOwned(plate)
    local result = exports.oxmysql:scalarSync('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    else
        return false
    end
end

function GetVehicleStatus(plate)
    local retval = nil
    local result = exports.oxmysql:executeSync('SELECT status FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] ~= nil then
        retval = result[1].status ~= nil and json.decode(result[1].status) or nil
    end
    return retval
end

ProjectRP.Commands.Add("setvehiclestatus", "Set Vehicle Status", {{
    name = "part",
    help = "Type The Part You Want To Edit"
}, {
    name = "amount",
    help = "The Percentage Fixed"
}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("vehiclemod:client:setPartLevel", source, part, level)
end, "god")

ProjectRP.Functions.CreateCallback('prp-vehicletuning:server:GetAttachedVehicle', function(source, cb)
    cb(Config.Plates)
end)

ProjectRP.Functions.CreateCallback('prp-vehicletuning:server:IsMechanicAvailable', function(source, cb)
    local amount = 0
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

RegisterServerEvent('prp-vehicletuning:server:SetAttachedVehicle')
AddEventHandler('prp-vehicletuning:server:SetAttachedVehicle', function(veh, k)
    if veh ~= false then
        Config.Plates[k].AttachedVehicle = veh
        TriggerClientEvent('prp-vehicletuning:client:SetAttachedVehicle', -1, veh, k)
    else
        Config.Plates[k].AttachedVehicle = nil
        TriggerClientEvent('prp-vehicletuning:client:SetAttachedVehicle', -1, false, k)
    end
end)

RegisterServerEvent('prp-vehicletuning:server:CheckForItems')
AddEventHandler('prp-vehicletuning:server:CheckForItems', function(part)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent('prp-vehicletuning:client:RepaireeePart', src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent('inventory:client:ItemBox', src,
                    ProjectRP.Shared.Items[Config.RepairCostAmount[part].item], "remove")
                Citizen.Wait(500)
            end
        else
            TriggerClientEvent('ProjectRP:Notify', src,
                "You Dont Have Enough " .. ProjectRP.Shared.Items[Config.RepairCostAmount[part].item]["label"] .. " (min. " ..
                    Config.RepairCostAmount[part].costs .. "x)", "error")
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, "You Do Not Have " ..
            ProjectRP.Shared.Items[Config.RepairCostAmount[part].item]["label"] .. " bij je!", "error")
    end
end)

function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

ProjectRP.Commands.Add("setmechanic", "Give Someone The Mechanic job", {{
    name = "id",
    help = "ID Of The Player"
}}, false, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = ProjectRP.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob("mechanic")
                TriggerClientEvent('ProjectRP:Notify', TargetData.PlayerData.source,
                    "You Were Hired As An Autocare Employee!")
                TriggerClientEvent('ProjectRP:Notify', source, "You have (" .. TargetData.PlayerData.charinfo.firstname ..
                    ") Hired As An Autocare Employee!")
            end
        else
            TriggerClientEvent('ProjectRP:Notify', source, "You Must Provide A Player ID!")
        end
    else
        TriggerClientEvent('ProjectRP:Notify', source, "You Cannot Do This!", "error")
    end
end)

ProjectRP.Commands.Add("firemechanic", "Fire A Mechanic", {{
    name = "id",
    help = "ID Of The Player"
}}, false, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = ProjectRP.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == "mechanic" then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('ProjectRP:Notify', TargetData.PlayerData.source,
                        "You Were Fired As An Autocare Employee!")
                    TriggerClientEvent('ProjectRP:Notify', source,
                        "You have (" .. TargetData.PlayerData.charinfo.firstname .. ") Fired As Autocare Employee!")
                else
                    TriggerClientEvent('ProjectRP:Notify', source, "Youre Not An Employee of Autocare!", "error")
                end
            end
        else
            TriggerClientEvent('ProjectRP:Notify', source, "You Must Provide A Player ID!", "error")
        end
    else
        TriggerClientEvent('ProjectRP:Notify', source, "You Cannot Do This!", "error")
    end
end)

ProjectRP.Functions.CreateCallback('prp-vehicletuning:server:GetStatus', function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)
