local ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('tdpd:server:getCops', function(source, cb)
	amount = 0
    for k, v in pairs(ProjectRP.Functions.GetPRPPlayers()) do
        if TDPD.Utils.hasJob(v.PlayerData.job.name) and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

RegisterServerEvent('tdpd:server:requestPD')
AddEventHandler('tdpd:server:requestPD', function(blipName)
    local src = source
    for k, v in pairs(ProjectRP.Functions.GetPRPPlayers()) do
        if TDPD.Utils.hasJob(v.PlayerData.job.name) and v.PlayerData.job.onduty then
            local cid = v.PlayerData.citizenid
            TriggerEvent('prp-phone:server:sendNewMailToOffline', cid, {
                sender = TDPD.Config.EmailSender,
                subject = TDPD.Config.EmailSubject,
                message = TDPD.Config.EmailMessage .. blipName .. '.',
                button = {}
            })
        end
    end
end)