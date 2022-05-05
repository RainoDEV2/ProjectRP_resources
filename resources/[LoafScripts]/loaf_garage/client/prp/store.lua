CreateThread(function()
    if Config.Framework ~= "prp" then 
        return 
    end
    
    while not loaded do 
        Wait(500) 
    end

    function StoreVehicle(garage, vehicle)
        if browsing then
            return
        end
        
        if type(vehicle) ~= "number" or not DoesEntityExist(vehicle) then
            vehicle = GetVehiclePedIsUsing(PlayerPedId())
        end
        if not DoesEntityExist(vehicle) then 
            return 
        end

        local props = ProjectRP.Functions.GetVehicleProperties(vehicle)
        props.plate = Entity(vehicle).state.plate or GetVehicleNumberPlateText(vehicle)
        if GetResourceState("LegacyFuel") == "started" then
            props.fuel = exports.LegacyFuel:GetFuel(vehicle)
        end

        lib.TriggerCallback("loaf_garage:store_vehicle", function(stored, reason)
            if stored then
                DeleteEntity(vehicle)
            else
                Notify(Strings[reason])
            end
        end, garage, props, GetDamages(vehicle))
    end
    exports("StoreVehicle", StoreVehicle)
end)