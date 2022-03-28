ProjectRP = exports['prp-core']:GetCoreObject()
PlayerJob = {}

-- Functions

function DrawText3D(x, y, z, text) -- Used Globally
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Events

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    ProjectRP.Functions.TriggerCallback('prp-diving:server:GetBusyDocks', function(Docks)
        PRPBoatshop.Locations["berths"] = Docks
    end)

    ProjectRP.Functions.TriggerCallback('prp-diving:server:GetDivingConfig', function(Config, Area)
        PRPDiving.Locations = Config
        TriggerEvent('prp-diving:client:SetDivingLocation', Area)
    end)

    PlayerJob = ProjectRP.Functions.GetPlayerData().job

    if PlayerJob.name == "police" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(PRPBoatshop.PoliceBoat.x, PRPBoatshop.PoliceBoat.y, PRPBoatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police boat")
        EndTextCommandSetBlipName(PoliceBlip)
        PoliceBlip = AddBlipForCoord(PRPBoatshop.PoliceBoat2.x, PRPBoatshop.PoliceBoat2.y, PRPBoatshop.PoliceBoat2.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police boat")
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

RegisterNetEvent('prp-diving:client:UseJerrycan', function()
    local ped = PlayerPedId()
    local boat = IsPedInAnyBoat(ped)
    if boat then
        local curVeh = GetVehiclePedIsIn(ped, false)
        ProjectRP.Functions.Progressbar("reful_boat", "Refueling boat ..", 20000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            exports['prp-fuel']:SetFuel(curVeh, 100)
            ProjectRP.Functions.Notify('The boat has been refueled', 'success')
            TriggerServerEvent('prp-diving:server:RemoveItem', 'jerry_can', 1)
            TriggerEvent('inventory:client:ItemBox', ProjectRP.Shared.Items['jerry_can'], "remove")
        end, function() -- Cancel
            ProjectRP.Functions.Notify('Refueling has been canceled!', 'error')
        end)
    else
        ProjectRP.Functions.Notify('You are not in a boat', 'error')
    end
end)
