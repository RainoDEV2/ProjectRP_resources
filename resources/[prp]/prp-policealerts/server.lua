local ProjectRP = exports['prp-core']:GetCoreObject()


RegisterNetEvent('prp-policealerts:server:AddPoliceAlert')
AddEventHandler('prp-policealerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('prp-policealerts:client:AddPoliceAlert', -1, data, forBoth)
end)