ProjectRP.Functions = {}

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = ProjectRP.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

function ProjectRP.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

function ProjectRP.Functions.GetIdentifier(source, idtype)
    local src = source
    local idtype = idtype or PRPConfig.IdentifierType
    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

function ProjectRP.Functions.GetSource(identifier)
    for src, player in pairs(ProjectRP.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

function ProjectRP.Functions.GetPlayer(source)
    local src = source
    if type(src) == 'number' then
        return ProjectRP.Players[src]
    else
        return ProjectRP.Players[ProjectRP.Functions.GetSource(src)]
    end
end

function ProjectRP.Functions.GetPlayerByCitizenId(citizenid)
    for src, player in pairs(ProjectRP.Players) do
        local cid = citizenid
        if ProjectRP.Players[src].PlayerData.citizenid == cid then
            return ProjectRP.Players[src]
        end
    end
    return nil
end

function ProjectRP.Functions.GetPlayerByPhone(number)
    for src, player in pairs(ProjectRP.Players) do
        local cid = citizenid
        if ProjectRP.Players[src].PlayerData.charinfo.phone == number then
            return ProjectRP.Players[src]
        end
    end
    return nil
end

function ProjectRP.Functions.GetPlayers()
    local sources = {}
    for k, v in pairs(ProjectRP.Players) do
        sources[#sources+1] = k
    end
    return sources
end

-- Will return an array of PRP Player class instances
-- unlike the GetPlayers() wrapper which only returns IDs
function ProjectRP.Functions.GetPRPPlayers()
    return ProjectRP.Players
end

--- Gets a list of all on duty players of a specified job and the number
function ProjectRP.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0

    for src, Player in pairs(ProjectRP.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count = count + 1
            end
        end
    end
    return players, count
end

-- Returns only the amount of players on duty for the specified job
function ProjectRP.Functions.GetDutyCount(job)
    local count = 0

    for _, Player in pairs(ProjectRP.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count = count + 1
            end
        end
    end
    return count
end

-- Paychecks (standalone - don't touch)

function PaycheckLoop()
    local Players = ProjectRP.Players
    for i = 1, #Players, 1 do
        local Player = Players[i]
        local payment = Player.PlayerData.job.payment
        if Player.PlayerData.job and Player.PlayerData.job.onduty and payment > 0 then
            Player.Functions.AddMoney('bank', payment)
            TriggerClientEvent('ProjectRP:Notify', Player.PlayerData.source, ('You received your paycheck of $%s'):format(payment))
        end
    end
    SetTimeout(ProjectRP.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckLoop)
end

-- Callbacks

function ProjectRP.Functions.CreateCallback(name, cb)
    ProjectRP.ServerCallbacks[name] = cb
end

function ProjectRP.Functions.TriggerCallback(name, source, cb, ...)
    local src = source
    if ProjectRP.ServerCallbacks[name] then
        ProjectRP.ServerCallbacks[name](src, cb, ...)
    end
end

-- Items

function ProjectRP.Functions.CreateUseableItem(item, cb)
    ProjectRP.UseableItems[item] = cb
end

function ProjectRP.Functions.CanUseItem(item)
    return ProjectRP.UseableItems[item]
end

function ProjectRP.Functions.UseItem(source, item)
    local src = source
    ProjectRP.UseableItems[item.name](src, item)
end

-- Kick Player

function ProjectRP.Functions.Kick(source, reason, setKickReason, deferrals)
    local src = source
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. ProjectRP.Config.Server.discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if src then
            DropPlayer(src, reason)
        end
        local i = 0
        while (i <= 4) do
            i = i + 1
            while true do
                if src then
                    if (GetPlayerPing(src) >= 0) then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(src, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

-- Check if player is whitelisted (not used anywhere)

function ProjectRP.Functions.IsWhitelisted(source)
    local src = source
    local plicense = ProjectRP.Functions.GetIdentifier(src, 'license')
    local identifiers = GetPlayerIdentifiers(src)
    if ProjectRP.Config.Server.whitelist then
        local result = exports.oxmysql:executeSync('SELECT * FROM whitelist WHERE license = ?', { plicense })
        if result[1] then
            for _, id in pairs(identifiers) do
                if result[1].license == id then
                    return true
                end
            end
        end
    else
        return true
    end
    return false
end

-- Setting & Removing Permissions

function ProjectRP.Functions.AddPermission(source, permission)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local plicense = Player.PlayerData.license
    if Player then
        ProjectRP.Config.Server.PermissionList[plicense] = {
            license = plicense,
            permission = permission:lower(),
        }
        exports.oxmysql:execute('DELETE FROM permissions WHERE license = ?', { plicense })

        exports.oxmysql:insert('INSERT INTO permissions (name, license, permission) VALUES (?, ?, ?)', {
            GetPlayerName(src),
            plicense,
            permission:lower()
        })

        Player.Functions.UpdatePlayerData()
        TriggerClientEvent('ProjectRP:Client:OnPermissionUpdate', src, permission)
    end
end

function ProjectRP.Functions.RemovePermission(source)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local license = Player.PlayerData.license
    if Player then
        ProjectRP.Config.Server.PermissionList[license] = nil
        exports.oxmysql:execute('DELETE FROM permissions WHERE license = ?', { license })
        Player.Functions.UpdatePlayerData()
    end
end

-- Checking for Permission Level

function ProjectRP.Functions.HasPermission(source, permission)
    local src = source
    local license = ProjectRP.Functions.GetIdentifier(src, 'license')
    local permission = tostring(permission:lower())
    if permission == 'user' then
        return true
    else
        if ProjectRP.Config.Server.PermissionList[license] then
            if ProjectRP.Config.Server.PermissionList[license].license == license then
                if ProjectRP.Config.Server.PermissionList[license].permission == permission or ProjectRP.Config.Server.PermissionList[license].permission == 'god' then
                    return true
                end
            end
        end
    end
    return false
end

function ProjectRP.Functions.GetPermission(source)
    local src = source
    local license = ProjectRP.Functions.GetIdentifier(src, 'license')
    if license then
        if ProjectRP.Config.Server.PermissionList[license] then
            if ProjectRP.Config.Server.PermissionList[license].license == license then
                return ProjectRP.Config.Server.PermissionList[license].permission
            end
        end
    end
    return 'user'
end

-- Opt in or out of admin reports

function ProjectRP.Functions.IsOptin(source)
    local src = source
    local license = ProjectRP.Functions.GetIdentifier(src, 'license')
    if ProjectRP.Functions.HasPermission(src, 'admin') then
        return ProjectRP.Config.Server.PermissionList[license].optin
    end
end

function ProjectRP.Functions.ToggleOptin(source)
    local src = source
    local license = ProjectRP.Functions.GetIdentifier(src, 'license')
    if ProjectRP.Functions.HasPermission(src, 'admin') then
        ProjectRP.Config.Server.PermissionList[license].optin = not ProjectRP.Config.Server.PermissionList[license].optin
    end
end

-- Check if player is banned

function ProjectRP.Functions.IsPlayerBanned(source)
    local src = source
    local retval = false
    local message = ''
    local plicense = ProjectRP.Functions.GetIdentifier(src, 'license')
    local result = exports.oxmysql:executeSync('SELECT * FROM bans WHERE license = ?', { plicense })
    if result[1] then
        if os.time() < result[1].expire then
            retval = true
            local timeTable = os.date('*t', tonumber(result.expire))
            message = 'You have been banned from the server:\n' .. result[1].reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
        else
            exports.oxmysql:execute('DELETE FROM bans WHERE id = ?', { result[1].id })
        end
    end
    return retval, message
end

-- Check for duplicate license

function ProjectRP.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, id in pairs(identifiers) do
            if string.find(id, 'license') then
                local playerLicense = id
                if playerLicense == license then
                    return true
                end
            end
        end
    end
    return false
end