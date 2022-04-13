local ProjectRP = exports['prp-core']:GetCoreObject()

local balance = nil

--REMOVE THIS COMMAND IF YOU ONLY WANT TO USE THE REGISTER SYSTEM
ProjectRP.Commands.Add('charge', 'Charge A Player', {{name = 'id', help = 'Player ID'}, {name = 'amount', help = 'Sale Amount'}, {name = 'type', help = 'Cash/Card'}}, false, function(source, args) 
	local biller = ProjectRP.Functions.GetPlayer(source)
	local billed = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[2])
	local billtype = string.lower(tostring(args[3]))
	for k, v in pairs(Config.JobRoles) do if v == biller.PlayerData.job.name then havejob = true end end if havejob then
		if billed ~= nil then
				if billtype == "cash" then balance = billed.Functions.GetMoney(billtype)
					if balance >= amount then billed.Functions.RemoveMoney('cash', amount) TriggerEvent("prp-bossmenu:server:addAccountMoney", tostring(biller.PlayerData.job.name), amount)	TriggerEvent('prp-payments:Tickets:Give', amount, tostring(biller.PlayerData.job.name))
					else 
						TriggerClientEvent("ProjectRP:Notify", source, "Customer doesn't have enough cash to pay", "error")
						TriggerClientEvent("ProjectRP:Notify", tonumber(citizen), "You don't have enough cash to pay", "error")
					end
				elseif billtype == "card" then
			if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
				if amount and amount > 0 then
					MySQL.Async.insert(
						'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
						{billed.PlayerData.citizenid, amount, biller.PlayerData.job.name,
						 biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
					TriggerClientEvent('prp-phone:RefreshPhone', billed.PlayerData.source)
					TriggerClientEvent('ProjectRP:Notify', source, 'Invoice Successfully Sent', 'success')
					TriggerClientEvent('ProjectRP:Notify', billed.PlayerData.source, 'New Invoice Received')
				else TriggerClientEvent('ProjectRP:Notify', source, 'Must Be A Valid Amount Above 0', 'error') end
			else TriggerClientEvent('ProjectRP:Notify', source, 'You Cannot Bill Yourself', 'error') end
			else TriggerClientEvent('ProjectRP:Notify', source, "Invalid choice, 'Cash' or 'Card'", 'error') end
		else TriggerClientEvent('ProjectRP:Notify', source, 'Player Not Online', 'error') end
	else TriggerClientEvent('ProjectRP:Notify', source, 'No Access', 'error') end
end)