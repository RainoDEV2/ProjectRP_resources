lockpicking = {}
CreateThread(function()
    for i, v in pairs(Houses) do
        v.id = i
        v.unique = v.unique or (v.unique == nil and v.type == "house" or v.type == "apartment" and false)
    end

    lib.RegisterCallback("loaf_housing:fetch_houses_cfg", function(source, cb)
        while not Houses do
            Wait(500)
        end
        cb(Houses)
    end)

    function GeneratePropertyId(propertyId)
        local found, uniqueId = false
        while not found do
            uniqueId = ("%s%s-%i%i%i%i"):format(
                string.char(math.random(65, 90)), 
                string.char(math.random(65, 90)),
                math.random(0, 9),
                math.random(0, 9),
                math.random(0, 9),
                math.random(0, 9)
            )
            found = uniqueId ~= MySQL.Sync.fetchScalar("SELECT `id` FROM `loaf_properties` WHERE `propertyid`=@propertyid AND `id`=@id", {
                ["@propertyid"] = propertyId,
                ["@id"] = uniqueId
            })

            Wait(50)
        end

        return uniqueId
    end

    function GenerateWallet()
        local found, wallet = false
        while not found do
            wallet = lib.GenerateString(50)
            found = wallet ~= MySQL.Sync.fetchScalar("SELECT `rent_wallet` FROM `loaf_rent` WHERE `rent_wallet`=@wallet", {["@wallet"] = wallet})
            Wait(50)
        end
        return wallet
    end

    -- KEYS
    function GetKeyName(propertyId, uniqueId)
        return ("housing_key_%i_%s"):format(propertyId, uniqueId)
    end

    function GiveKey(source, propertyId, uniqueId)
        exports.loaf_keysystem:GenerateKey(
            source, 
            GetKeyName(propertyId, uniqueId), 
            Strings["key_label"]:format(Houses[propertyId].label, propertyId, uniqueId), 
            "server", 
            "loaf_housing:used_key"
        )
    end

    RegisterNetEvent("loaf_housing:copy_keys", function(propertyId)
        local src = source
        local owns, index = DoesPlayerOwnProperty(src, propertyId)
        if not owns then return end
        GiveKey(src, propertyId, boughtHouses[index].id)
        Notify(src, Strings["copied_keys"])
    end)

    RegisterNetEvent("loaf_housing:change_lock", function(propertyId)
        local src = source
        local owns, index = DoesPlayerOwnProperty(src, propertyId)
        if not owns then return end
        exports.loaf_keysystem:RemoveAllKeys(GetKeyName(propertyId, boughtHouses[index].id))
        Notify(src, Strings["changed_lock"])
    end)

    -- instance
    local doorKnocks = {}
    RegisterNetEvent("loaf_housing:knock_door", function(propertyId, uniqueId)
        local src = source
        local propertyData = GetPropertyData(propertyId, uniqueId)
        if not propertyData then return end

        local instance = GetInstance(propertyId, uniqueId)
        if not instance then
            return Notify(src, Strings["noone_home"])
        end
        
        for _, guest in pairs(instances[instance].guests) do
            Notify(guest, Strings["someone_knocking"])
        end

        local knockId = propertyId .. "-" .. uniqueId
        if not doorKnocks[knockId] then
            doorKnocks[knockId] = {}
        end
        doorKnocks[knockId][tostring(src)] = true
    end)

    RegisterNetEvent("loaf_housing:cancel_knock", function(propertyId, uniqueId)
        local src = source
        local knockId = propertyId .. "-" .. uniqueId
        if not doorKnocks[knockId] then
            return
        end

        doorKnocks[knockId][tostring(src)] = nil
    end)

    RegisterNetEvent("loaf_housing:handle_knock", function(propertyId, uniqueId, player, accepted)
        local src = source
        local knockId = propertyId .. "-" .. uniqueId
        local inInstance, instanceId = IsInInstance(src)

        if not doorKnocks[knockId] or not inInstance or GetInstance(propertyId, uniqueId) ~= instanceId or not doorKnocks[knockId][tostring(player)] then
            return
        end

        doorKnocks[knockId][tostring(player)] = nil
        if not accepted then
            return
        end

        if not IsInInstance(player) then
            EnterInstance(player, instanceId)
        end
    end)

    lib.RegisterCallback("loaf_housing:get_knocking", function(source, cb, propertyId, uniqueId)
        cb(doorKnocks[propertyId .. "-" .. uniqueId] or {})
    end)

    RegisterNetEvent("loaf_housing:breach_door", function(propertyId, uniqueId)
        local src = source
        print(propertyId, uniqueId)
        if IsInInstance(src) or not CanBreach(src) then 
            return 
        end

        local instance = GetInstance(propertyId, uniqueId)
        if not instance then
            instance = CreateInstance(src, propertyId, uniqueId)
        end
        EnterInstance(src, instance)
    end)

    lib.RegisterCallback("loaf_housing:enter_property", function(source, cb, propertyId, uniqueId)
        if IsInInstance(source) then return cb(false, "in_instance") end
    
        local owns, i = DoesPlayerOwnProperty(source, propertyId)
        if 
            (owns and boughtHouses[i].id == uniqueId) 
            or 
            (not IsDoorLocked(propertyId, uniqueId) or exports.loaf_keysystem:HasKey(source, GetKeyName(propertyId, uniqueId))) 
        then
            -- check mlo etc
            local propertyData = GetPropertyData(propertyId, uniqueId)
            if not propertyData then return cb(false, "no_property") end
    
            local housedata = Houses[propertyId]
            
            if housedata.interiortype == "shell" or housedata.interiortype == "interior" then
                local instanceid = GetInstance(propertyId, uniqueId)
                if instanceid then
                    EnterInstance(source, instanceid)
                    cb(true)
                    return
                end
                
                local instance = CreateInstance(source, propertyId, uniqueId)
                if instance then
                    EnterInstance(source, instance)
                    cb(true)
                else
                    cb(false, "no_spawn")
                end
            elseif housedata.interiortype == "walkin" then
                cb(true)
            end
        else
            cb(false, "no_access")
        end
    end)

    RegisterNetEvent("loaf_housing:exit_property", function(instanceid)
        local src = source
        if not instanceid or not instances[instanceid] then 
            return 
        end
        ExitInstance(src, instanceid)
    end)

    RegisterNetEvent("loaf_housing:used_key", function(data)
        local src = source
        if not exports.loaf_keysystem:HasKey(src, data.key_id) then return end
        local key = data.key_id:gsub("housing_key_", "")
        local propertyidString, uniqueId = string.gmatch(key, "(.+)_(.+)")()
        local propertyid = tonumber(propertyidString)

        local propertyData, houseApart = Houses[propertyid], (Houses[propertyid].type == "house" and "house" or "apart")
        if propertyData.interiortype == "walkin" then
            -- find the closest door
            local playerCoords, closestDoor, dist = GetEntityCoords(GetPlayerPed(src)), 1, 99999999999999999
            for i, v in pairs(propertyData.doors) do
                if #(playerCoords - v.coords.xyz) < dist then
                    closestDoor = i
                    dist = #(playerCoords - v.coords.xyz)
                end
            end
            if Config.Key.DistanceCheck and dist > Config.Key.Distance then
                return Notify(src, Strings["not_nearby"])
            end
            GlobalState["loaf_housing_"..propertyidString.."_"..closestDoor] = not GlobalState["loaf_housing_"..propertyidString.."_"..closestDoor]
            Notify(src, Strings[not GlobalState["loaf_housing_"..propertyidString.."_"..closestDoor] and "locked_"..houseApart or "unlocked_"..houseApart])
        else
            if Config.Key.DistanceCheck and #(GetEntityCoords(GetPlayerPed(src)) - propertyData.entrance.xyz) > Config.Key.Distance then
                local inInstance, instance = IsInInstance(src)
                if not inInstance or instances[instance].property ~= propertyid then
                    return Notify(src, Strings["not_nearby"])
                end
            end
            SetDoorLocked(propertyid, uniqueId, not IsDoorLocked(propertyid, uniqueId))
            Notify(src, Strings[IsDoorLocked(propertyid, uniqueId) and "locked_"..houseApart or "unlocked_"..houseApart])
        end
    end)

    -- purchase / sell / transfer property
    function GiveProperty(source, cb, propertyId, purchaseOrRent, shellId)
        local housedata = Houses[propertyId]

        local shell
        if housedata.interiortype == "shell" then
            if Categories[housedata.category].shells[shellId] then
                shell = Categories[housedata.category].shells[shellId]
            else
                shell = Categories[housedata.category].shells[math.random(1, #Categories[housedata.category].shells)]
            end
        elseif housedata.interiortype == "interior" then
            shell = housedata.interior
        elseif housedata.interiortype == "walkin" then
            shell = "no shell set"
        end
        local uniqueId = GeneratePropertyId(propertyId)

        local wallet
        if purchaseOrRent == "rent" then
            wallet = GenerateWallet()
            MySQL.Async.execute("INSERT INTO `loaf_rent` (`rent_wallet`, `owner`, `propertyid`, `balance`, `rent_due`) VALUES(@wallet, @identifier, @property, 0, @rent_due)", {
                ["@wallet"] = wallet,
                ["@identifier"] = GetIdentifier(source),
                ["@rent_due"] = os.time() + Config.RentInterval,
                ["@property"] = propertyId
            })
        end

        local furniture = {}
        local locations = {}
        if housedata.interiortype == "interior" then
            locations = Config.Interiors[housedata.interior].locations
        elseif housedata.locations then
            locations = housedata.locations
            for k, v in pairs(locations) do
                if v.storage and Config.Inventory ~= "default" then
                    RegisterStash(propertyId, uniqueId, k, 50, 25000, GetIdentifier(source))
                end
            end
        end

        for k, v in pairs(locations) do
            furniture[k] = {
                item = "NOT_AN_ITEM",
                offset = {
                    x = v.coords.x,
                    y = v.coords.y,
                    z = v.coords.z,
                    h = 0.0
                }
            }

            if v.storage then
                furniture[k].items = {}
                furniture[k].weapons = {}
                furniture[k].money = {
                    cash = 0,
                    dirty = 0
                }

                if v.weight then
                    furniture[k].storageWeight = v.weight
                end
                if v.slots then
                    furniture[k].storageSlots = v.slots
                end
            end
        end

        MySQL.Async.execute("INSERT INTO `loaf_properties` (`owner`, `propertyid`, `shell`, `furniture`, `id`, `rent`) VALUES(@owner, @propertyid, @shell, @furniture, @id, @wallet)", {
            ["@owner"] = GetIdentifier(source),
            ["@propertyid"] = propertyId,
            ["@shell"] = shell,
            ["@furniture"] = json.encode(furniture),
            ["@id"] = uniqueId,
            ["@wallet"] = wallet
        }, function()
            table.insert(boughtHouses, {
                owner = GetIdentifier(source),
                propertyid = propertyId,
                id = uniqueId,
                rent = wallet
            })
            GiveKey(source, propertyId, uniqueId)
            TriggerClientEvent("loaf_housing:update_houses", -1, boughtHouses)
            cb(true, uniqueId)

            lib.Log({
                webhook = Webhooks.BuySell,
                category = "Housing",
                type = "success",
                title = "Purchase",
                source = source,
                text = Strings["LOG_purchase"]:format(propertyId, purchaseOrRent == "rent" and housedata.rent or housedata.price)
            })
        end)
    end
    exports("GiveProperty", GiveProperty)

    lib.RegisterCallback("loaf_housing:purchase_property", function(source, cb, propertyId, purchaseOrRent, shellId)
        if not type(propertyId) == "number" or not Houses[propertyId] then 
            return cb(false, "not_config") 
        end
        if GetAmountProperties(source) >= Config.MaxProperties then 
            return cb(false, "max_properties") 
        end

        -- check if the player already owns the property
        if MySQL.Sync.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `owner`=@identifier AND `propertyid`=@propertyid", {
            ["@identifier"] = GetIdentifier(source),
            ["@propertyid"] = propertyId
        }) then
            return cb(false, "already_owns")
        end

        local housedata = Houses[propertyId]
        -- check if someone owns the property
        if housedata.unique and MySQL.Sync.fetchScalar("SELECT `propertyid` FROM `loaf_properties` WHERE `propertyid`=@propertyid", {
            ["@propertyid"] = propertyId
        }) then
            return cb(false, "someone_owns")
        end

        if purchaseOrRent == "rent" then
            if not housedata.rent then
                return cb(false, "not_rentable")
            end
            if not PayMoney(source, housedata.rent) then
                return cb(false, "no_money")
            end
        else
            if not housedata.price then 
                return cb(false, "not_purchasable") 
            end
            if not PayMoney(source, housedata.price) then
                return cb(false, "no_money")
            end
        end

        GiveProperty(source, cb, propertyId, purchaseOrRent, shellId)
    end)

    lib.RegisterCallback("loaf_housing:sell_property", function(source, cb, propertyId)
        local owns, i = DoesPlayerOwnProperty(source, propertyId)
        if not owns then return cb(false, "dont_own") end
        
        local price = math.floor((Houses[propertyId] and Houses[propertyId].price or 0) * Config.PropertyResell or 1)
        RemoveProperty(GetIdentifier(source), propertyId, function(sold)
            if not sold then return cb(false) end
            AddMoney(source, price)
            cb(true)

            lib.Log({
                webhook = Webhooks.BuySell,
                category = "Housing",
                type = "error",
                title = "Sell",
                source = source,
                text = Strings["LOG_sell"]:format(propertyId, price)
            })
        end)
    end)

    lib.RegisterCallback("loaf_housing:transfer_property", function(source, cb, propertyId, transferTo)
        local owns, i = DoesPlayerOwnProperty(source, propertyId)
        if not owns then return cb(false, "dont_own") end
        
        if not GetIdentifier(transferTo) then return cb(false, "not_online") end

        local otherOwns = DoesPlayerOwnProperty(transferTo, propertyId)
        if otherOwns then return cb(false, "other_owns") end

        boughtHouses[i].owner = GetIdentifier(transferTo)

        MySQL.Async.execute("UPDATE `loaf_properties` SET `owner`=@newOwner WHERE `owner`=@oldOwner AND `propertyid`=@propertyid", {
            ["@newOwner"] = GetIdentifier(transferTo),
            ["@oldOwner"] = GetIdentifier(source),
            ["@propertyid"] = propertyId
        })
        MySQL.Async.execute("UPDATE `loaf_rent` SET `owner`=@newOwner WHERE `owner`=@oldOwner AND `propertyid`=@propertyid", {
            ["@newOwner"] = GetIdentifier(transferTo),
            ["@oldOwner"] = GetIdentifier(source),
            ["@propertyid"] = propertyId
        })

        exports.loaf_keysystem:RemoveAllKeys(GetKeyName(propertyId, boughtHouses[i].id))
        GiveKey(transferTo, propertyId, boughtHouses[i].id)
        TriggerClientEvent("loaf_housing:update_houses", -1, boughtHouses)

        cb(true)
    end)

    if Config.Lockpicking.Enabled then
        RegisterNetEvent("loaf_housing:cancel_lockpick", function()
            lockpicking[tostring(source)] = nil
        end)

        RegisterNetEvent("loaf_housing:lockpicked", function(propertyId, uniqueId)
            local src = source
            if not lockpicking[tostring(src)] then return cb(false) end

            local exists
            for _, v in pairs(boughtHouses) do
                if v.propertyid == propertyId and v.id == uniqueId then
                    exists = true
                    break
                end
            end
            if not exists then return end

            Notify(src, Strings["lockpicked"])
            SetDoorLocked(propertyId, uniqueId, false)
            lockpicking[tostring(src)] = nil
        end)
    end
end)