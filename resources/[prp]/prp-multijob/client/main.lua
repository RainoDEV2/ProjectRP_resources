local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterCommand('jobs', function(source, args)
    local Player = ProjectRP.Functions.GetPlayerData()
    local onDuty = Player.job.onduty
    local job = Player.job.name
    local currentGrade = Player.job.grade.level
    ProjectRP.Functions.TriggerCallback('prp-multijob:server:getJobs', function(result)
        if result ~= nil then 
            openMenu(onDuty, job, result, currentGrade)
        end
    end)
end)

-- RegisterKeyMapping('jobMenu', "Open Multi-Job Menu", "keyboard", Config.Keybind)

function openMenu(onDuty, job, jobInfo, currentGrade)
    SendNUIMessage({
        action = "open",
        duty = onDuty,
        jobInfo = jobInfo,
        job = job,
        currentGrade = currentGrade
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('close', function() 
    SetNuiFocus(false, false)
end)

RegisterNUICallback('deleteJob', function(data)
    TriggerServerEvent('prp-multijob:server:deleteJob', data.job)
end)

RegisterNUICallback('changeJob', function(data) 
    TriggerServerEvent('prp-multijob:server:changeJob', data.job, data.grade)
end)

RegisterNUICallback('toggleDuty', function() 
    local player = ProjectRP.Functions.GetPlayerData()
    local jobName = player.job.name
    if jobName ~= 'police' and jobName ~= 'ambulance' then 
        TriggerServerEvent("ProjectRP:ToggleDuty")
    else
        ProjectRP.Functions.Notify('Please use the duty system at the station', 'error') 
    end
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    TriggerServerEvent('prp-multijob:server:newJob', JobInfo)
end)