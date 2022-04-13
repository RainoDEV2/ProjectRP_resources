local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Transmission
RegisterNetEvent('prp-mechanic:client:applyTransmission', function(level)
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not inCar() then return end
	if not nearPoint(coords) then return end
	if not IsPedInAnyVehicle(playerPed, false) then vehicle = getClosest(coords) pushVehicle(vehicle) end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if DoesEntityExist(vehicle) then
		currentTrans = GetVehicleMod(vehicle, 13)
		if GetNumVehicleMods(vehicle, 13) == 0 then	TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["transmission"].cant, "error") return end
		if currentTrans == level then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].already, "error") else
			TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
			Wait(1000)				
			SetVehicleEngineOn(vehicle, false, false, true)
			SetVehicleDoorOpen(vehicle, 4, false, false)
			time = math.random(7000,10000)
			ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["common"].installing.."LVL: "..level+1, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, 
			{ animDict = "mini@repair",	anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
				if GetVehicleMod(vehicle, 13) ~= currentTrans then TriggerServerEvent("prp-mechanic:server:DupeWarn", "transmission"..(currentTrans+1)) emptyHands(playerPed) return end
				SetVehicleMod(vehicle, 13, level)
				SetVehicleDoorShut(vehicle, 4, false)
				updateCar(vehicle)
				TriggerServerEvent('prp-mechanic:server:removeTransmission', level, currentTrans)
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["transmission"].installed, "success")
				emptyHands(playerPed)
			end, function() -- Cancel
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["transmission"].failed, "error")
				SetVehicleDoorShut(vehicle, 4, false)
				emptyHands(playerPed)
			end)
		end
	end
end)

RegisterNetEvent('prp-mechanic:client:giveTransmission', function()
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)	
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	currentTrans = GetVehicleMod(vehicle, 13)
	SetVehicleDoorOpen(vehicle, 4, false, false)
	TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
	Wait(1000)
	ProjectRP.Functions.Progressbar("accepted_key", Loc[Config.Lan]["transmission"].removing, 8000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
	{ animDict = "mini@repair", anim = "fixing_a_ped", flags = 16, }, {}, {}, function() -- Done
		if GetVehicleMod(vehicle, 13) ~= currentTrans then TriggerServerEvent("prp-mechanic:server:DupeWarn", "transmission"..(currentTrans+1)) emptyHands(playerPed) return end
		ClearPedTasks(playerPed)
		SetVehicleMod(vehicle, 13, -1)
		SetVehicleDoorShut(vehicle, 4, false)
		updateCar(vehicle)
		TriggerServerEvent('prp-mechanic:server:removeTransmission', nil, currentTrans)
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["transmission"].remove, "success")
		emptyHands(playerPed)
	end, function() -- Cancel
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["transmission"].remfail, "error")
		emptyHands(playerPed)
	end)
end)