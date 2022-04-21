local ProjectRP = exports['prp-core']:GetCoreObject()

local function IsTargetDead(playerId)
    local retval = false
    ProjectRP.Functions.TriggerCallback('police:server:isPlayerDead', function(result)
        retval = result
    end, playerId)
    Wait(100)
    return retval
end

RegisterNetEvent('prp-stealshoes:client:TheftShoe', function() -- This could be used in the radialmenu ;)
    local ped = PlayerPedId()
    if not IsPedRagdoll(ped) then
        local player, distance = ProjectRP.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(ped) then
                local oped = GetPlayerPed(player)
                if (IsEntityPlayingAnim(oped, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(oped, "dead", "dead_a", 3) or IsEntityPlayingAnim(oped, "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(oped, "amb@code_human_cower@male@base", "base", 3) or  IsEntityPlayingAnim(oped, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(oped, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(oped, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(oped, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(oped, "missfbi5ig_22", "hands_up_loop_scientist", 3) ) or IsTargetDead(playerId) then
                    local hasShoes = GetPedDrawableVariation(oped, 6)
                    if hasShoes ~= 73 then
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
    if hasShoes ~= 73 then
        SetPedComponentVariation(ped, 6, 73, 0, 2)
        ProjectRP.Functions.Notify("Shoes got robbed lmao", 'primary')
        TriggerServerEvent("prp-stealshoes:server:Complete", playerId)
    else
        ProjectRP.Functions.Notify("Someone tried to steal yo feet", 'primary')
    end
end)
