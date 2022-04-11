RegisterServerEvent('prp:ReportBugReport')
AddEventHandler('prp:ReportBugReport', function(msgData, msgError, resource)
    local src = source


    TriggerEvent("prp-log:server:CreateLog", "bugreport", "[BugReport]", "yellow", "** ID: ".. source .. "\r Name: " .. GetPlayerName(source) .."\r** **Data**: ``"..msgData.."``\r  **Error**: ``"..msgError.."``\r  **Resource**: ``"..resource.."``")
end)