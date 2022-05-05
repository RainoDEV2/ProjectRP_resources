CreateThread(function()
    -- functions
    function HasFurniture(source, object)
        local amount = MySQL.Sync.fetchScalar("SELECT `amount` FROM `loaf_furniture` WHERE `identifier`=@identifier AND `object`=@object", {
            ["@identifier"] = GetIdentifier(source),
            ["@object"] = object
        })
        if not amount or amount <= 0 then return false end
        return true, amount
    end

    function RemoveFurniture(source, object)
        local owns, amount = HasFurniture(source, object)
        if not owns then return false end
        if amount == 1 then
            MySQL.Async.execute("DELETE FROM `loaf_furniture` WHERE `object`=@object AND `identifier`=@identifier", {
                ["@identifier"] = GetIdentifier(source),
                ["@object"] = object
            })
        else
            MySQL.Async.execute("UPDATE `loaf_furniture` SET `amount`=@amount WHERE `object`=@object AND `identifier`=@identifier", {
                ["@identifier"] = GetIdentifier(source),
                ["@object"] = object,
                ["@amount"] = amount - 1
            })
        end
        return true
    end

    lib.RegisterCallback("loaf_housing:get_furniture", function(source, cb)
        MySQL.Async.fetchAll("SELECT `object`, `amount` FROM `loaf_furniture` WHERE `identifier`=@identifier", {
            ["@identifier"] = GetIdentifier(source)
        }, function(furniture)
            cb(furniture)
        end)
    end)

    -- furniture store
    lib.RegisterCallback("loaf_housing:purchase_furniture", function(source, cb, category, furniture)
        if not category or not furniture then return cb(false) end
        if not Furniture[category] or not Furniture[category].furniture[furniture] then cb(false) end

        local furnitureData = Furniture[category].furniture[furniture]
        if not PayMoney(source, furnitureData.price) then
            Notify(source, Strings["no_money"])
            return cb(false)
        end
        
        MySQL.Async.fetchScalar("SELECT `amount` FROM `loaf_furniture` WHERE `identifier`=@identifier AND `object`=@object", {
            ["@identifier"] = GetIdentifier(source),
            ["@object"] = furnitureData.object
        }, function(amount)
            if amount then
                MySQL.Sync.execute("UPDATE `loaf_furniture` SET `amount`=`amount`+1 WHERE `identifier`=@identifier AND `object`=@object", {
                    ["@identifier"] = GetIdentifier(source),
                    ["@object"] = furnitureData.object
                })
            else
                MySQL.Sync.execute("INSERT INTO `loaf_furniture` (`identifier`, `object`, `amount`) VALUES(@identifier, @object, 1)", {
                    ["@identifier"] = GetIdentifier(source),
                    ["@object"] = furnitureData.object
                })
            end
            cb(true)
        end)
    end)

    lib.RegisterCallback("loaf_housing:sell_furniture", function(source, cb, object, amount)
        MySQL.Async.fetchScalar("SELECT `amount` FROM `loaf_furniture` WHERE `object`=@object AND `identifier`=@identifier", {
            ["@identifier"] = GetIdentifier(source),
            ["@object"] = object
        }, function(owned)
            if not owned or owned < amount then
                return cb(false)
            end
            local _, _, furnitureData = FindFurniture(object)
            furnitureData = furnitureData or {label = object, price = 0}
            local price = math.floor(amount * furnitureData.price * Config.FurnitureStore.Resell)
            if owned == amount then
                MySQL.Async.execute("DELETE FROM `loaf_furniture` WHERE `object`=@object AND `identifier`=@identifier", {
                    ["@identifier"] = GetIdentifier(source),
                    ["@object"] = object
                }, function()
                    AddMoney(source, price)
                    Notify(source, Strings["sold_furniture"]:format(amount, furnitureData.label, price))
                    cb(true)
                end)
            else
                MySQL.Async.execute("UPDATE `loaf_furniture` SET `amount`=@amount WHERE `object`=@object AND `identifier`=@identifier", {
                    ["@identifier"] = GetIdentifier(source),
                    ["@object"] = object,
                    ["@amount"] = owned - amount
                }, function()
                    AddMoney(source, price)
                    Notify(source, Strings["sold_furniture"]:format(amount, furnitureData.label, price))
                    cb(true)
                end)
            end
        end)
    end)

    -- manage furniture in property
    lib.RegisterCallback("loaf_housing:place_furniture", function(source, cb, instance, object, coords, heading, tilt)
        if not instance or not object or not coords or not heading then return cb(false) end
        if not instances[instance] then return cb(false) end
        if not type(coords) == "vector3" then return cb(false) end
        if not type(heading) == "number" then return cb(false) end

        if not RemoveFurniture(source, object) then return cb(false) end

        local coordsTable = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            h = heading,
            tilt = tilt
        }

        local toInsert = {
            item = object,
            offset = coordsTable
        }
        local _, _, furnitureData = FindFurniture(object)
        if furnitureData and furnitureData.storage then
            toInsert.items = {}
            toInsert.weapons = {}
            toInsert.money = {
                dirty = 0,
                cash = 0
            }
        end

        local instanceData = instances[instance]
        MySQL.Async.fetchScalar("SELECT `furniture` FROM `loaf_properties` WHERE `owner`=@owner AND `propertyid`=@propertyid", {
            ["@owner"] = instanceData.owner,
            ["@propertyid"] = instanceData.property
        }, function(currFurniture)
            if not currFurniture or not json.decode(currFurniture) then 
                currFurniture = {}
            else
                currFurniture = json.decode(currFurniture)
            end

            local id = lib.GenerateUniqueKey(currFurniture)
            currFurniture[id] = toInsert
            instanceData.furniture = currFurniture

            if Config.Inventory ~= "default" then
                RegisterStash(instanceData.property, instanceData.id, id, furnitureData.storageSlots or 50, furnitureData.storageWeight or 25000, instanceData.owner)
            end

            MySQL.Async.execute("UPDATE `loaf_properties` SET `furniture`=@furniture WHERE `owner`=@owner AND `propertyid`=@propertyid", {
                ["@furniture"] = json.encode(currFurniture),
                ["@owner"] = instanceData.owner,
                ["@propertyid"] = instanceData.property
            }, function()
                for _, src in pairs(instanceData.guests) do
                    TriggerClientEvent("loaf_housing:refresh_furniture", src, instanceData.furniture)
                end
                cb(true)
            end)
        end)
    end)

    lib.RegisterCallback("loaf_housing:remove_furniture", function(source, cb, furnitureId)
        local inInstance, instanceId = IsInInstance(source)
        if not inInstance then return cb(false) end
        if not instances[instanceId].furniture[furnitureId] then return cb(false) end

        local object = instances[instanceId].furniture[furnitureId].item
        instances[instanceId].furniture[furnitureId] = nil
        MySQL.Async.execute("UPDATE `loaf_properties` SET `furniture`=@furniture WHERE `owner`=@owner AND `propertyid`=@property", {
            ["@furniture"] = json.encode(instances[instanceId].furniture),
            ["@owner"] = instances[instanceId].owner,
            ["@property"] = instances[instanceId].property
        }, function()
            for _, src in pairs(instances[instanceId].guests) do
                TriggerClientEvent("loaf_housing:refresh_furniture", src, instances[instanceId].furniture)
            end
            Notify(source, Strings["removed_furniture"])

            MySQL.Async.fetchScalar("SELECT `amount` FROM `loaf_furniture` WHERE `identifier`=@identifier AND `object`=@object", {
                ["@identifier"] = GetIdentifier(source),
                ["@object"] = object
            }, function(amount)
                if amount then
                    MySQL.Sync.execute("UPDATE `loaf_furniture` SET `amount`=`amount`+1 WHERE `identifier`=@identifier AND `object`=@object", {
                        ["@identifier"] = GetIdentifier(source),
                        ["@object"] = object
                    })
                else
                    MySQL.Sync.execute("INSERT INTO `loaf_furniture` (`identifier`, `object`, `amount`) VALUES(@identifier, @object, 1)", {
                        ["@identifier"] = GetIdentifier(source),
                        ["@object"] = object
                    })
                end
                cb(true)
            end)
        end)
    end)
end)