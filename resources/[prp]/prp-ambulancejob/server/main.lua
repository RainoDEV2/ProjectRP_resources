local PlayerInjuries = {}
local PlayerWeaponWounds = {}
local ProjectRP = exports['prp-core']:GetCoreObject()
-- Events

-- Compatibility with txAdmin Menu's heal options.
-- This is an admin only server side event that will pass the target player id or -1.
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end

	TriggerClientEvent('hospital:client:Revive', eventData.id)
	TriggerClientEvent("hospital:client:HealInjuries", eventData.id, "full")
end)

RegisterNetEvent('hospital:server:SendToBed', function(bedId, isRevive)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	TriggerClientEvent('hospital:client:SendToBed', src, bedId, Config.Locations["beds"][bedId], isRevive)
	TriggerClientEvent('hospital:client:SetBed', -1, bedId, true)
	Player.Functions.RemoveMoney("bank", Config.BillCost , "Checked in at hospital")
	exports["prp-management"]:AddMoney("ambulance", Config.BillCost)
	TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
end)

RegisterNetEvent('hospital:server:RespawnAtHospital', function()
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	for k, v in pairs(Config.Locations["beds"]) do
		if not v.taken then
			TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
			TriggerClientEvent('hospital:client:SetBed', -1, k, true)
			if Config.WipeInventoryOnRespawn then
				Player.Functions.ClearInventory()
				MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), Player.PlayerData.citizenid })
				TriggerClientEvent('ProjectRP:Notify', src, 'All your possessions have been taken...', 'error')
			end
			Player.Functions.RemoveMoney("bank", Config.BillCost, "respawned at hospital")
			exports["prp-management"]:AddMoney("ambulance", Config.BillCost)
			TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
			return
		end
	end

	TriggerClientEvent('hospital:client:SendToBed', src, 1, Config.Locations["beds"][1], true)
	TriggerClientEvent('hospital:client:SetBed', -1, 1, true)
	if Config.WipeInventoryOnRespawn then
		Player.Functions.ClearInventory()
		MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), Player.PlayerData.citizenid })
		TriggerClientEvent('ProjectRP:Notify', src, 'All your possessions have been taken...', 'error')
	end
	Player.Functions.RemoveMoney("bank", Config.BillCost, "respawned at hospital")
	exports["prp-management"]:AddMoney("ambulance", Config.BillCost)
	TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
end)

RegisterNetEvent('hospital:server:ambulanceAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = ProjectRP.Functions.GetPlayers()
    for k,v in pairs(players) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player.PlayerData.job.name == 'ambulance' or 'police' and Player.PlayerData.job.onduty then
            TriggerClientEvent('hospital:client:ambulanceAlert', Player.PlayerData.source, coords, text)
        end
    end
end)

RegisterNetEvent('hospital:server:LeaveBed', function(id)
    TriggerClientEvent('hospital:client:SetBed', -1, id, false)
end)

RegisterNetEvent('hospital:server:SyncInjuries', function(data)
    local src = source
    PlayerInjuries[src] = data
end)

RegisterNetEvent('hospital:server:SetWeaponDamage', function(data)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player then
		PlayerWeaponWounds[Player.PlayerData.source] = data
	end
end)

RegisterNetEvent('hospital:server:RestoreWeaponDamage', function()
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	PlayerWeaponWounds[Player.PlayerData.source] = nil
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("isdead", isDead)
	end
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("inlaststand", bool)
	end
end)

RegisterNetEvent('hospital:server:SetArmor', function(amount)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("armor", amount)
	end
end)

RegisterNetEvent('hospital:server:lorazepamPill', function(playerId)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local Patient = ProjectRP.Functions.GetPlayer(playerId)
	if Patient then
		if Player.PlayerData.job.name =="ambulance" then
			Player.Functions.RemoveItem('lorazepam', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['lorazepam'], "remove")
			TriggerClientEvent("hospital:client:UseLorazepam", Patient.PlayerData.source, true)
		end
	end
end)

RegisterNetEvent('hospital:server:givePainkillers', function(playerId)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local Patient = ProjectRP.Functions.GetPlayer(playerId)
	if Patient then
		if Player.PlayerData.job.name =="ambulance" then
			Player.Functions.RemoveItem('painkillers', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['painkillers'], "remove")
			TriggerClientEvent("hospital:client:UsePainkillers", Patient.PlayerData.source, true)
		end
	end
end)

RegisterNetEvent('hospital:server:TreatWounds', function(playerId)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local Patient = ProjectRP.Functions.GetPlayer(playerId)
	if Patient then
		if Player.PlayerData.job.name =="ambulance" then
			Player.Functions.RemoveItem('bandage', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['bandage'], "remove")
			TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "full")
			TriggerClientEvent("hospital:client:UseBandage", Patient.PlayerData.source, true)
		end
	end
end)

RegisterNetEvent('hospital:server:SetDoctor', function()
	local amount = 0
    local players = ProjectRP.Functions.GetPlayers()
    for k,v in pairs(players) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
            amount = amount + 1
        end
	end
	TriggerClientEvent("hospital:client:SetDoctorCount", -1, amount)
end)

RegisterNetEvent('hospital:server:RevivePlayer', function(playerId, isOldMan)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local Patient = ProjectRP.Functions.GetPlayer(playerId)
	local oldMan = isOldMan or false
	if Patient then
		if oldMan then
			if Player.Functions.RemoveMoney("cash", 5000, "revived-player") then
				Player.Functions.RemoveItem('firstaid', 1)
				TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['firstaid'], "remove")
				TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
			else
				TriggerClientEvent('ProjectRP:Notify', src, 'You don\'t have enough money on you...', "error")
			end
		else
			Player.Functions.RemoveItem('firstaid', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['firstaid'], "remove")
			TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
		end
	end
end)

RegisterNetEvent('hospital:server:SendDoctorAlert', function()
    local players = ProjectRP.Functions.GetPlayers()
    for k,v in pairs(players) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
			TriggerClientEvent('ProjectRP:Notify', Player.PlayerData.source, 'A doctor is needed at Pillbox Hospital', 'ambulance')
		end
	end
end)

RegisterNetEvent('hospital:server:UseFirstAid', function(targetId)
	local src = source
	local Target = ProjectRP.Functions.GetPlayer(targetId)
	if Target then
		TriggerClientEvent('hospital:client:CanHelp', targetId, src)
	end
end)

RegisterNetEvent('hospital:server:CanHelp', function(helperId, canHelp)
	local src = source
	if canHelp then
		TriggerClientEvent('hospital:client:HelpPerson', helperId, src)
	else
		TriggerClientEvent('ProjectRP:Notify', helperId, 'You can\'t help this person...', "error")
	end
end)

-- Callbacks

ProjectRP.Functions.CreateCallback('hospital:GetDoctors', function(source, cb)
	local amount = 0
    local players = ProjectRP.Functions.GetPlayers()
    for k,v in pairs(players) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
			amount = amount + 1
		end
	end
	cb(amount)
end)

ProjectRP.Functions.CreateCallback('hospital:GetPlayerStatus', function(source, cb, playerId)
	local Player = ProjectRP.Functions.GetPlayer(playerId)
	local injuries = {}
	injuries["WEAPONWOUNDS"] = {}
	if Player then
		if PlayerInjuries[Player.PlayerData.source] then
			if (PlayerInjuries[Player.PlayerData.source].isBleeding > 0) then
				injuries["BLEED"] = PlayerInjuries[Player.PlayerData.source].isBleeding
			end
			for k, v in pairs(PlayerInjuries[Player.PlayerData.source].limbs) do
				if PlayerInjuries[Player.PlayerData.source].limbs[k].isDamaged then
					injuries[k] = PlayerInjuries[Player.PlayerData.source].limbs[k]
				end
			end
		end
		if PlayerWeaponWounds[Player.PlayerData.source] then
			for k, v in pairs(PlayerWeaponWounds[Player.PlayerData.source]) do
				injuries["WEAPONWOUNDS"][k] = v
			end
		end
	end
    cb(injuries)
end)

ProjectRP.Functions.CreateCallback('hospital:GetPlayerBleeding', function(source, cb)
	local src = source
	if PlayerInjuries[src] and PlayerInjuries[src].isBleeding then
		cb(PlayerInjuries[src].isBleeding)
	else
		cb(nil)
	end
end)

-- Commands

ProjectRP.Commands.Add('911e', 'EMS Report', {{name = 'message', help = 'Message to be sent'}}, false, function(source, args)
	local src = source
	if args[1] then message = table.concat(args, " ") else message = 'Civilian Call' end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = ProjectRP.Functions.GetPlayers()
    for k,v in pairs(players) do
        local Player = ProjectRP.Functions.GetPlayer(v)
        if Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
            TriggerClientEvent('hospital:client:ambulanceAlert', Player.PlayerData.source, coords, message)
        end
    end
end)

ProjectRP.Commands.Add("status", 'Check a Players Health', {}, false, function(source, args)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:CheckStatus", src)
	else
		TriggerClientEvent('ProjectRP:Notify', src, 'You are not EMS or not signed in', "error")
	end
end)

ProjectRP.Commands.Add("heal", 'Heal a Person', {}, false, function(source, args)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:TreatWounds", src)
	else
		TriggerClientEvent('ProjectRP:Notify', src, 'You are not EMS or not signed in', "error")
	end
end)

ProjectRP.Commands.Add("revivep", 'Revive a Person', {}, false, function(source, args)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:RevivePlayer", src)
	else
		TriggerClientEvent('ProjectRP:Notify', src, 'You are not EMS or not signed in', "error")
	end
end)

ProjectRP.Commands.Add("revive", 'Revive A Person or Yourself (Admin Only)', {{name = "id", help = 'Player ID (may be empty)'}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
		else
			TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', "error")
		end
	else
		TriggerClientEvent('hospital:client:Revive', src)
	end
end, "admin")

ProjectRP.Commands.Add("setpain", 'Set Yours or A Players Pain Level (Admin Only)', {{name = "id", help = 'Player ID (may be empty)'}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:SetPain', Player.PlayerData.source)
		else
			TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', "error")
		end
	else
		TriggerClientEvent('hospital:client:SetPain', src)
	end
end, "admin")

ProjectRP.Commands.Add("kill", 'Kill A Player or Yourself (Admin Only)', {{name = "id", help = 'Player ID (may be empty)'}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:KillPlayer', Player.PlayerData.source)
		else
			TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', "error")
		end
	else
		TriggerClientEvent('hospital:client:KillPlayer', src)
	end
end, "admin")

ProjectRP.Commands.Add('aheal', 'Heal A Player or Yourself (Admin Only)', {{name = 'id', help = 'Player ID (may be empty)'}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:adminHeal', Player.PlayerData.source)
		else
			TriggerClientEvent('ProjectRP:Notify', src, 'Player Not Online', "error")
		end
	else
		TriggerClientEvent('hospital:client:adminHeal', src)
	end
end, 'admin')

-- Items

ProjectRP.Functions.CreateUseableItem("ifaks", function(source, item)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseIfaks", src)
	end
end)

ProjectRP.Functions.CreateUseableItem("bandage", function(source, item)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseBandage", src)
	end
end)

ProjectRP.Functions.CreateUseableItem("painkillers", function(source, item)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UsePainkillers", src)
	end
end)

ProjectRP.Functions.CreateUseableItem("lorazepam", function(source, item)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseLorazepam", src,false)
	end
end)

ProjectRP.Functions.CreateUseableItem("firstaid", function(source, item)
	local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseFirstAid", src)
	end
end)







local await = false
local link = nil


RegisterNetEvent("sv:log:picture")
AddEventHandler("sv:log:picture", function(shit)
	link = shit
	Wait(50)
	await = false
end)

RegisterNetEvent('sv:log')
AddEventHandler('sv:log', function (killer,deathreason,deathweapon)
    local source = source
	link = nil

    local killer = killer

    if killer ~= 0 then

		TriggerClientEvent("Grab:Kill:Screenshot",killer)
		await = true
		while await do 
			Wait(0) 
		end


      Webhook("Player Killed", "L Bozo got killed", {
		{
		  name = "Killer's Name",
		  value = GetPlayerName(killer),
		  inline = true
		},
		{
		  name = "Server ID",
		  value = killer,
		  inline = true
		},
		{
		  name = "Victims Name",
		  value = GetPlayerName(source),
		  inline = true
		},
		{
		  name = "Victims Server ID",
		  value = source,
		  inline = true
		},
		{
		  name = "Death Reason",
		  value = deathreason,
		  inline = true
		},
		{
		  name = "Weapon Used",
		  value = deathweapon,
		  inline = false
		},
	  }, "https://discord.com/api/webhooks/938943739936788595/S5Tt17XPuVmQ-buHey5xxf66VGD5VEUs2_GRFlX6Eh-cFJiGG19l92M_vhEciOQ7_9dU", false, link)

    else
		TriggerClientEvent("Grab:Kill:Screenshot",source)
		await = true
		while await do 
			Wait(0) 
		end



      Webhook("Player Died", "Bozo Died ``(Here is a screenshot of dummys screen laugh at him for dying)``", {
        {
          name = "Victims Name",
          value = GetPlayerName(source),
          inline = true
        },
        {
          name = "Victims Server ID",
          value = source,
          inline = true
        },
        {
          name = "Death Reason",
          value = deathreason,
          inline = true
        },
        {
          name = "Weapon Used",
          value = deathweapon,
          inline = false
        },
      }, "https://discord.com/api/webhooks/938943739936788595/S5Tt17XPuVmQ-buHey5xxf66VGD5VEUs2_GRFlX6Eh-cFJiGG19l92M_vhEciOQ7_9dU", false, link)

    end
end)






HTTPRequest = function(a, b, c, d)
    a = a
    if b == "get" then
      PerformHttpRequest(a, function(a, b, c)
        a = a
        if b ~= nil and b ~= "" then
          va = b
        else
          va = "Error"
        end
      end)
      while nil == nil do
        Citizen.Wait(0)
      end
    elseif b == "post" then
      if d then
      end
      PerformHttpRequest(a, function(a, b, c)
        a = a
      end, "POST", json.encode({
        username = "ProjectRP",
        avatar_url = "https://cdn.discordapp.com/attachments/921901106349633588/932374611486720050/image0.jpg",
        content = "",
        embeds = {c}
      }), {
        ["Content-Type"] = "application/json"
      })
    end
    return nil
  end

Webhook = function(a, b, c, d, e, g)
    a = a
    HTTPRequest(d, "post", {
      color = "16722988",
      type = "rich",
      title = a,
      description = b,
      fields = c or {},
      footer = {
        text = "ProjectRP | " .. os.date("%B %d, %Y at %I:%M %p"),
        icon_url = "https://cdn.discordapp.com/attachments/921901106349633588/932374611486720050/image0.jpg"
      },
      image = {
        url = g or nil
      },
      author = {
        name = "Project RP ",
        url = "https://tronix.dev/",
        icon_url = "https://cdn.discordapp.com/attachments/921901106349633588/932374611486720050/image0.jpg"
      }
    }, e)
  end