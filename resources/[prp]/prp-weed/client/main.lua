local isLoggedIn = true
local housePlants = {}
local insideHouse = false
local currentHouse = nil

DrawText3Ds = function(x, y, z, text)
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

RegisterNetEvent('prp-weed:client:getHousePlants')
AddEventHandler('prp-weed:client:getHousePlants', function(house)    
    ProjectRP.Functions.TriggerCallback('prp-weed:server:getBuildingPlants', function(plants)
        currentHouse = house
        housePlants[currentHouse] = plants
        insideHouse = true
        spawnHousePlants()
    end, house)
end)

function spawnHousePlants()
    Citizen.CreateThread(function()
        if not plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    ["plantProp"] = GetHashKey(PRPWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                }

                plantProp = CreateObject(plantData["plantProp"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                while not plantProp do Wait(0) end
                PlaceObjectOnGroundProperly(plantProp)
                Wait(100)
                FreezeEntityPosition(plantProp, true)
                SetEntityAsMissionEntity(plantProp, false, false)
            end
            plantSpawned = true
        end
    end)
end

function despawnHousePlants()
    Citizen.CreateThread(function()
        if plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                }

                for _, stage in pairs(PRPWeed.Plants[housePlants[currentHouse][k].sort]["stages"]) do
                    local closestPlant = GetClosestObjectOfType(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 3.5, GetHashKey(stage), false, false, false)
                    if closestPlant ~= 0 then                    
                        DeleteObject(closestPlant)
                    end
                end
            end
            plantSpawned = false
        end
    end)
end

local ClosestTarget = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if insideHouse then
            if plantSpawned then
                local ped = PlayerPedId()
                for k, v in pairs(housePlants[currentHouse]) do
                    local gender = "M"
                    if housePlants[currentHouse][k].gender == "woman" then gender = "F" end

                    local plantData = {
                        ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                        ["plantStage"] = housePlants[currentHouse][k].stage,
                        ["plantProp"] = GetHashKey(PRPWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                        ["plantSort"] = {
                            ["name"] = housePlants[currentHouse][k].sort,
                            ["label"] = PRPWeed.Plants[housePlants[currentHouse][k].sort]["label"],
                        },
                        ["plantStats"] = {
                            ["food"] = housePlants[currentHouse][k].food,
                            ["health"] = housePlants[currentHouse][k].health,
                            ["progress"] = housePlants[currentHouse][k].progress,
                            ["stage"] = housePlants[currentHouse][k].stage,
                            ["highestStage"] = PRPWeed.Plants[housePlants[currentHouse][k].sort]["highestStage"],
                            ["gender"] = gender,
                            ["plantId"] = housePlants[currentHouse][k].plantid,
                        }
                    }

                    local plyDistance = #(GetEntityCoords(ped) - vector3(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"]))

                    if plyDistance < 0.8 then

                        ClosestTarget = k
                        if plantData["plantStats"]["health"] > 0 then
                            if plantData["plantStage"] ~= plantData["plantStats"]["highestStage"] then
                                DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Sort: '..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | Nutrition: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Health: ~b~'..plantData["plantStats"]["health"]..'%')
                            else
                                DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"] + 0.2, "Press ~g~ E ~w~ to harvest plant.")
                                DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Sort: ~g~'..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | Nutrition: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Health: ~b~'..plantData["plantStats"]["health"]..'%')
                                if IsControlJustPressed(0, 38) then
                                    ProjectRP.Functions.Progressbar("remove_weed_plant", "Harvesting Plant", 8000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "amb@world_human_gardener_plant@male@base",
                                        anim = "base",
                                        flags = 16,
                                    }, {}, {}, function() -- Done
                                        ClearPedTasks(ped)
                                        if plantData["plantStats"]["gender"] == "M" then
                                            amount = math.random(1, 2)
                                        else
                                            amount = math.random(1, 6)
                                        end
                                        TriggerServerEvent('prp-weed:server:harvestPlant', currentHouse, amount, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                                    end, function() -- Cancel
                                        ClearPedTasks(ped)
                                        ProjectRP.Functions.Notify("Process Canceled", "error")
                                    end)
                                end
                            end
                        elseif plantData["plantStats"]["health"] == 0 then
                            DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'The plant has died. Press ~r~ E ~w~ to remove plant.')
                            if IsControlJustPressed(0, 38) then
                                ProjectRP.Functions.Progressbar("remove_weed_plant", "Removing The Plant", 8000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "amb@world_human_gardener_plant@male@base",
                                    anim = "base",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('prp-weed:server:removeDeathPlant', currentHouse, plantData["plantStats"]["plantId"])
                                end, function() -- Cancel
                                    ClearPedTasks(ped)
                                    ProjectRP.Functions.Notify("Process Canceled", "error")
                                end)
                            end
                        end
                    end
                end
            end
        end

        if not insideHouse then
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('prp-weed:client:leaveHouse')
AddEventHandler('prp-weed:client:leaveHouse', function()
    despawnHousePlants()
    SetTimeout(1000, function()
        if currentHouse ~= nil then
            insideHouse = false
            housePlants[currentHouse] = nil
            currentHouse = nil
        end
    end)
end)

RegisterNetEvent('prp-weed:client:refreshHousePlants')
AddEventHandler('prp-weed:client:refreshHousePlants', function(house)
    if currentHouse ~= nil and currentHouse == house then
        despawnHousePlants()
        SetTimeout(500, function()
            ProjectRP.Functions.TriggerCallback('prp-weed:server:getBuildingPlants', function(plants)
                currentHouse = house
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, house)
        end)
    end
end)

RegisterNetEvent('prp-weed:client:refreshPlantStats')
AddEventHandler('prp-weed:client:refreshPlantStats', function()
    if insideHouse then
        despawnHousePlants()
        SetTimeout(500, function()
            ProjectRP.Functions.TriggerCallback('prp-weed:server:getBuildingPlants', function(plants)
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, currentHouse)
        end)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

RegisterNetEvent('prp-weed:client:placePlant')
AddEventHandler('prp-weed:client:placePlant', function(type, item)
    local ped = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, 0)
    local plantData = {
        ["plantCoords"] = {["x"] = plyCoords.x, ["y"] = plyCoords.y, ["z"] = plyCoords.z},
        ["plantModel"] = PRPWeed.Plants[type]["stages"]["stage-a"],
        ["plantLabel"] = PRPWeed.Plants[type]["label"]
    }
    local ClosestPlant = 0
    for k, v in pairs(PRPWeed.Props) do
        if ClosestPlant == 0 then
            ClosestPlant = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 0.8, GetHashKey(v), false, false, false)
        end
    end

    if currentHouse ~= nil then
        if ClosestPlant == 0 then
            ProjectRP.Functions.Progressbar("plant_weed_plant", "Planting", 8000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@world_human_gardener_plant@male@base",
                anim = "base",
                flags = 16,
            }, {}, {}, function() -- Done
                ClearPedTasks(ped)            
                TriggerServerEvent('prp-weed:server:placePlant', json.encode(plantData["plantCoords"]), type, currentHouse)
                TriggerServerEvent('prp-weed:server:removeSeed', item.slot, type)
            end, function() -- Cancel
                ClearPedTasks(ped)
                ProjectRP.Functions.Notify("Process canceled", "error")
            end)
        else
            ProjectRP.Functions.Notify("Can't place here", 'error', 3500)
        end
    else
        ProjectRP.Functions.Notify("It's not safe here, try your house", 'error', 3500)
    end
end)

RegisterNetEvent('prp-weed:client:foodPlant')
AddEventHandler('prp-weed:client:foodPlant', function(item)
    local plantData = {}
    if currentHouse ~= nil then
        if ClosestTarget ~= 0 then
            local ped = PlayerPedId()
            local gender = "M"
            if housePlants[currentHouse][ClosestTarget].gender == "woman" then 
                gender = "F" 
            end

            plantData = {
                ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).x, ["y"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).y, ["z"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).z},
                ["plantStage"] = housePlants[currentHouse][ClosestTarget].stage,
                ["plantProp"] = GetHashKey(PRPWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["stages"][housePlants[currentHouse][ClosestTarget].stage]),
                ["plantSort"] = {
                    ["name"] = housePlants[currentHouse][ClosestTarget].sort,
                    ["label"] = PRPWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["label"],
                },
                ["plantStats"] = {
                    ["food"] = housePlants[currentHouse][ClosestTarget].food,
                    ["health"] = housePlants[currentHouse][ClosestTarget].health,
                    ["progress"] = housePlants[currentHouse][ClosestTarget].progress,
                    ["stage"] = housePlants[currentHouse][ClosestTarget].stage,
                    ["highestStage"] = PRPWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["highestStage"],
                    ["gender"] = gender,
                    ["plantId"] = housePlants[currentHouse][ClosestTarget].plantid,
                }
            }
            local plyDistance = #(GetEntityCoords(ped) - vector3(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"]))

            if plyDistance < 1.0 then
                if plantData["plantStats"]["food"] == 100 then
                    ProjectRP.Functions.Notify('The Plant Does Not Need Nutrition', 'error', 3500)
                else
                    ProjectRP.Functions.Progressbar("plant_weed_plant", "Feeding Plant", math.random(4000, 8000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "timetable@gardener@filling_can",
                        anim = "gar_ig_5_filling_can",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(ped)
                        local newFood = math.random(40, 60)
                        TriggerServerEvent('prp-weed:server:foodPlant', currentHouse, newFood, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                    end, function() -- Cancel
                        ClearPedTasks(ped)
                        ProjectRP.Functions.Notify("Process Canceled", "error")
                    end)
                end
            else
                ProjectRP.Functions.Notify("Can't Place Here", "error")
            end
        else
            ProjectRP.Functions.Notify("Can't Place Here", "error")
        end
    end
end)
