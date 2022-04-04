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
    PerformHttpRequest('https://discord.com/api/webhooks/960323026971422722/6YhrO5zWUer7d5U-x61odcEcd-Rx-7-dxL2L0zUKCf_7TMjtj5op7P3j8tKb708iv8gy', function(err, text, headers) end, 'POST', json.encode({username = "Error Log", embeds = connect, avatar_url = ""}), { ['Content-Type'] = 'application/json' })
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
