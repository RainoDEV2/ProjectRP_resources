



local Logan = nil
local Peds = {}
local Frank = nil

function CreateNPC(name, interaction, pedHash, vector, heading, animation, callback)

	local DealerPed = pedHash

	if DealerPed == nil then

	   DealerPed = 803106487

	end

	if animation == nil then

	   animation = "WORLD_HUMAN_GUARD_PATROL"

	end

	Citizen.CreateThread(function()

	   RequestModel(DealerPed)



	   while not HasModelLoaded(DealerPed) do

		  Citizen.Wait(1)

	   end



	   local vehicleDealer = CreatePed(1, DealerPed, vector.x, vector.y, vector.z, heading, false, true)

	   SetBlockingOfNonTemporaryEvents(vehicleDealer, true)

	   SetPedDiesWhenInjured(vehicleDealer, false)

	   SetPedCanPlayAmbientAnims(vehicleDealer, true)

	   SetPedCanRagdollFromPlayerImpact(vehicleDealer, false)

	   SetEntityInvincible(vehicleDealer, true)

	   FreezeEntityPosition(vehicleDealer, true)

	   TaskStartScenarioInPlace(vehicleDealer, animation, 0, true);

	   TheNPC = vehicleDealer



	   table.insert(Peds, {Ped = vehicleDealer, Location = vector, Heading = heading, Name = name, Callback = callback, Interaction = interaction or "interact"})



	   print("[NPC] Added NPC " .. name)



	   SetModelAsNoLongerNeeded(DealerPed)

	end)

end




Citizen.CreateThread(function()
    Citizen.Wait(3000)


    local hasRented = false

	CreateNPC("Mario", "rent a bike", x, vector3(-671.3581, -1099.6770, 13.6753), 64.6626, nil, function(NPC)

		if not hasRented then

			exports['prp-tasknotify']:AddDialog("Mario", "Hey, would you like to borrow my bicycle buddy?", function(val)

				if val then

					-- TriggerEvent("doChatBlue", "Your bicycle is here my friend")


                    ProjectRP.Functions.SpawnVehicle("bmx", function(veh)
                        SetVehicleNumberPlateText(veh, "Rented")
                        SetEntityHeading(veh, 334.1462)
                        exports['prp-fuel']:SetFuel(veh, 100.0)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        SetEntityAsMissionEntity(veh, true, true)
                        TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))
                        SetVehicleEngineOn(veh, true, true)
                        hasRented = true
                    end, vector3(-673.1433, -1098.7621, 14.5602), true)


				end

			end)

		end

	end)

    CreateNPC("Logan", "trade", GetHashKey("g_m_y_ballaeast_01"), vector3(83.2422, -1858.6323, 23.2198), 290.0297, "amb@world_human_leaning@female@wall@back@hand_up@idle_a", function(NPC)
		Logan = NPC

		PlayAmbientSpeech1(Logan, "GENERIC_HOWS_IT_GOING", "SPEECH_PARAMS_FORCE_SHOUTED")

		exports['prp-tasknotify']:AddDialog("Logan", "You interested in trading aluminum for a lockpick?", function(val)
			if val then
                ProjectRP.Functions.Progressbar("Checking_through_inventory", "Checking through inventory", 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
                        if hasItem then
                            -- TriggerServerEvent("ProjectRP:Server:RemoveItem", "aluminum", 2)
                            -- TriggerEvent("inventory:client:ItemBox", ProjectRP.Shared.Items["aluminum"], "remove")


						    PlayAmbientSpeech1(Logan, "GENERIC_THANKS", "SPEECH_PARAMS_FORCE_SHOUTED")
                            TriggerServerEvent("__ProjectRP:Logan")
                        else
							PlayAmbientSpeech1(Logan, "GENERIC_CURSE_HIGH", "SPEECH_PARAMS_FORCE_SHOUTED")
                            ProjectRP.Functions.Notify('Come back when you got shit Idiot!', "error")
                        end
                    end, 'aluminum')
                end, function() -- Cancel

                end)

			else
				PlayAmbientSpeech1(Logan, "GENERIC_CURSE_HIGH", "SPEECH_PARAMS_FORCE_SHOUTED")
			end
		end)
	end)

    CreateNPC("Frank", "Rent a Car", GetHashKey('a_m_y_business_03'), vector3(109.9739, -1088.61, 28.302), 345.64, 'WORLD_HUMAN_CLIPBOARD', function(NPC)
		Frank = NPC

		PlayAmbientSpeech1(Frank, "GENERIC_HOWS_IT_GOING", "SPEECH_PARAMS_FORCE_SHOUTED")
        TriggerEvent("prp-rental:openMenu")
	end)







	-- Table = CreateObject(-555690024,-539.772, -231.768, 35.708,false,false,false)
	-- SetEntityHeading(Table, 224.098)
	-- FreezeEntityPosition(Table)
end)


local function DrawText3D(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local WaitTime = 5000
    -- interactions
    Citizen.CreateThread(function()
        Citizen.Wait(500)
    
        while true do
    
            local playerPed = PlayerPedId()
    
            local coords    = GetEntityCoords(playerPed)

    
            for k,v in pairs(Peds) do

            local distance = GetDistanceBetweenCoords(coords, v.Location.x, v.Location.y, v.Location.z, true)


            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
    
                WaitTime = 5000
    
            elseif distance < 10.0 then
    
                WaitTime = 5
    
                    if DoesEntityExist(v.Ped) then
    

                        if distance <= 3.0 then
    
                            DrawText3D({
    
                            x = v.Location.x,
    
                            y = v.Location.y,
    
                            z = v.Location.z + 2.0
    
                            }, v.Name)
    
    
    
                            DrawText3D({x = v.Location.x,y = v.Location.y,z = v.Location.z + 1.0}, "Press [~g~G~w~] to " .. v.Interaction or "interact")
    

                            if IsControlJustReleased(1, 47) then
    
                                v.Callback(v.Ped)
    
                            end
                        end
                    end
                end
            end    
            Citizen.Wait(WaitTime)
        end
    end)


AddEventHandler('onResourceStop', function(resource)

    if resource == GetCurrentResourceName() then

        DeleteEntity(Frank)
        DeleteEntity(Logan)
        -- DeleteEntity(Table)

    end

end)












-- ==========================
-- ==== R E N T A L =========
-- ==========================

RegisterNetEvent('prp-rental:spawncar')
AddEventHandler('prp-rental:spawncar', function(data)
    local money =data.money
    local model = data.model
    local player = PlayerPedId()
    ProjectRP.Functions.SpawnVehicle(model, function(vehicle)
        SetEntityHeading(vehicle, 340.0)
        TaskWarpPedIntoVehicle(player, vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
        SpawnVehicle = true
    end, vector4(111.4223, -1081.24, 29.192,340.0), true)
    Wait(1000)
    local vehicle = GetVehiclePedIsIn(player, false)
    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    vehicleLabel = GetLabelText(vehicleLabel)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('prp-rental:rentalpapers', plate, vehicleLabel, money)
end)

RegisterNetEvent('prp-rental:return')
AddEventHandler('prp-rental:return', function()
    if SpawnVehicle then
        local Player = ProjectRP.Functions.GetPlayerData()
        ProjectRP.Functions.Notify('Returned vehicle!', 'success')
        TriggerServerEvent('prp-rental:removepapers')
        local car = GetVehiclePedIsIn(PlayerPedId(),true)
        NetworkFadeOutEntity(car, true,false)
        Citizen.Wait(2000)
        ProjectRP.Functions.DeleteVehicle(car)
    else 
        ProjectRP.Functions.Notify("No vehicle to return", "error")
    end
    SpawnVehicle = false
end)

CreateThread(function()
    blip = AddBlipForCoord(111.0112, -1088.67, 29.302)
    SetBlipSprite (blip, 56)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.5)
    SetBlipColour (blip, 77)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Vehicle Rental')
    EndTextCommandSetBlipName(blip)
end)


RegisterNetEvent('prp-rental:openMenu', function()
    exports['prp-menu']:openMenu({
        {
            header = "Rental Vehicles",
            isMenuHeader = true,
        },
        {
            id = 1,
            header = "Return Vehicle ",
            txt = "Return your rented vehicle.",
            params = {
                event = "prp-rental:return",
            }
        },
        {
            id = 2,
            header = "Asterope",
            txt = "$250.00",
            params = {
                event = "prp-rental:spawncar",
                args = {
                    model = 'asterope',
                    money = 250,
                }
            }
        },
        {
            id = 3,
            header = "Bison ",
            txt = "$500.00",
            params = {
                event = "prp-rental:spawncar",
                args = {
                    model = 'bison',
                    money = 500,
                }
            }
        },
        {
            id = 4,
            header = "Sanchez",
            txt = "$3000.00",
            params = {
                event = "prp-rental:spawncar",
                args = {
                    model = 'sanchez',
                    money = 3000,
                }
            }
        },
    })
end)