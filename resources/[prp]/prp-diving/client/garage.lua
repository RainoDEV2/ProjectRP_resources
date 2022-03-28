local CurrentDock = nil
local ClosestDock = nil
local PoliceBlip = nil

-- Functions

function TakeOutDepotBoat(vehicle)
    ProjectRP.Functions.SpawnVehicle(vehicle.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicle.plate)
        SetEntityHeading(veh, PRPBoatshop.Depots[CurrentDock].coords.put.w)
        exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
        ProjectRP.Functions.Notify("Vehicle Off: Fuel: "..currentFuel.. "%", "primary", 4500)
        CloseMenu()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, PRPBoatshop.Depots[CurrentDock].coords.put, true)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == 1 then
        ProjectRP.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, PRPBoatshop.Docks[CurrentDock].coords.put.w)
            exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
            ProjectRP.Functions.Notify("vehicle Out: Fuel: "..currentFuel.. "%", "primary", 4500)
            CloseMenu()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
            TriggerServerEvent('prp-diving:server:SetBoatState', ProjectRP.Functions.GetPlate(veh), 0, CurrentDock, 100)
        end, PRPBoatshop.Docks[CurrentDock].coords.put, true)
    else
        ProjectRP.Functions.Notify("The boat is not in the boathouse", "error", 4500)
    end
end

function MenuBoatDepot()
    ClearMenu()
    ProjectRP.Functions.TriggerCallback("prp-diving:server:GetDepotBoats", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            ProjectRP.Functions.Notify("You have no vehicles in this Depot", "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(PRPBoatshop.Depots[CurrentDock].label, "yeet", PRPBoatshop.Depots[CurrentDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "In Boathouse"

                if v.state == 0 then
                    state = "In Depot"
                end

                Menu.addButton(PRPBoatshop.ShopBoats[v.model]["label"], "TakeOutDepotBoat", v, state, "Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage", nil)
    end)
end

function VehicleList()
    ClearMenu()
    ProjectRP.Functions.TriggerCallback("prp-diving:server:GetMyBoats", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            ProjectRP.Functions.Notify("You have no vehicles in this Boathouse", "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(PRPBoatshop.Docks[CurrentDock].label, "yeet", PRPBoatshop.Docks[CurrentDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                if v.state == 0 then
                    state = "In Depot"
                elseif v.state == 1 then
                    state = "In Boathouse"
                end

                Menu.addButton(PRPBoatshop.ShopBoats[v.model]["label"], "TakeOutVehicle", v, state, "Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage", nil)
    end, CurrentDock)
end

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil)
end

function CloseMenu()
    Menu.hidden = true
    CurrentDock = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

local function RemoveVehicle()
    local ped = PlayerPedId()
    local Boat = IsPedInAnyBoat(ped)

    if Boat then
        local CurVeh = GetVehiclePedIsIn(ped)
        local totalFuel = exports['prp-fuel']:GetFuel(CurVeh)
        TriggerServerEvent('prp-diving:server:SetBoatState', ProjectRP.Functions.GetPlate(CurVeh), 1, ClosestDock, totalFuel)

        ProjectRP.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, PRPBoatshop.Docks[ClosestDock].coords.take.x, PRPBoatshop.Docks[ClosestDock].coords.take.y, PRPBoatshop.Docks[ClosestDock].coords.take.z)
    end
end

-- Events

RegisterNetEvent('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == "police" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(PRPBoatshop.PoliceBoat.x, PRPBoatshop.PoliceBoat.y, PRPBoatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police Boats")
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(3)
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == "police" then
                local dist = #(pos - vector3(PRPBoatshop.PoliceBoat.x, PRPBoatshop.PoliceBoat.y, PRPBoatshop.PoliceBoat.z))
                if dist < 10 then
                    DrawMarker(2, PRPBoatshop.PoliceBoat.x, PRPBoatshop.PoliceBoat.y, PRPBoatshop.PoliceBoat.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(PRPBoatshop.PoliceBoat.x, PRPBoatshop.PoliceBoat.y, PRPBoatshop.PoliceBoat.z)) < 1.5 then
                        ProjectRP.Functions.DrawText3D(PRPBoatshop.PoliceBoat.x, PRPBoatshop.PoliceBoat.y, PRPBoatshop.PoliceBoat.z, "~g~E~w~ - Take Boat")
                        if IsControlJustReleased(0, 38) then
                            local coords = PRPBoatshop.PoliceBoatSpawn
                            ProjectRP.Functions.SpawnVehicle("predator", function(veh)
                                SetVehicleNumberPlateText(veh, "PBOA"..tostring(math.random(1000, 9999)))
                                SetEntityHeading(veh, coords.w)
                                exports['prp-fuel']:SetFuel(veh, 100.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, coords, true)
                        end
                    end
                else
                    Wait(1000)
                end
            else
                Wait(3000)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(3)
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == "police" then
                local dist = #(pos - vector3(PRPBoatshop.PoliceBoat2.x, PRPBoatshop.PoliceBoat2.y, PRPBoatshop.PoliceBoat2.z))
                if dist < 10 then
                    DrawMarker(2, PRPBoatshop.PoliceBoat2.x, PRPBoatshop.PoliceBoat2.y, PRPBoatshop.PoliceBoat2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(PRPBoatshop.PoliceBoat2.x, PRPBoatshop.PoliceBoat2.y, PRPBoatshop.PoliceBoat2.z)) < 1.5 then
                        ProjectRP.Functions.DrawText3D(PRPBoatshop.PoliceBoat2.x, PRPBoatshop.PoliceBoat2.y, PRPBoatshop.PoliceBoat2.z, "~g~E~w~ - Take Boat")
                        if IsControlJustReleased(0, 38) then
                            local coords = PRPBoatshop.PoliceBoatSpawn2
                            ProjectRP.Functions.SpawnVehicle("predator", function(veh)
                                SetVehicleNumberPlateText(veh, "PBOA"..tostring(math.random(1000, 9999)))
                                SetEntityHeading(veh, coords.w)
                                exports['prp-fuel']:SetFuel(veh, 100.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, coords, true)
                        end
                    end
                else
                    Wait(1000)
                end
            else
                Wait(3000)
            end
        end
    end
end)

CreateThread(function()
    while true do

        local inRange = false
        local Ped = PlayerPedId()
        local Pos = GetEntityCoords(Ped)

        for k, v in pairs(PRPBoatshop.Docks) do
            local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

            if TakeDistance < 50 then
                ClosestDock = k
                inRange = true
                PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                local inBoat = IsPedInAnyBoat(Ped)

                if inBoat then
                    DrawMarker(35, v.coords.put.x, v.coords.put.y, v.coords.put.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 1.7, 255, 55, 15, 255, false, false, false, true, false, false, false)
                    if PutDistance < 2 then
                        if inBoat then
                            DrawText3D(v.coords.put.x, v.coords.put.y, v.coords.put.z, '~g~E~w~ - Remove boat')
                            if IsControlJustPressed(0, 38) then
                                RemoveVehicle()
                            end
                        end
                    end
                end

                if not inBoat then
                    DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ - Take the boat')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentDock = nil
                        elseif IsControlJustPressed(0, 38) and Menu.hidden then
                            MenuGarage()
                            Menu.hidden = not Menu.hidden
                            CurrentDock = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestDock ~= nil then
                    ClosestDock = nil
                end
            end
        end

        for k, v in pairs(PRPBoatshop.Depots) do
            local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

            if TakeDistance < 50 then
                ClosestDock = k
                inRange = true
                PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                local inBoat = IsPedInAnyBoat(Ped)

                if not inBoat then
                    DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ -Boat storage')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentDock = nil
                        elseif IsControlJustPressed(0, 38) and Menu.hidden then
                            MenuBoatDepot()
                            Menu.hidden = not Menu.hidden
                            CurrentDock = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestDock ~= nil then
                    ClosestDock = nil
                end
            end
        end

        if not inRange then
            Wait(1000)
        end

        Wait(4)
    end
end)

CreateThread(function()
    for k, v in pairs(PRPBoatshop.Docks) do
        local DockGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)
        SetBlipSprite (DockGarage, 410)
        SetBlipDisplay(DockGarage, 4)
        SetBlipScale  (DockGarage, 0.8)
        SetBlipAsShortRange(DockGarage, true)
        SetBlipColour(DockGarage, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(DockGarage)
    end

    for k, v in pairs(PRPBoatshop.Depots) do
        local BoatDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)
        SetBlipSprite (BoatDepot, 410)
        SetBlipDisplay(BoatDepot, 4)
        SetBlipScale  (BoatDepot, 0.8)
        SetBlipAsShortRange(BoatDepot, true)
        SetBlipColour(BoatDepot, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(BoatDepot)
    end
end)