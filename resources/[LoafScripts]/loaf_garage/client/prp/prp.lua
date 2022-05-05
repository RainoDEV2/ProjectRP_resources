CreateThread(function()
    if Config.Framework ~= "prp" then
        return
    end

    while not ProjectRP do
        Wait(500)
        ProjectRP = exports["prp-core"]:GetCoreObject()
    end
    while not ProjectRP.Functions.GetPlayerData() or not ProjectRP.Functions.GetPlayerData().job do
        Wait(500)
    end

    function Notify(msg)
        ProjectRP.Functions.Notify(msg)
    end

    function GetJob()
        return ProjectRP.Functions.GetPlayerData().job.name
    end

    loaded = true
end)