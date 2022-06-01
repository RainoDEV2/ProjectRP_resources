local minGangMemberConnected = 0
local ProjectRP = exports['prp-core']:GetCoreObject()

-- Citizen.CreateThread(function()
--     local result = exports.oxmysql:executeSync('SELECT * FROM sprays', {})
--     if result[1] then
--         for k, v in pairs(result) do
--             Zones["Territories"][k] = {
--                 centre = vector3(v.x + 0.0, v.y + 0.0, v.z + 0.0),
--                 radius = 75.0,
--                 winner = v.gang,
--                 occupants={}
--             }
--         end
--     end

--     Wait(500)

--     TriggerClientEvent("prp-gangs:client:updateTerritories", -1, Zones["Territories"])
-- end)

function checkGroup(table, val)
    for k, v in pairs(table) do
        if val == v.label then
            return true
        end
    end
    return false
end

function removeGroup(tab, val)
    for k, v in pairs(tab) do
        if v.label == val then
            tab[k] = nil
        end
    end
end

function isContested(tab)
    local count = 0
    for k, v in pairs(tab) do
        count = count + 1
    end

    if count > 1 then
        return "contested"
    end
    return ""
end

RegisterNetEvent("prp-gangs:server:updateterritories")
AddEventHandler("prp-gangs:server:updateterritories", function(zone, inside)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local Gang = Player.PlayerData.gang
    local gangMemberConnected = 0
    local Territory = Zones["Territories"][zone]

    if Territory ~= nil then
        -- If they're not in a gang or they're not a cop just ignore them
        if Gang.name ~= "none" then
            if inside then
                if not checkGroup(Territory.occupants, Gang.label) then
                    Territory.occupants[Gang.name] = {
                        label = Gang.label,
                        score = 0
                    }
                else
                    for k, v in pairs(ProjectRP.Functions.GetPlayers()) do
                        local Player = ProjectRP.Functions.GetPlayer(v)
                        if Player ~= nil then
                            if (Player.PlayerData.gang.name == Territory.occupants[Gang.name]) then
                                gangMemberConnected = gangMemberConnected + 1
                            end
                        end
                    end
                    if gangMemberConnected >= minGangMemberConnected then
                        local score = Territory.occupants[Gang.name].score
                        if score < Zones["Config"].minScore and Territory.winner ~= Gang.name then
                            if isContested(Territory.occupants) == "" then
                                Territory.occupants[Gang.name].score = Territory.occupants[Gang.name].score + 1
                                TriggerClientEvent('ProjectRP:Notify',source,"Taking Zone Progress "..Territory.occupants[Gang.name].score.."/"..Zones["Config"].minScore, "success")
                            end
                        else
                            Territory.winner = Gang.name
                            TriggerClientEvent("prp-gangs:client:updateblips", source, zone, Gang.name)
                            Wait(1000)
                        end
                    else
                        --TriggerClientEvent('ProjectRP:Notify',src,Lang:t("error.member_not_connected"),"error")
                    end
                end
            else
                removeGroup(Territory.occupants, Gang.label)
            end
        end
    end
end)
