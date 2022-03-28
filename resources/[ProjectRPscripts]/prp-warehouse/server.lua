local ProjectRP = exports['prp-core']:GetCoreObject()


ProjectRP.Functions.CreateCallback('prp-warehouse:checkMoney', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local name = ProjectRP.Functions.GetPlayer(source)

	if xPlayer.PlayerData.money.cash >= Config.DepositPrice then
        xPlayer.Functions.RemoveMoney('cash', Config.DepositPrice)
		cb(true)
    elseif xPlayer.PlayerData.money.bank >= Config.DepositPrice then
        xPlayer.Functions.RemoveMoney('bank', Config.DepositPrice)
        cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('prp-warehouse:returnVehicle')
AddEventHandler('prp-warehouse:returnVehicle', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	local Payout = Config.DepositPrice
	
	xPlayer.Functions.AddMoney("bank", Config.DepositPrice)
end)

RegisterServerEvent('prp-warehouse:Payout')
AddEventHandler('prp-warehouse:Payout', function(arg)	
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	local Payout = Config.Payout * arg
	
	xPlayer.Functions.AddMoney("cash", Payout)
end)