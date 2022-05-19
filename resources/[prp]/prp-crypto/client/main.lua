-- Variables
local ProjectRP = exports['prp-core']:GetCoreObject()
local requiredItemsShowed = false
local requiredItems = {[1] = {name = ProjectRP.Shared.Items["cryptostick"]["name"], image = ProjectRP.Shared.Items["cryptostick"]["image"]}}

-- Functions

local function DrawText3Ds(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function ExchangeSuccess()
	TriggerServerEvent('prp-crypto:server:ExchangeSuccess', math.random(1, 20))
end

local function ExchangeFail()
	local RemoveChance = math.random(1, 2)
	if RemoveChance == 1 then
		TriggerServerEvent('prp-crypto:server:ExchangeFail')
		TriggerServerEvent('prp-crypto:server:SyncReboot')
		local pCoords = GetEntityCoords(PlayerPedId())
		local description = "A secure server alarm has been triggered inside Weasel News"
		TriggerServerEvent('cd_dispatch:AddNotification', {
			job_table = {'police'},
			coords = pCoords,
			title = '10-31 - Secure Server Alarm',
			message = description,
			flash = 0,
			unique_id = tostring(math.random(0000000,9999999)),
			blip = {
				sprite = 459,
				scale = 1,
				colour = 3,
				flashes = false,
				text = 'Secure Server Alarm',
				time = (5*60*1000),
				sound = 1,
			}
		})
	end
end

local function SystemCrashCooldown()
	CreateThread(function()
		while Crypto.Exchange.RebootInfo.state do
			if (Crypto.Exchange.RebootInfo.percentage + 1) <= 100 then
				Crypto.Exchange.RebootInfo.percentage = Crypto.Exchange.RebootInfo.percentage + 1
				TriggerServerEvent('prp-crypto:server:Rebooting', true, Crypto.Exchange.RebootInfo.percentage)
			else
				Crypto.Exchange.RebootInfo.percentage = 0
				Crypto.Exchange.RebootInfo.state = false
				TriggerServerEvent('prp-crypto:server:Rebooting', false, 0)
			end
			Wait(1200)
		end
	end)
end

local function HackingSuccess(success)
    if success then
		TriggerEvent('mhacking:hide')
        ExchangeSuccess()
    else
		TriggerEvent('mhacking:hide')
		ExchangeFail()
	end
end

CreateThread(function()
	while true do
		local sleep = 5000
		if LocalPlayer.state.isLoggedIn then
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local dist = #(pos - Crypto.Exchange.coords)
			if dist < 15 then
				sleep = 5
				if dist < 1.5 then
					if not Crypto.Exchange.RebootInfo.state then
						DrawText3Ds(Crypto.Exchange.coords, '~g~E~w~ - Enter USB')
						if not requiredItemsShowed then
							requiredItemsShowed = true
							TriggerEvent('inventory:client:requiredItems', requiredItems, true)
						end

						if IsControlJustPressed(0, 38) then
							ProjectRP.Functions.TriggerCallback('prp-crypto:server:HasSticky', function(HasItem)
								if HasItem then
									TriggerEvent("mhacking:show")
									TriggerEvent("mhacking:start", math.random(4, 6), 22, HackingSuccess)
								else
									ProjectRP.Functions.Notify('You have no Cryptostick', 'error')
								end
							end)
						end
					else
						DrawText3Ds(Crypto.Exchange.coords, 'System is rebooting - '..Crypto.Exchange.RebootInfo.percentage..'%')
					end
				else
					if requiredItemsShowed then
						requiredItemsShowed = false
						TriggerEvent('inventory:client:requiredItems', requiredItems, false)
					end
				end
			end
		end
		Wait(sleep)
	end
end)

-- Events

RegisterNetEvent('prp-crypto:client:SyncReboot', function()
	Crypto.Exchange.RebootInfo.state = true
	SystemCrashCooldown()
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
	TriggerServerEvent('prp-crypto:server:FetchWorth')
	TriggerServerEvent('prp-crypto:server:GetRebootState')
end)

RegisterNetEvent('prp-crypto:client:UpdateCryptoWorth', function(crypto, amount, history)
	Crypto.Worth[crypto] = amount
	if history ~= nil then
		Crypto.History[crypto] = history
	end
end)

RegisterNetEvent('prp-crypto:client:GetRebootState', function(RebootInfo)
	if RebootInfo.state then
		Crypto.Exchange.RebootInfo.state = RebootInfo.state
		Crypto.Exchange.RebootInfo.percentage = RebootInfo.percentage
		SystemCrashCooldown()
	end
end)