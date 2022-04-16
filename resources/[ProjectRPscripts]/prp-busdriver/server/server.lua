local ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-busdriver:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = math.random(Config.MinPayout, Config.MaxPayout)
	xPlayer.Functions.AddMoney("cash", money,"Bus Driver Payout")
    cb(money)
end)
