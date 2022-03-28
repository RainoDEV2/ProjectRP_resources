local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterServerEvent('prp-methcar:start')
AddEventHandler('prp-methcar:start', function()
	local _source = source
	local Player = ProjectRP.Functions.GetPlayer(source)
	local ItemAcetone = Player.Functions.GetItemByName("acetone")
    local ItemLithium = Player.Functions.GetItemByName("lithium")
	local ItemMethlab = Player.Functions.GetItemByName("methlab")
	if ItemAcetone ~= nil and ItemLithium ~= nil and ItemMethlab ~= nil then
		if ItemAcetone.amount >= 5 and ItemLithium.amount >= 2 and ItemMethlab.amount >= 1 then	
			TriggerClientEvent("prp-methcar:startprod", _source)
			Player.Functions.RemoveItem("acetone", 5, false)
			Player.Functions.RemoveItem("lithium", 2, false)
		else
		TriggerClientEvent('ProjectRP:Notify', source, "U don't have enough ingredients to cook!", 'error')
		end	
	else
	TriggerClientEvent('ProjectRP:Notify', source, "You're missing essential ingredients!", 'error')
	end	
end)

RegisterServerEvent('prp-methcar:stopf')
AddEventHandler('prp-methcar:stopf', function(id)
local _source = source
	local xPlayers = ProjectRP.Functions.GetPlayers()
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('prp-methcar:stopfreeze', xPlayers[i], id)
	end	
end)

RegisterServerEvent('prp-methcar:make')
AddEventHandler('prp-methcar:make', function(posx,posy,posz)
	local _source = source
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))
	if xPlayer.Functions.GetItemByName('methlab') ~= nil then
		if xPlayer.Functions.GetItemByName('methlab').amount >= 1 then	
			local xPlayers = ProjectRP.Functions.GetPlayers()
			for i=1, #xPlayers, 1 do
				TriggerClientEvent('prp-methcar:smoke',xPlayers[i],posx,posy,posz, 'a') 
			end		
		else
			TriggerClientEvent('prp-methcar:stop', _source)
		end
	else
	TriggerClientEvent('ProjectRP:Notify', source, "You're missing a lab!", 'error')
	end	
end)

RegisterServerEvent('prp-methcar:finish')
AddEventHandler('prp-methcar:finish', function(qualtiy)
	local _source = source
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))
	local rnd = math.random(-5, 5)
	xPlayer.Functions.AddItem('meth', math.floor(qualtiy / 2) + rnd)	
end)

RegisterServerEvent('prp-methcar:blow')
AddEventHandler('prp-methcar:blow', function(posx, posy, posz)
	local _source = source
	local xPlayers = ProjectRP.Functions.GetPlayers()
	local xPlayer = ProjectRP.Functions.GetPlayer(tonumber(source))
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('prp-methcar:blowup', xPlayers[i],posx, posy, posz)
	end
	xPlayer.Functions.RemoveItem('methlab', 1)
end)

