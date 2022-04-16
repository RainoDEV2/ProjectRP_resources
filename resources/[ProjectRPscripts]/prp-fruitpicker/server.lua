local ProjectRP = exports['prp-core']:GetCoreObject()


ProjectRP.Functions.CreateCallback('prp-fruitpicker:checkMoney', function(source, cb)
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

RegisterServerEvent('prp-fruitpicker:depositBack')
AddEventHandler('prp-fruitpicker:depositBack', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	local Payout = Config.DepositPrice
	
	xPlayer.Functions.AddMoney("bank", Config.DepositPrice,"Fruit Picker Deposit Back")
end)

RegisterServerEvent('prp-fruitpicker:Payout')
AddEventHandler('prp-fruitpicker:Payout', function(arg)	
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	local Payout = Config.Payout * arg
	
	xPlayer.Functions.AddMoney("cash", Payout,"Fruit Picker Payout")
end)