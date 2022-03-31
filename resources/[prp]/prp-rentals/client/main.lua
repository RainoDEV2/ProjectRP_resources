local ProjectRP = exports['prp-core']:GetCoreObject()
local SpawnVehicle = false

RegisterNetEvent('prp-rental:openMenu', function()
    exports['prp-menu']:openMenu({
        {
            header = "Rental Vehicles",
            isMenuHeader = true,
        },
        {
            id = 1,
            header = "Return Vehicle ",
            txt = "Return your rented vehicle.",
            params = {
                event = "prp-rental:return",
            }
        },
        {
            id = 2,
            header = "Asterope",
            txt = "$250.00",
            params = {
                event = "prp-rental:spawncar",
                args = {
                    model = 'asterope',
                    money = 250,
                }
            }
        },
        {
            id = 3,
            header = "Bison ",
            txt = "$500.00",
            params = {
                event = "prp-rental:spawncar",
                args = {
                    model = 'bison',
                    money = 500,
                }
            }
        },
        {
            id = 4,
            header = "Sanchez",
            txt = "$750.00",
            params = {
                event = "prp-rental:spawncar",
                args = {
                    model = 'sanchez',
                    money = 750,
                }
            }
        },
    })
end)

CreateThread(function()
    SpawnNPC()
end)


SpawnNPC = function()
    CreateThread(function()
        RequestModel(GetHashKey('a_m_y_business_03'))
        while not HasModelLoaded(GetHashKey('a_m_y_business_03')) do
            Wait(1)
        end
        CreateNPC()   
    end)
end


CreateNPC = function()
    created_ped = CreatePed(5, GetHashKey('a_m_y_business_03') , 109.9739, -1088.61, 28.302, 345.64, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end

RegisterNetEvent('prp-rental:spawncar')
AddEventHandler('prp-rental:spawncar', function(data)
    local money =data.money
    local model = data.model
    local player = PlayerPedId()
    ProjectRP.Functions.SpawnVehicle(model, function(vehicle)
        SetEntityHeading(vehicle, 340.0)
        TaskWarpPedIntoVehicle(player, vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
        SpawnVehicle = true
    end, vector4(111.4223, -1081.24, 29.192,340.0), true)
    Wait(1000)
    local vehicle = GetVehiclePedIsIn(player, false)
    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    vehicleLabel = GetLabelText(vehicleLabel)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('prp-rental:rentalpapers', plate, vehicleLabel, money)
end)

RegisterNetEvent('prp-rental:return')
AddEventHandler('prp-rental:return', function()
    if SpawnVehicle then
        local Player = ProjectRP.Functions.GetPlayerData()
        ProjectRP.Functions.Notify('Returned vehicle!', 'success')
        TriggerServerEvent('prp-rental:removepapers')
        local car = GetVehiclePedIsIn(PlayerPedId(),true)
        NetworkFadeOutEntity(car, true,false)
        Citizen.Wait(2000)
        ProjectRP.Functions.DeleteVehicle(car)
    else 
        ProjectRP.Functions.Notify("No vehicle to return", "error")
    end
    SpawnVehicle = false
end)

CreateThread(function()
    blip = AddBlipForCoord(111.0112, -1088.67, 29.302)
    SetBlipSprite (blip, 56)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.5)
    SetBlipColour (blip, 77)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Vehicle Rental')
    EndTextCommandSetBlipName(blip)
end)
