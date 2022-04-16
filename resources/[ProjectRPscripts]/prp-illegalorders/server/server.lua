local ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-illegalordersType1:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForFirstOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegalordersType2:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForSecondOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegalordersType3:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForThirdOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegalordersType4:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForFourthOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegalordersType5:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForFifthOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegalordersType6:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForSixthOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

ProjectRP.Functions.CreateCallback('prp-illegalordersType7:payout', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = Config.PayoutForSeventhOrder
	xPlayer.Functions.AddMoney("cash", money,"Illegal Orders Payout")
    cb(money)
end)

AddEventHandler('playerDropped', function()
    TriggerClientEvent('prp-illegalorders:removecars', source)
end)



ProjectRP.Functions.CreateCallback('prp-illegalorders:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)