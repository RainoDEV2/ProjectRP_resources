RegisterServerEvent('error')
AddEventHandler('error',function(resource, args)

    sendToDiscord("```[Client Side] Error in "..resource..'```', args)
end)

RegisterServerEvent('error2')
AddEventHandler('error2',function(resource, args)

    sendToDiscord("```[Server Side] Error in "..resource..'```', args)
end)

function sendToDiscord(name, args, color)
    local connect = {
        {
            ["color"] = 16711680,
            ["title"] = "".. name .."",
            ["description"] = args,
            ["footer"] = {
                ["text"] = "Project RP",
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/939200056408563752/N5oQMgffa8CMnjkaLL-itXTxDyrMMBWB0BDfOqyYBiPf-XycOr_q6OQJlEnP9A3CkZlG', function(err, text, headers) end, 'POST', json.encode({username = "Error Log", embeds = connect, avatar_url = ""}), { ['Content-Type'] = 'application/json' })
end



local oldError = error
local oldTrace = Citizen.Trace

local errorWords = {"failure", "error", "not", "failed", "not safe", "invalid", "cannot", ".lua", "server", "client", "attempt", "traceback", "stack", "function"}

function error(...)
    local resource = GetCurrentResourceName()

    TriggerEvent("error2", resource, args)
end

function Citizen.Trace(...)
    oldTrace(...)

    if type(...) == "string" then
        args = string.lower(...)
        
        for _, word in ipairs(errorWords) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
end
