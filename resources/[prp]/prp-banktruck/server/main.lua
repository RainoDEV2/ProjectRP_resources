local ProjectRP = exports["prp-core"]:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-banktruck:server:GetConfig', function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("prp-pacific:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
        
        TriggerEvent('prp-board:server:SetActivityBusy', "banktruck", true)
    end
end)
RegisterServerEvent('prp-banktruck:server:OpenTruck')
AddEventHandler('prp-banktruck:server:OpenTruck', function(Veh) 
    TriggerClientEvent('prp-banktruck:client:OpenTruck', source, Veh)
    
    TriggerEvent('prp-board:server:SetActivityBusy', "banktruck", false)
end)

RegisterServerEvent('prp-banktruck:server:updateplates')
AddEventHandler('prp-banktruck:server:updateplates', function(Plate)
 Config.RobbedPlates[Plate] = true
 TriggerClientEvent('prp-banktruck:plate:table', -1, Plate)
end)

RegisterServerEvent('prp-banktruck:sever:send:cop:alert')
AddEventHandler('prp-banktruck:sever:send:cop:alert', function(coords, veh, plate)
    local msg = "A bank truck is robbed.<br>"..plate
    local alertData = {
        title = "Bank Truck Alarm",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("prp-banktruck:client:send:cop:alert", -1, coords, veh, plate)
    TriggerClientEvent("prp-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('prp-bankrob:server:remove:card')
AddEventHandler('prp-bankrob:server:remove:card', function()
local Player = ProjectRP.Functions.GetPlayer(source)
 Player.Functions.RemoveItem('green-card', 1)
 TriggerClientEvent('prp-inventory:client:ItemBox', source, ProjectRP.Shared.Items['green-card'], "remove")
end)

RegisterServerEvent('prp-kanker:jemoederbakker')
AddEventHandler('prp-kanker:jemoederbakker', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
    local info = {worth = math.random(1500, 2550)}
    Player.Functions.AddItem('markedbills', 1, false, info)
    TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['markedbills'], "add")
    TriggerEvent("prp-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Got: **Marked Bills\n**Where the: **"..info.worth)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        local AmountGoldStuff = math.random(6,8)
        Player.Functions.AddItem('rolex', AmountGoldStuff)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['rolex'], "add")
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        local AmountGoldStuff = math.random(6,8)
        Player.Functions.AddItem('diamond_ring', AmountGoldStuff)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['diamond_ring'], "add")
        TriggerEvent("prp-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Got: **Golden Chain\n**Number: **"..AmountGoldStuff)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        local RandomAmount = math.random(1,2)
        Player.Functions.AddItem('10kgoldchain', RandomAmount)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['10kgoldchain'], "add") 
        TriggerEvent("prp-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Got: **Gold bar\n**Number: **"..RandomAmount)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('bankcard', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['bankcard'], "add") 
        TriggerEvent("prp-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Got: **Yellow card\n**Number:** 1x")
    end
end)

ProjectRP.Functions.CreateUseableItem("green-card", function(source, item)
    TriggerClientEvent("prp-truckrob:client:UseCard", source)
end)