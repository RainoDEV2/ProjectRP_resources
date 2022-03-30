ProjectRP.Commands = {}
ProjectRP.Commands.List = {}

-- Register & Refresh Commands

function ProjectRP.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    if type(permission) == 'string' then
        permission = permission:lower()
    else
        permission = 'user'
    end
    ProjectRP.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function ProjectRP.Commands.Refresh(source)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(ProjectRP.Commands.List) do
            local isGod = ProjectRP.Functions.HasPermission(src, 'god')
            local hasPerm = ProjectRP.Functions.HasPermission(src, ProjectRP.Commands.List[command].permission)
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            if isGod or hasPerm or isPrincipal then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            end
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end

-- Teleport

ProjectRP.Commands.Add('tp', 'TP To Player or Coords (Admin Only)', { { name = 'id/x', help = 'ID of player or X position' }, { name = 'y', help = 'Y position' }, { name = 'z', help = 'Z position' } }, false, function(source, args)
    local src = source
    if args[1] and not args[2] and not args[3] then
        local target = GetPlayerPed(tonumber(args[1]))
        if target ~= 0 then
            local coords = GetEntityCoords(target)
            TriggerClientEvent('ProjectRP:Command:TeleportToPlayer', src, coords)
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            if (x ~= 0) and (y ~= 0) and (z ~= 0) then
                TriggerClientEvent('ProjectRP:Command:TeleportToCoords', src, x, y, z)
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'Incorrect Format', 'error')
            end
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Not every argument has been entered (x, y, z)', 'error')
        end
    end
end, 'admin')

ProjectRP.Commands.Add('tpm', 'TP To Marker (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('ProjectRP:Command:GoToMarker', src)
end, 'admin')

-- Permissions

ProjectRP.Commands.Add('addpermission', 'Give Player Permissions (God Only)', { { name = 'id', help = 'ID of player' }, { name = 'permission', help = 'Permission level' } }, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        ProjectRP.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'god')

ProjectRP.Commands.Add('removepermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' } }, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        ProjectRP.Functions.RemovePermission(Player.PlayerData.source)
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'god')

-- Vehicle

ProjectRP.Commands.Add('car', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('ProjectRP:Command:SpawnVehicle', src, args[1])
end, 'admin')

ProjectRP.Commands.Add('dv', 'Delete Vehicle (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('ProjectRP:Command:DeleteVehicle', src)
end, 'admin')

-- Money

ProjectRP.Commands.Add('givemoney', 'Give A Player Money (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'admin')

ProjectRP.Commands.Add('setmoney', 'Set Players Money Amount (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'admin')

-- Job

ProjectRP.Commands.Add('job', 'Check Your Job', {}, false, function(source)
    local src = source
    local PlayerJob = ProjectRP.Functions.GetPlayer(src).PlayerData.job
    TriggerClientEvent('ProjectRP:Notify', src, string.format('[Job]: %s [Grade]: %s [On Duty]: %s', PlayerJob.label, PlayerJob.grade.name, PlayerJob.onduty))
end, 'user')

ProjectRP.Commands.Add('setjob', 'Set A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'admin')

-- Gang

ProjectRP.Commands.Add('gang', 'Check Your Gang', {}, false, function(source)
    local src = source
    local PlayerGang = ProjectRP.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('ProjectRP:Notify', src, string.format('[Gang]: %s [Grade]: %s', PlayerGang.label, PlayerGang.grade.name))
end, 'user')

ProjectRP.Commands.Add('setgang', 'Set A Players Gang (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'gang', help = 'Name of a gang' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'admin')

-- Inventory (should be in prp-inventory?)

ProjectRP.Commands.Add('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local src = source
    local playerId = args[1] or src
    local Player = ProjectRP.Functions.GetPlayer(tonumber(playerId))
    if Player then
        Player.Functions.ClearInventory()
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', 'error')
    end
end, 'admin')

-- Out of Character Chat

ProjectRP.Commands.Add('ooc', 'OOC Chat Message', {}, false, function(source, args)
    local src = source
    local message = table.concat(args, ' ')
    local Players = ProjectRP.Functions.GetPlayers()
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Players) do
        if v == src then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
        elseif #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
        elseif ProjectRP.Functions.HasPermission(v, 'admin') then
            if ProjectRP.Functions.IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = { 0, 0, 255},
                    multiline = true,
                    args = {'Proxmity OOC | '.. GetPlayerName(src), message}
                })
                TriggerEvent('prp-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(src) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')

-- Me command

ProjectRP.Commands.Add('me', 'Show local message', {name = 'message', help = 'Message to respond with'}, false, function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    local pCoords = GetEntityCoords(ped)
    local msg = table.concat(args, ' ')
    if msg == '' then return end
    for k,v in pairs(ProjectRP.Functions.GetPlayers()) do
        local target = GetPlayerPed(v)
        local tCoords = GetEntityCoords(target)
        if #(pCoords - tCoords) < 20 then
            TriggerClientEvent('ProjectRP:Command:ShowMe3D', v, src, msg)
        end
    end
end, 'user')

-- Idle cam toggle commands

ProjectRP.Commands.Add('idlecamoff', 'Disables the idle cam', {}, false, function(source)
    local src = source
    DisableIdleCamera(true)
    SetResourceKvp("idleCam", "off")
    TriggerClientEvent('ProjectRP:Notify', src, 'Idle cam is now off')
end, 'user')

ProjectRP.Commands.Add('idlecamon', 'Re-enables the idle cam', {}, false, function(source)
    local src = source
    DisableIdleCamera(false)
    SetResourceKvp("idleCam", "on")
    TriggerClientEvent('ProjectRP:Notify', src, 'Idle cam is now on')
end, 'user')

-- RegisterCommand('idlecamoff', function() -- help2 31, 167, 9
--     TriggerEvent('chat:addMessage', {
--         color = {227,8,0},
--         multiline = true,
--         args = {'[COMMANDS]', 'Idle Cam Is Now Off'}
--     })
--     DisableIdleCamera(true)
--     SetResourceKvp("idleCam", "off")
-- end)

-- RegisterCommand('idlecamon', function() -- help2 31, 167, 9
--     TriggerEvent('chat:addMessage', {
--         color = {31,167,9},
--         multiline = true,
--         args = {'[COMMANDS]', 'Idle Cam Is Now On'}
--     })
--     DisableIdleCamera(false)
--     SetResourceKvp("idleCam", "on")
-- end)

-- Citizen.CreateThread(function()
--     TriggerEvent("chat:addSuggestion", "/idlecamon", "Re-enables the idle cam")
--     TriggerEvent("chat:addSuggestion", "/idlecamoff", "Disables the idle cam")
    
--     local idleCamDisabled = GetResourceKvpString("idleCam") ~= "on"
--     DisableIdleCamera(idleCamDisabled)
-- end)
