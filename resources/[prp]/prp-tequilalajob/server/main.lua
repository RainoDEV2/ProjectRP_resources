RegisterServerEvent("prp-tequilalajob:bill:player")
AddEventHandler("prp-tequilalajob:bill:player", function(playerId, amount)
        local biller = ProjectRP.Functions.GetPlayer(source)
        local billed = ProjectRP.Functions.GetPlayer(tonumber(playerId))
        local amount = tonumber(amount)
        if biller.PlayerData.job.name == 'tequilala' then
            if billed ~= nil then
                if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                    if amount and amount > 0 then
                        exports.oxmysql:insert('INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (@citizenid, @amount, @society, @sender, @sendercitizenid)', {
                            ['@citizenid'] = billed.PlayerData.citizenid,
                            ['@amount'] = amount,
                            ['@society'] = biller.PlayerData.job.name,
                            ['@sender'] = biller.PlayerData.charinfo.firstname,
                            ['@sendercitizenid'] = biller.PlayerData.citizenid
                        })
                        TriggerClientEvent('prp-phone:RefreshPhone', billed.PlayerData.source)
                        TriggerClientEvent('ProjectRP:Notify', source, 'Invoice Successfully Sent', 'success')
                        TriggerClientEvent('ProjectRP:Notify', billed.PlayerData.source, 'New Invoice Received')
                    else
                        TriggerClientEvent('ProjectRP:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
                    end
                else
                    TriggerClientEvent('ProjectRP:Notify', source, 'You Cannot Bill Yourself', 'error')
                end
            else
                TriggerClientEvent('ProjectRP:Notify', source, 'Player Not Online', 'error')
            end
        else
            TriggerClientEvent('ProjectRP:Notify', source, 'No Access', 'error')
        end
end)
