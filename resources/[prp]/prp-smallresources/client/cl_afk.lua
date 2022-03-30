-- AFK Kick Time Limit (in seconds)
local group = 'user'
local secondsUntilKick = 1800
local ProjectRP = exports['prp-core']:GetCoreObject()
local prevPos, time = nil, nil

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    ProjectRP.Functions.TriggerCallback('prp-afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
end)

RegisterNetEvent('ProjectRP:Client:OnPermissionUpdate')
AddEventHandler('ProjectRP:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

-- Code
-- Citizen.CreateThread(function()
--     while true do
--         Wait(1000)
--         local playerPed = PlayerPedId()
--         if LocalPlayer.state['isLoggedIn'] then
--             if group == 'user' then
--                 currentPos = GetEntityCoords(playerPed, true)
--                 if prevPos ~= nil then
--                     if currentPos == prevPos then
--                         if time ~= nil then
--                             if time > 0 then
--                                 if time == (900) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!', 'error', 10000)
--                                 elseif time == (600) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!', 'error', 10000)
--                                 elseif time == (300) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!', 'error', 10000)
--                                 elseif time == (150) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minutes!', 'error', 10000)   
--                                 elseif time == (60) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. math.ceil(time / 60) .. ' minute!', 'error', 10000) 
--                                 elseif time == (30) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. time .. ' seconds!', 'error', 10000)  
--                                 elseif time == (20) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. time .. ' seconds!', 'error', 10000)    
--                                 elseif time == (10) then
--                                     ProjectRP.Functions.Notify('You are AFK and will be kicked in ' .. time .. ' seconds!', 'error', 10000)                                                                                                            
--                                 end
--                                 time = time - 1
--                             else
--                                 TriggerServerEvent('KickForAFK')
--                             end
--                         else
--                             time = secondsUntilKick
--                         end
--                     else
--                         time = secondsUntilKick
--                     end
--                 end
--                 prevPos = currentPos
--             end
--         end
--     end
-- end)
