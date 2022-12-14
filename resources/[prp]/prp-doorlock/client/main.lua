local ProjectRP = exports['prp-core']:GetCoreObject()
local closestDoorKey, closestDoorValue = nil, nil
local maxDistance = 1.25
local PlayerGang = {}
local PlayerJob = {}
local doorFound = false
-- Events

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    TriggerServerEvent("prp-doorlock:server:setupDoors")
	PlayerJob = ProjectRP.Functions.GetPlayerData().job
	PlayerGang = ProjectRP.Functions.GetPlayerData().gang
end)

RegisterNetEvent('prp-doorlock:client:setState', function(doorID, state)
	PRP.Doors[doorID].locked = state
	local current = PRP.Doors[doorID]
	if current.doors then
		for a = 1, #current.doors do
			local currentDoor = current.doors[a]
			local doorHash = type(currentDoor.objName) == 'number' and currentDoor.objName or GetHashKey(currentDoor.objName)
			if not currentDoor.object or not DoesEntityExist(currentDoor.object) then
				currentDoor.object = GetClosestObjectOfType(currentDoor.objCoords, 1.0, doorHash, false, false, false)
			end
			FreezeEntityPosition(currentDoor.object, current.locked)

			if current.locked and currentDoor.objYaw and GetEntityRotation(currentDoor.object).z ~= currentDoor.objYaw then
				SetEntityRotation(currentDoor.object, 0.0, 0.0, currentDoor.objYaw, 2, true)
			end
		end
	else
		local doorHash = type(current.objName) == 'number' and current.objName or GetHashKey(current.objName)
		if not current.object or not DoesEntityExist(current.object) then
			current.object = GetClosestObjectOfType(current.objCoords, 1.0, doorHash, false, false, false)
		end
		FreezeEntityPosition(current.object, current.locked)

		if current.locked and current.objYaw and GetEntityRotation(current.object).z ~= current.objYaw then
			SetEntityRotation(current.object, 0.0, 0.0, current.objYaw, 2, true)
		end
	end
end)

RegisterNetEvent('prp-doorlock:client:setDoors', function(doorList)
	PRP.Doors = doorList
end)

RegisterNetEvent('ProjectRP:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate', function(jobInfo)
	PlayerJob = jobInfo
end)

RegisterNetEvent('lockpicks:UseLockpick', function()
	local pos = GetEntityCoords(PlayerPedId())
	ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
		for k, v in pairs(PRP.Doors) do
			local dist = #(pos - vector3(PRP.Doors[k].textCoords.x, PRP.Doors[k].textCoords.y, PRP.Doors[k].textCoords.z))
			if dist < 1.5 then
				if PRP.Doors[k].pickable then
					if PRP.Doors[k].locked then
						if hasItem then
							closestDoorKey, closestDoorValue = k, v
							TriggerEvent('prp-lockpick:client:openLockpick', lockpickFinish)
						else
							ProjectRP.Functions.Notify("You Dont Have A Screwdriver Set", "error")
						end
					else
						ProjectRP.Functions.Notify('The Door Is Not Locked', 'error', 2500)
					end
				else
					ProjectRP.Functions.Notify('This Door Can Not Be Lockpicked', 'error', 2500)
				end
			end
		end
    end, "screwdriverset")
end)

-- Functions

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

function lockpickFinish(success)
    if success then
		ProjectRP.Functions.Notify('Success!', 'success', 2500)
		setDoorLocking(closestDoorValue, closestDoorKey)
    else
        ProjectRP.Functions.Notify('Failed', 'error', 2500)
    end
end

function setDoorLocking(doorId, key)
	doorId.locking = true
	openDoorAnim()
    SetTimeout(400, function()
		doorId.locking = false
		doorId.locked = not doorId.locked
		TriggerServerEvent('prp-doorlock:server:updateState', key, doorId.locked)
	end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function IsAuthorized(doorID)
	for _,job in pairs(doorID.authorizedJobs) do
		if job == PlayerJob.name or job == PlayerGang.name then
			return true
		end
	end

	return false
end

function openDoorAnim()
    loadAnimDict("anim@heists@keycard@")
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
	SetTimeout(400, function()
		ClearPedTasks(PlayerPedId())
	end)
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Threads

CreateThread(function()
	while true do
		Wait(0)
		local playerCoords, awayFromDoors = GetEntityCoords(PlayerPedId()), true

		for i = 1, #PRP.Doors do
			local current = PRP.Doors[i]
			local distance

			if current.doors then
				distance = #(playerCoords - current.doors[1].objCoords)
			else
				distance = #(playerCoords - current.objCoords)
			end

			if current.distance then
				maxDistance = current.distance
			end

			if distance < 10.0 and not doorFound then
				awayFromDoors = false
				if current.doors then
					for a = 1, #current.doors do
						local currentDoor = current.doors[a]
						local doorHash = type(currentDoor.objName) == 'number' and currentDoor.objName or GetHashKey(currentDoor.objName)
						if not currentDoor.object or not DoesEntityExist(currentDoor.object) then
							currentDoor.object = GetClosestObjectOfType(currentDoor.objCoords, 1.0, doorHash, false, false, false)
						end
						FreezeEntityPosition(currentDoor.object, current.locked)

						if current.locked and currentDoor.objYaw and GetEntityRotation(currentDoor.object).z ~= currentDoor.objYaw then
							SetEntityRotation(currentDoor.object, 0.0, 0.0, currentDoor.objYaw, 2, true)
						end
					end
				else
					local doorHash = type(current.objName) == 'number' and current.objName or GetHashKey(current.objName)
					if not current.object or not DoesEntityExist(current.object) then
						current.object = GetClosestObjectOfType(current.objCoords, 1.0, doorHash, false, false, false)
					end
					FreezeEntityPosition(current.object, current.locked)

					if current.locked and current.objYaw and GetEntityRotation(current.object).z ~= current.objYaw then
						SetEntityRotation(current.object, 0.0, 0.0, current.objYaw, 2, true)
					end
				end
			end

			if distance < maxDistance then
				awayFromDoors = false
				doorFound = true
				if current.size then
					size = current.size
				end

				local isAuthorized = IsAuthorized(current)

				if isAuthorized then
					if current.locked then
						displayText = "[~g~E~w~] - Locked"
					elseif not current.locked then
						displayText = "[~g~E~w~] - Unlocked"

					end
				elseif not isAuthorized then
					if current.locked then
						displayText = "~r~Locked"
					elseif not current.locked then
						displayText = "~g~Unlocked"
					end
				end

				if current.locking then
					if current.locked then
						displayText = "~g~Unlocking.."
					else
						displayText = "~r~Locking.."
					end
				end

				if current.objCoords == nil then
					current.objCoords = current.textCoords
				end

				DrawText3Ds(current.objCoords.x, current.objCoords.y, current.objCoords.z, displayText)

				if IsControlJustReleased(0, 38) then
					if isAuthorized then
						setDoorLocking(current, i)
					else
						ProjectRP.Functions.Notify('Not Authorized', 'error')
					end
				end
			end
		end

		if awayFromDoors then
			doorFound = false
			Citizen.Wait(1000)
		end
	end
end)
