local anchored = false
RegisterCommand('anchor', function()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyBoat(ped) then
        local boat = GetVehiclePedIsIn(ped, true)
        if boat ~= nil then
            anchored = not anchored
            FreezeEntityPosition(boat, anchored)
        end
    end
end)


-- Realistic Anchoring

-- local anchored = false
-- local boat = nil
-- Citizen.CreateThread(function()
-- 	while true do

-- 		Wait(0)
-- 		local ped = GetPlayerPed(-1)
-- 		if IsPedInAnyBoat(ped) then
-- 		boat  = GetVehiclePedIsIn(ped, true)
-- 		end
-- 		if IsControlJustPressed(0, 81) and not IsPedInAnyVehicle(ped) and boat ~= nil then
-- 			if not anchored then
-- 				SetBoatAnchor(boat, true)
-- 				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
-- 				Citizen.Wait(10000)
-- 				TriggerEvent("pNotify:SendNotification",{
--                     text = "Boat anchored!",
--                     type = "success",
--                     timeout = (3000),
--                     layout = "bottomCenter",
--                     queue = "global",
--                     animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
--                     killer = true,
--                     sounds = {
--                         sources = {"Anchordown.ogg"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
--                         volume = 0.1,
--                         conditions = {"docVisible"}  
--                     }  
-- 				})
-- 				ClearPedTasks(ped)
-- 			else
-- 				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
-- 				Citizen.Wait(10000)
-- 				SetBoatAnchor(boat, false)
-- 				TriggerEvent("pNotify:SendNotification",{
--                     text = "Boat not anchored anymore",
--                     type = "success",
--                     timeout = (3000),
--                     layout = "bottomCenter",
--                     queue = "global",
--                     animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
--                     killer = true,
--                     sounds = {
--                         sources = {"Anchorup.ogg"}, -- For sounds to work, you place your sound in the html folder and then add it to the files array in the __resource.lua file.
--                         volume = 0.1,
--                         conditions = {"docVisible"}  
--                     }  
-- 				})
-- 				ClearPedTasks(ped)
-- 			end
-- 			anchored = not anchored
-- 		end
-- 				if IsVehicleEngineOn(boat) then
-- 			anchored = false
-- 		end
-- 	end
-- end)