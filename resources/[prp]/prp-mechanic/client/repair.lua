local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Repair
local stashName = ""

Config.SafeLocations = {
    --Add your poly zone box locations and job name for each safe and it will add it to the prp-target loop above
    { coords = vector3(-37.78, -1036.21, 28.84), w = 3.6, d = 0.6, heading = 70.0, job = "mechanic" },
    { coords = vector3(-196.48, -1314.28, 31.22), w = 3.6, d = 0.6, heading = 0, job = "mechanic" },
    { coords = vector3(-1141.11, -2004.79, 13.18), w = 1.6, d = 0.6, heading = 45.0, job = "mechanic" },
    -- { coords = vector3(144.38, -3051.3, 7.04), w = 0.6, d = 3.6, heading = 0, job = "mechanic" },
    { coords = vector3(-345.77, -124.7, 39.01), w = 1.8, d = 0.6, heading = 340.0, job = "mechanic" },
    -- { coords = vector3(478.84, -1326.94, 29.21), w = 1.6, d = 0.6, heading = 27.0, job = "mechanic" },
    { coords = vector3(1180.85, 2635.0, 37.75), w = 1.6, d = 0.6, heading = 90.0, job = "mechanic" },
    { coords = vector3(102.7, 6626.23, 31.79), w = 1.6, d = 0.6, heading = 315.0, job = "mechanic" },
}
--Stash Controls
Citizen.CreateThread(function()
	if Config.StashRepair and not Config.FreeRepair then
		for k, v in pairs(Config.SafeLocations) do
			exports['prp-target']:AddBoxZone("MechSafe: "..k, v.coords, v.w, v.d, { name="MechSafe: "..k, heading = v.heading, debugPoly=Config.Debug, minZ=v.coords.z-1.0, maxZ=v.coords.z+1.0 }, 
				{ options = { { event = "prp-mechanic:client:Safe", icon = "fas fa-cogs", label = Loc[Config.Lan]["repair"].browse, job = v.job }, }, distance = 2.0 })
		end
	end
end)

RegisterNetEvent('prp-mechanic:client:Safe', function(data) TriggerEvent("inventory:client:SetCurrentStash", data.job .. "Safe") TriggerServerEvent("inventory:server:OpenInventory", "stash", data.job .. "Safe", { maxweight = 4000000, slots = 50, }) end)

RegisterNetEvent('prp-mechanic:client:Repair:ItemCheck', function(data)
	local amount = nil
	if not Config.FreeRepair then if Config.StashRepair then 
			TriggerEvent('prp-mechanic:client:Repair:Sure', data) else
			ProjectRP.Functions.TriggerCallback("prp-mechanic:repairCost", function(amount)
				while amount == nil do Wait(100) end
				if amount then TriggerEvent('prp-mechanic:client:Repair:Sure', data) else 
				TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["repair"].materials, "error")
				TriggerEvent('prp-mechanic:client:Repair:Check', -1)
				end
			end, data) end
	elseif Config.FreeRepair then TriggerEvent('prp-mechanic:client:Repair:Sure', data) end
	amount = nil
end)

RegisterNetEvent('prp-mechanic:client:Repair:Apply', function(data)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not IsPedInAnyVehicle(playerPed, false) then	vehicle = getClosest(coords) pushVehicle(vehicle) end
	if data.part == Loc[Config.Lan]["repair"].engine then
		SetVehicleDoorOpen(vehicle, 4, false, true)
		setanimDict = "mini@repair"
		setanim = "fixing_a_ped"
		setflags = 16
		settask = nil
	elseif data.part == Loc[Config.Lan]["repair"].body then
		SetVehicleDoorOpen(vehicle, 4, false, true)
		setanimDict = nil
		setanim = nil
		setflags = nil
		settask = "WORLD_HUMAN_WELDING"
	elseif data.part == Loc[Config.Lan]["repair"].radiator then
		SetVehicleDoorOpen(vehicle, 4, false, true)
		setanimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
		setanim = "machinic_loop_mechandplayer"
		setflags = 8
		settask = nil
	elseif data.part == Loc[Config.Lan]["repair"].driveshaft then
		setanimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
		setanim = "machinic_loop_mechandplayer"
		setflags = 8
		settask = nil
	elseif data.part == Loc[Config.Lan]["repair"].brakes then
		setanimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
		setanim = "machinic_loop_mechandplayer"
		setflags = 8
		settask = nil
	elseif data.part == Loc[Config.Lan]["repair"].clutch then
		setanimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
		setanim = "machinic_loop_mechandplayer"
		setflags = 8
		settask = nil
	elseif data.part == Loc[Config.Lan]["repair"].tank then
		setanimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
		setanim = "machinic_loop_mechandplayer"
		setflags = 8
		settask = nil
	end

	time = math.random(8000,10000)
	
	if Config.StashRepair and not Config.FreeRepair then
		stashName = PlayerJob.name .. "Safe"

		if data.part == Loc[Config.Lan]["repair"].engine then part = Config.RepairEngine cost = data.cost end
		if data.part == Loc[Config.Lan]["repair"].body then part = Config.RepairBody cost = data.cost end
		if data.part == Loc[Config.Lan]["repair"].radiator then part = Config.RepairRadiator cost = data.cost end
		if data.part == Loc[Config.Lan]["repair"].driveshaft then part = Config.RepairAxle cost = data.cost end
		if data.part == Loc[Config.Lan]["repair"].brakes then part = Config.RepairBrakes cost = data.cost end
		if data.part == Loc[Config.Lan]["repair"].clutch then part = Config.RepairClutch cost = data.cost end
		if data.part == Loc[Config.Lan]["repair"].tank then part = Config.RepairFuel cost = data.cost end
		
		local hasitem = false
		local indx = 0
		local countitem = 0
		
		ProjectRP.Functions.TriggerCallback('prp-inventory:server:GetStashItems', function(StashItems)
			for k,v in pairs(StashItems) do
				if v.name == part then
					hasitem = true
					if v.amount >= cost then
						countitem = v.amount
						indx = k
					end
				end
			end
			if hasitem and countitem >= cost then
				ProjectRP.Functions.Progressbar("repair_part", Loc[Config.Lan]["repair"].repairing..data.part, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false,	}, 
				{ task = settask, animDict = setanimDict, anim = setanim, flags = setflag, },
				{}, {}, function() -- Done
					emptyHands(playerPed)
					if data.part == Loc[Config.Lan]["repair"].body then
						for i = 0, 5 do SetVehicleDoorShut(vehicle, i, false, true) Wait(250) end
						enhealth = GetVehicleEngineHealth(vehicle)
						SetVehicleBodyHealth(vehicle, 1000.0)
						SetVehicleFixed(vehicle)				
						SetVehicleEngineHealth(vehicle, enhealth)
					elseif data.part == Loc[Config.Lan]["repair"].engine then SetVehicleEngineHealth(vehicle, 1000.0)
					elseif data.part == Loc[Config.Lan]["repair"].radiator then TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "radiator", 100)
					elseif data.part == Loc[Config.Lan]["repair"].driveshaft then TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "axle", 100)
					elseif data.part == Loc[Config.Lan]["repair"].brakes then TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "brakes", 100)
					elseif data.part == Loc[Config.Lan]["repair"].clutch then TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "clutch", 100)
					elseif data.part == Loc[Config.Lan]["repair"].tank then TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "fuel", 100) end
						
					if not Config.FreeRepair and not Config.StashRepair then TriggerServerEvent('prp-mechanic:ItemRemove', data) end
					
					emptyHands(playerPed)
					updateCar(vehicle)
					TriggerEvent("prp-mechanic:client:Repair:Check", -1)
					TriggerEvent("ProjectRP:Notify", data.part..Loc[Config.Lan]["repair"].repaired, "success")
				
					if (countitem - cost) <= 0 then StashItems[indx] = nil
					else countitem = (countitem - cost)	StashItems[indx].amount = countitem	end
					
					TriggerServerEvent('prp-inventory:server:SaveStashItems', stashName, StashItems)

				end, function()
					TriggerEvent('ProjectRP:Notify', data.part..Loc[Config.Lan]["repair"].cancel, "error")
					emptyHands(playerPed)
				end)
			else
				TriggerEvent('ProjectRP:Notify', Loc[Config.Lan]["repair"].nomaterials, 'error')
				return
			end
		end, stashName)
		
	else
		ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["repair"].repairing..data.part, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, }, 
		{ task = settask, animDict = setanimDict, anim = setanim, flags = setflag, }, {}, {}, function()
			emptyHands(playerPed)
			if data.part == Loc[Config.Lan]["repair"].body then
				for i = 0, 5 do SetVehicleDoorShut(vehicle, i, false, true) Wait(250) end
				enhealth = GetVehicleEngineHealth(vehicle)
				SetVehicleBodyHealth(vehicle, 1000.0)
				SetVehicleFixed(vehicle)				
				SetVehicleEngineHealth(vehicle, enhealth)
			elseif data.part == Loc[Config.Lan]["repair"].engine then
				SetVehicleEngineHealth(vehicle, 1000.0)
			elseif data.part == Loc[Config.Lan]["repair"].radiator then
				TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "radiator", 100)
			elseif data.part == Loc[Config.Lan]["repair"].driveshaft then
				TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "axle", 100)
			elseif data.part == Loc[Config.Lan]["repair"].brakes then
				TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "brakes", 100)
			elseif data.part == Loc[Config.Lan]["repair"].clutch then
				TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "clutch", 100)
			elseif data.part == Loc[Config.Lan]["repair"].tank then
				TriggerServerEvent("vehiclemod:server:updatePart", trim(GetVehicleNumberPlateText(vehicle)), "fuel", 100)
			end
				
			if not Config.FreeRepair and not Config.StashRepair then TriggerServerEvent('prp-mechanic:ItemRemove', data) end
			
			emptyHands(playerPed)
			updateCar(vehicle)
			TriggerEvent("prp-mechanic:client:Repair:Check", -1)
			TriggerEvent("ProjectRP:Notify", data.part..Loc[Config.Lan]["repair"].repaired, "success")
		end, function() -- Cancel
			TriggerEvent('ProjectRP:Notify', data.part..Loc[Config.Lan]["repair"].cancel, "error")
			emptyHands(playerPed)
		end)
	end
end)

RegisterNetEvent('prp-mechanic:client:Repair:Check', function(skip)
	if not skip then if not jobChecks() then return end end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not inCar() then return end
	if not nearPoint(coords) then return end
	if not IsPedInAnyVehicle(playerPed, false) then	vehicle = getClosest(coords) pushVehicle(vehicle) end
	
	local health = GetVehicleBodyHealth(vehicle) if health < 0.0 then SetVehicleBodyHealth(vehicle, 0.0) elseif health > 1000.0 then SetVehicleBodyHealth(vehicle, 1000.0) end
	local enghealth = GetVehicleEngineHealth(vehicle) if enghealth < 0.0 then SetVehicleEngineHealth(vehicle, 0.0) elseif enghealth > 1000.0 then SetVehicleEngineHealth(vehicle, 1000.0) end

	if Config.UseMechJob == true then
		if exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "radiator") == nil then
			TriggerServerEvent('vehiclemod:server:setupVehicleStatus', trim(GetVehicleNumberPlateText(vehicle)), GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle))
			Wait(200)
		end
		local list = { "radiator", "axle", "brakes", "clutch", "fuel" }
		for k, v in pairs(list) do
			print(v..": "..exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), v))
		end
	end
				
		costEngine = ""
		costBody = ""
		costRadiator = ""
		costAxle = ""
		costBrakes = ""
		costClutch = ""
		costFuel = ""
		if skip == -2 then else
			if not Config.FreeRepair then
				--Calculate the costs of each part based on damage
				EngineRepair = Config.RepairEngineCost - math.floor(Config.RepairEngineCost * math.floor((GetVehicleEngineHealth(vehicle)/10)+0.5) / 100)
				if EngineRepair ~= 0 then costEngine = Loc[Config.Lan]["repair"].cost..EngineRepair.." "..ProjectRP.Shared.Items[Config.RepairEngine].label end
				BodyRepair = Config.RepairBodyCost - math.floor(Config.RepairBodyCost * math.floor((GetVehicleBodyHealth(vehicle)/10)+0.5) / 100)
				if BodyRepair ~= 0 then costBody = Loc[Config.Lan]["repair"].cost..BodyRepair.." "..ProjectRP.Shared.Items[Config.RepairBody].label end
				
				if Config.UseMechJob then
					RadiatorRepair = Config.RepairRadiatorCost - math.floor(Config.RepairRadiatorCost * math.floor(exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "radiator")+0.5) / 100)
					if RadiatorRepair ~= 0 then costRadiator = Loc[Config.Lan]["repair"].cost..RadiatorRepair.." "..ProjectRP.Shared.Items[Config.RepairRadiator].label end
					AxleRepair = Config.RepairAxleCost - math.floor(Config.RepairAxleCost * math.floor(exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "axle")+0.5) / 100)
					if AxleRepair ~= 0 then costAxle = Loc[Config.Lan]["repair"].cost..AxleRepair.." "..ProjectRP.Shared.Items[Config.RepairAxle].label end
					BrakesRepair = Config.RepairBrakesCost - math.floor(Config.RepairBrakesCost * math.floor(exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "brakes")+0.5) / 100)
					if BrakesRepair ~= 0 then costBrakes = Loc[Config.Lan]["repair"].cost..BrakesRepair.." "..ProjectRP.Shared.Items[Config.RepairBrakes].label end
					ClutchRepair = Config.RepairClutchCost - math.floor(Config.RepairClutchCost * math.floor(exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "clutch")+0.5) / 100)
					if ClutchRepair ~= 0 then costClutch = Loc[Config.Lan]["repair"].cost..ClutchRepair.." "..ProjectRP.Shared.Items[Config.RepairClutch].label end
					FuelRepair = Config.RepairFuelCost - math.floor(Config.RepairFuelCost * math.floor(exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "fuel")+0.5) / 100)
					if FuelRepair ~= 0 then costFuel = Loc[Config.Lan]["repair"].cost..FuelRepair.." "..ProjectRP.Shared.Items[Config.RepairFuel].label end
				end				
			end
		end
				
		local RepairMenu = {
			{ isMenuHeader = true, header = searchCar(vehicle), txt = Loc[Config.Lan]["check"].plate..trim(GetVehicleNumberPlateText(vehicle))..Loc[Config.Lan]["check"].value..searchPrice(vehicle).."<br>"..searchDist(vehicle)},
			{ header = "", txt = Loc[Config.Lan]["common"].close, params = { event = "prp-mechanic:client:Menu:Close" } } }
			
			local headerlock = false
			if math.floor((GetVehicleEngineHealth(vehicle)/10)+0.5) == 100 or skip == -2 then headerlock = true end
			RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].engine, txt = Loc[Config.Lan]["repair"].status..math.floor((GetVehicleEngineHealth(vehicle)/10)+0.5).."%"..costEngine, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].engine, vehicle = vehicle, cost = EngineRepair } } }
			headerlock = false
			if math.floor((GetVehicleBodyHealth(vehicle)/10)+0.5) == 100 or skip == -2 then headerlock = true end	
			RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].body, txt =  Loc[Config.Lan]["repair"].status..math.floor((GetVehicleBodyHealth(vehicle)/10)+0.5).."%"..costBody, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].body, vehicle = vehicle, cost = BodyRepair } } }
			headerlock = false
			if Config.UseMechJob == true then
				if math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "radiator"))+0.5) == 100 or skip == -2 then headerlock = true end	
				RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].radiator, txt =  Loc[Config.Lan]["repair"].status..math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "radiator"))+0.5).."%"..costRadiator, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].radiator, vehicle = vehicle, status = vehicleStatus, cost = RadiatorRepair } } }
				headerlock = false
				if math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "axle"))+0.5) == 100 or skip == -2 then headerlock = true end	
				RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].driveshaft, txt =  Loc[Config.Lan]["repair"].status..math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "axle"))+0.5).."%"..costAxle, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].driveshaft, vehicle = vehicle, status = vehicleStatus, cost = AxleRepair } } }
				headerlock = false
				if math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "brakes"))+0.5) == 100 or skip == -2 then headerlock = true end	
				RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].brakes, txt =  Loc[Config.Lan]["repair"].status..math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "brakes"))+0.5).."%"..costBrakes, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].brakes, vehicle = vehicle, status = vehicleStatus, cost = BrakesRepair } } }
				headerlock = false
				if math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "clutch"))+0.5) == 100 or skip == -2 then headerlock = true end	
				RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].clutch, txt =  Loc[Config.Lan]["repair"].status..math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "clutch"))+0.5).."%"..costClutch, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].clutch, vehicle = vehicle, status = vehicleStatus, cost = ClutchRepair } } }
				headerlock = false
				if math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "fuel"))+0.5) == 100 or skip == -2 then headerlock = true end	
				RepairMenu[#RepairMenu+1] =	{ isMenuHeader = headerlock, header = Loc[Config.Lan]["repair"].tank, txt =  Loc[Config.Lan]["repair"].status..math.floor((exports['prp-mechanicjob']:GetVehicleStatus(ProjectRP.Functions.GetPlate(vehicle), "fuel"))+0.5).."%"..costFuel, params = { event = "prp-mechanic:client:Repair:ItemCheck", args = { part = Loc[Config.Lan]["repair"].tank, vehicle = vehicle, status = vehicleStatus, cost = FuelRepair } } }
			end
		if DoesEntityExist(vehicle) then
			if skip == -1 then	
				TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
				TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
				exports['prp-menu']:openMenu(RepairMenu)
			else
				TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
				Wait(1000)
				SetVehicleDoorOpen(vehicle, 4, false, false)
				time = math.random(3000,5000)
				for i = 0, 5 do SetVehicleDoorOpen(vehicle, i, false, false) end
				ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["repair"].checkeng, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, }, 
				{ animDict = "mini@repair", anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
					Wait(1000)
					time = math.random(3000,5000)
					ProjectRP.Functions.Progressbar("drink_something", Loc[Config.Lan]["repair"].checkbody, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, }, 
					{ animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", flags = 8, },
					{}, {}, function()
						emptyHands(playerPed)
						TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
						exports['prp-menu']:openMenu(RepairMenu)
					end, function() -- Cancel
						emptyHands(playerPed)
					end)
					
				end, function() -- Cancel
						emptyHands(playerPed)
					return
				end)
			end
		end
end)

RegisterNetEvent('prp-mechanic:client:Repair:Sure', function(data)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not inCar() then return end
	if not IsPedInAnyVehicle(playerPed, false) then	vehicle = getClosest(coords) pushVehicle(vehicle) end
	local vehicleStatus = data.status						
	if DoesEntityExist(vehicle) then
		TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		exports['prp-menu']:openMenu({
			{ isMenuHeader = true, header = searchCar(vehicle), txt = Loc[Config.Lan]["check"].plate..trim(GetVehicleNumberPlateText(vehicle))..Loc[Config.Lan]["check"].value..searchPrice(vehicle).."<br>"..searchDist(vehicle)},
			{ header = Loc[Config.Lan]["repair"].doyou..data.part.."?", isMenuHeader = true },
			{ header = Loc[Config.Lan]["check"].label47, params = { event = "prp-mechanic:client:Repair:Apply", args = { part = data.part, cost = data.cost } } },
			{ header = Loc[Config.Lan]["check"].label48, params = { event = "prp-mechanic:client:Repair:Check", args = -1 } },
		})
	end
end)

AddEventHandler('onResourceStop', function(r) if r == GetCurrentResourceName() then for k, v in pairs(Config.CraftingLocations) do exports['prp-target']:RemoveZone("MechSafe: "..k) end end end)
