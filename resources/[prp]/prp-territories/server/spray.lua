local ProjectRP = exports['prp-core']:GetCoreObject()

SPRAYS = {
}

FastBlacklist = {}

ProjectRP.Functions.CreateUseableItem("spray", function(source, item)
	local src = source
    TriggerEvent('rcore_spray:startSpraying', src)
end)

Citizen.CreateThread(function()
    if Config.Blacklist then
        for _, word in pairs(Config.Blacklist) do
            FastBlacklist[word] = word
        end
    end
end)

function GetSprayAtCoords(pos)
    for _, spray in pairs(SPRAYS) do
        if spray.location == pos then
            return spray
        end
    end
end

RegisterNetEvent('rcore_spray:addSpray')
AddEventHandler('rcore_spray:addSpray', function(spray)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName("spray")
    local Gang = Player.PlayerData.gang
    spray.gang = Gang.name

    if item.amount > 0 then
        Player.Functions.RemoveItem('spray', 1)
        local i = 1
        while true do
            if not SPRAYS[i] then
                SPRAYS[i] = spray
                break
            else
                i = i + 1
            end
        end

        PersistSpray(spray)
        TriggerEvent('rcore_sprays:addSpray', src, spray.text, spray.location)
        TriggerClientEvent('rcore_spray:setSprays', -1, SPRAYS)
    else
        ProjectRP.Functions.Notify(Config.Text.NEED_SPRAY, 'error')
    end
end)

function PersistSpray(spray)
    MySQL.Async.execute([[
        INSERT sprays
        (`x`, `y`, `z`, `rx`, `ry`, `rz`, `scale`, `text`, `font`, `color`, `interior`, `gang`)
        VALUES
        (@x, @y, @z, @rx, @ry, @rz, @scale, @text, @font, @color, @interior, @gang)
    ]], {
        ['@x'] = spray.location.x,
        ['@y'] = spray.location.y,
        ['@z'] = spray.location.z,
        ['@rx'] = spray.realRotation.x,
        ['@ry'] = spray.realRotation.y,
        ['@rz'] = spray.realRotation.z,
        ['@scale'] = spray.scale,
        ['@text'] = spray.text,
        ['@font'] = spray.font,
        ['@color'] = spray.originalColor,
        ['@interior'] = spray.interior,
        ['@gang'] = spray.gang,
    })
end

Citizen.CreateThread(function()
    -- Remove sprays after being there for configured time
    -- MySQL.Sync.execute([[
    --     DELETE FROM sprays 
    --     WHERE DATEDIFF(NOW(), created_at) >= @days
    -- ]], {['days'] = Config.SPRAY_PERSIST_DAYS})

    local results = MySQL.Sync.fetchAll([[
        SELECT x, y, z, rx, ry, rz, scale, text, font, color, created_at, interior, gang
        FROM sprays
    ]])

    for _, s in pairs(results) do
        table.insert(SPRAYS, {
            location = vector3(s.x + 0.0, s.y + 0.0, s.z + 0.0),
            realRotation = vector3(s.rx + 0.0, s.ry + 0.0, s.rz + 0.0),
            scale = tonumber(s.scale) + 0.0,
            text = s.text,
            font = s.font,
            originalColor = s.color,
            interior = (s.interior == 1) and true or false,
            gang = s.gang
        })
    end

    TriggerClientEvent('rcore_spray:setSprays', -1, SPRAYS)
end)

RegisterNetEvent('rcore_spray:playerSpawned')
AddEventHandler('rcore_spray:playerSpawned', function()
    local src = source
    TriggerClientEvent('rcore_spray:setSprays', src, SPRAYS)
end)

RegisterNetEvent('rcore_spray:startSpraying')
AddEventHandler('rcore_spray:startSpraying', function(source)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName("spray")

    if item.amount > 0 then
        local gang = Player.PlayerData.gang
        local sprayText = ''
        if gang ~= nil and ProjectRP.Shared.Gangs[gang.name] then
            sprayText = ProjectRP.Shared.Gangs[gang.name].spray
        end

        if FastBlacklist[sprayText] then
            ProjectRP.Functions.Notify(Config.Text.BLACKLISTED, 'error')
        else
            if sprayText then
                if sprayText:len() <= 9 then
                    if sprayText:len() == 0 then
                        TriggerClientEvent('ProjectRP:Notify', src, Config.Text.NO_GANG, 'error')
                    else
                        TriggerClientEvent('rcore_spray:spray', source, sprayText)
                    end
                else
                    TriggerClientEvent('ProjectRP:Notify', src, Config.Text.WORD_LONG, 'error')
                end
            else
                TriggerClientEvent('ProjectRP:Notify', src, Config.Text.USAGE, 'error')
            end
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, Config.Text.NEED_SPRAY, 'error')
    end
end, false)

function HasSpray(serverId, cb)
	local Player = ProjectRP.Functions.GetPlayer(serverId)
    local item = Player.Functions.GetItemByName("spray")

    cb(item.amount > 0)
end