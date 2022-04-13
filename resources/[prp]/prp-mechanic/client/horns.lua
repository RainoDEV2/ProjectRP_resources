local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Horn
RegisterNetEvent('prp-mechanic:client:Horn:Apply', function(data)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)
	time = math.random(3000,5000)
	SetVehicleDoorOpen(vehicle, 4, false, false)
	ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["common"].installing..data.name.."..", time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
	{ animDict = "mini@repair", anim = "fixing_a_ped", flags = 8, }, {}, {}, function()
		SetVehicleMod(vehicle, 14, tonumber(data.mod))
		SetVehicleDoorShut(vehicle, 4, false, false)
		emptyHands(playerPed)
		updateCar(vehicle)
		TriggerEvent('prp-mechanic:client:Horn:Check')
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["horns"].installed, "success")
	end, function() -- Cancel
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["horns"].failed, "error")
		emptyHands(playerPed)
		SetVehicleDoorShut(vehicle, 4, false, false)
	end)
end)

RegisterNetEvent('prp-mechanic:client:Horn:Check', function()
	if Config.CosmeticsJob then if not jobChecks() then return end end
	local playerPed	= PlayerPedId()
    local coords = GetEntityCoords(playerPed)
	local validMods = {}
	if not inCar() then return end
	if not nearPoint(coords) then return end
	local vehicle = nil
	if not IsPedInAnyVehicle(playerPed, false) then vehicle = getClosest(coords) pushVehicle(vehicle)
		hornCheck = GetVehicleMod(vehicle, 14)
		for k, v in pairs(Loc[Config.Lan].vehicleHorns) do	
			if hornCheck == tonumber(v.id) then installed = Loc[Config.Lan]["common"].current else installed = "" end
			validMods[k] = { id = v.id, name = v.name, txt = installed,	}
		end
	end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if DoesEntityExist(vehicle) then
		if GetVehicleMod(vehicle, 14) == -1 then stockinstall = Loc[Config.Lan]["common"].current else stockinstall = "" end
		local HornMenu = {
				{ header = searchCar(vehicle)..Loc[Config.Lan]["horns"].menuheader, txt = Loc[Config.Lan]["common"].amountoption..#validMods+1, params = { event = "prp-mechanic:client:Horn:Test", args = { veh = vehicle } }, },
				{ header = "", txt = Loc[Config.Lan]["common"].close, params = { event = "prp-mechanic:client:Menu:Close" } },
				{ header = "0. "..Loc[Config.Lan]["common"].stock, txt = stockinstall, params = { event = "prp-mechanic:client:Horn:Apply", args = { mod = -1, name = Loc[Config.Lan]["common"].stock } } } }
			for k,v in pairs(validMods) do
				HornMenu[#HornMenu + 1] = { header = k..". "..v.name, txt = v.txt, params = { event = 'prp-mechanic:client:Horn:Apply', args = { mod = v.id, name = v.name } } }
			end
		exports['prp-menu']:openMenu(HornMenu)
	end
end)

RegisterNetEvent('prp-mechanic:client:Horn:Test', function(data)
	StartVehicleHorn(data.veh, 2000, "HELDDOWN", false)
	TriggerEvent('prp-mechanic:client:Horn:Check')
end)