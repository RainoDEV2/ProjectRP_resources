local ProjectRP = exports['prp-core']:GetCoreObject()
local OnlinePlayers = {}

--- Standard round function
local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--- Add specific jobs here to check. So that unemployed etc doesn't get logged.
local function HasJob(Job)
    if Job == 'police'
    or Job == 'fib'
    or Job == 'ambulance'
    or Job == 'rea'
    or Job == 'realestate'
    or Job == 'burger'
    or Job == 'taxi'
    or Job == 'cardealer'
    or Job == 'mechanic'
    or Job == 'pizza'
    or Job == 'judge'
    or Job == 'lawyer'
    or Job == 'farmer'
    or Job == 'courier'
    or Job == 'vu'
    or Job == 'tequilala'
    or Job == 'fruitpicker'
    or Job == 'builder'
    or Job == 'warehouse'
    or Job == 'reporter'
    or Job == 'trucker'
    or Job == 'tow'
    or Job == 'garbage'
    or Job == 'recycling'
    or Job == 'hotdog'
    or Job == 'catcafe'
    or Job == 'galaxy'
    or Job == 'fightclub'
    or Job == 'taxi' then
        return true
    end
    return false
end

AddEventHandler('ProjectRP:Server:PlayerLoaded', function(Player)
    if not HasJob(Player.PlayerData.job.name) then return end
    OnlinePlayers[#OnlinePlayers + 1] = {
        Name = GetPlayerName(Player.PlayerData.source),
        CID = Player.PlayerData.citizenid,
        Job = Player.PlayerData.job.name,
        Label = Player.PlayerData.job.label,
        Duty = Player.PlayerData.job.onduty,
        StartDate = os.date("%d/%m/%Y %H:%M:%S"),
        StartTime = os.time()
    }
end)

RegisterNetEvent('prp-shiftlog:server:OnPlayerUnload', function()
    local src = source
    local Player = OnlinePlayers[src]

    if not Player then return end -- if this is somehow still nill
    if not HasJob(Player.Job) then return end

    if Player.Duty then
        TriggerEvent('prp-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
        Player.Name, Player.CID, src, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Label, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local Player = OnlinePlayers[src]

    if not Player then return end -- if this is somehow still nill
    if not HasJob(Player.Job) then return end

    if Player.Duty then
        TriggerEvent('prp-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
        Player.Name, Player.CID, src, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Label, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    end
end)

RegisterNetEvent('prp-shiftlog:server:SetPlayerData', function(NewPlayer)
    local src = source
    local OldPlayer = OnlinePlayers[src]

    if not OldPlayer then return end -- if this is somehow still nill

    --- Check if the job has changed
    if NewPlayer.job.label ~= OldPlayer.Label then
        if OldPlayer.Duty then
            OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
            if not HasJob(OldPlayer.Job) then return end
            TriggerEvent('prp-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
            string.format("**%s** (CitizenID: %s | ID: %s) \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
            OldPlayer.Name, OldPlayer.CID, src, OldPlayer.StartDate, os.date("%d/%m/%Y %H:%M:%S"), OldPlayer.Label, round(os.difftime(os.time(), OldPlayer.StartTime) / 60, 2)))
        else
            OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
        end
    end

    --- Check if the duty has changed.
    if not NewPlayer.job.onduty and OldPlayer.Duty then
        OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
        if not HasJob(OldPlayer.Job) then return end
        TriggerEvent('prp-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
        OldPlayer.Name, OldPlayer.CID, src, OldPlayer.StartDate, os.date("%d/%m/%Y %H:%M:%S"), OldPlayer.Label, round(os.difftime(os.time(), OldPlayer.StartTime) / 60, 2)))
    elseif not OldPlayer.Duty and NewPlayer.job.onduty then
        OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
    end
end)