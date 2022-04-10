local ProjectRP = exports['prp-core']:GetCoreObject()

DrawText3D = function(x, y, z, text)
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

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local started = false
local progress = 0
local CurrentVehicle 
local pause = false
local quality = 0
local LastCar

RegisterNetEvent('prp-methcar:stop')
AddEventHandler('prp-methcar:stop', function()
	started = false
	ProjectRP.Functions.Notify("Production stopped...", "error")
	FreezeEntityPosition(LastCar, false)
end)

RegisterNetEvent('prp-methcar:stopfreeze')
AddEventHandler('prp-methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)

RegisterNetEvent('prp-methcar:notify')
AddEventHandler('prp-methcar:notify', function(message)
	ProjectRP.Functions.Notify(message)
end)

RegisterNetEvent('prp-methcar:startprod')
AddEventHandler('prp-methcar:startprod', function()
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	ProjectRP.Functions.Notify("Production started", "success")	
	SetPedIntoVehicle((PlayerPedId()), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('prp-methcar:smoke')
AddEventHandler('prp-methcar:smoke', function(posx, posy, posz, bool)
	if bool == 'a' then
		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_bzgas_smoke", posx, posy, posz + 1.6, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.9)
		Citizen.Wait(60000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end
end)

-------------------------------------------------------EVENTS NEGATIVE
RegisterNetEvent('prp-methcar:boom', function()
	playerPed = (PlayerPedId())
	local pos = GetEntityCoords((PlayerPedId()))
	pause = false
	Citizen.Wait(500)
	started = false
	Citizen.Wait(500)
	CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
	TriggerServerEvent('prp-methcar:blow', pos.x, pos.y, pos.z)
	TriggerEvent('prp-methcar:stop')
	FreezeEntityPosition(LastCar,false)
end)

RegisterNetEvent('prp-methcar:blowup')
AddEventHandler('prp-methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2, 15, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)	
end)

RegisterNetEvent('prp-methcar:drugged')
AddEventHandler('prp-methcar:drugged', function()
	local pos = GetEntityCoords((PlayerPedId()))
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur((PlayerPedId()), true)
	SetPedMovementClipset((PlayerPedId()), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk((PlayerPedId()), true)
	quality = quality - 3
	pause = false
	Citizen.Wait(90000)
	ClearTimecycleModifier()
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:q-1police', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "error")
	quality = quality - 1
	pause = false
	TriggerServerEvent('police:server:policeAlert', 'Person reports stange smell!')
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:q-1', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "error")
	quality = quality - 1
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:q-3', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "error")
	quality = quality - 3
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:q-5', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "error")
	quality = quality - 5
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

-------------------------------------------------------EVENTS POSITIVE
RegisterNetEvent('prp-methcar:q2', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "success")
	quality = quality + 2
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:q3', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "success")
	quality = quality + 3
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:q5', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "success")
	quality = quality + 5
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('prp-methcar:gasmask', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	ProjectRP.Functions.Notify(data.message, "success")
	SetPedPropIndex(playerPed, 1, 26, 7, true)
	quality = quality + 2
	pause = false
	TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
end)

local METHSLEEP = 3500
-------------------------------------------------------THREAD
Citizen.CreateThread(function(data)
	while true do		
		playerPed = (PlayerPedId())
		local pos = GetEntityCoords((PlayerPedId()))
		if IsPedInAnyVehicle(playerPed) then	
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())
			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)			
			if modelName == 'JOURNEY' and car then				
				METHSLEEP = 1
					if GetPedInVehicleSeat(car, -0) == playerPed then
							DrawText3D(pos.x, pos.y, pos.z, '~g~E~w~ to (cook)')
							if IsControlJustReleased(0, Keys['E']) then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('prp-methcar:start')
									TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
									progress = 0
									pause = false
									quality = 0		
								else
									ProjectRP.Functions.Notify('This kichen is already in use..')
								end
							end
					end		
			end			
		else	
				if started then
					started = false
					TriggerEvent('prp-methcar:stop')
					FreezeEntityPosition(LastCar,false)
				end
		end		
		if started == true then	
			METHSLEEP = 1
			if progress < 96 then
				Citizen.Wait(500)
				-- TriggerServerEvent('prp-methcar:make', pos.x,pos.y,pos.z)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					quality = quality + 1
					ProjectRP.Functions.Notify('Meth production: ' .. progress .. '%')
					Citizen.Wait(4000)
				end
				--
				--   EVENT 1
				--
				if progress > 9 and progress < 11 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "Gas tank is leaking... now what?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Fix with tape",
							params = {
								event = "prp-methcar:q-3",
								args = {
									message = "That kinda fixed it, i think?!"
								}
							}
						},
						{
							header = "🔴 Let it go!",
							params = {
								event = "prp-methcar:boom"
							}
						},
						{
							header = "🔴 Replace tube",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "Replacing was the best solution!"
								}
							}
						},
					})
				end
				--
				--   EVENT 2
				--
				if progress > 19 and progress < 21 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "You spilled some acetone on the floor.. now what?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Open a window",
							params = {
								event = "prp-methcar:q-1police",
								args = {
									message = "The smell is reaching more people..."
								}
							}
						},
						{
							header = "🔴 Breathe it in..",
							params = {
								event = "prp-methcar:drugged"
							}
						},
						{
							header = "🔴 Put on a gass mask",
							params = {
								event = "prp-methcar:gasmask",
								args = {
									message = "Good choise"
								}
							}
						},
					})
				end
				--
				--   EVENT 3
				--
				if progress > 29 and progress < 31 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "Meth is clugging up to fast, what to do?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Add more temperature",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "A higher temperture made the perfect balance!"
								}
							}
						},
						{
							header = "🔴 Add more pressure",
							params = {
								event = "prp-methcar:q-3",
								args = {
									message = "The pressure fluctuated a lot.."
								}
							}
						},
						{
							header = "🔴 Lower the pressure",
							params = {
								event = "prp-methcar:q-5",
								args = {
									message = "That was the worst thing to do!"
								}
							}
						},
					})
				end
				--
				--   EVENT 4
				--
				if progress > 39 and progress < 41 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "You added to much acetone, what to do?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Do nothing..",
							params = {
								event = "prp-methcar:q-5",
								args = {
									message = "The Meth is smelling like pure acetone"
								}
							}
						},
						{
							header = "🔴 Use a straw to suck it out",
							params = {
								event = "prp-methcar:drugged"
							}
						},
						{
							header = "🔴 Add lithium to stabilize",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "Smart solution"
								}
							}
						},
					})
				end
				--
				--   EVENT 5
				--
				if progress > 49 and progress < 51 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "There is some blue pigment, use it?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Add it in the mix!",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "Smart move, people like it!"
								}
							}
						},
						{
							header = "🔴 Put away",
							params = {
								event = "prp-methcar:q-1",
								args = {
									message = "Not very creative are you?"
								}
							}
						},
					})
				end
				--
				--   EVENT 6
				--
				if progress > 59 and progress < 61 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "The filter is filthy, now what?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Blow it out with a compressor",
							params = {
								event = "prp-methcar:q-5",
								args = {
									message = "You made a mess of the product!"
								}
							}
						},
						{
							header = "🔴 Replace the filter!",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "Replacing was the best option!"
								}
							}
						},
						{
							header = "🔴 Clean it with a brush",
							params = {
								event = "prp-methcar:q-1",
								args = {
									message = "It helped but not enough"
								}
							}
						},
					})
				end
				--
				--   EVENT 7
				--
				if progress > 69 and progress < 71 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "You spilled some acetone on the floor.. now what?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Breathe it in..",
							params = {
								event = "prp-methcar:drugged"
							}
						},
						{
							header = "🔴 Put on a gass mask",
							params = {
								event = "prp-methcar:gasmask",
								args = {
									message = "Good choise"
								}
							}
						},
						{
							header = "🔴 Open a window",
							params = {
								event = "prp-methcar:q-1police",
								args = {
									message = "The smell is reaching more people..."
								}
							}
						},
					})
				end
				--
				--   EVENT 8
				--
				if progress > 79 and progress < 81 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "Gas tank is leaking... now what?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Let it go!",
							params = {
								event = "prp-methcar:boom"
							}
						},
						{
							header = "🔴 Fix it with tape",
							params = {
								event = "prp-methcar:q-3",
								args = {
									message = "That kinda fixed it, i think?!"
								}
							}
						},
						{
							header = "🔴 Replace tube",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "Replacing was the best solution!"
								}
							}
						},
					})
				end
				--
				--   EVENT 9
				--
				if progress > 89 and progress < 91 then
					pause = true
					exports['prp-menu']:openMenu({
						{
							header = "You really need to take a shit! What do you do?",
							txt = "Pick your answer below. Progres: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Just pinch it off!",
							params = {
								event = "prp-methcar:q5",
								args = {
									message = "SUPER JOB, I'm proud!"
								}
							}
						},
						{
							header = "🔴 Go outside to shit!",
							params = {
								event = "prp-methcar:q-1police",
								args = {
									message = "Somebody spotted you're suspicious work!"
								}
							}
						},
						{
							header = "🔴 Shit inside!",
							params = {
								event = "prp-methcar:q-5",
								args = {
									message = "Not good! Everything smells like SHIT!"
								}
							}
						},
					})
				end
			else
				TriggerEvent('prp-methcar:stop')
				progress = 100
				ProjectRP.Functions.Notify('Meth production: ' .. progress .. '%')
				ProjectRP.Functions.Notify("Done!!", "success")
				TriggerServerEvent('prp-methcar:finish', quality)
				SetPedPropIndex(playerPed, 1, 0, 0, true)
				FreezeEntityPosition(LastCar, false)
			end				
		end
		Citizen.Wait(METHSLEEP)		
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle((PlayerPedId())) then
			else
				if started then
					started = false
					TriggerEvent('prp-methcar:stop')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end
end)
