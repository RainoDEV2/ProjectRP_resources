local Bail = {}

local ProjectRP = exports["prp-core"]:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-pizzeria:server:HasMoney', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= Config.BailPrice then
        Bail[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', Config.BailPrice)
        cb(true)
    elseif Player.PlayerData.money.bank >= Config.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('prp-pizzeria:server:add:to:register')
AddEventHandler('prp-pizzeria:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePaymentsPizza[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('prp-pizzeria:client:sync:register', -1, Config.ActivePaymentsPizza)
end)

RegisterServerEvent('prp-pizzeria:server:pay:receipt')
AddEventHandler('prp-pizzeria:server:pay:receipt', function(Price, Note, Id)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Price, 'pizzeria') then
        if Config.ActivePaymentsPizza[tonumber(Id)] ~= nil then
            Config.ActivePaymentsPizza[tonumber(Id)] = nil
            TriggerEvent('prp-pizzeria:give:receipt:to:workers', Note, Price)
            TriggerClientEvent('prp-pizzeria:client:sync:register', -1, Config.ActivePaymentsPizza)
            exports["prp-management"]:AddMoney('pizza', Price)
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'You dont have enough cash..', 'error')
    end
end)

RegisterServerEvent('prp-pizzeria:give:receipt:to:workers')
AddEventHandler('prp-pizzeria:give:receipt:to:workers', function(Note, Price)
    local src = source
    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == 'pizza' and Player.PlayerData.job.onduty then
                local Info = {note = Note, price = Price}
                Player.Functions.AddItem('burger-ticket', 1, false, Info)
                TriggerClientEvent('prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['burger-ticket'], "add")
            end
        end
    end
end)

ProjectRP.Commands.Add("refreshpizza", "Reset Pizzeria props", {}, false, function(source, args)
    TriggerClientEvent('prp-pizzeria:client:refresh:props', -1)
end, "admin")


ProjectRP.Functions.CreateCallback('prp-pizzeria:server:CheckBail', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Config.BailPrice, 'prp-pizzeria:server:CheckBail')
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)


RegisterServerEvent('prp-pizza:server:start:black')
AddEventHandler('prp-pizza:server:start:black', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    TriggerClientEvent('prp-pizza:start:black:job', src)
    Player.Functions.AddItem("pizza-box", 1)
    TriggerClientEvent('prp-prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['pizza-box'], 'add')
end)

ProjectRP.Functions.CreateCallback('prp-pizzeria:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('prp-pizza:server:reward:money')
AddEventHandler('prp-pizza:server:reward:money', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(360, 500), "pizza-shop-reward")
    TriggerClientEvent('ProjectRP:Notify', source, "Pizza delivered! Go back to the Pizza Shop for a new delivery.")
    Player.Functions.RemoveItem('pizza-box', 1)
    TriggerClientEvent('prp-prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['pizza-box'], 'remove')

end)


RegisterServerEvent('prp-pizzeria:server:remove:pack')
AddEventHandler('prp-pizzeria:server:remove:pack', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('pizza', 1)
    end
end)

RegisterServerEvent('prp-pizzeria:server:add:box')
AddEventHandler('prp-pizzeria:server:add:box', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.AddItem('pizza-box', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['pizza-box'], 'add')
    end
end)


RegisterServerEvent('prp-pizzeria:server:get:stuff')
AddEventHandler('prp-pizzeria:server:get:stuff', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.AddItem('pizza-vooraad', 1)
        TriggerClientEvent('prp-prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['pizza-vooraad'], 'add')
    end
end)


RegisterServerEvent('prp-pizzeria:server:rem:pizza')
AddEventHandler('prp-pizzeria:server:rem:pizza', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('pizza', 1)
        TriggerClientEvent('prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['pizza'], 'remove')
    end
end)

RegisterServerEvent('prp-pizzeria:server:rem:pizzabox')
AddEventHandler('prp-pizzeria:server:rem:pizzabox', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('pizza', 1)
        TriggerClientEvent('prp-prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['pizza'], 'add')
    end
end)

RegisterServerEvent('prp-pizzeria:server:rem:stuff')
AddEventHandler('prp-pizzeria:server:rem:stuff', function(what)
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    -- if Player ~= nil then
    if Player ~= nil and what == "pizzameat" or what == "vegetables" or what == "pizza-vooraad" or what == "pizza" then
        Player.Functions.RemoveItem(what, 1)
        TriggerClientEvent('prp-prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['what'], 'add')
    end
end)

RegisterServerEvent('prp-pizzeria:server:add:stuff')
AddEventHandler('prp-pizzeria:server:add:stuff', function(what)
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player ~= nil and what == "pizzameat" or what == "vegetables" or what == "pizza-vooraad" or what == "pizza" then
        Player.Functions.AddItem(what, 1)
        TriggerClientEvent('prp-prp-inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['what'], 'add')
    end
end)

ProjectRP.Functions.CreateCallback('prp-pizza:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = ProjectRP.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("vegetables")
    local meat = Ply.Functions.GetItemByName("pizzameat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

ProjectRP.Functions.CreateCallback('prp-pizza:server:get:pizzas', function(source, cb)
    local src = source
    local Ply = ProjectRP.Functions.GetPlayer(src)
    local pizza = Ply.Functions.GetItemByName('pizza')
    if pizza ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

ProjectRP.Functions.CreateUseableItem("pizza-box", function(source, item)
	local xPlayer = ProjectRP.Functions.GetPlayer(source)
	TriggerClientEvent("prp-inventory:client:ItemBox", source, ProjectRP.Shared.Items['pizza-box'], "remove")
	xPlayer.Functions.RemoveItem("pizza-box", 1)
	TriggerClientEvent("prp-inventory:client:ItemBox", source, ProjectRP.Shared.Items['pizza'], "add")
    xPlayer.Functions.AddItem('pizza', 1) 
end)
