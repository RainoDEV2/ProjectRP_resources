local ProjectRP = exports['prp-core']:GetCoreObject()

-- Get permissions --

ProjectRP.Functions.CreateCallback('prp-anticheat:server:GetPermissions', function(source, cb)
    local group = ProjectRP.Functions.GetPermission(source)
    cb(group)
end)

-- Execute ban --

RegisterServerEvent('prp-anticheat:server:banPlayer')
AddEventHandler('prp-anticheat:server:banPlayer', function(reason)
    local src = source
    TriggerEvent("prp-log:server:CreateLog", "anticheat", "Anti-Cheat", "white", GetPlayerName(src).." has been banned for "..reason, false)
    exports.oxmysql:insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        ProjectRP.Functions.GetIdentifier(src, 'license'),
        ProjectRP.Functions.GetIdentifier(src, 'discord'),
        ProjectRP.Functions.GetIdentifier(src, 'ip'),
        reason,
        2145913200,
        'Anti-Cheat'
    })
    DropPlayer(src, "You have been banned for cheating. Check our Discord for more information: " .. ProjectRP.Config.Server.discord)
end)

-- Fake events --
function NonRegisteredEventCalled(CalledEvent, source)
    TriggerClientEvent("prp-anticheat:client:NonRegisteredEventCalled", source, "Cheating", CalledEvent)
end


for x, v in pairs(Config.BlacklistedEvents) do
    RegisterServerEvent(v)
    AddEventHandler(v, function(source)
        NonRegisteredEventCalled(v, source)
    end)
end



-- RegisterServerEvent('banking:withdraw')
-- AddEventHandler('banking:withdraw', function(source)
--     NonRegisteredEventCalled('bank:withdraw', source)
-- end)

ProjectRP.Functions.CreateCallback('prp-anticheat:server:HasWeaponInInventory', function(source, cb, WeaponInfo)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local PlayerInventory = Player.PlayerData.items
    local retval = false

    for k, v in pairs(PlayerInventory) do
        if v.name == WeaponInfo["name"] then
            retval = true
        end
    end
    cb(retval)
end)
