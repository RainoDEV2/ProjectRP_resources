local ProjectRP = exports['prp-core']:GetCoreObject()
local cashA = 200 				--<<how much minimum you can get from a robbery
local cashB = 300				--<< how much maximum you can get from a robbery
local ScashA = 1000 			--<<how much minimum you can get from a robbery
local ScashB = 1500				--<< how much maximum you can get from a robbery

RegisterNetEvent('prp-storerobbery:server:takeMoney', function(register, isDone)
    local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	-- Add some stuff if you want, this here above the if statement will trigger every 2 seconds of the animation when robbing a cash register.
    if isDone then
	local bags = math.random(1,3)
	local info = {
		worth = math.random(cashA, cashB)
	}
	Player.Functions.AddItem('markedbills', bags, false, info)
	TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['markedbills'], "add")
        if math.random(1, 100) <= 10 then
            -- Give Special Item (Safe Cracker)
            Player.Functions.AddItem("safecracker", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["safecracker"], 'add')
        end
    end
end)

RegisterNetEvent('prp-storerobbery:server:setRegisterStatus', function(register)
    Config.Registers[register].robbed   = true
    Config.Registers[register].time     = Config.resetTime
    TriggerClientEvent('prp-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
end)

RegisterNetEvent('prp-storerobbery:server:setSafeStatus', function(safe)
    TriggerClientEvent('prp-storerobbery:client:setSafeStatus', -1, safe, true)
    Config.Safes[safe].robbed = true

    SetTimeout(math.random(40, 80) * (60 * 1000), function()
        TriggerClientEvent('prp-storerobbery:client:setSafeStatus', -1, safe, false)
        Config.Safes[safe].robbed = false
    end)
end)

RegisterNetEvent('prp-storerobbery:server:SafeReward', function(safe)
    local src = source
	local Player = ProjectRP.Functions.GetPlayer(src)
	local bags = math.random(3,5)
	local info = {
		worth = math.random(ScashA, ScashB)
	}
	Player.Functions.AddItem('markedbills', bags, false, info)
	TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['markedbills'], "add")
    local luck = math.random(1, 100)
    local odd = math.random(1, 100)
    if luck <= 10 then
            Player.Functions.AddItem("rolex", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["rolex"], "add")
        if luck == odd then
            Wait(500)
            Player.Functions.AddItem("goldbar", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["goldbar"], "add")
        end
    end
end)

RegisterNetEvent('prp-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local cameraId = 4
    if type == "safe" then
        cameraId = Config.Safes[safe].camId
    else
        cameraId = Config.Registers[safe].camId
    end
    local description = "Someone Is Trying To Rob A Store At "..streetLabel.." (CAMERA ID: "..cameraId..")"
    TriggerClientEvent("prp-storerobbery:client:robberyCall", -1, type, cameraId, description, coords)
end)

CreateThread(function()
    while true do
        local toSend = {}
        for k, v in ipairs(Config.Registers) do

            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                if Config.Registers[k].robbed then
                    Config.Registers[k].time = 0
                    Config.Registers[k].robbed = false
					toSend[#toSend+1] = Config.Registers[k]
                end
            end
        end

        if #toSend > 0 then
            --The false on the end of this is redundant
            TriggerClientEvent('prp-storerobbery:client:setRegisterStatus', -1, toSend, false)
        end

        Wait(Config.tickInterval)
    end
end)

ProjectRP.Functions.CreateCallback('prp-storerobbery:server:getRegisterStatus', function(source, cb)
    cb(Config.Registers)
end)

ProjectRP.Functions.CreateCallback('prp-storerobbery:server:getSafeStatus', function(source, cb)
    cb(Config.Safes)
end)

RegisterNetEvent('prp-storerobbery:server:CheckItem', function()
    local Player = ProjectRP.Functions.GetPlayer(source)
    local ItemData = Player.Functions.GetItemByName("safecracker")
    if ItemData ~= nil then
        TriggerClientEvent('prp-storerobbery:client:hacksafe', source)
    else
        TriggerClientEvent('ProjectRP:Notify', source, "You appear to be missing something?")
    end
end)
