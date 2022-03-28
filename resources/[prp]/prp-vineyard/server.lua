RegisterNetEvent('prp-vineyard:server:getGrapes')
AddEventHandler('prp-vineyard:server:getGrapes', function()
    local Player = ProjectRP.Functions.GetPlayer(source)

    Player.Functions.AddItem("grape", Config.GrapeAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['grape'], "add")
end)

RegisterServerEvent('prp-vineyard:server:loadIngredients') 
AddEventHandler('prp-vineyard:server:loadIngredients', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grapejuice')

	if xPlayer.PlayerData.items ~= nil then 
        if grape ~= nil then 
            if grape.amount >= 23 then 

                xPlayer.Functions.RemoveItem("grapejuice", 23, false)
                TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['grapejuice'], "remove")
                
                TriggerClientEvent("prp-vineyard:client:loadIngredients", source)

            else
                TriggerClientEvent('ProjectRP:Notify', source, "You do not have the correct items", 'error')   
            end
        else
            TriggerClientEvent('ProjectRP:Notify', source, "You do not have the correct items", 'error')   
        end
	else
		TriggerClientEvent('ProjectRP:Notify', source, "You Have Nothing...", "error")
	end 
	
end) 

RegisterServerEvent('prp-vineyard:server:grapeJuice') 
AddEventHandler('prp-vineyard:server:grapeJuice', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grape')

	if xPlayer.PlayerData.items ~= nil then 
        if grape ~= nil then 
            if grape.amount >= 16 then 

                xPlayer.Functions.RemoveItem("grape", 16, false)
                TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['grape'], "remove")
                
                TriggerClientEvent("prp-vineyard:client:grapeJuice", source)

            else
                TriggerClientEvent('ProjectRP:Notify', source, "You do not have the correct items", 'error')   
            end
        else
            TriggerClientEvent('ProjectRP:Notify', source, "You do not have the correct items", 'error')   
        end
	else
		TriggerClientEvent('ProjectRP:Notify', source, "You Have Nothing...", "error")
	end 
	
end) 

RegisterServerEvent('prp-vineyard:server:receiveWine')
AddEventHandler('prp-vineyard:server:receiveWine', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))

	xPlayer.Functions.AddItem("wine", Config.WineAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['wine'], "add")
end)

RegisterServerEvent('prp-vineyard:server:receiveGrapeJuice')
AddEventHandler('prp-vineyard:server:receiveGrapeJuice', function()
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))

	xPlayer.Functions.AddItem("grapejuice", Config.GrapeJuiceAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['grapejuice'], "add")
end)


-- Hire/Fire

--[[ ProjectRP.Commands.Add("hirevineyard", "Hire a player to the Vineyard!", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    local Myself = ProjectRP.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Myself.PlayerData.gang.name == "la_familia") then
            Player.Functions.SetJob("vineyard")
        end
    end
end)

ProjectRP.Commands.Add("firevineyard", "Fire a player to the Vineyard!", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
    local Myself = ProjectRP.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Myself.PlayerData.gang.name == "la_familia") then
            Player.Functions.SetJob("unemployed")
        end
    end
end) ]]
