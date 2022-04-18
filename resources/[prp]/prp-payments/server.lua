local ProjectRP = exports['prp-core']:GetCoreObject()

local function cv(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

-- ProjectRP.Commands.Add("cashregister", "Use mobile cash register", {}, false, function(source) TriggerClientEvent("prp-payments:client:Charge", source, true) end)

RegisterServerEvent('prp-payments:Tickets:Give', function(data, biller)
	--Find the biller from their citizenid
	if biller == nil then
		for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
		local Player = ProjectRP.Functions.GetPlayer(v)
			if Player.PlayerData.citizenid == data.senderCitizenId then	biller = Player	end
		end
	end
	if Config.TicketSystem then
		if data.amount >= Config.Jobs[data.society].MinAmountforTicket then
			for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
				local Player = ProjectRP.Functions.GetPlayer(v)
				if Player ~= nil then
					if Player.PlayerData.job.name == data.society and Player.PlayerData.job.onduty then
						Player.Functions.AddItem('payticket', 1, false, {["quality"] = nil})
						TriggerClientEvent('ProjectRP:Notify', Player.PlayerData.source, 'Receipt received', 'success')
						TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, ProjectRP.Shared.Items['payticket'], "add", 1) 
					end
				end
			end
		end
	end
	-- Commission section, does each config option separately
	local comm = tonumber(Config.Jobs[data.society].Commission)
	if Config.Commission and comm ~= 0 then
		if Config.CommissionLimit and data.amount < Config.Jobs[data.society].MinAmountforTicket then return end
		if Config.CommissionDouble then	
			biller.Functions.AddMoney("bank", math.floor(tonumber(data.amount) * (comm *2)))
			TriggerClientEvent("ProjectRP:Notify", biller.PlayerData.source, "Recieved $"..math.floor(tonumber(data.amount) * (comm *2)).." in Commission", "success")
		else biller.Functions.AddMoney("bank",  math.floor(tonumber(data.amount) *comm))
			TriggerClientEvent("ProjectRP:Notify", biller.PlayerData.source, "Recieved $"..math.floor(tonumber(data.amount) * comm).." in Commission", "success")
		end
		if Config.CommissionAll then
			for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
				local Player = ProjectRP.Functions.GetPlayer(v)
				if Player ~= nil and Player ~= biller then
					if Player.PlayerData.job.name == data.society and Player.PlayerData.job.onduty then
						Player.Functions.AddMoney("bank",  math.floor(tonumber(data.amount) * comm))
						TriggerClientEvent("ProjectRP:Notify", Player.PlayerData.source, "Recieved $"..math.floor(tonumber(data.amount) * comm).." in Commission", "success")
					end
				end
			end
		end
	end
end)

RegisterServerEvent('prp-payments:Tickets:Sell', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName("payticket") == nil then TriggerClientEvent('ProjectRP:Notify', source, "No tickets to trade", 'error') return
	else
		tickets = Player.Functions.GetItemByName("payticket").amount
		Player.Functions.RemoveItem('payticket', tickets)
		pay = (tickets * Config.Jobs[Player.PlayerData.job.name].PayPerTicket)
		Player.Functions.AddMoney('bank', pay, 'ticket-payment')
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['payticket'], "remove", tickets)
		TriggerClientEvent('ProjectRP:Notify', source, "Tickets traded: "..tickets.." Total: $"..cv(pay), 'success')
	end
end)

ProjectRP.Functions.CreateCallback('prp-payments:Ticket:Count', function(source, cb)
	if ProjectRP.Functions.GetPlayer(source).Functions.GetItemByName('payticket') == nil then amount = 0
	else amount = ProjectRP.Functions.GetPlayer(source).Functions.GetItemByName('payticket').amount end
	cb(amount)
end)

RegisterServerEvent("prp-payments:server:Charge", function(citizen, price, billtype, img)
	local src = source
    local biller = ProjectRP.Functions.GetPlayer(src)
    local billed = ProjectRP.Functions.GetPlayer(tonumber(citizen))
    local amount = tonumber(price)
	local balance = billed.Functions.GetMoney(billtype)
	if amount and amount > 0 then
		if balance < amount then
			TriggerClientEvent("ProjectRP:Notify", src, "Customer doesn't have enough cash to pay", "error")
			TriggerClientEvent("ProjectRP:Notify", tonumber(citizen), "You don't have enough cash to pay", "error")
			return
		end
		if billtype == "cash" then 
			TriggerClientEvent("prp-payments:client:PayPopup", billed.PlayerData.source, amount, src, billtype, img, biller.PlayerData.job.label)
		elseif billtype == "bank" then
			if Config.PhoneBank == false then
				TriggerClientEvent("prp-payments:client:PayPopup", billed.PlayerData.source, amount, src, billtype, img, biller.PlayerData.job.label)
			else
				MySQL.Async.insert(
					'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
					{billed.PlayerData.citizenid, amount, biller.PlayerData.job.name, biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
				TriggerClientEvent('prp-phone:RefreshPhone', billed.PlayerData.source)
				TriggerClientEvent('ProjectRP:Notify', src, 'Invoice Successfully Sent', 'success')
				TriggerClientEvent('ProjectRP:Notify', billed.PlayerData.source, 'New Invoice Received')
			end
		end
	else TriggerClientEvent('ProjectRP:Notify', source, "You can't charge $0", 'error') return end
end)

RegisterServerEvent("prp-payments:server:PayPopup", function(data)
	local src = source
    local billed = ProjectRP.Functions.GetPlayer(src)
    local biller = ProjectRP.Functions.GetPlayer(tonumber(data.biller))
	local newdata = { senderCitizenId = biller.PlayerData.citizenid, society = biller.PlayerData.job.name, amount = data.amount }
	if data.accept == true then
		billed.Functions.RemoveMoney(tostring(data.billtype), data.amount)
		local comm = tonumber(Config.Jobs[newdata.society].Commission)
		if Config.Commission and comm ~= 0 then
			local businessAmount = data.amount - math.floor(tonumber(data.amount) * comm)
			exports["prp-management"]:AddMoney(tostring(biller.PlayerData.job.name), businessAmount)
		end
		TriggerEvent('prp-payments:Tickets:Give', newdata, biller)
		TriggerClientEvent("ProjectRP:Notify", data.biller, billed.PlayerData.charinfo.firstname.." accepted the payment", "success")
	elseif data.accept == false then
		TriggerClientEvent("ProjectRP:Notify", src, "You declined the payment")
		TriggerClientEvent("ProjectRP:Notify", data.biller, billed.PlayerData.charinfo.firstname.." declined the payment", "error")
	end
end)

ProjectRP.Functions.CreateCallback('prp-payments:MakePlayerList', function(source, cb)
	local onlineList = {}
	for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
		local P = ProjectRP.Functions.GetPlayer(v)
		onlineList[#onlineList+1] = { value = tonumber(v), text = "["..v.."] - "..P.PlayerData.charinfo.firstname..' '..P.PlayerData.charinfo.lastname  }
	end
	cb(onlineList) 
end)
