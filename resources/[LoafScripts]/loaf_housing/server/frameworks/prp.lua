CreateThread(function()
    if Config.Framework ~= "prp" then return end
    local ProjectRP = exports["prp-core"]:GetCoreObject()

    function CanBreach(source)
        if not Config.PoliceRaid.Enabled then
            return false
        end

        local job = ProjectRP.Functions.GetPlayer(source).PlayerData.job

        for jobName, grade in pairs(Config.PoliceRaid.Jobs) do
            if jobName == job.name and job.grade.level >= grade then
                return true
            end
        end

        return false
    end

    -- lockpick
    lib.RegisterCallback("loaf_housing:get_lockpicks", function(source, cb, remove)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        local lockpick = qPlayer.Functions.GetItemByName("lockpick")
        if remove and lockpick then
            if lockpick.amount > 0 then
                RemoveItem(source, "lockpick", 1)
                lockpick.amount = lockpick.amount - 1
            end
        end
        cb(lockpick?.amount or 0)
    end)

    lib.RegisterCallback("loaf_housing:start_lockpicking", function(source, cb, propertyId, uniqueId)
        if not Config.Lockpicking.Enabled or lockpicking[tostring(source)] then return cb(false) end
        local online = 0
        for _, source in pairs(ProjectRP.Functions.GetPlayers()) do
            local qPlayer = ProjectRP.Functions.GetPlayer(source)
            for _, job in pairs(Config.Lockpicking.Police) do
                if qPlayer.PlayerData.job.name == job then
                    online += 1
                end
            end
        end
        local allowed = online >= Config.Lockpicking.MinimumPolice
        if allowed then
            lockpicking[tostring(source)] = true
            NotifyPolice(Houses[propertyId].entrance.xyz, uniqueId)
        end
        cb(allowed)
    end)

    function NotifyPolice(coords, uniqueId)
        for _, source in pairs(ProjectRP.Functions.GetPlayers()) do
            local qPlayer = ProjectRP.Functions.GetPlayer(source)
            for _, job in pairs(Config.Lockpicking.Police) do
                if qPlayer.PlayerData.job.name == job then
                    TriggerClientEvent("loaf_housing:lockpick_alert", source, coords, uniqueId)
                end
            end
        end
    end

    -- general functions
    function HasMoney(source, amount)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        if not qPlayer then return false end
        if qPlayer.Functions.GetMoney("cash") >= amount then 
            return true, "cash"
        elseif qPlayer.Functions.GetMoney("bank") >= amount then 
            return true, "bank"
        end

        return false
    end

    function AddMoney(source, amount)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        if not qPlayer then return false end
        qPlayer.Functions.AddMoney("cash", amount, "loaf-housing")
        return true
    end

    function PayMoney(source, amount)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        if not qPlayer then return false end

        local hasMoney, account = HasMoney(source, amount)
        if not hasMoney then return false end
        
        qPlayer.Functions.RemoveMoney(account, amount, "loaf-housing")
        return true
    end

    function Notify(source, msg)
        TriggerClientEvent("ProjectRP:Notify", source, msg)
    end

    function GetIdentifier(source)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        if not qPlayer then return false end
        return qPlayer.PlayerData.citizenid
    end

    function SetPlayerCoordinates(identifier, coords)
        Wait(7500)
        local pos = json.encode({
            x = tonumber(string.format("%.2f", coords.x)),
            y = tonumber(string.format("%.2f", coords.y)),
            z = tonumber(string.format("%.2f", coords.z)),
        })
        MySQL.Async.execute("UPDATE `players` SET `position`=@position WHERE `citizenid`=@identifier", {
            ["@position"] = pos,
            ["@identifier"] = identifier
        }, function()
            print(identifier, pos)
            print("set coordinates due to leaving in instance")
        end)
    end

    -- items
    function RemoveItem(source, item, amount)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        local itemData = qPlayer.Functions.GetItemByName(item)
        if not itemData or itemData.amount <= 0 then return false end
        qPlayer.Functions.RemoveItem(item, amount, false)
        return true
    end
end)