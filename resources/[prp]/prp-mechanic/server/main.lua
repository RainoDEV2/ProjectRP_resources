local ProjectRP = exports['prp-core']:GetCoreObject()
--========================================================== Engines
RegisterNetEvent('prp-mechanic:server:removeSuspension', function(level, current)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if level ~= nil then
		Player.Functions.RemoveItem("suspension"..level+1, 1) 
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["suspension"..level+1], "remove", 1)
	end
	if current ~= -1 then
		Player.Functions.AddItem("suspension"..current+1, 1, false, {["quality"] = nil})
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["suspension"..current+1], "add", 1)
	end
end)

for i = 1, 4 do
	ProjectRP.Functions.CreateUseableItem("suspension"..i, function(source, item) TriggerClientEvent("prp-mechanic:client:applySuspension", source, i-1) end)
end

--========================================================== Engines
RegisterNetEvent('prp-mechanic:server:removeEngines', function(level, current)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if level ~= nil then
		Player.Functions.RemoveItem("engine"..level+1, 1) 
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["engine"..level+1], "remove", 1)
	end
	if current ~= -1 then
		Player.Functions.AddItem("engine"..current+1, 1, false, {["quality"] = nil})
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["engine"..current+1], "add", 1)
	end
end)

for i = 1, 4 do
	ProjectRP.Functions.CreateUseableItem("engine"..i, function(source, item) TriggerClientEvent("prp-mechanic:client:applyEngine", source, i-1) end)
end
--========================================================== Brakes
RegisterNetEvent('prp-mechanic:server:removeBrakes', function(level, current)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if level ~= nil then
		Player.Functions.RemoveItem("brakes"..level+1, 1) 
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["brakes"..level+1], "remove", 1)
	end
	if current ~= -1 then
		Player.Functions.AddItem("brakes"..current+1, 1, false, {["quality"] = nil})
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["brakes"..current+1], "add", 1)
	end
end)

for i = 1, 3 do
	ProjectRP.Functions.CreateUseableItem("brakes"..i, function(source, item) TriggerClientEvent("prp-mechanic:client:applyBrakes", source, i-1) end)
end
--========================================================== Transmission
RegisterNetEvent('prp-mechanic:server:removeTransmission', function(level, current)
    local Player = ProjectRP.Functions.GetPlayer(source)
	if level ~= nil then
		Player.Functions.RemoveItem('transmission'..level+1, 1) 
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["transmission"..level+1], "remove", 1)
	end
	if current ~= -1 then
		Player.Functions.AddItem('transmission'..current+1, 1, false, {["quality"] = nil})
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items["transmission"..current+1], "add", 1)
	end
end)

for i = 1, 3 do
	ProjectRP.Functions.CreateUseableItem("transmission"..i, function(source, item) TriggerClientEvent("prp-mechanic:client:applyTransmission", source, i-1) end)
end
--========================================================== Armour
RegisterNetEvent('prp-mechanic:server:removeArmour', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('car_armor', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['car_armor'], "remove", 1)
end)

RegisterNetEvent('prp-mechanic:server:giveArmour', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddItem('car_armor', 1, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['car_armor'], "add", 1)
end)

ProjectRP.Functions.CreateUseableItem("car_armor", function(source, item) TriggerClientEvent('prp-mechanic:client:applyArmour', source) end)
--========================================================== Turbo
RegisterNetEvent('prp-mechanic:server:removeTurbo', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('turbo', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['turbo'], "remove", 1)
end)

RegisterNetEvent('prp-mechanic:server:giveTurbo', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddItem('turbo', 1, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['turbo'], "add", 1)
end)

ProjectRP.Functions.CreateUseableItem("turbo", function(source, item) TriggerClientEvent("prp-mechanic:client:applyTurbo", source) end)
--========================================================== BulletProof Tires
RegisterNetEvent('prp-mechanic:server:removeBulletProof', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('bprooftires', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['bprooftires'], "remove", 1)
end)

RegisterNetEvent('prp-mechanic:server:giveBulletProof', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddItem('bprooftires', 1, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['bprooftires'], "add", 1)
end)

ProjectRP.Functions.CreateUseableItem("bprooftires", function(source, item) TriggerClientEvent("prp-mechanic:client:applyBulletProof", source) end)
--========================================================== Drift Tires
RegisterNetEvent('prp-mechanic:server:removeDrift', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('drifttires', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['drifttires'], "remove", 1)
end)

RegisterNetEvent('prp-mechanic:server:giveDrift', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddItem('drifttires', 1, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['drifttires'], "add", 1)
end)

ProjectRP.Functions.CreateUseableItem("drifttires", function(source, item) TriggerClientEvent("prp-mechanic:client:applyDrift", source) end)
--========================================================== NOS
RegisterNetEvent('prp-mechanic:server:removeNOS', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('nos', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['nos'], "remove", 1)
end)
RegisterNetEvent('prp-mechanic:server:giveNOS', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddItem('noscan', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['noscan'], "add", 1)
end)

ProjectRP.Functions.CreateUseableItem("nos", function(source, item) TriggerClientEvent("prp-mechanic:client:applyNOS", source) end)
--========================================================== Headlights & Underglow
RegisterNetEvent('prp-mechanic:server:removeXenon', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('headlights', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['headlights'], "remove", 1)
end)

RegisterNetEvent('prp-mechanic:server:giveXenon', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.AddItem('headlights', 1, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['headlights'], "add", 1)
end)

ProjectRP.Functions.CreateUseableItem("headlights", function(source, item) TriggerClientEvent("prp-mechanic:client:applyXenons", source) end)

ProjectRP.Functions.CreateUseableItem("underglow_controller", function(source, item) TriggerClientEvent('prp-mechanic:client:neonMenu', source) end)

--========================================================== Toolbox
ProjectRP.Functions.CreateUseableItem("toolbox", function(source, item) TriggerClientEvent('prp-mechanic:client:Menu', source) end)

--========================================================== REPAIR
ProjectRP.Functions.CreateUseableItem("mechanic_tools", function(source, item) TriggerClientEvent('prp-mechanic:client:Repair:Check', source) end)

--========================================================== Seats
ProjectRP.Functions.CreateUseableItem("seat", function(source, item) TriggerClientEvent('prp-mechanic:client:Seat:Check', source) end)

--========================================================== Interior
ProjectRP.Functions.CreateUseableItem("internals", function(source, item) TriggerClientEvent('prp-mechanic:client:Interior:Check', source) end)

--========================================================== Exterior
ProjectRP.Functions.CreateUseableItem("externals", function(source, item) TriggerClientEvent('prp-mechanic:client:Exterior:Check', source) end)

--========================================================== Rims
ProjectRP.Functions.CreateUseableItem("rims", function(source, item) TriggerClientEvent('prp-mechanic:client:Rims:Check', source) end)

--========================================================== Exhaust
ProjectRP.Functions.CreateUseableItem("exhaust", function(source, item) TriggerClientEvent('prp-mechanic:client:Exhaust:Check', source) end)

--========================================================== Horn
ProjectRP.Functions.CreateUseableItem("horn", function(source, item) TriggerClientEvent('prp-mechanic:client:Horn:Check', source) end)

--========================================================== Paints
ProjectRP.Functions.CreateUseableItem("paintcan", function(source, item) TriggerClientEvent('prp-mechanic:client:Paints:Check', source) end)

--========================================================== Livery
ProjectRP.Functions.CreateUseableItem("livery", function(source, item) TriggerClientEvent('prp-mechanic:client:Livery:Check', source) end)

--========================================================== Tire Smoke
ProjectRP.Functions.CreateUseableItem("tires", function(source, item) TriggerClientEvent('prp-mechanic:client:Tires:Check', source) end)

--========================================================== Skirts
ProjectRP.Functions.CreateUseableItem("skirts", function(source, item) TriggerClientEvent('prp-mechanic:client:Skirts:Check', source) end)

--========================================================== Spoiler
ProjectRP.Functions.CreateUseableItem("spoiler", function(source, item) TriggerClientEvent('prp-mechanic:client:Spoilers:Check', source) end)

--========================================================== Roof
ProjectRP.Functions.CreateUseableItem("roof", function(source, item) TriggerClientEvent('prp-mechanic:client:Roof:Check', source) end)

--========================================================== Hood
ProjectRP.Functions.CreateUseableItem("hood", function(source, item) TriggerClientEvent('prp-mechanic:client:Hood:Check', source) end)

--========================================================== Bumpers
ProjectRP.Functions.CreateUseableItem("bumper", function(source, item) TriggerClientEvent('prp-mechanic:client:Bumpers:Check', source) end)

--========================================================== Plates
ProjectRP.Functions.CreateUseableItem("customplate", function(source, item) TriggerClientEvent('prp-mechanic:client:Plates:Check', source) end)

--========================================================== Cleaning Car
ProjectRP.Functions.CreateUseableItem("cleaningkit", function(source, item) TriggerClientEvent('prp-mechanic:client:cleanVehicle', source, true) end)

--========================================================== Windowtint

RegisterNetEvent('prp-mechanic:server:removeTintSupplies', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('tint_supplies', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['tint_supplies'], "remove", 1)
end)

ProjectRP.Functions.CreateUseableItem("tint_supplies", function(source, item) TriggerClientEvent('prp-mechanic:client:Windows:Check', source) end)

--========================================================== REPAIRS

ProjectRP.Functions.CreateUseableItem("ducttape", function(source, item) TriggerClientEvent("prp-mechanic:quickrepair", source) end)

RegisterNetEvent('prp-mechanic:server:removeTape', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('ducttape', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items['ducttape'], "remove", 1)
end)
--========================================================== REPAIRS

ProjectRP.Functions.CreateCallback('prp-mechanic:repairCost',function(source, cb, data)
    local src = source 
    local Player = ProjectRP.Functions.GetPlayer(src)
	if data.part == Loc[Config.Lan]["repair"].engine then
		local item = Player.Functions.GetItemByName(Config.RepairEngine)
		if item ~= nil and item.amount >= tonumber(data.cost) then cb(true)
		else cb(false) end
	elseif data.part == Loc[Config.Lan]["repair"].body then
		local item = Player.Functions.GetItemByName(Config.RepairBody)
		if item ~= nil and item.amount >= data.cost then cb(true)
		else cb(false) end	
	elseif data.part == Loc[Config.Lan]["repair"].radiator then
		local item = Player.Functions.GetItemByName(Config.RepairRadiator)
		if item ~= nil and item.amount >= tonumber(data.cost) then cb(true)
		else cb(false) end
	elseif data.part == Loc[Config.Lan]["repair"].driveshaft then
		local item = Player.Functions.GetItemByName(Config.RepairAxle)
		if item ~= nil and item.amount >= data.cost then cb(true)
		else cb(false) end
	elseif data.part == Loc[Config.Lan]["repair"].brakes then
		local item = Player.Functions.GetItemByName(Config.RepairBrakes)
		if item ~= nil and item.amount >= data.cost then cb(true)
		else cb(false) end
	elseif data.part == Loc[Config.Lan]["repair"].clutch then
		local item = Player.Functions.GetItemByName(Config.RepairClutch)
		if item ~= nil and item.amount >= data.cost then cb(true)
		else cb(false) end
	elseif data.part == Loc[Config.Lan]["repair"].tank then
		local item = Player.Functions.GetItemByName(Config.RepairFuel)
		if item ~= nil and item.amount >= data.cost then cb(true)
		else cb(false) end
	end
end)

RegisterServerEvent('prp-mechanic:ItemRemove')
AddEventHandler('prp-mechanic:ItemRemove', function(data)
    local src = source 
    local Player = ProjectRP.Functions.GetPlayer(src)
	if data.part == Loc[Config.Lan]["repair"].engine then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairEngine], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairEngine, data.cost)
	elseif data.part == Loc[Config.Lan]["repair"].body then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairBody], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairBody, data.cost)
	elseif data.part == Loc[Config.Lan]["repair"].radiator then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairRadiator], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairRadiator, data.cost)
	elseif data.part == Loc[Config.Lan]["repair"].driveshaft then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairAxle], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairAxle, data.cost)
	elseif data.part == Loc[Config.Lan]["repair"].brakes then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairBrakes], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairBrakes, data.cost)
	elseif data.part == Loc[Config.Lan]["repair"].clutch then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairClutch], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairClutch, data.cost)
	elseif data.part == Loc[Config.Lan]["repair"].tank then
		TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[Config.RepairFuel], "remove", data.cost) 
		Player.Functions.RemoveItem(Config.RepairFuel, data.cost)
	end
end)