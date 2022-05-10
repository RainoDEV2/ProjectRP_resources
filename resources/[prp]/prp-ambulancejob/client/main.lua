ProjectRP = exports['prp-core']:GetCoreObject()

local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'
local canLeaveBed = true
local bedOccupying = nil
local bedObject = nil
local bedOccupyingData = nil
local closestBed = nil
local doctorCount = 0
local CurrentDamageList = {}
local inCheckin = false
local inBed = false
bedNames = { 'v_med_bed1', 'v_med_bed2', 'v_med_emptybed', 'hirurg_bath' } -- Add more model strings here if you'd like
bedHashes = {}
onBedAnimDict = 'anim@gangops@morgue@table@'
onBedAnimName = 'body_search'
putOnBed = false

inBedDict = "dead"
inBedAnim = "dead_a"
isInHospitalBed = false
isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0
legCount = 0
armcount = 0
headCount = 0
playerHealth = nil
isDead = false
isStatusChecking = false
statusChecks = {}
statusCheckTime = 0
isHealingPerson = false
healAnimDict = "amb@medic@standing@tendtodead@idle_a"
healAnim = "idle_a"
reviveAnimDict = "amb@medic@standing@tendtodead@idle_a"
reviveAnim = "idle_a"
injured = {}

BodyParts = {
    ['HEAD'] =          { label = 'Head',          causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] =          { label = 'Neck',          causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] =         { label = 'Spine',         causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] =    { label = 'Upper Body',    causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] =    { label = 'Lower Body',    causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] =          { label = 'Left Arm',      causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] =         { label = 'Left Hand',     causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] =       { label = 'Left Fingers',  causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] =          { label = 'Left Leg',      causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] =         { label = 'Left Foot',     causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] =          { label = 'Right Arm',     causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] =         { label = 'Right Hand',    causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] =       { label = 'Right Fingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] =          { label = 'Right Leg',     causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] =         { label = 'Right Foot',    causeLimp = true, isDamaged = false, severity = 0 },
}

-- Functions


local function DrawText3D(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

PlayerJob = {}

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerJob = ProjectRP.Functions.GetPlayerData().job

end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

local function GetAvailableBed(bedId)
    local pos = GetEntityCoords(PlayerPedId())
    local retval = nil
    if bedId == nil then
        for k, v in pairs(Config.Locations["beds"]) do
            if not Config.Locations["beds"][k].taken then
                if #(pos - vector3(Config.Locations["beds"][k].coords.x, Config.Locations["beds"][k].coords.y, Config.Locations["beds"][k].coords.z)) < 500 then
                        retval = k
                end
            end
        end
    else
        if not Config.Locations["beds"][bedId].taken then
            if #(pos - vector3(Config.Locations["beds"][bedId].coords.x, Config.Locations["beds"][bedId].coords.y, Config.Locations["beds"][bedId].coords.z))  < 500 then
                retval = bedId
            end
        end
    end
    return retval
end

local function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            return v
        end
    end

    return nil
end

local function IsDamagingEvent(damageDone, weapon)
    local luck = math.random(100)
    local multi = damageDone / Config.HealthDamage

    return luck < (Config.HealthDamage * multi) or (damageDone >= Config.ForceInjury or multi > Config.MaxInjuryChanceMulti or Config.ForceInjuryWeapons[weapon])
end

local function DoLimbAlert()
    if not isDead and not InLaststand then
        if #injured > 0 then
            local limbDamageMsg = ''
            if #injured <= Config.AlertShowInfo then
                for k, v in pairs(injured) do
                    local limb = v.label
                    local severity = Config.WoundStates[v.severity]
                    limbDamageMsg = limbDamageMsg..'Your ' .. limb .. ' feels ' .. severity
                    if k < #injured then
                        limbDamageMsg = limbDamageMsg .. " | "
                    end
                end
            else
                limbDamageMsg = 'You have pain in many places...'
            end
            ProjectRP.Functions.Notify(limbDamageMsg, "primary")
        end
    end
end

local function DoBleedAlert()
    if not isDead and tonumber(isBleeding) > 0 then
        local bleedstate = Config.BleedingStates[tonumber(isBleeding)].label
        ProjectRP.Functions.Notify('You are ' .. bleedstate, "error")
    end
end

local function ApplyBleed(level)
    if isBleeding ~= 4 then
        if isBleeding + level > 4 then
            isBleeding = 4
        else
            isBleeding = isBleeding + level
        end
        DoBleedAlert()
    end
end

local function SetClosestBed()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for k, v in pairs(Config.Locations["beds"]) do
        local dist2 = #(pos - vector3(Config.Locations["beds"][k].coords.x, Config.Locations["beds"][k].coords.y, Config.Locations["beds"][k].coords.z))
        if current then
            if dist2 < dist then
                current = k
                dist = dist2
            end
        else
            dist = dist2
            current = k
        end
    end
    if current ~= closestBed and not isInHospitalBed then
        closestBed = current
    end
end

local function IsInjuryCausingLimp()
    for k, v in pairs(BodyParts) do
        if v.causeLimp and v.isDamaged then
            return true
        end
    end
    return false
end

local function ProcessRunStuff(ped)
    if IsInjuryCausingLimp() then
        RequestAnimSet("move_m@injured")
        while not HasAnimSetLoaded("move_m@injured") do
            Wait(0)
        end
        SetPedMovementClipset(ped, "move_m@injured", 1 )
        SetPlayerSprint(PlayerId(), false)
    end
end

local function GetClosestPlayer()
    local closestPlayers = ProjectRP.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end
	return closestPlayer, closestDistance
end

function ResetPartial()
    for k, v in pairs(BodyParts) do
        if v.isDamaged and v.severity <= 2 then
            v.isDamaged = false
            v.severity = 0
        end
    end

    for k, v in pairs(injured) do
        if v.severity <= 2 then
            v.severity = 0
            table.remove(injured, k)
        end
    end

    if isBleeding <= 2 then
        isBleeding = 0
        bleedTickTimer = 0
        advanceBleedTimer = 0
        fadeOutTimer = 0
        blackoutTimer = 0
    end

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end

local function ResetAll()
    isBleeding = 0
    bleedTickTimer = 0
    advanceBleedTimer = 0
    fadeOutTimer = 0
    blackoutTimer = 0
    onDrugs = 0
    wasOnDrugs = false
    onPainKiller = 0
    wasOnPainKillers = false
    injured = {}

    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 0
    end

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    CurrentDamageList = {}
    TriggerServerEvent('hospital:server:SetWeaponDamage', CurrentDamageList)

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
    TriggerServerEvent("ProjectRP:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("ProjectRP:Server:SetMetaData", "thirst", 100)
end

local function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(1)
	end
end

local function SetBedCam()
    isInHospitalBed = true
    canLeaveBed = false
    local player = PlayerPedId()

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Wait(100)
    end

	if IsPedDeadOrDying(player) then
		local pos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(player), true, false)
    end

    bedObject = GetClosestObjectOfType(bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z, 1.0, bedOccupyingData.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.02)
    --SetEntityInvincible(PlayerPedId(), true)
    Wait(500)
    FreezeEntityPosition(player, true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
    SetEntityHeading(player, bedOccupyingData.coords.w)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0 , true)
    SetCamFov(cam, 90.0)
    local heading = GetEntityHeading(player)
    heading = (heading > 180) and heading - 180 or heading + 180
    SetCamRot(cam, -45.0, 0.0, heading, 2)

    DoScreenFadeIn(1000)

    Wait(1000)
    FreezeEntityPosition(player, true)
end

local function LeaveBed()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Wait(0)
    end

    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, bedOccupyingData.coords.w + 90)
    TaskPlayAnim(player, getOutDict , getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Wait(4000)
    ClearPedTasks(player)
    TriggerServerEvent('hospital:server:LeaveBed', bedOccupying)
    FreezeEntityPosition(bedObject, true)
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
    isInHospitalBed = false
end

local function IsInDamageList(damage)
    local retval = false
    if CurrentDamageList then
        for k, v in pairs(CurrentDamageList) do
            if CurrentDamageList[k] == damage then
                retval = true
            end
        end
    end
    return retval
end

local function CheckWeaponDamage(ped)
    local detected = false
    for k, v in pairs(ProjectRP.Shared.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, GetHashKey(k), 0) then
            detected = true
            if not IsInDamageList(k) then
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = false,
                    args = {'Status Check', v.damagereason}
                })
                CurrentDamageList[#CurrentDamageList+1] = k
            end
        end
    end
    if detected then
        TriggerServerEvent("hospital:server:SetWeaponDamage", CurrentDamageList)
    end
    ClearEntityLastDamageEntity(ped)
end

local function ApplyImmediateEffects(ped, bone, weapon, damageDone)
    local armor = GetPedArmour(ped)
    if Config.MinorInjurWeapons[weapon] and damageDone < Config.DamageMinorToMajor then
        if Config.CriticalAreas[Config.Bones[bone]] then
            if armor <= 0 then
                ApplyBleed(1)
            end
        end

        -- if Config.StaggerAreas[Config.Bones[bone]] and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
        --     if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].minor) then
        --         SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
        --     end
        -- end
    elseif Config.MajorInjurWeapons[weapon] or (Config.MinorInjurWeapons[weapon] and damageDone >= Config.DamageMinorToMajor) then
        if Config.CriticalAreas[Config.Bones[bone]] then
            if armor > 0 and Config.CriticalAreas[Config.Bones[bone]].armored then
                if math.random(100) <= math.ceil(Config.MajorArmoredBleedChance) then
                    ApplyBleed(1)
                end
            else
                ApplyBleed(1)
            end
        else
            if armor > 0 then
                if math.random(100) < (Config.MajorArmoredBleedChance) then
                    ApplyBleed(1)
                end
            else
                if math.random(100) < (Config.MajorArmoredBleedChance * 2) then
                    ApplyBleed(1)
                end
            end
        end

        -- if Config.StaggerAreas[Config.Bones[bone]] and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
        --     if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].major) then
        --         SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
        --     end
        -- end
    end
end

local function CheckDamage(ped, bone, weapon, damageDone)
    if weapon == nil then return end

    if Config.Bones[bone] and not isDead and not InLaststand then
        ApplyImmediateEffects(ped, bone, weapon, damageDone)

        if not BodyParts[Config.Bones[bone]].isDamaged then
            BodyParts[Config.Bones[bone]].isDamaged = true
            BodyParts[Config.Bones[bone]].severity = math.random(1, 3)
            injured[#injured+1] = {
                part = Config.Bones[bone],
                label = BodyParts[Config.Bones[bone]].label,
                severity = BodyParts[Config.Bones[bone]].severity
            }
        else
            if BodyParts[Config.Bones[bone]].severity < 4 then
                BodyParts[Config.Bones[bone]].severity = BodyParts[Config.Bones[bone]].severity + 1

                for k, v in pairs(injured) do
                    if v.part == Config.Bones[bone] then
                        v.severity = BodyParts[Config.Bones[bone]].severity
                    end
                end
            end
        end

        TriggerServerEvent('hospital:server:SyncInjuries', {
            limbs = BodyParts,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(ped)
    end
end

local function ProcessDamage(ped)
    if not isDead and not InLaststand and not onPainKillers then
        for k, v in pairs(injured) do
            if (v.part == 'LLEG' and v.severity > 1) or (v.part == 'RLEG' and v.severity > 1) or (v.part == 'LFOOT' and v.severity > 2) or (v.part == 'RFOOT' and v.severity > 2) then
                if legCount >= Config.LegInjuryTimer then
                    if not IsPedRagdoll(ped) and IsPedOnFoot(ped) then
                        local chance = math.random(100)
                        if (IsPedRunning(ped) or IsPedSprinting(ped)) then
                            if chance <= Config.LegInjuryChance.Running then
                                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        else
                            if chance <= Config.LegInjuryChance.Walking then
                                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        end
                    end
                    legCount = 0
                else
                    legCount = legCount + 1
                end
            elseif (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) or (v.part == 'RARM' and v.severity > 1) or (v.part == 'RHAND' and v.severity > 1) or (v.part == 'RFINGER' and v.severity > 2) then
                if armcount >= Config.ArmInjuryTimer then
                    local chance = math.random(100)

                    if (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) then
                        local isDisabled = 15
                        CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Wait(1)
                            end
                        end)
                    else
                        local isDisabled = 15
                        CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisableControlAction(0, 25, true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Wait(1)
                            end
                        end)
                    end

                    armcount = 0
                else
                    armcount = armcount + 1
                end
            elseif (v.part == 'HEAD' and v.severity > 2) then
                if headCount >= Config.HeadInjuryTimer then
                    local chance = math.random(100)

                    if chance <= Config.HeadInjuryChance then
                        SetFlash(0, 0, 100, 10000, 100)

                        DoScreenFadeOut(100)
                        while not IsScreenFadedOut() do
                            Wait(0)
                        end

                        if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                            SetPedToRagdoll(ped, 5000, 1, 2)
                        end

                        Wait(5000)
                        DoScreenFadeIn(250)
                    end
                    headCount = 0
                else
                    headCount = headCount + 1
                end
            end
        end
    end
end

-- Events

RegisterNetEvent('hospital:client:ambulanceAlert', function(coords, text)
    local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street1name = GetStreetNameFromHashKey(street1)
    local street2name = GetStreetNameFromHashKey(street2)

    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'ambulance', 'police'}, 
        coords = coords,
        title = text,
        message = street1name.. ' ' ..street2name,
        flash = 0,
        unique_id = tostring(math.random(0000000,9999999)),
        blip = {
            sprite = 153, 
            scale = 1.2, 
            colour = 1,
            flashes = false, 
            text = text,
            time = (5*60*1000),
            sound = 1,
        }
    })
end)

RegisterNetEvent('hospital:client:Revive', function()
    local player = PlayerPedId()

    if isDead or InLaststand then
        local pos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(player), true, false)
        isDead = false
        SetEntityInvincible(player, false)
        SetLaststand(false)
    end

    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(player, inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        SetEntityInvincible(player, true)
        canLeaveBed = true
    end

    -- TriggerServerEvent("hospital:server:RestoreWeaponDamage")
    SetEntityMaxHealth(player, 150)
    SetEntityHealth(player, 150)
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)
    ResetAll()
    ResetPedMovementClipset(player, 0.0)
    -- TriggerServerEvent('hud:server:RelieveStress', 100)
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent("hospital:server:SetLaststandStatus", false)
    emsNotified = false
end)

RegisterNetEvent('hospital:client:SetPain', function()
    ApplyBleed(math.random(1,4))
    if not BodyParts[Config.Bones[24816]].isDamaged then
        BodyParts[Config.Bones[24816]].isDamaged = true
        BodyParts[Config.Bones[24816]].severity = math.random(1, 4)
        injured[#injured+1] = {
            part = Config.Bones[24816],
            label = BodyParts[Config.Bones[24816]].label,
            severity = BodyParts[Config.Bones[24816]].severity
        }
    end

    if not BodyParts[Config.Bones[40269]].isDamaged then
        BodyParts[Config.Bones[40269]].isDamaged = true
        BodyParts[Config.Bones[40269]].severity = math.random(1, 4)
        injured[#injured+1] = {
            part = Config.Bones[40269],
            label = BodyParts[Config.Bones[40269]].label,
            severity = BodyParts[Config.Bones[40269]].severity
        }
    end

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end)

RegisterNetEvent('hospital:client:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('hospital:client:HealInjuries', function(type)
    if type == "full" then
        ResetAll()
    else
        ResetPartial()
    end
    TriggerServerEvent("hospital:server:RestoreWeaponDamage")
    ProjectRP.Functions.Notify('Your wounds have been healed!', 'success')
end)

RegisterNetEvent('hospital:client:SendToBed', function(id, data, isRevive)
    bedOccupying = id
    bedOccupyingData = data
    SetBedCam()
    CreateThread(function ()
        Wait(5)
        if isRevive then
            ProjectRP.Functions.Notify('You are being helped...', 'success', Config.AIHealTimer * 1000)
            Wait(Config.AIHealTimer * 1000)
            TriggerEvent("hospital:client:Revive")
        else
            canLeaveBed = true
        end
    end)
end)

RegisterNetEvent('hospital:client:SetBed', function(id, isTaken)
    Config.Locations["beds"][id].taken = isTaken
end)

RegisterNetEvent('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent("hospital:server:RespawnAtHospital")
    if exports["prp-policejob"]:IsHandcuffed() then
        TriggerEvent("police:client:GetCuffed", -1)
    end
    TriggerEvent("police:client:DeEscort")
end)

RegisterNetEvent('hospital:client:SendBillEmail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = 'Mr.'
        if ProjectRP.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = 'Mrs.'
        end
        local charinfo = ProjectRP.Functions.GetPlayerData().charinfo
        TriggerServerEvent('prp-phone:server:sendNewMail', {
            sender = 'Pillbox Hospital',
            subject = 'Hospital Costs',
            message = 'Dear ' .. gender .. ' ' ..charinfo.lastname.. ', <br /><br />Hereby you received an email with the costs of the last hospital visit.<br />The final costs have become: <strong>$' .. amount .. '</strong><br /><br />We wish you a quick recovery!',
            button = {}
        })
    end)
end)

RegisterNetEvent('hospital:client:SetDoctorCount', function(amount)
    doctorCount = amount
end)

RegisterNetEvent('hospital:client:adminHeal', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    TriggerServerEvent("ProjectRP:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("ProjectRP:Server:SetMetaData", "thirst", 100)
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    local ped = PlayerPedId()
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent('hospital:server:SetLaststandStatus', false)
    TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(ped))
    if bedOccupying then
        TriggerServerEvent("hospital:server:LeaveBed", bedOccupying)
    end
    isDead = false
    deathTime = 0
    SetEntityInvincible(ped, false)
    SetPedArmour(ped, 0)
    ResetAll()
end)

-- Threads

CreateThread(function()
    for k, station in pairs(Config.Locations["stations"]) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, 61)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 25)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station.label)
        EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    while true do
        sleep = 1000
        if isInHospitalBed and canLeaveBed then
            sleep = 0
            local pos = GetEntityCoords(PlayerPedId())
            exports['prp-core']:DrawText('[E] - To get out of bed..')
            if IsControlJustReleased(0, 38) then
                exports['prp-core']:KeyPressed(38)
                LeaveBed()
                exports['prp-core']:HideText()
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait((1000 * Config.MessageTimer))
        DoLimbAlert()
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        SetClosestBed()
        if isStatusChecking then
            statusCheckTime = statusCheckTime - 1
            if statusCheckTime <= 0 then
                statusChecks = {}
                isStatusChecking = false
            end
        end
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health) -- Players health was damaged

        local damageDone = (playerHealth - health)

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            local weapon = GetDamagingWeapon(ped)

            if hit and bodypart ~= 'NONE' then
                local checkDamage = true
                if damageDone >= Config.HealthDamage then
                    if weapon then
                        if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                            checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                            if armorDamaged then
                                TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(ped))
                            end
                        end

                        if checkDamage then
                            if IsDamagingEvent(damageDone, weapon) then
                                CheckDamage(ped, bone, weapon, damageDone)
                            end
                        end
                    end
                elseif Config.AlwaysBleedChanceWeapons[weapon] then
                    if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                        checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                    end
                    if math.random(100) < Config.AlwaysBleedChance and checkDamage then
                        ApplyBleed(1)
                    end
                end
            end

            CheckWeaponDamage(ped)
        end

        playerHealth = health
        playerArmor = armor

        if not isInHospitalBed then
            ProcessDamage(ped)
        end
        Wait(100)
    end
end)

local listen = false
    local function CheckInControls(variable)
    CreateThread(function()
        listen = true
        while listen do
            if IsControlJustPressed(0, 38) then
                exports['prp-core']:KeyPressed(38)
                -- if variable == "checkin" then
                --     TriggerEvent('prp-ambulancejob:checkin')
                if variable == "beds" then
                    TriggerEvent('prp-ambulancejob:beds')
                end
            end
            Wait(1)
        end
    end)
end 


function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


local checking = false
Citizen.CreateThread(function()
	while true do
		local waitTimer = 1500
        local checkInCoords = Config.Locations["checking"][1]
        local hspDist = GetDistanceBetweenCoords(checkInCoords.x, checkInCoords.y, checkInCoords.z, GetEntityCoords(GetPlayerPed(-1)),true)

		if hspDist < 3.0 then
            waitTimer = 0
            if IsControlJustReleased(0,38) and hspDist < 3.0 and not checking then
                checking = true
				loadAnimDict('anim@narcotics@trash')
                TaskPlayAnim(GetPlayerPed(-1),'anim@narcotics@trash', 'drop_front',1.0, 1.0, -1, 1, 0, 0, 0, 0)
                TriggerEvent('prp-ambulancejob:checkin')
                checking = false
			end

            DrawText3D(Config.Locations["checking"][1], "Press [~g~E~w~] to Check In")
		end

        for k, v in pairs(Config.Locations["armory"]) do
            LockerDist = GetDistanceBetweenCoords(vector3(v.x, v.y, v.z),GetEntityCoords(GetPlayerPed(-1)),true)

            if LockerDist < 3.0 then
                -- print(PlayerJob.name)
                if PlayerJob.name == "ambulance" then
                    waitTimer = 0
                    DrawText3D(vector3(v.x, v.y, v.z), "Press ~g~E~w~ to open ~b~ Armory")

                    if IsControlJustReleased(0,38) then
                        TriggerEvent('prp-ambulancejob:armory')
                    end
                end
            end
        end

        for k, v in pairs(Config.Locations["stash"]) do
            LockerDist = GetDistanceBetweenCoords(vector3(v.x, v.y, v.z),GetEntityCoords(GetPlayerPed(-1)),true)
            if LockerDist < 3.0 then
                -- print(PlayerJob.name)
                if PlayerJob.name == "ambulance" then
                    waitTimer = 0
                    DrawText3D(vector3(v.x, v.y, v.z), "Press ~g~E~w~ to open ~b~ Personal Stash")
                    if IsControlJustReleased(0,38) then
                        TriggerEvent('prp-ambulancejob:stash')
                    end
                end
            end
        end

        Citizen.Wait(waitTimer)
	end
end)


RegisterNetEvent('prp-ambulancejob:checkin', function()
    if doctorCount >= Config.MinimalDoctors then
        TriggerServerEvent("hospital:server:SendDoctorAlert")
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
        ProjectRP.Functions.Progressbar("hospital_checkin", 'Checking in...', 2000, true, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            LocalPlayer.state:set("inv_busy", false, true)
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            local bedId = GetAvailableBed()
            if bedId then
                TriggerServerEvent("hospital:server:SendToBed", bedId, true)
            else
                ProjectRP.Functions.Notify('Beds are occupied...', "error")
            end
        end, function() -- Cancel
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            ProjectRP.Functions.Notify('Canceled', "error")
        end)
    end
end)


RegisterNetEvent('prp-ambulancejob:beds', function()
    if GetAvailableBed(closestBed) then
        TriggerServerEvent("hospital:server:SendToBed", closestBed, false)
    else
        ProjectRP.Functions.Notify('Beds are occupied...', "error")
    end
end)


-- Put player in bed
CreateThread(function()
    for k,v in ipairs(bedNames) do
        table.insert(bedHashes, GetHashKey(v))
    end
end)

RegisterCommand('bed', function()
    TriggerEvent('hospital:client:PutPlayerOnBed', GetPlayerPed(-1))
end)

RegisterNetEvent('hospital:client:PutOnBed', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 5.0 then
        local playerPed = GetPlayerPed(player)
        TriggerEvent('hospital:client:PutPlayerOnBed', playerPed)
    else
        ProjectRP.Functions.Notify('No Player Nearby', "error")
    end
end)

RegisterNetEvent('hospital:client:PutPlayerOnBed', function(playerPed)
    if playerPed then
        if putOnBed then
            DoScreenFadeOut(1000)
            while not IsScreenFadedOut() do
                Wait(100)
            end

            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            RenderScriptCams(0, true, 200, true, true)
            DestroyCam(cam, false)
            ClearPedTasksImmediately(playerPed)

            Wait(200)

            DoScreenFadeIn(1000)
            putOnBed = false
            return
        end

        local playerPos = GetEntityCoords(playerPed, true)

        local bed = nil
        local bedHash = nil

        for k, v in ipairs(bedHashes) do
            bed = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 1.5, v, false, false, false)
            if bed ~= 0 then
                bedHash = v
                break
            end
        end

        if bed ~= nil and DoesEntityExist(bed) then
            if not HasAnimDictLoaded(onBedAnimDict) then
                RequestAnimDict(onBedAnimDict)
            end
            local bedCoords = GetEntityCoords(bed)

            if bedHash == GetHashKey('hirurg_bath') then -- check for surgery bed
                SetEntityCoords(playerPed, bedCoords.x, bedCoords.y, bedCoords.z+1, 1, 1, 0, 0)
                SetEntityHeading(playerPed, GetEntityHeading(bed) + 270.0)
            else
                SetEntityCoords(playerPed, bedCoords.x, bedCoords.y, bedCoords.z, 1, 1, 0, 0)
                SetEntityHeading(playerPed, GetEntityHeading(bed) + 180.0)
            end
            TaskPlayAnim(playerPed, onBedAnimDict, onBedAnimName, 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)
            putOnBed = true

            FreezeEntityPosition(playerPed, true)

            DoScreenFadeOut(1000)
            while not IsScreenFadedOut() do
                Wait(100)
            end

            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 1, true, true)
            AttachCamToPedBone(cam, playerPed, 31085, 0, 1.0, 1.0 , true)
            SetCamFov(cam, 90.0)
            local heading = GetEntityHeading(playerPed)
            heading = (heading > 180) and heading - 180 or heading + 180
            SetCamRot(cam, -45.0, 0.0, heading, 2)

            FreezeEntityPosition(playerPed, true)

            DoScreenFadeIn(1000)
        else
            ProjectRP.Functions.Notify('No Bed Nearby', "error")
        end
    else
        ProjectRP.Functions.Notify('No Player Nearby', "error")
    end
end)

-- Convar Turns into strings
if Config.UseTarget == 'true' then
    CreateThread(function()
        -- for k, v in pairs(Config.Locations["checking"]) do
        --     exports['prp-target']:AddBoxZone("checking"..k, vector3(v.x, v.y, v.z), 3.5, 2, {
        --         name = "checkin"..k,
        --         heading = -72,
        --         debugPoly = false,
        --         minZ = v.z - 2,
        --         maxZ = v.z + 2,
        --     }, {
        --         options = {
        --             {
        --                 type = "client",
        --                 icon = "fa fa-clipboard",
        --                 event = "prp-ambulancejob:checkin",
        --                 label = "Check In",
        --             }
        --         },
        --         distance = 1.5
        --     })
        -- end

        -- for k, v in pairs(Config.Locations["beds"]) do
        --     exports['prp-target']:AddBoxZone("beds"..k,  v.coords, 2.5, 2.3, {
        --         name = "beds"..k,
        --         heading = -20,
        --         debugPoly = false,
        --         minZ = v.coords.z - 1,
        --         maxZ = v.coords.z + 1,
        --     }, {
        --         options = {
        --             {
        --                 type = "client",
        --                 event = "prp-ambulancejob:beds",
        --                 icon = "fas fa-bed",
        --                 label = "Layin Bed",
        --             }
        --         },
        --         distance = 1.5
        --     })
        -- end
    end)
else
    CreateThread(function()
        -- local checkingPoly = {}
        -- for k, v in pairs(Config.Locations["checking"]) do
        --     checkingPoly[#checkingPoly+1] = BoxZone:Create(vector3(v.x, v.y, v.z), 3.5, 2, {
        --         heading = -72,
        --         name="checkin"..k,
        --         debugPoly = false,
        --         minZ = v.z - 2,
        --         maxZ = v.z + 2,
        --     })
        --     local checkingCombo = ComboZone:Create(checkingPoly, {name = "checkingCombo", debugPoly = false})
        --     checkingCombo:onPlayerInOut(function(isPointInside)
        --         if isPointInside then
        --             inCheckin = true
        --             if doctorCount >= Config.MinimalDoctors then
        --                 exports['prp-core']:DrawText('[E] - Call doctor','left')
        --                 CheckInControls("checkin")
        --             else
        --                 exports['prp-core']:DrawText('[E] Check in', 'left')
        --                 CheckInControls("checkin")
        --             end
        --         else
        --             inCheckin = false
        --             listen = false
        --             exports['prp-core']:HideText()
        --         end
        --     end)
        -- end
        -- local bedPoly = {}
        -- for k, v in pairs(Config.Locations["beds"]) do
        --     bedPoly[#bedPoly+1] = BoxZone:Create(v.coords, 2.5, 2.3, {
        --         name="beds"..k,
        --         heading = -20,
        --         debugPoly = false,
        --         minZ = v.coords.z - 1,
        --         maxZ = v.coords.z + 1,
        --     })
        --     local bedCombo = ComboZone:Create(bedPoly, {name = "bedCombo", debugPoly = false})
        --     bedCombo:onPlayerInOut(function(isPointInside)
        --         if isPointInside then
        --             inBed = true
        --             exports['prp-core']:DrawText('[E] - To lie in bed', 'left')
        --             CheckInControls("beds")
        --         else
        --             inBed = false
        --             listen = false
        --             exports['prp-core']:HideText()
        --         end
        --     end)
        -- end
    end)
end
