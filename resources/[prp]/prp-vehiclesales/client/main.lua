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

local occasionVehicles = {}
local inRange
local vehiclesSpawned = false
local isConfirming = false

Citizen.CreateThread(function()
    while true do
        inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local price = nil
        if ProjectRP ~= nil then
            for _,slot in pairs(Config.OccasionSlots) do
                local dist = #(pos - slot.loc)

                if dist <= 40 then
                    inRange = true
                    if not vehiclesSpawned then
                        vehiclesSpawned = true

                        ProjectRP.Functions.TriggerCallback('prp-occasions:server:getVehicles', function(vehicles)
                            occasionVehicles = vehicles
                            despawnOccasionsVehicles()
                            spawnOccasionsVehicles(vehicles)
                        end)
                    end
                end
            end

            local sellBackDist = #(pos - Config.SellVehicleBack)

            if sellBackDist <= 13.0 and IsPedInAnyVehicle(ped) then
                DrawMarker(2, Config.SellVehicleBack.x, Config.SellVehicleBack.y, Config.SellVehicleBack.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.6, 255, 0, 0, 155, false, false, false, true, false, false, false)
                if sellBackDist <= 3.5 and IsPedInAnyVehicle(ped) then
                    local price
                    local sellVehData = {}
                    sellVehData.plate = ProjectRP.Functions.GetPlate(GetVehiclePedIsIn(ped))
                    sellVehData.model = GetEntityModel(GetVehiclePedIsIn(ped))
                        for k, v in pairs(ProjectRP.Shared.Vehicles) do
                            if tonumber(v["hash"]) == sellVehData.model then
                                sellVehData.price = tonumber(v["price"])
                            end
                        end
                    DrawText3Ds(Config.SellVehicleBack.x, Config.SellVehicleBack.y, Config.SellVehicleBack.z, '[~g~E~w~] - Sell Vehicle To Dealer For ~g~$'..math.floor(sellVehData.price / 2))
                    if IsControlJustPressed(0, 38) then
                        ProjectRP.Functions.TriggerCallback('prp-garage:server:checkVehicleOwner', function(owned)
                            if owned then
                                SellToDealer(sellVehData, GetVehiclePedIsIn(ped))
                            else
                                ProjectRP.Functions.Notify('This is not your vehicle..', 'error', 3500)
                            end
                        end, sellVehData.plate)
                    end
                end
            end

            if inRange then
                for i = 1, #Config.OccasionSlots, 1 do
                    local vehPos = GetEntityCoords(Config.OccasionSlots[i]["occasionid"])
                    local dstCheck = #(pos - vehPos)

                    if dstCheck <= 2 then
                        if not IsPedInAnyVehicle(ped) then
                            if not isConfirming then
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, '[~g~E~w~] - View Vehicle Contract')
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, ProjectRP.Shared.Vehicles[Config.OccasionSlots[i]["model"]]["name"]..', Price: ~g~$'..Config.OccasionSlots[i]["price"])
                                if Config.OccasionSlots[i]["owner"] == ProjectRP.Functions.GetPlayerData().citizenid then
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.05, '[~r~G~w~] - Cancel Vehicle Sale')
                                    if IsControlJustPressed(0, 47) then
                                        isConfirming = true
                                    end
                                end
                                if IsControlJustPressed(0, 38) then
                                    currentVehicle = i

                                    ProjectRP.Functions.TriggerCallback('prp-occasions:server:getSellerInformation', function(info)
                                        if info ~= nil then
                                            info.charinfo = json.decode(info.charinfo)
                                        else
                                            info = {}
                                            info.charinfo = {
                                                firstname = "not",
                                                lastname = "known",
                                                account = "Account not known..",
                                                phone = "telephone number not known.."
                                            }
                                        end

                                        openBuyContract(info, Config.OccasionSlots[currentVehicle])
                                    end, Config.OccasionSlots[currentVehicle]["owner"])
                                end
                            else
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, 'Are you sure you no longer want to sell your vehicle?')
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, '[~g~7~w~] - Yes | [~r~8~w~] - No')
                                if IsDisabledControlJustPressed(0, 161) then
                                    isConfirming = false
                                    currentVehicle = i
                                    TriggerServerEvent("prp-occasions:server:ReturnVehicle", Config.OccasionSlots[i])
                                end
                                if IsDisabledControlJustPressed(0, 162) then
                                    isConfirming = false
                                end
                            end
                        end
                    end
                end

                local sellDist = #(pos - Config.SellVehicle)

                if sellDist <= 13.0 and IsPedInAnyVehicle(ped) then
                    DrawMarker(2, Config.SellVehicle.x, Config.SellVehicle.y, Config.SellVehicle.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.6, 255, 0, 0, 155, false, false, false, true, false, false, false)
                    if sellDist <= 3.5 and IsPedInAnyVehicle(ped) then
                        DrawText3Ds(Config.SellVehicle.x, Config.SellVehicle.y, Config.SellVehicle.z, '[~g~E~w~] - Place Vehicle For Sale By Owner')
                        if IsControlJustPressed(0, 38) then
                            local VehiclePlate = ProjectRP.Functions.GetPlate(GetVehiclePedIsIn(ped))
                            ProjectRP.Functions.TriggerCallback('prp-garage:server:checkVehicleOwner', function(owned)
                                if owned then
                                    openSellContract(true)
                                else
                                    ProjectRP.Functions.Notify('This is not your vehicle..', 'error', 3500)
                                end
                            end, VehiclePlate)
                        end
                    end
                end
            end

            if not inRange then
                if vehiclesSpawned then
                    vehiclesSpawned = false
                    despawnOccasionsVehicles()
                end
                Citizen.Wait(1000)
            end
        end

        Citizen.Wait(3)
    end
end)

function SellToDealer(sellVehData, vehicleHash)
    -- Thread to handle confirmation question. Will only run until a decision
    -- is made of the distance to the checkpoint is too far
    Citizen.CreateThread(function()
        local keepGoing = true
        while keepGoing do
            local coords = GetEntityCoords(vehicleHash)
            DrawText3Ds(coords.x, coords.y, coords.z + 1.6, '~g~7~w~ - Confirm / ~r~8~w~ - Cancel ~g~') -- (coords, text, size, font)

            if IsDisabledControlJustPressed(0, 161) then
                TriggerServerEvent('prp-occasions:server:sellVehicleBack', sellVehData)
                ProjectRP.Functions.DeleteVehicle(vehicleHash)

                keepGoing = false
            end

            if IsDisabledControlJustPressed(0, 162) then
                keepGoing = false
            end

            if #(Config.SellVehicleBack - coords) > 3 then
                keepGoing = false
            end

            Citizen.Wait(0)
        end

    end)
end

function spawnOccasionsVehicles(vehicles)
    local oSlot = Config.OccasionSlots

    if vehicles ~= nil then
        for i = 1, #vehicles, 1 do
            local model = GetHashKey(vehicles[i].model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end

            oSlot[i]["occasionid"] = CreateVehicle(model, oSlot[i].loc.x, oSlot[i].loc.y, oSlot[i].loc.z, false, false)

            oSlot[i]["price"] = vehicles[i].price
            oSlot[i]["owner"] = vehicles[i].seller
            oSlot[i]["model"] = vehicles[i].model
            oSlot[i]["plate"] = vehicles[i].plate
            oSlot[i]["oid"]   = vehicles[i].occasionid
            oSlot[i]["desc"]  = vehicles[i].description
            oSlot[i]["mods"]  = vehicles[i].mods

            ProjectRP.Functions.SetVehicleProperties(oSlot[i]["occasionid"], json.decode(oSlot[i]["mods"]))

            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(oSlot[i]["occasionid"])
            SetEntityInvincible(oSlot[i]["occasionid"],true)
            SetEntityHeading(oSlot[i]["occasionid"], oSlot[i].h)
            SetVehicleDoorsLocked(oSlot[i]["occasionid"], 3)

            SetVehicleNumberPlateText(oSlot[i]["occasionid"], vehicles[i].occasionid)
            FreezeEntityPosition(oSlot[i]["occasionid"],true)
        end
    end
end

function despawnOccasionsVehicles()
    local oSlot = Config.OccasionSlots
    for i = 1, #Config.OccasionSlots, 1 do
        local loc = Config.OccasionSlots[i].loc
        local oldVehicle = GetClosestVehicle(loc.x, loc.y, loc.z, 1.3, 0, 70)
        if oldVehicle ~= 0 then
            ProjectRP.Functions.DeleteVehicle(oldVehicle)
        end
    end
end

function openSellContract(bool)
    local pData = ProjectRP.Functions.GetPlayerData()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "sellVehicle",
        bizName = Config.BusinessName,
        sellerData = {
            firstname = pData.charinfo.firstname,
            lastname = pData.charinfo.lastname,
            account = pData.charinfo.account,
            phone = pData.charinfo.phone
        },
        plate = ProjectRP.Functions.GetPlate(GetVehiclePedIsUsing(PlayerPedId()))
    })
end

function openBuyContract(sellerData, vehicleData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "buyVehicle",
        bizName = Config.BusinessName,
        sellerData = {
            firstname = sellerData.charinfo.firstname,
            lastname = sellerData.charinfo.lastname,
            account = sellerData.charinfo.account,
            phone = sellerData.charinfo.phone
        },
        vehicleData = {
            desc = vehicleData.desc,
            price = vehicleData.price
        },
        plate = vehicleData.plate
    })
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('buyVehicle', function(data, cb)
    local vehData = Config.OccasionSlots[currentVehicle]
    TriggerServerEvent('prp-occasions:server:buyVehicle', vehData)
    cb('ok')
end)

DoScreenFadeIn(250)

RegisterNetEvent('prp-occasions:client:BuyFinished')
AddEventHandler('prp-occasions:client:BuyFinished', function(vehdata)
    local vehmods = json.decode(vehdata.mods)

    DoScreenFadeOut(250)
    Citizen.Wait(500)
    ProjectRP.Functions.SpawnVehicle(vehdata.model, function(veh)
        SetVehicleNumberPlateText(veh, vehdata.plate)
        SetEntityHeading(veh, Config.BuyVehicle.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleFuelLevel(veh, 100)
        ProjectRP.Functions.Notify("Vehicle Bought", "success", 2500)
        TriggerEvent("vehiclekeys:client:SetOwner", vehdata.plate)
        SetVehicleEngineOn(veh, true, true)
        Citizen.Wait(500)
        ProjectRP.Functions.SetVehicleProperties(veh, vehmods)
    end, Config.BuyVehicle, true)
    Citizen.Wait(500)
    DoScreenFadeIn(250)
    currentVehicle = nil
end)

RegisterNetEvent('prp-occasions:client:ReturnOwnedVehicle')
AddEventHandler('prp-occasions:client:ReturnOwnedVehicle', function(vehdata)
    local vehmods = json.decode(vehdata.mods)
    DoScreenFadeOut(250)
    Citizen.Wait(500)
    ProjectRP.Functions.SpawnVehicle(vehdata.model, function(veh)
        SetVehicleNumberPlateText(veh, vehdata.plate)
        SetEntityHeading(veh, Config.BuyVehicle.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleFuelLevel(veh, 100)
        ProjectRP.Functions.Notify("You vehicle is returned")
        TriggerEvent("vehiclekeys:client:SetOwner", vehdata.plate)
        SetVehicleEngineOn(veh, true, true)
        Citizen.Wait(500)
        ProjectRP.Functions.SetVehicleProperties(veh, vehmods)
    end, Config.BuyVehicle, true)
    Citizen.Wait(500)
    DoScreenFadeIn(250)
    currentVehicle = nil
end)

RegisterNUICallback('sellVehicle', function(data, cb)
    local plate = ProjectRP.Functions.GetPlate(GetVehiclePedIsUsing(PlayerPedId())) --Getting the plate and sending to the function
    SellData(data,plate)
    cb('ok')
end)

function SellData(data,model)
    ProjectRP.Functions.TriggerCallback("prp-vehiclesales:server:CheckModelName",function(DataReturning)
        local vehicleData = {}
        local PlayerData = ProjectRP.Functions.GetPlayerData()
        vehicleData.ent = GetVehiclePedIsUsing(PlayerPedId())
        vehicleData.model = DataReturning
        vehicleData.plate = model
        vehicleData.mods = ProjectRP.Functions.GetVehicleProperties(vehicleData.ent)
        vehicleData.desc = data.desc
        TriggerServerEvent('prp-occasions:server:sellVehicle', data.price, vehicleData)
        sellVehicleWait(data.price)
    end,model) --the older function GetDisplayNameFromVehicleModel doest like long names like Washington or Buccanner2
end



function sellVehicleWait(price)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    ProjectRP.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
    Citizen.Wait(1500)
    DoScreenFadeIn(250)
    ProjectRP.Functions.Notify('Your car has been put up for sale! Price - $'..price, 'success')
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end

RegisterNetEvent('prp-occasion:client:refreshVehicles')
AddEventHandler('prp-occasion:client:refreshVehicles', function()
    if inRange then
        ProjectRP.Functions.TriggerCallback('prp-occasions:server:getVehicles', function(vehicles)
            occasionVehicles = vehicles
            despawnOccasionsVehicles()
            spawnOccasionsVehicles(vehicles)
        end)
    end
end)

Citizen.CreateThread(function()
    OccasionBlip = AddBlipForCoord(Config.SellVehicle.x, Config.SellVehicle.y, Config.SellVehicle.z)

    SetBlipSprite (OccasionBlip, 326)
    SetBlipDisplay(OccasionBlip, 4)
    SetBlipScale  (OccasionBlip, 0.75)
    SetBlipAsShortRange(OccasionBlip, true)
    SetBlipColour(OccasionBlip, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Used Vehicle Lot")
    EndTextCommandSetBlipName(OccasionBlip)
end)
