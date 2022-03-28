local requiredItemsShowed = false
local requiredItemsShowed2 = false
local requiredItemsShowed3 = false
local requiredItemsShowed4 = false

-- Functions

local function OnHackPacificDone(success)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('prp-bankrobbery:server:setBankState', "pacific", true)
    else
		TriggerEvent('mhacking:hide')
	end
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Events

RegisterNetEvent('prp-bankrobbery:UseBankcardB', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.BigBanks["pacific"]["coords"][1])
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if dist < 1.5 then
        ProjectRP.Functions.TriggerCallback('prp-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if CurrentCops >= Config.MinimumPacificPolice then
                    if not Config.BigBanks["pacific"]["isOpened"] then
                        TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                        ProjectRP.Functions.Progressbar("security_pass", "Please validate ..", math.random(5000, 10000), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@gangops@facility@servers@",
                            anim = "hotwire",
                            flags = 16,
                        }, {}, {}, function() -- Done
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            TriggerServerEvent('prp-doorlock:server:updateState', 1, false)
                            TriggerServerEvent("ProjectRP:Server:RemoveItem", "security_card_02", 1)
                            if not copsCalled then
                                local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                local street1 = GetStreetNameFromHashKey(s1)
                                local street2 = GetStreetNameFromHashKey(s2)
                                local streetLabel = street1
                                if street2 ~= nil then
                                    streetLabel = streetLabel .. " " .. street2
                                end
                                if Config.BigBanks["pacific"]["alarm"] then
                                    TriggerServerEvent("prp-bankrobbery:server:callCops", "pacific", 0, streetLabel, pos)
                                    copsCalled = true
                                end
                            end
                        end, function() -- Cancel
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            ProjectRP.Functions.Notify("Canceled..", "error")
                        end)
                    else
                        ProjectRP.Functions.Notify("Looks like the bank is already open ..", "error")
                    end
                else
                    ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                end
            else
                ProjectRP.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end
end)

RegisterNetEvent('electronickit:UseElectronickit', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.BigBanks["pacific"]["coords"][2])
    if dist < 1.5 then
        ProjectRP.Functions.TriggerCallback('prp-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                local dist = #(pos - Config.BigBanks["pacific"]["coords"][2])
                if dist < 1.5 then
                    if CurrentCops >= Config.MinimumPacificPolice then
                        if not Config.BigBanks["pacific"]["isOpened"] then
                            ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(result)
                                if result then
                                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
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
                                        TriggerServerEvent("ProjectRP:Server:RemoveItem", "electronickit", 1)
                                        TriggerEvent('inventory:client:ItemBox', ProjectRP.Shared.Items["electronickit"], "remove")
                                        TriggerServerEvent("ProjectRP:Server:RemoveItem", "trojan_usb", 1)
                                        TriggerEvent('inventory:client:ItemBox', ProjectRP.Shared.Items["trojan_usb"], "remove")
                                        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                        TriggerEvent("mhacking:show")
                                        TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 15), OnHackPacificDone)

                                        exports['hacking']:hacking(function(Success)
                                        if Success then 
                                            TriggerServerEvent('prp-bankrobbery:server:setBankState', "pacific", true)
                                        else 
                                            ProjectRP.Functions.Notify("YTrmt gustavo..", "error")
                                        end
                                        end)    

                                        if not copsCalled then
                                            local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                            local street1 = GetStreetNameFromHashKey(s1)
                                            local street2 = GetStreetNameFromHashKey(s2)
                                            local streetLabel = street1
                                            if street2 ~= nil then
                                                streetLabel = streetLabel .. " " .. street2
                                            end
                                            if Config.BigBanks["pacific"]["alarm"] then
                                                TriggerServerEvent("prp-bankrobbery:server:callCops", "pacific", 0, streetLabel, pos)
                                                copsCalled = true
                                            end
                                        end
                                    end, function() -- Cancel
                                        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                        ProjectRP.Functions.Notify("Canceled", "error")
                                    end)
                                else
                                    ProjectRP.Functions.Notify("You're missing an item ..", "error")
                                end
                            end, "trojan_usb")
                        else
                            ProjectRP.Functions.Notify("Looks like the bank is already open", "error")
                        end
                    else
                        ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                    end
                end
            else
                ProjectRP.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end
end)

-- Threads

CreateThread(function()
    Wait(2000)
    local requiredItems3 = {
        [1] = {name = ProjectRP.Shared.Items["thermite"]["name"], image = ProjectRP.Shared.Items["thermite"]["image"]},
    }
    local requiredItems2 = {
        [1] = {name = ProjectRP.Shared.Items["electronickit"]["name"], image = ProjectRP.Shared.Items["electronickit"]["image"]},
        [2] = {name = ProjectRP.Shared.Items["trojan_usb"]["name"], image = ProjectRP.Shared.Items["trojan_usb"]["image"]},
    }
    local requiredItems = {
        [1] = {name = ProjectRP.Shared.Items["security_card_02"]["name"], image = ProjectRP.Shared.Items["security_card_02"]["image"]},
    }
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if ProjectRP ~= nil then
            if #(pos - Config.BigBanks["pacific"]["coords"][1]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["coords"][1])
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            end
            if #(pos - Config.BigBanks["pacific"]["coords"][2]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["coords"][2])
                    if dist < 1 then
                        if not requiredItemsShowed2 then
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, true)
                        end
                    else
                        if requiredItemsShowed2 then
                            requiredItemsShowed2 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                        end
                    end
                end
            end
            if #(pos - Config.BigBanks["pacific"]["thermite"][1]["coords"]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["thermite"][1]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["thermite"][1]["coords"])
                    if dist < 1 then
                        currentThermiteGate = Config.BigBanks["pacific"]["thermite"][1]["doorId"]
                        if not requiredItemsShowed3 then
                            requiredItemsShowed3 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems3, true)
                        end
                    else
                        currentThermiteGate = 0
                        if requiredItemsShowed3 then
                            requiredItemsShowed3 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems3, false)
                        end
                    end
                end
            end

            if Config.BigBanks["pacific"]["isOpened"] then
                for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
                    local lockerDist = #(pos - Config.BigBanks["pacific"]["lockers"][k]["coords"])
                    if not Config.BigBanks["pacific"]["lockers"][k]["isBusy"] then
                        if not Config.BigBanks["pacific"]["lockers"][k]["isOpened"] then
                            if lockerDist < 5 then
                                inRange = true
                                DrawMarker(2, Config.BigBanks["pacific"]["lockers"][k]["coords"].x, Config.BigBanks["pacific"]["lockers"][k]["coords"].y, Config.BigBanks["pacific"]["lockers"][k]["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                if lockerDist < 0.5 then
                                    DrawText3Ds(Config.BigBanks["pacific"]["lockers"][k]["coords"].x, Config.BigBanks["pacific"]["lockers"][k]["coords"].y, Config.BigBanks["pacific"]["lockers"][k]["coords"].z + 0.3, '[E] Break open the safe')
                                    if IsControlJustPressed(0, 38) then
                                        if CurrentCops >= Config.MinimumPacificPolice then
                                            loadAnimDict("anim@heists@fleeca_bank@drilling")
                                            TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                                            local pos = GetEntityCoords(PlayerPedId(), true)
                                            local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z, true, true, true)
                                            AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
                                            exports['minigame-drill']:StartDrilling(function(Success)
                                                if Success then 
                                                StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                                                DetachEntity(DrillObject, true, true)
                                                DeleteObject(DrillObject)
                                                openLocker("pacific", k)
                                                else 
                                                ProjectRP.Functions.Notify("You failed.", "error", 5500)
                                                end
                                            end)
                                        else
                                            ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                Wait(2500)
            end
        end
        Wait(1)
    end
end)

CreateThread(function()
    Wait(2000)
    local requiredItems4 = {
        [1] = {name = ProjectRP.Shared.Items["thermite"]["name"], image = ProjectRP.Shared.Items["thermite"]["image"]},
    }
    while true do
        Wait(1)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if ProjectRP ~= nil then
            if #(pos - Config.BigBanks["pacific"]["thermite"][2]["coords"]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["thermite"][1]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["thermite"][2]["coords"])
                    if dist < 1 then
                        currentThermiteGate = Config.BigBanks["pacific"]["thermite"][2]["doorId"]
                        if not requiredItemsShowed4 then
                            requiredItemsShowed4 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems4, true)
                        end
                    else
                        currentThermiteGate = 0
                        if requiredItemsShowed4 then
                            requiredItemsShowed4 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems4, false)

                        end
                    end
                end
            end
        end
    end
end)