function GetPedVehicleSeat(vehicle, ped)
    if DoesEntityExist(vehicle) then
        local seats = GetVehicleNumberOfPassengers(vehicle)+1

        for seat = -1, seats do
            if GetPedInVehicleSeat(vehicle, seat) == ped then
                return seat
            end
        end
    end

    return false
end

CreateThread(function()
    while true do
        Wait(500)
        if GetPedVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), PlayerPedId()) == -1 then
            SendNUIMessage({driver = true})
        else
            SendNUIMessage({driver = false})
        end
    end
end)

RegisterNetEvent("prp-carmenu:openUI",function()
    local playerVeh = GetVehiclePedIsIn(PlayerPedId())
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(playerVeh))
    local vehHealth = math.floor((GetEntityHealth(playerVeh) / 10))
    local vehPlate = GetVehicleNumberPlateText(playerVeh)

    SetNuiFocus(true,true)
    if GetIsVehicleEngineRunning(playerVeh) then 
        SendNUIMessage({action = "engineOn"})
    else
        SendNUIMessage({action = "engineOff"})
    end

    SendNUIMessage({action = true,vehName = vehName,vehHealth = vehHealth, vehFuel = math.floor(GetVehicleFuelLevel(playerVeh)),vehPlate = vehPlate})
end)

RegisterNUICallback("openDoor", function(data,cb)
    -- local veh = GetVehiclePedIsIn(PlayerPedId())
    -- SetVehicleDoorOpen(veh,data.door,0,0)
	TriggerEvent("prp-mechanic:client:openDoor", data.door)
end)

RegisterNUICallback("closeDoor", function(data,cb)
    -- local veh = GetVehiclePedIsIn(PlayerPedId())
    -- SetVehicleDoorShut(veh,data.door,0,0)
	TriggerEvent("prp-mechanic:client:openDoor", data.door)
end)

RegisterNUICallback("engineOn", function(data,cb)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleEngineOn(veh,true,false,true)
end)

RegisterNUICallback("engineOff", function(data,cb)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleEngineOn(veh,false,false,true)
end)

RegisterNUICallback("changeSeat", function(data,cb)
    -- local veh = GetVehiclePedIsIn(PlayerPedId())
    -- if data.seat == "undefind" then
    --     SetPedIntoVehicle(PlayerPedId(),veh,-1)
    -- end
    -- SetPedIntoVehicle(PlayerPedId(),veh,data.seat)
    if data.seat == "undefind" then
        TriggerEvent("prp-mechanic:seat", -1)
    end
	TriggerEvent("prp-mechanic:seat", data.seat)
end)

RegisterNUICallback("windowDown", function(data,cb)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    RollDownWindow(veh,data.window)
end)

RegisterNUICallback("windowUp", function(data,cb)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    RollUpWindow(veh,data.window)
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false,false)
end)

RegisterCommand('carmenu', function(source)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        TriggerEvent('prp-carmenu:openUI')
    end
end)