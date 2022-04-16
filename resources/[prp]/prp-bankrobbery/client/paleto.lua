local inBankCardAZone = false
local currentLocker = 0

-- Events

RegisterNetEvent('prp-bankrobbery:UseBankcardA', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not ProjectRP.Functions.IsWearingGloves() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if not inBankCardAZone then return end
    ProjectRP.Functions.TriggerCallback('prp-bankrobbery:server:isRobberyActive', function(isBusy)
        if not isBusy then
            if CurrentCops >= Config.MinimumPaletoPolice then
                if not Config.BigBanks["paleto"]["isOpened"] then
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    ProjectRP.Functions.Progressbar("security_pass", "Validitating card..", math.random(5000, 10000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@gangops@facility@servers@",
                        anim = "hotwire",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        if copsCalled or not Config.BigBanks["paleto"]["alarm"] then return end
                        local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                        local street1 = GetStreetNameFromHashKey(s1)
                        local street2 = GetStreetNameFromHashKey(s2)
                        local streetLabel = street1
                        if street2 then streetLabel = streetLabel .. " " .. street2 end
                        TriggerServerEvent("prp-bankrobbery:server:callCops", "paleto", 0, streetLabel, pos)
                        copsCalled = true
                        TriggerEvent("prp:numbers:start", 45, function(output)
                            if output == true then
                                StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                TriggerServerEvent('prp-bankrobbery:server:setBankState', "paleto", true)
                                TriggerServerEvent('prp-bankrobbery:server:removeBankCard', '01')
                                TriggerServerEvent('prp-doorlock:server:updateState', 4, false, false, false, true, false, false)
                            else
                                StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                            end
                        end)
                    end, function() -- Cancel
                        StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                        ProjectRP.Functions.Notify("Canceled..", "error")
                    end)
                else
                    ProjectRP.Functions.Notify("It looks like the bank is already opened..", "error")
                end
            else
                ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumPaletoPolice..' Police Needed', "error")
            end
        else
            ProjectRP.Functions.Notify("The security lock is active, the door cannot be opened at the moment..", "error", 5500)
        end
    end)
end)

-- Threads

CreateThread(function()
    local bankCardAZone = BoxZone:Create(Config.BigBanks["paleto"]["coords"], 1.0, 1.0, {
        name = 'paleto_coords_bankcarda',
        heading = Config.BigBanks["paleto"]["coords"].closed,
        minZ = Config.BigBanks["paleto"]["coords"].z - 1,
        maxZ = Config.BigBanks["paleto"]["coords"].z + 1,
        debugPoly = false
    })
    bankCardAZone:onPlayerInOut(function(inside)
        inBankCardAZone = inside
        if inside and not Config.BigBanks["paleto"]["isOpened"] then
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = ProjectRP.Shared.Items["security_card_01"]["name"], image = ProjectRP.Shared.Items["security_card_01"]["image"]}
            }, true)
        else
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = ProjectRP.Shared.Items["security_card_01"]["name"], image = ProjectRP.Shared.Items["security_card_01"]["image"]}
            }, false)
        end
    end)
    local thermite1Zone = BoxZone:Create(Config.BigBanks["paleto"]["thermite"][1]["coords"], 1.0, 1.0, {
        name = 'paleto_coords_thermite_1',
        heading = Config.BigBanks["paleto"]["heading"].closed,
        minZ = Config.BigBanks["paleto"]["thermite"][1]["coords"].z - 1,
        maxZ = Config.BigBanks["paleto"]["thermite"][1]["coords"].z + 1,
        debugPoly = false
    })
    thermite1Zone:onPlayerInOut(function(inside)
        if inside and not Config.BigBanks["paleto"]["thermite"][1]["isOpened"] then
            currentThermiteGate = Config.BigBanks["paleto"]["thermite"][1]["doorId"]
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = ProjectRP.Shared.Items["thermite"]["name"], image = ProjectRP.Shared.Items["thermite"]["image"]},
            }, true)
        else
            if currentThermiteGate == Config.BigBanks["paleto"]["thermite"][1]["doorId"] then
                currentThermiteGate = 0
                TriggerEvent('inventory:client:requiredItems', {
                    [1] = {name = ProjectRP.Shared.Items["thermite"]["name"], image = ProjectRP.Shared.Items["thermite"]["image"]},
                }, false)
            end
        end
    end)
    for k in pairs(Config.BigBanks["paleto"]["lockers"]) do
        if Config.UseTarget then
            exports['prp-target']:AddBoxZone('paleto_coords_locker_'..k, Config.BigBanks["paleto"]["lockers"][k]["coords"], 1.0, 1.0, {
                name = 'paleto_coords_locker_'..k,
                heading = Config.BigBanks["paleto"]["heading"].closed,
                minZ = Config.BigBanks["paleto"]["lockers"][k]["coords"].z - 1,
                maxZ = Config.BigBanks["paleto"]["lockers"][k]["coords"].z + 1,
                debugPoly = false
            }, {
                options = {
                    {
                        action = function()
                            openLocker("paleto", k)
                        end,
                        canInteract = function()
                            return Config.BigBanks["paleto"]["isOpened"] and not Config.BigBanks["paleto"]["lockers"][k]["isBusy"] and not Config.BigBanks["paleto"]["lockers"][k]["isOpened"]
                        end,
                        icon = 'fa-solid fa-vault',
                        label = 'Break Safe Open',
                    },
                },
                distance = 1.5
            })
        else
            local lockerZone = BoxZone:Create(Config.BigBanks["paleto"]["lockers"][k]["coords"], 1.0, 1.0, {
                name = 'paleto_coords_locker_'..k,
                heading = Config.BigBanks["paleto"]["heading"].closed,
                minZ = Config.BigBanks["paleto"]["lockers"][k]["coords"].z - 1,
                maxZ = Config.BigBanks["paleto"]["lockers"][k]["coords"].z + 1,
                debugPoly = false
            })
            lockerZone:onPlayerInOut(function(inside)
                if inside and Config.BigBanks["paleto"]["isOpened"] and not Config.BigBanks["paleto"]["lockers"][k]["isBusy"] and not Config.BigBanks["paleto"]["lockers"][k]["isOpened"] then
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
                        if CurrentCops >= Config.MinimumPaletoPolice then
                            openLocker("paleto", currentLocker)
                        else
                            ProjectRP.Functions.Notify('Minimum Of '..Config.MinimumPaletoPolice..' Police Needed', "error")
                        end
                        sleep = 1000
                    end
                end
            end
            Wait(sleep)
        end
    end
end)
