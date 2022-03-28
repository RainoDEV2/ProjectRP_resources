local ProjectRP = exports['prp-core']:GetCoreObject()
local group = Config.Group

-- Check if is decorating --

local IsDecorating = false

RegisterNetEvent('prp-anticheat:client:ToggleDecorate', function(bool)
  IsDecorating = bool
end)

-- Few frequently used locals --

local flags = 0
local isLoggedIn = false

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    ProjectRP.Functions.TriggerCallback('prp-anticheat:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    isLoggedIn = false
    IsDecorating = false
    flags = 0
end)





RegisterNetEvent('prp-anticheat:client:NonRegisteredEventCalled', function(reason, CalledEvent)
    local player = PlayerId()

    TriggerServerEvent('prp-anticheat:server:banPlayer', reason)
    TriggerServerEvent("prp-log:server:CreateLog", "anticheat", "Player banned! (Not really of course, this is a test duuuhhhh)", "red", "** @everyone " ..GetPlayerName(player).. "** has event **"..CalledEvent.."tried to trigger (LUA injector!)")
end)
