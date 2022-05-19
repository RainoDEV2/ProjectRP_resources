local ProjectRP = exports['prp-core']:GetCoreObject()

ProjectRP.Functions.CreateCallback('prp-multijob:server:getJobs', function(source, cb)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local jobList = {}
    local icon
    MySQL.query('SELECT * FROM player_jobs WHERE cid = ?', {cid}, function(jobs)
        for k, v in pairs(jobs) do
            if Config.Icons[v.job] ~= nil then 
                icon = Config.Icons[v.job]
            else
                icon = Config.DefaultIcon
            end
            table.insert(jobList,
                {
                    job = v.job,
                    salary = ProjectRP.Shared.Jobs[v.job].grades[tostring(v.grade)].payment,
                    jobLabel = ProjectRP.Shared.Jobs[v.job].label,
                    gradeLabel = ProjectRP.Shared.Jobs[v.job].grades[tostring(v.grade)].name,
                    grade = v.grade,
                    icon = icon
                }
            )
        end
        cb(json.encode(jobList))
    end)
end)

RegisterNetEvent('prp-multijob:server:changeJob')
AddEventHandler('prp-multijob:server:changeJob', function(job, grade)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local JobInfo = ProjectRP.Shared.Jobs[job]
    if job == 'police' or job == 'ambulance' then
        Player.Functions.SetJob(job, grade)
        TriggerClientEvent('ProjectRP:Notify', src, 'Your job is now '..JobInfo.label)
    else
        Player.Functions.SetJob(job, grade)
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent("ProjectRP:Client:SetDuty", src, true)
        TriggerClientEvent('ProjectRP:Notify', src, 'Your job is now '..JobInfo.label .. ', you are now on duty')
    end
end)

RegisterNetEvent('prp-multijob:server:newJob')
AddEventHandler('prp-multijob:server:newJob', function(jobInfo)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local canAdd = true
    MySQL.query('SELECT * FROM player_jobs WHERE cid = ?', {cid}, function(jobs)
        for k, v in pairs(jobs) do
            if jobInfo.name == v.job then

                MySQL.execute('UPDATE player_jobs SET grade = ? WHERE job = ? and cid = ?', {jobInfo.grade.level, jobInfo.name, cid})

                canAdd = false
            end
        end
        for k, v in pairs(Config.BlackListedJobs) do
            if jobInfo.name == v then
                canAdd = false
            end
        end
        if canAdd then 
            MySQL.insert('INSERT INTO player_jobs (cid, job, grade) VALUE (?, ?, ?)', {cid, jobInfo.name, jobInfo.grade.level})
        end
    end)
end)

RegisterNetEvent('prp-multijob:server:deleteJob')
AddEventHandler('prp-multijob:server:deleteJob', function(job)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    MySQL.execute('DELETE FROM `player_jobs` WHERE `cid` = ? and `job` = ?', {cid, job})
    TriggerClientEvent('ProjectRP:Notify', src, 'Job Removed', 'error')
    Player.Functions.SetJob('unemployed', 0)
end)

ProjectRP.Commands.Add('removejob', 'Remove a job from the players multijob menu', {{name="id", help="Players ID"},{name="job", help = "Job"}}, false, function(source, args)
    if args[1] ~= nil and args[2] ~= nil then
        local Player = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
        local cid = Player.PlayerData.citizenid
        if Player ~= nil then
            if cid ~= nil then
                MySQL.execute('DELETE FROM `player_jobs` WHERE `cid` = ? and `job` = ?', {cid, args[2]})
                Player.Functions.SetJob('unemployed', 0)
            else
                TriggerClientEvent('ProjectRP:Notify', source, "An Error Occured", "error")
            end
        else
            TriggerClientEvent('ProjectRP:Notify', source, "Player Not Online", "error")
        end
    else
        TriggerClientEvent('ProjectRP:Notify', source, "Incorrect Useage", "error")
    end
end, 'admin')