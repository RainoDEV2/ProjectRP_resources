ProjectRP.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    TriggerClientEvent('prp-fitbit:use', source)
end)

RegisterServerEvent('prp-fitbit:server:setValue')
AddEventHandler('prp-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = ProjectRP.Functions.GetPlayer(src)
    local fitbitData = {}

    if type == "thirst" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = value,
            food = currentMeta.food
        }
    elseif type == "food" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = currentMeta.thirst,
            food = value
        }
    end

    ply.Functions.SetMetaData('fitbit', fitbitData)
end)

ProjectRP.Functions.CreateCallback('prp-fitbit:server:HasFitbit', function(source, cb)
    local Ply = ProjectRP.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)