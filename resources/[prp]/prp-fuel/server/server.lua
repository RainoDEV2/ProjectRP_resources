-- Variables

local ProjectRP = exports['prp-core']:GetCoreObject()

-- Functions

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

-- Server Events

RegisterNetEvent("prp-fuel:server:OpenMenu", function (amount, inGasStation)
	local src = source
	if not src then return end
	local player = ProjectRP.Functions.GetPlayer(src)
	if not player then return end
	local tax = GlobalTax(amount)
	local total = math.ceil(amount + tax)
	if inGasStation == true then
		TriggerClientEvent('prp-menu:client:openMenu', src, {
			{
				header = 'Gas Station',
				txt = 'The total cost is going to be: $'..total..' including taxes.' ,
				params = {
					event = "prp-fuel:client:RefuelVehicle",
					args = total,
				}
			},
		})
	end
		if inGasStation == false then
			TriggerClientEvent('prp-menu:client:openMenu', src, {
				{
					header = 'Gas Station',
					txt = 'The total cost is going to be: $'..total..' including taxes.' ,
					params = {
					event = "prp-fuel:client:RefuelVehicle",
					args = total,
				}
			},
		})
	end
end)

RegisterNetEvent("prp-fuel:server:PayForFuel", function (amount)
	local src = source
	if not src then return end
	local player = ProjectRP.Functions.GetPlayer(src)
	if not player then return end
	player.Functions.RemoveMoney('cash', amount)
end)
