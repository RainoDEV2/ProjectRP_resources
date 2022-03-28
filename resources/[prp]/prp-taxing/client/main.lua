local ProjectRP = exports['prp-core']:GetCoreObject()

TriggerEvent('ProjectRP:getObject', function(obj) ProjectRP = obj end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(Config.Time) -- change time of payment // current time is 45 minutes
-- 		TriggerServerEvent('prp-taxing:server:paytaxes')
-- 	end
-- end)

-- RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
-- AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
--     TriggerServerEvent("prp-taxing:server:Display") 
-- end)

-- RegisterCommand('bracket', function()
--     TriggerServerEvent("prp-taxing:server:Display")    
-- end)
