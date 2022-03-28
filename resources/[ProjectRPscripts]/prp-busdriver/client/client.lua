local ProjectRP = exports['prp-core']:GetCoreObject()

--------------------------------------------------------------------------------
local PlayerData = {}
local clothes = false
local Plate, Vehicle, MechanicPed, Route = nil,nil,nil,nil
local inspection = false
local Passengers = 0
local number = 1
local close = false
local WorkBlip = nil

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerData = ProjectRP.Functions.GetPlayerData()
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function()
	PlayerData.job = ProjectRP.Functions.GetPlayerData().job
end)

Citizen.CreateThread(function()
	local StartJobBlip = AddBlipForCoord(Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z)
	
	SetBlipSprite (StartJobBlip, 408)
	SetBlipDisplay(StartJobBlip, 4)
	SetBlipScale  (StartJobBlip, 0.8)
	SetBlipColour (StartJobBlip, 0)
	SetBlipAsShortRange(StartJobBlip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Bus Driver')
	EndTextCommandSetBlipName(StartJobBlip)
end)


--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-- Citizen.CreateThread(function ()
-- 	while true do
-- 		local sleep = 500
-- 		local ped = PlayerPedId()
-- 		local coords = GetEntityCoords(ped)
-- 		if inspection then
-- 			if(GetDistanceBetweenCoords(coords, Config.Deposit['Deposit'].Pos.x, Config.Deposit['Deposit'].Pos.y, Config.Deposit['Deposit'].Pos.z, true) < 8.0) then
-- 				sleep = 5
-- 				DrawMarker(Config.Deposit['Deposit'].Type, Config.Deposit['Deposit'].Pos.x, Config.Deposit['Deposit'].Pos.y, Config.Deposit['Deposit'].Pos.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Deposit['Deposit'].Size.x, Config.Deposit['Deposit'].Size.y, Config.Deposit['Deposit'].Size.z, Config.Deposit['Deposit'].Color.r, Config.Deposit['Deposit'].Color.g, Config.Deposit['Deposit'].Color.b, 100, false, true, 2, false, false, false, false)
-- 				DrawMarker(30, Config.Deposit['Deposit'].Pos.x, Config.Deposit['Deposit'].Pos.y, Config.Deposit['Deposit'].Pos.z+0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 100, false, true, 2, false, false, false, false)
-- 				if(GetDistanceBetweenCoords(coords,Config.Deposit['Deposit'].Pos.x, Config.Deposit['Deposit'].Pos.y, Config.Deposit['Deposit'].Pos.z, true) < 1.5) then
-- 					DrawText3Ds(Config.Deposit['Deposit'].Pos.x, Config.Deposit['Deposit'].Pos.y, Config.Deposit['Deposit'].Pos.z+1.4, 'To stow the vehicle, press [~g~E~w~]')
-- 					if IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
-- 						local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
-- 						if GetVehicleNumberPlateText(vehicle) == Plate then
-- 							ESX.Game.DeleteVehicle(Vehicle)
-- 							Vehicle = nil
-- 							Plate = nil
-- 							for i, v in pairs(Config.BusDriver['Coaches']) do
-- 								RemoveBlip(v.blip)
-- 							end
-- 							DeletePed(MechanicPed)
-- 							inspection = false
-- 							RemoveBlip(InspectionBlip)
-- 							RemoveBlip(RouteSelection)
-- 							MechanicPed = nil

-- 							number = 1
-- 							for i, v in pairs(Config.First) do
-- 								v.done = false
-- 							end
-- 							for i, v in pairs(Config.Second) do
-- 								v.done = false
-- 							end
-- 							Route = nil
-- 							close = false
-- 							RemoveBlip(DepositBlip)
-- 							Passengers = 0	
-- 							exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>You returned the vehicle!', timeout = 1500})
-- 							CreateSpawnBusBlip()
-- 						else
-- 							exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>It's not your bus", timeout = 4500})
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 		Citizen.Wait(sleep)
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		
		--if PlayerData.job ~= nil and PlayerData.job.grade_name == 'BusDriver' then
			if(GetDistanceBetweenCoords(coords, Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z, true) < 8.0) then
				sleep = 5

				DrawMarker(Config.BusDriver['Jobstart'].Type, Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.BusDriver['Jobstart'].Size.x, Config.BusDriver['Jobstart'].Size.y, Config.BusDriver['Jobstart'].Size.z, Config.BusDriver['Jobstart'].Color.r, Config.BusDriver['Jobstart'].Color.g, Config.BusDriver['Jobstart'].Color.b, 100, false, true, 2, false, false, false, false)
				DrawMarker(30, Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z+0.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				if(GetDistanceBetweenCoords(coords, Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z, true) < 1.5) then
					if not clothes then
						DrawText3Ds(Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z+1.4, 'To start job, press [~g~E~w~]')
						if IsControlJustReleased(0, Keys['E']) and not IsPedInAnyVehicle(ped, false) then
							exports.rprogress:Custom({
								Duration = 2500,
								Label = "Changing wear...",
								Animation = {
									scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
									animationDictionary = "idle_a", -- https://alexguirre.github.io/animations-list/
								},
								DisableControls = {
									Mouse = false,
									Player = true,
									Vehicle = true
								}
							})
							Citizen.Wait(2500)
							local PlayerData = ProjectRP.Functions.GetPlayerData()
							if PlayerData.charinfo.gender == 0 then 
								SetPedComponentVariation(ped, 3, Config.Clothes.male['arms'], 0, 0) --arms
								SetPedComponentVariation(ped, 8, Config.Clothes.male['tshirt_1'], Config.Clothes.male['tshirt_2'], 0) --t-shirt
								SetPedComponentVariation(ped, 11, Config.Clothes.male['torso_1'], Config.Clothes.male['torso_2'], 0) --torso2
								SetPedComponentVariation(ped, 9, Config.Clothes.male['bproof_1'], Config.Clothes.male['bproof_2'], 0) --vest
								SetPedComponentVariation(ped, 10, Config.Clothes.male['decals_1'], Config.Clothes.male['decals_2'], 0) --decals
								SetPedComponentVariation(ped, 7, Config.Clothes.male['chain_1'], Config.Clothes.male['chain_2'], 0) --accessory
								SetPedComponentVariation(ped, 4, Config.Clothes.male['pants_1'], Config.Clothes.male['pants_2'], 0) -- pants
								SetPedComponentVariation(ped, 6, Config.Clothes.male['shoes_1'], Config.Clothes.male['shoes_2'], 0) --shoes
								SetPedPropIndex(ped, 0, Config.Clothes.male['helmet_1'], Config.Clothes.male['helmet_2'], true) --hat
								SetPedPropIndex(ped, 2, Config.Clothes.male['ears_1'], Config.Clothes.male['ears_2'], true) --ear
							else
								SetPedComponentVariation(ped, 3, Config.Clothes.female['arms'], 0, 0) --arms
								SetPedComponentVariation(ped, 8, Config.Clothes.female['tshirt_1'], Config.Clothes.female['tshirt_2'], 0) --t-shirt
								SetPedComponentVariation(ped, 11, Config.Clothes.female['torso_1'], Config.Clothes.female['torso_2'], 0) --torso2
								SetPedComponentVariation(ped, 9, Config.Clothes.female['bproof_1'], Config.Clothes.female['bproof_2'], 0) --vest
								SetPedComponentVariation(ped, 10, Config.Clothes.female['decals_1'], Config.Clothes.female['decals_2'], 0) --decals
								SetPedComponentVariation(ped, 7, Config.Clothes.female['chain_1'], Config.Clothes.female['chain_2'], 0) --accessory
								SetPedComponentVariation(ped, 4, Config.Clothes.female['pants_1'], Config.Clothes.female['pants_2'], 0) -- pants
								SetPedComponentVariation(ped, 6, Config.Clothes.female['shoes_1'], Config.Clothes.female['shoes_2'], 0) --shoes
								SetPedPropIndex(ped, 0, Config.Clothes.female['helmet_1'], Config.Clothes.female['helmet_2'], true) --hat
								SetPedPropIndex(ped, 2, Config.Clothes.female['ears_1'], Config.Clothes.female['ears_2'], true) --ear
							end	
								clothes = true
								CreateSpawnBusBlip()
								exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>Job started, get the bus out now!', timeout = 1500})				
						elseif IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
							exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>Leave the vehicle!', timeout = 1500})
						end
					else
						DrawText3Ds(Config.BusDriver['Jobstart'].Pos.x, Config.BusDriver['Jobstart'].Pos.y, Config.BusDriver['Jobstart'].Pos.z+1.4, 'To finish work, press [~r~E~w~]')
						if IsControlJustReleased(0, Keys['E']) and not IsPedInAnyVehicle(ped, false) then
							exports.rprogress:Custom({
								Duration = 2500,
								Label = "Changing wear...",
								Animation = {
									scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
									animationDictionary = "idle_a", -- https://alexguirre.github.io/animations-list/
								},
								DisableControls = {
									Mouse = false,
									Player = true,
									Vehicle = true
								}
							})
							Citizen.Wait(2500)
							TriggerServerEvent("prp-clothes:loadPlayerSkin")	
							Citizen.Wait(1500)
							TriggerServerEvent("Mx :: GetTattoos")
								clothes = false
								ProjectRP.Functions.DeleteVehicle(Vehicle)
								Vehicle = nil
								Plate = nil
								for i, v in pairs(Config.BusDriver['Coaches']) do
									RemoveBlip(v.blip)
								end
								DeletePed(MechanicPed)
								inspection = false
								RemoveBlip(InspectionBlip)
								RemoveBlip(RouteSelection)
								-- RemoveBlip(DepositBlip)
								MechanicPed = nil

								number = 1
								for i, v in pairs(Config.First) do
									v.done = false
								end
								for i, v in pairs(Config.Second) do
									v.done = false
								end
								Route = nil
								close = false
								Passengers = 0								
								exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>Work done, you are welcome here!', timeout = 1500})			
						elseif IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
							exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>Leave the vehicle!', timeout = 1500})
						end
					end
				end	
			end
		--end
	Citizen.Wait(sleep)
	end
end)

function CreateSpawnBusBlip()
	for i, v in pairs(Config.BusDriver['Coaches']) do
		v.blip = AddBlipForCoord(v.x, v.y, v.z)
	
		SetBlipSprite (v.blip, 513)
		SetBlipDisplay(v.blip, 4)
		SetBlipScale  (v.blip, 0.5)
		SetBlipColour (v.blip, 0)
		SetBlipAsShortRange(v.blip, true)
	
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Bus spawn')
		EndTextCommandSetBlipName(v.blip)
	end
end

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if clothes and not Plate then
			sleep = 5
			for i, v in pairs(Config.BusDriver['Coaches']) do
				if(GetDistanceBetweenCoords(coords,v.x, v.y, v.z, true) < 8.0) then
					DrawMarker(20, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 100, false, true, 2, false, false, false, false)
					if(GetDistanceBetweenCoords(coords,v.x, v.y, v.z, true) < 1.5) then
						DrawText3Ds(v.x, v.y, v.z+1.4, 'To pull out the vehicle, press [~g~E~w~]')
						if IsControlJustReleased(0, Keys['E']) and not IsPedInAnyVehicle(ped, false) then
							ProjectRP.Functions.SpawnVehicle('bus', function(veh)
								SetEntityHeading(veh, 214.02)
								SetVehicleNumberPlateText(veh, "BUS"..tostring(math.random(1000, 9999)))
								TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))	
								TaskWarpPedIntoVehicle(ped, veh, -1)
								SetVehicleEngineOn(veh, true, true)
								CreateInspectionBlip()
								Plate = GetVehicleNumberPlateText(veh)
								Vehicle = veh
								for i, v in pairs(Config.BusDriver['Coaches']) do
									RemoveBlip(v.blip)
								end
								exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>Now go to the inspection of the vehicle on your left", timeout = 4500})
							end, v, true)
						end
					end
				end
			end
		end	
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if Plate and not inspection then
			sleep = 5
			if(GetDistanceBetweenCoords(coords,Config.BusDriver['Inspection'].Pos.x, Config.BusDriver['Inspection'].Pos.y, Config.BusDriver['Inspection'].Pos.z, true) < 20.0) then
				DrawMarker(25, Config.BusDriver['Inspection'].Pos.x, Config.BusDriver['Inspection'].Pos.y, Config.BusDriver['Inspection'].Pos.z-0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 3.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				if(GetDistanceBetweenCoords(coords,Config.BusDriver['Inspection'].Pos.x, Config.BusDriver['Inspection'].Pos.y, Config.BusDriver['Inspection'].Pos.z, true) < 3.5) then
					DrawText3Ds(Config.BusDriver['Inspection'].Pos.x, Config.BusDriver['Inspection'].Pos.y, Config.BusDriver['Inspection'].Pos.z+0.90, 'To send the vehicle for inspection, press [~g~E~w~]')
					if IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
						local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
						if GetVehicleNumberPlateText(vehicle) == Plate then
							if IsSpawnPointClear(vector3(Config.BusDriver['Inspection'].PosCar.x, Config.BusDriver['Inspection'].PosCar.y, Config.BusDriver['Inspection'].PosCar.z), 4) then	
								Vehicle = vehicle
								SetEntityCoords(vehicle, Config.BusDriver['Inspection'].PosCar.x, Config.BusDriver['Inspection'].PosCar.y, Config.BusDriver['Inspection'].PosCar.z, false, false, false, true)
								SetEntityHeading(vehicle, Config.BusDriver['Inspection'].PosCar.h)
								SetEntityCoords(ped, 457.28,-556.22,27.5, false, false, false, true)
								SetEntityHeading(ped, 86.45)
								FreezeEntityPosition(vehicle, true)
								TaskLeaveVehicle(ped, vehicle, 0)
								exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>Now go to the inspector is in front of the vehicle", timeout = 4500})
								local ped_hash = GetHashKey('mp_m_waremech_01')
								RequestModel(ped_hash)
								while not HasModelLoaded(ped_hash) do
									Citizen.Wait(1)
								end
								MechanicPed = CreatePed(1, ped_hash, Config.BusDriver['Inspection'].PosPed.x, Config.BusDriver['Inspection'].PosPed.y, Config.BusDriver['Inspection'].PosPed.z-1.0, Config.BusDriver['Inspection'].PosPed.h, false, true)
								SetBlockingOfNonTemporaryEvents(MechanicPed, true)
								SetPedDiesWhenInjured(MechanicPed, false)
								SetPedCanPlayAmbientAnims(MechanicPed, true)
								SetPedCanRagdollFromPlayerImpact(MechanicPed, false)
								SetEntityInvincible(MechanicPed, true)
								FreezeEntityPosition(MechanicPed, true)
							else
								exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>Someone is currently inspecting the vehicle", timeout = 4500})
							end			
						else
							exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>It's not your bus", timeout = 4500})
						end
					end
				end
			end
		end	
		Citizen.Wait(sleep)
	end
end)

--##############################

function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function GetClosestVehicle(coords)
	local vehicles        = GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function GetVehiclesInArea(coords, area)
	local vehicles       = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

--##############################

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if MechanicPed then
			sleep = 5
			if(GetDistanceBetweenCoords(coords,Config.BusDriver['Inspection'].PosPed.x, Config.BusDriver['Inspection'].PosPed.y, Config.BusDriver['Inspection'].PosPed.z, true) < 3.5) then
				DrawText3Ds(Config.BusDriver['Inspection'].PosPed.x, Config.BusDriver['Inspection'].PosPed.y, Config.BusDriver['Inspection'].PosPed.z+1.0, 'To start a vehicle inspection, press [~g~E~w~]')
				if IsControlJustReleased(0, Keys['E']) and not IsPedInAnyVehicle(ped, false) then
					FreezeEntityPosition(MechanicPed, false)
					TaskGoToCoordAnyMeans(MechanicPed, Config.BusDriver['Inspection'].FirstWheel.x, Config.BusDriver['Inspection'].FirstWheel.y, Config.BusDriver['Inspection'].FirstWheel.z, 1.3)
					while true do
						Citizen.Wait(0)
						local PedCoords = GetEntityCoords(MechanicPed)
						if(GetDistanceBetweenCoords(PedCoords,Config.BusDriver['Inspection'].FirstWheel.x, Config.BusDriver['Inspection'].FirstWheel.y, Config.BusDriver['Inspection'].FirstWheel.z, true) < 0.5) then
							SetEntityHeading(MechanicPed,266.31)
							startAnim(MechanicPed, 'anim@gangops@morgue@table@', 'player_search')
							Citizen.Wait(5000)
							ClearPedTasks(MechanicPed)
							break
						end
					end
					TaskGoToCoordAnyMeans(MechanicPed, Config.BusDriver['Inspection'].SecondWheel.x, Config.BusDriver['Inspection'].SecondWheel.y, Config.BusDriver['Inspection'].SecondWheel.z, 1.3)
					while true do
						Citizen.Wait(0)
						local PedCoords = GetEntityCoords(MechanicPed)
						if(GetDistanceBetweenCoords(PedCoords,Config.BusDriver['Inspection'].SecondWheel.x, Config.BusDriver['Inspection'].SecondWheel.y, Config.BusDriver['Inspection'].SecondWheel.z, true) < 0.5) then
							SetEntityHeading(MechanicPed,266.31)
							startAnim(MechanicPed, 'anim@gangops@morgue@table@', 'player_search')
							Citizen.Wait(5000)
							ClearPedTasks(MechanicPed)
							break
						end
					end					
					TaskGoToCoordAnyMeans(MechanicPed, Config.BusDriver['Inspection'].PosPed.x, Config.BusDriver['Inspection'].PosPed.y, Config.BusDriver['Inspection'].PosPed.z, 1.3)
					FreezeEntityPosition(Vehicle, false)
					FreezeEntityPosition(MechanicPed, false)	
					CreateRouteSelection()	
					RemoveBlip(InspectionBlip)		
					exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>Your vehicle is great for the tour, please go to the route selection point", timeout = 5500})
					local displaying = true
					-- DepositB()
					Citizen.CreateThread(function()
						Wait(5000)
						displaying = false
					end)
					inspection = true
					while displaying do
						Wait(0)
						local coordsPed = GetEntityCoords(MechanicPed, false)
						local coords = GetEntityCoords(PlayerPedId(), false)
						local dist = Vdist2(coordsPed, coords)
						if dist < 150 then                
							DrawText3Ds(coordsPed['x'], coordsPed['y'], coordsPed['z'] + 1.2, "Everything's fine, you can go")
						end
					end	
					Citizen.Wait(5000)
					DeletePed(MechanicPed)
					MechanicPed = nil
				end
			end
		end	
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if inspection and not Route then
			sleep = 5
			if(GetDistanceBetweenCoords(coords,Config.BusDriver['RouteSelection'].Pos.x, Config.BusDriver['RouteSelection'].Pos.y, Config.BusDriver['RouteSelection'].Pos.z, true) < 20.0) then
				DrawMarker(21, Config.BusDriver['RouteSelection'].Pos.x, Config.BusDriver['RouteSelection'].Pos.y, Config.BusDriver['RouteSelection'].Pos.z+0.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				if(GetDistanceBetweenCoords(coords,Config.BusDriver['RouteSelection'].Pos.x, Config.BusDriver['RouteSelection'].Pos.y, Config.BusDriver['RouteSelection'].Pos.z, true) < 3.5) then
					DrawText3Ds(Config.BusDriver['RouteSelection'].Pos.x, Config.BusDriver['RouteSelection'].Pos.y, Config.BusDriver['RouteSelection'].Pos.z+1.4, 'To select a route, press [~g~E~w~]')
					if IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
						local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
						if GetVehicleNumberPlateText(vehicle) == Plate then
							exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>You have selected the route - go to the first point on the map", timeout = 4500})
							Route = Randomize(Config.Locations)
							RemoveBlip(RouteSelection)
							CreateRoute(Route.name)
						else
							exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>It's not your bus", timeout = 4500})
						end
					end
				end	
			end
		end	
		Citizen.Wait(sleep)
	end
end)

function CreateRoute(type)
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
			if type == 'first' then
				CreateWorkBlip(type,number) 
				sleep = 5
				for i, v in pairs(Config.First) do
					if i == number then 
						if(GetDistanceBetweenCoords(coords,Config.First[number].x, Config.First[number].y, Config.First[number].z, true) < 20.0) and not v.done then
							DrawMarker(20, Config.First[number].x, Config.First[number].y, Config.First[number].z+0.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
							if(GetDistanceBetweenCoords(coords,Config.First[number].x, Config.First[number].y, Config.First[number].z, true) < 3.5) then
								DrawText3Ds(Config.First[number].x, Config.First[number].y, Config.First[number].z+1.4, 'To stop and invite passengers, press [~g~E~w~]')
								if IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
								local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
									if GetVehicleNumberPlateText(vehicle) == Plate then
										SetEntityCoords(vehicle,Config.First[number].x, Config.First[number].y, Config.First[number].z, false, false, false, true)
										SetEntityHeading(vehicle,Config.First[number].h)
										FreezeEntityPosition(vehicle, true)
										
										SetVehicleDoorOpen(vehicle, 1, false, true)
										if Passengers == 3 then
											for i, v in pairs(Config.First[number].Peds['Peds']) do
												CordsV = GetEntityCoords(vehicle)
												local ped_hash = GetHashKey(Config.BusDriver['Peds'][math.random(1,#Config.BusDriver['Peds'])].ped)
												RequestModel(ped_hash)
												while not HasModelLoaded(ped_hash) do
													Citizen.Wait(1)
												end
												v.ped = CreatePed(1, ped_hash, Config.First[number].dx, Config.First[number].dy, Config.First[number].dz-0.5, 0.0, false, true)
												SetBlockingOfNonTemporaryEvents(v.ped, true)
												SetPedDiesWhenInjured(v.ped, false)
												SetPedCanPlayAmbientAnims(v.ped, true)
												SetPedCanRagdollFromPlayerImpact(v.ped, false)
												SetEntityInvincible(v.ped, true)
												TaskGoToCoordAnyMeans(v.ped, CordsV.x-10, CordsV.y+2, CordsV.z, 1.3)
												Passengers = 0
											end
											Citizen.Wait(3000)
											for i, v in pairs(Config.First[number].Peds['Peds']) do
												DeletePed(v.ped)
											end
										end
										
										for i, v in pairs(Config.First[number].Peds['Peds']) do
											local ped_hash = GetHashKey(Config.BusDriver['Peds'][math.random(1,#Config.BusDriver['Peds'])].ped)
											RequestModel(ped_hash)
											while not HasModelLoaded(ped_hash) do
												Citizen.Wait(1)
											end
											v.ped = CreatePed(1, ped_hash, v.x, v.y, v.z-0.5, v.h, false, true)
											SetBlockingOfNonTemporaryEvents(v.ped, true)
											SetPedDiesWhenInjured(v.ped, false)
											SetPedCanPlayAmbientAnims(v.ped, true)
											SetPedCanRagdollFromPlayerImpact(v.ped, false)
											SetEntityInvincible(v.ped, true)
											TaskGoToCoordAnyMeans(v.ped, Config.First[number].dx, Config.First[number].dy, Config.First[number].dz, 1.3)
											Passengers = 3
										end

										exports.rprogress:Custom({
											Duration = 3000,
											Label = "Passengers board...",
											Animation = {
												scenario = "", -- https://pastebin.com/6mrYTdQv
												animationDictionary = "", -- https://alexguirre.github.io/animations-list/
											},
											DisableControls = {
												Mouse = false,
												Player = true,
												Vehicle = true
											}
										})
										Citizen.Wait(3000)
										for i, v in pairs(Config.First[number].Peds['Peds']) do
											DeletePed(v.ped)
										end
										RemoveBlip(WorkBlip)
										WorkBlip = nil
										SetVehicleDoorShut(vehicle, 1, false)

										FreezeEntityPosition(vehicle, false)
										
										v.done = true
										if number >= #Config.First then
											close = true
											break
										end
										ProjectRP.Functions.TriggerCallback('prp-busdriver:payout', function(money)
											exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>You have earned '..money..'$ go to the next point', timeout = 4500})
										end)
										number = number + 1
									else
										exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>It's not your bus", timeout = 4500})
									end
								end
							end
						end
					end
				end
			elseif type == 'second' then
				CreateWorkBlip(type,number) 
				sleep = 5
				for i, v in pairs(Config.Second) do
					if i == number then 
						if(GetDistanceBetweenCoords(coords,Config.Second[number].x, Config.Second[number].y, Config.Second[number].z, true) < 20.0) and not v.done then
							DrawMarker(20, Config.Second[number].x, Config.Second[number].y, Config.Second[number].z+0.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
							if(GetDistanceBetweenCoords(coords,Config.Second[number].x, Config.Second[number].y, Config.Second[number].z, true) < 3.5) then
								DrawText3Ds(Config.Second[number].x, Config.Second[number].y, Config.Second[number].z+1.4, 'To stop and invite passengers, press [~g~E~w~]')
								if IsControlJustReleased(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then
								local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
									if GetVehicleNumberPlateText(vehicle) == Plate then
										SetEntityCoords(vehicle,Config.Second[number].x, Config.Second[number].y, Config.Second[number].z, false, false, false, true)
										SetEntityHeading(vehicle,Config.Second[number].h)
										FreezeEntityPosition(vehicle, true)
											
										SetVehicleDoorOpen(vehicle, 1, false, true)
										if Passengers == 3 then
											for i, v in pairs(Config.Second[number].Peds['Peds']) do
												CordsV = GetEntityCoords(vehicle)
												local ped_hash = GetHashKey(Config.BusDriver['Peds'][math.random(1,#Config.BusDriver['Peds'])].ped)
												RequestModel(ped_hash)
												while not HasModelLoaded(ped_hash) do
													Citizen.Wait(1)
												end
												v.ped = CreatePed(1, ped_hash, Config.Second[number].dx, Config.Second[number].dy, Config.Second[number].dz-0.5, 0.0, false, true)
												SetBlockingOfNonTemporaryEvents(v.ped, true)
												SetPedDiesWhenInjured(v.ped, false)
												SetPedCanPlayAmbientAnims(v.ped, true)
												SetPedCanRagdollFromPlayerImpact(v.ped, false)
												SetEntityInvincible(v.ped, true)
												TaskGoToCoordAnyMeans(v.ped, CordsV.x-10, CordsV.y+2, CordsV.z, 1.3)
												Passengers = 0
											end
											Citizen.Wait(3000)
											for i, v in pairs(Config.Second[number].Peds['Peds']) do
												DeletePed(v.ped)
											end
										end
											
										for i, v in pairs(Config.Second[number].Peds['Peds']) do
											local ped_hash = GetHashKey(Config.BusDriver['Peds'][math.random(1,#Config.BusDriver['Peds'])].ped)
											RequestModel(ped_hash)
											while not HasModelLoaded(ped_hash) do
												Citizen.Wait(1)
											end
											v.ped = CreatePed(1, ped_hash, v.x, v.y, v.z-0.5, v.h, false, true)
											SetBlockingOfNonTemporaryEvents(v.ped, true)
											SetPedDiesWhenInjured(v.ped, false)
											SetPedCanPlayAmbientAnims(v.ped, true)
											SetPedCanRagdollFromPlayerImpact(v.ped, false)
											SetEntityInvincible(v.ped, true)
											TaskGoToCoordAnyMeans(v.ped, Config.Second[number].dx, Config.Second[number].dy, Config.Second[number].dz, 1.3)
											Passengers = 3
										end

										exports.rprogress:Custom({
											Duration = 3000,
											Label = "Passengers board...",
											Animation = {
												scenario = "", -- https://pastebin.com/6mrYTdQv
												animationDictionary = "", -- https://alexguirre.github.io/animations-list/
											},
											DisableControls = {
												Mouse = false,
												Player = true,
												Vehicle = true
											}
										})
										Citizen.Wait(3000)
										for i, v in pairs(Config.Second[number].Peds['Peds']) do
											DeletePed(v.ped)
										end

										RemoveBlip(WorkBlip)
										WorkBlip = nil
										SetVehicleDoorShut(vehicle, 1, false)

										FreezeEntityPosition(vehicle, false)
											
										v.done = true
										if number >= #Config.Second then
											close = true
											break
										end
										ProjectRP.Functions.TriggerCallback('prp-busdriver:payout', function(money)
											exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>You have earned '..money..'$ go to the next point', timeout = 4500})
										end)
										number = number + 1
									else
										exports.pNotify:SendNotification({text = "<b>Bus Driver</b></br>It's not your bus", timeout = 4500})
									end
								end
							end
						end
					end
				end
			end
			if close then
				ProjectRP.Functions.TriggerCallback('prp-busdriver:payout', function(money)
					exports.pNotify:SendNotification({text = '<b>Bus Driver</b></br>You have earned '..money..'$ End of the route, go for the next one', timeout = 4500})
				end)
				number = 1
				for i, v in pairs(Config.First) do
					v.done = false
				end
				for i, v in pairs(Config.Second) do
					v.done = false
				end
				Route = nil
				close = false
				Passengers = 0
				CreateRouteSelection()
				break
			end
		Citizen.Wait(sleep)
	end
end

function CreateWorkBlip(type,number)
	if not WorkBlip then
		if type == 'first' then
			WorkBlip = AddBlipForCoord(Config.First[number].x, Config.First[number].y, Config.First[number].z)
			
			SetBlipSprite (WorkBlip, 162)
			SetBlipDisplay(WorkBlip, 4)
			SetBlipScale  (WorkBlip, 0.8)
			SetBlipColour (WorkBlip, 0)
			SetBlipAsShortRange(WorkBlip, true)
			
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Bus Stop')
			EndTextCommandSetBlipName(WorkBlip)
			SetBlipRoute(WorkBlip, true)
		elseif type == 'second' then
			WorkBlip = AddBlipForCoord(Config.Second[number].x, Config.Second[number].y, Config.Second[number].z)
			
			SetBlipSprite (WorkBlip, 162)
			SetBlipDisplay(WorkBlip, 4)
			SetBlipScale  (WorkBlip, 0.8)
			SetBlipColour (WorkBlip, 0)
			SetBlipAsShortRange(WorkBlip, true)
			
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Bus Stop')
			EndTextCommandSetBlipName(WorkBlip)
			SetBlipRoute(WorkBlip, true)
		end
	end
end

function CreateRouteSelection()
	RouteSelection = AddBlipForCoord(Config.BusDriver['RouteSelection'].Pos.x, Config.BusDriver['RouteSelection'].Pos.y, Config.BusDriver['RouteSelection'].Pos.z)
	
	SetBlipSprite (RouteSelection, 459)
	SetBlipDisplay(RouteSelection, 4)
	SetBlipScale  (RouteSelection, 0.8)
	SetBlipColour (RouteSelection, 0)
	SetBlipAsShortRange(RouteSelection, true)
	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Route Selection')
	EndTextCommandSetBlipName(RouteSelection)
end

-- function DepositB()
-- 	DepositBlip = AddBlipForCoord(Config.Deposit['Deposit'].Pos.x, Config.Deposit['Deposit'].Pos.y, Config.Deposit['Deposit'].Pos.z)
	
-- 	SetBlipSprite (DepositBlip, 68)
-- 	SetBlipDisplay(DepositBlip, 4)
-- 	SetBlipScale  (DepositBlip, 0.8)
-- 	SetBlipColour (DepositBlip, 0)
-- 	SetBlipAsShortRange(DepositBlip, true)
	
-- 	BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentString('Return the vehicle')
-- 	EndTextCommandSetBlipName(DepositBlip)
-- end

function CreateInspectionBlip()
	InspectionBlip = AddBlipForCoord(Config.BusDriver['Inspection'].Pos.x, Config.BusDriver['Inspection'].Pos.y, Config.BusDriver['Inspection'].Pos.z)
	
	SetBlipSprite (InspectionBlip, 464)
	SetBlipDisplay(InspectionBlip, 4)
	SetBlipScale  (InspectionBlip, 0.8)
	SetBlipColour (InspectionBlip, 0)
	SetBlipAsShortRange(InspectionBlip, true)
	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Bus Inspection')
	EndTextCommandSetBlipName(InspectionBlip)
end

function Randomize(tb)
	local keys = {}
	for k in pairs(tb) do table.insert(keys, k) end
	return tb[keys[math.random(#keys)]]
end

function startAnim(ped, dictionary, anim)
	Citizen.CreateThread(function()
	  RequestAnimDict(dictionary)
	  while not HasAnimDictLoaded(dictionary) do
		Citizen.Wait(0)
	  end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

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


