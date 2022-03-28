--███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
--██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
--██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


ESX, ProjectRP = nil, nil

if Config.Framework == 'esx' then
    TriggerEvent(Config.FrameworkTriggers.main, function(obj) ESX = obj end)
    
elseif Config.Framework == 'qbcore' then
    TriggerEvent(Config.FrameworkTriggers.main, function(obj) ProjectRP = obj end)
    if ProjectRP == nil then
        ProjectRP = exports[Config.FrameworkTriggers.resource_name]:GetCoreObject()
    end
    
elseif Config.Framework == 'other' then
    --add your own code here.
end


function GetIdentifier(source)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.identifier

    elseif Config.Framework == 'qbcore' then
        local xPlayer = ProjectRP.Functions.GetPlayer(source)
        return xPlayer.PlayerData.citizenid

    elseif Config.Framework == 'other' then
        return GetPlayerIdentifiers(source)[1] --return your identifier here (string).

    end
end

function GetJob(source)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.name
    
    elseif Config.Framework == 'qbcore' then
        local xPlayer = ProjectRP.Functions.GetPlayer(source)
        return xPlayer.PlayerData.job.name

    elseif Config.Framework == 'other' then
        return 'unemployed' --return the players job name (string).

    end
end

function CheckJob(source, job)
    if CheckMultiJobs(job) then
        if Config.DutyLocalsMethod then
            return self[source].on_duty
        else
            return true
        end
    else
        return false
    end
end

function RemoveMoney(source, amount)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeAccountMoney('bank', amount)

    elseif Config.Framework == 'qbcore' then
        local xPlayer = ProjectRP.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveMoney('bank', amount, 'Speeding fine')

    elseif Config.Framework == 'other' then
        --remove money from a player.
    end
end


--███╗   ███╗ █████╗ ██╗███╗   ██╗
--████╗ ████║██╔══██╗██║████╗  ██║
--██╔████╔██║███████║██║██╔██╗ ██║
--██║╚██╔╝██║██╔══██║██║██║╚██╗██║
--██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
--╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝


RegisterServerEvent('cd_dispatch:PlayerLoaded')
AddEventHandler('cd_dispatch:PlayerLoaded', function()
    local _source = source
    if not self then return end
    local data = GetCharacterInfo(_source)
    self[_source] = {}
    self[_source].source = _source
    self[_source].char_name = data.char_name
    self[_source].callsign = data.callsign
    self[_source].phone_number = data.phone_number
    self[_source].job = GetJob(_source)
    self[_source].radio_channel = 0
    self[_source].vehicle = 'foot'
    self[_source].status = 'avaliable'
    if Config.DutyLocalsMethod then
        if Config.Framework == 'esx' then
            self[_source].on_duty = false
        elseif Config.Framework == 'qbcore' then
            self[_source].on_duty = ProjectRP.Functions.GetPlayer(_source).PlayerData.job.onduty
        end
    else
        self[_source].on_duty = true
    end
    TriggerClientEvent('cd_dispatch:SendSourceData', _source, self[_source], DispatcherData.active)
    PlayerBlipsActions(_source, 'update')
    if CheckMultiJobs(self[_source].job) then
        RefreshLargeUI(self[_source].job)
    end
end)

function GetCharacterInfo(source)
    local identifier = GetIdentifier(source)
    local data = {}
    data.char_name, data.callsign, data.phone_number = L('unknown'), L('unknown'), ' '

    if Config.Framework == 'esx' then 
        local Result1 = DatabaseQuery('SELECT firstname, lastname, phone_number FROM users WHERE identifier="'..identifier..'"')
        if Result1 and Result1[1] and Result1[1].firstname and Result1[1].lastname then
            data.char_name = Result1[1].firstname..' '..Result1[1].lastname
            if Result1[1].phone_number then
                data.phone_number = Result1[1].phone_number
            end
        end

        local Result2 = DatabaseQuery('SELECT callsign FROM cd_dispatch WHERE identifier="'..identifier..'"')
        if Result2 and Result2[1] and Result2[1].callsign then
            data.callsign = Result2[1].callsign
        end
    
    elseif Config.Framework == 'qbcore' then
        local xPlayer = ProjectRP.Functions.GetPlayer(source)
        if xPlayer and xPlayer.PlayerData.charinfo.firstname and xPlayer.PlayerData.charinfo.lastname then
            data.char_name = xPlayer.PlayerData.charinfo.firstname..' '..xPlayer.PlayerData.charinfo.lastname
            if xPlayer.PlayerData.charinfo.phone then
                data.phone_number = xPlayer.PlayerData.charinfo.phone
            end
        end

        local Result2 = DatabaseQuery('SELECT callsign FROM cd_dispatch WHERE identifier="'..identifier..'"')
        if Result2 and Result2[1] and Result2[1].callsign then
            data.callsign = Result2[1].callsign
        end
        
    
    elseif Config.Framework == 'other' then
        --add your own code here.

    end
    return data
end

function SetCallsign(source, callsign)
    local identifier = GetIdentifier(source)
    local Result = DatabaseQuery('SELECT callsign FROM cd_dispatch WHERE identifier="'..identifier..'"')
    if Result and Result[1] and Result[1].callsign then
        DatabaseQuery('UPDATE cd_dispatch SET callsign="'..callsign..'" WHERE identifier="'..identifier..'"')
    else
        DatabaseQuery('INSERT INTO cd_dispatch (identifier, callsign) VALUES ("'..identifier..'", "'..callsign..'")')
    end
end

RegisterServerEvent('cd_dispatch:JobSet')
AddEventHandler('cd_dispatch:JobSet', function(job)
    local _source = source
    if self and self[_source] and type(job) == 'string' then
        local old_job = self[_source].job
        self[_source].job = job
        PlayerBlipsActions(_source, 'update')
        if CheckMultiJobs(job) then
            RefreshLargeUI(job)
            TriggerClientEvent('cd_dispatch:SendSourceData', _source, self[_source], DispatcherData.active)
        end
        if CheckMultiJobs(old_job) then
            RefreshLargeUI(old_job)
        end
    end
end)

function PlayerDropped(source)
    if self and source and self[source] then
        PlayerBlipsActions(source, 'remove')
        if self[source].dispatcher then
            TriggerEvent('cd_dispatch:DispatcherToggle', false, self[source].job)
        end
        if CheckMultiJobs(self[source].job) then
            RefreshLargeUI(self[source].job)
        end
        Citizen.Wait(2000)
        self[source] = nil
    end
end


--██████╗  █████╗ ██████╗ ██╗ ██████╗      ██████╗██╗  ██╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██╗     
--██╔══██╗██╔══██╗██╔══██╗██║██╔═══██╗    ██╔════╝██║  ██║██╔══██╗████╗  ██║████╗  ██║██╔════╝██║     
--██████╔╝███████║██║  ██║██║██║   ██║    ██║     ███████║███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██║     
--██╔══██╗██╔══██║██║  ██║██║██║   ██║    ██║     ██╔══██║██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██║     
--██║  ██║██║  ██║██████╔╝██║╚██████╔╝    ╚██████╗██║  ██║██║  ██║██║ ╚████║██║ ╚████║███████╗███████╗
--╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝ ╚═════╝      ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚══════╝


RegisterServerEvent('cd_dispatch:GetRadioChannel')
AddEventHandler('cd_dispatch:GetRadioChannel', function(radio_channel)
    local _source = source
    if radio_channel ~= nil and CheckJob(_source, self[_source].job) and self and self[_source] then
        self[_source].radio_channel = radio_channel
        RefreshLargeUI(self[_source].job)
    end
end)


--███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


function Notification(source, notif_type, message)
    if notif_type and message then
        if Config.NotificationType.client == 'esx' then
            TriggerClientEvent('esx:showNotification', source, message)
        
        elseif Config.NotificationType.client == 'qbcore' then
            if notif_type == 1 then
                TriggerClientEvent('ProjectRP:Notify', source, message, 'success')
            elseif notif_type == 2 then
                TriggerClientEvent('ProjectRP:Notify', source, message, 'primary')
            elseif notif_type == 3 then
                TriggerClientEvent('ProjectRP:Notify', source, message, 'error')
            end
        
        elseif Config.NotificationType.client == 'mythic_old' then
            if notif_type == 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'success', text = message, length = 10000})
            elseif notif_type == 2 then
                TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'inform', text = message, length = 10000})
            elseif notif_type == 3 then
                TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'error', text = message, length = 10000})
            end

        elseif Config.NotificationType.client == 'mythic_new' then
            if notif_type == 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            elseif notif_type == 2 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            elseif notif_type == 3 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            end

        elseif Config.NotificationType.client == 'chat' then
                TriggerClientEvent('chatMessage', source, message)

        elseif Config.NotificationType.client == 'other' then
            --add your own notification.

        end
    end
end


-- ██████╗ ████████╗██╗  ██╗███████╗██████╗ 
--██╔═══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
--██║   ██║   ██║   ███████║█████╗  ██████╔╝
--██║   ██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
--╚██████╔╝   ██║   ██║  ██║███████╗██║  ██║
-- ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝


AddEventHandler('playerDropped', function()
    PlayerDropped(source)
end)

RegisterServerEvent('esx:cd_multicharacter:SwitchCharacter')
AddEventHandler('esx:cd_multicharacter:SwitchCharacter', function(_source)
	if type(_source) ~= 'number' then _source = source end
	PlayerDropped(_source)
end)

RegisterServerEvent('cd_donatorshop:CharacterNameChanged')
AddEventHandler('cd_donatorshop:CharacterNameChanged', function(new_name, _source)
	if type(_source) ~= 'number' then _source = source end
	if self and self[_source] then
        self[_source].char_name = new_name
        PlayerBlipsActions(_source, 'update')
    end
end)

RegisterNetEvent('cd_dispatch:OnDutyChecks')
AddEventHandler('cd_dispatch:OnDutyChecks', function(boolean)
    local _source = source
    while not self do Wait(1000) end
    if self[_source] and type(boolean) == 'boolean' then
        self[_source].on_duty = boolean
        if boolean then
            PlayerBlipsActions(_source, 'update')
        else
            PlayerBlipsActions(_source, 'remove')
        end
    end
end)

RegisterServerEvent('cd_dispatch:AddNotification')
AddEventHandler('cd_dispatch:AddNotification', function(data)
    for c, d in pairs(self) do
        for cc, dd in pairs(data.job_table) do
            if d.job == dd then
                TriggerClientEvent('cd_dispatch:AddNotification', d.source, data)
            end
        end
    end
end)