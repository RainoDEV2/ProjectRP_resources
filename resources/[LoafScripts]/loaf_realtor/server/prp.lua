CreateThread(function()
    if Config.Framework ~= "prp" then
        return
    end

    local ProjectRP = exports["prp-core"]:GetCoreObject()

    function Notify(src, msg)
        TriggerClientEvent("ProjectRP:Notify", src, msg)
    end

    function GetIdentifier(src)
        return ProjectRP.Functions.GetPlayer(src).PlayerData.citizenid
    end

    function HasJob(source)
        local job = ProjectRP.Functions.GetPlayer(source).PlayerData.job
        hasJob = job.name == Config.JobName
        isBoss = hasJob and job.isboss
        canCreate = hasJob and job.grade.level >= Config.CreateGrade

        return hasJob, isBoss, canCreate
    end

    function RemoveSocietyMoney(price)
        if GetResourceState("prp-management") == "started" then
            return exports["prp-management"]:RemoveMoney(Config.JobName, price)
        elseif GetResourceState("prp-bossmenu") == "started" then
            local accounts = json.decode(LoadResourceFile("prp-bossmenu", "./accounts.json"))

            if accounts[Config.JobName] and accounts[Config.JobName] >= price then
                TriggerEvent("prp-bossmenu:server:removeAccountMoney", Config.JobName, price)
                return true
            else
                return false
            end
        else
            return true
        end
    end
end)