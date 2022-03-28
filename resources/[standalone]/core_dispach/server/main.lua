ProjectRP = nil

Id = 0

Units = {}
Calls = {}
UnitStatus = {}
local PlayerData = {}


local ProjectRP = exports['prp-core']:GetCoreObject()


RegisterServerEvent("core_dispach:playerStatus")
AddEventHandler("core_dispach:playerStatus", function(status)
        local src = source

        if status.carPlate ~= "" then
            Units[src] = {plate = status.carPlate, type = status.type, job = status.job, netId = status.netId}
        else
            Units[src] = nil
        end
end)

RegisterServerEvent("core_dispach:removeCall")
AddEventHandler("core_dispach:removeCall", function(id)
        Calls[tonumber(id)] = nil
end)

RegisterServerEvent("core_dispach:changeStatus")
AddEventHandler( "core_dispach:changeStatus", function(userid, status)
        UnitStatus[userid] = status
end)

RegisterServerEvent("core_dispach:unitDismissed")
AddEventHandler( "core_dispach:unitDismissed", function(id, job)
        local src = source
        local count = 1

        for _, v in ipairs(Calls[tonumber(id)].respondingUnits) do
            if v.unit == src then
                table.remove(Calls[tonumber(id)].respondingUnits, count)
            end
            count = count + 1
        end
end)

RegisterServerEvent("core_dispach:unitResponding")
AddEventHandler("core_dispach:unitResponding", function(id, job)
        local src = source
        table.insert(Calls[tonumber(id)].respondingUnits, {unit = src, type = job})
end)

RegisterServerEvent("core_dispach:forwardCall")
AddEventHandler("core_dispach:forwardCall", function(id, job)
        local add = true
        for _, v in ipairs(Calls[tonumber(id)].job) do
            if v == job then
                add = false
            end
        end

        if add then
            table.insert(Calls[tonumber(id)].job, job)

            TriggerClientEvent("core_dispach:callAdded", -1, tonumber(id), Calls[tonumber(id)], job, 5000)
        end
end)

RegisterServerEvent("core_dispach:addMessage")
AddEventHandler("core_dispach:addMessage", function(message, location, job, cooldown, sprite, color)
        local src = source
        local xPlayer = ProjectRP.Functions.GetPlayer(src)
        local phone =  xPlayer.PlayerData.charinfo.phone
        Calls[Id] = {
            code = "",
            title = "",
            extraInfo = {},
            respondingUnits = {},
            coords = location,
            job = {job},
            phone = phone,
            message = message,
            type = "message",
            caller = src
        }

        TriggerClientEvent("core_dispach:callAdded", -1, Id, Calls[Id], job, cooldown or 5000, sprite or 11, color or 5)

        Id = Id + 1
end)

RegisterServerEvent("core_dispach:addCall")
AddEventHandler("core_dispach:addCall", function(code, title, info, location, job, cooldown, sprite, color)
        Calls[Id] = {
            code = code,
            title = title,
            extraInfo = info,
            respondingUnits = {},
            coords = location,
            job = {job},
            type = "call"
        }

        TriggerClientEvent("core_dispach:callAdded", -1, Id, Calls[Id], job, cooldown or 3500, sprite or 11, color or 5)


         Id = Id + 1
end)

RegisterServerEvent("core_dispach:arrivalNotice")
AddEventHandler("core_dispach:arrivalNotice", function(caller)
    	if caller ~= nil then
        TriggerClientEvent("core_dispach:arrivalNotice", caller)
    end
end)

ProjectRP.Functions.CreateCallback("core_dispach:getPersonalInfo", function(source, cb)
        local Player = ProjectRP.Functions.GetPlayer(source)
        local firstname = Player.PlayerData.charinfo.firstname
        local lastname = Player.PlayerData.charinfo.lastname
        cb(firstname, lastname)
end)

ProjectRP.Functions.CreateCallback("core_dispach:getInfo", function(source, cb)
        local generated = {}

        for k, v in pairs(Units) do
            if GetPlayerPing(k) > 0 then
                local Player = ProjectRP.Functions.GetPlayer(source)
                local firstname = Player.PlayerData.charinfo.firstname
                local lastname = Player.PlayerData.charinfo.lastname
                if generated[v.plate] == nil then
                    generated[v.plate] = {
                        type = Config.Icons[v.type],
                        units = {{id = k, name = firstname .. " " .. lastname}},
                        job = v.job
                    }
                elseif generated[v.plate].job == v.job then
                    table.insert(generated[v.plate].units, {id = k, name = firstname .. " " .. lastname})
                end
            end
        end
        cb(generated, Calls, UnitStatus)
end)

ProjectRP.Functions.CreateCallback("core_dispach:getUnits", function(source, cb)
        local generated = {}

        for k, v in pairs(Units) do
            if GetPlayerPing(k) > 0 then
                local Player = ProjectRP.Functions.GetPlayer(source)
                local firstname = Player.PlayerData.charinfo.firstname
                local lastname = Player.PlayerData.charinfo.lastname

                generated[k] = {netId = v.netId, firstname = firstname, lastname = lastname, type = v.type, job = v.job}
            end
        end
        cb(generated)
end)
