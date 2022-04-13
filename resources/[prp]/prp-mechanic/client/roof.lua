local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Roof
RegisterNetEvent('prp-mechanic:client:Roof:Apply', function(mod)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)
	local modName = GetLabelText(GetModTextLabel(vehicle, 10, tonumber(mod)))
	if modName == "NULL" then modName = Loc[Config.Lan]["common"].stock end
	if GetVehicleMod(vehicle, 10) == tonumber(mod) then TriggerEvent('ProjectRP:Notify', modName..Loc[Config.Lan]["common"].already, "error") TriggerEvent('prp-mechanic:client:Roof:Check')
	elseif GetVehicleMod(vehicle, 10) ~= tonumber(mod) then
		time = math.random(3000,5000)
		TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
		Wait(1000)
		ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["common"].installing..modName.."..", time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, }, 
		{ task = "WORLD_HUMAN_WELDING" }, {}, {}, function()
			emptyHands(playerPed)
			SetVehicleMod(vehicle, 10, tonumber(mod))
			updateCar(vehicle)
			TriggerEvent('prp-mechanic:client:Roof:Check')
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["roof"].installed, "success")
		end, function() -- Cancel
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].failed, "error")
			emptyHands(playerPed)
		end)
	end
end)

RegisterNetEvent('prp-mechanic:client:Roof:Check', function()
	if Config.CosmeticsJob then if not jobChecks() then return end end
	local playerPed	= PlayerPedId()
    local coords = GetEntityCoords(playerPed)
	local validMods = {}
	if not inCar() then return end
	if not nearPoint(coords) then return end
	local vehicle = nil
	if not IsPedInAnyVehicle(playerPed, false) then vehicle = getClosest(coords) pushVehicle(vehicle)
		if GetNumVehicleMods(vehicle, 10) == 0 then	TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error") return end
		for i = 1, GetNumVehicleMods(vehicle, 10) do
			if GetVehicleMod(vehicle, 10) == (i-1) then	txt = Loc[Config.Lan]["common"].current else txt = "" end
			validMods[i] = { id = (i-1), name = GetLabelText(GetModTextLabel(vehicle, 10, (i - 1))), install = txt }
		end
	end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if GetVehicleMod(vehicle, 10) == -1 then stockinstall = Loc[Config.Lan]["common"].current else stockinstall = "" end
	local RoofMenu = {
			{ isMenuHeader = true, header = searchCar(vehicle)..Loc[Config.Lan]["roof"].menuheader, txt = Loc[Config.Lan]["common"].amountoption..GetNumVehicleMods(vehicle, 10)+1,	},
			{ header = "", txt = Loc[Config.Lan]["common"].close, params = { event = "prp-mechanic:client:Menu:Close" } },
			{ header = Loc[Config.Lan]["common"].stock, txt = stockinstall,	params = { event = "prp-mechanic:client:Roof:Apply", args = -1 } } }
		for k,v in pairs(validMods) do
			RoofMenu[#RoofMenu + 1] = { header = k..". "..v.name, txt = v.install, params = { event = 'prp-mechanic:client:Roof:Apply', args = tostring(v.id) } }
		end
	exports['prp-menu']:openMenu(RoofMenu)
end)