local ProjectRP = exports['prp-core']:GetCoreObject()
local currentHouseGarage = nil
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local PlayerData = {}
local PlayerGang = {}
local PlayerJob = {}

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

RegisterNetEvent('prp-garages:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house
    hasGarageKey = hasKey
end)

RegisterNetEvent('prp-garages:client:houseGarageConfig', function(garageConfig)
    HouseGarages = garageConfig
end)

RegisterNetEvent('prp-garages:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)

-- Functions

local DrawText3Ds = function(x, y, z, text)
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

local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function MenuGarage()
    exports['prp-menu']:openMenu({
        {
            header = "Public Garage",
            isMenuHeader = true
        },
        {
            header = "My Vehicles",
            txt = "View your stored vehicles!",
            params = {
                event = "prp-garages:client:VehicleList"
            }
        },
        {
            header = "⬅ Leave Garage",
            txt = "",
            params = {
                event = "prp-menu:closeMenu"
            }
        },
    })
end

local function GangMenuGarage()
    exports['prp-menu']:openMenu({
        {
            header = "Gang Garage",
            isMenuHeader = true
        },
        {
            header = "My Vehicles",
            txt = "View your stored vehicles!",
            params = {
                event = "prp-garages:client:GangVehicleList"
            }
        },
        {
            header = "⬅ Leave Garage",
            txt = "",
            params = {
                event = "prp-menu:closeMenu"
            }
        },
    })
end

local function JobMenuGarage()
    exports['prp-menu']:openMenu({
        {
            header = "Job Garage",
            isMenuHeader = true
        },
        {
            header = "My Vehicles",
            txt = "View your stored vehicles!",
            params = {
                event = "prp-garages:client:JobVehicleList"
            }
        },
        {
            header = "⬅ Leave Garage",
            txt = "",
            params = {
                event = "prp-menu:closeMenu"
            }
        },
    })
end

local function MenuDepot()
    exports['prp-menu']:openMenu({
        {
            header = "Impound",
            isMenuHeader = true
        },
        {
            header = "My Vehicles",
            txt = "View your impounded vehicles!",
            params = {
                event = "prp-garages:client:DepotList"
            }
        },
        {
            header = "⬅ Leave Depot",
            txt = "",
            params = {
                event = "prp-menu:closeMenu"
            }
        },
    })
end

local function MenuHouseGarage(house)
    exports['prp-menu']:openMenu({
        {
            header = "House Garage",
            isMenuHeader = true
        },
        {
            header = "My Vehicles",
            txt = "View your stored vehicles!",
            params = {
                event = "prp-garages:client:HouseGarage",
                args = house
            }
        },
        {
            header = "⬅ Leave Garage",
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
    currentGarage = nil
    ClearMenu()
end

local function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine > 1000.0 then
        engine = 1000.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 900.0 then
		smash = true
	end

	if body < 800.0 then
		damageOutside = true
	end

	if body < 500.0 then
		damageOutside2 = true
	end

    Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

local function CheckPlayers(vehicle)
    for i = -1, 5,1 do
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            ProjectRP.Functions.DeleteVehicle(vehicle)
        end
   end
end

-- Events

RegisterNetEvent('prp-garages:client:takeOutDepot', function(vehicle)
    if OutsideVehicles and next(OutsideVehicles) then
        if OutsideVehicles[vehicle.plate] then
            local Engine = GetVehicleEngineHealth(OutsideVehicles[vehicle.plate])
            ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)
                    ProjectRP.Functions.SetVehicleProperties(veh, properties)
                    enginePercent = round(vehicle.engine / 10, 0)
                    bodyPercent = round(vehicle.body / 10, 0)
                    currentFuel = vehicle.fuel

                    if vehicle.plate then
                        DeleteVehicle(OutsideVehicles[vehicle.plate])
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Depots["hayesdepot"].takeVehicle.w)
                    exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                    SetEntityAsMissionEntity(veh, true, true)
                    doCarDamage(veh, vehicle)
                    TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                    closeMenuFull()
                    SetVehicleEngineOn(veh, true, true)
                end, vehicle.plate)
                TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
            end, vector4(-131.7727, -1182.2717, 23.1892, 268.9681), true)
            SetTimeout(250, function()
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false)))
            end)
        else
            ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)
                    ProjectRP.Functions.SetVehicleProperties(veh, properties)
                    enginePercent = round(vehicle.engine / 10, 0)
                    bodyPercent = round(vehicle.body / 10, 0)
                    currentFuel = vehicle.fuel

                    if vehicle.plate then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Depots["hayesdepot"].takeVehicle.w)
                    exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                    SetEntityAsMissionEntity(veh, true, true)
                    doCarDamage(veh, vehicle)
                    TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                    closeMenuFull()
                    SetVehicleEngineOn(veh, true, true)
                end, vehicle.plate)
                TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
            end, vector4(-131.7727, -1182.2717, 23.1892, 268.9681), true)
            SetTimeout(250, function()
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false)))
            end)
        end
    else
        ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)
                ProjectRP.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 0)
                bodyPercent = round(vehicle.body / 10, 0)
                currentFuel = vehicle.fuel

                if vehicle.plate then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, Depots["hayesdepot"].takeVehicle.w)
                exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                SetEntityAsMissionEntity(veh, true, true)
                doCarDamage(veh, vehicle)
                TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                closeMenuFull()
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)
            TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
        end, vector4(-131.7727, -1182.2717, 23.1892, 268.9681), true)
        SetTimeout(250, function()
            TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false)))
        end)
    end
end)

RegisterNetEvent("prp-garages:client:HouseGarage", function(house)
    ProjectRP.Functions.TriggerCallback("prp-garage:server:GetHouseVehicles", function(result)
        if result == nil then
            ProjectRP.Functions.Notify("You don't have any vehicles in your garage!", "error", 5000)
        else
            local MenuHouseGarageOptions = {
                {
                    header = "Garage: "..HouseGarages[house].label,
                    isMenuHeader = true
                },
            }

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = HouseGarages[house].label
                vname = ProjectRP.Shared.Vehicles[v.vehicle].name

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impounded By Police"
                end

                MenuHouseGarageOptions[#MenuHouseGarageOptions+1] = {
                    header = vname.." ["..v.plate.."]",
                    txt = "State: "..v.state.. "<br>Fuel: "..currentFuel.." | Engine: "..enginePercent.." | Body: "..bodyPercent,
                    params = {
                        event = "prp-garages:client:TakeOutHouseGarage",
                        args = v
                    }
                }
            end

            MenuHouseGarageOptions[#MenuHouseGarageOptions+1] = {
                header = "⬅ Leave Garage",
                txt = "",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
            exports['prp-menu']:openMenu(MenuHouseGarageOptions)
        end
    end, house)
end)

RegisterNetEvent("prp-garages:client:DepotList", function()
    ProjectRP.Functions.TriggerCallback("prp-garage:server:GetDepotVehicles", function(result)
        if result == nil then
            ProjectRP.Functions.Notify("You don't have any impounded vehicles!", "error", 5000)
        else
            local MenuDepotOptions = {
                {
                    header = "Depot: "..Depots["hayesdepot"].label,
                    isMenuHeader = true
                },
            }
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                vname = ProjectRP.Shared.Vehicles[v.vehicle].name

                if v.state == 0 then
                    v.state = "Impound"
                end

                MenuDepotOptions[#MenuDepotOptions+1] = {
                    header = vname.." ["..v.depotprice.."]",
                    txt = "Plate: "..v.plate.."<br>Fuel: "..currentFuel.." | Engine: "..enginePercent.." | Body: "..bodyPercent,
                    params = {
                        event = "prp-garages:client:TakeOutDepotVehicle",
                        args = v
                    }
                }
            end

            MenuDepotOptions[#MenuDepotOptions+1] = {
                header = "⬅ Leave Depot",
                txt = "",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
            exports['prp-menu']:openMenu(MenuDepotOptions)
        end
    end)
end)

RegisterNetEvent("prp-garages:client:VehicleList", function()
    ProjectRP.Functions.TriggerCallback("prp-garage:server:GetUserVehicles", function(result)
        if result == nil then
            ProjectRP.Functions.Notify("You don't have any vehicles in this garage!", "error", 5000)
        else
            local MenuPublicGarageOptions = {
                {
                    header = "Garage: "..Garages[currentGarage].label,
                    isMenuHeader = true
                },
            }
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = Garages[v.garage].label
                vname = ProjectRP.Shared.Vehicles[v.vehicle].name

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impounded By Police"
                end

                MenuPublicGarageOptions[#MenuPublicGarageOptions+1] = {
                    header = vname.." ["..v.plate.."]",
                    txt = "State: "..v.state.." <br>Fuel: "..currentFuel.." | Engine: "..enginePercent.." | Body: "..bodyPercent,
                    params = {
                        event = "prp-garages:client:takeOutPublicGarage",
                        args = v,
                    }
                }
            end

            MenuPublicGarageOptions[#MenuPublicGarageOptions+1] = {
                header = "⬅ Leave Garage",
                txt = "",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
            exports['prp-menu']:openMenu(MenuPublicGarageOptions)
        end
    end, currentGarage)
end)

RegisterNetEvent("prp-garages:client:GangVehicleList", function()
    ProjectRP.Functions.TriggerCallback("prp-garage:server:GetUserVehicles", function(result)
        if result == nil then
            ProjectRP.Functions.Notify("You don't have any vehicles in this garage!", "error", 5000)
        else
            local MenuGangGarageOptions = {
                {
                    header = "Garage: "..GangGarages[currentGarage].label,
                    isMenuHeader = true
                },
            }
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = GangGarages[v.garage].label
                vname = ProjectRP.Shared.Vehicles[v.vehicle].name

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impounded By Police"
                end

                MenuGangGarageOptions[#MenuGangGarageOptions+1] = {
                    header = vname.." ["..v.plate.."]",
                    txt = "State: "..v.state.."<br>Fuel: "..currentFuel.." | Engine: "..enginePercent.." | Body: "..bodyPercent,
                    params = {
                        event = "prp-garages:client:takeOutGangGarage",
                        args = v
                    }
                }
            end

            MenuGangGarageOptions[#MenuGangGarageOptions+1] = {
                header = "⬅ Leave Garage",
                txt = "",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
            exports['prp-menu']:openMenu(MenuGangGarageOptions)
        end
    end, currentGarage)
end)

RegisterNetEvent("prp-garages:client:JobVehicleList", function()
    ProjectRP.Functions.TriggerCallback("prp-garage:server:GetUserVehicles", function(result)
        if result == nil then
            ProjectRP.Functions.Notify("You don't have any vehicles in this garage!", "error", 5000)
        else
            local MenuJobGarageOptions = {
                {
                    header = "Garage: "..JobGarages[currentGarage].label,
                    isMenuHeader = true
                },
            }
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = JobGarages[v.garage].label
                vname = ProjectRP.Shared.Vehicles[v.vehicle].name

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impounded By Police"
                end

                MenuJobGarageOptions[#MenuJobGarageOptions+1] = {
                    header = vname.." ["..v.plate.."]",
                    txt = "State: "..v.state.."<br>Fuel: "..currentFuel.." | Engine: "..enginePercent.." | Body: "..bodyPercent,
                    params = {
                        event = "prp-garages:client:takeOutJobGarage",
                        args = v
                    }
                }
            end

            MenuJobGarageOptions[#MenuJobGarageOptions+1] = {
                header = "⬅ Leave Garage",
                txt = "",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
            exports['prp-menu']:openMenu(MenuJobGarageOptions)
        end
    end, currentGarage)
end)

RegisterNetEvent('prp-garages:client:takeOutPublicGarage', function(vehicle)
    if vehicle.state == "Garaged" then
        enginePercent = round(vehicle.engine / 10, 1)
        bodyPercent = round(vehicle.body / 10, 1)
        currentFuel = vehicle.fuel

        ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)

                if vehicle.plate then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                ProjectRP.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, Garages[currentGarage].spawnPoint.w)
                exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                doCarDamage(veh, vehicle)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)

        end, Garages[currentGarage].spawnPoint, true)
    elseif vehicle.state == "Out" then
        ProjectRP.Functions.Notify("Your vehicle may be at the depot!", "error", 2500)
    elseif vehicle.state == "Impound" then
        ProjectRP.Functions.Notify("This vehicle was impounded by the police!", "error", 4000)
    end
end)

RegisterNetEvent('prp-garages:client:takeOutGangGarage', function(vehicle)
    if vehicle.state == "Garaged" then
        enginePercent = round(vehicle.engine / 10, 1)
        bodyPercent = round(vehicle.body / 10, 1)
        currentFuel = vehicle.fuel

        ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)

                if vehicle.plate then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                ProjectRP.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, GangGarages[currentGarage].spawnPoint.w)
                exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                doCarDamage(veh, vehicle)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)

        end, GangGarages[currentGarage].spawnPoint, true)
    elseif vehicle.state == "Out" then
        ProjectRP.Functions.Notify("Your vehicle may be in the depot!", "error", 2500)
    elseif vehicle.state == "Impound" then
        ProjectRP.Functions.Notify("This vehicle was impounded by the police!", "error", 4000)
    end
end)

RegisterNetEvent('prp-garages:client:takeOutJobGarage', function(vehicle)
    if vehicle.state == "Garaged" then
        enginePercent = round(vehicle.engine / 10, 1)
        bodyPercent = round(vehicle.body / 10, 1)
        currentFuel = vehicle.fuel
        ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)
                if vehicle.plate then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end
                ProjectRP.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, JobGarages[currentGarage].spawnPoint.w)
                exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                doCarDamage(veh, vehicle)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)
        end, JobGarages[currentGarage].spawnPoint, true)
    elseif vehicle.state == "Out" then
        ProjectRP.Functions.Notify("Your vehicle may be in the depot!", "error", 2500)
    elseif vehicle.state == "Impound" then
        ProjectRP.Functions.Notify("This vehicle was impounded by the police!", "error", 4000)
    end
end)

RegisterNetEvent('prp-garages:client:TakeOutDepotVehicle', function(vehicle)
    if vehicle.state == "Impound" then
        TriggerServerEvent("prp-garage:server:PayDepotPrice", vehicle)
        Wait(1000)
    end
end)

RegisterNetEvent('prp-garages:client:TakeOutHouseGarage', function(vehicle)
    if vehicle.state == "Garaged" then
        ProjectRP.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            ProjectRP.Functions.TriggerCallback('prp-garage:server:GetVehicleProperties', function(properties)
                ProjectRP.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 1)
                bodyPercent = round(vehicle.body / 10, 1)
                currentFuel = vehicle.fuel

                if vehicle.plate then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, HouseGarages[currentHouseGarage].takeVehicle.h)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                exports['prp-fuel']:SetFuel(veh, vehicle.fuel)
                SetEntityAsMissionEntity(veh, true, true)
                doCarDamage(veh, vehicle)
                TriggerServerEvent('prp-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)
        end, HouseGarages[currentHouseGarage].takeVehicle, true)
    end
end)

-- Threads

CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        for k, v in pairs(Garages) do
            local takeDist = #(pos - vector3(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z))
            if takeDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        DrawText3Ds(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                        if IsControlJustPressed(0, 38) then
                            MenuGarage()
                            currentGarage = k
                        end
                    else
                        DrawText3Ds(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, Garages[k].label)
                    end
                end
                if takeDist >= 4 then
                    closeMenuFull()
                end
            end
            local putDist = #(pos - vector3(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z))
            if putDist <= 25 and IsPedInAnyVehicle(ped) then
                inGarageRange = true
                DrawMarker(2, Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                if putDist <= 1.5 then
                    DrawText3Ds(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z + 0.5, '~g~E~w~ - Park Vehicle')
                    if IsControlJustPressed(0, 38) then
                        local curVeh = GetVehiclePedIsIn(ped)
                        local plate = ProjectRP.Functions.GetPlate(curVeh)
                        ProjectRP.Functions.TriggerCallback('prp-garage:server:checkVehicleOwner', function(owned)
                            if owned then
                                local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                local totalFuel = exports['prp-fuel']:GetFuel(curVeh)
                                local vehProperties = ProjectRP.Functions.GetVehicleProperties(curVeh)
                                CheckPlayers(curVeh)
                                TriggerServerEvent('prp-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, k)
                                TriggerServerEvent('prp-garage:server:updateVehicleState', 1, plate, k)
                                TriggerServerEvent('prp-vehicletuning:server:SaveVehicleProps', vehProperties)
                                if plate then
                                    OutsideVehicles[plate] = veh
                                    TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                end
                                ProjectRP.Functions.Notify("Vehicle Parked", "primary", 4500)
                            else
                                ProjectRP.Functions.Notify("Vehicle not owned", "error", 3500)
                            end
                        end, plate)
                    end
                end
            end
        end
        if not inGarageRange then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if PlayerGang.name then Name = PlayerGang.name end
         for k, v in pairs(GangGarages) do
            if PlayerGang.name == GangGarages[k].job then
                local takeDist = #(pos - vector3(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z))
                if takeDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if takeDist <= 1.5 then
                        if not IsPedInAnyVehicle(ped) then
                            DrawText3Ds(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                            if IsControlJustPressed(0, 38) then
                                GangMenuGarage()
                                currentGarage = Name
                            end
                        else
                            DrawText3Ds(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, GangGarages[Name].label)
                        end
                    end
                    if takeDist >= 4 then
                        closeMenuFull()
                    end
                end
                local putDist = #(pos - vector3(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z))
                if putDist <= 25 and IsPedInAnyVehicle(ped) then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if putDist <= 1.5 then
                        DrawText3Ds(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z + 0.5, '~g~E~w~ - Park Vehicle')
                        if IsControlJustPressed(0, 38) then
                            local curVeh = GetVehiclePedIsIn(ped)
                            local plate = ProjectRP.Functions.GetPlate(curVeh)
                            ProjectRP.Functions.TriggerCallback('prp-garage:server:checkVehicleOwner', function(owned)
                                if owned then
                                    local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                    local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                    local totalFuel = exports['prp-fuel']:GetFuel(curVeh)
                                    local vehProperties = ProjectRP.Functions.GetVehicleProperties(curVeh)
                                    CheckPlayers(curVeh)
                                    Wait(500)
                                    if DoesEntityExist(curVeh) then
                                        ProjectRP.Functions.Notify("Vehicle not stored, please check if is someone inside the car.", "error", 4500)
                                    else
                                    TriggerServerEvent('prp-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, Name)
                                    TriggerServerEvent('prp-garage:server:updateVehicleState', 1, plate, Name)
                                    TriggerServerEvent('prp-vehicletuning:server:SaveVehicleProps', vehProperties)
                                    if plate then
                                        OutsideVehicles[plate] = veh
                                        TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                    end
                                    ProjectRP.Functions.Notify("Vehicle Parked", "primary", 4500)
                                end
                                else
                                    ProjectRP.Functions.Notify("Vehicle not owned", "error", 3500)
                                end
                            end, plate)
                        end
                    end
                end
            end
        end
        if not inGarageRange then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if PlayerJob.name then Name = PlayerJob.name end
         for k, v in pairs(JobGarages) do
            if PlayerJob.name == JobGarages[k].job then
                local takeDist = #(pos - vector3(JobGarages[Name].takeVehicle.x, JobGarages[Name].takeVehicle.y, JobGarages[Name].takeVehicle.z))
                if takeDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2, JobGarages[Name].takeVehicle.x, JobGarages[Name].takeVehicle.y, JobGarages[Name].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if takeDist <= 1.5 then
                        if not IsPedInAnyVehicle(ped) then
                            DrawText3Ds(JobGarages[Name].takeVehicle.x, JobGarages[Name].takeVehicle.y, JobGarages[Name].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                            if IsControlJustPressed(0, 38) then
                                JobMenuGarage()
                                currentGarage = Name
                            end
                        else
                            DrawText3Ds(JobGarages[Name].takeVehicle.x, JobGarages[Name].takeVehicle.y, JobGarages[Name].takeVehicle.z, JobGarages[Name].label)
                        end
                    end
                    if takeDist >= 4 then
                        closeMenuFull()
                    end
                end
                local putDist = #(pos - vector3(JobGarages[Name].putVehicle.x, JobGarages[Name].putVehicle.y, JobGarages[Name].putVehicle.z))
                if putDist <= 25 and IsPedInAnyVehicle(ped) then
                    inGarageRange = true
                    DrawMarker(2, JobGarages[Name].putVehicle.x, JobGarages[Name].putVehicle.y, JobGarages[Name].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if putDist <= 1.5 then
                        DrawText3Ds(JobGarages[Name].putVehicle.x, JobGarages[Name].putVehicle.y, JobGarages[Name].putVehicle.z + 0.5, '~g~E~w~ - Park Vehicle')
                        if IsControlJustPressed(0, 38) then
                            local curVeh = GetVehiclePedIsIn(ped)
                            local plate = ProjectRP.Functions.GetPlate(curVeh)
                            ProjectRP.Functions.TriggerCallback('prp-garage:server:checkVehicleOwner', function(owned)
                                if owned then
                                    local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                    local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                    local totalFuel = exports['prp-fuel']:GetFuel(curVeh)
                                    local vehProperties = ProjectRP.Functions.GetVehicleProperties(curVeh)
                                    CheckPlayers(curVeh)
                                    Wait(500)
                                    if DoesEntityExist(curVeh) then
                                        ProjectRP.Functions.Notify("Vehicle not stored, please check if is someone inside the car.", "error", 4500)
                                    else
                                    TriggerServerEvent('prp-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, Name)
                                    TriggerServerEvent('prp-garage:server:updateVehicleState', 1, plate, Name)
                                    TriggerServerEvent('prp-vehicletuning:server:SaveVehicleProps', vehProperties)
                                    if plate then
                                        OutsideVehicles[plate] = veh
                                        TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                    end
                                    ProjectRP.Functions.Notify("Vehicle Parked", "primary", 4500)
                                end
                                else
                                    ProjectRP.Functions.Notify("Vehicle not owned", "error", 3500)
                                end
                            end, plate)
                        end
                    end
                end
            end
        end
        if not inGarageRange then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        sleep = 1000
        if LocalPlayer.state['isLoggedIn'] then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            inGarageRange = false
            if HouseGarages and currentHouseGarage then
                if hasGarageKey and HouseGarages[currentHouseGarage] and HouseGarages[currentHouseGarage].takeVehicle and HouseGarages[currentHouseGarage].takeVehicle.x then
                    local takehouseDist = #(pos - vector3(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z))
                    if takehouseDist <= 15 then
                        sleep = 5
                        inGarageRange = true
                        DrawMarker(2, HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if takehouseDist < 2.0 then
                            if not IsPedInAnyVehicle(ped) then
                                DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                                if IsControlJustPressed(0, 38) then
                                    MenuHouseGarage(currentHouseGarage)

                                end
                            elseif IsPedInAnyVehicle(ped) then
                                DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - To Park')
                                if IsControlJustPressed(0, 38) then
                                    local curVeh = GetVehiclePedIsIn(ped)
                                    local plate = ProjectRP.Functions.GetPlate(curVeh)
                                    ProjectRP.Functions.TriggerCallback('prp-garage:server:checkVehicleHouseOwner', function(owned)
                                        if owned then
                                            local bodyDamage = round(GetVehicleBodyHealth(curVeh), 1)
                                            local engineDamage = round(GetVehicleEngineHealth(curVeh), 1)
                                            local totalFuel = exports['prp-fuel']:GetFuel(curVeh)
                                            local vehProperties = ProjectRP.Functions.GetVehicleProperties(curVeh)
                                                CheckPlayers(curVeh)
                                            if DoesEntityExist(curVeh) then
                                                    ProjectRP.Functions.Notify("The Vehicle wasn't deleted, please check if is someone inside the car.", "error", 4500)
                                            else
                                            TriggerServerEvent('prp-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, currentHouseGarage)
                                            TriggerServerEvent('prp-garage:server:updateVehicleState', 1, plate, currentHouseGarage)
                                            TriggerServerEvent('prp-vehicletuning:server:SaveVehicleProps', vehProperties)
                                            ProjectRP.Functions.DeleteVehicle(curVeh)
                                            if plate then
                                                OutsideVehicles[plate] = veh
                                                TriggerServerEvent('prp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                            end
                                            ProjectRP.Functions.Notify("Vehicle Parked", "primary", 4500)
                                        end
                                        else
                                            ProjectRP.Functions.Notify("Vehicle not owned", "error", 3500)
                                        end

                                    end, plate, currentHouseGarage)
                                end
                            end
                        end
                        if takehouseDist > 1.99 then
                            closeMenuFull()
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


RegisterNetEvent("Axel:Impound")
AddEventHandler("Axel:Impound", function()
    MenuDepot()
end)
-- CreateThread(function()
--     Wait(1000)
--     while true do
--         Wait(5)
--         local ped = PlayerPedId()
--         local pos = GetEntityCoords(ped)
--         local inGarageRange = false
--         for k, v in pairs(Depots) do
--             local depottakeDist = #(pos - vector3(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z))
--             if depottakeDist <= 15 then
--                 inGarageRange = true
--                 DrawMarker(2, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
--                 if depottakeDist <= 1.5 then
--                     if not IsPedInAnyVehicle(ped) then
--                         DrawText3Ds(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
--                         if IsControlJustPressed(0, 38) then
--                             MenuDepot()
--                             currentGarage = k
--                         end
--                     end
--                 end
--                 if depottakeDist >= 4 then
--                     closeMenuFull()
--                 end
--             end
--         end
--         if not inGarageRange then
--             Wait(5000)
--         end
--     end
-- end)


Citizen.CreateThread(function()

    towtruckBlip = AddBlipForCoord(-189.4412, -1170.3667, 23.1638)
    SetBlipAsFriendly(towtruckBlip, true)
    SetBlipSprite(towtruckBlip, 498)
    SetBlipColour(towtruckBlip, 30)
    SetBlipScale(towtruckBlip, 0.8)
    SetBlipAsShortRange(towtruckBlip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring("Tow Truck HQ"))
    EndTextCommandSetBlipName(towtruckBlip)

end)

CreateThread(function()
    for k, v in pairs(Garages) do
        if v.showBlip then
            local Garage = AddBlipForCoord(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z)
            SetBlipSprite (Garage, 357)
            SetBlipDisplay(Garage, 4)
            SetBlipScale  (Garage, 0.65)
            SetBlipAsShortRange(Garage, true)
            SetBlipColour(Garage, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Garages[k].label)
            EndTextCommandSetBlipName(Garage)
        end
    end

    -- for k, v in pairs(Depots) do
    --     if v.showBlip then
    --         local Depot = AddBlipForCoord(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z)
    --         SetBlipSprite (Depot, 68)
    --         SetBlipDisplay(Depot, 4)
    --         SetBlipScale  (Depot, 0.7)
    --         SetBlipAsShortRange(Depot, true)
    --         SetBlipColour(Depot, 5)
    --         BeginTextCommandSetBlipName("STRING")
    --         AddTextComponentSubstringPlayerName(Depots[k].label)
    --         EndTextCommandSetBlipName(Depot)
    --     end
    -- end
end)
