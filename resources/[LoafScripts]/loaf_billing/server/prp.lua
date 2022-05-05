CreateThread(function()
    if Config.Framework ~= "prp" then
        return
    end

    local ProjectRP = exports["prp-core"]:GetCoreObject()

    function Notify(source, message)
        TriggerClientEvent("ProjectRP:Notify", source, message)
    end

    function GetPlayerFromIdentifier(identifier)
        return ProjectRP.Functions.GetPlayerByCitizenId(identifier)?.PlayerData.source
    end

    function GetIdentifier(source)
        return ProjectRP.Functions.GetPlayer(source)?.PlayerData.citizenid
    end

    function GetCompanyName(job)
        return job
    end

    function PayMoney(source, amount)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        if qPlayer?.Functions.GetMoney("cash") >= amount then 
            qPlayer.Functions.RemoveMoney("cash", amount, "loaf-billing")
            return true
        elseif qPlayer?.Functions.GetMoney("bank") >= amount then 
            qPlayer.Functions.RemoveMoney("bank", amount, "loaf-billing")
            return true
        end
        
        return false
    end

    function GetName(source)
        local qPlayer = ProjectRP.Functions.GetPlayer(source)
        return ("%s %s"):format(qPlayer.PlayerData.charinfo.firstname, qPlayer.PlayerData.charinfo.lastname)
    end

    function HasJob(source, job)
        return ProjectRP.Functions.GetPlayer(source)?.PlayerData.job.name == job
    end

    function AddCompanyMoney(company, amount)
        if GetResourceState("prp-management") == "started" then
            exports["prp-management"]:AddMoney(company, amount)
        elseif GetResourceState("prp-bossmenu") == "started" then
            TriggerEvent("prp-bossmenu:server:addAccountMoney", company, amount)
        end
    end
end)