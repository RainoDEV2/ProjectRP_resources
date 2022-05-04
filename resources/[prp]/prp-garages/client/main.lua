local ProjectRP = exports['prp-core']:GetCoreObject()
local PlayerData = {}
local PlayerGang = {}
local PlayerJob = {}
local currentHouseGarage = nil
local OutsideVehicles = {}

local Markers = false
local HouseMarkers = false
local InputIn = false
local InputOut = false
local currentGarage = nil
local currentGarageIndex = nil
local garageZones = {}
local lasthouse = nil


--Menus
local function MenuGarage(type, garage, indexgarage)
    local header
    local leave
    if type == "house" then
        header = Lang:t("menu.header."..type.."_car", {value = garage.label})
        leave = Lang:t("menu.leave.car")
    else 
        header = Lang:t("menu.header."..type.."_"..garage.vehicle, {value = garage.label})
        leave = Lang:t("menu.leave."..garage.vehicle)
    end

    exports['prp-menu']:openMenu({
        {
            header = header,
            isMenuHeader = true
        },
        {
            header = Lang:t("menu.header.vehicles"),
            txt = Lang:t("menu.text.vehicles"),
            params = {
                event = "prp-garages:client:VehicleList",
                args = {
                    type = type,
                    garage = garage,
                    index = indexgarage,
                }
            }
        },
        {
            header = leave,
            txt = "",
            params = {
                event = "prp-menu:closeMenu"
            }
        },
    })
end

local function ClearMenu()
	TriggerEvent("prp-menu:closeMenu")
end

local function closeMenuFull()
    ClearMenu()
end

local function DestroyZone(type, index)
    if garageZones[type.."_"..index] then
        garageZones[type.."_"..index].zonecombo:destroy()
        garageZones[type.."_"..index].zone:destroy()            
    end
end

local function CreateZone(type, garage, index)
    local size
    local coords
    local heading
    local minz
    local maxz

    if type == 'in' then
        size = 4
        coords = vector3(garage.putVehicle.x, garage.putVehicle.y, garage.putVehicle.z)
        heading = garage.spawnPoint.w
        minz = coords.z - 1.0
        maxz = coords.z + 2.0
    elseif type == 'out' then
        size = 2
        coords = vector3(garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
        heading = garage.spawnPoint.w
        minz = coords.z - 1.0
        maxz = coords.z + 2.0
    elseif type == 'marker' then
        size = 60
        coords = vector3(garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
        heading = garage.spawnPoint.w
        minz = coords.z - 7.5
        maxz = coords.z + 7.0
    elseif type == 'hmarker' then
        size = 20
        coords = vector3(garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
        heading = 0
        minz = coords.z - 4.0
        maxz = coords.z + 2.0
    elseif type == 'house' then
        size = 2
        coords = vector3(garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
        heading = 0
        minz = coords.z - 1.0
        maxz = coords.z + 2.0
    end
    garageZones[type.."_"..index] = {}
    garageZones[type.."_"..index].zone = BoxZone:Create(
        coords, size, size, {
            minZ = minz,
            maxZ = maxz,
            name = type,
            debugPoly = false,
            heading = heading
        })

    garageZones[type.."_"..index].zonecombo = ComboZone:Create({garageZones[type.."_"..index].zone}, {name = "box"..type, debugPoly = false})
    garageZones[type.."_"..index].zonecombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            if type == "in" then
                local text
                if garage.type == "house" then
                    text = "E - Store Vehicle"
                else
                    text = "E - Store Vehicle<br>"..garage.label
                end
                exports['prp-core']:DrawText(text, 'left')
                InputIn = true
            elseif type == "out" then
                if garage.type == "house" then
                    text = "E - Garage"
                else
                    text = Lang:t("info."..garage.vehicle.."_e").."<br>"..garage.label
                end

                exports['prp-core']:DrawText(text, 'left')
                InputOut = true
            elseif type == "marker" then
                currentGarage = garage
                currentGarageIndex = index
                CreateZone("out", garage, index)
                if garage.type ~= "depot" then
                    CreateZone("in", garage, index)
                    Markers = true
                else
                    HouseMarkers = true
                end
            elseif type == "hmarker" then
                currentGarage = garage
                currentGarage.type = "house"
                currentGarageIndex = index
                CreateZone("house", garage, index)
                HouseMarkers = true
            elseif type == "house" then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['prp-core']:DrawText("E - Store Vehicle", 'left')
                    InputIn = true
                else
                    exports['prp-core']:DrawText("E - Garage", 'left')
                    InputOut = true
                end
            end
        else
            if type == "marker" then
                if garage.type ~= "depot" then
                    Markers = false
                else
                    HouseMarkers = false
                end
                currentGarage = nil
                DestroyZone("in", index)
                DestroyZone("out", index)
            elseif type == "hmarker" then
                HouseMarkers = false
                currentHouseGarage = nil
                DestroyZone("house", index)
            elseif type == "house" then
                exports['prp-core']:HideText()
                InputIn = false
                InputOut = false
            elseif type == "in" then
                exports['prp-core']:HideText()
                InputIn = false
            elseif type == "out" then
                closeMenuFull()
                exports['prp-core']:HideText()
                InputOut = false
            end
        end
    end)
end

local function doCarDamage(currentVehicle, veh)
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0

    Wait(100)
    if body < 900.0 then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
		SmashVehicleWindow(currentVehicle, 5)
		SmashVehicleWindow(currentVehicle, 6)
		SmashVehicleWindow(currentVehicle, 7)
	end
	if body < 800.0 then
		SetVehicleDoorBroken(currentVehicle, 0, true)
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 2, true)
		SetVehicleDoorBroken(currentVehicle, 3, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
		SetVehicleDoorBroken(currentVehicle, 5, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
	end
	if engine < 700.0 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if engine < 500.0 then
		SetVehicleTyreBurst(currentVehicle, 0, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 5, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 6, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 7, false, 990.0)
	end
    SetVehicleEngineHealth(currentVehicle, engine)
    SetVehicleBodyHealth(currentVehicle, body)

end

local function CheckPlayers(vehicle, garage)
    for i = -1, 5, 1 do
        local seat = GetPedInVehicleSeat(vehicle, i)
        if seat then
            TaskLeaveVehicle(seat, vehicle, 0)
            if garage then
                SetEntityCoords(seat, garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
            end
        end
    end
    SetVehicleDoorsLocked(vehicle)
    Wait(1500)
    ProjectRP.Functions.DeleteVehicle(vehicle)
end

-- Functions
local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterNetEvent("prp-garages:client:VehicleList", function(data)
    local type = data.type
    local garage = data.garage
    local indexgarage = data.index
    local header
    local leave
    if type == "house" then
        header = Lang:t("menu.header."..type.."_car", {value = garage.label})
        leave = Lang:t("menu.leave.car")
    else 
        header = Lang:t("menu.header."..type.."_"..garage.vehicle, {value = garage.label})
        leave = Lang:t("menu.leave."..garage.vehicle)
    end

    ProjectRP.Functions.TriggerCallback("prp-garage:server:GetGarageVehicles", function(result)
        if result == nil then
            ProjectRP.Functions.Notify("There is no vehicles in this location!", "error", 5000)
        else
            local MenuGarageOptions = {
                {
                    header = header,
                    isMenuHeader = true
                },
            }
            for k, v in pairs(result) do
                local enginePercent = round(v.engine / 10, 0)
                local bodyPercent = round(v.body / 10, 0)
                local currentFuel = v.fuel
                local vname = ProjectRP.Shared.Vehicles[v.vehicle].name

                if v.state == 0 then
                    v.state = Lang:t("status.out")
                elseif v.state == 1 then
                    v.state = Lang:t("status.garaged")
                elseif v.state == 2 then
                    v.state = Lang:t("status.impound")
                end
                if type == "depot" then
                    MenuGarageOptions[#MenuGarageOptions+1] = {
                        header = Lang:t('menu.header.depot', {value = vname, value2 = v.depotprice}),
                        txt = Lang:t('menu.text.depot', {value = v.plate, value2 = currentFuel, value3 = enginePercent, value4 = bodyPercent}),
                        params = {
                            event = "prp-garages:client:TakeOutDepot",
                            args = {
                                vehicle = v,
                                type = type,
                                garage = garage,
                                index = indexgarage,
                            }
                        }
                    }
                else
                    MenuGarageOptions[#MenuGarageOptions+1] = {
                        header = Lang:t('menu.header.garage', {value = vname, value2 = v.plate}),
                        txt = Lang:t('menu.text.garage', {value = v.state, value2 = currentFuel, value3 = enginePercent, value4 = bodyPercent}),
                        params = {
                            event = "prp-garages:client:takeOutGarage",
                            args = {
                                vehicle = v,
                                type = type,
                                garage = garage,
                                index = indexgarage,
                            }
                        }
                    }
                end
            end

            MenuGarageOptions[#MenuGarageOptions+1] = {
                header = leave,
                txt = "",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
            exports['prp-menu']:openMenu(MenuGarageOptions)
        end
    end, indexgarage, type, garage.vehicle)
end)

RegisterNetEvent('prp-garages:client:takeOutGarage', function(data)
    local type = data.type
    local vehicle = data.vehicle
    local garage = data.garage
    local indexgarage = data.index
    local spawn = false

    if type == "depot" then         --If depot, check if vehicle is not already spawned on the map
        local VehExists = DoesEntityExist(OutsideVehicles[vehicle.plate])        
        if not VehExists then
            spawn = true
        else
            ProjectRP.Functions.Notify("Your vehicle is not in impound", "error", 5000)
            spawn = false
        end
    else
        spawn = true
    end
    if spawn then
        local enginePercent = round(vehicle.engine / 10, 1)
        local bodyPercent = round(vehicle.body / 10, 1)
        local currentFuel = vehicle.fuel
        local location
        local heading
        if type == "house" then
            location = garage.takeVehicle
            heading = garage.takeVehicle.h
        else
            location = garage.spawnPoint
            heading = garage.spawnPoint.w
        end

        ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)

                if vehicle.plate then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                ProjectRP.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, heading)
                exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                doCarDamage(veh, vehicle)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                if type == "depot" and garage.vehicle == "car" then
                    ProjectRP.Functions.Notify("Your Vehicle is waiting Outside.", "success", "3000")
                else
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                end
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
                if type == "house" then
                    exports['prp-core']:DrawText("E - Store Vehicle", 'left')
                    InputOut = false
                    InputIn = true
                end
            end, vehicle.plate)

        end, location, true)
    end
end)

local function enterVehicle(veh, indexgarage, type, garage)
    local plate = ProjectRP.Functions.GetPlate(veh)
    ProjectRP.Functions.TriggerCallback('prp-garage:server:checkOwnership', function(owned)
        if owned then
            local bodyDamage = math.ceil(GetVehicleBodyHealth(veh))
            local engineDamage = math.ceil(GetVehicleEngineHealth(veh))
            local totalFuel = exports['prp-fuel']:GetFuel(veh)
            local vehProperties = ProjectRP.Functions.GetVehicleProperties(veh)
            TriggerServerEvent('prp-garage:server:updateVehicle', 1, totalFuel, engineDamage, bodyDamage, plate, indexgarage)
            CheckPlayers(veh, garage)
            if type == "house" then
                exports['prp-core']:DrawText("E - Garage", 'left')
                InputOut = true
                InputIn = false
            end

            if plate then
                OutsideVehicles[plate] = nil
                TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
            end
            ProjectRP.Functions.Notify("Vehicle Stored", "primary", 4500)
        else
            ProjectRP.Functions.Notify("This vehicle can't be stored", "error", 3500)
        end
    end, plate, type, indexgarage, PlayerGang.name)
end

RegisterNetEvent('prp-garages:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house
    hasGarageKey = hasKey
    if HouseGarages[house] then
        if lasthouse ~= house then
            if lasthouse then
                DestroyZone("hmarker", lasthouse)
            end
            if hasKey then
                CreateZone("hmarker", HouseGarages[house], house)
                lasthouse = house
            end
        end
    end
end)

RegisterNetEvent('prp-garages:client:houseGarageConfig', function(garageConfig)
    HouseGarages = garageConfig
end)

RegisterNetEvent('prp-garages:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)

AddEventHandler('onResourceStart', function(resource)--if you restart the resource
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerData = ProjectRP.Functions.GetPlayerData()
        PlayerGang = PlayerData.gang
        PlayerJob = PlayerData.job
    end
end)

AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerData = ProjectRP.Functions.GetPlayerData()
    PlayerGang = PlayerData.gang
    PlayerJob = PlayerData.job
end)

RegisterNetEvent('ProjectRP:Client:OnGangUpdate', function(gang)
    PlayerGang = gang
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate', function(job)
    PlayerJob = job
end)

CreateThread(function()
    for index, garage in pairs(Garages) do
        if garage.showBlip then
            local Garage = AddBlipForCoord(garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
            SetBlipSprite (Garage, garage.blipNumber)
            SetBlipDisplay(Garage, 4)
            SetBlipScale  (Garage, 0.60)
            SetBlipAsShortRange(Garage, true)
            SetBlipColour(Garage, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(garage.blipName)
            EndTextCommandSetBlipName(Garage)
        end
        CreateZone("marker", garage, index)
    end
end)

RegisterNetEvent('prp-garages:client:TakeOutDepot', function(data)
    local vehicle = data.vehicle

    if ProjectRP.Functions.IsSpawnPointClear(vector3(-205.3176, -1165.6792, 22.4647),5.0) then
        if vehicle.depotprice ~= 0 then
            TriggerServerEvent("prp-garage:server:PayDepotPrice", data)
        else
            TriggerEvent("prp-garages:client:takeOutGarage", data)
        end
    else
        ProjectRP.Functions.Notify("There is a car blocking the Lot!", "error", 3000)
    end
end)

-- Threads
CreateThread(function()
    local sleep
    while true do
        sleep = 2000
        if Markers then
            DrawMarker(2, currentGarage.putVehicle.x, currentGarage.putVehicle.y, currentGarage.putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
            DrawMarker(2, currentGarage.takeVehicle.x, currentGarage.takeVehicle.y, currentGarage.takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
            sleep = 0
        elseif HouseMarkers then
            DrawMarker(2, currentGarage.takeVehicle.x, currentGarage.takeVehicle.y, currentGarage.takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
            sleep = 0
        end
        if InputIn or InputOut then
            if IsControlJustReleased(0, 38) then
                if InputIn then
                    local ped = PlayerPedId()
                    local curVeh = GetVehiclePedIsIn(ped)
                    local vehClass = GetVehicleClass(curVeh)
                    --Check vehicle type for garage
                    if currentGarage ~= nil then
                        if currentGarage.vehicle == "car" or not currentGarage.vehicle then
                            if vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 then
                                enterVehicle(curVeh, currentGarageIndex, currentGarage.type)
                            else
                                ProjectRP.Functions.Notify("You can't store this type of vehicle here", "error", 3500)
                            end
                        elseif currentGarage.vehicle == "air" then
                            if vehClass == 15 or vehClass == 16 then
                                enterVehicle(curVeh, currentGarageIndex, currentGarage.type)
                            else
                                ProjectRP.Functions.Notify("You can't store this type of vehicle here", "error", 3500)
                            end
                        elseif currentGarage.vehicle == "sea" then
                            if vehClass == 14 then
                                enterVehicle(curVeh, currentGarageIndex, currentGarage.type, currentGarage)
                            else
                                ProjectRP.Functions.Notify("You can't store this type of vehicle here", "error", 3500)
                            end
                        end
                    else
                        ProjectRP.Functions.Notify("Garage not found", "error", 3500)
                    end
                elseif InputOut and currentGarage then
                    MenuGarage(currentGarage.type, currentGarage, currentGarageIndex)
                end
            end
            sleep = 0
        end
        Wait(sleep)
    end
end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

local function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

local function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

ProjectRP.Functions.GetVehicles = function()
	local vehicles = {}
	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end
	return vehicles
end

ProjectRP.Functions.GetVehiclesInArea = function(coords, area)
	local vehicles       = ProjectRP.Functions.GetVehicles()
	local vehiclesInArea = {}
	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end
	return vehiclesInArea
end

ProjectRP.Functions.IsSpawnPointClear = function(coords, radius)
	local vehicles = ProjectRP.Functions.GetVehiclesInArea(coords, radius)
	return #vehicles == 0
end
