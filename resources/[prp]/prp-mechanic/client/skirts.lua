local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Skirts
RegisterNetEvent('prp-mechanic:client:Skirts:Apply', function(data)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)
	local modName = GetLabelText(GetModTextLabel(vehicle, tonumber(data.bumperid), tonumber(data.mod)))
	if modName == "NULL" then modName = Loc[Config.Lan]["common"].stock end
	if GetVehicleMod(vehicle, tonumber(data.bumperid)) == tonumber(data.mod) then TriggerEvent('ProjectRP:Notify', modName..Loc[Config.Lan]["common"].already, "error") TriggerEvent('prp-mechanic:client:Skirts:Choose', tonumber(data.bumperid))
	elseif GetVehicleMod(vehicle, tonumber(data.bumperid)) ~= tonumber(data.mod) then
		time = math.random(3000,5000)
		ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["common"].installing..modName.."..", time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, 
		{ animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", flags = 8, }, {}, {}, function()
			SetVehicleMod(vehicle, tonumber(data.bumperid), tonumber(data.mod))
			emptyHands(playerPed)
			updateCar(vehicle)
			TriggerEvent('prp-mechanic:client:Skirts:Choose', tonumber(data.bumperid))
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["skirts"].installed, "success")
		end, function() -- Cancel
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["skirts"].failed, "error")
			emptyHands(playerPed)
		end)
	end
end)

RegisterNetEvent('prp-mechanic:client:Skirts:Check', function()
	if Config.CosmeticsJob then if not jobChecks() then return end end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)  
	if not inCar() then return end
	if not nearPoint(coords) then return end
	local vehicle = nil
	if not IsPedInAnyVehicle(playerPed, false) then	vehicle = getClosest(coords) pushVehicle(vehicle) end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if DoesEntityExist(vehicle) then
		if GetLabelText(GetModTextLabel(vehicle, 3, GetVehicleMod(vehicle, 3))) == "NULL" then installed1 = Loc[Config.Lan]["common"].stock else installed1 = GetLabelText(GetModTextLabel(vehicle, 3, GetVehicleMod(vehicle, 3))) end
		if GetLabelText(GetModTextLabel(vehicle, 9, GetVehicleMod(vehicle, 9))) == "NULL" then installed2 = Loc[Config.Lan]["common"].stock else installed2 = GetLabelText(GetModTextLabel(vehicle, 9, GetVehicleMod(vehicle, 9))) end
		if GetLabelText(GetModTextLabel(vehicle, 8, GetVehicleMod(vehicle, 8))) == "NULL" then installed3 = Loc[Config.Lan]["common"].stock else installed3 = GetLabelText(GetModTextLabel(vehicle, 8, GetVehicleMod(vehicle, 8))) end				
		if GetNumVehicleMods(vehicle, 3) == 0 and GetNumVehicleMods(vehicle, 9) == 0 and GetNumVehicleMods(vehicle, 8) == 0 then
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error")
			return
		end			
		local SkirtMenu = {
			{ isMenuHeader = true, header = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))..Loc[Config.Lan]["skirts"].menuheader, },
			{ header = "", txt = Loc[Config.Lan]["common"].close, params = { event = "prp-mechanic:client:Menu:Close" } } }
		if GetNumVehicleMods(vehicle, 3) ~= 0 then SkirtMenu[#SkirtMenu + 1] = { header = Loc[Config.Lan]["skirts"].menuskirt, txt = "["..(GetNumVehicleMods(vehicle, 3)+1)..Loc[Config.Lan]["common"].menuinstalled..installed1, params = { event = "prp-mechanic:client:Skirts:Choose", args = 3 } } end
		if GetNumVehicleMods(vehicle, 9) ~= 0 then SkirtMenu[#SkirtMenu + 1] = { header = Loc[Config.Lan]["skirts"].menuRF, txt = "["..(GetNumVehicleMods(vehicle, 9)+1)..Loc[Config.Lan]["common"].menuinstalled..installed2, params = { event = "prp-mechanic:client:Skirts:Choose", args = 9 } } end
		if GetNumVehicleMods(vehicle, 8) ~= 0 then SkirtMenu[#SkirtMenu + 1] = { header = Loc[Config.Lan]["skirts"].menuLF, txt = "["..(GetNumVehicleMods(vehicle, 8)+1)..Loc[Config.Lan]["common"].menuinstalled..installed3, params = { event = "prp-mechanic:client:Skirts:Choose", args = 8 } } end
		exports['prp-menu']:openMenu(SkirtMenu)					
	end
end)

RegisterNetEvent('prp-mechanic:client:Skirts:Choose', function(mod)
	local playerPed	= PlayerPedId()
    local coords = GetEntityCoords(playerPed)
	local validMods = {}
	if not inCar() then return end
	if not nearPoint(coords) then return end
	local vehicle = nil
	if not IsPedInAnyVehicle(playerPed, false) then vehicle = getClosest(coords) pushVehicle(vehicle)
		for i = 1, GetNumVehicleMods(vehicle, mod) do
			if GetVehicleMod(vehicle, mod) == (i-1) then txt = Loc[Config.Lan]["common"].current else txt = "" end
			validMods[i] = { id = (i - 1), name = GetLabelText(GetModTextLabel(vehicle, mod, (i - 1))), install = txt }
		end
	end
	if DoesEntityExist(vehicle) then
		if GetVehicleMod(vehicle, mod) == -1 then stockinstall = Loc[Config.Lan]["common"].current else stockinstall = "" end
		local SkirtsMenu = {
				{ isMenuHeader = true, header = searchCar(vehicle)..Loc[Config.Lan]["skirts"].menuheader, txt = Loc[Config.Lan]["common"].amountoption..#validMods+1, },
				{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Skirts:Check" } },
				{ header = "0. "..Loc[Config.Lan]["common"].stock, txt = stockinstall,	params = { event = "prp-mechanic:client:Skirts:Apply", args = { mod = -1, bumperid = tonumber(mod) } } } }
			for k,v in pairs(validMods) do
				SkirtsMenu[#SkirtsMenu + 1] = { header = k..". "..v.name, txt = v.install, params = { event = 'prp-mechanic:client:Skirts:Apply', args = { mod = tostring(v.id), bumperid = tonumber(mod) } } }
			end
		exports['prp-menu']:openMenu(SkirtsMenu)
	end
end)
