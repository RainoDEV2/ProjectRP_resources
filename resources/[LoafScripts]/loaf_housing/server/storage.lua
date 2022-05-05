CreateThread(function()
    local function GetHouseFurniture(propertyId, uniqueId)
        local instance = GetInstance(propertyId, uniqueId)
        if instance then
            return instances[instance].furniture
        else
            return json.decode(MySQL.Sync.fetchScalar("SELECT `furniture` FROM `loaf_properties` WHERE `propertyid`=@propertyId AND `id`=@uniqueId", {
                ["@propertyId"] = propertyId,
                ["@uniqueId"] = uniqueId
            }))
        end
    end

    local function SetStorage(propertyId, uniqueId, furnitureId, storage)
        local instance = GetInstance(propertyId, uniqueId)
        local furniture = GetHouseFurniture(propertyId, uniqueId)
        
        if instance then
            instances[instance].furniture[furnitureId] = storage
            furniture = instances[instance].furniture
            for _, src in pairs(instances[instance].guests) do
                TriggerClientEvent("loaf_housing:refresh_furniture", src, furniture)
            end
        end

        furniture[furnitureId] = storage
        MySQL.Sync.execute("UPDATE `loaf_properties` SET `furniture`=@furniture WHERE `propertyid`=@propertyId AND `id`=@uniqueId", {
            ["@furniture"] = json.encode(furniture),
            ["@propertyId"] = propertyId,
            ["@uniqueId"] = uniqueId
        })
    end

    lib.RegisterCallback("loaf_housing:get_storage", function(source, cb, propertyId, uniqueId, furnitureId)
        local currentFurniture = GetHouseFurniture(propertyId, uniqueId)

        if not currentFurniture or not currentFurniture[furnitureId] or not currentFurniture[furnitureId].items then
            return cb({})
        end
        cb(currentFurniture[furnitureId])
    end)

    -- items
    lib.RegisterCallback("loaf_housing:deposit_item", function(source, cb, propertyId, uniqueId, furnitureId, item, amount)
        local currentStorage = GetHouseFurniture(propertyId, uniqueId)
        if not currentStorage or not currentStorage[furnitureId] or not currentStorage[furnitureId].items or amount <= 0 then
            return cb(false)
        end
        currentStorage = currentStorage[furnitureId]

        local removed, label = RemoveItem(source, item, amount)
        if not removed then
            return cb(false)
        end

        local inStorage
        for i, v in ipairs(currentStorage.items) do
            if v.item == item then
                inStorage = true
                v.amount = v.amount + amount
                v.label = label
            end
        end
        if not inStorage then 
            table.insert(currentStorage.items, {
                label = label,
                item = item,
                amount = amount
            })
        end

        SetStorage(propertyId, uniqueId, furnitureId, currentStorage)
        Notify(source, Strings["deposited_item"]:format(amount, label))
        cb(GetHouseFurniture(propertyId, uniqueId))

        lib.Log({
            webhook = Webhooks.Storage,
            source = source,
            category = "Housing",
            type = "success",
            title = "Storage",
            text = Strings["LOG_deposit"]:format(amount, label)
        })
    end)
    
    lib.RegisterCallback("loaf_housing:withdraw_item", function(source, cb, propertyId, uniqueId, furnitureId, item, amount)
        local currentStorage = GetHouseFurniture(propertyId, uniqueId)
        if not currentStorage or not currentStorage[furnitureId] or not currentStorage[furnitureId].items or amount <= 0 then
            return cb(false)
        end
        currentStorage = currentStorage[furnitureId]

        local inStorage, label
        for i, v in pairs(currentStorage.items) do
            if v.item == item then
                inStorage = i
                label = v.label
                break
            end
        end
        if not inStorage then
            return cb(false)
        end

        local data = currentStorage.items[inStorage]
        if data.amount < amount then
            return cb(false)
        end

        if not GiveItem(source, item, amount) then 
            Notify(source, Strings["cant_carry"])
            return cb(false) 
        end

        data.amount = data.amount - amount
        if data.amount == 0 then
            table.remove(currentStorage.items, inStorage)
        end

        SetStorage(propertyId, uniqueId, furnitureId, currentStorage)
        Notify(source, Strings["withdrew_item"]:format(amount, label))
        cb(GetHouseFurniture(propertyId, uniqueId))

        lib.Log({
            webhook = Webhooks.Storage,
            source = source,
            category = "Housing",
            type = "error",
            title = "Storage",
            text = Strings["LOG_withdrew"]:format(amount, label)
        })
    end)

    -- weapons
    lib.RegisterCallback("loaf_housing:deposit_weapon", function(source, cb, propertyId, uniqueId, furnitureId, weapon)
        local currentStorage = GetHouseFurniture(propertyId, uniqueId)
        if not currentStorage or not currentStorage[furnitureId] or not currentStorage[furnitureId].weapons then
            return cb(false)
        end
        currentStorage = currentStorage[furnitureId]

        local weaponData = GetWeaponData(source, weapon)
        if not weaponData then
            Notify(source, Strings["dont_have_weapon"])
            return cb(false) 
        end
        
        if not RemoveWeapon(source, weaponData.name) then 
            Notify(source, Strings["dont_have_weapon"])
            return cb(false)
        end
        local weaponId = lib.GenerateUniqueKey(currentStorage.weapons)
        currentStorage.weapons[weaponId] = {
            ammo = weaponData.ammo,
            weapon = weaponData.name,
            label = weaponData.label,
            components = weaponData.components,
            tint = weaponData.tintIndex
        }

        SetStorage(propertyId, uniqueId, furnitureId, currentStorage)
        Notify(source, Strings["deposited_weapon"]:format(weaponData.label))
        cb(GetHouseFurniture(propertyId, uniqueId))

        lib.Log({
            webhook = Webhooks.Storage,
            source = source,
            category = "Housing",
            type = "success",
            title = "Storage",
            text = Strings["LOG_deposit"]:format(1, weaponData.label)
        })
    end)

    lib.RegisterCallback("loaf_housing:withdraw_weapon", function(source, cb, propertyId, uniqueId, furnitureId, weaponId)
        local currentStorage = GetHouseFurniture(propertyId, uniqueId)
        if not currentStorage or not currentStorage[furnitureId] or not currentStorage[furnitureId].weapons or not currentStorage[furnitureId].weapons[weaponId] then
            return cb(false)
        end
        currentStorage = currentStorage[furnitureId]

        local weaponData = currentStorage.weapons[weaponId]
        GiveWeapon(source, weaponData)
        currentStorage.weapons[weaponId] = nil

        SetStorage(propertyId, uniqueId, furnitureId, currentStorage)
        Notify(source, Strings["withdrew_weapon"]:format(weaponData.label))
        cb(GetHouseFurniture(propertyId, uniqueId))

        lib.Log({
            webhook = Webhooks.Storage,
            source = source,
            category = "Housing",
            type = "error",
            title = "Storage",
            text = Strings["LOG_withdrew"]:format(1, weaponData.label)
        })
    end)

    -- money
    lib.RegisterCallback("loaf_housing:deposit_money", function(source, cb, propertyId, uniqueId, furnitureId, moneyType, amount)
        local currentStorage = GetHouseFurniture(propertyId, uniqueId)
        if not currentStorage or not currentStorage[furnitureId] or not currentStorage[furnitureId].items or amount <= 0 then
            return cb(false)
        end
        currentStorage = currentStorage[furnitureId]

        if moneyType == "cash" then
            if not RemoveCash(source, amount) then
                Notify(source, Strings["dont_have"])
                return cb(false)
            end
        elseif moneyType == "dirty" then
            if not RemoveDirty(source, amount) then
                Notify(source, Strings["dont_have"])
                return cb(false)
            end
        end
        currentStorage.money[moneyType] = currentStorage.money[moneyType] + amount

        SetStorage(propertyId, uniqueId, furnitureId, currentStorage)
        Notify(source, Strings["deposited_money"]:format(amount))
        cb(GetHouseFurniture(propertyId, uniqueId))

        lib.Log({
            webhook = Webhooks.Storage,
            source = source,
            category = "Housing",
            type = "success",
            title = "Storage",
            text = Strings["LOG_deposit"]:format(amount, moneyType)
        })
    end)

    lib.RegisterCallback("loaf_housing:withdraw_money", function(source, cb, propertyId, uniqueId, furnitureId, moneyType, amount)
        local currentStorage = GetHouseFurniture(propertyId, uniqueId)
        if not currentStorage or not currentStorage[furnitureId] or not currentStorage[furnitureId].items or amount <= 0 then
            return cb(false)
        end
        currentStorage = currentStorage[furnitureId]

        if currentStorage.money[moneyType] < amount then
            Notify(source, Strings["storage_not_enough"])
            return cb(false)
        end

        if moneyType == "cash" then
            GiveCash(source, amount)
        elseif moneyType == "dirty" then
            GiveDirty(source, amount)
        end

        currentStorage.money[moneyType] = currentStorage.money[moneyType] - amount

        SetStorage(propertyId, uniqueId, furnitureId, currentStorage)
        Notify(source, Strings["withdrew_money"]:format(amount))
        cb(GetHouseFurniture(propertyId, uniqueId))

        lib.Log({
            webhook = Webhooks.Storage,
            source = source,
            category = "Housing",
            type = "error",
            title = "Storage",
            text = Strings["LOG_withdrew"]:format(amount, moneyType)
        })
    end)
end)