local ProjectRP = exports['prp-core']:GetCoreObject()

onDuty = false
hasCar = false
working = false
hasWashed = false
hasBox = false
local done, AmountPayout = 0, 0
local Plate = nil
local PlayerData = {}
local Marker = false

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

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
        local sleep = 500

        if PlayerData.job ~= nil and PlayerData.job.name == 'fruitpicker' then
            if not onDuty then
                if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 10) then
                    sleep = 4
                    DrawMarker(2, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 1.5) then
                        sleep = 4
                        DrawText3D(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z + 0.4, '~g~[E]~s~ - Change into work clothes')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not InVehicle then
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
                                exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You started work!", timeout = 3000})
                                onDuty = true
                                blips()
                            else
                                exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
                            end
                        end
                    end
                end
            elseif onDuty then
                if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 10) then
                    sleep = 4
                    DrawMarker(2, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 1.5) then
                        sleep = 4
                        DrawText3D(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z + 0.4, '~r~[E]~s~ - Change into citizen clothes')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not InVehicle then
                                exports.rprogress:Custom({
                                    Duration = 2500,
                                    Label = "You're changing your clothes...",
                                    Animation = {
                                        scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
                                        animationDictionary = "idle_a", -- https://alexguirre.github.io/animations-list/
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
                                exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You finished work!", timeout = 3000})
                                onDuty = false
                                working = false
                                hasWashed = false
                                hasBox = false
                                hasCar = false
                                done = 0
                                AmountPayout = 0
                                RemoveBlip(blip1)
                                RemoveBlip(blip2)
                                RemoveBlip(blip3)
                                for i, v in ipairs(Config.OrangeSpots) do
                                    RemoveBlip(v.blip)
                                    v.taked = true
                                end
                                for i, v in ipairs(Config.AppleSpots) do
                                    RemoveBlip(v.blip)
                                    v.taked = true
                                end
                                for i, v in ipairs(Config.StrawberrySpots) do
                                    RemoveBlip(v.blip)
                                    v.taked = true
                                end
                                
                            else
                                exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
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
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)

        if PlayerData.job ~= nil and PlayerData.job.name == 'fruitpicker' then
            if onDuty then
                if (GetDistanceBetweenCoords(pos, Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z, true) < 10) then
                    sleep = 4
                    DrawMarker(2, Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z, true) < 2.5) then
                        sleep = 4
                        if InVehicle then
                            sleep = 4
                            DrawText3D(Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z + 0.4, '~r~[E]~s~ - Return vehicle')
                            if IsControlJustReleased(0, Keys["E"]) then
                                if hasCar then
                                    DepositBack()
                                    exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>You received ' ..Config.DepositPrice.. '$ for returning the vehicle', timeout = 1500})
                                    working = false
                                    hasCar = false
                                    Plate = nil
                                    TriggerServerEvent('prp-fruitpicker:depositBack', source)
                                    for i, v in ipairs(Config.OrangeSpots) do
                                        RemoveBlip(v.blip)
                                        v.taked = true
                                    end
                                    for i, v in ipairs(Config.AppleSpots) do
                                        RemoveBlip(v.blip)
                                        v.taked = true
                                    end
                                    for i, v in ipairs(Config.StrawberrySpots) do
                                        RemoveBlip(v.blip)
                                        v.taked = true
                                    end
                                else
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You haven't paid deposit for this vehicle", timeout = 1500})
                                end
                            end
                        elseif not InVehicle then
                            sleep = 4
                            DrawText3D(Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z + 0.4, '~g~[E]~s~ - Take out vehicle')
                            if IsControlJustReleased(0, Keys["E"]) then
                                ProjectRP.Functions.TriggerCallback('prp-fruitpicker:checkMoney', function(hasMoney)
                                    if hasMoney then
                                        ProjectRP.Functions.SpawnVehicle(Config.CarModelName, function(vehicle)
                                            SetEntityHeading(vehicle, Config.Locations["cardeposit"].coords.h)                                      
                                            SetVehicleNumberPlateText(vehicle, "FRT"..tostring(math.random(1000, 9999)))
                                            TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(vehicle))	
                                            TaskWarpPedIntoVehicle(ped, vehicle, -1)
                                            SetVehicleEngineOn(vehicle, true, true)
                                            exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>You paid ' ..Config.DepositPrice.. '$ to take out the vehicle', timeout = 1500})
                                            Plate = GetVehicleNumberPlateText(vehicle)
                                            hasCar = true
                                            working = true
                                            BlipsWorking()
                                            for i, v in ipairs(Config.OrangeSpots) do
                                                v.taked = false
                                            end
                                            for i, v in ipairs(Config.AppleSpots) do
                                                v.taked = false
                                            end
                                            for i, v in ipairs(Config.StrawberrySpots) do
                                                v.taked = false
                                            end                                           
                                        end, Config.Locations["cardeposit"].coords, true)
                                    else
                                        exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You don't have enough money", timeout = 1500})
                                    end
                                end)
                            end
                        end
                    end
                end
            end
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
                    local x,y,z = table.unpack(GetEntityCoords(ped))
                    local animbasket = "anim@heists@box_carry@"
                    local object = 'prop_fruit_basket'
                if working then
                    if not InVehicle then
                        if Plate == GetVehicleNumberPlateText(vehicle) then
                            sleep = 4
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -1.5, 0)
                                if not hasBox then
                                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 then
                                        sleep = 4
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~g~[E]~s~ - Take out basket")
                                        if IsControlJustReleased(0, Keys["E"]) then
                                            sleep = 20
                                            TaskPlayAnim(ped, animbasket, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0)
                                            basket = CreateObject(GetHashKey(object), pos.x, pos.y, pos.z,  true,  true, true)
                                            AttachEntityToEntity(basket, ped, GetPedBoneIndex(ped, 28422), 0.22+0.05, -0.3+0.25, 0.0+0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                            hasBox = true
                                        end
                                    end
                                elseif hasBox then
                                    sleep = 3
                                    DisableControlAction(0,23,true) -- DISABLE EXIT/ENTER VEHICLE
                                    sleep = 4
                                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 then
                                        sleep = 4
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~r~[E]~s~ - Put in basket")
                                        if IsControlJustReleased(0, Keys["E"]) then
                                            sleep = 20
                                            ClearPedTasks(GetPlayerPed(-1))
                                            TaskPlayAnim(ped, animbasket, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
                                            DeleteEntity(basket)
                                            hasBox = false
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
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
        local object = 'prop_fruit_basket'

        if PlayerData.job ~= nil and PlayerData.job.name == 'fruitpicker' then
            if working then
                for i, v in ipairs(Config.OrangeSpots) do
                    if not v.taked then
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 3 then
                            sleep = 4
                            DrawText3D(v.x, v.y, v.z + 0.4, '~g~[E]~s~ - Pick oranges')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if not InVehicle then
                                    if hasBox then
                                        RequestAnimDict("amb@prop_human_movie_bulb@idle_a")
                                        while (not HasAnimDictLoaded("amb@prop_human_movie_bulb@idle_a")) do
                                            Citizen.Wait(7)
                                        end                                       
                                        TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@idle_a', 'idle_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        
                                        exports.rprogress:Custom({
                                            Duration = 5500,
                                            Label = "Picking oranges...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(5500)
                                        ClearPedTasks(ped)
                                        done = done + 1
                                        v.taked = true
                                        RemoveBlip(v.blip)
                                        if done == 12 then
                                            exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>You picked up all the fruit from the orchard, wash it now', timeout = 5000})
                                            SetNewWaypoint(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z)
                                        end
                                    else
                                        exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You don't have a basket", timeout = 3000})
                                    end
                                else
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
                                end
                            end
                        end
                    end
                end
                for i, v in ipairs(Config.AppleSpots) do
                    if not v.taked then
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 3 then
                            sleep = 4
                            DrawText3D(v.x, v.y, v.z + 0.4, '~g~[E]~s~ - Pick apples')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if not InVehicle then
                                    if hasBox then
                                        RequestAnimDict("amb@prop_human_movie_bulb@idle_a")
                                        while (not HasAnimDictLoaded("amb@prop_human_movie_bulb@idle_a")) do
                                            Citizen.Wait(7)
                                        end 
                                        TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@idle_a', 'idle_a', 8.0, -8.0, -1, 2, 0, false, false, false)

                                        exports.rprogress:Custom({
                                            Duration = 5500,
                                            Label = "Picking apples...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(5500)
                                        ClearPedTasks(ped)
                                        done = done + 1
                                        v.taked = true
                                        RemoveBlip(v.blip)
                                        if done == 12 then
                                            exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>You picked up all the fruit from the orchard, wash it now', timeout = 5000})
                                            SetNewWaypoint(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z)
                                        end
                                    else
                                        exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You don't have a basket", timeout = 3000})
                                    end
                                else
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
                                end
                            end
                        end
                    end
                end
                for i, v in ipairs(Config.StrawberrySpots) do
                    if not v.taked then
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 3 then
                            sleep = 4
                            DrawText3D(v.x, v.y, v.z + 0.4, '~g~[E]~s~ - Pick strawberries')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if not InVehicle then
                                    if hasBox then
                                        DeleteEntity(basket)
                                        RequestAnimDict("amb@world_human_gardener_plant@male@enter")
                                        while (not HasAnimDictLoaded("amb@world_human_gardener_plant@male@enter")) do
                                            Citizen.Wait(7)
                                        end 
                                        TaskPlayAnim(PlayerPedId(), 'amb@world_human_gardener_plant@male@enter', 'enter', 8.0, -8.0, -1, 2, 0, false, false, false)

                                        exports.rprogress:Custom({
                                            Duration = 5500,
                                            Label = "Picking strawberries...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(5500)
                                        basket = CreateObject(GetHashKey(object), pos.x, pos.y, pos.z,  true,  true, true)
                                        AttachEntityToEntity(basket, ped, GetPedBoneIndex(ped, 28422), 0.22+0.05, -0.3+0.25, 0.0+0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                        ClearPedTasks(ped)
                                        done = done + 1
                                        v.taked = true
                                        RemoveBlip(v.blip)
                                        if done == 12 then
                                            exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>You picked up all the fruit from the orchard, wash it now', timeout = 5000})
                                            SetNewWaypoint(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z)
                                        end
                                    else
                                        exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You don't have a basket", timeout = 3000})
                                    end
                                else
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
                                end
                            end
                        end
                    end
                end
                sleep = 4
                if (GetDistanceBetweenCoords(pos, Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z, true) < 10) then
                    sleep = 4
                    DrawMarker(2, Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z, true) < 2.5) then
                        sleep = 4
                        DrawText3D(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z + 0.4, '~g~[E]~s~ - Wash fruits')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if done == 12 then
                                if not InVehicle then
                                    if hasBox then
                                        if not hasWashed then
                                            DoScreenFadeOut(800)
                                            Citizen.Wait(800)
                                            exports.rprogress:Custom({
                                                Duration = 25000,
                                                Label = "Washing the fruits...",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(25000)
                                            hasWashed = true
                                            DoScreenFadeIn(800)
                                            Citizen.Wait(800)
                                            exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>Your fruit is ready to sell, go to the store', timeout = 5000})
                                            SetNewWaypoint(Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z)
                                        elseif hasWashed then
                                            exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Your fruit is already washed", timeout = 3000})
                                        end
                                    else
                                        exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You don't have a basket", timeout = 3000})
                                    end
                                else
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
                                end
                            else
                                exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You haven't picked up all the fruit from the orchard!", timeout = 3000})
                            end
                        end
                    end
                end
                sleep = 4
                if (GetDistanceBetweenCoords(pos, Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z, true) < 10) then
                    sleep = 4
                    DrawMarker(2, Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z, true) < 2.5) then
                        sleep = 4
                        DrawText3D(Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z + 0.4, '~g~[E]~s~ - Sell fruit')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not InVehicle then
                                if hasBox then
                                    if hasWashed then
                                        ClearPedTasks(ped)
                                        TaskPlayAnim(ped, 'anim@heists@box_carry@', "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
                                        DeleteEntity(basket)
                                        RequestAnimDict("mp_common")
                                        while (not HasAnimDictLoaded("mp_common")) do
                                            Citizen.Wait(7)
                                        end
                                        TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)

                                        exports.rprogress:Custom({
                                            Duration = 4000,
                                            Label = "Selling fruit...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(4000)
                                        ClearPedTasks(ped)
                                        AmountPayout = AmountPayout + 1
                                        TriggerServerEvent('prp-fruitpicker:Payout', AmountPayout)
                                        exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You earned " ..Config.Payout.. "$", timeout = 3000})
                                        done = 0
                                        AmountPayout = 0
                                        hasWashed = false
                                        hasBox = false
                                        for i, v in ipairs(Config.OrangeSpots) do
                                            v.taked = false
                                        end
                                        for i, v in ipairs(Config.AppleSpots) do
                                            v.taked = false
                                        end
                                        for i, v in ipairs(Config.StrawberrySpots) do
                                            v.taked = false
                                        end
                                        BlipsWorking()
                                    else
                                        exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>Your fruits are not washed!', timeout = 3000})
                                    end
                                else
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>You don't have a basket", timeout = 3000})
                                end
                            else
                                exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>Leave the vehicle!", timeout = 1500})
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- MAIN BLIP
Citizen.CreateThread(function()
        local coordsm = Config.Locations["main"].coords
        local namem = Config.Locations["main"].label
        blip = AddBlipForCoord(coordsm.x, coordsm.y, coordsm.z)
        SetBlipSprite(blip, 285)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(namem)
        EndTextCommandSetBlipName(blip)
end)
-- ONDUTY BLIP
function blips()
        local coordsc = Config.Locations["cardeposit"].coords
        local namec = Config.Locations["cardeposit"].label
        blip1 = AddBlipForCoord(coordsc.x, coordsc.y, coordsc.z)
        SetBlipSprite(blip1, 285)
        SetBlipDisplay(blip1, 4)
        SetBlipScale(blip1, 0.6)
        SetBlipAsShortRange(blip1, true)
        SetBlipColour(blip1, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(namec)
        EndTextCommandSetBlipName(blip1)

        local coordst = Config.Locations["transformfruit"].coords
        local namet = Config.Locations["transformfruit"].label
        blip2 = AddBlipForCoord(coordst.x, coordst.y, coordst.z)
        SetBlipSprite(blip2, 285)
        SetBlipDisplay(blip2, 4)
        SetBlipScale(blip2, 0.6)
        SetBlipAsShortRange(blip2, true)
        SetBlipColour(blip2, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(namet)
        EndTextCommandSetBlipName(blip2)
        
        local sell = Config.Locations["sellfruit"].coords
        local names = Config.Locations["sellfruit"].label
        blip3 = AddBlipForCoord(sell.x, sell.y, sell.z)
        SetBlipSprite(blip3, 285)
        SetBlipDisplay(blip3, 4)
        SetBlipScale(blip3, 0.6)
        SetBlipAsShortRange(blip3, true)
        SetBlipColour(blip3, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(names)
        EndTextCommandSetBlipName(blip3)
end

-- WORKING BLIPS
function BlipsWorking()
    for i, v in ipairs(Config.OrangeSpots) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 47)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Oranges Orchard')
        EndTextCommandSetBlipName(v.blip)
    end

    for i, v in ipairs(Config.AppleSpots) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 69)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Apples Orchard')
        EndTextCommandSetBlipName(v.blip)
    end

    for i, v in ipairs(Config.StrawberrySpots) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 49)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Strawberries Orchard')
        EndTextCommandSetBlipName(v.blip)
    end
end

function DepositBack()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    ProjectRP.Functions.DeleteVehicle(vehicle)
    hasCar = false
end

function DrawText3D(x, y, z, text)
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


