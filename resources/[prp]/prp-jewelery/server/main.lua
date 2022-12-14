local timeOut = false

local alarmTriggered = false

RegisterServerEvent('prp-jewellery:server:setVitrineState')
AddEventHandler('prp-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('prp-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('prp-jewellery:server:vitrineReward')
AddEventHandler('prp-jewellery:server:vitrineReward', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'You have to much in your pocket', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("10kgoldchain", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["10kgoldchain"], 'add')
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'You have to much in your pocket..', 'error')
        end
    end
end)

RegisterServerEvent('prp-jewellery:server:setTimeout')
AddEventHandler('prp-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('prp-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('prp-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('prp-jewellery:client:setAlertState', -1, false)
                TriggerEvent('prp-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RegisterServerEvent('prp-jewellery:server:PoliceAlertMessage')
AddEventHandler('prp-jewellery:server:PoliceAlertMessage', function(title, coords, blip)
    local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Possible robbery going on at Vangelico Jewelry Store<br>Available camera's: 31, 32, 33, 34",
    }

    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("prp-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("prp-jewellery:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("prp-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("prp-jewellery:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

ProjectRP.Functions.CreateCallback('prp-jewellery:server:getCops', function(source, cb)
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
