local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterNetEvent('prp-log:server:CreateLog', function(name, title, color, message, tagEveryone)        
    local tag = tagEveryone or false
    local webHook = Config.Webhooks[name] or Config.Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Config.Colors[color] or Config.Colors['default'],
            ['footer'] = {
                ['text'] = '©️ All rights reserved by Project RP' ..os.date("%d/%m/%Y %X"),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'ProjectRP Logs',
                ['icon_url'] = 'https://cdn.discordapp.com/attachments/939449273970487417/939449508398510170/fba5482d5d39e8456de27e9e5ddf53e0.png',
            },
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = 'ProjectRP Logs', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = 'ProjectRP Logs', content = ''}), { ['Content-Type'] = 'application/json' })
    end
end)

ProjectRP.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function(source, args)
    TriggerEvent('prp-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
