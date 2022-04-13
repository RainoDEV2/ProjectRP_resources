local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Headlights
RegisterNetEvent('prp-mechanic:client:applyXenons', function()
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not inCar() then return end
	if not nearPoint(coords) then return end
	if not IsPedInAnyVehicle(playerPed, false) then	vehicle = getClosest(coords) pushVehicle(vehicle)
		local headlightl = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "headlight_l"))
		local headlightr = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "headlight_r"))
		local playerpos = GetEntityCoords(PlayerPedId(), 1)
		distanceToL = #(playerpos - headlightl)
		distanceToR = #(playerpos - headlightr)
	end
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if DoesEntityExist(vehicle) then
		if GetNumVehicleMods(vehicle,11) == 0 then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error") return end
		if distanceToL <= 1 or distanceToR <= 1 then
			if IsToggleModOn(vehicle, 22) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].already, "error")
			else
				TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
				Wait(1000)
				time = math.random(3000,7000)
				ProjectRP.Functions.Progressbar("accepted_key", Loc[Config.Lan]["xenons"].install, time, false, true, { disableMovement = true, disableCarMovement = true,	disableMouse = false, disableCombat = false, },
				{ animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", flags = 8, }, {}, {}, function() -- Done
					if IsToggleModOn(vehicle, 22) then TriggerServerEvent("prp-mechanic:server:DupeWarn", "headlights") emptyHands(playerPed) return end
					ToggleVehicleMod(vehicle, 22, true)
					updateCar(vehicle)
					TriggerServerEvent('prp-mechanic:server:removeXenon')
					TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].installed, "success")
					emptyHands(playerPed)
				end, function() -- Cancel
					TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].failed, "error")				
					emptyHands(playerPed)
				end)
			end
		else TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].closer, "error") end
	end
end)

RegisterNetEvent('prp-mechanic:client:giveXenon', function()	
	if not jobChecks() then return end
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	vehicle = getClosest(coords) pushVehicle(vehicle)
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	local headlightl = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "headlight_l"))
	local headlightr = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "headlight_r"))
	local playerpos = GetEntityCoords(PlayerPedId(), 1)
	distanceToL = #(playerpos - headlightl)
	distanceToR = #(playerpos - headlightr)
	if distanceToR <= 1 or distanceToL <= 1 then
		TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
		Wait(1000)
		ProjectRP.Functions.Progressbar("accepted_key", Loc[Config.Lan]["xenons"].removing, 8000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false,	},
		{ animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", flags = 8, }, {}, {}, function()
		if not IsToggleModOn(vehicle, 22) then TriggerServerEvent("prp-mechanic:server:DupeWarn", "headlights") emptyHands(playerPed) return end
		ToggleVehicleMod(vehicle, 22, false)
			SetVehicleHeadlightsColour(vehicle, 0)
			emptyHands(playerPed)
			updateCar(vehicle)
			TriggerServerEvent('prp-mechanic:server:giveXenon')
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].remove, "success")
		end, function() -- Cancel
			TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].remfail, "error")
			emptyHands(playerPed)
		end)	
	else
		TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].closer, "error")
	end
end)

RegisterNetEvent('prp-mechanic:client:neonMenu', function()
    local playerPed	= PlayerPedId()
	local bike = false
	if not outCar() then return end
	local vehicle = GetVehiclePedIsIn(playerPed) pushVehicle(vehicle) vehProps = ProjectRP.Functions.GetVehicleProperties(vehicle)
	if Config.isVehicleOwned and not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].owned, "error") return end
	if IsThisModelABike(GetEntityModel(vehicle)) or IsThisModelAQuadbike(GetEntityModel(vehicle)) then bike = true end				
	if bike and not IsToggleModOn(vehicle, 22) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["common"].noOptions, "error")	return end
	local NeonMenu = {
			{ isMenuHeader = true, header = Loc[Config.Lan]["xenons"].neonheader1, },
			{ header = "", txt = Loc[Config.Lan]["common"].close, params = { event = "prp-mechanic:Menu:Close" } } }
	if not bike then NeonMenu[#NeonMenu + 1] = { header = Loc[Config.Lan]["xenons"].neonheader2, txt = "", params = { event = "prp-mechanic:client:neonToggleMenu", } } end
	if not bike then NeonMenu[#NeonMenu + 1] = { header = Loc[Config.Lan]["xenons"].neonheader3, txt = "", params = { event = "prp-mechanic:client:neonColorMenu", } } end
	if IsToggleModOn(vehicle, 22) then NeonMenu[#NeonMenu + 1] = { header = Loc[Config.Lan]["xenons"].neonheader4, txt = "", params = { event = "prp-mechanic:client:xenonMenu", } } end

	exports['prp-menu']:openMenu(NeonMenu)
end)

RegisterNetEvent('prp-mechanic:client:applyNeonPostion', function(args) 
    local args = tonumber(args)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
	SetVehicleEngineOn(vehicle, true, true)
	if args == -1 then
		if not IsVehicleNeonLightEnabled(vehicle, 2) or not IsVehicleNeonLightEnabled(vehicle, 1) or not IsVehicleNeonLightEnabled(vehicle, 3) or not IsVehicleNeonLightEnabled(vehicle, 0) then
			for i = 0, 4 do	SetVehicleNeonLightEnabled(vehicle, i, true) Wait(50) end
		else 
			for i = 0, 4 do SetVehicleNeonLightEnabled(vehicle, i, false) Wait(50) end 
		end
	else if IsVehicleNeonLightEnabled(vehicle, args) then SetVehicleNeonLightEnabled(vehicle, args, false) else SetVehicleNeonLightEnabled(vehicle, args, true) end
    end
    TriggerEvent("prp-mechanic:client:neonToggleMenu")
end)

RegisterNetEvent('prp-mechanic:client:applyNeonColor', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
	SetVehicleEngineOn(vehicle, true, false)
	SetVehicleNeonLightsColour(vehicle, tonumber(data.R), tonumber(data.G), tonumber(data.B))
	TriggerEvent("prp-mechanic:client:neonColorMenu")
end)

RegisterNetEvent('prp-mechanic:client:neonCustomMenu', function()
    local dialog = exports['prp-input']:ShowInput({
        header = Loc[Config.Lan]["xenons"].customheader,
        submitText = Loc[Config.Lan]["xenons"].customconfirm,
        inputs = {
            { type = 'number', isRequired = true, name = 'Red', text = 'R' },
            { type = 'number', isRequired = true, name = 'Green', text = 'G' },
            { type = 'number', isRequired = true, name = 'Blue', text = 'B' } } })
    if dialog then
        if not dialog.Red or not dialog.Green or not dialog.Blue then return end
		local data = { R = dialog.Red, G = dialog.Green, B = dialog.Blue }
        TriggerEvent('prp-mechanic:client:applyNeonColor', data)
    end
end)

RegisterNetEvent('prp-mechanic:client:neonToggleMenu', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if IsVehicleNeonLightEnabled(vehicle, 2) then fHead = "✅" else fHead = "❌" end
	if IsVehicleNeonLightEnabled(vehicle, 1) then rHead = "✅" else rHead = "❌" end
	if IsVehicleNeonLightEnabled(vehicle, 3) then bHead = "✅" else bHead = "❌" end
	if IsVehicleNeonLightEnabled(vehicle, 0) then lHead = "✅" else lHead = "❌" end
    exports['prp-menu']:openMenu({
		{ header = Loc[Config.Lan]["xenons"].neonheader3, txt = Loc[Config.Lan]["xenons"].neontxt1, isMenuHeader = true },
        { header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:neonMenu", } },
        { header = Loc[Config.Lan]["xenons"].toggle, txt = "", params = { event = "prp-mechanic:client:applyNeonPostion", args = -1 } },
        { header = fHead..Loc[Config.Lan]["xenons"].front, txt = "", params = { event = "prp-mechanic:client:applyNeonPostion", args = 2 } },
        { header = rHead..Loc[Config.Lan]["xenons"].right, txt = "", params = { event = "prp-mechanic:client:applyNeonPostion", args = 1 } },
        { header = bHead..Loc[Config.Lan]["xenons"].back, txt = "", params = { event = "prp-mechanic:client:applyNeonPostion", args = 3 } },
        { header = lHead..Loc[Config.Lan]["xenons"].left, txt = "", params = { event = "prp-mechanic:client:applyNeonPostion", args = 0 } },
    })
end)

RegisterNetEvent('prp-mechanic:client:neonColorMenu', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) pushVehicle(vehicle) vehProps = ProjectRP.Functions.GetVehicleProperties(vehicle)
	local validMods = {}
	local r,g,b = GetVehicleNeonLightsColour(vehicle)
	local XenonMenu = {
	{ header = Loc[Config.Lan]["xenons"].neonheader3, txt = Loc[Config.Lan]["xenons"].neontxt2.."<br>R:"..r.." G:"..g.." B:"..b, isMenuHeader = true },
	{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:neonMenu", } },
	{ header = Loc[Config.Lan]["xenons"].customheader, txt = "", params = { event = "prp-mechanic:client:neonCustomMenu", } } }
	for k, v in pairs(Loc[Config.Lan].vehicleNeonOptions) do
		if r == v.R and g == v.G and b == v.B then installed = Loc[Config.Lan]["common"].current else installed = "" end
		XenonMenu[#XenonMenu + 1] = { header = v.name, txt = installed, params = { event = 'prp-mechanic:client:applyNeonColor', args = { R = v.R, G = v.G, B = v.B }  } }
	end
	exports['prp-menu']:openMenu(XenonMenu)
end)

RegisterNetEvent('prp-mechanic:client:applyXenonColor', function(args) 
    local args = tonumber(args)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleEngineOn(vehicle, true, false)
	SetVehicleHeadlightsColour(vehicle, args)
	updateCar(vehicle)
    TriggerEvent("prp-mechanic:client:xenonMenu")
end)

RegisterNetEvent('prp-mechanic:client:xenonMenu', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) pushVehicle(vehicle)
	local validMods = {}
	if not IsToggleModOn(vehicle, 22) then TriggerEvent("ProjectRP:Notify", Loc[Config.Lan]["xenons"].notinstall, "error") else
		local XenonMenu = {	
				{ header = Loc[Config.Lan]["xenons"].xenonheader, txt = Loc[Config.Lan]["xenons"].xenontxt, isMenuHeader = true },
				{ header = "", txt = Loc[Config.Lan]["common"].ret, params = { event = "prp-mechanic:client:neonMenu" } },
				{ header = Loc[Config.Lan]["common"].stock, txt = stockinstall, params = { event = "prp-mechanic:client:applyXenonColor", args = -1 } } }
		for k, v in pairs(Loc[Config.Lan].vehicleXenonOptions) do
			if GetVehicleHeadlightsColour(vehicle) == v.id then installed = Loc[Config.Lan]["common"].current else installed = "" end
			XenonMenu[#XenonMenu + 1] = { header = v.name, txt = installed, params = { event = 'prp-mechanic:client:applyXenonColor', args = v.id  } }
		end
		exports['prp-menu']:openMenu(XenonMenu)
	end
end)