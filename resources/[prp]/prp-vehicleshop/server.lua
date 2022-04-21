-- Variables
local ProjectRP = exports['prp-core']:GetCoreObject()
local financetimer = {}
local paymentDue = false

-- Handlers

-- Store game time for player when they load
RegisterNetEvent('prp-vehicleshop:server:addPlayer', function(citizenid, gameTime)
    financetimer[citizenid] = gameTime
end)

-- Deduct stored game time from player on logout
RegisterNetEvent('prp-vehicleshop:server:removePlayer', function(citizenid)
    if financetimer[citizenid] then
        local playTime = financetimer[citizenid]
        local financetime = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {citizenid})
        for k,v in pairs(financetime) do
            if v.balance >= 1 then
                local newTime = math.floor(v.financetime - (((GetGameTimer() - playTime) / 1000) / 60))
                if newTime < 0 then newTime = 0 end
                MySQL.Async.execute('UPDATE player_vehicles SET financetime = ? WHERE plate = ?', {newTime, v.plate})
            end
        end
    end
    financetimer[citizenid] = nil
end)

-- Deduct stored game time from player on quit because we can't get citizenid
AddEventHandler('playerDropped', function()
    local src = source
    for k,v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end
    if license then
        local vehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE license = ?', {license})
        if vehicles then
            for k,v in pairs(vehicles) do
                local playTime = financetimer[v.citizenid]
                if v.balance >= 1 and playTime then
                    local newTime = math.floor(v.financetime - (((GetGameTimer() - playTime) / 1000) / 60))
                    if newTime < 0 then newTime = 0 end
                    MySQL.Async.execute('UPDATE player_vehicles SET financetime = ? WHERE plate = ?', {newTime, v.plate})
                end
            end
            if vehicles[1] and financetimer[vehicles[1].citizenid] then financetimer[vehicles[1].citizenid] = nil end
        end
    end
end)

-- Functions

local function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

local function calculateFinance(vehiclePrice, downPayment, paymentamount)
    local balance = vehiclePrice - downPayment
    local vehPaymentAmount = balance / paymentamount
    return round(balance), round(vehPaymentAmount)
end

local function calculateNewFinance(paymentAmount, vehData)
    local newBalance = tonumber(vehData.balance - paymentAmount)
    local minusPayment = vehData.paymentsLeft - 1
    local newPaymentsLeft = newBalance / minusPayment
    local newPayment = newBalance / newPaymentsLeft
    return round(newBalance), round(newPayment), newPaymentsLeft
end

local function GeneratePlate()
    local plate = ProjectRP.Shared.RandomInt(1) .. ProjectRP.Shared.RandomStr(2) .. ProjectRP.Shared.RandomInt(3) .. ProjectRP.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

-- Callbacks

ProjectRP.Functions.CreateCallback('prp-vehicleshop:server:getVehicles', function(source, cb)
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    if player then
        local vehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid})
        if vehicles[1] then
            cb(vehicles)
        end
    end
end)

-- Events

-- Sync vehicle for other players
RegisterNetEvent('prp-vehicleshop:server:swapVehicle', function(data)
    local src = source
    TriggerClientEvent('prp-vehicleshop:client:swapVehicle', -1, data)
    Wait(1500) -- let new car spawn
    TriggerClientEvent('prp-vehicleshop:client:homeMenu', src) -- reopen main menu
end)

-- Send customer for test drive
RegisterNetEvent('prp-vehicleshop:server:customTestDrive', function(vehicle, playerid)
    local src = source
    local target = tonumber(playerid)
    if not ProjectRP.Functions.GetPlayer(target) then
        TriggerClientEvent('ProjectRP:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end
    if #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))<3 then
        TriggerClientEvent('prp-vehicleshop:client:customTestDrive', target, vehicle)
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'This player is not close enough', 'error')
    end
end)

-- Make a finance payment
RegisterNetEvent('prp-vehicleshop:server:financePayment', function(paymentAmount, vehData)
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local plate = vehData.vehiclePlate
    local paymentAmount = tonumber(paymentAmount)
    local minPayment = tonumber(vehData.paymentAmount)
    local timer = (Config.PaymentInterval * 60)
    local newBalance, newPaymentsLeft, newPayment = calculateNewFinance(paymentAmount, vehData)
    if newBalance > 0 then
        if player and paymentAmount >= minPayment then
            if cash >= paymentAmount then
                player.Functions.RemoveMoney('cash', paymentAmount)
                MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {newBalance, newPayment, newPaymentsLeft, timer, plate})
            elseif bank >= paymentAmount then
                player.Functions.RemoveMoney('bank', paymentAmount)
                MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {newBalance, newPayment, newPaymentsLeft, timer, plate})
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
            end
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Minimum payment allowed is $' ..comma_value(minPayment), 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'You overpaid', 'error')
    end
end)


-- Pay off vehice in full
RegisterNetEvent('prp-vehicleshop:server:financePaymentFull', function(data)
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local vehBalance = data.vehBalance
    local vehPlate = data.vehPlate
    if player and vehBalance ~= 0 then
        if cash >= vehBalance then
            player.Functions.RemoveMoney('cash', vehBalance)
            MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {0, 0, 0, 0, vehPlate})
        elseif bank >= vehBalance then
            player.Functions.RemoveMoney('bank', vehBalance)
            MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {0, 0, 0, 0, vehPlate})
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Vehicle is already paid off', 'error')
    end
end)

-- Buy public vehicle outright
RegisterNetEvent('prp-vehicleshop:server:buyShowroomVehicle', function(vehicle)
    local src = source
    local vehicle = vehicle.buyVehicle
    local pData = ProjectRP.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = ProjectRP.Shared.Vehicles[vehicle]['price']
    local plate = GeneratePlate()
    if cash > vehiclePrice then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0
        })
        TriggerClientEvent('ProjectRP:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
    elseif bank > vehiclePrice then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0
        })
        TriggerClientEvent('ProjectRP:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
    end
end)

-- Finance public vehicle
RegisterNetEvent('prp-vehicleshop:server:financeVehicle', function(downPayment, paymentAmount, vehicle)
    local src = source
    local downPayment = tonumber(downPayment)
    local paymentAmount = tonumber(paymentAmount)
    local pData = ProjectRP.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = ProjectRP.Shared.Vehicles[vehicle]['price']
    local timer = (Config.PaymentInterval * 60)
    local minDown = tonumber(round((Config.MinimumDown/100) * vehiclePrice))
    if downPayment > vehiclePrice then return TriggerClientEvent('ProjectRP:Notify', src, 'Vehicle is not worth that much', 'error') end
    if downPayment < minDown then return TriggerClientEvent('ProjectRP:Notify', src, 'Down payment too small', 'error') end
    if paymentAmount > Config.MaximumPayments then return TriggerClientEvent('ProjectRP:Notify', src, 'Exceeded maximum payment amount', 'error') end
    local plate = GeneratePlate()
    local balance, vehPaymentAmount = calculateFinance(vehiclePrice, downPayment, paymentAmount)
    if cash >= downPayment then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0,
            balance,
            vehPaymentAmount,
            paymentAmount,
            timer
        })
        TriggerClientEvent('ProjectRP:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', downPayment, 'vehicle-bought-in-showroom')
    elseif bank >= downPayment then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0,
            balance,
            vehPaymentAmount,
            paymentAmount,
            timer
        })
        TriggerClientEvent('ProjectRP:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', downPayment, 'vehicle-bought-in-showroom')
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
    end
end)

-- Sell vehicle to customer
RegisterNetEvent('prp-vehicleshop:server:sellShowroomVehicle', function(data, playerid)
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    local target = ProjectRP.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('ProjectRP:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target.PlayerData.source)))<3 then
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehicle = data
        local vehiclePrice = ProjectRP.Shared.Vehicles[vehicle]['price']
        local commission = round(vehiclePrice * Config.Commission)
        local plate = GeneratePlate()
        if cash >= vehiclePrice then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0
            })
            TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission)
            TriggerClientEvent('ProjectRP:Notify', src, 'You earned $'..comma_value(commission)..' in commission', 'success')
            exports['prp-management']:AddMoney(player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        elseif bank >= vehiclePrice then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0
            })
            TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission)
            exports['prp-management']:AddMoney(player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('ProjectRP:Notify', src, 'You earned $'..comma_value(commission)..' in commission', 'success')
            TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'This player is not close enough', 'error')
    end
end)

-- Finance vehicle to customer
RegisterNetEvent('prp-vehicleshop:server:sellfinanceVehicle', function(downPayment, paymentAmount, vehicle, playerid)
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    local target = ProjectRP.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('ProjectRP:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target.PlayerData.source)))<3 then
        local downPayment = tonumber(downPayment)
        local paymentAmount = tonumber(paymentAmount)
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehiclePrice = ProjectRP.Shared.Vehicles[vehicle]['price']
        local timer = (Config.PaymentInterval * 60)
        local minDown = tonumber(round((Config.MinimumDown/100) * vehiclePrice))
        if downPayment > vehiclePrice then return TriggerClientEvent('ProjectRP:Notify', src, 'Vehicle is not worth that much', 'error') end
        if downPayment < minDown then return TriggerClientEvent('ProjectRP:Notify', src, 'Down payment too small', 'error') end
        if paymentAmount > Config.MaximumPayments then return TriggerClientEvent('ProjectRP:Notify', src, 'Exceeded maximum payment amount', 'error') end
        local commission = round(vehiclePrice * Config.Commission)
        local plate = GeneratePlate()
        local balance, vehPaymentAmount = calculateFinance(vehiclePrice, downPayment, paymentAmount)
        if cash >= downPayment then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0,
                balance,
                vehPaymentAmount,
                paymentAmount,
                timer
            })
            TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', downPayment, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission)
            TriggerClientEvent('ProjectRP:Notify', src, 'You earned $'..comma_value(commission)..' in commission', 'success')
            exports['prp-management']:AddMoney(player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        elseif bank >= downPayment then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0,
                balance,
                vehPaymentAmount,
                paymentAmount,
                timer
            })
            TriggerClientEvent('prp-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', downPayment, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission)
            TriggerClientEvent('ProjectRP:Notify', src, 'You earned $'..comma_value(commission)..' in commission', 'success')
            exports['prp-management']:AddMoney(player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'This player is not close enough', 'error')
    end
end)

-- Check if payment is due
RegisterNetEvent('prp-vehicleshop:server:checkFinance', function()
    local src = source
    local player = ProjectRP.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid})
    for k,v in pairs(result) do
        if v.balance >= 1 and v.financetime < 1 then
            paymentDue = true
        end
    end
    if paymentDue then
        TriggerClientEvent('ProjectRP:Notify', src, 'Your vehicle payment is due within '..Config.PaymentWarning..' minutes')
        Wait(Config.PaymentWarning * 60000)
        MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid}, function(vehicles)
            for k,v in pairs(vehicles) do
                if v.balance >= 1 and v.financetime < 1 then
                    local plate = v.plate
                    MySQL.Async.execute('DELETE FROM player_vehicles WHERE plate = @plate', {['@plate'] = plate})
                    TriggerClientEvent('ProjectRP:Notify', src, 'Your vehicle with plate '..plate..' has been repossessed', 'error')
                end
            end
        end)
    end
end)

-- Transfer vehicle to player in passenger seat
RegisterNetEvent('prp-vehicleshop:server:transferVehicle', function(plate, buyerId, amount)
    local src = source
    local plate = plate
    local buyerId = tonumber(buyerId)
    local sellAmount = tonumber(amount)
    local ped = GetPlayerPed(src)
    local player = ProjectRP.Functions.GetPlayer(src)
    local target = ProjectRP.Functions.GetPlayer(buyerId)
    local citizenid = player.PlayerData.citizenid
    if target ~= nil then
        if sellAmount then
            if target.Functions.GetMoney('cash') > sellAmount then
                local targetcid = target.PlayerData.citizenid
                MySQL.Async.execute('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', {targetcid, plate})
                player.Functions.AddMoney('cash', sellAmount)
                TriggerClientEvent('ProjectRP:Notify', src, 'You sold your vehicle for $'..comma_value(sellAmount), 'success')
                target.Functions.RemoveMoney('cash', sellAmount)
                TriggerClientEvent('vehiclekeys:client:SetOwner', target.PlayerData.source, plate)
                TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'You bought a vehicle for $'..comma_value(sellAmount), 'success')

                TriggerEvent("prp-log:server:CreateLog", "vehicleshop", "/Transfervehicle", "blue",
                '**Name**\n```Steam Name: ' .. GetPlayerName(src) .. ' (citizenid: ' .. player.PlayerData.citizenid .. ' | id: ' .. src .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(src).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(src).PlayerData.charinfo.lastname .. ')```\n **Details**\n``` transfered his vehicle to ' .. GetPlayerName(buyerId) .. ' (citizenid: ' .. target.PlayerData.citizenid .. ' | id: ' .. buyerId.. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(buyerId).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(buyerId).PlayerData.charinfo.lastname .. ') for $'..amount..'``` **Vehicle Details:** ```Plate: '..plate..'``` '
                )
            elseif target.Functions.GetMoney('bank') > sellAmount then
                local targetcid = target.PlayerData.citizenid
                MySQL.Async.execute('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', {targetcid, plate})
                player.Functions.AddMoney('bank', sellAmount)
                TriggerClientEvent('ProjectRP:Notify', src, 'You sold your vehicle for $'..comma_value(sellAmount), 'success')
                target.Functions.RemoveMoney('bank', sellAmount)
                TriggerClientEvent('vehiclekeys:client:SetOwner', target.PlayerData.source, plate)
                TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'You bought a vehicle for $'..comma_value(sellAmount), 'success')

                TriggerEvent("prp-log:server:CreateLog", "vehicleshop", "/Transfervehicle", "blue",
                '**Name**\n```Steam Name: ' .. GetPlayerName(src) .. ' (citizenid: ' .. player.PlayerData.citizenid .. ' | id: ' .. src .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(src).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(src).PlayerData.charinfo.lastname .. ')```\n **Details**\n``` transfered his vehicle to ' .. GetPlayerName(buyerId) .. ' (citizenid: ' .. target.PlayerData.citizenid .. ' | id: ' .. buyerId.. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(buyerId).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(buyerId).PlayerData.charinfo.lastname .. ') for $'..amount..'``` **Vehicle Details:** ```Plate: '..plate..'``` '
                )
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'Not enough money', 'error')
            end
        else
            local targetcid = target.PlayerData.citizenid
            MySQL.Async.execute('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', {targetcid, plate})
            TriggerClientEvent('ProjectRP:Notify', src, 'You gifted your vehicle', 'success')
            TriggerClientEvent('vehiclekeys:client:SetOwner', target.PlayerData.source, plate)
            TriggerClientEvent('ProjectRP:Notify', target.PlayerData.source, 'You were gifted a vehicle', 'success')
            
            TriggerEvent("prp-log:server:CreateLog", "vehicleshop", "/Transfervehicle", "blue",
            '**Name**\n```Steam Name: ' .. GetPlayerName(src) .. ' (citizenid: ' .. player.PlayerData.citizenid .. ' | id: ' .. src .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(src).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(src).PlayerData.charinfo.lastname .. ')```\n **Details**\n``` Gifted his vehicle to ' .. GetPlayerName(buyerId) .. ' (citizenid: ' .. target.PlayerData.citizenid .. ' | id: ' .. buyerId.. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(buyerId).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(buyerId).PlayerData.charinfo.lastname .. ') ``` **Vehicle Details:** ```Plate: '..plate..'``` '
            )

        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Couldn\'t get purchaser info.', 'error')
    end
end)

-- Transfer vehicle to player in passenger seat
ProjectRP.Commands.Add('transferVehicle', 'Gift or sell your vehicle', {{name = 'ID', help = 'ID of buyer'}, {name = 'amount', help = 'Sell amount'}}, false, function(source, args)
    if args[1] ~= nil and args[2] ~= nil then
        TriggerClientEvent('prp-vehicleshop:client:transferVehicle', source, args[1], args[2])
    else
        TriggerClientEvent('ProjectRP:Notify', source, 'Check who you\'re selling to or the amount to sell for.', 'error')
    end
end)