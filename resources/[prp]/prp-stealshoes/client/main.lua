local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterCommand("stealshoes", function()
    TriggerEvent('prp-stealshoes:client:TheftShoe')
end)

RegisterNetEvent('prp-stealshoes:client:TheftShoe', function() -- This could be used in the radialmenu ;)
    local ped = PlayerPedId()
    if not IsPedRagdoll(ped) then
        local player, distance = ProjectRP.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(ped) then
                local oped = GetPlayerPed(player)
                local hasShoes = GetPedDrawableVariation(oped, 6)
                if hasShoes ~= 34 then
                    while not HasAnimDictLoaded("random@domestic") do
                        RequestAnimDict("random@domestic")
                        Wait(1)
                    end
                    TaskPlayAnim(ped, "random@domestic", "pickup_low", 8.00, -8.00, 500, 0, 0.00, 0, 0, 0)
                    TriggerServerEvent("prp-stealshoes:server:TheftShoe", playerId)
                    SetPedComponentVariation(oped, 6, 73, 0, 2)
                else
                    ProjectRP.Functions.Notify("No shoes to been stolen!", "error")
                end
            else
                ProjectRP.Functions.Notify('You can\'t steal shoes in vehicle', "error")
            end
        else
            ProjectRP.Functions.Notify('No one nearby!', "error")
        end
    end
end)

RegisterNetEvent('prp-stealshoes:client:StoleShoe', function(playerId)
    local ped = PlayerPedId()
    local hasShoes = GetPedDrawableVariation(ped, 6)
    if hasShoes ~= 34 then
        SetPedComponentVariation(ped, 6, 34, 0, 2)
        ProjectRP.Functions.Notify("Shoes got robbed lmao", 'primary')
        TriggerServerEvent("prp-stealshoes:server:Complete", playerId)
    else
        ProjectRP.Functions.Notify("Someone tried to steal yo feet", 'primary')
    end
end)
