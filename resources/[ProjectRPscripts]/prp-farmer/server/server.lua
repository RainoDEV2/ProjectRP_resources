local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterServerEvent('prp-farmer:payout')
AddEventHandler('prp-farmer:payout', function(AmountPayoutC, AmountPayoutL, AmountPayoutP)	
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	local Payout = Config.PayoutC * AmountPayoutC
	Payout = Payout + Config.PayoutL *  AmountPayoutL
	Payout = Payout + Config.PayoutP *  AmountPayoutP
	xPlayer.Functions.AddMoney("cash", Payout,"Farmer Payout")
	Payout = 0
end)
