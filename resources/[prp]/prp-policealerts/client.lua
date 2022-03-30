local ProjectRP = exports['prp-core']:GetCoreObject()


local isLoggedIn = false
PlayerData = {}
PlayerJob = {}

-- Code

Citizen.CreateThread(function()
    Wait(100)
    if ProjectRP.Functions.GetPlayerData() ~= nil then
        PlayerData = ProjectRP.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if JobInfo.name == "police" then
        if PlayerJob.onduty then
            PlayerJob.onduty = false
        end
    end
    PlayerJob.onduty = true
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData =  ProjectRP.Functions.GetPlayerData()
    PlayerJob = ProjectRP.Functions.GetPlayerData().job
end)

RegisterNetEvent('prp-policealerts:ToggleDuty')
AddEventHandler('prp-policealerts:ToggleDuty', function(Duty)
    PlayerJob.onduty = Duty
end)

RegisterNetEvent('prp-policealerts:client:AddPoliceAlert')
AddEventHandler('prp-policealerts:client:AddPoliceAlert', function(data, forBoth)
    if forBoth then
        if (PlayerJob.name == "police" or PlayerJob.name == "doctor" or PlayerJob.name == "ambulance") and PlayerJob.onduty then
            if data.alertTitle == "Assist collegue" or data.alertTitle == "Assist Ambulance" or data.alertTitle == "Doctor assistance" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police', 'ambulance'}, 
                coords = data.coords,
                title = data.alertTitle,
                message = data.msg,
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                blip = {
                    sprite = 431, 
                    scale = 1.2, 
                    colour = 3,
                    flashes = false, 
                    text = '911 - Blain County Savings bank robbery attempt',
                    time = (5*60*1000),
                    sound = 3,
                }
            })
        end
    else
        if (PlayerJob.name == "police" and PlayerJob.onduty) then
            if data.alertTitle == "Assist collegue" or data.alertTitle == "Assist Ambulance" or data.alertTitle == "Doctor assistance" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police', 'ambulance'}, 
                coords = data.coords,
                title = data.alertTitle,
                message = data.msg,
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                blip = {
                    sprite = 431, 
                    scale = 1.2, 
                    colour = 3,
                    flashes = false, 
                    text = '911 - Blain County Savings bank robbery attempt',
                    time = (5*60*1000),
                    sound = 3,
                }
            })
        end 
    end
end)

RegisterNUICallback('SetWaypoint', function(data)
    local coords = data.coords

    SetNewWaypoint(coords.x, coords.y)
    ProjectRP.Functions.Notify('GPS set!')
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    MouseActive = false
end)

-- Citizen.CreateThread(function()
--     Wait(500)
--     local ped = GetPlayerPed(-1)
--     local veh = GetVehiclePedIsIn(ped)

--     exports["vstancer"]:SetVstancerPreset(veh, -0.8, 0.0, -0.8, 0.0)
-- end)


-- #The max value you can increase or decrease the front Track Width
-- frontMaxOffset=0.25

-- #The max value you can increase or decrease the front Camber
-- frontMaxCamber=0.20

-- #The max value you can increase or decrease the rear Track Width
-- rearMaxOffset=0.25

-- #The max value you can increase or decrease the rear Camber
-- rearMaxCamber=0.20