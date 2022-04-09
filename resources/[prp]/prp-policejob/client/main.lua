-- Variables
ProjectRP = exports['prp-core']:GetCoreObject()
isHandcuffed = false
cuffType = 1
isEscorted = false
draggerId = 0
PlayerJob = {}
onDuty = false
local DutyBlips = {}

-- Functions


Citizen.CreateThread(function()
    local policeBlip = AddBlipForCoord(463.482, -986.370, 25.565)
    SetBlipAsFriendly(policeBlip, true)
    SetBlipSprite(policeBlip, 526)
    SetBlipColour(policeBlip, 63)
    SetBlipScale(sheriffBlip, 0.8)
    SetBlipAsShortRange(policeBlip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring("Police Department"))
    EndTextCommandSetBlipName(policeBlip)

    local sheriffBlip = AddBlipForCoord(1852.363, 3687.263, 34.2866)
    SetBlipAsFriendly(sheriffBlip, true)
    SetBlipSprite(sheriffBlip, 526)
    SetBlipColour(sheriffBlip, 22)
    SetBlipScale(sheriffBlip, 0.8)
    SetBlipAsShortRange(sheriffBlip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring("Sheriff Department"))
    EndTextCommandSetBlipName(sheriffBlip)

    local stateBlip = AddBlipForCoord(-446.589, 6012.52, 31.71)
    SetBlipAsFriendly(stateBlip, true)
    SetBlipSprite(stateBlip, 526)
    SetBlipColour(stateBlip, 9)
    SetBlipScale(stateBlip, 0.8)
    SetBlipAsShortRange(stateBlip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring("State Department"))
    EndTextCommandSetBlipName(stateBlip)

    local stateBlip = AddBlipForCoord(1714.947, 2522.514, 45.563)
    SetBlipAsFriendly(stateBlip, true)
    SetBlipSprite(stateBlip, 285)
    SetBlipColour(stateBlip, 1)
    SetBlipScale(stateBlip, 1.0)
    SetBlipAsShortRange(stateBlip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring("Boilingbroke Penitentiary"))
    EndTextCommandSetBlipName(stateBlip)

	local pedmodel = GetHashKey("s_m_y_cop_01")
	RequestModel(pedmodel)
	while not HasModelLoaded(pedmodel) do
		Citizen.Wait(1)
	end
	weaponLicenseCop = CreatePed(1, pedmodel, 433.56, -985.7, 29.71, 90, false, true)
	SetBlockingOfNonTemporaryEvents(weaponLicenseCop, true)
	SetPedDiesWhenInjured(weaponLicenseCop, false)
	SetPedCanPlayAmbientAnims(weaponLicenseCop, true)
	SetPedCanRagdollFromPlayerImpact(weaponLicenseCop, false)
	SetEntityInvincible(weaponLicenseCop, true)
	FreezeEntityPosition(weaponLicenseCop, true)
    TaskStartScenarioInPlace(weaponLicenseCop, "WORLD_HUMAN_CLIPBOARD", 0, true)
    exports['prp-target']:AddCircleZone("WeaponLicenseCop",
        vector3(433.56, -985.7, 30.71),
        90,
        { name="WeaponLicenseCop", debugPoly=false, useZ=true, },
        { options = {
            { type = "server", event = "police:server:GiveWeaponLicense", icon = "fas fa-certificate", label = "Apply for a weapons licence.", },
        },
		distance = 2.5
    })
end)


local function CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation)
    local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)

    if not DoesBlipExist(blip) then

        if NetworkIsPlayerActive(playerId) then
            blip = AddBlipForEntity(ped)
        else
            blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
        end
        SetBlipSprite(blip, 1)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, math.ceil(playerLocation.w))
        SetBlipScale(blip, 1.0)
        if playerJob == "police" then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 5)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
        DutyBlips[#DutyBlips+1] = blip
    end

    if GetBlipFromEntity(PlayerPedId()) == blip then
        -- Ensure we remove our own blip.
        RemoveBlip(blip)
    end
end

-- Events

AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    local player = ProjectRP.Functions.GetPlayerData()
    PlayerJob = player.job
    onDuty = player.job.onduty
    isHandcuffed = false
    TriggerServerEvent("ProjectRP:Server:SetMetaData", "ishandcuffed", false)
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    TriggerServerEvent("police:server:UpdateBlips")
    TriggerServerEvent("police:server:UpdateCurrentCops")

    if player.metadata.tracker then
        local trackerClothingData = {
            outfitData = {
                ["accessory"] = {
                    item = 13,
                    texture = 0
                }
            }
        }
        TriggerEvent('prp-clothing:client:loadOutfit', trackerClothingData)
    else
        local trackerClothingData = {
            outfitData = {
                ["accessory"] = {
                    item = -1,
                    texture = 0
                }
            }
        }
        TriggerEvent('prp-clothing:client:loadOutfit', trackerClothingData)
    end

    if PlayerJob and PlayerJob.name ~= "police" then
        if DutyBlips then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    TriggerServerEvent('police:server:UpdateBlips')
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    TriggerServerEvent("police:server:UpdateCurrentCops")
    isHandcuffed = false
    isEscorted = false
    onDuty = false
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    if DutyBlips then
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("police:server:UpdateBlips")
    if JobInfo.name == "police" then
        if PlayerJob.onduty then
            TriggerServerEvent("ProjectRP:ToggleDuty")
            onDuty = false
        end
    end

    if (PlayerJob ~= nil) and PlayerJob.name ~= "police" then
        if DutyBlips then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('police:client:sendBillingMail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "Mr."
        if ProjectRP.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Mrs."
        end
        local charinfo = ProjectRP.Functions.GetPlayerData().charinfo
        TriggerServerEvent('prp-phone:server:sendNewMail', {
            sender = "Central Judicial Collection Agency",
            subject = "Debt collection",
            message = "Dear " .. gender .. " " .. charinfo.lastname ..
                ",<br /><br />The Central Judicial Collection Agency (CJCA) charged the fines you received from the police.<br />There is <strong>$" ..
                amount .. "</strong> withdrawn from your account.<br /><br />Kind regards,<br />Mr. I.K. Graai",
            button = {}
        })
    end)
end)

RegisterNetEvent('police:client:UpdateBlips', function(players)
    if PlayerJob and (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance') and
        onDuty then
        if DutyBlips then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                CreateDutyBlips(id, data.label, data.job, data.location)

            end
        end
    end
end)

RegisterNetEvent('police:client:policeAlert', function(coords, text)
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'}, 
        coords = coords,
        title = 'New Call',
        message = text,
        flash = 0,
        unique_id = tostring(math.random(0000000,9999999)),
        blip = {
            sprite = 280, 
            scale = 1.2, 
            colour = 3,
            flashes = false, 
            text = '911 - New Call',
            time = (5*60*1000),
            sound = 1,
        }
    })
end)

RegisterNetEvent('police:client:SendToJail', function(time)
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    isHandcuffed = false
    isEscorted = false
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    TriggerEvent("prison:client:Enter", time)
end)

-- NUI




RegisterNetEvent('police:client:SendPoliceEmergencyAlert')
AddEventHandler('police:client:SendPoliceEmergencyAlert', function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end
    local alertTitle = "Colleague Requesting Backup"
    if PlayerJob.name == "ambulance" or PlayerJob.name == "doctor" then
        alertTitle = "Assistant " .. PlayerJob.label
    end

    local MyId = GetPlayerServerId(PlayerId())

    TriggerServerEvent('prp-policealerts:server:AddPoliceAlert', {
        alertTitle = alertTitle,
        coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
        },
        msg = streetLabel .. ' | ' .. ProjectRP.Functions.GetPlayerData().charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayerData().charinfo.lastname,
    }, true)
end)
