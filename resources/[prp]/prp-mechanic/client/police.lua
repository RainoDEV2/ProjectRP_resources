local ProjectRP = exports['prp-core']:GetCoreObject()

--Set which jobs can use this
Config.QuickJobs = {
	["police"] = 0,
	["ambulance"] = 0,
}

Config.PoliceLocations = {
    --Add your poly zone box locations and job name for each store and it will add it to the prp-target loop above
    { coords = vector3(451.05, -973.19, 25.7), heading = 0, }, -- MRPD UNDERGROUND PARKING
    -- { coords = vector3(-45.27, -1048.43, 28.4), heading = 70.0, }, -- BENNYS NEXT TO PDM
    { coords = vector3(331.90, -565.72, 28.78), heading = 250.0, }, -- PILL BOX GARAGE
    { coords = vector3(332.70, -566.00, 28.78), heading = 70.0, }, -- PILL BOX GARAGE
}

local bench = {}
CreateThread(function()
	for k, v in pairs(Config.PoliceLocations) do
		RequestModel(GetHashKey("imp_prop_impexp_mechbench"))
		while not HasModelLoaded(GetHashKey("imp_prop_impexp_mechbench")) do Citizen.Wait(2) end
		bench[#bench+1] = CreateObject(GetHashKey("imp_prop_impexp_mechbench"),v.coords.x, v.coords.y, v.coords.z-1,false,false,false)
		SetEntityHeading(bench[#bench], v.heading)
		FreezeEntityPosition(bench[#bench], true)
		exports['prp-target']:AddBoxZone("bench"..k, v.coords, 1.2, 4.2, { name="bench"..k, heading = v.heading, debugPoly=Config.Debug, minZ = v.coords.z-1, maxZ = v.coords.z+1.4, }, 
			{ options = { { event = "prp-mechanic:client:Police:Menu", icon = "fas fa-cogs", label = "Use Repair Station" , job = Config.QuickJobs, }, }, distance = 5.0 })
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Menu', function()
	local playerPed = PlayerPedId()
	local validMods = {}
	local vehicle = nil
	if not outCar() then return end
	vehicle = GetVehiclePedIsIn(playerPed, false)
	local driver = GetPedInVehicleSeat(vehicle, -1)
	if driver ~= playerPed then return end
	if IsPedInAnyVehicle(playerPed, false) then
		local PoliceMenu = {}
			PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["common"].close, params = { event = "prp-mechanic:client:Menu:Close" } }
			PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["police"].repair, txt = "", params = { event = "prp-mechanic:client:Police:Repair" }, }
			PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["police"].extras, txt = "", params = { event = "prp-mechanic:client:Police:Extra" }, }
			PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["police"].plates, txt = "", params = { event = "prp-mechanic:client:Police:Plates" }, }
			if GetNumVehicleMods(vehicle, 48) > 0 or GetVehicleLiveryCount(vehicle) > -1 then
				PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["police"].livery, txt = "", params = { event = "prp-mechanic:client:Police:Livery" }, } end
			if GetNumVehicleMods(vehicle, 0) ~= 0 then 
				PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["police"].spoiler, txt = "", params = { event = "prp-mechanic:client:Police:Spoiler" }, } end
			PoliceMenu[#PoliceMenu+1] = { header = Loc[Config.Lan]["paint"].menuheader, txt = "", params = { event = "prp-mechanic:client:Police:Paint" }, }
			--PoliceMenu[#PoliceMenu+1] = { header = "Test", txt = "Vehicle Death Simulator", params = { event = "prp-mechanic:client:Police:test" }, }
		exports['prp-menu']:openMenu(PoliceMenu)
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Extra', function()
	local playerPed = PlayerPedId()
	local validMods = {}
	local vehicle = nil
	local hasMod = false
	if not IsPedInAnyVehicle(playerPed, false) then TriggerEvent('prp-mechanic:client:Police:Menu') return end
	vehicle = GetVehiclePedIsIn(playerPed, false)
	local ExtraMenu = {}
	ExtraMenu[#ExtraMenu+1] = { isMenuHeader = true, header = Loc[Config.Lan]["police"].extras, txt = "Toggle Vehicle Extras" }
	ExtraMenu[#ExtraMenu+1] = { header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Menu" }, }
	for i = 0, 20 do
		if DoesExtraExist(vehicle, i) then hadMod = true
		if IsVehicleExtraTurnedOn(vehicle, i) then setheader = "✅ Extra "..i else setheader = "❌ Extra "..i end
		ExtraMenu[#ExtraMenu+1] = { header = setheader, txt = "", params = { event = "prp-mechanic:client:Police:Extra:Apply", args = { id = i }, }, } end
	end
	if hadMod then exports['prp-menu']:openMenu(ExtraMenu) elseif not hadMod then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error") TriggerEvent('prp-mechanic:client:Police:Menu') return end
end)

RegisterNetEvent('prp-mechanic:client:Police:Extra:Apply', function(data)
	local playerPed = PlayerPedId()
	vehicle = GetVehiclePedIsIn(playerPed, false)
	local veh = {}
	veh.engine = GetVehicleEngineHealth(vehicle)
	veh.body = GetVehicleBodyHealth(vehicle)
	if IsVehicleExtraTurnedOn(vehicle, data.id) then SetVehicleExtra(vehicle, data.id, 1)
	else SetVehicleExtra(vehicle, data.id, 0) SetVehicleFixed(vehicle) end
	doCarDamage(vehicle, veh)
	Wait(500)
	SetVehicleEngineHealth(vehicle, veh.engine)
	SetVehicleBodyHealth(vehicle, veh.body)
	TriggerEvent('prp-mechanic:client:Police:Extra')
end)

RegisterNetEvent('prp-mechanic:client:Police:Repair', function()
	local playerPed = PlayerPedId()
	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle)
	FreezeEntityPosition(vehicle, true)
	TriggerEvent("ProjectRP:Notify", "Repairing Engine...")
	SetVehicleEngineHealth(vehicle, 1000.0)
	SetVehicleBodyHealth(vehicle, 1000.0)
	Wait(2000)
	TriggerEvent("ProjectRP:Notify", "Repairing Body...")
	if Config.UseMechJob then
		TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "radiator", 100)
		TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "axle", 100)
		TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "brakes", 100)
		TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "clutch", 100)
		TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "fuel", 100)
	end
	SetVehicleFixed(vehicle)
	Wait(2000)
	TriggerEvent("ProjectRP:Notify", "Cleaning Car...")
	local cleaning = true								
	while cleaning do
		if GetVehicleDirtLevel(vehicle) >= 1.0 then SetVehicleDirtLevel(vehicle, (tonumber(GetVehicleDirtLevel(vehicle))) - 0.8)
		elseif GetVehicleDirtLevel(vehicle) <= 1.0 then SetVehicleDirtLevel(vehicle, 0.0) cleaning = false end
		Wait(300)
	end
	TriggerEvent("ProjectRP:Notify", "Repair Complete", "success")
	FreezeEntityPosition(vehicle, false)
	TriggerEvent('prp-mechanic:client:Police:Menu')
end)

RegisterNetEvent('prp-mechanic:client:Police:Livery', function()
	local playerPed = PlayerPedId()
	local validMods = {}
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) 
        if GetNumVehicleMods(vehicle, 48) == 0 and GetVehicleLiveryCount(vehicle) ~= 0 then
			oldlivery = true
			for i = 0, GetVehicleLiveryCount(vehicle)-1 do
				if GetVehicleLivery(vehicle) == (i) then txt = Loc[Config.Lan]["common"].current
				elseif GetVehicleLivery(vehicle) ~= (i) then txt = "" end
				if i ~= 0 then validMods[i] = { id = i, name = Loc[Config.Lan]["police"].livery.." "..i, install = txt } end
			end
		else
			oldlivery = false
			for i = 1, GetNumVehicleMods(vehicle, 48) do
				local modName = GetLabelText(GetModTextLabel(vehicle, 48, (i - 1)))
				if GetVehicleMod(vehicle, 48) == (i-1) then txt = Loc[Config.Lan]["common"].current
				elseif GetVehicleMod(vehicle, 48) ~= (i-1) then txt = "" end
				validMods[i] = { id = (i - 1), name = modName, install = txt }
			end
		end
	end
	if DoesEntityExist(vehicle) then
		local LiveryMenu = {}
		if oldlivery == true then
				if GetVehicleLivery(vehicle) == 0 then stockinstall = Loc[Config.Lan]["common"].current else stockinstall = "" end
				LiveryMenu[#LiveryMenu + 1] = { isMenuHeader = true, header = Loc[Config.Lan]["livery"].menuheader, txt = 'Amount of Options: '..GetVehicleLiveryCount(vehicle) }
				LiveryMenu[#LiveryMenu + 1] = { header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Menu" }, }
				LiveryMenu[#LiveryMenu + 1] = {  header = "0. "..Loc[Config.Lan]["common"].stock, txt = stockinstall, params = { event = "prp-mechanic:client:Police:Apply", args = { id = tostring(0), old = true } } }
			for k,v in pairs(validMods) do
				LiveryMenu[#LiveryMenu + 1] = { header = k..". "..v.name, txt = v.install, params = { event = 'prp-mechanic:client:Police:Apply', args = { id = tostring(v.id), old = true } } }
			end
		elseif oldlivery ~= true then
				if GetVehicleMod(vehicle, 48) == -1 then stockinstall = Loc[Config.Lan]["common"].current else stockinstall = "" end
				LiveryMenu[#LiveryMenu + 1] = { isMenuHeader = true, header = Loc[Config.Lan]["livery"].menuheader, txt = 'Amount of Options: '..GetNumVehicleMods(vehicle, 48)+1 }
				LiveryMenu[#LiveryMenu + 1] = { header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Menu" }, }
				LiveryMenu[#LiveryMenu + 1] = {  header = "0. "..Loc[Config.Lan]["common"].stock, txt = stockinstall, params = { event = "prp-mechanic:client:Police:Apply", args = { id = tostring(-1) } } }
			for k,v in pairs(validMods) do
				LiveryMenu[#LiveryMenu + 1] = { header = k..". "..v.name, txt = v.install, params = { event = 'prp-mechanic:client:Police:Apply', args = { id = tostring(v.id) } } }
			end
		end
		exports['prp-menu']:openMenu(LiveryMenu)
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Apply', function(data)
	local playerPed	= PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end
	local label = GetModTextLabel(vehicle, 48, tonumber(data.id))
	local modName = GetLabelText(label)
	if data.old then
		if modName == "NULL" then modName = Loc[Config.Lan]["livery"].oldMod end
		if GetVehicleLivery(vehicle) == tonumber(data.id) then
			TriggerEvent('ProjectRP:Notify', data.id..Loc[Config.Lan]["common"].already, "error")
			TriggerEvent('prp-mechanic:client:Police:Livery')
			return
		end
	else
		if modName == "NULL" then modName = Loc[Config.Lan]["common"].stock end
		if GetVehicleMod(vehicle, 48) == tonumber(data.id) then
			TriggerEvent('ProjectRP:Notify', modName..Loc[Config.Lan]["common"].already, "error")
			TriggerEvent('prp-mechanic:client:Police:Livery')
			return
		end
	end
	if data.old then
		if tonumber(data.id) == 0 then 
			SetVehicleMod(vehicle, 48, -1, false) 
			SetVehicleLivery(vehicle, 0)
		else 
			SetVehicleMod(vehicle, 48, -1, false)			
			SetVehicleLivery(vehicle, tonumber(data.id))
		end
	elseif not data.old then
		if tonumber(data.id) == -1 then 
			SetVehicleMod(vehicle, 48, -1, false) 
			SetVehicleLivery(vehicle, -1)
		else
			SetVehicleMod(vehicle, 48, tonumber(data.id), false) 
			SetVehicleLivery(vehicle, -1)
		end
	end
	updateCar(vehicle)
	TriggerEvent('prp-mechanic:client:Police:Livery')
	oldlivery = nil
end)

RegisterNetEvent('prp-mechanic:client:Police:Plates', function()
	local playerPed	= PlayerPedId()
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) 
		if DoesEntityExist(vehicle) then
			local PlateMenu = {	
			{ header = searchCar(vehicle)..Loc[Config.Lan]["plates"].menuheader2, isMenuHeader = true },
			{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Menu" } } }
			for k, v in pairs(Loc[Config.Lan].vehiclePlateOptions) do
				if GetVehicleNumberPlateTextIndex(vehicle) == v.id then installed = Loc[Config.Lan]["common"].current else installed = "" end
				PlateMenu[#PlateMenu + 1] = { header = k..". "..v.name, txt = installed, params = { event = 'prp-mechanic:client:Police:Plates:Apply', args = v.id  } }
			end
			exports['prp-menu']:openMenu(PlateMenu)
		end
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Plates:Apply', function(index)
	local playerPed	= PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end
	if GetVehicleNumberPlateTextIndex(vehicle) == tonumber(index) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["plates"].already, "error") TriggerEvent('prp-mechanic:client:Police:Plates') 
	elseif GetVehicleNumberPlateTextIndex(vehicle) ~= tonumber(index) then
		SetVehicleNumberPlateTextIndex(vehicle, index)
		emptyHands(playerPed)
		TriggerEvent('prp-mechanic:client:Police:Plates')
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Spoiler', function()
	local playerPed	= PlayerPedId()
    local coords = GetEntityCoords(playerPed)
	local validMods = {}
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) 
		for i = 1, GetNumVehicleMods(vehicle,0) do
			if GetVehicleMod(vehicle, 0) == (i-1) then txt = Loc[Config.Lan]["common"].current else txt = "" end
			validMods[i] = { id = (i - 1), name = GetLabelText(GetModTextLabel(vehicle, 0, (i - 1))), install = txt }
		end
	end
	if DoesEntityExist(vehicle) then
		if GetNumVehicleMods(vehicle, 0) == 0 then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error") return	end
		if GetVehicleMod(vehicle, 0) == -1 then	stockinstall = Loc[Config.Lan]["common"].current else stockinstall = ""	end
		local spoilerMenu = {
				{ isMenuHeader = true, header = Loc[Config.Lan]["spoilers"].menuheader, txt = Loc[Config.Lan]["common"].amountoption..#validMods+1,	},
				{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Menu" } },
				{ header = "0. "..Loc[Config.Lan]["common"].stock, txt = stockinstall,	params = { event = "prp-mechanic:client:Police:Spoilers:Apply", args = -1 } } }
			for k,v in pairs(validMods) do
				spoilerMenu[#spoilerMenu + 1] = { header = k..". "..v.name, txt = v.install, params = { event = 'prp-mechanic:client:Police:Spoilers:Apply', args = tostring(v.id) } }
			end
		exports['prp-menu']:openMenu(spoilerMenu)
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Spoilers:Apply', function(mod)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end
	local modName = GetLabelText(GetModTextLabel(vehicle, 0, tonumber(mod)))
	if modName == "NULL" then modName = Loc[Config.Lan]["common"].stock end
	if GetVehicleMod(vehicle, 0) == tonumber(mod) then
		TriggerEvent('ProjectRP:Notify', modName..Loc[Config.Lan]["common"].already, "error")
		TriggerEvent('prp-mechanic:client:Police:Spoiler')
	elseif GetVehicleMod(vehicle, 0) ~= tonumber(mod) then
		SetVehicleMod(vehicle, 0, tonumber(mod))
		emptyHands(playerPed)
		updateCar(vehicle)
		TriggerEvent('prp-mechanic:client:Police:Spoiler')
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["spoilers"].installed, "success")
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Paint', function()
	local playerPed	= PlayerPedId()
	local validMods = {}
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end

	local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(vehicle)
	local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(vehicle)
	for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsClassic) do
		if vehPrimaryColour == v.id then vehPrimaryColour = Loc[Config.Lan]["paint"].metallic.." "..v.name	end
		if vehSecondaryColour == v.id then vehSecondaryColour = Loc[Config.Lan]["paint"].metallic.." "..v.name	end
		if vehPearlescentColour == v.id then vehPearlescentColour = Loc[Config.Lan]["paint"].metallic.." "..v.name	end
	end			
	for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsMatte) do
		if vehPrimaryColour == v.id then vehPrimaryColour = Loc[Config.Lan]["paint"].matte.." "..v.name	end
		if vehSecondaryColour == v.id then vehSecondaryColour = Loc[Config.Lan]["paint"].matte.." "..v.name	end
		if vehPearlescentColour == v.id then vehPearlescentColour = Loc[Config.Lan]["paint"].matte.." "..v.name	end
	end
	for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsMetals) do
		if vehPrimaryColour == v.id then vehPrimaryColour = v.name	end
		if vehSecondaryColour == v.id then vehSecondaryColour = v.name	end
		if vehPearlescentColour == v.id then vehPearlescentColour = v.name	end
	end
	if type(vehPrimaryColour) == "number" then vehPrimaryColour = Loc[Config.Lan]["common"].stock end
	if type(vehSecondaryColour) == "number" then vehSecondaryColour = Loc[Config.Lan]["common"].stock end
	if type(vehPearlescentColour) == "number" then vehPearlescentColour = Loc[Config.Lan]["common"].stock end
	local PaintMenu = {	
			{ header = Loc[Config.Lan]["paint"].menuheader, txt = "", isMenuHeader = true },
			{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Menu", } } }
		PaintMenu[#PaintMenu + 1] = { header = Loc[Config.Lan]["paint"].primary, txt = Loc[Config.Lan]["common"].current..": "..vehPrimaryColour, params = { event = "prp-mechanic:client:Police:Paints:Choose", args = Loc[Config.Lan]["paint"].primary } }
		PaintMenu[#PaintMenu + 1] = { header = Loc[Config.Lan]["paint"].secondary, txt = Loc[Config.Lan]["common"].current..": "..vehSecondaryColour, params = { event = "prp-mechanic:client:Police:Paints:Choose", args = Loc[Config.Lan]["paint"].secondary } }
		PaintMenu[#PaintMenu + 1] = { header = Loc[Config.Lan]["paint"].pearl, txt = Loc[Config.Lan]["common"].current..": "..vehPearlescentColour, params = { event = "prp-mechanic:client:Police:Paints:Choose", args = Loc[Config.Lan]["paint"].pearl } }
	exports['prp-menu']:openMenu(PaintMenu)
end)

RegisterNetEvent('prp-mechanic:client:Police:Paints:Choose', function(data)
	local playerPed	= PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end
	if DoesEntityExist(vehicle) then
		exports['prp-menu']:openMenu({
			{ header = data..Loc[Config.Lan]["paint"].menuheader, txt = "", isMenuHeader = true },
			{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Paint" } },
			{ header = Loc[Config.Lan]["paint"].classic, txt = "", params = { event = "prp-mechanic:client:Police:Paints:Choose:Colour", args = { paint = data, finish = Loc[Config.Lan]["paint"].classic } } },
			{ header = Loc[Config.Lan]["paint"].metallic, txt = "", params = { event = "prp-mechanic:client:Police:Paints:Choose:Colour", args = { paint = data, finish = Loc[Config.Lan]["paint"].metallic } } },
			{ header = Loc[Config.Lan]["paint"].matte, txt = "", params = { event = "prp-mechanic:client:Police:Paints:Choose:Colour", args = { paint = data, finish = Loc[Config.Lan]["paint"].matte } } },
			{ header = Loc[Config.Lan]["paint"].metals, txt = "", params = { event = "prp-mechanic:client:Police:Paints:Choose:Colour", args = { paint = data, finish = Loc[Config.Lan]["paint"].metals } } },
		})
	end
end)

RegisterNetEvent('prp-mechanic:client:Police:Paints:Choose:Colour', function(data)
	local playerPed	= PlayerPedId()
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then	vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end
	local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(vehicle)
	local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(vehicle)
	if data.paint == Loc[Config.Lan]["paint"].primary then colourCheck = vehPrimaryColour end
	if data.paint == Loc[Config.Lan]["paint"].secondary then colourCheck = vehSecondaryColour end
	if data.paint == Loc[Config.Lan]["paint"].pearl then colourCheck = vehPearlescentColour end
	local PaintMenu = {	
		{ isMenuHeader = true, header = data.finish.." "..data.paint, txt = "" },
		{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:Police:Paints:Choose", args = data.paint } } }
	local installed = nil
	if data.finish == Loc[Config.Lan]["paint"].classic then
		for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsClassic) do
			if colourCheck == v.id then installed = Loc[Config.Lan]["common"].current else installed = "" end
			PaintMenu[#PaintMenu + 1] = { header = k..". "..v.name, txt = installed, params = { event = 'prp-mechanic:client:Police:Paints:Apply', args = { paint = data.paint, id = v.id, name = v.name, finish = data.finish } } } end
			
	elseif data.finish == Loc[Config.Lan]["paint"].metallic then
		for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsClassic) do
			if colourCheck == v.id then installed = Loc[Config.Lan]["common"].current else installed = "" end
			PaintMenu[#PaintMenu + 1] = { header = k..". "..v.name, txt = installed, params = { event = 'prp-mechanic:client:Police:Paints:Apply', args = { paint = data.paint, id = v.id, name = v.name, finish = data.finish } } } end
			
	elseif data.finish == Loc[Config.Lan]["paint"].matte then
		for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsMatte) do
			if colourCheck == v.id then installed = Loc[Config.Lan]["common"].current else installed = "" end
			PaintMenu[#PaintMenu + 1] = { header = k..". "..v.name, txt = installed, params = { event = 'prp-mechanic:client:Police:Paints:Apply', args = { paint = data.paint, id = v.id, name = v.name, finish = data.finish } } } end
			
	elseif data.finish == Loc[Config.Lan]["paint"].metals then
		for k, v in pairs(Loc[Config.Lan].vehicleResprayOptionsMetals) do	
			if colourCheck == v.id then installed = Loc[Config.Lan]["common"].current else installed = "" end
			PaintMenu[#PaintMenu + 1] = { header = k..". "..v.name, txt = installed, params = { event = 'prp-mechanic:client:Police:Paints:Apply', args = { paint = data.paint, id = v.id, name = v.name, finish = data.finish } } } end
	end
	exports['prp-menu']:openMenu(PaintMenu)
end)

RegisterNetEvent('prp-mechanic:client:Police:Paints:Apply', function(data)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if IsPedInAnyVehicle(playerPed, false) then vehicle = GetVehiclePedIsIn(playerPed, false) pushVehicle(vehicle) end
	local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(vehicle)
	local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(vehicle)
	if data.paint == Loc[Config.Lan]["paint"].primary then SetVehicleColours(vehicle, data.id, vehSecondaryColour)
	elseif data.paint == Loc[Config.Lan]["paint"].secondary then SetVehicleColours(vehicle, vehPrimaryColour, data.id)
	elseif data.paint == Loc[Config.Lan]["paint"].pearl then SetVehicleExtraColours(vehicle, data.id, vehWheelColour) end
	updateCar(vehicle)
	TriggerEvent('prp-mechanic:client:Police:Paints:Choose:Colour', data)
end)


RegisterNetEvent('prp-mechanic:client:Police:test', function(data)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = GetVehiclePedIsIn(playerPed, false)
	SetVehicleEngineHealth(vehicle, 200.0)
	SetVehicleBodyHealth(vehicle, 200.0)
	local veh = {}
	veh.engine = GetVehicleEngineHealth(vehicle)
	veh.body = GetVehicleBodyHealth(vehicle)
	doCarDamage(vehicle, veh)
	SetVehicleDirtLevel(vehicle, 14.5)
	TriggerEvent('prp-mechanic:client:Police:Menu')
end)

AddEventHandler('onResourceStop', function(r) 
	if r == GetCurrentResourceName() then 
		for k, v in pairs(Config.RegisterLocations) do exports['prp-target']:RemoveZone("bench"..k) end
		for i = 1, #bench do DeleteEntity(bench[i])	end
	end 
end)

