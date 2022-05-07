-- Opens the washing menu for a given washer
-- @param k number - Washer number
local function OpenWasher(k)
    if Config.Labs.moneywash.washers[k].busy then
        ProjectRP.Functions.Notify("Someone is already operating this washer..", "error", 2500)
        return
    elseif Config.Labs.moneywash.washers[k].started then
        ProjectRP.Functions.Notify("Washing process started, come back later..", "error", 2500)
        return
    end
    local menu = {
        {
            header = "< Close",
            txt = Config.Labs.moneywash.washers[k].moneybags..'/'..Config.Labs.moneywash.maxBags..' Bags ($'..Config.Labs.moneywash.washers[k].worth..')',
            params = {
                event = "prp-menu:closeMenu",
            }
        }
    }
    if not Config.Labs.moneywash.washers[k].completed then
        if not Config.Labs.moneywash.washers[k].started then
            if Config.Labs.moneywash.washers[k].moneybags < Config.Labs.moneywash.maxBags then
                menu[#menu+1] = {
                    header = "Load Washer",
                    txt = "",
                    params = {
                        event = "prp-labs:client:LoadWasher",
                        args = {
                            washer = k
                        }
                    }
                }
            end
            if Config.Labs.moneywash.washers[k].moneybags > 0 then
                menu[#menu+1] = {
                    header = "Start Washer",
                    txt = "",
                    params = {
                        isServer = true,
                        event = "prp-labs:server:StartMoneyWash",
                        args = {
                            washer = k
                        }
                    }
                }
            end
        end
    else
        menu[#menu+1] = {
            header = "Grab Money",
            params = {
                event = "prp-labs:client:GrabMoney",
                args = {
                    washer = k
                }
            }
        }
    end
    exports['prp-menu']:openMenu(menu)
end

RegisterNetEvent('prp-labs:client:LoadWasher', function(data)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
    -- SET STATION BUSY
    TriggerServerEvent('prp-labs:server:BusyMoneyWash', data.washer, true)
    ProjectRP.Functions.Progressbar("pickup_reycle_package", "Loading Money..", 5000, false, true, {}, {}, {}, {}, function() -- Done
        -- FINISH ANIMATION
        ClearPedTasks(ped)
        -- UPDATE MONEYBAGS
        TriggerServerEvent('prp-labs:server:LoadMoneyWash', data.washer)
        -- SET STATION NOT BUSY
        TriggerServerEvent('prp-labs:server:BusyMoneyWash', data.washer, false)
    end, function() -- cancel
        ProjectRP.Functions.Notify('Canceled..', 'error')
        ClearPedTasks(ped)
        -- SET STATION NOT BUSY
        TriggerServerEvent('prp-labs:server:BusyMoneyWash', data.washer, false)
    end)
end)

RegisterNetEvent('prp-labs:client:BusyMoneyWash', function(index, bool)
    Config.Labs.moneywash.washers[index].busy = bool
end)

RegisterNetEvent('prp-labs:client:LoadMoneyWash', function(index, amount, newWorth)
    Config.Labs.moneywash.washers[index].moneybags = amount
    Config.Labs.moneywash.washers[index].worth = newWorth
end)

RegisterNetEvent('prp-labs:client:StartMoneyWash', function(index)
    Config.Labs.moneywash.washers[index].started = true
end)

RegisterNetEvent('prp-labs:client:CompletedMoneyWash', function(index)
    Config.Labs.moneywash.washers[index].completed = true
    Config.Labs.moneywash.washers[index].started = false
end)

RegisterNetEvent('prp-labs:client:GrabMoney', function(data)
    local washer = data.washer
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
    ProjectRP.Functions.Progressbar("pickup_reycle_package", "Grabbing Money..", 6000, false, true, {}, {}, {}, {}, function() -- Done
        TriggerServerEvent('prp-labs:server:GrabMoney', washer)
        ClearPedTasks(ped)
    end, function() -- cancel
        ProjectRP.Functions.Notify('Canceled..', 'error')
        ClearPedTasks(ped)
    end)
end)

RegisterNetEvent('prp-labs:client:ResetWasher', function(index)
    Config.Labs.moneywash.washers[index].busy = false
    Config.Labs.moneywash.washers[index].started = false
    Config.Labs.moneywash.washers[index].completed = false
    Config.Labs.moneywash.washers[index].moneybags = 0
    Config.Labs.moneywash.washers[index].worth = 0
end)

CreateThread(function()
    exports["prp-target"]:AddBoxZone("mwentrance", Config.Labs.moneywash.entrance.xyz, 0.6, 1.3, {
        name = "mwentrance",
        heading = Config.Labs.moneywash.entrance.w,
        debugPoly = false,
        minZ = 26.38,
        maxZ = 28.78,
        }, {
            options = {
            {
                action = function()
                    enterKeyLab("moneywash")
                end,
                icon = "fas fa-user-secret",
                label = "Enter",
                canInteract = function()
                    if Config.Labs.moneywash.locked then return false end
                    return true
                end,
            },
            {
                action = function()
                    LockUnlock("moneywash", "mwkey")
                end,
                icon = "fas fa-key",
                label = "Lock/Unlock Door"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddBoxZone("mwexit", Config.Labs.moneywash.exit.xyz, 0.6, 1.2, {
        name = "mwexit",
        heading = Config.Labs.moneywash.exit.w,
        debugPoly = false,
        minZ = -40.70,
        maxZ = -38.70,
        }, {
            options = {
            {
                action = function()
                    Exitlab("moneywash")
                end,
                icon = "fas fa-user-secret",
                label = "Exit",
                canInteract = function()
                    if Config.Labs.moneywash.locked then return false end
                    return true
                end,
            },
            {
                action = function()
                    LockUnlock("moneywash", "mwkey")
                end,
                icon = "fas fa-key",
                label = "Lock/Unlock Door"
            }
        },
        distance = 1.5
    })
    for i=1, #Config.Labs.moneywash.washers, 1 do
        exports['prp-target']:AddBoxZone("mwwasher"..i, Config.Labs.moneywash.washers[i].coords, 1.4, 1.4, {
            name = "mwwasher"..i,
            heading = 0.00,
            debugPoly = false,
            minZ = -41.4050,
            maxZ = -39.2030,
            }, {
                options = { 
                {
                    action = function()
                        OpenWasher(i)
                    end,
                    icon = 'fas fa-money-bill-wave',
                    label = 'Check Washer'
                }
            },
            distance = 1.5,
        })
    end
end)