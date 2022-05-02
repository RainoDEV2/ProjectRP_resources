local means = {
    [1] = 15,
    [2] = 50,
    [3] = 35
}

local function gaussian(mean, variance)
    return math.sqrt(-2 * variance * math.log(math.random())) * math.cos(2 * math.pi * math.random()) + mean
end

local function CalculatePurity(lab)
    local task1 = 33 - (math.abs(Config.Labs[lab].tasks[1].temperature - math.floor(gaussian(means[1], 5))))
    local task2 = 34 - (math.abs(Config.Labs[lab].tasks[2].temperature - math.floor(gaussian(means[2], 5))))
    local task3 = 33 - (math.abs(Config.Labs[lab].tasks[3].temperature - math.floor(gaussian(means[3], 5))))
    local purity = task1 + task2 + task3
    if purity < 34 then -- minimum purity
        purity = 34
    end
    return purity
end

-- UPDATING STOCK
RegisterNetEvent('prp-labs:server:UpdateStock', function(lab, type)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if type == "grab" then
        Config.Labs[lab].ingredients.stock = Config.Labs[lab].ingredients.stock - 1
        local amount = Config.Labs[lab].ingredients.stock
        TriggerClientEvent("prp-labs:client:UpdateStock", -1, lab, amount)
    elseif type == "return" then
        Config.Labs[lab].ingredients.stock = Config.Labs[lab].ingredients.stock + 1
        local amount = Config.Labs[lab].ingredients.stock
        TriggerClientEvent("prp-labs:client:UpdateStock", -1, lab, amount)
    elseif type == "stock" then
        local ingredientsAmount = 0
        local itemName = nil

        if      lab == "methlab"  then itemName = "methylamine"
        elseif  lab == "methlab2" then itemName = "methylamine"
        elseif  lab == "weedlab"  then itemName = "weed_nutrition"
        elseif  lab == "cokelab"  then itemName = "ecgonine"     end

        if Player.Functions.GetItemByName(itemName) then
            ingredientsAmount = Player.Functions.GetItemByName(itemName).amount
            Player.Functions.RemoveItem(itemName,ingredientsAmount)
            TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[itemName], "remove")
            TriggerClientEvent('ProjectRP:Notify', source, "You've added "..ingredientsAmount.."x "..itemName.." to the stock", "success")

            Config.Labs[lab].ingredients.stock = Config.Labs[lab].ingredients.stock + ingredientsAmount
            local amount = Config.Labs[lab].ingredients.stock
            TriggerClientEvent("prp-labs:client:UpdateStock", -1, lab, amount)
        else
            TriggerClientEvent('ProjectRP:Notify', source, "You don't have anything useful on you", "error", 2000)
        end
    end
end)

-- STOCK BUSY STATE
RegisterNetEvent('prp-labs:server:UpdateIngredients', function(lab, bool)
    Config.Labs[lab].ingredients.busy = bool
    TriggerClientEvent("prp-labs:client:UpdateIngredients", -1, lab, bool)
end)

-- TASK EVENTS
RegisterNetEvent('prp-labs:server:UpdateTasks', function(lab, task, bool)
    Config.Labs[lab].tasks[task].busy = bool
    TriggerClientEvent("prp-labs:client:UpdateTasks", -1, lab, task, bool)
end)

RegisterNetEvent('prp-labs:server:SetTemperature', function(lab, task, temp)
    Config.Labs[lab].tasks[task].temperature = temp
    TriggerClientEvent('prp-labs:client:SetTemperature', -1, lab, task, temp)
end)

RegisterNetEvent('prp-labs:server:StartMachine', function(data)
    local src = source
    if Config.Labs[data.lab].tasks[data.task].ingredients.current == Config.Labs[data.lab].tasks[data.task].ingredients.needed then
        Config.Labs[data.lab].tasks[data.task].started = true
        TriggerClientEvent("prp-labs:client:SetTaskStarted", -1, data.lab, data.task, true)
        print("^3[prp-labs] ^5"..data.lab..": Started Task "..data.task.."^7")
        TriggerClientEvent('ProjectRP:Notify', src, "You started the machine!", "success", 4000)
        CreateThread(function()
            Wait(Config.Labs[data.lab].tasks[data.task].duration*1000)
            Config.Labs[data.lab].tasks[data.task].completed = true
            print("^3[prp-labs] ^5"..data.lab..": Completed Task "..data.task.."^7")
            TriggerClientEvent('prp-labs:client:SetTaskCompleted', -1, data.lab, data.task, true)
        end)
    else
        TriggerClientEvent('ProjectRP:Notify', src, "This machine does not run on hopes and dreams!", "error", 4000)
    end
end)

RegisterNetEvent('prp-labs:server:AddIngredients', function(lab, task)
    Config.Labs[lab].tasks[task].ingredients.current = Config.Labs[lab].tasks[task].ingredients.current + 1
    local amount = Config.Labs[lab].tasks[task].ingredients.current
    TriggerClientEvent("prp-labs:client:AddIngredients", -1, lab, task, amount)
end)

RegisterNetEvent('prp-labs:server:SetTaskStarted', function(lab, task, bool)
    Config.Labs[lab].tasks[task].started = bool
    TriggerClientEvent("prp-labs:client:SetTaskStarted", -1, lab, task, bool)
end)

RegisterNetEvent('prp-labs:server:SetTaskCompleted', function(lab, task, bool)
    Config.Labs[lab].tasks[task].completed = bool
    TriggerClientEvent("prp-labs:client:SetTaskCompleted", -1, lab, task, bool)
end)

RegisterNetEvent('prp-labs:server:FinishLab', function(lab)
    -- RETURN IF LAST STEP NOT COMPLETED
    if not Config.Labs[lab].tasks[3].completed then return end
    -- ADD BATCH
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local pure = CalculatePurity(lab)
    print("^3[prp-labs] ^5"..lab..": "..GetPlayerName(source).." finished a batch, purity: "..pure.."^7")
    local info = {
        purity = pure
    }
    TriggerEvent("prp-log:server:CreateLog", 'keylabs', lab, "white", "**"..Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *(" .. Player.PlayerData.source .. "))*: has received a "..Config.Labs[lab].curing.batchItem.." with purity: "..pure)  
    Player.Functions.AddItem(Config.Labs[lab].curing.batchItem, 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[Config.Labs[lab].curing.batchItem], "add")
    -- SET FINISHED
    for k, v in pairs(Config.Labs[lab].tasks) do
        v.busy = false
        v.completed = false
        v.started = false
        v.ingredients.current = 0
        v.timeremaining = v.duration
        v.temperature = 80
    end
    TriggerClientEvent("prp-labs:client:FinishLab", -1, lab)
end)

-- CURING EVENTS
RegisterNetEvent('prp-labs:server:CureBusyState', function(lab, state)
    Config.Labs[lab].curing.busy = state
    TriggerClientEvent('prp-labs:client:CureBusyState', -1, lab, state)
end)

RegisterNetEvent('prp-labs:server:AddCureBatch', function(lab)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName(Config.Labs[lab].curing.batchItem)
    if item then
        local purity = item.info.purity
        -- TAKE BATCH
        Player.Functions.RemoveItem(item.name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[item.name], "remove")
        -- SET PURITY
        Config.Labs[lab].curing.purity = purity
        TriggerClientEvent('prp-labs:client:SetPurity', -1, lab, purity)
    else
        TriggerClientEvent('ProjectRP:Notify', src, "You don't have anything to be "..Locales[lab].cureBatchType, "error", 2500)
    end
end)

RegisterNetEvent('prp-labs:server:StartCuring', function(data)
    Config.Labs[data.lab].curing.started = true
    TriggerClientEvent('prp-labs:client:CureStartedState', -1, data.lab, true)
    CreateThread(function()
        while Config.Labs[data.lab].curing.timeremaining > 0 do
            Wait(1000)
            Config.Labs[data.lab].curing.timeremaining = Config.Labs[data.lab].curing.timeremaining - 1
        end
        print("^3[prp-labs] ^5"..data.lab..": Finished curing.^7")
        Config.Labs[data.lab].curing.completed = true
        Config.Labs[data.lab].curing.started = false
        TriggerClientEvent('prp-labs:client:CureCompletedState', -1, data.lab, true)
        TriggerClientEvent('prp-labs:client:CureStartedState', -1, data.lab, false)
    end)
end)

RegisterNetEvent('prp-labs:server:TakeCureBatch', function(lab)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    -- GIVE CURED BATCH
    local info = {
        purity = Config.Labs[lab].curing.purity
    }
    print("^3[prp-labs] ^5"..lab..": "..GetPlayerName(src).." took cured batch, purity: "..Config.Labs[lab].curing.purity.."^7")
    TriggerEvent("prp-log:server:CreateLog", 'keylabs', lab, "green", "**"..Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *(" .. Player.PlayerData.source .. "))*: has received a "..Config.Labs[lab].curing.curedItem.." with purity: "..Config.Labs[lab].curing.purity)  
    Player.Functions.AddItem(Config.Labs[lab].curing.curedItem, 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[Config.Labs[lab].curing.curedItem], "add")
    -- SET NOT COMPLETED AFTER DONE
    Config.Labs[lab].curing.timeremaining = Config.Labs[lab].curing.duration
    Config.Labs[lab].curing.completed = false
    TriggerClientEvent('prp-labs:client:CureCompletedState', -1, lab, false)
    Config.Labs[lab].curing.purity = nil
    TriggerClientEvent('prp-labs:client:SetPurity', -1, lab, nil)
end)