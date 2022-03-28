-- Variables
local ProjectRP = exports['prp-core']:GetCoreObject()
local frozen = false
local permissions = {
    ['kill'] = 'god',
    ['ban'] = 'admin',
    ['noclip'] = 'admin',
    ['kickall'] = 'admin',
    ['kick'] = 'admin'
}

-- Get Dealers
ProjectRP.Functions.CreateCallback('test:getdealers', function(source, cb)
    cb(exports['prp-drugs']:GetDealers())
end)

-- Get Players
ProjectRP.Functions.CreateCallback('test:getplayers', function(source, cb) -- WORKS
    local players = {}
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local targetped = GetPlayerPed(v)
        local ped = ProjectRP.Functions.GetPlayer(v)
        players[#players+1] = {
            name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
            id = v,
            coords = GetEntityCoords(targetped),
            cid = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
            citizenid = ped.PlayerData.citizenid,
            sources = GetPlayerPed(ped.PlayerData.source),
            sourceplayer= ped.PlayerData.source

        }
    end
        -- Sort players list by source ID (1,2,3,4,5, etc) --
        table.sort(players, function(a, b)
            return a.id < b.id
        end)
        ------
    cb(players)
end)

ProjectRP.Functions.CreateCallback('prp-admin:server:getrank', function(source, cb)
    local src = source
    if ProjectRP.Functions.HasPermission(src, 'god') or IsPlayerAceAllowed(src, 'command') then
        cb(true)
    else
        cb(false)
    end
end)

-- Functions

local function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
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
            sourceplayer= ped.PlayerData.source
        }
    end
    TriggerClientEvent('prp-admin:client:Show', src, players)
end)

RegisterNetEvent('prp-admin:server:kill', function(player)
    TriggerClientEvent('hospital:client:KillPlayer', player.id)
end)

RegisterNetEvent('prp-admin:server:revive', function(player)
    TriggerClientEvent('hospital:client:Revive', player.id)
end)

RegisterNetEvent('prp-admin:server:kick', function(player, reason)
    local src = source
    if ProjectRP.Functions.HasPermission(src, permissions['kick']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerEvent('prp-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
        DropPlayer(player.id, 'You have been kicked from the server:\n' .. reason .. '\n\n🔸 Check our Discord for more information: ' .. ProjectRP.Config.Server.discord)
    end
end)

RegisterNetEvent('prp-admin:server:ban', function(player, time, reason)
    local src = source
    if ProjectRP.Functions.HasPermission(src, permissions['ban']) or IsPlayerAceAllowed(src, 'command') then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date('*t', banTime)
        exports.oxmysql:insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            GetPlayerName(player.id),
            ProjectRP.Functions.GetIdentifier(player.id, 'license'),
            ProjectRP.Functions.GetIdentifier(player.id, 'discord'),
            ProjectRP.Functions.GetIdentifier(player.id, 'ip'),
            reason,
            banTime,
            GetPlayerName(src)
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
            args = {GetPlayerName(player.id), reason}
        })
        TriggerEvent('prp-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
        if banTime >= 2147483647 then
            DropPlayer(player.id, 'You have been banned:\n' .. reason .. '\n\nYour ban is permanent.\n🔸 Check our Discord for more information: ' .. ProjectRP.Config.Server.discord)
        else
            DropPlayer(player.id, 'You have been banned:\n' .. reason .. '\n\nBan expires: ' .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. ProjectRP.Config.Server.discord)
        end
    end
end)

RegisterNetEvent('prp-admin:server:spectate')
AddEventHandler('prp-admin:server:spectate', function(player)
    local src = source
    local targetped = GetPlayerPed(player.id)
    local coords = GetEntityCoords(targetped)
    TriggerClientEvent('prp-admin:client:spectate', src, player.id, coords)
end)

RegisterNetEvent('prp-admin:server:freeze')
AddEventHandler('prp-admin:server:freeze', function(player)
    local target = GetPlayerPed(player.id)
    if not frozen then
        frozen = true
        FreezeEntityPosition(target, true)
    else
        frozen = false
        FreezeEntityPosition(target, false)
    end
end)

RegisterNetEvent('prp-admin:server:goto', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(GetPlayerPed(player.id))
    SetEntityCoords(admin, coords)
end)

RegisterNetEvent('prp-admin:server:intovehicle', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    -- local coords = GetEntityCoords(GetPlayerPed(player.id))
    local targetPed = GetPlayerPed(player.id)
    local vehicle = GetVehiclePedIsIn(targetPed,false)
    local seat = -1
    if vehicle ~= 0 then
        for i=0,8,1 do
            if GetPedInVehicleSeat(vehicle,i) == 0 then
                seat = i
                break
            end
        end
        if seat ~= -1 then
            SetPedIntoVehicle(admin,vehicle,seat)
            TriggerClientEvent('ProjectRP:Notify', src, 'Entered vehicle', 'success', 5000)
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'The vehicle has no free seats!', 'danger', 5000)
        end
    end
end)


RegisterNetEvent('prp-admin:server:bring', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(admin)
    local target = GetPlayerPed(player.id)
    SetEntityCoords(target, coords)
end)

RegisterNetEvent('prp-admin:server:inventory', function(player)
    local src = source
    TriggerClientEvent('prp-admin:client:inventory', src, player.id)
end)

RegisterNetEvent('prp-admin:server:cloth', function(player)
    TriggerClientEvent('prp-clothing:client:openMenu', player.id)
end)

RegisterNetEvent('prp-admin:server:setPermissions', function(targetId, group)
    local src = source
    if ProjectRP.Functions.HasPermission(src, 'god') or IsPlayerAceAllowed(src, 'command') then
        ProjectRP.Functions.AddPermission(targetId, group[1].rank)
        TriggerClientEvent('ProjectRP:Notify', targetId, 'Your Permission Level Is Now '..group[1].label)
    end
end)

RegisterNetEvent('prp-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    if ProjectRP.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        if ProjectRP.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterNetEvent('prp-admin:server:Staffchat:addMessage', function(name, msg)
    local src = source
    if ProjectRP.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        if ProjectRP.Functions.IsOptin(src) then
            TriggerClientEvent('chat:addMessage', src, 'STAFFCHAT - '..name, 'error', msg)
        end
    end
end)

RegisterNetEvent('prp-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local result = exports.oxmysql:executeSync('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result[1] == nil then
        exports.oxmysql:insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            vehicle.model,
            vehicle.hash,
            json.encode(mods),
            plate,
            0
        })
        TriggerClientEvent('ProjectRP:Notify', src, 'The vehicle is now yours!', 'success', 5000)
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'This vehicle is already yours..', 'error', 3000)
    end
end)

-- Commands

ProjectRP.Commands.Add('blips', 'Show blips for players (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('prp-admin:client:toggleBlips', src)
end, 'admin')

ProjectRP.Commands.Add('names', 'Show player name overhead (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('prp-admin:client:toggleNames', src)
end, 'admin')

ProjectRP.Commands.Add('coords', 'Enable coord display for development stuff (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('prp-admin:client:ToggleCoords', src)
end, 'admin')

ProjectRP.Commands.Add('noclip', 'Toggle noclip (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('prp-admin:client:ToggleNoClip', src)
end, 'admin')

ProjectRP.Commands.Add('admincar', 'Save Vehicle To Your Garage (Admin Only)', {}, false, function(source, args)
    local ply = ProjectRP.Functions.GetPlayer(source)
    TriggerClientEvent('prp-admin:client:SaveCar', source)
end, 'admin')

ProjectRP.Commands.Add('announce', 'Make An Announcement (Admin Only)', {}, false, function(source, args)
    local msg = table.concat(args, ' ')
    if msg == '' then return end
    TriggerClientEvent('chatMessage', -1, "Staff Announcement:", "error", msg)
end, 'admin')

ProjectRP.Commands.Add('admin', 'Open Admin Menu (Admin Only)', {}, false, function(source, args)
    TriggerClientEvent('prp-admin:client:openMenu', source)
end, 'admin')

ProjectRP.Commands.Add('report', 'Admin Report', {{name='message', help='Message'}}, true, function(source, args)
    local src = source
    local msg = table.concat(args, ' ')
    local Player = ProjectRP.Functions.GetPlayer(source)
    TriggerClientEvent('prp-admin:client:SendReport', -1, GetPlayerName(src), src, msg)
    TriggerEvent('prp-log:server:CreateLog', 'report', 'Report', 'green', '**'..GetPlayerName(source)..'** (CitizenID: '..Player.PlayerData.citizenid..' | ID: '..source..') **Report:** ' ..msg, false)
end)

ProjectRP.Commands.Add('staffchat', 'Send A Message To All Staff (Admin Only)', {{name='message', help='Message'}}, true, function(source, args)
    local msg = table.concat(args, ' ')
    TriggerClientEvent('prp-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, 'admin')

ProjectRP.Commands.Add('givenuifocus', 'Give A Player NUI Focus (Admin Only)', {{name='id', help='Player id'}, {name='focus', help='Set focus on/off'}, {name='mouse', help='Set mouse on/off'}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]
    TriggerClientEvent('prp-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, 'admin')



ProjectRP.Commands.Add("warn", "Warn a player", {{name="ID", help="Player"}, {name="Reason", help="Mention a reason"}}, true, function(source, args)
    local targetPlayer = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = ProjectRP.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "WARN-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "You have been warned by: "..GetPlayerName(source)..", Reason: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You have warned "..GetPlayerName(targetPlayer.PlayerData.source).." for: "..msg)
        exports.oxmysql:insert('INSERT INTO player_warns (senderIdentifier, targetIdentifier, reason, warnId) VALUES (?, ?, ?, ?)', {
            senderPlayer.PlayerData.license,
            targetPlayer.PlayerData.license,
            msg,
            warnId
        })
    else
        TriggerClientEvent('ProjectRP:Notify', source, 'This player is not online', 'error')
    end 
end, "admin")


ProjectRP.Commands.Add('checkwarns', 'Check Player Warnings (Admin Only)', {{name='id', help='Player'}, {name='Warning', help='Number of warning, (1, 2 or 3 etc..)'}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
        local result = exports.oxmysql:executeSync('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
        TriggerClientEvent('chat:addMessage', source, 'SYSTEM', 'warning', targetPlayer.PlayerData.name..' has '..tablelength(result)..' warnings!')
    else
        local targetPlayer = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
        local warnings = exports.oxmysql:executeSync('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
        local selectedWarning = tonumber(args[2])
        if warnings[selectedWarning] ~= nil then
            local sender = ProjectRP.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)
            TriggerClientEvent('chat:addMessage', source, 'SYSTEM', 'warning', targetPlayer.PlayerData.name..' has been warned by '..sender.PlayerData.name..', Reason: '..warnings[selectedWarning].reason)
        end
    end
end, 'admin')

ProjectRP.Commands.Add('delwarn', 'Delete Players Warnings (Admin Only)', {{name='id', help='Player'}, {name='Warning', help='Number of warning, (1, 2 or 3 etc..)'}}, true, function(source, args)
    local targetPlayer = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    local warnings = exports.oxmysql:executeSync('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
    local selectedWarning = tonumber(args[2])
    if warnings[selectedWarning] ~= nil then
        local sender = ProjectRP.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)
        TriggerClientEvent('chat:addMessage', source, 'SYSTEM', 'warning', 'You have deleted warning ('..selectedWarning..') , Reason: '..warnings[selectedWarning].reason)
        exports.oxmysql:execute('DELETE FROM player_warns WHERE warnId = ?', { warnings[selectedWarning].warnId })
    end
end, 'admin')

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

ProjectRP.Commands.Add('reportr', 'Reply To A Report (Admin Only)', {{name='id', help='Player'}, {name = 'message', help = 'Message to respond with'}}, false, function(source, args, rawCommand)
    local src = source
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, ' ')
    local OtherPlayer = ProjectRP.Functions.GetPlayer(playerId)
    if msg == '' then return end
    if not OtherPlayer then return TriggerClientEvent('ProjectRP:Notify', src, 'Player is not online', 'error') end
    if not ProjectRP.Functions.HasPermission(src, 'admin') then return end
    TriggerClientEvent('chat:addMessage', playerId, {
        color = {255, 0, 0},
        multiline = true,
        args = {'Admin Response', msg}
    })
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 0, 0},
        multiline = true,
        args = {'Report Response ('..playerId..')', msg}
    })
    TriggerClientEvent('ProjectRP:Notify', src, 'Reply Sent')
    TriggerEvent('prp-log:server:CreateLog', 'report', 'Report Reply', 'red', '**'..GetPlayerName(src)..'** replied on: **'..OtherPlayer.PlayerData.name.. ' **(ID: '..OtherPlayer.PlayerData.source..') **Message:** ' ..msg, false)
end, 'admin')

ProjectRP.Commands.Add('setmodel', 'Change Ped Model (Admin Only)', {{name='model', help='Name of the model'}, {name='id', help='Id of the Player (empty for yourself)'}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])
    if model ~= nil or model ~= '' then
        if target == nil then
            TriggerClientEvent('prp-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = ProjectRP.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('prp-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('ProjectRP:Notify', source, 'This person is not online..', 'error')
            end
        end
    else
        TriggerClientEvent('ProjectRP:Notify', source, 'You did not set a model..', 'error')
    end
end, 'admin')

ProjectRP.Commands.Add('setspeed', 'Set Player Foot Speed (Admin Only)', {}, false, function(source, args)
    local speed = args[1]
    if speed ~= nil then
        TriggerClientEvent('prp-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('ProjectRP:Notify', source, 'You did not set a speed.. (`fast` for super-run, `normal` for normal)', 'error')
    end
end, 'admin')

ProjectRP.Commands.Add('reporttoggle', 'Toggle Incoming Reports (Admin Only)', {}, false, function(source, args)
    local src = source
    ProjectRP.Functions.ToggleOptin(src)
    if ProjectRP.Functions.IsOptin(src) then
        TriggerClientEvent('ProjectRP:Notify', src, 'You are receiving reports', 'success')
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'You are not receiving reports', 'error')
    end
end, 'admin')

ProjectRP.Commands.Add('kickall', 'Kick all players', {}, false, function(source, args)
    local src = source
    if src > 0 then
        local reason = table.concat(args, ' ')
        if ProjectRP.Functions.HasPermission(src, 'god') or IsPlayerAceAllowed(src, 'command') then
            if not reason then
                for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
                    local Player = ProjectRP.Functions.GetPlayer(v)
                    if Player then
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'No reason specified', 'error')
            end
        end
    else
        for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
            local Player = ProjectRP.Functions.GetPlayer(v)
            if Player then
                DropPlayer(Player.PlayerData.source, 'Server restart, check our Discord for more information: ' .. ProjectRP.Config.Server.discord)
            end
        end
    end
end, 'god')

ProjectRP.Commands.Add('setammo', 'Set Your Ammo Amount (Admin Only)', {{name='amount', help='Amount of bullets, for example: 20'}, {name='weapon', help='Name of the weapen, for example: WEAPON_VINTAGEPISTOL'}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])

    if weapon ~= nil then
        TriggerClientEvent('prp-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        TriggerClientEvent('prp-weapons:client:SetWeaponAmmoManual', src, 'current', amount)
    end
end, 'admin')
