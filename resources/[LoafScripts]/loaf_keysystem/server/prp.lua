CreateThread(function()
    if Config.Framework ~= "prp" then return end
    local ProjectRP = exports["prp-core"]:GetCoreObject()

    function Notify(source, message)
        TriggerClientEvent("ProjectRP:Notify", source, message)
    end

    function GetIdentifier(source)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        if not qPlayer then return false end
        return qPlayer.PlayerData.citizenid
    end

    function GetIngameName(source)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        return qPlayer.PlayerData.charinfo.firstname  .. " " .. qPlayer.PlayerData.charinfo.lastname
    end

    function GetSourceByIdentifier(identifier)
        local qPlayer = ProjectRP.Functions.GetPlayerByCitizenId(identifier)
        if qPlayer then return 
            qPlayer.PlayerData.source
        end
        return false
    end

    loaded = true
end)