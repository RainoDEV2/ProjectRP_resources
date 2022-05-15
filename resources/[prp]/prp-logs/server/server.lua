local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterNetEvent('prp-log:server:CreateLog', function(name, title, color, message, tagEveryone)        
    local tag = tagEveryone or false
    local webHook = Config.Webhooks[name] or Config.Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Config.Colors[color] or Config.Colors['default'],
            ['footer'] = {
                ['text'] = '©️ All rights reserved by Project RP ' ..os.date("%d/%m/%Y %X"),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'ProjectRP Logs',
                ['icon_url'] = 'https://imgur.com/HFPVGUc',
            },
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = 'ProjectRP Logs', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = 'ProjectRP Logs', content = ''}), { ['Content-Type'] = 'application/json' })
    end
end)


RegisterNetEvent('prp-log:server:CreateLog:MDT', function(name, title, color, message, arrestofficer, offendername, charges, notes)        
    local webHook = Config.Webhooks[name] or Config.Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Config.Colors[color] or Config.Colors['default'],
            ['footer'] = {
                ['text'] = "⭐ Project RP MDT",
            },
            ['fields'] = {
                {
                    ['name'] = "Arrest Officer",
                    ['value'] = ''..arrestofficer..'',
                    ['inline'] = true
                },
                {
                    ['name'] = "Offender Name",
                    ['value'] = ''..offendername..'',
                    ['inline'] = true
                },
                {
                    ['name'] = "Charges",
                    ['value'] = ''..charges..'',
                    ['inline'] = false
                },
                {
                    ['name'] = "Notes",
                    ['value'] = ''..notes..'',
                    ['inline'] = false
                },
            },
            
            ['description'] = message,
            ['author'] = {
                ['name'] = "Project RP MDT",
                ['icon_url'] = 'https://imgur.com/HFPVGUc',
            },
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Project RP MDT", embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
end)

ProjectRP.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function(source, args)
    TriggerEvent('prp-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
