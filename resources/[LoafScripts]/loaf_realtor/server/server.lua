lib = exports.loaf_lib:GetLib()

local function BillName(propertyId)
    return "loaf_realtor:" .. propertyId
end

RegisterNetEvent("loaf_realtor:bill_house", function(billed, propertyId)
    local src = source

    local hasJob, isBoss, canCreate = HasJob(src)
    if not hasJob then 
        return
    end

    local propertyData = exports.loaf_housing:GetHouse(propertyId)
    if not propertyData then
        return Notify(src, Strings["invalid_property"])
    end

    if propertyData.unique then
        local owner = MySQL.Sync.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `propertyid`=@id", {["@id"] = propertyId})
        if owner then
            return Notify(Strings["someone_owns"])
        end
    end

    local billedIdentifier = GetIdentifier(billed)
    local billedOwns = MySQL.Sync.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `owner`=@billed AND `propertyid`=@id", {
        ["@billed"] = billedIdentifier,
        ["@id"] = propertyId
    })
    if billedOwns then
        return Notify(Strings["already_owns"])
    end

    exports.loaf_billing:CreateBill(src, function(billId)
        
    end, billed, 60, 0, propertyData.price, BillName(propertyId), Strings["bill_label"]:format(propertyData.label, propertyId), Config.JobName)
end)

RegisterNetEvent("loaf_realtor:transfer_property", function(transferTo, propertyId)
    local src = source

    local hasJob, isBoss, canCreate = HasJob(src)
    if not hasJob then 
        return
    end

    local propertyData = exports.loaf_housing:GetHouse(propertyId)
    if not propertyData then
        return Notify(src, Strings["invalid_property"])
    end

    if propertyData.unique then
        local owner = MySQL.Sync.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `propertyid`=@id", {["@id"] = propertyId})
        if owner then
            return Notify(src, Strings["someone_owns"])
        end
    end

    local transferIdentifier = GetIdentifier(transferTo)
    local transferOwns = MySQL.Sync.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `owner`=@identifier AND `propertyid`=@id", {
        ["@identifier"] = transferIdentifier,
        ["@id"] = propertyId
    })
    if transferOwns then
        return Notify(src, Strings["already_owns"])
    end

    MySQL.Async.fetchScalar("SELECT `id` FROM `loaf_invoices` WHERE `billed`=@identifier AND `name`=@name AND `signed`=1", {
        ["@identifier"] = transferIdentifier,
        ["@name"] = BillName(propertyId)
    }, function(billId)
        if not billId then
            return Notify(src, Strings["not_paid"])
        end
        
        local shellId
        if propertyData.shell then
            local Categories = exports.loaf_housing:GetShells()
            for i, shell in pairs(Categories[propertyData.category].shells) do
                if shell == propertyData.shell then
                    shellId = i
                    break
                end
            end
        end

        exports.loaf_housing:GiveProperty(transferTo, function(received)
            if received then
                Notify(src, Strings["transferred_property"])
                exports.loaf_billing:RemoveBill(billId)
            end
        end, propertyId, "purchase", shellId)
    end)
end)

RegisterNetEvent("loaf_realtor:add_property", function(entrance, garageEntrance, garageExit, interiorType, interior, propertyType, name, price)
    local src = source
    local hasJob, isBoss, canCreate = HasJob(src)

    if not canCreate then
        return
    end

    if not (
        entrance and
        price and
        price > 0 and
        name and
        interiorType and
        interior
    ) then
        return
    end

    if Config.CreatePercent and Config.CreatePercent > 0 then
        local percent = Config.CreatePercent/100
        local toPay = math.floor(price * percent)
        if not RemoveSocietyMoney(toPay) then
            return Notify(src, Strings["company_no_money"])
        end
    end

    MySQL.Async.fetchScalar("SELECT MAX(`id`) FROM `loaf_houses`", {}, function(id)
        local nextId = (id or 0) + 1

        local garage_entrance, garage_exit
        if garageEntrance and garageExit then
            garage_entrance = json.encode({x = garageEntrance.x, y = garageEntrance.y, z = garageEntrance.z})
            garage_exit = json.encode({x = garageExit.x, y = garageExit.y, z = garageExit.z, w = garageExit.w})
        end

        local category
        if interiorType == "shell" then
            category = exports.loaf_housing:GetShell(interior).category
        end
        
        MySQL.Async.execute([[
            INSERT INTO `loaf_houses` 
            (`id`, `label`, `house_apart`, `interior_type`, `interior`, `category`, `entrance`, `price`, `garage_entrance`, `garage_exit`)
            VALUES
            (@id, @name, @propertyType, @interiorType, @interior, @category, @entrance, @price, @garageEntrance, @garageExit)
        ]], {
            ["@id"] = nextId,

            ["@name"] = name,
            ["@propertyType"] = propertyType,
            
            ["@interiorType"] = interiorType,
            ["@interior"] = interior,
            ["@category"] = category,

            ["@entrance"] = json.encode({x = entrance.x, y = entrance.y, z = entrance.z, w = entrance.w}),
            ["@price"] = price,

            ["@garageEntrance"] = garage_entrance,
            ["@garageExit"] = garage_exit,
            
        }, function(added)
            if added == 1 then
                local garage
                if garageEntrance and garageExit then
                    garage = {
                        entrance = garageEntrance,
                        exit = garageExit
                    }
                end

                exports.loaf_housing:AddHouse(nextId, {
                    label = name,
                    price = price,
                    entrance = entrance,
                    type = propertyType,

                    category = category,
                    interior = interior,
                    interiortype = interiorType,

                    shell = interiorType == "shell" and interior,
                    
                    garage = garage
                })
            end
        end)
    end)
end)

RegisterNetEvent("loaf_realtor:remove_property", function(propertyId)
    local src = source
    local hasJob, isBoss, canCreate = HasJob(src)

    if not canCreate or not propertyId then
        return
    end

    MySQL.Async.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `propertyid`=@id", {
        ["@id"] = propertyId
    }, function(owner)
        if owner and not Config.AllowRemoveOwned then
            return Notify(src, Strings["someone_owns"])
        end

        MySQL.Async.execute("DELETE FROM `loaf_houses` WHERE `id`=@id", {
            ["@id"] = propertyId
        }, function(res)
            if res ~= 1 then
                return Notify(src, Strings["invalid_property"])
            end
            exports.loaf_housing:RemoveHouse(propertyId)
            Notify(src, Strings["removed_property"]:format(propertyId))
        end)
    end)
end)

local function SetHouses()
    MySQL.Async.fetchAll("SELECT * FROM `loaf_houses`", {}, function(res)
        local houses = {}
        for _, v in pairs(res) do
            local entrance = json.decode(v.entrance)
            entrance = vector4(entrance.x, entrance.y, entrance.z, entrance.w)

            local garage
            if v.garage_entrance and v.garage_exit then
                local garageEntrance, garageExit = json.decode(v.garage_entrance), json.decode(v.garage_exit)
                garage = {
                    entrance = vector3(garageEntrance.x, garageEntrance.y, garageEntrance.z),
                    exit = vector4(garageExit.x, garageExit.y, garageExit.z, garageExit.w)
                }
            end

            houses[v.id] = {
                label = v.label,
                price = v.price,
                type = v.house_apart,

                entrance = entrance,

                interiortype = v.interior_type,
                interior = v.interior,
                shell = v.interior_type == "shell" and v.interior,
                category = v.category,
                
                garage = garage
            }
        end

        exports.loaf_housing:SetHouses(houses)
    end)
end

exports("FetchHouses", SetHouses)
MySQL.ready(SetHouses)

--- VERSION CHECK ---
CreateThread(function()
    PerformHttpRequest("https://loaf-scripts.com/versions/", function(err, text, headers) 
        print(text or "^3[WARNING]^0 Error checking script version, the website did not respond. (This is not an error on your end)")
    end, "POST", json.encode({
        resource = "realtor",
        version = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or "2.0.0"
    }), {["Content-Type"] = "application/json"})
end)