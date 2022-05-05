CreateThread(function()
    if Config.Framework ~= "esx" then return end
    
    TriggerEvent("esx:getSharedObject", function(ESX)
        function CanBreach(source)
            if not Config.PoliceRaid.Enabled then
                return false
            end

            local job = ESX.GetPlayerFromId(source).job

            for jobName, grade in pairs(Config.PoliceRaid.Jobs) do
                if jobName == job.name and job.grade >= grade then
                    return true
                end
            end

            return false
        end

        -- STORAGE
        lib.RegisterCallback("loaf_housing:get_inventory", function(src, cb)
            local xPlayer = ESX.GetPlayerFromId(src)
            cb(xPlayer.getMoney(), xPlayer.getAccount("black_money").money, xPlayer.inventory, xPlayer.getLoadout())
        end)

        -- lockpick
        lib.RegisterCallback("loaf_housing:get_lockpicks", function(source, cb, remove)
            local xPlayer = ESX.GetPlayerFromId(source)
            local lockpick = xPlayer.getInventoryItem("lockpick")
            if remove then
                if lockpick.count > 0 then
                    xPlayer.removeInventoryItem("lockpick", 1)
                    lockpick.count = lockpick.count - 1
                end
            end
            cb(lockpick.count)
        end)

        lib.RegisterCallback("loaf_housing:start_lockpicking", function(source, cb, propertyId, uniqueId)
            if not Config.Lockpicking.Enabled or lockpicking[tostring(source)] then return cb(false) end
            local online = 0
            for _, source in pairs(ESX.GetPlayers()) do
                for _, job in pairs(Config.Lockpicking.Police) do
                    if ESX.GetPlayerFromId(source).getJob().name == job then
                        online = online + 1
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
            for _, source in pairs(ESX.GetPlayers()) do
                for _, job in pairs(Config.Lockpicking.Police) do
                    if ESX.GetPlayerFromId(source).getJob().name == job then
                        TriggerClientEvent("loaf_housing:lockpick_alert", source, coords, uniqueId)
                    end
                end
            end
        end

        -- items
        function RemoveItem(source, item, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            local itemData = xPlayer.getInventoryItem(item)
            if not itemData or itemData.count < amount then return false end
            xPlayer.removeInventoryItem(item, amount)
            return true, (itemData.label or item)
        end
        function GiveItem(source, item, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer.canCarryItem(item, amount) then return false end
            xPlayer.addInventoryItem(item, amount)
            return true
        end
        -- cash
        function RemoveCash(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.getMoney() < amount then return false end
            xPlayer.removeMoney(amount)
            return true
        end
        function GiveCash(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.addMoney(amount)
            return true
        end
        -- dirty money
        function RemoveDirty(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.getAccount("black_money").money < amount then return false end
            xPlayer.removeAccountMoney("black_money", amount)
            return true
        end
        function GiveDirty(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.addAccountMoney("black_money", amount)
            return true
        end
        -- weapons
        function GetWeaponData(source, weapon)
            local xPlayer = ESX.GetPlayerFromId(source)
            local _, weapon = xPlayer.getWeapon(weapon)
            return weapon
        end
        function RemoveWeapon(source, weapon)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.removeWeapon(weapon)
            return true
        end
        function GiveWeapon(source, weapondata)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.addWeapon(weapondata.weapon, weapondata.ammo)
            if xPlayer.setWeaponTint then 
                xPlayer.setWeaponTint(weapondata.weapon, weapondata.tint)
            end
            for k, v in pairs(weapondata.components) do
                xPlayer.addWeaponComponent(weapondata.weapon, v)
            end
            return true
        end

        -- general functions
        function HasMoney(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then return false end
            if xPlayer.getMoney() >= amount then 
                return true, "cash"
            elseif xPlayer.getAccount("bank").money >= amount then 
                return true, "bank"
            end

            return false
        end

        function AddMoney(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then return false end
            xPlayer.addMoney(amount)
            return true
        end

        function PayMoney(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then return false end
            local hasMoney, account = HasMoney(source, amount)
            if not hasMoney then return false end
            if account == "cash" then
                xPlayer.removeMoney(amount)
                return true
            elseif account == "bank" then
                xPlayer.removeAccountMoney("bank", amount)
                return true
            end
            return false
        end

        function Notify(source, msg)
            TriggerClientEvent("esx:showNotification", source, msg)
        end

        function GetIdentifier(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then return false end
            return xPlayer.identifier
        end

        function SetPlayerCoordinates(identifier, coords)
            Wait(7500)
            local pos = json.encode({
                x = tonumber(string.format("%.2f", coords.x)),
                y = tonumber(string.format("%.2f", coords.y)),
                z = tonumber(string.format("%.2f", coords.z)),
                heading = tonumber(string.format("%.2f", coords.w))
            })
            MySQL.Async.execute("UPDATE `users` SET `position`=@position WHERE `identifier`=@identifier", {
                ["@position"] = pos,
                ["@identifier"] = identifier
            }, function()
                print("set coordinates due to leaving in instance")
            end)
        end

        -- wardrobe
        lib.RegisterCallback("loaf_housing:get_outfits", function(source, cb)
            if GetResourceState("fivem-appearance") == "started" then
                MySQL.Async.fetchAll("SELECT `id`, `name` FROM `outfits` WHERE `identifier`=@identifier", {
                    ["@identifier"] = GetIdentifier(source)
                }, function(result)
                    local outfits = {}

                    for k, v in pairs(result) do
                        outfits[v.id] = v.name
                    end

                    cb(outfits)
                end)
            else
                TriggerEvent("esx_datastore:getDataStore", "property", GetIdentifier(source), function(store)
                    local labels = {}

                    for i = 1, store.count("dressing") do
                        table.insert(labels, store.get("dressing", i).label)
                    end

                    cb(labels)
                end)
            end
        end)

        lib.RegisterCallback("loaf_housing:get_outfit", function(source, cb, id)
            if GetResourceState("fivem-appearance") == "started" then
                MySQL.Async.fetchAll("SELECT `ped`, `components`, `props` FROM `outfits` WHERE `id`=@id", {
                    ["@id"] = id
                }, function(result)
                    cb(result and result[1] and {
                        ped = json.decode(result[1].ped),
                        components = json.decode(result[1].components),
                        props = json.decode(result[1].props)
                    })
                end)
            else
                TriggerEvent("esx_datastore:getDataStore", "property", GetIdentifier(source), function(store)
                    local outfit = store.get("dressing", id)
                    if outfit then
                        cb(outfit.skin)
                    else
                        cb(false)
                    end
                end)
            end
        end)

        lib.RegisterCallback("loaf_housing:delete_outfit", function(source, cb, id)
            local identifier = GetIdentifier(source)
            if not identifier then return cb({}) end

            if GetResourceState("fivem-appearance") == "started" then
                MySQL.Async.execute("DELETE FROM `outfits` WHERE `id`=@id AND `identifier`=@identifier", {
                    ["@id"] = id,
                    ["@identifier"] = identifier
                }, function()
                    MySQL.Async.fetchAll("SELECT `id`, `name` FROM `outfits` WHERE `identifier`=@identifier", {
                        ["@identifier"] = identifier
                    }, function(result)
                        local outfits = {}
    
                        for k, v in pairs(result) do
                            outfits[v.id] = v.name
                        end
    
                        cb(outfits)
                    end)
                end)
            else
                TriggerEvent("esx_datastore:getDataStore", "property", identifier, function(store)
                    local outfits = store.get("dressing") or {}

                    if outfits[id] then
                        table.remove(outfits, id)
                        store.set("dressing", outfits)
                    end

                    local labels = {}
                    for i = 1, store.count("dressing") do
                        table.insert(labels, store.get("dressing", i).label)
                    end
                    cb(labels)
                end)
            end
        end)
    end)
end)