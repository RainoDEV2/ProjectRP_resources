ProjectRP.Functions.CreateUseableItem("radio", function(source, item)
    TriggerClientEvent('prp-radio:use', source)
end)

ProjectRP.Functions.CreateCallback('prp-radio:server:GetItem', function(source, cb, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player ~= nil then
        local RadioItem = Player.Functions.GetItemByName(item)
        if RadioItem ~= nil and not Player.PlayerData.metadata["isdead"] and
            not Player.PlayerData.metadata["inlaststand"] then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local Player = ProjectRP.Functions.GetPlayer(source)
        return config[Player.PlayerData.job.name] and Player.PlayerData.job.onduty
    end)
end
