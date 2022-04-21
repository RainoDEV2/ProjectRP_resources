RegisterCommand('roll', function(source, args, rawCommand)
    -- Interpret the number of sides
    local die = 6
    if args[1] ~= nil and tonumber(args[1]) then
        die = tonumber(args[1])
    end

    -- Roll and add up rolls
    local number = math.random(1,die)

    loadAnimDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1500)
    ClearPedTasks(GetPlayerPed(-1))
    TriggerEvent('3dme:shareDisplay', 'Rolled ' .. number .. '/' .. die, GetPlayerServerId(PlayerId()))
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end

TriggerEvent('chat:addSuggestion', '/roll', 'Bind an emote', {{ name="sides", help="Number of sides"}})
