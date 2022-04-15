ProjectRP = exports['prp-core']:GetCoreObject()
isLoggedIn = LocalPlayer.state['isLoggedIn']
currentThermiteGate = 0
CurrentCops = 0
local closestBank = 0
local inElectronickitZone = false
local copsCalled = false
local refreshed = false
local currentLocker = 0

-- Handlers

local function ResetBankDoors()
    for k in pairs(Config.SmallBanks) do
        local object = GetClosestObjectOfType(Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"], 5.0, Config.SmallBanks[k]["object"], false, false, false)
        if not Config.SmallBanks[k]["isOpened"] then
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].closed)
        else
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].open)
        end
    end
    if not Config.BigBanks["paleto"]["isOpened"] then
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].closed)
    else
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].open)
    end
    if not Config.BigBanks["pacific"]["isOpened"] then
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].closed)
    else
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].open)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    ResetBankDoors()
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    ProjectRP.Functions.TriggerCallback('prp-bankrobbery:server:GetConfig', function(config)
        Config = config
    end)
    ResetBankDoors()
    isLoggedIn = true
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Functions

local function OpenPaletoDoor()
    TriggerServerEvent('prp-doorlock:server:updateState', 4, false, false, false, true, false, false)
    local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
    if object ~= 0 then
        SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].open)
    end
end

local function OpenPacificDoor()
    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    local entHeading = Config.BigBanks["pacific"]["heading"].closed
    if object ~= 0 then
        CreateThread(function()
            while entHeading > Config.BigBanks["pacific"]["heading"].open do
                SetEntityHeading(object, entHeading - 10)
                entHeading -= 0.5
                Wait(10)
            end
        end)
    end
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.SmallBanks[bankId]["coords"]["x"], Config.SmallBanks[bankId]["coords"]["y"], Config.SmallBanks[bankId]["coords"]["z"], 5.0, Config.SmallBanks[bankId]["object"], false, false, false)
    local entHeading = Config.SmallBanks[bankId]["heading"].closed
    if object ~= 0 then
        CreateThread(function()
            while entHeading ~= Config.SmallBanks[bankId]["heading"].open do
                SetEntityHeading(object, entHeading - 10)
                entHeading -= 0.5
                Wait(10)
            end
        end)
    end
end

function openLocker(bankId, lockerId) -- Globally Used
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 65 and not ProjectRP.Functions.IsWearingGloves() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', true)
    if bankId == "paleto" then
        ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
            if hasItem then
                loadAnimDict("anim@heists@fleeca_bank@drilling")
                TaskPlayAnim(ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z, true, true, true)
                AttachEntityToEntity(DrillObject, ped, GetPedBoneIndex(ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
                IsDrilling = true
                ProjectRP.Functions.Progressbar("open_locker_drill", "Breaking open the safe ..", math.random(18000, 30000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    StopAnimTask(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    TriggerServerEvent('prp-bankrobbery:server:recieveItem', 'paleto')
                    ProjectRP.Functions.Notify("Successful!", "success")
                    IsDrilling = false
                end, function() -- Cancel
                    StopAnimTask(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    ProjectRP.Functions.Notify("Canceled..", "error")
                    IsDrilling = false
                end)
                CreateThread(function()
                    while IsDrilling do
                        TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                        Wait(10000)
                    end
                end)
            else
                ProjectRP.Functions.Notify("Looks like the safe lock is too strong ..", "error")
                TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, "drill")
    elseif bankId == "pacific" then
        ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(hasItem)
            if hasItem then
                loadAnimDict("anim@heists@fleeca_bank@drilling")
                TaskPlayAnim(ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z, true, true, true)
                AttachEntityToEntity(DrillObject, ped, GetPedBoneIndex(ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
                IsDrilling = true
                ProjectRP.Functions.Progressbar("open_locker_drill", "Breaking open the safe ..", math.random(18000, 30000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    StopAnimTask(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)

                    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    TriggerServerEvent('prp-bankrobbery:server:recieveItem', 'pacific')
                    ProjectRP.Functions.Notify("Successful!", "success")
                    IsDrilling = false
                end, function() -- Cancel
                    StopAnimTask(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    ProjectRP.Functions.Notify("Canceled..", "error")
                    IsDrilling = false
                end)
                CreateThread(function()
                    while IsDrilling do
                        TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                        Wait(10000)
                    end
                end)
            else
                ProjectRP.Functions.Notify("Looks like the safe lock is too strong ..", "error")
                TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, "drill")
    else
        IsDrilling = true
        ProjectRP.Functions.Progressbar("open_locker", "Breaking open the safe ..", math.random(27000, 37000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@gangops@facility@servers@",
            anim = "hotwire",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
            TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            TriggerServerEvent('prp-bankrobbery:server:recieveItem', 'small')
            ProjectRP.Functions.Notify("Successful!", "success")
            IsDrilling = false
        end, function() -- Cancel
            StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerServerEvent('prp-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            ProjectRP.Functions.Notify("Canceled..", "error")
            IsDrilling = false
        end)
        CreateThread(function()
            while IsDrilling do
                TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                Wait(10000)
            end
        end)
    end
end

-- Events

RegisterNetEvent('electronickit:UseElectronickit', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not ProjectRP.Functions.IsWearingGloves() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank == 0 or not inElectronickitZone then return end
    ProjectRP.Functions.TriggerCallback('prp-bankrobbery:server:isRobberyActive', function(isBusy)
        if not isBusy then
            if CurrentCops >= Config.MinimumFleecaPolice then
                if not Config.SmallBanks[closestBank]["isOpened"] then
                    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(result)
                        if result then
                            TriggerEvent('inventory:client:requiredItems', {
                                [1] = {name = ProjectRP.Shared.Items["electronickit"]["name"], image = ProjectRP.Shared.Items["electronickit"]["image"]},
                                [2] = {name = ProjectRP.Shared.Items["trojan_usb"]["name"], image = ProjectRP.Shared.Items["trojan_usb"]["image"]}
                            }, false)
                            ProjectRP.Functions.Progressbar("hack_gate", "Connecting the hacking device ..", math.random(5000, 10000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "anim@gangops@facility@servers@",
                                anim = "hotwire",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                TriggerServerEvent('prp-bankrobbery:server:removeElectronicKit')
                                exports["hacking"]:hacking(
                                function() -- success
                                    TriggerServerEvent('prp-bankrobbery:server:setBankState', closestBank, true)
                                end,
                                function() -- failure
                                    ProjectRP.Functions.Notify("Canceled..", "error")
                                end)
                                if copsCalled or not Config.SmallBanks[closestBank]["alarm"] then return end
                                local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                local street1 = GetStreetNameFromHashKey(s1)
                                local street2 = GetStreetNameFromHashKey(s2)
                                local streetLabel = street1
                                if street2 then streetLabel = streetLabel .. " " .. street2 end
                                TriggerServerEvent("prp-bankrobbery:server:callCops", "small", closestBank, streetLabel, pos)
                                copsCalled = true
                                SetTimeout(60000 * Config.DispatchCooldown, function() copsCalled = false end)
                            end, function() -- Cancel
                                StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                ProjectRP.Functions.Notify("Canceled..", "error")
                            end)
                        else
                            ProjectRP.Functions.Notify("You're missing an item ..", "error")
                        end
                    end, {["trojan_usb"] = 1, ["electronickit"] = 1})
                else
                    ProjectRP.Functions.Notify("Looks like the bank is already open ..", "error")
                end
            else
                ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error")
            end
        else
            ProjectRP.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
        end
    end)
end)

RegisterNetEvent('prp-bankrobbery:client:setBankState', function(bankId, state)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["isOpened"] = state
        if state then
            OpenPaletoDoor()
        end
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = state
        if state then
            OpenPacificDoor()
        end
    else
        Config.SmallBanks[bankId]["isOpened"] = state
        if state then
            OpenBankDoor(bankId)
        end
    end
end)

RegisterNetEvent('prp-bankrobbery:client:enableAllBankSecurity', function()
    for k in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = true
    end
end)

RegisterNetEvent('prp-bankrobbery:client:disableAllBankSecurity', function()
    for k in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = false
    end
end)

RegisterNetEvent('prp-bankrobbery:client:BankSecurity', function(key, status)
    Config.SmallBanks[key]["alarm"] = status
end)

RegisterNetEvent('prp-bankrobbery:client:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end
end)

RegisterNetEvent('prp-bankrobbery:client:ResetFleecaLockers', function(BankId)
    Config.SmallBanks[BankId]["isOpened"] = false
    for k in pairs(Config.SmallBanks[BankId]["lockers"]) do
        Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
        Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
    end
end)

RegisterNetEvent('prp-bankrobbery:client:robberyCall', function(type, key, streetLabel, coords, msg)
    if not isLoggedIn then return end
    local PlayerJob = ProjectRP.Functions.GetPlayerData().job
    if PlayerJob.name == "police" and PlayerJob.onduty then
        local cameraId = 4
        local bank = "Fleeca"
        if type == "small" then
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police'}, 
                coords = coords,
                title = '10-90 - Fleeca bank robbery attempt',
                message = msg,
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                blip = {
                    sprite = 108,
                    scale = 1.2,
                    colour = 3,
                    flashes = false,
                    text = '911 - Blain County Savings bank robbery attempt',
                    time = (5*60*1000),
                    sound = 1,
                }
            })
        elseif type == "paleto" then
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police'}, 
                coords = coords,
                title = '10-90 - Blain County Savings bank robbery attempt',
                message = msg,
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                blip = {
                    sprite = 108, 
                    scale = 1.2, 
                    colour = 3,
                    flashes = false, 
                    text = '911 - Blain County Savings bank robbery attempt',
                    time = (5*60*1000),
                    sound = 2,
                }
            })
        elseif type == "pacific" then
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police'}, 
                coords = coords,
                title = '10-90 - Pacific Standard Bank robbery attempt',
                message = msg,
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                blip = {
                    sprite = 108, 
                    scale = 1.2, 
                    colour = 3,
                    flashes = false, 
                    text = '911 - Pacific Standard Bank robbery attempt',
                    time = (5*60*1000),
                    sound = 2,
                }
            })
        end
    end
end)

-- Threads

CreateThread(function()
    while true do
        if closestBank ~= 0 then
            if not refreshed then
                ResetBankDoors()
                refreshed = true
            end
        else
            refreshed = false
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do -- This is kept for the ResetBankDoors function to be executed outside of the polyzone
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if isLoggedIn then
            for k, v in pairs(Config.SmallBanks) do
                local dist = #(pos - v["coords"])
                if dist < 15 then
                    closestBank = k
                    inRange = true
                end
            end
            if not inRange then closestBank = 0 end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    for i = 1, #Config.SmallBanks do
        local bankZone = BoxZone:Create(Config.SmallBanks[i]["coords"], 1.0, 1.0, {
            name = 'fleeca_'..i..'_coords_electronickit',
            heading = Config.SmallBanks[i]["coords"].closed,
            minZ = Config.SmallBanks[i]["coords"].z - 1,
            maxZ = Config.SmallBanks[i]["coords"].z + 1,
            debugPoly = false
        })
        bankZone:onPlayerInOut(function(inside)
            inElectronickitZone = inside
            if inside and not Config.SmallBanks[i]["isOpened"] then
                TriggerEvent('inventory:client:requiredItems', {
                    [1] = {name = ProjectRP.Shared.Items["electronickit"]["name"], image = ProjectRP.Shared.Items["electronickit"]["image"]},
                    [2] = {name = ProjectRP.Shared.Items["trojan_usb"]["name"], image = ProjectRP.Shared.Items["trojan_usb"]["image"]}
                }, true)
            else
                TriggerEvent('inventory:client:requiredItems', {
                    [1] = {name = ProjectRP.Shared.Items["electronickit"]["name"], image = ProjectRP.Shared.Items["electronickit"]["image"]},
                    [2] = {name = ProjectRP.Shared.Items["trojan_usb"]["name"], image = ProjectRP.Shared.Items["trojan_usb"]["image"]}
                }, false)
            end
        end)
        for k in pairs(Config.SmallBanks[i]["lockers"]) do
            if Config.UseTarget then
                exports['prp-target']:AddBoxZone('fleeca_'..i..'_coords_locker_'..k, Config.SmallBanks[i]["lockers"][k]["coords"], 1.0, 1.0, {
                    name = 'fleeca_'..i..'_coords_locker_'..k,
                    heading = Config.SmallBanks[i]["heading"].closed,
                    minZ = Config.SmallBanks[i]["lockers"][k]["coords"].z - 1,
                    maxZ = Config.SmallBanks[i]["lockers"][k]["coords"].z + 1,
                    debugPoly = false
                }, {
                    options = {
                        {
                            action = function()
                                openLocker(closestBank, k)
                            end,
                            canInteract = function()
                                return closestBank ~= 0 and Config.SmallBanks[i]["isOpened"] and not Config.SmallBanks[i]["lockers"][k]["isOpened"] and not Config.SmallBanks[i]["lockers"][k]["isBusy"]
                            end,
                            icon = 'fa-solid fa-vault',
                            label = 'Break Safe Open',
                        },
                    },
                    distance = 1.5
                })
            else
                local lockerZone = BoxZone:Create(Config.SmallBanks[i]["lockers"][k]["coords"], 1.0, 1.0, {
                    name = 'fleeca_'..i..'_coords_locker_'..k,
                    heading = Config.SmallBanks[i]["heading"].closed,
                    minZ = Config.SmallBanks[i]["lockers"][k]["coords"].z - 1,
                    maxZ = Config.SmallBanks[i]["lockers"][k]["coords"].z + 1,
                    debugPoly = false
                })
                lockerZone:onPlayerInOut(function(inside)
                    if inside and closestBank ~= 0 and Config.SmallBanks[i]["isOpened"] and not Config.SmallBanks[i]["lockers"][k]["isOpened"] and not Config.SmallBanks[i]["lockers"][k]["isBusy"] then
                        exports['prp-core']:DrawText('[E] Break open the safe', 'right')
                        currentLocker = k
                    else
                        if currentLocker == k then
                            currentLocker = 0
                            exports['prp-core']:HideText()
                        end
                    end
                end)
            end
        end
    end
    if not Config.UseTarget then
        while true do
            local sleep = 1000
            if isLoggedIn then
                if currentLocker ~= 0 then
                    sleep = 0
                    if IsControlJustPressed(0, 38) then
                        exports['prp-core']:KeyPressed()
                        Wait(500)
                        exports['prp-core']:HideText()
                        if CurrentCops >= Config.MinimumFleecaPolice then
                            openLocker(closestBank, currentLocker)
                        else
                            ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error")
                        end
                        sleep = 1000
                    end
                end
            end
            Wait(sleep)
        end
    end
end)
