local robberyAlert = false
local isLoggedIn = false
local firstAlarm = false

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

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload')
AddEventHandler('ProjectRP:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        inRange = false

        if ProjectRP ~= nil then
            if isLoggedIn then
                PlayerData = ProjectRP.Functions.GetPlayerData()
                for case,_ in pairs(Config.Locations) do
                    -- if PlayerData.job.name ~= "police" then
                        local dist = #(pos - vector3(Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"]))
                        local storeDist = #(pos - vector3(Config.JewelleryLocation["coords"]["x"], Config.JewelleryLocation["coords"]["y"], Config.JewelleryLocation["coords"]["z"]))
                        if dist < 30 then
                            inRange = true

                            if dist < 0.6 then
                                if not Config.Locations[case]["isBusy"] and not Config.Locations[case]["isOpened"] then
                                    DrawText3Ds(Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"], '[E] Rob the display case')
                                    if IsControlJustPressed(0, 38) then
                                        ProjectRP.Functions.TriggerCallback('prp-jewellery:server:getCops', function(cops)
                                            if cops >= Config.RequiredCops then
                                                if validWeapon() then
                                                    smashVitrine(case)
                                                else
                                                    ProjectRP.Functions.Notify('Your weapon is not strong enough..', 'error')
                                                end
                                            else
                                                ProjectRP.Functions.Notify('Not Enough Police ('.. Config.RequiredCops ..') Required', 'error')
                                            end                
                                        end)
                                    end
                                end
                            end

                            if storeDist < 2 then
                                if not firstAlarm then
                                    if validWeapon() then
                                        TriggerServerEvent('prp-jewellery:server:PoliceAlertMessage', 'Vangelico Jewelry Store', vector3(-633.9, -241.7, 38.1), true)
                                        firstAlarm = true
                                    end
                                end
                            end
                        end
                    -- end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(3)
    end
end

function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end

local smashing = false

function smashVitrine(k)
    local animDict = "missheist_jewel"
    local animName = "smash_case"
    local ped = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
    local pedWeapon = GetSelectedPedWeapon(ped)

    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
    elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
        ProjectRP.Functions.Notify("You've left a fingerprint on the glass", "error")
    end

    smashing = true
-- Config.WhitelistedWeapons[pedWeapon]["timeOut"] < ---------- Before 
    ProjectRP.Functions.Progressbar("smash_vitrine", "Robbing a display", 3500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('prp-jewellery:server:setVitrineState', "isOpened", true, k)
        TriggerServerEvent('prp-jewellery:server:setVitrineState', "isBusy", false, k)
        TriggerServerEvent('prp-jewellery:server:vitrineReward')
        TriggerServerEvent('prp-jewellery:server:setTimeout')
        TriggerServerEvent('prp-jewellery:server:PoliceAlertMessage', 'Vangelico Jewelry Store', vector3(-633.9, -241.7, 38.1), true)
        smashing = false
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        TriggerServerEvent('prp-jewellery:server:setVitrineState', "isBusy", false, k)
        smashing = false
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    TriggerServerEvent('prp-jewellery:server:setVitrineState', "isBusy", true, k)

    Citizen.CreateThread(function()
        while smashing do
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(500)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
            loadParticle()
            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            Citizen.Wait(2500)
        end
    end)
end

RegisterNetEvent('prp-jewellery:client:setVitrineState')
AddEventHandler('prp-jewellery:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

RegisterNetEvent('prp-jewellery:client:setAlertState')
AddEventHandler('prp-jewellery:client:setAlertState', function(bool)
    robberyAlert = bool
end)

RegisterNetEvent('prp-jewellery:client:PoliceAlertMessage')
AddEventHandler('prp-jewellery:client:PoliceAlertMessage', function(title, coords, blip)
    if blip then
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = coords,
            title = '10-31 - Vangelico Jewelry robbery attempt',
            message = 'Possible robbery at Vangelico Jewelry Store<br>Available cameras: 31, 32, 33, 34',
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 617, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Vangelico Jewelry robbery attempt',
                time = (5*60*1000),
                sound = 1,
            }
        })
    else
        if not robberyAlert then
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police'}, 
                coords = coords,
                title = '10-31 - Vangelico Jewelry robbery attempt',
                message = 'Possible robbery at Vangelico Jewelry Store<br>Available cameras: 31, 32, 33, 34',
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                blip = {
                    sprite = 617, 
                    scale = 1.2, 
                    colour = 3,
                    flashes = false, 
                    text = '911 - Vangelico Jewelry robbery attempt',
                    time = (5*60*1000),
                    sound = 1,
                }
            })
            robberyAlert = true
        end
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(Config.JewelleryLocation["coords"]["x"], Config.JewelleryLocation["coords"]["y"], Config.JewelleryLocation["coords"]["z"])

    SetBlipSprite (Dealer, 617)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.7)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vangelico Jewelry")
    EndTextCommandSetBlipName(Dealer)
end)
