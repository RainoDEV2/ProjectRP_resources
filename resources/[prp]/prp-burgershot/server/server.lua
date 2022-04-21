local ProjectRP = exports['prp-core']:GetCoreObject()

-- Code

ProjectRP.Commands.Add("refreshburgerprops", "Reset burgershot props", {}, false, function(source, args)
    TriggerClientEvent('prp-burgershot:client:refresh:props', -1)
end, "admin")

ProjectRP.Functions.CreateCallback('prp-burgershot:server:hasBurgerItems', function(source, cb)
    local src = source
    local count = 0
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        local BurgerData = Player.Functions.GetItemByName(v)
        if BurgerData ~= nil then
            count = count + 1
        end
    end
    if count == 3 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('prp-burgershot:server:finish:burgerbleeder')
AddEventHandler('prp-burgershot:server:finish:burgerbleeder', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items[v], "remove")
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem('burger-bleeder', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-bleeder'], "add")
    end)
end)

RegisterServerEvent('prp-burgershot:server:finish:burger-heartstopper')
AddEventHandler('prp-burgershot:server:finish:burger-heartstopper', function(BurgerName)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items[v], "remove")
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem('burger-heartstopper', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-heartstopper'], "add")
    end)
end)

RegisterServerEvent('prp-burgershot:server:finish:burger-moneyshot')
AddEventHandler('prp-burgershot:server:finish:burger-moneyshot', function(BurgerName)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items[v], "remove")
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem('burger-moneyshot', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-moneyshot'], "add")
    end)
end)

RegisterServerEvent('prp-burgershot:server:finish:burger-torpedo')
AddEventHandler('prp-burgershot:server:finish:burger-torpedo', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items[v], "remove")
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem('burger-torpedo', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-torpedo'], "add")
    end)
end)

RegisterServerEvent('prp-burgershot:server:finish:fries')
AddEventHandler('prp-burgershot:server:finish:fries', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-potato', 1) then
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-potato'], "remove")
        Player.Functions.AddItem('burger-fries', math.random(3, 5))
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-fries'], "add")
    end
end)

RegisterServerEvent('prp-burgershot:server:finish:patty1')
AddEventHandler('prp-burgershot:server:finish:patty1', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('huntingcarcass1', 1) then
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['huntingcarcass1'], "remove")
        Player.Functions.AddItem('burger-meat', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-meat'], "add")
    end
end)

RegisterServerEvent('prp-burgershot:server:finish:patty2')
AddEventHandler('prp-burgershot:server:finish:patty2', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('huntingcarcass2', 1) then
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['huntingcarcass2'], "remove")
        Player.Functions.AddItem('burger-meat', math.random(2, 3))
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-meat'], "add")
    end
end)

RegisterServerEvent('prp-burgershot:server:finish:patty3')
AddEventHandler('prp-burgershot:server:finish:patty3', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('huntingcarcass3', 1) then
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['huntingcarcass3'], "remove")
        Player.Functions.AddItem('burger-meat', math.random(3, 5))
        TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-meat'], "add")
    end
end)

RegisterServerEvent('prp-burgershot:server:finish:drinksoda')
AddEventHandler('prp-burgershot:server:finish:drinksoda', function(DrinkName)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    Player.Functions.AddItem('burger-softdrink', 1)
    TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-softdrink'], "add")
end)

RegisterServerEvent('prp-burgershot:server:finish:drinkcoffee')
AddEventHandler('prp-burgershot:server:finish:drinkcoffee', function(DrinkName)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    Player.Functions.AddItem('burger-coffee', 1)
    TriggerClientEvent('prp-inventory:client:ItemBox', src, ProjectRP.Shared.Items['burger-coffee'], "add")
end)

RegisterServerEvent('prp-burgershot:server:add:to:register')
AddEventHandler('prp-burgershot:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePayments[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('prp-burgershot:client:sync:register', -1, Config.ActivePayments)
end)

RegisterServerEvent('prp-burgershot:server:pay:receipt')
AddEventHandler('prp-burgershot:server:pay:receipt', function(Price, Note, Id)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Price, 'burger-shot') then
        if Config.ActivePayments[tonumber(Id)] ~= nil then
            Config.ActivePayments[tonumber(Id)] = nil
            TriggerEvent('prp-burgershot:give:receipt:to:workers', Note, Price)
            TriggerEvent('prp-bossmenu:server:addAccountMoney', 'burger', Price)
            TriggerClientEvent('prp-burgershot:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'You dont have enough cash..', 'error')
    end
end)

RegisterServerEvent('prp-burgershot:give:receipt:to:workers')
AddEventHandler('prp-burgershot:give:receipt:to:workers', function(Note, Price)
    local src = source
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == 'burger' and Player.PlayerData.job.onduty then
                local Info = {note = Note, price = Price}
                Player.Functions.AddItem('burger-ticket', 1, false, Info)
                TriggerClientEvent('prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['burger-ticket'], "add")
            end
        end
    end
end)

RegisterServerEvent('prp-burgershot:server:sell:tickets')
AddEventHandler('prp-burgershot:server:sell:tickets', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.items) do
        if v.name == 'burger-ticket' then
            for i = 1, v.amount do
                Player.Functions.RemoveItem('burger-ticket', 1)
                Player.Functions.AddMoney('cash', math.random(54, 109), 'burgershot-payment')
                -- TriggerEvent('prp-bossmenu:server:addAccountMoney', 'burger', math.random(60, 150))
                Citizen.Wait(1000)
            end
        end
    end
    TriggerClientEvent('prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['burger-ticket'], "remove")
end)