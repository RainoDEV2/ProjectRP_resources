local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Turbo
RegisterNetEvent('prp-mechanic:client:applyTurbo', function()
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not inCar() then return end
	if not nearPoint(coords) then return end
	if not IsPedInAnyVehicle(playerPed, false) then vehicle = getClosest(coords) pushVehicle(vehicle) end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if DoesEntityExist(vehicle) then
		if GetNumVehicleMods(vehicle,11) == 0 then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error") return end
		if IsToggleModOn(vehicle, 18) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].already, "error") else
			SetVehicleEngineOn(vehicle, false, false, true)
			SetVehicleDoorOpen(vehicle, 4, false, false)
			TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
			Wait(1000)
			time = math.random(7000,10000)
			ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["turbo"].install, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
			{ animDict = "mini@repair",	anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
				if IsToggleModOn(vehicle, 18) then TriggerServerEvent("prp-mechanic:server:DupeWarn", "turbo") emptyHands(playerPed) return end
				ToggleVehicleMod(vehicle, 18, true)
				SetVehicleDoorShut(vehicle, 4, false)
				FreezeEntityPosition(playerPed, false)
				updateCar(vehicle)
				TriggerServerEvent('prp-mechanic:server:removeTurbo')
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["turbo"].installed, "success")
				emptyHands(playerPed)
			end, function() -- Cancel
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["turbo"].failed, "error")
				SetVehicleDoorShut(vehicle, 4, false)
				emptyHands(playerPed)
			end)
		end
	end
end)

RegisterNetEvent('prp-mechanic:client:giveTurbo', function()
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	SetVehicleDoorOpen(vehicle, 4, false, false)
	TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
	Wait(1000)
	ProjectRP.Functions.Progressbar("accepted_key", Loc[Config.Lan]["turbo"].removing, 8000, false, true, {	disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, }, 
	{ animDict = "mini@repair",	anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
		if not IsToggleModOn(vehicle, 18) then TriggerServerEvent("prp-mechanic:server:DupeWarn", "turbo") emptyHands(playerPed) return end
		ToggleVehicleMod(vehicle, 18, false)
		SetVehicleDoorShut(vehicle, 4, false)
		updateCar(vehicle)
		TriggerServerEvent('prp-mechanic:server:giveTurbo')
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["turbo"].remove, "success")
		emptyHands(playerPed)
	end, function() -- Cancel
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["turbo"].remfail, "error")
		emptyHands(playerPed)
	end)
end)