local ProjectRP = exports['prp-core']:GetCoreObject()

--Slow and visible cleaning command
RegisterNetEvent('prp-mechanic:client:cleanVehicle', function(skip)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not skip then if not jobChecks() then return end end
	if not inCar() then return end
	if not nearPoint(coords) then return end
	vehicle = getClosest(coords) pushVehicle(vehicle)
	if DoesEntityExist(vehicle) then
	local cleaning = false
	if skip then
		if GetVehicleDirtLevel(vehicle) <= 0.1 then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].clean, "success") SetVehicleDirtLevel(vehicle, 0.0) updateCar(vehicle) return
		elseif GetVehicleDirtLevel(vehicle) > 0.1 then
			cleaning = true 
			TriggerServerEvent("ProjectRP:Server:RemoveItem", 'cleaningkit', 1)
			TriggerEvent('inventory:client:ItemBox', ProjectRP.Shared.Items['cleaningkit'], "use", 1)
		end
	else cleaning = true end
		TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"})
		Wait(150)
		TriggerEvent('animations:client:EmoteCommandStart', {"clean2"})
		while cleaning do 
			if GetVehicleDirtLevel(vehicle) >= 1.0 then SetVehicleDirtLevel(vehicle, (tonumber(GetVehicleDirtLevel(vehicle))) - 0.3)
			elseif GetVehicleDirtLevel(vehicle) <= 1.0 then SetVehicleDirtLevel(vehicle, 0.0) cleaning = false TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].clean, "success") emptyHands(playerPed, true) updateCar(vehicle) end
			Wait(300)
		end
	end
end)

--Multipurpose Door command
RegisterNetEvent('prp-mechanic:client:openDoor', function(door)
	local doornum = tonumber(door)
	if doornum < 0 or doornum > 5 then
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].doorerr, "error")
		return
	end
	local coords = GetEntityCoords(PlayerPedId())
	if not nearPoint(coords) then return end
	local vehicle = nil
	if IsPedSittingInAnyVehicle(PlayerPedId()) then	vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	else vehicle = getClosest(coords) pushVehicle(vehicle) end
	if DoesEntityExist(vehicle) then
		if GetVehicleDoorLockStatus(vehicle) == 2 then
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].locked, "error")
			return
		else
			if GetVehicleDoorAngleRatio(vehicle, doornum) > 0.0 then SetVehicleDoorShut(vehicle, doornum, false)
			else SetVehicleDoorOpen(vehicle, doornum, false, false) end
		end
	end
end)

RegisterNetEvent("prp-mechanic:flipvehicle", function()
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle = nil
	if not inCar() then	return end
	if not nearPoint(coords) then return end
	vehicle = getClosest(coords) pushVehicle(vehicle)
	if DoesEntityExist(vehicle) then
		ProjectRP.Functions.Progressbar("accepted_key", Loc[Config.Lan]["extras"].flipping, 12000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false,	disableCombat = false, }, 
		{ task = "CODE_HUMAN_MEDIC_TEND_TO_DEAD" }, {}, {}, function() -- Done
			emptyHands(playerPed)
			vehiclecoords = GetEntityCoords(vehicle)
			SetEntityCoords(vehicle, vehiclecoords.x+0.5, vehiclecoords.y+0.5, vehiclecoords.z+1)
			Wait(200)
			SetEntityRotation(vehicle, GetEntityRotation(PlayerPedId(), 2), 2)
			Wait(500)
			SetVehicleOnGroundProperly(vehicle)
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].flipped, "success")
		end, function() -- Cancel
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].failed, "error")
			emptyHands(playerPed)
		end)
	end
end)

RegisterNetEvent("prp-mechanic:seat", function(seat)
	if not seat then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["extras"].noseat, "error") return end
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	local IsSeatFree = IsVehicleSeatFree(vehicle, tonumber(seat))
	local speed = GetEntitySpeed(vehicle)
	local HasHarnass = exports['prp-smallresources']:HasHarness()
	if not HasHarnass then
		local kmh = (speed * 3.6);
		if IsSeatFree then
			if kmh <= 100.0 then
				SetPedIntoVehicle(PlayerPedId(), vehicle, tonumber(seat))
				-- ProjectRP.Functions.Notify(Loc[Config.Lan]["extras"].moveseat..seat.."!")
			else
				ProjectRP.Functions.Notify(Loc[Config.Lan]["extras"].fastseat)
			end
		else
			ProjectRP.Functions.Notify(Loc[Config.Lan]["extras"].notseat)
		end
	else
		ProjectRP.Functions.Notify(Loc[Config.Lan]["extras"].harness, 'error')
	end
end)

local vehicle_sounds = {}
RegisterNetEvent("engine:sound")
AddEventHandler("engine:sound", function(name,plate)
    if vehicle_sounds[plate] == nil then vehicle_sounds[plate] = {} end
    vehicle_sounds[plate].plate = plate vehicle_sounds[plate].name = name
end)

CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(GetGamePool('CVehicle')) do
            if #(mycoords - GetEntityCoords(v, false)) < 100 then
                local plate = string.gsub(GetVehicleNumberPlateText(v), "%s+", "")
                if vehicle_sounds[plate] ~= nil and vehicle_sounds[plate].plate ~= nil and plate == vehicle_sounds[plate].plate and vehicle_sounds[plate].current ~= vehicle_sounds[plate].name then
                    ForceVehicleEngineAudio(v,vehicle_sounds[plate].name)
                    vehicle_sounds[plate].current = vehicle_sounds[plate].name
                end
            end
        end
        Wait(2000)
    end
end)

RegisterNetEvent("prp-mechanic:togglesound", function(toggle)
	if toggle:lower() ~= "on" and toggle:lower() ~= "off" then TriggerEvent('ProjectRP:Notify', "Error", "error") return end
	vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
	--Grab info which engine is already in
	currentEngine = GetVehicleMod(vehicle, 11)
	if toggle == "on" then
		if currentEngine == 3 then ForceVehicleEngineAudio(vehicle,"monster")
		elseif currentEngine == 2 then	ForceVehicleEngineAudio(vehicle,"krieger")
		elseif currentEngine == 1 then	ForceVehicleEngineAudio(vehicle,"zentorno")
		elseif currentEngine == 0 then	ForceVehicleEngineAudio(vehicle,"zorrusso") end
	elseif toggle == "off" then
		ForceVehicleEngineAudio(vehicle,string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
	end
end, false)

--ODOMETER FUNCTION
CreateThread(function()
	Wait(500)
	while true do
		local ped = PlayerPedId()
		local invehicle = IsPedInAnyVehicle(ped, true)
		if invehicle then
			local veh = GetVehiclePedIsIn(ped)
			if not IsVehicleStopped(veh) then
				local seat = GetPedInVehicleSeat(veh, -1)
				local plate = trim(GetVehicleNumberPlateText(veh))
				if plate ~= nil then
					if seat == ped then
						TriggerServerEvent('prp-mechanic:server:UpdateDrivingDistance', plate)
					end
				end
			end
		end
		if invehicle then Wait(5000)
		else Wait(500) end
	end
end)


