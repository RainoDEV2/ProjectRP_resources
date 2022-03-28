local ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-tastyeats:getexperience', function(source, cb, xPlayer)
    local PlayerData = ProjectRP.Functions.GetPlayer(source)

    local result = exports.oxmysql:executeSync('SELECT * FROM inside_jobs WHERE identifier=@identifier AND job=@job', {['@identifier'] = PlayerData.PlayerData.citizenid, ['@job'] = 'tastyeats'})
    if result[1] ~= nil then
        cb(tonumber(result[1].experience)) 
    else
        exports.oxmysql:execute('INSERT INTO inside_jobs (identifier, experience, job) VALUES (@identifier, @experience, @job)', {
            ['@identifier'] = PlayerData.PlayerData.citizenid,
            ['@experience'] = 0,
            ['@job'] = 'tastyeats'
        })
    end
end)

ProjectRP.Functions.CreateCallback('prp-tastyeats:checkMoney', function(source, cb)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)

	if xPlayer.PlayerData.money.cash >= icfg.DepositForVehiclePrice then
        xPlayer.Functions.RemoveMoney('cash', icfg.DepositForVehiclePrice)
		cb(true)
    elseif xPlayer.PlayerData.money.bank >= icfg.DepositForVehiclePrice then
        xPlayer.Functions.RemoveMoney('bank', icfg.DepositForVehiclePrice)
        cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('prp-tastyeats:returnVehicle')
AddEventHandler('prp-tastyeats:returnVehicle', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	
	xPlayer.Functions.AddMoney("bank", icfg.DepositForVehiclePrice)
end)

ProjectRP.Functions.CreateCallback('prp-tastyeats:Payout', function(source, cb, xPlayer, level)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
    local money = nil
    
    local result = exports.oxmysql:executeSync('SELECT * FROM inside_jobs WHERE identifier=@identifier AND job=@job', {['@identifier'] = xPlayer.PlayerData.citizenid, ['@job'] = 'tastyeats'})
    if result[1] ~= nil then
        if result[1].experience >= icfg.Levels.Level5.MinPoints then
            money = math.random(icfg.Levels.Level5.PayoutMin, icfg.Levels.Level5.PayoutMax)
        elseif result[1].experience >= icfg.Levels.Level4.MinPoints and result[1].experience <= icfg.Levels.Level4.MaxPoints then
            money = math.random(icfg.Levels.Level4.PayoutMin, icfg.Levels.Level4.PayoutMax)
        elseif result[1].experience >= icfg.Levels.Level3.MinPoints and result[1].experience <= icfg.Levels.Level3.MaxPoints then
            money = math.random(icfg.Levels.Level3.PayoutMin, icfg.Levels.Level3.PayoutMax)
        elseif result[1].experience >= icfg.Levels.Level2.MinPoints and result[1].experience <= icfg.Levels.Level2.MaxPoints then
            money = math.random(icfg.Levels.Level2.PayoutMin, icfg.Levels.Level2.PayoutMax)
        elseif result[1].experience >= icfg.Levels.Level1.MinPoints and result[1].experience <= icfg.Levels.Level1.MaxPoints then
            money = math.random(icfg.Levels.Level1.PayoutMin, icfg.Levels.Level1.PayoutMax)
        end
        xPlayer.Functions.AddMoney("cash", money)
        cb(money) 
        playerexp = result[1].experience + 1  
        exports.oxmysql:execute('UPDATE inside_jobs SET experience=@playerexp WHERE identifier=@identifier AND job=@job', {
            ['@identifier'] = xPlayer.PlayerData.citizenid,
            ['@playerexp'] = playerexp, 
            ['@job'] = 'tastyeats',
        })
    end
end)

RegisterServerEvent('prp-tastyeats:SynchroHookiesFood')
AddEventHandler('prp-tastyeats:SynchroHookiesFood', function()
    TriggerClientEvent('prp-tastyeats:GetHookiesFood', -1)
end)

RegisterServerEvent('prp-tastyeats:SynchroTacoBombFood')
AddEventHandler('prp-tastyeats:SynchroTacoBombFood', function()
    TriggerClientEvent('prp-tastyeats:GetTacoBombFood', -1)
end)

RegisterServerEvent('prp-tastyeats:SynchroCluckinBellFood')
AddEventHandler('prp-tastyeats:SynchroCluckinBellFood', function()
    TriggerClientEvent('prp-tastyeats:GetCluckinBellFood', -1)
end)

RegisterServerEvent('prp-tastyeats:SynchroPizzaThisFood')
AddEventHandler('prp-tastyeats:SynchroPizzaThisFood', function()
    TriggerClientEvent('prp-tastyeats:GetPizzaThisFood', -1)
end)

RegisterServerEvent('prp-tastyeats:SynchroBurgerShotFood')
AddEventHandler('prp-tastyeats:SynchroBurgerShotFood', function()
    TriggerClientEvent('prp-tastyeats:GetBurgerShotFood', -1)
end)