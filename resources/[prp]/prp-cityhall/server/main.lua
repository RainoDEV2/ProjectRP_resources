local DrivingSchools = {
    
}

RegisterServerEvent('prp-cityhall:server:requestId')
AddEventHandler('prp-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local info = {}
    if identityData.item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class C Driver License"
    elseif identityData.item == "weaponlicense" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    end

    Player.Functions.AddItem(identityData.item, 1, nil, info)

    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items[identityData.item], 'add')
end)


RegisterServerEvent('prp-cityhall:server:getIDs')
AddEventHandler('prp-cityhall:server:getIDs', function()
    local src = source
    GiveStarterItems(src)
end)


RegisterServerEvent('prp-cityhall:server:sendDriverTest')
AddEventHandler('prp-cityhall:server:sendDriverTest', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k, v in pairs(DrivingSchools) do 
        local SchoolPlayer = ProjectRP.Functions.GetPlayerByCitizenId(v)
        if SchoolPlayer ~= nil then 
            TriggerClientEvent("prp-cityhall:client:sendDriverEmail", SchoolPlayer.PlayerData.source, Player.PlayerData.charinfo)
        else
            local mailData = {
                sender = "Township",
                subject = "Driving lessons request",
                message = "Hello,<br /><br />We have just received a message that someone wants to take driving lessons.<br />If you are willing to teach, please contact us:<br />Naam: <strong>".. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "<br />Telephone number: <strong>"..Player.PlayerData.charinfo.phone.."</strong><br/><br/>Kind regards,<br />City of Los Santos",
                button = {}
            }
            TriggerEvent("prp-phone:server:sendNewEventMail", v, mailData)
        end
    end
    TriggerClientEvent('ProjectRP:Notify', src, 'An email has been sent to driving schools, and you will be contacted automatically', "success", 5000)
end)

local AvailableJobs = {
    "farmer",
    "fruitpicker",
    "courier",
    "builder",
    "warehouse",
    "trucker",
    "taxi",
    "tow",
    "reporter",
    "garbage",
}

function IsAvailableJob(job)
    local retval = false
    for k, v in pairs(AvailableJobs) do
        if v == job then
            retval = true
        end
    end
    return retval
end

RegisterServerEvent('prp-cityhall:server:ApplyJob')
AddEventHandler('prp-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local Ped = GetPlayerPed(src)
    local PedCoords = GetEntityCoords(Ped)
    local JobInfo = ProjectRP.Shared.Jobs[job]

    

    Player.Functions.SetJob(job, 0)
    TriggerClientEvent('ProjectRP:Notify', src, 'Congratulations with your new job! ('..JobInfo.label..')')
end)


-- ProjectRP.Commands.Add("drivinglicense", "Give a driver's license to someone", {{"id", "ID of a person"}}, true, function(source, args)
--     local Player = ProjectRP.Functions.GetPlayer(source)

--         local SearchedPlayer = ProjectRP.Functions.GetPlayer(tonumber(args[1]))
--         if SearchedPlayer ~= nil then
--             local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
--             if not driverLicense then
--                 local licenses = {
--                     ["driver"] = true,
--                     ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]
--                 }
--                 SearchedPlayer.Functions.SetMetaData("licences", licenses)
--                 TriggerClientEvent('ProjectRP:Notify', SearchedPlayer.PlayerData.source, "You have passed! Pick up your driver's license at the town hall", "success", 5000)
--             else
--                 TriggerClientEvent('ProjectRP:Notify', src, "Can't give driver's license ..", "error")
--             end
--         end

-- end)

function GiveStarterItems(source)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    for k, v in pairs(ProjectRP.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, 1, false, info)
    end
end

function IsWhitelistedSchool(citizenid)
    local retval = false
    for k, v in pairs(DrivingSchools) do 
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

RegisterServerEvent('prp-cityhall:server:banPlayer')
AddEventHandler('prp-cityhall:server:banPlayer', function()
    local src = source
    TriggerClientEvent('chatMessage', -1, "PRP Anti-Cheat", "error", GetPlayerName(src).." has been banned for sending POST Request's ")
    exports.oxmysql:insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        ProjectRP.Functions.GetIdentifier(src, 'license'),
        ProjectRP.Functions.GetIdentifier(src, 'discord'),
        ProjectRP.Functions.GetIdentifier(src, 'ip'),
        'Abuse localhost:13172 For POST Requests',
        2145913200,
        GetPlayerName(src)
    })
    DropPlayer(src, 'Attempting To Exploit')
end)
