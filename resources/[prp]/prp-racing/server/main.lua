-----------------------
----   Variables   ----
-----------------------
local ProjectRP = exports['prp-core']:GetCoreObject()
local Races = {}
local AvailableRaces = {}
local LastRaces = {}
local NotFinished = {}

-----------------------
----   Threads     ----
-----------------------
MySQL.ready(function ()
    local races = MySQL.Sync.fetchAll('SELECT * FROM race_tracks', {})
    if races[1] ~= nil then
        for k, v in pairs(races) do
            local Records = {}
            if v.records ~= nil then
                Records = json.decode(v.records)
            end
            Races[v.raceid] = {
                RaceName = v.name,
                Checkpoints = json.decode(v.checkpoints),
                Records = Records,
                Creator = v.creatorid,
                CreatorName = v.creatorname,
                RaceId = v.raceid,
                Started = false,
                Waiting = false,
                Distance = v.distance,
                LastLeaderboard = {},
                Racers = {}
            }
        end
    end
end)

-----------------------
---- Server Events ----
-----------------------
RegisterNetEvent('prp-racing:server:FinishPlayer', function(RaceData, TotalTime, TotalLaps, BestLap)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local RacerName = RaceData.RacerName
    local PlayersFinished = 0
    local AmountOfRacers = 0

    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        if v.Finished then
            PlayersFinished = PlayersFinished + 1
        end
        AmountOfRacers = AmountOfRacers + 1
    end
    local BLap = 0
    if TotalLaps < 2 then
        BLap = TotalTime
    else
        BLap = BestLap
    end

    if LastRaces[RaceData.RaceId] ~= nil then
        LastRaces[RaceData.RaceId][#LastRaces[RaceData.RaceId]+1] =  {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = RacerName
        }
    else
        LastRaces[RaceData.RaceId] = {}
        LastRaces[RaceData.RaceId][#LastRaces[RaceData.RaceId]+1] =  {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = RacerName
        }
    end
    if Races[RaceData.RaceId].Records ~= nil and next(Races[RaceData.RaceId].Records) ~= nil then
        if BLap < Races[RaceData.RaceId].Records.Time then
            Races[RaceData.RaceId].Records = {
                Time = BLap,
                Holder = RacerName
            }
            MySQL.Async.execute('UPDATE race_tracks SET records = ? WHERE raceid = ?',
                {json.encode(Races[RaceData.RaceId].Records), RaceData.RaceId})
                TriggerClientEvent('ProjectRP:Notify', src, string.format("You now hold the record in %s with a time of: %s!", RaceData.RaceName, SecondsToClock(BLap)), 'success')
        end
    else
        Races[RaceData.RaceId].Records = {
            Time = BLap,
            Holder = RacerName
        }
        MySQL.Async.execute('UPDATE race_tracks SET records = ? WHERE raceid = ?',
            {json.encode(Races[RaceData.RaceId].Records), RaceData.RaceId})
            TriggerClientEvent('ProjectRP:Notify', src, string.format("You now hold the record in %s with a time of: %s!", RaceData.RaceName, SecondsToClock(BLap)), 'success')
    end
    AvailableRaces[AvailableKey].RaceData = Races[RaceData.RaceId]
    TriggerClientEvent('prp-racing:client:PlayerFinish', -1, RaceData.RaceId, PlayersFinished, RacerName)
    if PlayersFinished == AmountOfRacers then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceData.RaceId] ~= nil and
            next(NotFinished[RaceData.RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceData.RaceId]) do
                LastRaces[RaceData.RaceId][#LastRaces[RaceData.RaceId]+1] = {
                    TotalTime = v.TotalTime,
                    BestLap = v.BestLap,
                    Holder = v.Holder
                }
            end
        end
        Races[RaceData.RaceId].LastLeaderboard = LastRaces[RaceData.RaceId]
        Races[RaceData.RaceId].Racers = {}
        Races[RaceData.RaceId].Started = false
        Races[RaceData.RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        LastRaces[RaceData.RaceId] = nil
        NotFinished[RaceData.RaceId] = nil
    end
end)

RegisterNetEvent('prp-racing:server:CreateLapRace', function(RaceName, RacerName)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    if IsPermissioned(Player.PlayerData.citizenid, 'create') then 
        if IsNameAvailable(RaceName) then
            TriggerClientEvent('prp-racing:client:StartRaceEditor', source, RaceName, RacerName)
        else
            TriggerClientEvent('ProjectRP:Notify', source, "There is already a race with that name.", 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', source, "You do not have permission to do that.", 'error')
    end
end)

RegisterNetEvent('prp-racing:server:JoinRace', function(RaceData)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local RaceName = RaceData.RaceData.RaceName
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local CurrentRace = GetCurrentRace(Player.PlayerData.citizenid)
    local RacerName = RaceData.RacerName

    print('prp-racing:server:JoinRace', RacerName)
    if CurrentRace ~= nil then
        local AmountOfRacers = 1
        PreviousRaceKey = GetOpenedRaceKey(CurrentRace)
        for k, v in pairs(Races[CurrentRace].Racers) do
            AmountOfRacers = AmountOfRacers + 1
        end
        Races[CurrentRace].Racers[Player.PlayerData.citizenid] = nil
        if (AmountOfRacers - 1) == 0 then
            Races[CurrentRace].Racers = {}
            Races[CurrentRace].Started = false
            Races[CurrentRace].Waiting = false
            table.remove(AvailableRaces, PreviousRaceKey)
            TriggerClientEvent('ProjectRP:Notify', src, "You were the last person in that race so it was canceled.")
            TriggerClientEvent('prp-racing:client:LeaveRace', src, Races[CurrentRace])
        else
            AvailableRaces[PreviousRaceKey].RaceData = Races[CurrentRace]
            TriggerClientEvent('prp-racing:client:LeaveRace', src, Races[CurrentRace])
        end
    end

    Races[RaceId].Waiting = true
    Races[RaceId].Racers[Player.PlayerData.citizenid] = {
        Checkpoint = 0,
        Lap = 1,
        Finished = false,
        RacerName = RacerName,
    }
    AvailableRaces[AvailableKey].RaceData = Races[RaceId]
    TriggerClientEvent('prp-racing:client:JoinRace', src, Races[RaceId], RaceData.Laps, RacerName)
    TriggerClientEvent('prp-racing:client:UpdateRaceRacers', src, RaceId, Races[RaceId].Racers)
    local creatorsource = ProjectRP.Functions.GetPlayerByCitizenId(AvailableRaces[AvailableKey].SetupCitizenId).PlayerData.source
    if creatorsource ~= Player.PlayerData.source then
        TriggerClientEvent('ProjectRP:Notify', creatorsource, "Someone has joined the race.")
    end
end)

RegisterNetEvent('prp-racing:server:LeaveRace', function(RaceData)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local RacerName = RaceData.RacerName
    local RaceName = RaceData.RaceName
    if RaceData.RaceData then
        RaceName = RaceData.RaceData.RaceName
    end

    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local creatorsource = ProjectRP.Functions.GetPlayerByCitizenId(AvailableRaces[AvailableKey].SetupCitizenId).PlayerData.source

    if creatorsource ~= Player.PlayerData.source then
        TriggerClientEvent('ProjectRP:Notify', creatorsource, "Someone has left the race.")
    end

    local AmountOfRacers = 0
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        AmountOfRacers = AmountOfRacers + 1
    end
    if NotFinished[RaceData.RaceId] ~= nil then
        NotFinished[RaceData.RaceId][#NotFinished[RaceData.RaceId]+1] = {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = RacerName
        }
    else
        NotFinished[RaceData.RaceId] = {}
        NotFinished[RaceData.RaceId][#NotFinished[RaceData.RaceId]+1] = {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = RacerName
        }
    end
    Races[RaceId].Racers[Player.PlayerData.citizenid] = nil
    if (AmountOfRacers - 1) == 0 then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceId] ~= nil and next(NotFinished[RaceId]) ~=
            nil then
            for k, v in pairs(NotFinished[RaceId]) do
                if LastRaces[RaceId] ~= nil then
                    LastRaces[RaceId][#LastRaces[RaceId]+1] = {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = v.Holder
                    }
                else
                    LastRaces[RaceId] = {}
                    LastRaces[RaceId][#LastRaces[RaceId]+1] = {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = v.Holder
                    }
                end
            end
        end
        Races[RaceId].LastLeaderboard = LastRaces[RaceId]
        Races[RaceId].Racers = {}
        Races[RaceId].Started = false
        Races[RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        TriggerClientEvent('ProjectRP:Notify', src, "You were the last person in that race so it was canceled.")
        TriggerClientEvent('prp-racing:client:LeaveRace', src, Races[RaceId])
        LastRaces[RaceId] = nil
        NotFinished[RaceId] = nil
    else
        AvailableRaces[AvailableKey].RaceData = Races[RaceId]
        TriggerClientEvent('prp-racing:client:LeaveRace', src, Races[RaceId])
    end
    TriggerClientEvent('prp-racing:client:UpdateRaceRacers', src, RaceId, Races[RaceId].Racers)
end)

RegisterNetEvent('prp-racing:server:SetupRace', function(RaceId, Laps, RacerName)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Races[RaceId] ~= nil then
        if not Races[RaceId].Waiting then
            if not Races[RaceId].Started then
                Races[RaceId].Waiting = true
                local allRaceData = {
                    RaceData = Races[RaceId],
                    Laps = Laps,
                    RaceId = RaceId,
                    SetupCitizenId = Player.PlayerData.citizenid,
                    SetupRacerName = RacerName
                }
                AvailableRaces[#AvailableRaces+1] = allRaceData
                TriggerClientEvent('ProjectRP:Notify', src, "The race was created!", 'success')
                TriggerClientEvent('prp-racing:server:ReadyJoinRace', src, allRaceData)

                CreateThread(function()
                    local count = 0
                    while Races[RaceId].Waiting do
                        Wait(1000)
                        if count < 5 * 60 then
                            count = count + 1
                        else
                            local AvailableKey = GetOpenedRaceKey(RaceId)
                            for cid, _ in pairs(Races[RaceId].Racers) do
                                local RacerData = ProjectRP.Functions.GetPlayerByCitizenId(cid)
                                if RacerData ~= nil then
                                    TriggerClientEvent('ProjectRP:Notify', RacerData.PlayerData.source, "The race timed out and was canceled.", 'error')
                                    TriggerClientEvent('prp-racing:client:LeaveRace', RacerData.PlayerData.source, Races[RaceId])
                                end
                            end
                            table.remove(AvailableRaces, AvailableKey)
                            Races[RaceId].LastLeaderboard = {}
                            Races[RaceId].Racers = {}
                            Races[RaceId].Started = false
                            Races[RaceId].Waiting = false
                            LastRaces[RaceId] = nil
                        end
                    end
                end)
            else
                TriggerClientEvent('ProjectRP:Notify', src, "The race has already started!", 'error')
            end
        else
            TriggerClientEvent('ProjectRP:Notify', src, "The race has already started!", 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, "This race does not exist :(", 'error')
    end
end)

RegisterNetEvent('prp-racing:server:UpdateRaceState', function(RaceId, Started, Waiting)
    Races[RaceId].Waiting = Waiting
    Races[RaceId].Started = Started
end)

RegisterNetEvent('prp-racing:server:UpdateRacerData', function(RaceId, Checkpoint, Lap, Finished)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    Races[RaceId].Racers[CitizenId].Checkpoint = Checkpoint
    Races[RaceId].Racers[CitizenId].Lap = Lap
    Races[RaceId].Racers[CitizenId].Finished = Finished

    TriggerClientEvent('prp-racing:client:UpdateRaceRacerData', -1, RaceId, Races[RaceId])
end)

RegisterNetEvent('prp-racing:server:StartRace', function(RaceId)
    local src = source
    local MyPlayer = ProjectRP.Functions.GetPlayer(src)
    local AvailableKey = GetOpenedRaceKey(RaceId)

    if not RaceId then
        TriggerClientEvent('ProjectRP:Notify', src, "You are not in a race.", 'error')
        return
    end

    if AvailableRaces[AvailableKey].RaceData.Started then
        TriggerClientEvent('ProjectRP:Notify', src, "The race has already started!", 'error')
        return
    end

    AvailableRaces[AvailableKey].RaceData.Started = true
    AvailableRaces[AvailableKey].RaceData.Waiting = false
    for CitizenId, _ in pairs(Races[RaceId].Racers) do
        local Player = ProjectRP.Functions.GetPlayerByCitizenId(CitizenId)
        if Player ~= nil then
            TriggerClientEvent('prp-racing:client:RaceCountdown', Player.PlayerData.source)
        end
    end
end)

RegisterNetEvent('prp-racing:server:SaveRace', function(RaceData)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local RaceId = GenerateRaceId()
    local Checkpoints = {}
    for k, v in pairs(RaceData.Checkpoints) do
        Checkpoints[k] = {
            offset = v.offset,
            coords = v.coords
        }
    end

    Races[RaceId] = {
        RaceName = RaceData.RaceName,
        Checkpoints = Checkpoints,
        Records = {},
        Creator = Player.PlayerData.citizenid,
        CreatorName = RaceData.RacerName,
        RaceId = RaceId,
        Started = false,
        Waiting = false,
        Distance = math.ceil(RaceData.RaceDistance),
        Racers = {},
        LastLeaderboard = {}
    }
    MySQL.Async.insert('INSERT INTO race_tracks (name, checkpoints, creatorid, creatorname, distance, raceid) VALUES (?, ?, ?, ?, ?, ?)',
        {RaceData.RaceName, json.encode(Checkpoints), Player.PlayerData.citizenid, RaceData.RacerName, RaceData.RaceDistance, RaceId})
end)

-----------------------
----   Functions   ----
-----------------------

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    local retval = 0
    if seconds <= 0 then
        retval = "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds / 3600));
        mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
        secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
        retval = hours .. ":" .. mins .. ":" .. secs
    end
    return retval
end


function IsPermissioned(CitizenId, type)
    local Player = ProjectRP.Functions.GetPlayerByCitizenId(CitizenId)

    local HasMaster = Player.Functions.GetItemsByName('fob_racing_master')
    if HasMaster then
        for _, item in ipairs(HasMaster) do
            if item.info.owner == CitizenId and Config.Permissions['fob_racing_master'][type] then
                return true
            end
        end
    end

    local HasBasic = Player.Functions.GetItemsByName('fob_racing_basic')
    if HasBasic then
        for _, item in ipairs(HasBasic) do
            if item.info.owner == CitizenId and Config.Permissions['fob_racing_basic'][type] then
                return true
            end
        end
    end
end

function IsNameAvailable(RaceName)
    local retval = true
    for RaceId, _ in pairs(Races) do
        if Races[RaceId].RaceName == RaceName then
            retval = false
            break
        end
    end
    return retval
end

function HasOpenedRace(CitizenId)
    local retval = false
    for k, v in pairs(AvailableRaces) do
        if v.SetupCitizenId == CitizenId then
            retval = true
        end
    end
    return retval
end

function GetOpenedRaceKey(RaceId)
    local retval = nil
    for k, v in pairs(AvailableRaces) do
        if v.RaceId == RaceId then
            retval = k
            break
        end
    end
    return retval
end

function GetCurrentRace(MyCitizenId)
    local retval = nil
    for RaceId, _ in pairs(Races) do
        for cid, _ in pairs(Races[RaceId].Racers) do
            if cid == MyCitizenId then
                retval = RaceId
                break
            end
        end
    end
    return retval
end

function GetRaceId(name)
    local retval = nil
    for k, v in pairs(Races) do
        if v.RaceName == name then
            retval = k
            break
        end
    end
    return retval
end

function GenerateRaceId()
    local RaceId = "LR-" .. math.random(1111, 9999)
    while Races[RaceId] ~= nil do
        RaceId = "LR-" .. math.random(1111, 9999)
    end
    return RaceId
end

function UseRacingFob(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid

    if item.info.owner == citizenid then
        TriggerClientEvent('prp-racing:Client:OpenMainMenu', source, { type = item.name, name = item.info.name})
    else
        TriggerClientEvent('ProjectRP:Notify', source, "It doesn't seem to respond do you.", "error")
    end
end

ProjectRP.Functions.CreateCallback('prp-racing:server:GetRacingLeaderboards', function(source, cb)
    local Leaderboard = {}
    for RaceId, RaceData in pairs(Races) do
        Leaderboard[RaceData.RaceName] = RaceData.Records
    end
    cb(Leaderboard)
end)

ProjectRP.Functions.CreateCallback('prp-racing:server:GetRaces', function(source, cb)
    cb(AvailableRaces)
end)

ProjectRP.Functions.CreateCallback('prp-racing:server:GetListedRaces', function(source, cb)
    cb(Races)
end)

ProjectRP.Functions.CreateCallback('prp-racing:server:GetRacingData', function(source, cb, RaceId)
    cb(Races[RaceId])
end)

ProjectRP.Functions.CreateCallback('prp-racing:server:HasCreatedRace', function(source, cb)
    cb(HasOpenedRace(ProjectRP.Functions.GetPlayer(source).PlayerData.citizenid))
end)

ProjectRP.Functions.CreateCallback('prp-racing:server:IsAuthorizedToCreateRaces', function(source, cb, TrackName)
    cb(IsPermissioned(ProjectRP.Functions.GetPlayer(source).PlayerData.citizenid, 'create'), IsNameAvailable(TrackName))
end)

ProjectRP.Functions.CreateCallback('prp-racing:server:GetTrackData', function(source, cb, RaceId)
    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ?', {Races[RaceId].Creator})
    if result[1] ~= nil then
        result[1].charinfo = json.decode(result[1].charinfo)
        cb(Races[RaceId], result[1])
    else
        cb(Races[RaceId], {
            charinfo = {
                firstname = "Unknown",
                lastname = "Unknown"
            }
        })
    end
end)

ProjectRP.Commands.Add('createracingfob', 'Create a Racing Fob (Admin)', { {name='type', help='Basic/Master'}, {name='identifier', help='CitizenID or ID'}, {name='Racer Name', help='Racer Name to associate with Fob'} }, true, function(source, args)
    local type = args[1]
    local citizenid = args[2]

    local name = {}
    for i = 3, #args do
        name[#name+1] = args[i]
    end
    name = table.concat(name, ' ')

    local fobTypes = {
        ['basic'] = "fob_racing_basic",
        ['master'] = "fob_racing_master"
    }

    if fobTypes[type:lower()] then 
        type = fobTypes[type:lower()]
    else
        TriggerClientEvent('ProjectRP:Notify', source, "Invalid fob type.", "error")
        return
    end

    if tonumber(citizenid) then
        local Player = ProjectRP.Functions.GetPlayer(tonumber(citizenid))
        if Player then
            citizenid = Player.PlayerData.citizenid
        else
            TriggerClientEvent('ProjectRP:Notify', source, "Citizen by that ID was not found.", "error")
            return
        end
    end

    if #name >= Config.MaxRacerNameLength then
        TriggerClientEvent('ProjectRP:Notify', source, 'The name is too long.', "error")
        return
    end

    if #name <= Config.MinRacerNameLength then
        TriggerClientEvent('ProjectRP:Notify', source, 'The name is too short.', "error")
        return
    end

    ProjectRP.Functions.GetPlayer(source).Functions.AddItem(type, 1, nil, { owner = citizenid, name = name })
    TriggerClientEvent('inventory:client:ItemBox', source, ProjectRP.Shared.Items[type], 'add', 1)
end, 'admin')

ProjectRP.Functions.CreateUseableItem("fob_racing_basic", function(source, item)
    UseRacingFob(source, item)
end)

ProjectRP.Functions.CreateUseableItem("fob_racing_master", function(source, item)
    UseRacingFob(source, item)
end)
