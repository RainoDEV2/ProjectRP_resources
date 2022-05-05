CreateThread(function()
    if not Config.Realtor.enabled then
        return
    end

    Houses = nil

    exports("AddHouse", function(id, data)
        data.id = id
        data.unique = data.unique or (data.unique == nil and data.type == "house" or data.type == "apartment" and false)
        Houses[id] = data
        TriggerClientEvent("loaf_housing:set_houses", -1, Houses)
    end)

    exports("RemoveHouse", function(id)
        MySQL.Async.fetchScalar("SELECT `owner` FROM `loaf_properties` WHERE `propertyid`=@id", {
            ["@id"] = id
        }, function(owner)
            if owner then
                RemoveProperty(owner, id)
            end
        end)

        Houses[id] = nil
        TriggerClientEvent("loaf_housing:set_houses", -1, Houses)
    end)

    exports("SetHouses", function(data)
        for i, v in pairs(data) do
            v.id = i
            v.unique = v.unique or (v.unique == nil and v.type == "house" or v.type == "apartment" and false)
        end

        Houses = data
        TriggerClientEvent("loaf_housing:set_houses", -1, Houses)
    end)

    while GetResourceState("loaf_realtor") ~= "started" do
        Wait(500)
        print("Waiting for loaf_realtor to start")
    end
end)