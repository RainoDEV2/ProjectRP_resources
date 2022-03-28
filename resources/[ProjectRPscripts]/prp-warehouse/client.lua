local ProjectRP = exports['prp-core']:GetCoreObject()

local JobStart = Config.Warehouse.JobStart
local Boss = Config.Warehouse.Boss
local Garage = Config.Warehouse.Garage
local GarageSpawnPoint = Config.Warehouse.GarageSpawnPoint
local PostOP = Config.Warehouse.PostOP
local GoPostal = Config.Warehouse.GoPostal
local AlphaMail = Config.Warehouse.AlphaMail
local IKEA = Config.Warehouse.IKEA
local PackageMarker = Config.Warehouse.PackageMarker
local HasRandomBox = nil
local Type = nil
local Plate = nil
local done, AmountPayout = 0, 0

onDuty = false
hasCar = false
hasOpenDoor = false
hasBox = false

Citizen.CreateThread(function()
	while ProjectRP == nil do
		TriggerEvent('ProjectRP:GetObject', function(obj) ProjectRP = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerData = ProjectRP.Functions.GetPlayerData()
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function()
	PlayerData.job = ProjectRP.Functions.GetPlayerData().job
end)

-- STARTING JOB
Citizen.CreateThread(function()
    while true do

        local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

            if (GetDistanceBetweenCoords(coords, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z, true) < 8) then
                sleep = 4
                DrawMarker(JobStart.Type, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, JobStart.Size.x, JobStart.Size.y, JobStart.Size.z, JobStart.Color.r, JobStart.Color.g, JobStart.Color.b, 100, false, true, 2, false, false, false, false)
                if (GetDistanceBetweenCoords(coords, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z, true) < 1.2) then
                    if not onDuty then
                        sleep = 4
                        DrawText3Ds(JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z + 0.4, '~g~[E]~s~ - Change into work clothes')
                        if IsControlJustPressed(0, Keys["E"]) then
                            exports.rprogress:Custom({
                                Duration = 2500,
                                Label = "You're changing your clothes...",
                                Animation = {
                                    scenario = "WORLD_HUMAN_COP_IDLES",
                                    animationDictionary = "idle_a",
                                },
                                DisableControls = {
                                    Mouse = false,
                                    Player = true,
                                    Vehicle = true
                                }
                            })
                            Citizen.Wait(2500)
                            local PlayerData = ProjectRP.Functions.GetPlayerData()
                            if PlayerData.charinfo.gender == 0 then 
                                SetPedComponentVariation(ped, 3, Config.Clothes.male['arms'], 0, 0) --arms
                                SetPedComponentVariation(ped, 8, Config.Clothes.male['tshirt_1'], Config.Clothes.male['tshirt_2'], 0) --t-shirt
                                SetPedComponentVariation(ped, 11, Config.Clothes.male['torso_1'], Config.Clothes.male['torso_2'], 0) --torso2
                                SetPedComponentVariation(ped, 9, Config.Clothes.male['bproof_1'], Config.Clothes.male['bproof_2'], 0) --vest
                                SetPedComponentVariation(ped, 10, Config.Clothes.male['decals_1'], Config.Clothes.male['decals_2'], 0) --decals
                                SetPedComponentVariation(ped, 7, Config.Clothes.male['chain_1'], Config.Clothes.male['chain_2'], 0) --accessory
                                SetPedComponentVariation(ped, 4, Config.Clothes.male['pants_1'], Config.Clothes.male['pants_2'], 0) -- pants
                                SetPedComponentVariation(ped, 6, Config.Clothes.male['shoes_1'], Config.Clothes.male['shoes_2'], 0) --shoes
                                SetPedPropIndex(ped, 0, Config.Clothes.male['helmet_1'], Config.Clothes.male['helmet_2'], true) --hat
                                SetPedPropIndex(ped, 2, Config.Clothes.male['ears_1'], Config.Clothes.male['ears_2'], true) --ear
                            else
                                SetPedComponentVariation(ped, 3, Config.Clothes.female['arms'], 0, 0) --arms
                                SetPedComponentVariation(ped, 8, Config.Clothes.female['tshirt_1'], Config.Clothes.female['tshirt_2'], 0) --t-shirt
                                SetPedComponentVariation(ped, 11, Config.Clothes.female['torso_1'], Config.Clothes.female['torso_2'], 0) --torso2
                                SetPedComponentVariation(ped, 9, Config.Clothes.female['bproof_1'], Config.Clothes.female['bproof_2'], 0) --vest
                                SetPedComponentVariation(ped, 10, Config.Clothes.female['decals_1'], Config.Clothes.female['decals_2'], 0) --decals
                                SetPedComponentVariation(ped, 7, Config.Clothes.female['chain_1'], Config.Clothes.female['chain_2'], 0) --accessory
                                SetPedComponentVariation(ped, 4, Config.Clothes.female['pants_1'], Config.Clothes.female['pants_2'], 0) -- pants
                                SetPedComponentVariation(ped, 6, Config.Clothes.female['shoes_1'], Config.Clothes.female['shoes_2'], 0) --shoes
                                SetPedPropIndex(ped, 0, Config.Clothes.female['helmet_1'], Config.Clothes.female['helmet_2'], true) --hat
                                SetPedPropIndex(ped, 2, Config.Clothes.female['ears_1'], Config.Clothes.female['ears_2'], true) --ear
                            end
                            exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>You have started work, go to the boss to get information about the job!", timeout = 3000})
                            onDuty = true
                            addBlips()
                        end
                    elseif onDuty then
                        sleep = 4
                        DrawText3Ds(JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z + 0.4, '~r~[E]~s~ - Change into citizen clothes')
                        DrawMarker(JobStart.Type, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, JobStart.Size.x, JobStart.Size.y, JobStart.Size.z, JobStart.Color.r, JobStart.Color.g, JobStart.Color.b, 100, false, true, 2, false, false, false, false)
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not HasRandomBox then
                                exports.rprogress:Custom({
                                    Duration = 2500,
                                    Label = "You're changing your clothes...",
                                    Animation = {
                                        scenario = "WORLD_HUMAN_COP_IDLES",
                                        animationDictionary = "idle_a",
                                    },
                                    DisableControls = {
                                        Mouse = false,
                                        Player = true,
                                        Vehicle = true
                                    }
                                })
                                Citizen.Wait(2500)
                                TriggerServerEvent("prp-clothes:loadPlayerSkin")	
                                Citizen.Wait(1500)
                                TriggerServerEvent("Mx :: GetTattoos")
                                exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>You finished work!", timeout = 3000})
                                onDuty = false
                                RemoveBlip(bossBlip)
                            elseif HasRandomBox then
                                exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>First, cancel the job at the boss", timeout = 3000})
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

-- BOSS
Citizen.CreateThread(function()
    while true do

        local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
        local salary = Config.Payout * AmountPayout

            if onDuty then
                if (GetDistanceBetweenCoords(coords, Boss.Pos.x, Boss.Pos.y, Boss.Pos.z, true) < Config.DrawDistance) then
                    sleep = 4
                    DrawMarker(Boss.Type, Boss.Pos.x, Boss.Pos.y, Boss.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Boss.Size.x, Boss.Size.y, Boss.Size.z, Boss.Color.r, Boss.Color.g, Boss.Color.b, 100, false, true, 2, false, false, false, false)
                    if (GetDistanceBetweenCoords(coords, Boss.Pos.x, Boss.Pos.y, Boss.Pos.z, true) < 1.5) then
                        if not HasRandomBox then
                            DrawText3Ds(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z + 0.4, "~g~[E]~s~ - Ask your boss about today's job")
                            if IsControlJustPressed(0, Keys["E"]) then
                                HasRandomBox = math.random(6, 16)
                                Companies = Randomize(Config.Companies)
                                CreateWork(Companies.CompanyName)
                                addBlipsHRB()
                                exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>You have to collect " ..HasRandomBox.. " packages from the warehouse. Take the " ..Companies.CompanyName.. " vehicle from the garage and start!", timeout = 5000})
                            end
                        elseif HasRandomBox then
                            if AmountPayout == 0 then
                                DrawText3Ds(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z + 0.4, "~r~[E]~s~ - Cancel the errand")
                                if IsControlJustPressed(0, Keys["E"]) then
                                    if not hasCar then
                                        done = 0
                                        Type = nil
                                        HasRandomBox = nil
                                        DeleteCompanyBlip()
                                        RemoveBlip(garageBlip)
                                        for i, v in ipairs(Config.WarehouseSpots) do
                                            v.taked = true
                                            RemoveBlip(v.blip)
                                        end
                                        exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>You're canceled the errand", timeout = 3000})
                                    elseif hasCar then
                                        exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>Put the vehicle into garage", timeout = 3000})
                                    end
                                end
                            elseif AmountPayout == HasRandomBox then
                                DrawText3Ds(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z + 0.4, "~g~[E]~s~ - Receive a salary of " ..salary.. "$")
                                if IsControlJustPressed(0, Keys["E"]) then
                                    if not hasCar then
                                        exports.rprogress:Custom({
                                            Duration = 2000,
                                            Label = "You're calculating your paycheck...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(2000)
                                        TriggerServerEvent('prp-warehouse:Payout', AmountPayout)
                                        exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You earned ' ..salary.. '$!', timeout = 3000})
                                        RemoveBlip(garageBlip)
                                        AmountPayout = 0
                                        done = 0
                                        HasRandomBox = nil
                                    elseif hasCar then
                                        exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>Put the vehicle into garage", timeout = 3000})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

-- CAR DEPOSIT
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

            if HasRandomBox then
                if (GetDistanceBetweenCoords(coords, Garage.Pos.x, Garage.Pos.y, Garage.Pos.z, true) < Config.DrawDistance) then
                    sleep = 4
                    DrawMarker(Garage.Type, Garage.Pos.x, Garage.Pos.y, Garage.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Garage.Size.x, Garage.Size.y, Garage.Size.z, Garage.Color.r, Garage.Color.g, Garage.Color.b, 100, false, true, 2, false, false, false, false)
                    if (GetDistanceBetweenCoords(coords, Garage.Pos.x, Garage.Pos.y, Garage.Pos.z, true) < 2.5) then
                        if IsPedInAnyVehicle(ped, false) then
                            DrawText3Ds(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z + 0.4, '~r~[E]~s~ - Return vehicle')
                            if IsControlJustReleased(0, Keys["E"]) then
                                if hasCar then
                                    TriggerServerEvent('prp-warehouse:returnVehicle', source)
                                    ReturnVehicle()
                                    exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You received ' ..Config.DepositPrice.. '$ for returning the vehicle', timeout = 1500})
                                    hasCar = false
                                    Plate = nil
                                end
                            end
                        elseif not IsPedInAnyVehicle(ped, false) then
                            if not hasCar then
                                DrawText3Ds(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z + 0.4, '~g~[E]~s~ - Take out vehicle')
                            elseif hasCar then
                                DrawText3Ds(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z + 0.4, 'You already have a pulled out vehicle')
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                ProjectRP.Functions.TriggerCallback('prp-warehouse:checkMoney', function(hasMoney)
                                    if hasMoney then
                                        if not hasCar then
                                            if Type == "Post OP" then
                                                ProjectRP.Functions.SpawnVehicle(Config.CarPostOP, function(vehicle)
                                                    SetEntityHeading(vehicle, GarageSpawnPoint.Pos.h)
                                                    SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                                    SetVehicleEngineOn(vehicle, true, true)
                                                    exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You paid ' ..Config.DepositPrice.. '$ to take out the vehicle', timeout = 1500})
                                                    hasCar = true
                                                    Plate = GetVehicleNumberPlateText(vehicle)
                                                    TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(vehicle))	
                                                    SetEntityAsMissionEntity(vehicle, true, true)
                                                    BlipsOnWorking()
                                                    for i, v in ipairs(Config.WarehouseSpots) do
                                                        v.taked = false
                                                    end
                                                end, GarageSpawnPoint.Pos, true)
                                            elseif Type == "GoPostal" then
                                                ProjectRP.Functions.SpawnVehicle(Config.CarGoPostal, function(vehicle)
                                                    SetEntityHeading(vehicle, GarageSpawnPoint.Pos.h)
                                                    SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                                    SetVehicleEngineOn(vehicle, true, true)
                                                    exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You paid ' ..Config.DepositPrice.. '$ to take out the vehicle', timeout = 1500})
                                                    hasCar = true
                                                    Plate = GetVehicleNumberPlateText(vehicle)
                                                    TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(vehicle))	
                                                    SetEntityAsMissionEntity(vehicle, true, true)
                                                    BlipsOnWorking()
                                                    for i, v in ipairs(Config.WarehouseSpots) do
                                                        v.taked = false
                                                    end
                                                end, GarageSpawnPoint.Pos, true)
                                            elseif Type == "Alpha Mail" then
                                                ProjectRP.Functions.SpawnVehicle(Config.CarAlphaMail, function(vehicle)
                                                    SetEntityHeading(vehicle, GarageSpawnPoint.Pos.h)
                                                    SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                                    SetVehicleEngineOn(vehicle, true, true)
                                                    exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You paid ' ..Config.DepositPrice.. '$ to take out the vehicle', timeout = 1500})
                                                    hasCar = true
                                                    Plate = GetVehicleNumberPlateText(vehicle)
                                                    TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(vehicle))	
                                                    SetEntityAsMissionEntity(vehicle, true, true)
                                                    BlipsOnWorking()
                                                    for i, v in ipairs(Config.WarehouseSpots) do
                                                        v.taked = false
                                                    end
                                                end, GarageSpawnPoint.Pos, true)
                                            elseif Type == "IKEA" then
                                                ProjectRP.Functions.SpawnVehicle(Config.CarDefault, function(vehicle)
                                                    SetEntityHeading(vehicle, GarageSpawnPoint.Pos.h)
                                                    SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                                    SetVehicleEngineOn(vehicle, true, true)
                                                    exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You paid ' ..Config.DepositPrice.. '$ to take out the vehicle', timeout = 1500})
                                                    hasCar = true
                                                    Plate = GetVehicleNumberPlateText(vehicle)
                                                    TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(vehicle))	
                                                    SetEntityAsMissionEntity(vehicle, true, true)
                                                    BlipsOnWorking()
                                                    for i, v in ipairs(Config.WarehouseSpots) do
                                                        v.taked = false
                                                    end
                                                end, GarageSpawnPoint.Pos, true)
                                            end
                                        elseif hasCar then
                                            exports.pNotify:SendNotification({text = "<b>Gardener</b></br>First, put down the car you pulled out", timeout = 2500})
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

-- OPENING VAN DOORS
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

            if hasCar then
                if not IsPedInAnyVehicle(ped, false) then
                    if Plate == GetVehicleNumberPlateText(vehicle) then
                        local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -3.5, 0)
                        if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 2) then
                            sleep = 4
                            if not hasOpenDoor and not hasBox then
                                sleep = 4
                                DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~g~[G]~s~ - Open Doors")
                                if IsControlJustReleased(0, Keys["G"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "You're opening the rear doors",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    SetVehicleDoorOpen(vehicle, 3, false, false)
                                    SetVehicleDoorOpen(vehicle, 2, false, false)
                                    hasOpenDoor = true
                                end
                            elseif hasOpenDoor then
                                sleep = 4
                                DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.25, "Packages: ~g~" ..done.. "/" ..HasRandomBox.. "~s~")
                                if not hasBox and done == 0 then
                                    sleep = 4
                                    DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~r~[G]~s~ - Close Doors")
                                    if IsControlJustReleased(0, Keys["G"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "You're closing the rear doors",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        SetVehicleDoorShut(vehicle, 3, false)
                                        SetVehicleDoorShut(vehicle, 2, false)
                                        hasOpenDoor = false
                                    end
                                elseif not hasBox then
                                    sleep = 4
                                    DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~r~[G]~s~ - Close Doors | ~r~[E]~s~ - Take package out")
                                    if IsControlJustReleased(0, Keys["G"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "You're closing the rear doors",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        SetVehicleDoorShut(vehicle, 3, false)
                                        SetVehicleDoorShut(vehicle, 2, false)
                                        hasOpenDoor = false
                                    elseif IsControlJustReleased(0, Keys["E"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "You're picking package...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        addPackage()
                                        hasBox = true
                                        done = done - 1
                                    end
                                elseif hasBox then
                                    sleep = 4
                                    DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~g~[E]~s~ - Put package in")
                                    if IsControlJustReleased(0, Keys["E"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "You're putting package...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        removePackage()
                                        hasBox = false
                                        done = done + 1
                                        if done == HasRandomBox then
                                            exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>You collected all boxes from base, now deliver it to " ..Companies.CompanyName.. ' company!', timeout = 5000})
                                            if Type == "GoPostal" then
                                                SetNewWaypoint(GoPostal.Pos.x, GoPostal.Pos.y, GoPostal.Pos.z)
                                            elseif Type == "Post OP" then
                                                SetNewWaypoint(PostOP.Pos.x, PostOP.Pos.y, PostOP.Pos.z)
                                            elseif Type == "Alpha Mail" then
                                                SetNewWaypoint(AlphaMail.Pos.x, AlphaMail.Pos.y, AlphaMail.Pos.z)
                                            elseif Type == "IKEA" then
                                                SetNewWaypoint(IKEA.Pos.x, IKEA.Pos.y, IKEA.Pos.z)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

-- WORKING
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        local vheading = GetEntityHeading(vehicle)

            if hasCar then
                for i, v in ipairs(Config.WarehouseSpots) do
                    if HasRandomBox and i > HasRandomBox then break end
                    if not v.taked then
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 40) then
                            sleep = 4
                            DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                            if not hasBox then
                                if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                                    sleep = 4
                                    DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Pickup package")
                                    if IsControlJustReleased(0, Keys["E"]) then
                                        if hasOpenDoor then
                                            exports.rprogress:Custom({
                                                Duration = 1500,
                                                Label = "You're picking package...",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(1500)
                                            addPackage()
                                            v.taked = true
                                            hasBox = true
                                            RemoveBlip(v.blip)
                                        elseif not hasOpenDoor then
                                            exports.pNotify:SendNotification({text = "<b>Warehouse</b></br>Open the rear doors in your vehicle!", timeout = 5000})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if Type == "GoPostal" then
                for i, v in ipairs(Config.GoPostal) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 4
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "You're putting package...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You deliver all package to GoPostal, now return vehicle and go to the boss!', timeout = 5000})
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Type == "Post OP" then
                for i, v in ipairs(Config.PostOP) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 4
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "You're putting package...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You deliver all package to Post OP, now return vehicle and go to the boss!', timeout = 5000})
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Type == "Alpha Mail" then
                for i, v in ipairs(Config.AlphaMail) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 4
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "You're putting package...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You deliver all package to Alpha Mail, now return vehicle and go to the boss!', timeout = 5000})
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Type == "IKEA" then
                for i, v in ipairs(Config.IKEA) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 4
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "You're putting package...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports.pNotify:SendNotification({text = '<b>Warehouse</b></br>You deliver all package to IKEA, now return vehicle and go to the boss!', timeout = 5000})
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

function Randomize(tb)
	local keys = {}
	for k in pairs(tb) do table.insert(keys, k) end
	return tb[keys[math.random(#keys)]]
end

function CreateWork(type)

    if type == "GoPostal" then
        for i, v in ipairs(Config.GoPostal) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] GoPostal')
            EndTextCommandSetBlipName(v.blip)
        end
    elseif type == "Post OP" then
        for i, v in ipairs(Config.PostOP) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] Post OP')
            EndTextCommandSetBlipName(v.blip)
        end
    elseif type == "Alpha Mail" then
        for i, v in ipairs(Config.AlphaMail) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] Alpha Mail')
            EndTextCommandSetBlipName(v.blip)
        end
    elseif type == "IKEA" then
        for i, v in ipairs(Config.IKEA) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] IKEA')
            EndTextCommandSetBlipName(v.blip)
        end
    end
    Type = type
end

function DeleteCompanyBlip()
    for i, v in ipairs(Config.PostOP) do
        RemoveBlip(v.blip)
    end
    for i, v in ipairs(Config.GoPostal) do
        RemoveBlip(v.blip)
    end
    for i, v in ipairs(Config.AlphaMail) do
        RemoveBlip(v.blip)
    end
    for i, v in ipairs(Config.IKEA) do
        RemoveBlip(v.blip)
    end
end

-- RETURNING VEHICLE
function ReturnVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)

    ProjectRP.Functions.DeleteVehicle(vehicle)
end

-- MAIN BLIP
Citizen.CreateThread(function()
    mainBlip = AddBlipForCoord(JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z)
    SetBlipSprite(mainBlip, 365)
    SetBlipDisplay(mainBlip, 4)
    SetBlipScale(mainBlip, JobStart.BlipScale)
    SetBlipAsShortRange(mainBlip, true)
    SetBlipColour(mainBlip, JobStart.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(JobStart.BlipLabel)
    EndTextCommandSetBlipName(mainBlip)
end)

-- ONDUTY BLIP
function addBlips()

    bossBlip = AddBlipForCoord(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z)
    SetBlipSprite(bossBlip, 408)
    SetBlipDisplay(bossBlip, 4)
    SetBlipScale(bossBlip, Boss.BlipScale)
    SetBlipAsShortRange(bossBlip, true)
    SetBlipColour(bossBlip, Boss.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Boss.BlipLabel)
    EndTextCommandSetBlipName(bossBlip)
end

-- AFTER BOSS BLIPS
function addBlipsHRB()
    
    garageBlip = AddBlipForCoord(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
    SetBlipSprite(garageBlip, 326)
    SetBlipDisplay(garageBlip, 4)
    SetBlipScale(garageBlip, Garage.BlipScale)
    SetBlipAsShortRange(garageBlip, true)
    SetBlipColour(garageBlip, Garage.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Garage.BlipLabel)
    EndTextCommandSetBlipName(garageBlip)
end

-- WORKING BLIPS
function BlipsOnWorking()
    for i, v in ipairs(Config.WarehouseSpots) do
        if HasRandomBox and i > HasRandomBox then break end
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 1)
        SetBlipColour(v.blip, 24)
        SetBlipScale(v.blip, 0.3)
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('[Warehouse] Packages')
        EndTextCommandSetBlipName(v.blip)
    end
end

function addPackage()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    pack = CreateObject(GetHashKey('prop_cs_cardbox_01'), coords.x, coords.y, coords.z,  true,  true, true)
    AttachEntityToEntity(pack, ped, GetPedBoneIndex(ped, 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
end

function removePackage()
    local ped = PlayerPedId()

    ClearPedTasks(ped)
    DeleteEntity(pack)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
