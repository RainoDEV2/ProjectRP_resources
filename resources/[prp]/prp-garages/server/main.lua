local ProjectRP = exports['prp-core']:GetCoreObject()
local OutsideVehicles = {}

-- Events

RegisterNetEvent('prp-garages:server:UpdateOutsideVehicles', function(Vehicles)
    local src = source
    local Ply = ProjectRP.Functions.GetPlayer(src)
    local CitizenId = Ply.PlayerData.citizenid
    OutsideVehicles[CitizenId] = Vehicles
end)

RegisterNetEvent('prp-garage:server:PayDepotPrice', function(vehicle, garage)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local cashBalance = Player.PlayerData.money["cash"]
    local bankBalance = Player.PlayerData.money["bank"]
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = ?', {vehicle.plate}, function(result)
        if result[1] then
            if cashBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("cash", result[1].depotprice, "paid-depot")
                TriggerClientEvent("prp-garages:client:takeOutDepot", src, vehicle, garage)
            elseif bankBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("bank", result[1].depotprice, "paid-depot")
                TriggerClientEvent("prp-garages:client:takeOutDepot", src, vehicle, garage)
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
            end
        end
    end)
end)

RegisterNetEvent('prp-garage:server:updateVehicleState', function(state, plate, garage)
    exports.oxmysql:execute('UPDATE player_vehicles SET state = ?, garage = ?, depotprice = ? WHERE plate = ?',{state, garage, 0, plate})
end)

RegisterNetEvent('prp-garage:server:updateVehicleStatus', function(fuel, engine, body, plate, garage)
    local src = source
    local pData = ProjectRP.Functions.GetPlayer(src)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    exports.oxmysql:execute('UPDATE player_vehicles SET fuel = ?, engine = ?, body = ? WHERE plate = ? AND citizenid = ? AND garage = ?',{fuel, engine, body, plate, pData.PlayerData.citizenid, garage})
end)

-- Callbacks

ProjectRP.Functions.CreateCallback("prp-garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local pData = ProjectRP.Functions.GetPlayer(src)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',{plate, pData.PlayerData.citizenid}, function(result)
        if result[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)

ProjectRP.Functions.CreateCallback("prp-garage:server:GetOutsideVehicles", function(source, cb)
    local Ply = ProjectRP.Functions.GetPlayer(source)
    local CitizenId = Ply.PlayerData.citizenid
    if OutsideVehicles[CitizenId] and next(OutsideVehicles[CitizenId]) then
        cb(OutsideVehicles[CitizenId])
    else
        cb(nil)
    end
end)

ProjectRP.Functions.CreateCallback("prp-garage:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = ProjectRP.Functions.GetPlayer(src)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?', {pData.PlayerData.citizenid, garage}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ProjectRP.Functions.CreateCallback("prp-garage:server:GetVehicleProperties", function(source, cb, plate)
    local src = source
    local properties = {}
    local result = exports.oxmysql:executeSync('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] then
        properties = json.decode(result[1].mods)
    end
    cb(properties)
end)

ProjectRP.Functions.CreateCallback("prp-garage:server:GetDepotVehicles", function(source, cb)
    local src = source
    local pData = ProjectRP.Functions.GetPlayer(src)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE citizenid = ? AND state = ?',{pData.PlayerData.citizenid, 0}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ProjectRP.Functions.CreateCallback("prp-garage:server:GetHouseVehicles", function(source, cb, house)
    local src = source
    local pData = ProjectRP.Functions.GetPlayer(src)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE garage = ?', {house}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ProjectRP.Functions.CreateCallback("prp-garage:server:checkVehicleHouseOwner", function(source, cb, plate, house)
    local src = source
    local pData = ProjectRP.Functions.GetPlayer(src)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        if result[1] then
            local hasHouseKey = exports['prp-houses']:hasKey(result[1].license, result[1].citizenid, house)
            if hasHouseKey then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)
