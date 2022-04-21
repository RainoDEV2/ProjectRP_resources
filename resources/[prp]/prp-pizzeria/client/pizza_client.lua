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

ProjectRP = exports["prp-core"]:GetCoreObject()
local isLoggedIn = false
local PlayerData = {}
local PlayerJob = {}
local CurrentWorkObject_pizza = {}
local InProcess = false

local Nearby = false

local InRange = false

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
		ProjectRP.Functions.GetPlayerData(function(PlayerData)
			PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
			isLoggedIn = true 
		end)
    end) 
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload')
AddEventHandler('ProjectRP:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)


RegisterNetEvent('prp-pizzeria:client:SetStock')
AddEventHandler('prp-pizzeria:client:SetStock', function(stock, amount)
	Config.JobData[stock] = amount
end)

-- Code
RegisterNetEvent('prp-pizzeria:client:open:box')
AddEventHandler('prp-pizzeria:client:open:box', function(PidId)
    TriggerServerEvent("prp-inventory:server:OpenInventory", "stash", 'pizza_'..PidId, {maxweight = 29900, slots = 3})
    TriggerEvent("prp-inventory:client:SetCurrentStash", 'pizza_'..PidId)
end)

-- // Loops \\ --


-- functions


RegisterNetEvent('prp-pizzeria:client:open:payment')
AddEventHandler('prp-pizzeria:client:open:payment', function()
	SetNuiFocus(true, true)
	SendNUIMessage({action = 'OpenPaymentPizza', payments = Config.ActivePaymentsPizza})
end)

RegisterNetEvent('prp-pizzeria:client:open:register')
AddEventHandler('prp-pizzeria:client:open:register', function()
	if isLoggedIn then
		if (PlayerJob ~= nil) and PlayerJob.name == "pizza" then
		SetNuiFocus(true, true)
		SendNUIMessage({action = 'OpenRegisterPizza'})
		else
		ProjectRP.Functions.Notify('You are not authorized for this.')
		end
	end
end)

RegisterNetEvent('prp-pizzeria:client:sync:register')
AddEventHandler('prp-pizzeria:client:sync:register', function(RegisterConfig)
	Config.ActivePaymentsPizza = RegisterConfig
end)


function GetActiveRegister()
	return Config.ActivePaymentsPizza
end

RegisterNUICallback('Click', function()
	PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorClick', function()
	PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('AddPrice', function(data)
	TriggerServerEvent('prp-pizzeria:server:add:to:register', data.Price, data.Note)
end)

RegisterNUICallback('PayReceipt', function(data)
	TriggerServerEvent('prp-pizzeria:server:pay:receipt', data.Price, data.Note, data.Id)
end)

RegisterNUICallback('CloseNui', function()
	SetNuiFocus(false, false)
end)

RegisterNetEvent('prp-pizzeria:client:bakingpizza')
AddEventHandler('prp-pizzeria:client:bakingpizza', function()
	ProjectRP.Functions.TriggerCallback('prp-pizza:server:get:ingredient', function(HasItems)  
	if HasItems then
	TriggerEvent('prp-inventory:client:busy:status', true)
	TriggerEvent('prp-sound:client:play', 'Meat', 0.5)
	ProjectRP.Functions.Progressbar("pickup_sla", "Making Pizza...", 3500, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bbq@male@base",
		anim = "base",
		flags = 9,
	}, {
		model = "prop_fish_slice_01",
        bone = 28422,
        coords = { x = -0.00, y = 0.00, z = 0.00 },
        rotation = { x = 0.0, y = 0.0, z = 0.0 },
	}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
		TriggerEvent('prp-inventory:client:busy:status', false)
		TriggerServerEvent('prp-pizzeria:server:rem:stuff', "pizzameat")
		TriggerServerEvent('prp-pizzeria:server:rem:stuff', "vegetables")
		TriggerServerEvent('prp-pizzeria:server:add:stuff', "pizza")
		TriggerEvent('prp-inventory:client:ItemBox', ProjectRP.Shared.Items['pizzameat'], 'remove')
		TriggerEvent('prp-inventory:client:ItemBox', ProjectRP.Shared.Items['vegetables'], 'remove')
		TriggerEvent('prp-inventory:client:ItemBox', ProjectRP.Shared.Items['pizza'], 'add')
		end, function()
			TriggerEvent('prp-inventory:client:busy:status', false)
			ProjectRP.Functions.Notify("Cancelled.", "error")
		end)
    else
		ProjectRP.Functions.Notify("You don't have all the ingredients yet!", "error")
        end
	end)
end)	

RegisterNetEvent('prp-pizzeria:client:cutvegetables')
AddEventHandler('prp-pizzeria:client:cutvegetables', function()
	TriggerEvent('prp-sound:client:play', 'Pizzameat', 0.7)
	ProjectRP.Functions.Progressbar("pickup_sla", "Cutting Vegetables...", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bbq@male@base",
		anim = "base",
		flags = 10,
	}, {
		model = "prop_knife",
        bone = 28422,
        coords = { x = -0.00, y = -0.10, z = 0.00 },
        rotation = { x = 175.0, y = 160.0, z = 0.0 },
	}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
		TriggerServerEvent('prp-pizzeria:server:add:stuff', 'vegetables')
		TriggerEvent('prp-inventory:client:ItemBox', ProjectRP.Shared.Items['vegetables'], 'add')
		InProcess = false
	end, function()
		ProjectRP.Functions.Notify("Cancelled.", "error")
		InProcess = false
	end)
end)


RegisterNetEvent('prp-pizzeria:client:togo')
AddEventHandler('prp-pizzeria:client:togo', function()
	ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
		if HasItem then
			TriggerEvent('prp-inventory:client:ItemBox', ProjectRP.Shared.Items['pizza'], 'remove')
			TriggerServerEvent('prp-pizzeria:server:remove:pack')
			ProjectRP.Functions.Progressbar("pickup_sla", "Packing pizza...", 4100, false, true, {
				disableMovement = true,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
			}, {
				animDict = "amb@prop_human_bum_bin@idle_b",
				anim = "idle_d",
				flags = 10,
			}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
			end, function()
				ProjectRP.Functions.Notify("Cancelled.", "error")
				InProcess = false
			end)
			Citizen.Wait(4100)
			TriggerServerEvent('prp-pizzeria:server:add:box')
        else
            ProjectRP.Functions.Notify("You don't have a pizza!", "error")
        end	
	end, 'pizza')	
end)


Citizen.CreateThread(function()
    while true do
        inRange = false
		if isLoggedIn then
			if (PlayerJob ~= nil) and PlayerJob.name == "pizza" then
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local Bosje = GetDistanceBetweenCoords(pos, Config.Boss["Menu"]["x"], Config.Boss["Menu"]["y"], Config.Boss["Menu"]["z"])
				if Bosje < 3 then
					inRange = true
					ProjectRP.Functions.DrawText3D(Config.Boss["Menu"]["x"], Config.Boss["Menu"]["y"], Config.Boss["Menu"]["z"], 'Boss')
					if Bosje < 1.5 then
						if IsControlJustReleased(0, Keys["E"]) then
							TriggerServerEvent('prp-bossmenu:server:openMenu')
						end
					end
				end
			end
		end

        if not inRange then
            Citizen.Wait(3000)
        end

        Citizen.Wait(3)
    end
end)


RegisterNetEvent('prp-pizzeria:client:drinks')
AddEventHandler('prp-pizzeria:client:drinks', function()
    local ShopItems = {}
    ShopItems.label = "Drinks Machine"
    ShopItems.items = Config.drinks
    ShopItems.slots = #Config.drinks
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Drankjes_"..math.random(1, 99), ShopItems)
end)


RegisterNetEvent('prp-pizzeria:client:takemeat')
AddEventHandler('prp-pizzeria:client:takemeat', function()
	TriggerEvent('prp-sound:client:play', 'fridge', 0.5)
	ProjectRP.Functions.Progressbar("pickup_sla", "Grabbing meat...", 4100, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bum_bin@idle_b",
		anim = "idle_d",
		flags = 10,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
		TriggerServerEvent('prp-pizzeria:server:add:stuff', "pizzameat")
		TriggerEvent('prp-inventory:client:ItemBox', ProjectRP.Shared.Items['pizzameat'], 'add')
	end, function()
		ProjectRP.Functions.Notify("Cancelled.", "error")
		InProcess = false
	end)
end)



---Vehicle
function Pizzascooter()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local Area = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, true)
    if Area < 4.0 then
        return true
    end
end

RegisterNetEvent('prp-pizzeria:client:enter')
AddEventHandler('prp-pizzeria:client:enter', function(House)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
	local Area = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, true)
    if Area < 4.0 then
        ProjectRP.Functions.TriggerCallback('prp-pizzeria:server:HasMoney', function(HasMoney)
            if HasMoney then
				local coords2 = Config.Locations["vehicle"].coords
                ProjectRP.Functions.SpawnVehicle("pizzascoot", function(veh)
                    SetVehicleNumberPlateText(veh, "piz"..tostring(math.random(1000, 9999)))
                    SetEntityHeading(veh, coords2.h)
                    exports['prp-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    SetEntityAsMissionEntity(veh, true, true)
                    exports['prp-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
                    SetVehicleEngineOn(veh, true, true)
                    ProjectRP.Functions.Notify("You have paid $500 deposit.")
                end, coords2, true)
            else
                ProjectRP.Functions.Notify("You don't have enough money for the deposit.Deposit costs $500,-")
			end	
        end)
    end
end)

function StorePizzascooter()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local Area = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, true)
    if Area < 10.0 then
        return true
    end
end



RegisterNetEvent('prp-pizzeria:client:store')
AddEventHandler('prp-pizzeria:client:store', function(House)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local Area = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, true)
    local InVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
    if Area < 10.0 then
		if InVehicle then
            ProjectRP.Functions.TriggerCallback('prp-pizzeria:server:CheckBail', function(DidBail)
                if DidBail then
                    BringBackCar()
                    ProjectRP.Functions.Notify("You have received $ 500 deposit.")
                else
                    ProjectRP.Functions.Notify("You have no deposit paid about this vehicle.")
				end	
            end)
        end
    end
end)

RegisterNetEvent('prp-pizzeria:client:bossmenu')
AddEventHandler('prp-pizzeria:client:bossmenu', function()
    if (PlayerJob ~= nil) and PlayerJob.name == "pizza" then
		TriggerServerEvent("prp-bossmenu:server:openMenu")
	end	
end)

RegisterNetEvent('prp-pizzeria:client:safe')
AddEventHandler('prp-pizzeria:client:safe', function()
    if (PlayerJob ~= nil) and PlayerJob.name == "pizza" then
		TriggerServerEvent("prp-inventory:server:OpenInventory", "stash", "pizza")
        TriggerEvent("prp-inventory:client:SetCurrentStash", "pizza")
	end	
end)

function BringBackCar()
    local veh = GetVehiclePedIsIn(PlayerPedId())
    DeleteVehicle(veh)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(288.46,-972.12, 29.43)
	SetBlipSprite(blip, 52)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 73)  
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pizza Shop")
    EndTextCommandSetBlipName(blip)
end)
