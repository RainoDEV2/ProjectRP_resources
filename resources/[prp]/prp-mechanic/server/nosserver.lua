local ProjectRP = exports['prp-core']:GetCoreObject()

local VehicleNitrous = {}

RegisterNetEvent('prp-mechanic:server:LoadNitrous', function(Plate)
	VehicleNitrous[Plate] = { hasnitro = true, level = 100, }
	TriggerClientEvent('prp-mechanic:client:LoadNitrous', -1, Plate)
	TriggerClientEvent('hud:client:UpdateNitrous', -1, VehicleNitrous[Plate].hasnitro, VehicleNitrous[Plate].level, false)
	TriggerEvent('prp-mechanic:database:LoadNitro', Plate, 100)
end)

RegisterNetEvent('prp-mechanic:server:UnloadNitrous', function(Plate)
	VehicleNitrous[Plate] = nil
	TriggerClientEvent('prp-mechanic:client:UnloadNitrous', -1, Plate)
	TriggerEvent('prp-mechanic:database:UnloadNitro', Plate)
end)

RegisterNetEvent('prp-mechanic:server:UpdateNitroLevel', function(Plate, level)
	VehicleNitrous[Plate].level = level
	TriggerClientEvent('prp-mechanic:client:UpdateNitroLevel', -1, Plate, level)
	TriggerEvent('prp-mechanic:database:UpdateNitroLevel', Plate, level)
end)

ProjectRP.Functions.CreateCallback('prp-mechanic:GetNosLoadedVehs', function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE hasnitro = ?', {1})
	if result[1] then
		for k, v in pairs(result) do
			if v["hasnitro"] == 1 then
				if Config.Debug then print("VehicleNitrous["..tostring(v["plate"]).."] = { level = "..tonumber(v["noslevel"])..", hasnitro = "..tostring(v["hasnitro"]).." }") end
				VehicleNitrous[v["plate"]] = { hasnitro = v["hasnitro"], level = tonumber(v["noslevel"]), }
				TriggerClientEvent('prp-mechanic:client:LoadNitrous', -1, tostring(v["plate"]))
				TriggerClientEvent('hud:client:UpdateNitrous', -1, VehicleNitrous[result[k]["plate"]].hasnitro, VehicleNitrous[result[k]["plate"]].level, false)
			end
		end
	end
	cb(VehicleNitrous)
end)

ProjectRP.Functions.CreateCallback('prp-mechanic:GetNosLoaded', function(source, cb, plate)
	local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
	if result[1].hasnitro then
		for k, v in pairs(result) do
			if v["hasnitro"] == 1 then
				if Config.Debug then print("VehicleNitrous["..tostring(result[k]["plate"]).."] = { level = "..tonumber(result[k]["noslevel"])..", hasnitro = "..tostring(result[k]["hasnitro"]).." }") end
				VehicleNitrous[result[k]["plate"]] = { hasnitro = true, level = tonumber(result[k]["noslevel"]), }
				TriggerClientEvent('prp-mechanic:client:LoadNitrous', -1, tostring(result[k]["plate"]))
				TriggerClientEvent('hud:client:UpdateNitrous', -1, VehicleNitrous[result[k]["plate"]].hasnitro, VehicleNitrous[result[k]["plate"]].level, false)
			end
		end
	end
	cb(VehicleNitrous)
end)

RegisterNetEvent('prp-mechanic:database:LoadNitro', function(plate, level)
	MySQL.Async.execute('UPDATE player_vehicles SET noslevel = ? WHERE plate = ?', {level, plate})
	MySQL.Async.execute('UPDATE player_vehicles SET hasnitro = ? WHERE plate = ?', {hasnitro, plate})
end)

RegisterNetEvent('prp-mechanic:database:UnloadNitro', function(plate)
	MySQL.Async.execute('UPDATE player_vehicles SET noslevel = ? WHERE plate = ?', {0, plate}) 
	MySQL.Async.execute('UPDATE player_vehicles SET hasnitro = ? WHERE plate = ?', {0, plate}) 
end)

RegisterNetEvent('prp-mechanic:database:UpdateNitroLevel', function(plate, level)
	MySQL.Async.execute('UPDATE player_vehicles SET noslevel = ? WHERE plate = ?', {level, plate})
end)

--Syncing stuff
RegisterNetEvent('prp-mechanic:server:SyncPurge', function(netId, enabled)
	for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
		local P = ProjectRP.Functions.GetPlayer(v)
		TriggerClientEvent('prp-mechanic:client:SyncPurge', P.PlayerData.source, netId, enabled)
	end
end)
RegisterNetEvent('prp-mechanic:server:SyncTrail', function(netId, enabled)
	for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
		local P = ProjectRP.Functions.GetPlayer(v)
		TriggerClientEvent('prp-mechanic:client:SyncTrail', P.PlayerData.source, netId, enabled)
	end
end)
RegisterNetEvent('prp-mechanic:server:SyncFlame', function(netId, scale)
	for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
		local P = ProjectRP.Functions.GetPlayer(v)
		TriggerClientEvent('prp-mechanic:client:SyncFlame', P.PlayerData.source, netId, scale)
	end
end)