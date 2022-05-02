-- Variables
ProjectRP = exports['prp-core']:GetCoreObject()
local SoundScriptName = 'interact-sound'
local SoundPath = '/client/html/sounds'
local Sounds = {}
local IsFrozen = {}
local permissions = { -- What should each permission be able to do
    ['kill'] = 'god',
    ['revive'] = 'god',
    ['freeze'] = 'admin',
    ['spectate'] = 'admin',
    ['goto'] = 'admin',
    ['bring'] = 'admin',
    ['intovehicle'] = 'admin',
    ['kick'] = 'admin',
    ['ban'] = 'god',
    ['setPermissions'] = 'god',
    ['cloth'] = 'admin',
    ['spawnVehicle'] = 'admin',
    ['savecar'] = 'god',
    ['playsound'] = 'admin',
    ['usemenu'] = 'admin',
}
local PermissionOrder = { -- Permission hierarchy order from top to bottom
    'god',
    'admin',
    'user'
}

-- Functions
local function PermOrder(source)
    for i = 1, #PermissionOrder do
        if IsPlayerAceAllowed(source, PermissionOrder[i]) then
            return i
        end
    end
end

-- Events
RegisterNetEvent('prp-admin:server:GetPlayersForBlips', function()
    local src = source
    local players = {}
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local targetped = GetPlayerPed(v)
        local ped = ProjectRP.Functions.GetPlayer(v)
        players[#players+1] = {
            name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | ' .. GetPlayerName(v),
            id = v,
            coords = GetEntityCoords(targetped),
            cid = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
            citizenid = ped.PlayerData.citizenid,
            sources = GetPlayerPed(ped.PlayerData.source),
            sourceplayer = ped.PlayerData.source
        }
    end
    TriggerClientEvent('prp-admin:client:Show', src, players)
end)

RegisterNetEvent('prp-admin:server:kill', function(player)
    local src = source
    local target = player.id

    if not (ProjectRP.Functions.HasPermission(src, permissions['kill'])) then return end
    if PermOrder(src) > PermOrder(target) then return end

    TriggerClientEvent('hospital:client:KillPlayer', target)
end)

RegisterNetEvent('prp-admin:server:revive', function(player)
    local src = source

    if not (ProjectRP.Functions.HasPermission(src, permissions['revive'])) then return end
    
    TriggerClientEvent('hospital:client:Revive', player.id)
end)

RegisterNetEvent('prp-admin:server:freeze', function(player)
    local src = source
    local target = GetPlayerPed(player.id)
    
    if not (ProjectRP.Functions.HasPermission(src, permissions['freeze'])) then return end
    if PermOrder(src) > PermOrder(player.id) then return end
    if IsFrozen[target] == nil then IsFrozen[target] = false end

    if IsFrozen[target] then
        FreezeEntityPosition(target, false)
        IsFrozen[target] = false
    else
        FreezeEntityPosition(target, true)
        IsFrozen[target] = true
    end
end)

RegisterNetEvent('prp-admin:server:spectate', function(player)
    local src = source
    local targetped = GetPlayerPed(player.id)
    local coords = GetEntityCoords(targetped)

    if not (ProjectRP.Functions.HasPermission(src, permissions['spectate'])) then return end
    
    TriggerClientEvent('prp-admin:client:spectate', src, player.id, coords)
end)

RegisterNetEvent('prp-admin:server:goto', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(GetPlayerPed(player.id))
    
    if not (ProjectRP.Functions.HasPermission(src, permissions['goto'])) then return end

    SetEntityCoords(admin, coords)
end)

RegisterNetEvent('prp-admin:server:bring', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(admin)
    local target = GetPlayerPed(player.id)
    
    if not (ProjectRP.Functions.HasPermission(src, permissions['bring'])) then return end
    
    SetEntityCoords(target, coords)
end)

RegisterNetEvent('prp-admin:server:intovehicle', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local targetPed = GetPlayerPed(player.id)
    local vehicle = GetVehiclePedIsIn(targetPed, false)
    local seat = -1
    
    if not (ProjectRP.Functions.HasPermission(src, permissions['intovehicle'])) then return end
    if vehicle == 0 then TriggerClientEvent('ProjectRP:Notify', src, Lang:t("error.player_no_vehicle"), 'error', 4000) return end
    for i = 0, 8, 1 do if GetPedInVehicleSeat(vehicle, i) == 0 then seat = i break end end
    if seat == -1 then TriggerClientEvent('ProjectRP:Notify', src, Lang:t("error.no_free_seats"), 'error', 4000) return end
    
    SetPedIntoVehicle(admin, vehicle, seat)
    TriggerClientEvent('ProjectRP:Notify', src, Lang:t("success.entered_vehicle"), 'success', 5000)
end)

RegisterNetEvent('prp-admin:server:kick', function(player, reason)
    local src = source
    local target = player.id
    
    if not (ProjectRP.Functions.HasPermission(src, permissions['kick'])) then return end
    if PermOrder(src) > PermOrder(target) then return end
    
    TriggerEvent('prp-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(target), GetPlayerName(src), reason), true)
    DropPlayer(target, Lang:t("info.kicked_server") .. ':\n' .. reason .. '\n\n' .. Lang:t("info.check_discord") .. ProjectRP.Config.Server.discord)
end)

RegisterNetEvent('prp-admin:server:ban', function(player, time, reason)
    local src = source
    local target = player.id
    local banTime = tonumber(os.time() + tonumber(time))
    if banTime > 2147483647 then banTime = 2147483647 end
    local timeTable = os.date('*t', banTime)
    
    if not (ProjectRP.Functions.HasPermission(src, permissions['ban'])) then return end
    if PermOrder(src) > PermOrder(target) then return end

    MySQL.Async.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(target),
        ProjectRP.Functions.GetIdentifier(target, 'license'),
        ProjectRP.Functions.GetIdentifier(target, 'discord'),
        ProjectRP.Functions.GetIdentifier(target, 'ip'),
        reason,
        banTime,
        GetPlayerName(src)
    })
    TriggerClientEvent('chat:addMessage', -1, {
        template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
        args = {GetPlayerName(target), reason}
    })
    TriggerEvent('prp-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(target), GetPlayerName(src), reason), true)
    if banTime >= 2147483647 then
        DropPlayer(target, Lang:t("info.banned") .. '\n' .. reason .. Lang:t("info.ban_perm") .. ProjectRP.Config.Server.discord)
    else
        DropPlayer(target, Lang:t("info.banned") .. '\n' .. reason .. Lang:t("info.ban_expires") .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. ProjectRP.Config.Server.discord)
    end
end)

RegisterNetEvent('prp-admin:server:setPermissions', function(targetId, group)
    local src = source

    if not (ProjectRP.Functions.HasPermission(src, permissions['setPermissions'])) then return end
    if PermOrder(src) > PermOrder(targetId) then return end

    ProjectRP.Functions.AddPermission(targetId, group[1].rank)
    TriggerClientEvent('ProjectRP:Notify', targetId, Lang:t("info.rank_level")..group[1].label)
    TriggerClientEvent('ProjectRP:Notify', src, Lang:t("success.changed_perm")..' : '..group[1].label)
end)

RegisterNetEvent('prp-admin:server:cloth', function(player)
    local src = source

    if not (ProjectRP.Functions.HasPermission(src, permissions['cloth'])) then return end

    TriggerClientEvent('prp-clothing:client:openMenu', player.id)
end)

RegisterNetEvent('prp-admin:server:spawnVehicle', function(model)
    local src = source
    local hash = GetHashKey(model)
    local player = GetPlayerPed(src)
    local coords = GetEntityCoords(player)
    local heading = GetEntityHeading(player)
    local vehicle = GetVehiclePedIsIn(player, false)

    if not (ProjectRP.Functions.HasPermission(src, permissions['spawnVehicle'])) then return end
    if vehicle ~= 0 then DeleteEntity(vehicle) end

    local vehicle = CreateVehicle(hash, coords, true, true)
    while not DoesEntityExist(vehicle) do
        Wait(100)
    end
    SetEntityHeading(vehicle, heading)
    TaskWarpPedIntoVehicle(player, vehicle, -1)
    TriggerClientEvent('vehiclekeys:client:SetOwner', src, GetVehicleNumberPlateText(vehicle))
end)

RegisterNetEvent('prp-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    
    if result[1] ~= nil then TriggerClientEvent('ProjectRP:Notify', src, Lang:t("error.failed_vehicle_owner"), 'error', 3000) return end
    if not (ProjectRP.Functions.HasPermission(src, permissions['savecar'])) then return end
    
    MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        vehicle.model,
        vehicle.hash,
        json.encode(mods),
        plate,
        0
    })
    TriggerClientEvent('ProjectRP:Notify', src, Lang:t("success.success_vehicle_owner"), 'success', 5000)
end)

RegisterNetEvent('prp-admin:server:getsounds', function()
    local src = source
    print(Sounds)
    if not (ProjectRP.Functions.HasPermission(src, permissions['playsound'])) then return end
    print(Sounds)
    
    TriggerClientEvent('prp-admin:client:getsounds', src, Sounds)
end)

RegisterNetEvent('prp-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    if ProjectRP.Functions.HasPermission(src, 'admin') then
        if ProjectRP.Functions.IsOptin(src) then
            TriggerClientEvent('chat:addMessage', src, {
                color = {255, 0, 0},
                multiline = true,
                args = {Lang:t("info.admin_report")..name..' ('..targetSrc..')', msg}
            })
        end
    end
end)

AddEventHandler('prp-admin:server:Staffchat:addMessage', function(name, msg)
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        if ProjectRP.Functions.IsOptin(v) then
            TriggerClientEvent('chat:addMessage', v, {
                color = {255, 0, 0},
                multiline = true,
                args = {Lang:t("info.staffchat")..name, msg}
            })
        end
	end
end)

RegisterNetEvent('prp-admin:server:playsound', function(target, soundname, soundvolume, soundradius)
    local src = source

    if not (ProjectRP.Functions.HasPermission(src, permissions['playsound'])) then return end

    TriggerClientEvent('prp-admin:client:playsound', target, soundname, soundvolume, soundradius)
end)

RegisterNetEvent('prp-admin:server:check', function()
    local src = source

    if ProjectRP.Functions.HasPermission(src, permissions['usemenu']) then return end

    DropPlayer(src, Lang:t("info.dropped"))
end)

ProjectRP.Functions.CreateCallback('prp-adminmenu:callback:getdealers', function(source, cb)
    cb(exports['prp-drugs']:GetDealers())
end)

ProjectRP.Functions.CreateCallback('prp-adminmenu:callback:getplayers', function(source, cb)
    if not ProjectRP.Functions.HasPermission(source, permissions['usemenu']) then return end

    local players = {}
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local targetped = GetPlayerPed(v)
        local ped = ProjectRP.Functions.GetPlayer(v)
        players[#players+1] = {
            id = v,
            name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
            food = ped.PlayerData.metadata['hunger'],
            water = ped.PlayerData.metadata['thirst'],
            stress = ped.PlayerData.metadata['stress'],
            armor = ped.PlayerData.metadata['armor'],
            phone = ped.PlayerData.charinfo.phone,
            craftingrep = ped.PlayerData.metadata['craftingrep'],
            dealerrep = ped.PlayerData.metadata['dealerrep'],
            cash = ped.PlayerData.money['cash'],
            bank = ped.PlayerData.money['bank'],
            job = ped.PlayerData.job.label .. ' | ' .. ped.PlayerData.job.grade.level,
            gang = ped.PlayerData.gang.label,
        }
    end
        -- Sort players list by source ID (1,2,3,4,5, etc) --
        table.sort(players, function(a, b)
            return a.id < b.id
        end)
        ------
    cb(players)
end)

CreateThread(function()
    local path = GetResourcePath(SoundScriptName)
    local directory = path:gsub('//', '/')..SoundPath
    for filename in io.popen('dir "'..directory..'" /b'):lines() do
        Sounds[#Sounds + 1] = filename:match("(.+)%..+$")
    end
end)
