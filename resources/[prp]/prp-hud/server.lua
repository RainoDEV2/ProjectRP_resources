local ProjectRP = exports['prp-core']:GetCoreObject()
local ResetStress = false

ProjectRP.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local cashamount = Player.PlayerData.money.cash
    TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
end)

ProjectRP.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local bankamount = Player.PlayerData.money.bank
    TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)

ProjectRP.Commands.Add("dev", "Enable/Disable developer Mode", {}, false, function(source, args)
    TriggerClientEvent("prp-admin:client:ToggleDevmode", source)
end, 'admin')

RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local newStress
    if not Player or (Config.DisablePoliceStress and Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance') then return end
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] + amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    -- TriggerClientEvent('ProjectRP:Notify', src, 'Getting Stressed', 'error', 1500)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local newStress
    if not Player then return end
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] - amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    TriggerClientEvent('ProjectRP:Notify', src, 'You Are Relaxing')
end)

ProjectRP.Functions.CreateCallback('hud:server:HasHarness', function(source, cb)
    local Ply = ProjectRP.Functions.GetPlayer(source)
    local Harness = Ply.Functions.GetItemByName("harness")
    if Harness ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
ProjectRP.Functions.CreateCallback('hud:server:getMenu', function(source, cb)
    cb(Config.Menu)
end) 
