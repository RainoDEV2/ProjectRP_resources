RegisterCommand('seat', function(source, args)
	if args[1] ~= nil and tonumber(args[1]) >= 1 and tonumber(args[1]) <= 4 then
	  TriggerEvent('car:swapseat', tonumber(args[1]) - 2)
	end
end)



RegisterNetEvent('car:swapseat')
AddEventHandler('car:swapseat', function(num)
	local num = tonumber(num)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetPedIntoVehicle(PlayerPedId(),veh,num)
end)


RegisterCommand("door", function(source, args, raw)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	local Driver = GetPedInVehicleSeat(veh, -1)
	
	if args[1] ~= nil then
		door = tonumber(args[1]) - 1
	else
		door = nil
	end

	if door ~= nil then
		if DoesEntityExist(Driver) and IsPedInAnyVehicle(ped, false) then
			if GetVehicleDoorAngleRatio(veh, door) > 0 then
				SetVehicleDoorShut(veh, door, false)
			else	
				SetVehicleDoorOpen(veh, door, false, false)
			end
		end
	end
end)