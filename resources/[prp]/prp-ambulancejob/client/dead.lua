local deadAnimDict = "dead"
local deadAnim = "dead_a"
local hold = 5
deathTime = 0

-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function OnDeath()
    if not isDead then
        isDead = true
        TriggerServerEvent("hospital:server:SetDeathStatus", true)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
        local player = PlayerPedId()
        while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Wait(10)
        end

        if isDead then
            local pos = GetEntityCoords(player)
            local heading = GetEntityHeading(player)

            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) then
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                -- local veh = GetVehiclePedIsIn(ped)
                -- local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
                -- for i = -1, vehseats do
                --     local occupant = GetPedInVehicleSeat(veh, i)
                --     if occupant == ped then
                --         NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                --         SetPedIntoVehicle(ped, veh, i)
                --     end
                -- end
            else
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
            end
			
            SetEntityInvincible(player, true)
            SetEntityHealth(player, GetEntityMaxHealth(player))
            if IsPedInAnyVehicle(player, false) then
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                -- loadAnimDict("veh@low@front_ps@idle_duck")
                -- TaskPlayAnim(player, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            else
                loadAnimDict(deadAnimDict)
                TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
            -- TriggerServerEvent('hospital:server:ambulanceAlert', 'Civilian Died')
        end
    end
end

function DeathTimer()
    hold = 5
    while isDead do
        Wait(1000)
        deathTime = deathTime - 1
        if deathTime <= 0 then
            if IsControlPressed(0, 38) and hold <= 0 and not isInHospitalBed then
                TriggerEvent("hospital:client:RespawnAtHospital")
                hold = 5
            end
            if IsControlPressed(0, 38) then
                if hold - 1 >= 0 then
                    hold = hold - 1
                else
                    hold = 0
                end
            end
            if IsControlReleased(0, 38) then
                hold = 5
            end
        end
    end
end

local function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end




-- Threads

-- local ambulancelsleep = 3500
-- CreateThread(function()
-- 	while true do
-- 		local player = PlayerId()
-- 		if NetworkIsPlayerActive(player) then
--             ambulancelsleep = 10
--             local playerPed = PlayerPedId()
--             if IsEntityDead(playerPed) and not InLaststand then
--                 SetLaststand(true)
--             elseif IsEntityDead(playerPed) and InLaststand and not isDead then
--                 SetLaststand(false)
--                 local killer_2, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
--                 local killer = GetPedSourceOfDeath(playerPed)

--                 if killer_2 ~= 0 and killer_2 ~= -1 then
--                     killer = killer_2
--                 end

--                 local killerId = NetworkGetPlayerIndexFromPed(killer)
--                 local killerName = killerId ~= -1 and GetPlayerName(killerId) .. " " .. "("..GetPlayerServerId(killerId)..")" or 'Themselves or an NPC'
--                 local weaponLabel = 'Unknown'
--                 local weaponName = 'Unknown'
--                 local weaponItem = ProjectRP.Shared.Weapons[killerWeapon]

--                 if weaponItem then
--                     weaponLabel = weaponItem.label
--                     weaponName = weaponItem.name
--                 end

--                 titlePlayername = GetPlayerName(-1)
--                 titlePlayerid = GetPlayerServerId(player)
--                 logTitle = titlePlayername .. "(" .. titlePlayerid .. ") is dead"
--                 logMessage = killerName .. "has killed " .. GetPlayerName(player) .. " with a **" .. weaponLabel .. "** (" .. weaponName .. ")"
--                 TriggerServerEvent("prp-log:server:CreateLog", "death", titleText, "red", logMessage)
--                 deathTime = Config.DeathTime
--                 OnDeath()
--                 DeathTimer()
--             end
-- 		end
--         Wait(ambulancelsleep)
-- 	end
-- end)

emsNotified = false

CreateThread(function()
	while true do
        sleep = 1000
		if isDead or InLaststand then
            sleep = 5
            local ped = PlayerPedId()
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 0, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 288, true)
            EnableControlAction(0, 213, true)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
            EnableControlAction(0, 47, true)

            if isDead then
                if not isInHospitalBed then

                    if deathTime > 0 then
                        local deathtime = math.ceil(deathTime)
                        DrawTxt(0.93, 1.44, 1.0,1.0,0.6, 'RESPAWN IN: ~r~' .. deathtime .. '~s~ SECONDS', 255, 255, 255, 255)

                        if deathTime < 290 then
                            if not emsNotified then
                                DrawTxt(0.91, 1.40, 1.0, 1.0, 0.6, 'PRESS [~r~G~s~] TO REQUEST HELP', 255, 255, 255, 255)
                            else
                                DrawTxt(0.90, 1.40, 1.0, 1.0, 0.6, 'EMS PERSONNEL HAVE BEEN NOTIFIED', 255, 255, 255, 255)
                            end

                            if IsControlJustPressed(0, 47) and not emsNotified then
                                TriggerServerEvent('hospital:server:ambulanceAlert', 'Civilian Down')
                                emsNotified = true
                            end
                        end

                    else
                        local holdtime = hold
                        local cost = Config.BillCost
                        DrawTxt(0.865, 1.44, 1.0, 1.0, 0.6, 'HOLD [~r~E~s~] FOR ' .. holdtime .. ' SECONDS TO RESPAWN FOR ~r~$' .. cost .. '~s~', 255, 255, 255, 255)
                    end
                end

                if IsPedInAnyVehicle(ped, false) then
                    local pos = GetEntityCoords(PlayerPedId())
                    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                --     loadAnimDict("veh@low@front_ps@idle_duck")
                --     if not IsEntityPlayingAnim(ped, "veh@low@front_ps@idle_duck", "sit", 3) then
                --         TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                --     end
                else
                    if isInHospitalBed then
                        if not IsEntityPlayingAnim(ped, inBedDict, inBedAnim, 3) then
                            loadAnimDict(inBedDict)
                            TaskPlayAnim(ped, inBedDict, inBedAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                        end
                    else
                        if not IsEntityPlayingAnim(ped, deadAnimDict, deadAnim, 3) then
                            loadAnimDict(deadAnimDict)
                            TaskPlayAnim(ped, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                        end
                    end
                end

                SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            -- elseif InLaststand then
            --     sleep = 5

            --     if LaststandTime > Laststand.MinimumRevive then
            --         local time = math.ceil(LaststandTime)
            --         DrawTxt(0.94, 1.44, 1.0, 1.0, 0.6, 'YOU WILL BLEED OUT IN: ~r~' .. time .. '~s~ SECONDS', 255, 255, 255, 255)
            --     else
            --         local time = math.ceil(LaststandTime)
            --         DrawTxt(0.845, 1.44, 1.0, 1.0, 0.6, 'YOU WILL BLEED OUT IN: ~r~' .. time .. '~s~ SECONDS, YOU CAN BE HELPED', 255, 255, 255, 255)
            --         -- if not emsNotified then
            --         --     DrawTxt(0.91, 1.40, 1.0, 1.0, 0.6, 'PRESS [~r~G~s~] TO REQUEST HELP', 255, 255, 255, 255)
            --         -- else
            --         --     DrawTxt(0.90, 1.40, 1.0, 1.0, 0.6, 'EMS PERSONNEL HAVE BEEN NOTIFIED', 255, 255, 255, 255)
            --         -- end

            --         -- if IsControlJustPressed(0, 47) and not emsNotified then
            --         --     TriggerServerEvent('hospital:server:ambulanceAlert', 'Civilian Down')
            --         --     emsNotified = true
            --         -- end
            --     end

            --     if not isEscorted then
            --         if IsPedInAnyVehicle(ped, false) then
            --             local pos = GetEntityCoords(PlayerPedId())
            --             NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
            --             -- loadAnimDict("veh@low@front_ps@idle_duck")
            --             -- if not IsEntityPlayingAnim(ped, "veh@low@front_ps@idle_duck", "sit", 3) then
            --             --     TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            --             -- end
            --         else
            --             loadAnimDict(lastStandDict)
            --             if not IsEntityPlayingAnim(ped, lastStandDict, lastStandAnim, 3) then
            --                 TaskPlayAnim(ped, lastStandDict, lastStandAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            --             end
            --         end
            --     else
            --         if IsPedInAnyVehicle(ped, false) then
            --             local pos = GetEntityCoords(PlayerPedId())
            --             NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
            --             -- loadAnimDict("veh@low@front_ps@idle_duck")
            --             -- if IsEntityPlayingAnim(ped, "veh@low@front_ps@idle_duck", "sit", 3) then
            --             --     StopAnimTask(ped, "veh@low@front_ps@idle_duck", "sit", 3)
            --             -- end
            --         else
            --             loadAnimDict(lastStandDict)
            --             if IsEntityPlayingAnim(ped, lastStandDict, lastStandAnim, 3) then
            --                 StopAnimTask(ped, lastStandDict, lastStandAnim, 3)
            --             end
            --         end
            --     end

            end
		end
        Wait(sleep)
	end
end)













--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
   
    
    deathTime = Config.DeathTime
    OnDeath()
    DeathTimer()


end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)

    deathTime = Config.DeathTime
    OnDeath()
    DeathTimer()

end)






function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE','WEAPON_ASSAULTRIFLE2','WEAPON_ASSAULTRIFLE_MK2','WEAPON_M4', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end




--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------