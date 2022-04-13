local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Armour
-- Add Armour
RegisterNetEvent('prp-mechanic:client:applyArmour', function()
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not jobChecks() then return end
	if not inCar() then return end
	if not nearPoint(coords) then return end
	if not IsPedInAnyVehicle(playerPed, false) then	vehicle = getClosest(coords) pushVehicle(vehicle) end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if DoesEntityExist(vehicle) then
		if GetNumVehicleMods(vehicle, 16) == 0 then	TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["armour"].cant, "error") return end
		if GetVehicleMod(vehicle, 16)+1 == GetNumVehicleMods(vehicle, 16) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].already, "error") else
			TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
			Wait(1000)
			SetVehicleEngineOn(vehicle, false, false, true)
			SetVehicleDoorOpen(vehicle, 4, false, false)
			time = math.random(7000,10000)
			ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["armour"].install, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
			{ animDict = "mini@repair", anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
				SetVehicleMod(vehicle, 16, GetNumVehicleMods(vehicle, 16)-1)
				SetVehicleDoorShut(vehicle, 4, false)
				emptyHands(playerPed)
				updateCar(vehicle)
				TriggerServerEvent('prp-mechanic:server:removeArmour')
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["armour"].installed, "success")
			end, function() -- Cancel
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["armour"].failed, "error")
				SetVehicleDoorShut(vehicle, 4, false)
				emptyHands(playerPed)
			end)
		end
	end
end)
-- Remove Armour
RegisterNetEvent('prp-mechanic:client:giveArmor', function()
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
	Wait(1000)
	SetVehicleDoorOpen(vehicle, 4, false, false)
	ProjectRP.Functions.Progressbar("accepted_key", Loc[Config.Lan]["armour"].removing, 8000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, }, 
	{ animDict = "mini@repair", anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
		if GetVehicleMod(vehicle, 16) == -1 then TriggerServerEvent("prp-mechanic:server:DupeWarn", "car armor") emptyHands(playerPed) return end
		SetVehicleMod(vehicle, 16, -1)
		SetVehicleDoorShut(vehicle, 4, false)
		updateCar(vehicle)
		TriggerServerEvent('prp-mechanic:server:giveArmour')
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["armour"].removed, "success")
		emptyHands(playerPed)				
	end, function()
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["armour"].remfail, "error")
		emptyHands(playerPed)
	end)
end)