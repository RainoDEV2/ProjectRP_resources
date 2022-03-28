local debugProps, sitting, lastPos, currentSitCoords, currentScenario = {}
local disableControls = false
local currentObj = nil

ProjectRP = exports["prp-core"]:GetCoreObject()
--if Config.Debug then
--     Citizen.CreateThread(function() 
--         while ProjectRP == nil do
--             TriggerEvent("ProjectRP:GetObject", function(obj) ProjectRP = obj end)    
--             Citizen.Wait(200)
--             LoggedIn = true
--         end
--     end)
-- --end


RegisterNetEvent("ProjectRP:Client:OnPlayerLoaded")
AddEventHandler("ProjectRP:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1000, function()
       -- TriggerEvent("ProjectRP:GetObject", function(obj) ProjectRP = obj end)    
        Citizen.Wait(250)
        LoggedIn = true
    end)
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload')
AddEventHandler('ProjectRP:Client:OnPlayerUnload', function()
    LoggedIn = false
end)


if Config.Debug then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			for i=1, #debugProps, 1 do
				local coords = GetEntityCoords(debugProps[i])
				local hash = GetEntityModel(debugProps[i])
				local id = coords.x .. coords.y .. coords.z
				local model = 'unknown'

				for i=1, #Config.Interactables, 1 do
					local seat = Config.Interactables[i]

					if hash == GetHashKey(seat) then
						model = seat
						break
					end
				end

				local text = ('ID: %s~n~Hash: %s~n~Model: %s'):format(id, hash, model)

				ProjectRP.Functions.DrawText3D(
					 coords.x,
					 coords.y,
					 coords.z + 2.0
				, text, 0.5)
			end

			if #debugProps == 0 then
				Citizen.Wait(500)
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup()
		end

		if IsControlJustPressed(0, 38) and IsControlPressed(0, 21) and IsInputDisabled(0) and IsPedOnFoot(playerPed) then
			if sitting then
				wakeup()
			end			
		end
	end
end)

Citizen.CreateThread(function()
	local Sitables = {}

	for k,v in pairs(Config.Interactables) do
		local model = GetHashKey(v)
		table.insert(Sitables, model)
	end
	Wait(100)
	exports['prp-target']:AddTargetModel(Sitables, {
        options = {
            {
                event = "Boost-Sit:Sit",
                icon = "chair",
                label = "Sit",
            },
        },
        job = {"all"},
        distance = Config.MaxDistance
    })
end)

RegisterNetEvent("Boost-Sit:Sit")
AddEventHandler("Boost-Sit:Sit", function()
	print("Nu suveikiau")
	local playerPed = PlayerPedId()

	if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
		wakeup()
	end

		-- Disable controls
	if disableControls then
		DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	end

	local object, distance = GetNearChair()

	if Config.Debug then
		table.insert(debugProps, object)
	end

	if distance and distance < 1.4 then
		local hash = GetEntityModel(object)

		for k,v in pairs(Config.Sitable) do
			if GetHashKey(k) == hash then
				sit(object, k, v)
				break
			end
		end
	end
end)

function GetNearChair()
	local object, distance
	local coords = GetEntityCoords(GetPlayerPed(-1))
	for i=1, #Config.Interactables do
		object = GetClosestObjectOfType(coords, 3.0, GetHashKey(Config.Interactables[i]), false, false, false)
		distance = #(coords - GetEntityCoords(object))
		if distance < 1.6 then
			return object, distance
		end
	end
	return nil, nil
end

function wakeup()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(GetPlayerPed(-1))

	TaskStartScenarioAtPosition(playerPed, currentScenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
	while IsPedUsingScenario(GetPlayerPed(-1), currentScenario) do
		Wait(100)
	end
	ClearPedTasks(playerPed)

	FreezeEntityPosition(playerPed, false)
	FreezeEntityPosition(currentObj, false)

	TriggerServerEvent('prp-sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
	sitting = false
	disableControls = false
end

function sit(object, modelName, data)
	-- Fix for sit on chairs behind walls
	if not HasEntityClearLosToEntity(GetPlayerPed(-1), object, 17) then
		return
	end
	disableControls = true
	currentObj = object
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(GetPlayerPed(-1))
	local objectCoords = pos.x .. pos.y .. pos.z

	ProjectRP.Functions.TriggerCallback('prp-sit:getPlace', function(occupied)
		if occupied then
			--ProjectRP.ShowNotification('There is someone on this chair')
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('prp-sit:takePlace', objectCoords)
			
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, false)

			Citizen.Wait(2500)
			if GetEntitySpeed(GetPlayerPed(-1)) > 0 then
				ClearPedTasks(GetPlayerPed(-1))
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end

			sitting = true
		end
	end, objectCoords)
end