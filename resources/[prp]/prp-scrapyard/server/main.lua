Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        GenerateVehicleList()
        Citizen.Wait((1000 * 60) * 60)
    end
end)


RegisterNetEvent('prp-scrapyard:server:LoadVehicleList', function()
    local src = source
    TriggerClientEvent("prp-scapyard:client:setNewVehicles", src, Config.CurrentVehicles)
end)


ProjectRP.Functions.CreateCallback('prp-scrapyard:checkOwnerVehicle', function(source, cb, plate)
    local result = exports.oxmysql:scalarSync("SELECT `plate` FROM `player_vehicles` WHERE `plate` = ?",{plate})
    if result then
        cb(false)
    else 
        cb(true)
    end
end)


RegisterNetEvent('prp-scrapyard:server:ScrapVehicle', function(listKey)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Config.CurrentVehicles[listKey] ~= nil then
        local amount = math.random(4, 5)
        for i = 1, amount, 1 do
            local item = Config.Items[math.random(1, #Config.Items)]
            Player.Functions.AddItem(item, math.random(15, 25))
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item], 'add')
            Citizen.Wait(500)
        end
        local Luck = math.random(1, 8)
        if Luck == 1 then
            local random = math.random(8, 12)
            Player.Functions.AddItem("rubber", random)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["rubber"], 'add')

        end
        Config.CurrentVehicles[listKey] = nil
        TriggerClientEvent("prp-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
    end
end)

function GenerateVehicleList()
    Config.CurrentVehicles = {}
    for i = 1, 40, 1 do
        local randVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]
        if not IsInList(randVehicle) then
            Config.CurrentVehicles[i] = randVehicle
        end
    end
    TriggerClientEvent("prp-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end

function IsInList(name)
    local retval = false
    if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
        for k, v in pairs(Config.CurrentVehicles) do
            if Config.CurrentVehicles[k] == name then 
                retval = true
            end
        end
    end
    return retval
end
