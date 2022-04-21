-- Variables
local isEscorting = false

-- Functions

exports('IsHandcuffed', function()
    return isHandcuffed
end)

local function loadAnimDict(dict) -- interactions, job,
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

local function IsTargetDead(playerId)
    local retval = false
    ProjectRP.Functions.TriggerCallback('police:server:isPlayerDead', function(result)
        retval = result
    end, playerId)
    Wait(100)
    return retval
end

local function HandCuffAnimation()
    local ped = PlayerPedId()
    if isHandcuffed == true then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Cuff", 0.2)
    else
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
    end

    loadAnimDict("mp_arrest_paired")
	Wait(100)
    TaskPlayAnim(ped, "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Cuff", 0.2)
	Wait(3500)
    TaskPlayAnim(ped, "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

local function GetCuffedAnimation(playerId)
    local ped = PlayerPedId()
    local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
    local heading = GetEntityHeading(cuffer)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Cuff", 0.2)
    loadAnimDict("mp_arrest")
    SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
    
	Wait(100)
	SetEntityHeading(ped, heading)
	TaskPlayAnim(ped, "mp_arrest", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0 ,true, true, true)
	Wait(2500)
end

-- Events

RegisterNetEvent('police:client:SetOutVehicle', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, vehicle, 16)
    end
end)

RegisterNetEvent('police:client:PutInVehicle', function()
    local ped = PlayerPedId()
    if isHandcuffed or isEscorted then
        local vehicle = ProjectRP.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), 1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    isEscorted = false
                    TriggerEvent('hospital:client:isEscorted', isEscorted)
                    ClearPedTasks(ped)
                    DetachEntity(ped, true, false)

                    Wait(100)
                    SetPedIntoVehicle(ped, vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('police:client:SearchPlayer', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
        TriggerServerEvent("police:server:SearchPlayer", playerId)
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeCash', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("police:server:SeizeCash", playerId)
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeDriverLicense', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("police:server:SeizeDriverLicense", playerId)
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)


RegisterNetEvent('police:client:RobPlayer', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    local ped = PlayerPedId()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if (IsEntityPlayingAnim(oped, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(playerPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(playerPed, "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(playerPed, "amb@code_human_cower@male@base", "base", 3) or  IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(playerPed, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(playerPed, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(playerPed, "missfbi5ig_22", "hands_up_loop_scientist", 3) ) or IsTargetDead(playerId) then
            if IsPedArmed(PlayerPedId(), 7) then
                ProjectRP.Functions.Progressbar("robbing_player", "Robbing person..", math.random(5000, 7000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "random@shop_robbery",
                    anim = "robbery_action_b",
                    flags = 16,
                }, {}, {}, function() -- Done
                    local plyCoords = GetEntityCoords(playerPed)
                    local pos = GetEntityCoords(ped)
                    if #(pos - plyCoords) < 2.5 then
                        StopAnimTask(ped, "random@shop_robbery", "robbery_action_b", 1.0)
                        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                        TriggerEvent("inventory:server:RobPlayer", playerId)
                    else
                        ProjectRP.Functions.Notify("No one nearby!", "error")
                    end
                end, function() -- Cancel
                    StopAnimTask(ped, "random@shop_robbery", "robbery_action_b", 1.0)
                    ProjectRP.Functions.Notify("Canceled..", "error")
                end)
            else
                ProjectRP.Functions.Notify("You need a weapon!", "error")
            end
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)


RegisterNetEvent('police:client:JailCommand', function(playerId, time)
    exports['prp-tasknotify']:AddDialog("Police", "Are you sure you want to send this person to jail for <b>" .. tonumber(time) .. "</b> months?", function(val)
        if val then
            ProjectRP.Functions.Progressbar("sending_Boilingbroke", 'Sending to Boilingbroke', 2000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
            end, function() -- Cancel

            end)
        end
    end)
end)

RegisterNetEvent('police:client:FineCommand', function(playerId, fine)
    exports['prp-tasknotify']:AddDialog("Police", "Are you sure you want to fine this person for <b>$" .. tonumber(fine) .. "</b>?", function(val)
        if val then
            TriggerServerEvent("axel:bill:player", playerId, fine)
        end
    end)
end)

RegisterNetEvent('police:client:BillCommand', function(playerId, price)
    TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(price))
end)

RegisterNetEvent('police:client:JailPlayer', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(7)
        end
        local time = GetOnscreenKeyboardResult()
        if tonumber(time) > 0 then
            TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
        else
            ProjectRP.Functions.Notify("Time must be higher than 0..", "error")
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:BillPlayer', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(7)
        end
        local price = GetOnscreenKeyboardResult()
        if tonumber(price) > 0 then
            TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(price))
        else
            ProjectRP.Functions.Notify("Time must be higher than 0..", "error")
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:PutPlayerInVehicle', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:PutPlayerInVehicle", playerId)
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SetPlayerOutVehicle', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:SetPlayerOutVehicle", playerId)
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:EscortPlayer', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:EscortPlayer", playerId)
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:KidnapPlayer', function()
    local player, distance = ProjectRP.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not IsPedInAnyVehicle(GetPlayerPed(player)) then
            if not isHandcuffed and not isEscorted then
                TriggerServerEvent("police:server:KidnapPlayer", playerId)
            end
        end
    else
        ProjectRP.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:CuffPlayerSoft', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = ProjectRP.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(PlayerPedId())) then
                TriggerServerEvent("police:server:CuffPlayer", playerId, true)
                HandCuffAnimation()
            else
                ProjectRP.Functions.Notify("You cant cuff someone in a vehicle", "error")
            end
        else
            ProjectRP.Functions.Notify("No one nearby!", "error")
        end
    else
        Wait(2000)
    end
end)

RegisterNetEvent('police:client:CuffPlayer', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = ProjectRP.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(result)
                if result then 
                    local playerId = GetPlayerServerId(player)
                    if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(PlayerPedId())) then
                        TriggerServerEvent("police:server:CuffPlayer", playerId, false)
                        HandCuffAnimation()
                    else
                        ProjectRP.Functions.Notify("You can\'t cuff someone in a vehicle", "error")
                    end
                else
                    ProjectRP.Functions.Notify("You don\'t have handcuffs on you", "error")
                end
            end, "handcuffs")
        else
            ProjectRP.Functions.Notify("No one nearby!", "error")
        end
    else
        Wait(2000)
    end
end)

RegisterNetEvent('police:client:GetEscorted', function(playerId)
    local ped = PlayerPedId()
    ProjectRP.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or isHandcuffed or PlayerData.metadata["inlaststand"] then
            if not isEscorted then
                isEscorted = true
                draggerId = playerId
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
                AttachEntityToEntity(ped, dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                isEscorted = false
                DetachEntity(ped, true, false)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

RegisterNetEvent('police:client:DeEscort', function()
    isEscorted = false
    TriggerEvent('hospital:client:isEscorted', isEscorted)
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('police:client:GetKidnappedTarget', function(playerId)
    local ped = PlayerPedId()
    ProjectRP.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] or isHandcuffed then
            if not isEscorted then
                isEscorted = true
                draggerId = playerId
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                RequestAnimDict("nm")

                while not HasAnimDictLoaded("nm") do
                    Wait(10)
                end
                -- AttachEntityToEntity(PlayerPedId(), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                AttachEntityToEntity(ped, dragger, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                TaskPlayAnim(ped, "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
            else
                isEscorted = false
                DetachEntity(ped, true, false)
                ClearPedTasksImmediately(ped)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

RegisterNetEvent('police:client:GetKidnappedDragger', function(playerId)
    ProjectRP.Functions.GetPlayerData(function(PlayerData)
        if not isEscorting then
            draggerId = playerId
            local dragger = PlayerPedId()
            RequestAnimDict("missfinale_c2mcs_1")

            while not HasAnimDictLoaded("missfinale_c2mcs_1") do
                Wait(10)
            end
            TaskPlayAnim(dragger, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, 100000, 49, 0, false, false, false)
            isEscorting = true
        else
            local dragger = PlayerPedId()
            ClearPedSecondaryTask(dragger)
            ClearPedTasksImmediately(dragger)
            isEscorting = false
        end
        TriggerEvent('hospital:client:SetEscortingState', isEscorting)
        TriggerEvent('prp-kidnapping:client:SetKidnapping', isEscorting)
    end)
end)

RegisterNetEvent('police:client:GetCuffed', function(playerId, isSoftcuff)
    local ped = PlayerPedId()
    

    if not isHandcuffed then

    local success = exports['prp-lock']:StartLockPickCircle(1, seconds, success)

    if success then 
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
        ProjectRP.Functions.Notify("You escaped!")
        return
    end
        isHandcuffed = true
        TriggerServerEvent("police:server:SetHandcuffStatus", true)
        ClearPedTasksImmediately(ped)
        if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
        if not isSoftcuff then
            cuffType = 16
            GetCuffedAnimation(playerId)
            ProjectRP.Functions.Notify("You are cuffed!")
        else
            cuffType = 49
            GetCuffedAnimation(playerId)
            ProjectRP.Functions.Notify("You are cuffed, but you can walk")
        end
    else
        isHandcuffed = false
        isEscorted = false
        TriggerEvent('hospital:client:isEscorted', isEscorted)
        DetachEntity(ped, true, false)
        TriggerServerEvent("police:server:SetHandcuffStatus", false)
        ClearPedTasksImmediately(ped)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
        ProjectRP.Functions.Notify("You are uncuffed!")
    end

end)

-- Threads

CreateThread(function()
    while true do
        Wait(1)
        if isEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
        end

        if isHandcuffed then
            DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
            EnableControlAction(0, 249, true) -- Added for talking while cuffed
            EnableControlAction(0, 46, true)  -- Added for talking while cuffed

            if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not ProjectRP.Functions.GetPlayerData().metadata["isdead"] then
                loadAnimDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, cuffType, 0, 0, 0, 0)
            end
        end
        if not isHandcuffed and not isEscorted then
            Wait(2000)
        end
    end
end)
