local statusCheckPed = nil
local PlayerJob = {}
local onDuty = false
local currentGarage = 0
local inDuty = false
local inStash = false
local inArmory = false
local inVehicle = false
local inHeli = false
local onRoof = false
local inMain = false
local inMain2 = false
local inBottomFloor = false


-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
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

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    ProjectRP.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, 'AMBO'..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['prp-fuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        if Config.VehicleSettings[vehicleInfo] ~= nil then
            ProjectRP.Shared.SetDefaultVehicleExtras(veh, Config.VehicleSettings[vehicleInfo].extras)
        end
        TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function MenuGarage()
    local vehicleMenu = {
        {
            header = 'Ambulance Vehicles',
            isMenuHeader = true
        }
    }

    local authorizedVehicles = Config.AuthorizedVehicles[ProjectRP.Functions.GetPlayerData().job.grade.level]
    for veh, label in pairs(authorizedVehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = label,
            txt = "",
            params = {
                event = "ambulance:client:TakeOutVehicle",
                args = {
                    vehicle = veh
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = '⬅ Close Menu',
        txt = "",
        params = {
            event = "prp-menu:client:closeMenu"
        }

    }
    exports['prp-menu']:openMenu(vehicleMenu)
end

-- Events

RegisterNetEvent('ambulance:client:TakeOutVehicle', function(data)
    local vehicle = data.vehicle
    TakeOutVehicle(vehicle)
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    local ped = PlayerPedId()
    local player = PlayerId()
    TriggerServerEvent("hospital:server:SetDoctor")
    CreateThread(function()
        Wait(5000)
        SetEntityMaxHealth(ped, 200)
        SetEntityHealth(ped, 200)
        SetPlayerHealthRechargeMultiplier(player, 0.0)
        SetPlayerHealthRechargeLimit(player, 0.0)
    end)
    CreateThread(function()
        Wait(1000)
        ProjectRP.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            onDuty = PlayerData.job.onduty
            SetPedArmour(PlayerPedId(), PlayerData.metadata["armor"])
            if (not PlayerData.metadata["inlaststand"] and PlayerData.metadata["isdead"]) then
                deathTime = Laststand.ReviveInterval
                OnDeath()
                DeathTimer()
            elseif (PlayerData.metadata["inlaststand"] and not PlayerData.metadata["isdead"]) then
                SetLaststand(true, true)
            else
                TriggerServerEvent("hospital:server:SetDeathStatus", false)
                TriggerServerEvent("hospital:server:SetLaststandStatus", false)
            end
        end)
    end)
end)

RegisterNetEvent('ProjectRP:Client:SetDuty', function(duty)
    onDuty = duty
    TriggerServerEvent("hospital:server:SetDoctor")
end)

function Status()
    if isStatusChecking then
        local statusMenu = {
            {
                header = 'Heath Status',
                isMenuHeader = true
            }
        }
        for k, v in pairs(statusChecks) do
            statusMenu[#statusMenu+1] = {
                header = v.label,
                txt = "",
                params = {
                    event = "hospital:client:TreatWounds",
                }
            }
        end
        statusMenu[#statusMenu+1] = {
            header = 'Give lorazepam Pill',
            txt = "",
            params = {
                event = "hospital:client:lorazepam"
            }
        }

        statusMenu[#statusMenu+1] = {
            header = '⬅ Close Menu',
            txt = "",
            params = {
                event = "prp-menu:client:closeMenu"
            }
        }
        exports['prp-menu']:openMenu(statusMenu)
    end
end

RegisterNetEvent('hospital:client:CheckStatus', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 5.0 then
        local playerId = GetPlayerServerId(player)
        statusCheckPed = GetPlayerPed(player)
        ProjectRP.Functions.TriggerCallback('hospital:GetPlayerStatus', function(result)
            if result then
                for k, v in pairs(result) do
                    if k ~= "BLEED" and k ~= "WEAPONWOUNDS" then
                        statusChecks[#statusChecks+1] = {bone = Config.BoneIndexes[k], label = v.label .." (".. Config.WoundStates[v.severity] ..")"}
                    elseif result["WEAPONWOUNDS"] then
                        for k, v in pairs(result["WEAPONWOUNDS"]) do
                            TriggerEvent('chat:addMessage', {
                                color = { 255, 0, 0},
                                multiline = false,
                                args = {'Status Check', WeaponDamageList[v]}
                            })
                        end
                    elseif result["BLEED"] > 0 then
                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = false,
                            args = {'Status Check', 'Is ' .. Config.BleedingStates[v].label}
                        })
                    else
                        ProjectRP.Functions.Notify('Player is Healthy', 'success')
                    end
                end
                isStatusChecking = true
                Status()
            end
        end, playerId)
    else
        ProjectRP.Functions.Notify('No Player Nearby', 'error')
    end
end)

RegisterNetEvent('hospital:client:RevivePlayer', function()
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
        if hasItem then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                ProjectRP.Functions.Progressbar("hospital_revive", 'Reviving Person...', 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    ProjectRP.Functions.Notify('You revived a person', 'success')
                    TriggerServerEvent("hospital:server:RevivePlayer", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    ProjectRP.Functions.Notify('Canceled', "error")
                end)
            else
                ProjectRP.Functions.Notify('No Player Nearby', "error")
            end
        else
            ProjectRP.Functions.Notify('You need a First Aid Kit', "error")
        end
    end, 'firstaid')
end)

RegisterNetEvent('hospital:client:TreatWounds', function()
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
        if hasItem then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                ProjectRP.Functions.Progressbar("hospital_healwounds", 'Healing Wounds...', 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    ProjectRP.Functions.Notify('You helped the person', 'success')
                    TriggerServerEvent("hospital:server:TreatWounds", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    ProjectRP.Functions.Notify('Canceled', "error")
                end)
            else
                ProjectRP.Functions.Notify('No Player Nearby', "error")
            end
        else
            ProjectRP.Functions.Notify('You need a Bandage', "error")
        end
    end, 'bandage')
end)
-- hospital:client:lorazepam
RegisterNetEvent('hospital:client:lorazepam', function()
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
        if hasItem then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                ProjectRP.Functions.Progressbar("hospital_healwounds", 'Giving lorazepam Pill...', 1000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    ProjectRP.Functions.Notify('You gave the person a lorazepam Pill', 'success')
                    TriggerServerEvent("hospital:server:lorazepamPill", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    ProjectRP.Functions.Notify('Canceled', "error")
                end)
            else
                ProjectRP.Functions.Notify('No Player Nearby', "error")
            end
        else
            ProjectRP.Functions.Notify('You need a lorazepam', "error")
        end
    end, 'lorazepam')
end)



local check = false
local function EMSControls(variable)
    CreateThread(function()
        check = true
        while check do
            if IsControlJustPressed(0, 38) then
                exports['prp-core']:KeyPressed(38)
                if variable == "sign" then
                    TriggerEvent('EMSToggle:Duty')
                elseif variable == "stash" then
                    TriggerEvent('prp-ambulancejob:stash')
                elseif variable == "armory" then
                    TriggerEvent('prp-ambulancejob:armory')
                elseif variable == "storeheli" then
                    TriggerEvent('prp-ambulancejob:storeheli')
                elseif variable == "takeheli" then
                    TriggerEvent('prp-ambulancejob:pullheli')
                elseif variable == "roof" then
                    TriggerEvent('prp-ambulancejob:elevator_main')
                elseif variable == "main" then
                    TriggerEvent('prp-ambulancejob:elevator_roof')
                elseif variable == "bottomFloor" then
                    TriggerEvent('prp-ambulancejob:elevator_main2')
                elseif variable == "main2" then
                    TriggerEvent('prp-ambulancejob:elevator_bottomFloor')
                end
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('prp-ambulancejob:stash', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "ambulancestash_"..ProjectRP.Functions.GetPlayerData().citizenid)
        TriggerEvent("inventory:client:SetCurrentStash", "ambulancestash_"..ProjectRP.Functions.GetPlayerData().citizenid)
    end
end)

RegisterNetEvent('prp-ambulancejob:armory', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
    end
end)

local CheckVehicle = false
local function EMSVehicle(k)
    CheckVehicle = true
    CreateThread(function()
        while CheckVehicle do
            if IsControlJustPressed(0, 38) then
                exports['prp-core']:KeyPressed(38)
                CheckVehicle = false
                local ped = PlayerPedId()
                    if IsPedInAnyVehicle(ped, false) then
                        ProjectRP.Functions.DeleteVehicle(GetVehiclePedIsIn(ped))
                    else
                        currentVehicle = k
                        MenuGarage(currentVehicle)
                        currentGarage = currentVehicle
                    end
                end
            Wait(1)
        end
    end)
end

local CheckHeli = false
local function EMSHelicopter(k)
    CheckHeli = true
    CreateThread(function()
        while CheckHeli do
            if IsControlJustPressed(0, 38) then
                exports['prp-core']:KeyPressed(38)
                CheckHeli = false
                local ped = PlayerPedId()
                    if IsPedInAnyVehicle(ped, false) then
                        ProjectRP.Functions.DeleteVehicle(GetVehiclePedIsIn(ped))
                    else
                        currentHelictoper = k
                        local coords = Config.Locations["helicopter"][currentHelictoper]
                        ProjectRP.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                            SetVehicleNumberPlateText(veh, 'LIFE'..tostring(math.random(1000, 9999)))
                            SetEntityHeading(veh, coords.w)
                            SetVehicleLivery(veh, 1) -- Ambulance Livery
                            exports['prp-fuel']:SetFuel(veh, 100.0)
                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                            TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                            SetVehicleEngineOn(veh, true, true)
                        end, coords, true)
                    end
                end
            Wait(1)
        end
    end)
end

RegisterNetEvent('prp-ambulancejob:elevator_roof', function()
    local ped = PlayerPedId()
    for k, v in pairs(Config.Locations["roof"]) do
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end

        currentHospital = k

        local coords = Config.Locations["main"][currentHospital]
        SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
        SetEntityHeading(ped, coords.w)

        Wait(100)

        DoScreenFadeIn(1000)
    end
end)

RegisterNetEvent('prp-ambulancejob:elevator_main', function()
    local ped = PlayerPedId()
    for k, v in pairs(Config.Locations["main"]) do
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end

        currentHospital = k

        local coords = Config.Locations["roof"][currentHospital]
        SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
        SetEntityHeading(ped, coords.w)

        Wait(100)

        DoScreenFadeIn(1000)
    end
end)

RegisterNetEvent('prp-ambulancejob:elevator_bottomFloor', function()
    local ped = PlayerPedId()
    for k, v in pairs(Config.Locations["main2"]) do
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end

        currentHospital = k

        local coords = Config.Locations["main2"][currentHospital]
        SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
        SetEntityHeading(ped, coords.w)

        Wait(100)

        DoScreenFadeIn(1000)
    end
end)

RegisterNetEvent('prp-ambulancejob:elevator_main2', function()
    local ped = PlayerPedId()
    for k, v in pairs(Config.Locations["bottomFloor"]) do
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end

        currentHospital = k

        local coords = Config.Locations["bottomFloor"][currentHospital]
        SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
        SetEntityHeading(ped, coords.w)

        Wait(100)

        DoScreenFadeIn(1000)
    end
end)

RegisterNetEvent('EMSToggle:Duty', function()
    onDuty = not onDuty
    TriggerServerEvent("ProjectRP:ToggleDuty")
    TriggerServerEvent("police:server:UpdateBlips")
end)

CreateThread(function()
    for k, v in pairs(Config.Locations["vehicle"]) do
        local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 5, 5, {
            name="vehicle"..k,
            debugPoly = false,
            heading = 70,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" and onDuty then
                inVehicle = true
                exports['prp-core']:DrawText('[E] - Take / Store Vehicle', 'left')
                EMSVehicle(k)
            else
                inVehicle = false
                CheckVehicle = false
                exports['prp-core']:HideText()
            end
        end)
    end

    for k, v in pairs(Config.Locations["helicopter"]) do
        local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 5, 5, {
            name="helicopter"..k,
            debugPoly = false,
            heading = 70,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" and onDuty then
                inVehicle = true
                exports['prp-core']:DrawText('[E] - Grab / Take Helicopter', 'left')
                EMSHelicopter(k)
            else
                inVehicle = false
                CheckHelicopter = false
                exports['prp-core']:HideText()
            end
        end)
    end
end)

-- Convar Turns into strings
if Config.UseTarget == 'true' then
    CreateThread(function()
        for k, v in pairs(Config.Locations["duty"]) do
            exports['prp-target']:AddBoxZone("duty"..k, vector3(v.x, v.y, v.z), 1.5, 1, {
                name = "duty"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "EMSToggle:Duty",
                        icon = "fa fa-clipboard",
                        label = "Sign In/Off duty",
                        job = "ambulance"
                    }
                },
                distance = 1.5
            })
        end
        for k, v in pairs(Config.Locations["stash"]) do
            exports['prp-target']:AddBoxZone("stash"..k, vector3(v.x, v.y, v.z), 1, 1, {
                name = "stash"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "prp-ambulancejob:stash",
                        icon = "fa fa-hand",
                        label = "Open Stash",
                        job = "ambulance"
                    }
                },
                distance = 1.5
            })
        end
        for k, v in pairs(Config.Locations["armory"]) do
            exports['prp-target']:AddBoxZone("armory"..k, vector3(v.x, v.y, v.z), 1, 1, {
                name = "armory"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "prp-ambulancejob:armory",
                        icon = "fa fa-hand",
                        label = "Open Armory",
                        job = "ambulance"
                    }
                },
                distance = 1.5
            })
        end
        for k, v in pairs(Config.Locations["roof"]) do
            exports['prp-target']:AddBoxZone("roof"..k, vector3(v.x, v.y, v.z), 2, 2, {
                name = "roof"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "prp-ambulancejob:elevator_roof",
                        icon = "fas fa-hand-point-up",
                        label = "Take Elevator",
                        job = "ambulance"
                    },
                },
                distance = 8
            })
        end
        for k, v in pairs(Config.Locations["main"]) do
            exports['prp-target']:AddBoxZone("main"..k, vector3(v.x, v.y, v.z), 1.5, 1.5, {
                name = "main"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "prp-ambulancejob:elevator_main",
                        icon = "fas fa-hand-point-up",
                        label = "Take Elevator",
                        job = "ambulance"
                    },
                },
                distance = 8
            })
        end
    end)
else
    CreateThread(function()
        local signPoly = {}
        for k, v in pairs(Config.Locations["duty"]) do
            signPoly[#signPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1.5, 1, {
                name="sign"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local signCombo = ComboZone:Create(signPoly, {name = "signcombo", debugPoly = false})
        signCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                inDuty = true
                if not onDuty then
                    exports['prp-core']:DrawText('[E] - Go On Duty','left')
                    EMSControls("sign")
                else
                    exports['prp-core']:DrawText('[E] - Go Off Duty','left')
                    EMSControls("sign")
                end
            else
                inDuty = false
                check = false
                exports['prp-core']:HideText()
            end
        end)

        local stashPoly = {}
        for k, v in pairs(Config.Locations["stash"]) do
            stashPoly[#stashPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1, 1, {
                name="stash"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local stashCombo = ComboZone:Create(stashPoly, {name = "stashCombo", debugPoly = false})
        stashCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                inStash = true
                if onDuty then
                    exports['prp-core']:DrawText('[E] - Personal stash','left')
                    EMSControls("stash")
                end
            else
                inStash = false
                check = false
                exports['prp-core']:HideText()
            end
        end)

        local armoryPoly = {}
        for k, v in pairs(Config.Locations["armory"]) do
            armoryPoly[#armoryPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1, 1, {
                name="armory"..k,
                debugPoly = false,
                heading = 70,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local armoryCombo = ComboZone:Create(armoryPoly, {name = "armoryCombo", debugPoly = false})
        armoryCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                inArmory = true
                if onDuty then
                    exports['prp-core']:DrawText('[E] - Armory','left')
                    EMSControls("armory")
                end
            else
                inArmory = false
                check = false
                exports['prp-core']:HideText()
            end
        end)

        local roofPoly = {}
        for k, v in pairs(Config.Locations["roof"]) do
            roofPoly[#roofPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 2, 2, {
                name="roof"..k,
                debugPoly = false,
                heading = 70,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local roofCombo = ComboZone:Create(roofPoly, {name = "roofCombo", debugPoly = false})
        roofCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                onRoof = true
                if onDuty then
                    exports['prp-core']:DrawText('[E] - Take the elevator down','left')
                    EMSControls("main")
                else
                    exports['prp-core']:DrawText('You are not EMS or not signed in','left')
                end
            else
                onRoof = false
                check = false
                exports['prp-core']:HideText()
            end
        end)

        local mainPoly = {}
        for k, v in pairs(Config.Locations["main"]) do
            mainPoly[#mainPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1.5, 1.5, {
                name="main"..k,
                debugPoly = false,
                heading = 70,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local mainCombo = ComboZone:Create(mainPoly, {name = "mainPoly", debugPoly = false})
        mainCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                inMain = true
                if onDuty then
                    exports['prp-core']:DrawText('[E] - Take the elevator to the roof','left')
                    EMSControls("roof")
                else
                    exports['prp-core']:DrawText('You are not EMS or not signed in','left')
                end
            else
                inMain = false
                check = false
                exports['prp-core']:HideText()
            end
        end)

        ---------------

        local main2Poly = {}
        for k, v in pairs(Config.Locations["main2"]) do
            main2Poly[#main2Poly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 2, 2, {
                name="main2"..k,
                debugPoly = false,
                heading = 70,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local main2Combo = ComboZone:Create(main2Poly, {name = "main2Combo", debugPoly = false})
        main2Combo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                inMain2 = true
                if onDuty then
                    exports['prp-core']:DrawText('[E] - Take the elevator down','left')
                    EMSControls("bottomFloor")
                else
                    exports['prp-core']:DrawText('You are not EMS or not signed in','left')
                end
            else
                inMain2 = false
                check = false
                exports['prp-core']:HideText()
            end
        end)

        local bottomFloorPoly = {}
        for k, v in pairs(Config.Locations["bottomFloor"]) do
            bottomFloorPoly[#bottomFloorPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1.5, 1.5, {
                name="bottomFloor"..k,
                debugPoly = false,
                heading = 70,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local bottomFloorCombo = ComboZone:Create(bottomFloorPoly, {name = "bottomFloorPoly", debugPoly = false})
        bottomFloorCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="ambulance" then
                inBottomFloor = true
                if onDuty then
                    exports['prp-core']:DrawText('[E] - Take the elevator to the main floor','left')
                    EMSControls("main2")
                else
                    exports['prp-core']:DrawText('You are not EMS or not signed in','left')
                end
            else
                inBottomFloor = false
                check = false
                exports['prp-core']:HideText()
            end
        end)
    end)
end