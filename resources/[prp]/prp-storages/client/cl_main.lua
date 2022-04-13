local ProjectRP, LoggedIn = Config.CoreExport, false
local CurrentStorageId = nil

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function() 
        ProjectRP.Functions.TriggerCallback('ProjectRP/server/get-config', function(ConfigData)
           Config = ConfigData
        end)
        Citizen.Wait(250)
        TriggerServerEvent('ProjectRP/server/setup-containers')
   
        Citizen.Wait(450)
        LoggedIn = true
    end)
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- [ Code ] --


-- [ Threads ] --

local storageshitsleep = 3500
Citizen.CreateThread(function()
    

    while true do
            for k, v in pairs(Config.StorageContainers) do

                local Distance = #(GetEntityCoords(PlayerPedId()) - vector3(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z']))

                if Distance <= 3.5 and IsAuthorized(v['Owner'], v['KeyHolders']) then
                    DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.15, '~g~E~s~ - Storage ('..v['SName']..')')
                    if IsControlJustReleased(0, 38) then
                        CurrentStorageId = v['SName']
                        OpenKeyPad()
                    end
                end
            end
        Citizen.Wait(storageshitsleep)
    end
end)


-- [ Functions ] --

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function IsAuthorized(CitizenId, KeyHolders)
    local Retval = false
    if ProjectRP.Functions.GetPlayerData().citizenid == CitizenId then
        Retval = true
    end
    return Retval
end

function OpenKeyPad()
    SendNUIMessage({
        action = "open"
    })
    SetNuiFocus(true, true)    
end

local function OpenStorage(StorageId)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "storage_"..StorageId, {
        maxweight = Config.MaxStashWeight,
        slots = Config.StashSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "storage_"..StorageId)
end

local function IsRealEstate()
    local Retval = false
    if ProjectRP.Functions.GetPlayerData().job.name == Config.EstateJob then
      Retval = true
    end
    return Retval
end

-- RegisterCommand('keypad', function(source, args, RawCommand)
--     OpenKeyPad()
-- end)

-- [ NUI Callbacks ] --

RegisterNUICallback("CheckPincode", function(data, cb)
    ProjectRP.Functions.TriggerCallback('ProjectRP/server/check-pincode', function(AcceptedPincode)
        if AcceptedPincode then
            OpenStorage(CurrentStorageId)
        else
            ProjectRP.Functions.Notify('You have entered a wrong pincode..', 'error')
        end
    end, tonumber(data.pincode), CurrentStorageId)
end)

RegisterNUICallback("Close", function(data, cb)
    SetNuiFocus(false, false)
end)

-- [ Events ] --

RegisterNetEvent('ProjectRP/client/create-storage', function(PinCode, TPlayer)
    if IsRealEstate() then
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local PlayerHeading = GetEntityHeading(PlayerPedId())
        local CoordsTable = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading}
        TriggerServerEvent('ProjectRP/server/add-new-storage', CoordsTable, PinCode, TPlayer)
    else
        ProjectRP.Functions.Notify('And what are you doing exactly?', 'error')
    end
end)

RegisterNetEvent("ProjectRP/client/update-config", function(ContainerData)
    Config.StorageContainers = ContainerData
end)
















































local success = nil
local await = false
RegisterNUICallback("dataPosts", function(data, cb)
    SetNuiFocus(false, false)
    -- print(json.encode(data))
    success = data.data
    -- print("success: "..success)
    await = false
    cb('ok')
end)

RegisterNUICallback("cancels", function()
    SetNuiFocus(false)
    success = nil
    await = false
end)


function Input(data)
    if not data or await then 
        return 
    end
    Wait(250)
    success = nil
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = "openContainer",
        Main = data.Banner
    })
    await = true
    while await do 
        Wait(0) 
    end
    -- print("await false")
    -- print("thingy "..success)
    -- print("what is success"..success)
        if success ~= nil then
            -- print("returning "..success)
            return success
        end
    -- print("returning nil" )
    return nil
end


-- RegisterCommand("typeshit", function(source,args,rawCommand)
--    local shit = Input({Banner = "ZT"})
-- --    print("sadasdasd "..shit)
-- end)

exports("Input", Input)
