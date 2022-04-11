local currentLocation = 0
currentBlip = nil
local isWorking = false

-- Functions

local function CreateJobBlip()
    if currentLocation ~= 0 then
        if DoesBlipExist(currentBlip) then
            RemoveBlip(currentBlip)
        end
        currentBlip = AddBlipForCoord(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z)

        SetBlipSprite (currentBlip, 402)
        SetBlipDisplay(currentBlip, 4)
        SetBlipScale  (currentBlip, 0.8)
        SetBlipAsShortRange(currentBlip, true)
        SetBlipColour(currentBlip, 1)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Jobs[currentJob])
        EndTextCommandSetBlipName(currentBlip)

        local Chance = math.random(100)
        local Odd = math.random(100)
        if Chance == Odd then
            TriggerServerEvent('ProjectRP:Server:AddItem', 'phone', 1)
            TriggerEvent('inventory:client:ItemBox', ProjectRP.Shared.Items["phone"], "add")
            ProjectRP.Functions.Notify("You found a phone..", "success")
        end
    end
end

local function JobDone()
    if math.random(1, 100) <= 50 then
        ProjectRP.Functions.Notify("You've worked some time off your sentence.")
        jailTime = jailTime - math.random(1, 2)
    end
    local newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    while (newLocation == currentLocation) do
        Wait(100)
        newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    end
    currentLocation = newLocation
    CreateJobBlip()
end

local function jobstart(currentJob, currentLocation)
    if Config.UseTarget then
        exports['prp-target']:AddBoxZone("electricianwork", vector3(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z), 1.5, 1.6, {
            name = "electricianwork",
            heading = 12.0,
            debugPoly = false,
            minZ = 19,
            maxZ = 219,
        }, {
            options = {
            {
                type = "client",
                event = "prp-prison:electrician:work",
                icon = 'fas fa-swords-laser',
                label = 'Do Electrician Work',
            }
            },
            distance = 2.5,
        })
    else
        CreateThread(function()
            local electricityzone = BoxZone:Create(vector3(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z), 3.0, 5.0, {
                name="electricity",
                debugPoly=false,
            })
            electricityzone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['prp-core']:DrawText('[E] Electricity Work', 'left')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("prp-prison:electrician:work")
                        electricityzone:destroy()
                    end
                else
                    exports['prp-core']:HideText()
                end
            end)
        end)
    end
end

-- Threads

RegisterNetEvent('prp-prison:electrician:work')
AddEventHandler('prp-prison:electrician:work', function()
    isWorking = true
    ProjectRP.Functions.Progressbar("work_electric", "Working on electricity..", math.random(5000, 10000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        isWorking = false
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        JobDone()
    end, function() -- Cancel
        isWorking = false
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        ProjectRP.Functions.Notify("Process Canceled..", "error")
    end)
end)

CreateThread(function()
    while true do
        Wait(0)
        if inJail and currentJob ~= nil then
            if currentLocation ~= 0 then
                if not DoesBlipExist(currentBlip) then
                    CreateJobBlip()
                end
                jobstart(currentJob, currentLocation)
            else
                currentLocation = math.random(1, #Config.Locations.jobs[currentJob])
                CreateJobBlip()
            end
        else
            Wait(5000)
        end
    end
end)
















--  
--  S H O W E R C L E A N E R 
-- 




function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local IsCleaning = false

local IsEating = false

--local cleanx = vector3(1730.9069824219, 2501.6616210938, 45.819358825684)

local food = vector3(1781.1302490234, 2557.5888671875, 45.6729431152)

local IsCleaningTable = false

local SwappingCharacters = false

-- local TimeR = TimeRemaining
-- local minutes = TimeR

local function DrawText3D(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function JobDoneCleaning(shit,shit2)
        ProjectRP.Functions.Notify("You've worked some time off your sentence.")
        jailTime = jailTime - math.random(shit, shit2)

end

Citizen.CreateThread(function()
    Citizen.Wait(3000)
    while true do
        if inJail then
            Citizen.Wait(1)
--             local cleanx = vector3(1730.9069824219, 2501.6616210938, 45.819358825684)
--             if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), cleanx.x,cleanx.y,cleanx.z, true) < 4.0) and not IsCleaning then
--                 if IsControlJustPressed(1, 38) and not SwappingCharacters then
--                     IsCleaning = true


--                     ProjectRP.Functions.Progressbar("clean_Shower", "Cleaning Showers", 45000, false, true, {
--                         disableMovement = true,
--                         disableCarMovement = true,
--                         disableMouse = false,
--                         disableCombat = true,
--                     }, {
--                         animDict = "amb@world_human_janitor@male@base",
--                         anim = "base",
--                         flags = 16,
--                     }, {}, {}, function() -- Done
--                         IsCleaning = false
--                         StopAnimTask(PlayerPedId(), "amb@world_human_janitor@male@base", "base", 1.0)
--                         JobDoneCleaning(1,4)
--                     end, function() -- Cancel
--                         IsCleaning = false
--                         StopAnimTask(PlayerPedId(), "amb@world_human_janitor@male@base", "base", 1.0)
--                         ProjectRP.Functions.Notify("Process Canceled..", "error")
--                     end)

--                 end

--                 DrawText3D({
--                     x = cleanx.x,
--                     y = cleanx.y,
--                     z = cleanx.z + 0.2
--                 }, "Press [~g~E~w~] to start cleaning the showers")
--             end
-- -- table
           local cleanT = vector3(1759.2132568359, 2485.8781738281, 45.817295074463)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), cleanT.x,cleanT.y,cleanT.z, true) < 4.0) and not IsCleaningTable then
                if IsControlJustPressed(1, 38) then
                    IsCleaningTable = true
-
                    ProjectRP.Functions.Progressbar("clean_Table", "Cleaning Table", 20000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "mini@repair",
                        anim = "fixing_a_ped",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        IsCleaningTable = false
                        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
                        JobDoneCleaning(1,4)
                    end, function() -- Cancel
                        IsCleaningTable = false
                        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
                        ProjectRP.Functions.Notify("Process Canceled..", "error")
                    end)

                end

                DrawText3D({
                    x = cleanT.x,
                    y = cleanT.y,
                    z = cleanT.z + 0.2
                }, "Press [~g~E~w~] to start cleaning Tables")
            end



        else
            Citizen.Wait(5000)
        end
    end
end)



RegisterNetEvent("Clean:Showers")
AddEventHandler("Clean:Showers", function()

    if inJail then
        if not IsCleaning then
            IsCleaning = true
            local playerPed = GetPlayerPed(-1) 

            TaskGoStraightToCoord(playerPed, 1732.1616, 2498.7124, 45.8185,1.0,8000,88.67,0)

            Wait(2000)
                       ProjectRP.Functions.Progressbar("clean_Shower", "Cleaning Showers", 45000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "amb@world_human_janitor@male@base",
                        anim = "base",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        IsCleaning = false
                        StopAnimTask(PlayerPedId(), "amb@world_human_janitor@male@base", "base", 1.0)
                        JobDoneCleaning(1,4)
                    end, function() -- Cancel
                        IsCleaning = false
                        StopAnimTask(PlayerPedId(), "amb@world_human_janitor@male@base", "base", 1.0)
                        ProjectRP.Functions.Notify("Process Canceled..", "error")
                    end)
            else
                ProjectRP.Functions.Notify("You are already cleaning the floor you mug..", "error")
            end
        else
            ProjectRP.Functions.Notify("You are currently not serving any time?", "error")
        end
end)