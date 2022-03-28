local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000
local choosingSpawn = false
local cam, cam2 = nil, nil
local ProjectRP = exports['prp-core']:GetCoreObject()

-- Functions

local function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

-- Events

RegisterNetEvent('prp-spawn:client:openUI', function(value)
    SetEntityVisible(PlayerPedId(), false)
    DoScreenFadeOut(250)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
    ProjectRP.Functions.GetPlayerData(function(PlayerData)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus1, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end)
    Citizen.Wait(500)
    SetDisplay(value)
end)

RegisterNetEvent('prp-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

RegisterNetEvent('prp-spawn:client:setupSpawns', function(cData, new, apps)
    if not new then
        ProjectRP.Functions.TriggerCallback('prp-spawn:server:getOwnedHouses', function(houses)
            local myHouses = {}
            if houses ~= nil then
                for i = 1, (#houses), 1 do
                    myHouses[#myHouses+1] = {
                        house = houses[i].house,
                        label = Config.Houses[houses[i].house].adress,
                    }
                end
            end

            Citizen.Wait(500)
            SendNUIMessage({
                action = "setupLocations",
                locations = PRP.Spawns,
                houses = myHouses,
            })
        end, cData.citizenid)
    elseif new then
        SendNUIMessage({
            action = "setupAppartements",
            locations = apps,
        })
    end
end)

-- NUI Callbacks

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

local cam = nil
local cam2 = nil

local function SetCam(campos)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Citizen.Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), campos.x, campos.y, campos.z)
end

RegisterNUICallback('setCam', function(data)
    local location = tostring(data.posname)
    local type = tostring(data.type)

    DoScreenFadeOut(200)
    Citizen.Wait(500)
    DoScreenFadeIn(200)

    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    if DoesCamExist(cam2) then
        DestroyCam(cam2, true)
    end

    if type == "current" then
        ProjectRP.Functions.GetPlayerData(function(PlayerData)
            SetCam(PlayerData.position)
        end)
    elseif type == "house" then
        SetCam(Config.Houses[location].coords.enter)
    elseif type == "normal" then
        SetCam(PRP.Spawns[location].coords)
    elseif type == "appartment" then
        SetCam(Apartments.Locations[location].coords.enter)
    end
end)

RegisterNUICallback('chooseAppa', function(data)
    local appaYeet = data.appType
    SetDisplay(false)
    DoScreenFadeOut(500)
    Citizen.Wait(5000)
    TriggerServerEvent("apartments:server:CreateApartment", appaYeet, Apartments.Locations[appaYeet].label)
    TriggerServerEvent('ProjectRP:Server:OnPlayerLoaded')
    TriggerEvent('ProjectRP:Client:OnPlayerLoaded')
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
end)

local function PreSpawnPlayer()
    SetDisplay(false)
    DoScreenFadeOut(500)
    Citizen.Wait(2000)
end

local function PostSpawnPlayer(ped)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerServerEvent('prp-walkstyles:server:walkstyles', 'get')
end

RegisterNUICallback('spawnplayer', function(data)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = PlayerPedId()
    local PlayerData = ProjectRP.Functions.GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]

    if type == "current" then
        PreSpawnPlayer()
        ProjectRP.Functions.GetPlayerData(function(PlayerData)
            SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityHeading(PlayerPedId(), PlayerData.position.a)
            FreezeEntityPosition(PlayerPedId(), false)
        end)

        if insideMeta.house ~= nil then
            local houseId = insideMeta.house
            TriggerEvent('prp-houses:client:LastLocationHouse', houseId)
        elseif insideMeta.apartment.apartmentType ~= nil or insideMeta.apartment.apartmentId ~= nil then
            local apartmentType = insideMeta.apartment.apartmentType
            local apartmentId = insideMeta.apartment.apartmentId
            TriggerEvent('prp-apartments:client:LastLocationHouse', apartmentType, apartmentId)
        end
        TriggerServerEvent('ProjectRP:Server:OnPlayerLoaded')
        TriggerEvent('ProjectRP:Client:OnPlayerLoaded')
        PostSpawnPlayer()
        TriggerServerEvent('prp-walkstyles:server:walkstyles', 'get')
    elseif type == "house" then
        PreSpawnPlayer()
        TriggerEvent('prp-houses:client:enterOwnedHouse', location)
        TriggerServerEvent('ProjectRP:Server:OnPlayerLoaded')
        TriggerEvent('ProjectRP:Client:OnPlayerLoaded')
        TriggerServerEvent('prp-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('prp-apartments:server:SetInsideMeta', 0, 0, false)
        PostSpawnPlayer()
        TriggerServerEvent('prp-walkstyles:server:walkstyles', 'get')
    elseif type == "normal" then
        local pos = PRP.Spawns[location].coords
        PreSpawnPlayer()
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        TriggerServerEvent('ProjectRP:Server:OnPlayerLoaded')
        TriggerEvent('ProjectRP:Client:OnPlayerLoaded')
        TriggerServerEvent('prp-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('prp-apartments:server:SetInsideMeta', 0, 0, false)
        Citizen.Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.w)
        PostSpawnPlayer()
        TriggerServerEvent('prp-walkstyles:server:walkstyles', 'get')
    end
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if choosingSpawn then
            DisableAllControlActions(0)
        else
            Citizen.Wait(1000)
        end
    end
end)
