ProjectRP = exports['prp-core']:GetCoreObject()
CarryPackage = nil

-- Opens the menu to lock/unlock and enter a lab
-- @param lab string - Name of the lab
function LockUnlock(lab)
    local menu = {
        {
            header = "< Close",
            txt = "ESC or click to close",
            params = {
                event = "prp-menu:closeMenu",
            }
        },
    }
    if Config.Labs[lab].locked then
        menu[#menu+1] = {
            header = "Unlock Door",
            txt = "",
            params = {
                isServer = true,
                event = "prp-labs:server:unlock",
                args = {
                    lab = lab
                }
            }
        }
    else
        menu[#menu+1] = {
            header = "Lock Door",
            txt = "",
            params = {
                isServer = true,
                event = "prp-labs:server:lock",
                args = {
                    lab = lab
                }
            }
        }
    end
    exports['prp-menu']:openMenu(menu)
end

-- Teleports the player ped inside a given lab
-- @param lab string - Name of the lab
local function enterLab(lab)
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(PlayerPedId(), Config.Labs[lab].exit.x, Config.Labs[lab].exit.y, Config.Labs[lab].exit.z - 0.98)
    SetEntityHeading(PlayerPedId(), Config.Labs[lab].exit.w)
    Wait(1000)
    TriggerServerEvent("prp-log:server:CreateLog", "keylabs", "Enter "..lab, "white", "**"..GetPlayerName(PlayerId()).."** has entered the "..lab)
    DoScreenFadeIn(250)
end

-- Performs the keypad animation when exiting a lab
-- @param x number - X coordinate
-- @param y number - Y coordinate
-- @param z number - Z coordinate
-- @param h number - Heading
local function KeyPadAnimation(x, y, z, h)
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    SetEntityCoords(ped, x, y, z - 0.98)
    SetEntityHeading(ped, h)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, dict, "exit", 2.0, 2.0, -1, 0, 0, false, false, false)
    Wait(1000)
end

-- Performs the unlocking animation and plays a sound
local function OpenDoorAnimation()
    RequestAnimDict("anim@heists@keycard@")
    while not HasAnimDictLoaded("anim@heists@keycard@") do Wait(10) end
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
    TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

-- Teleports the player ped inside a given lab
-- @param lab string - Name of the lab
function enterKeyLab(lab)
    local pos = GetEntityCoords(PlayerPedId())
    if #(pos - Config.Labs[lab].entrance.xyz) < 1 then
        enterLab(lab)
    end
end

-- Teleports the player ped outside a given lab
-- @param lab string - Name of the lab
function Exitlab(lab)
    local ped = PlayerPedId()
    if lab == "methlab" then
        KeyPadAnimation(996.92, -3199.85, -36.4, 94.5)
    elseif lab == 'methlab2' then
        KeyPadAnimation(969.38, -146.2, -46.4, 91.49)
    elseif lab == "moneywash" then
        KeyPadAnimation(1139.0957, -3198.721, -39.66567, 186.46743)
    else
        OpenDoorAnimation()
    end
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.Labs[lab].entrance.x, Config.Labs[lab].entrance.y, Config.Labs[lab].entrance.z - 0.98)
    SetEntityHeading(ped, Config.Labs[lab].entrance.w)
    Wait(1000)
    DoScreenFadeIn(250)
end

-- Opens the ingredients menu for a given lab
-- @param lab string - Name of the lab
function CheckIngredients(lab)
    if Config.Labs[lab].ingredients.busy then
        ProjectRP.Functions.Notify('Someone is already grabbing stuff..', 'error', 2500)
    else
        local menu = {
            {
                header = "< Close",
                txt = "Stock: "..Config.Labs[lab].ingredients.stock,
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
        }
        if Config.Labs[lab].ingredients.stock > 0 and not CarryPackage then
            menu[#menu+1] = {
                header = "Grab Ingredients",
                params = {
                    event = "prp-labs:client:GrabStock",
                    args = {
                        lab = lab
                    }
                }
            }
        end
        if not CarryPackage then
            menu[#menu+1] = {
                header = "Store Ingredients",
                params = {
                    event = "prp-labs:client:StoreStock",
                    args = {
                        lab = lab
                    }
                }
            }
        end
        if CarryPackage then
            menu[#menu+1] = {
                header = "Return Ingredients",
                params = {
                    event = "prp-labs:client:ReturnStock",
                    args = {
                        lab = lab
                    }
                }
            }
        end
        exports['prp-menu']:openMenu(menu)
    end
end

-- Opens the task menu for a given lab and task number
-- @param lab string - Name of the lab
-- @param task number - Task number
function CheckTask(lab, task)
    if Config.Labs[lab].tasks[task].busy then
        ProjectRP.Functions.Notify('Someone is already using this..', 'error', 2500)
    elseif Config.Labs[lab].tasks[task].completed then
        ProjectRP.Functions.Notify('Move on to the next step..', 'error', 5000)
    elseif Config.Labs[lab].tasks[task].started then
        ProjectRP.Functions.Notify('There is nothing you can do.. just wait!', 'error', 5000)
    else
        local menu = {
            {
                header = "< Close",
                txt = "ESC or click to close",
                params = {
                    event = "prp-menu:closeMenu",
                }
            },
            {
                header = "Add Ingredients",
                txt = "Currently: "..Config.Labs[lab].tasks[task].ingredients.current.." / "..Config.Labs[lab].tasks[task].ingredients.needed,
                params = {
                    event = "prp-labs:client:addingredients",
                    args = {
                        lab = lab,
                        task = task
                    }
                }
            },
            {
                header = "Set "..Locales[lab].parameter,
                txt = "Currently: "..Config.Labs[lab].tasks[task].temperature.." "..Locales[lab].unit,
                params = {
                    event = "prp-labs:client:SetTemp",
                    args = {
                        lab = lab,
                        task = task
                    }
                }
            },
            {
                header = Locales[lab].tasks[task],
                params = {
                    isServer = true,
                    event = "prp-labs:server:StartMachine",
                    args = {
                        lab = lab,
                        task = task
                    }
                }
            }
        }
        exports['prp-menu']:openMenu(menu)
    end
end

-- Opens the curing menu for a given lab
-- @param lab string - Name of the lab
function CheckCure(lab)
    if Config.Labs[lab].curing.busy then
        ProjectRP.Functions.Notify('Someone is already using this..', 'error', 2500)
    elseif Config.Labs[lab].curing.started then
        ProjectRP.Functions.Notify('There is nothing you can do.. just wait!', 'error', 5000)
    else
        local menu = {
            {
                header = "< Close",
                txt = "ESC or click to close",
                params = {
                    event = "prp-menu:closeMenu",
                }
            }
        }
        if not Config.Labs[lab].curing.completed and not Config.Labs[lab].curing.started and Config.Labs[lab].curing.purity ~= nil then
            menu[#menu+1] = {
                header = "Start "..Locales[lab].curelabel,
                params = {
                    isServer = true,
                    event = "prp-labs:server:StartCuring",
                    args = {
                        lab = lab
                    }
                }
            }
        end
        if not Config.Labs[lab].curing.completed and not Config.Labs[lab].curing.started and not Config.Labs[lab].curing.purity then
            menu[#menu+1] = {
                header = "Add Batch",
                params = {
                    event = "prp-labs:client:AddCureBatch",
                    args = {
                        lab = lab
                    }
                }
            }
        elseif Config.Labs[lab].curing.completed then
            menu[#menu+1] = {
                header = "Take "..Locales[lab].cureBatchType.." Batch",
                params = {
                    event = "prp-labs:client:TakeCureBatch",
                    args = {
                        lab = lab
                    }
                }
            }
        end
        exports['prp-menu']:openMenu(menu)
    end
end

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    ProjectRP.Functions.TriggerCallback('prp-labs:server:GetConfig', function(config)
        Config = config
    end)
end)

AddEventHandler('onClientResourceStart',function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    Wait(2000) -- Wait to give server time to fetch from database
    ProjectRP.Functions.TriggerCallback('prp-labs:server:GetConfig', function(config)
        Config = config
    end)
end)

RegisterNetEvent('prp-labs:client:DoorAnimation', function()
    OpenDoorAnimation()
end)

RegisterNetEvent('prp-labs:client:lock', function(lab)
    Config.Labs[lab].locked = true
end)

RegisterNetEvent('prp-labs:client:unlock', function(lab)
    Config.Labs[lab].locked = false
end)

RegisterNetEvent('prp-labs:client:GrabStock', function(data)
    -- SET STATION BUSY
    TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, true)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)

    ProjectRP.Functions.Progressbar("pickup_reycle_package", "Grabbing ingredients..", 5000, false, true, {}, {}, {}, {}, function() -- Done
        -- FINISH ANIMATION SPAWN BOX
        ClearPedTasks(ped)
        local pos = GetEntityCoords(ped, true)
        local model = `bkr_prop_meth_toulene`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 28422), 0.55, 0.00, 0.00, 00.0, -90.0, 0.0, true, true, false, true, 1, true)
        CarryPackage = object
        Config.Labs[data.lab].ingredients.taken = true
        -- update stock
        TriggerServerEvent('prp-labs:server:UpdateStock', data.lab, "grab")
        TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, false)
    end, function() -- cancel
        ClearPedTasks(ped)
        TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, false)
    end)
end)

RegisterNetEvent('prp-labs:client:StoreStock', function(data)
    -- SET STATION BUSY
    TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, true)
    -- animation
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    Wait(5000)
    ClearPedTasks(PlayerPedId())
    -- update stock
    TriggerServerEvent('prp-labs:server:UpdateStock', data.lab, "stock")
    TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, false)
end)

RegisterNetEvent('prp-labs:client:ReturnStock', function(data)
    local ped = PlayerPedId()
    TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
    ProjectRP.Functions.Progressbar("pickup_reycle_package", "Returning ingredients..", 2500, false, true, {}, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        DetachEntity(CarryPackage, true, true)
        DeleteObject(CarryPackage)
        CarryPackage = nil
        Config.Labs[data.lab].ingredients.taken = false
        -- update stock
        TriggerServerEvent('prp-labs:server:UpdateStock', data.lab, "return")
        TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, false)
    end, function() -- cancel
        ClearPedTasks(ped)
        DetachEntity(CarryPackage, true, true)
        DeleteObject(CarryPackage)
        CarryPackage = nil
        Config.Labs[data.lab].ingredients.taken = false
        -- update stock
        TriggerServerEvent('prp-labs:server:UpdateStock', data.lab, "return")
        TriggerServerEvent('prp-labs:server:UpdateIngredients', data.lab, false)
    end)
end)

RegisterNetEvent('prp-labs:client:addingredients', function(data)
    if Config.Labs[data.lab].tasks[data.task].ingredients.current == Config.Labs[data.lab].tasks[data.task].ingredients.needed then 
        ProjectRP.Functions.Notify('Cannot add more ingredients, it is already filled!', 'error', 2500)
        return 
    end
    if CarryPackage then
        -- SET BUSY
        TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, true)
        local ped = PlayerPedId()
        ClearPedTasks(ped)
        while (not HasAnimDictLoaded("weapon@w_sp_jerrycan")) do
            RequestAnimDict("weapon@w_sp_jerrycan")
            Wait(10)
        end
        TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0)

        ProjectRP.Functions.Progressbar("pickup_reycle_package", "Adding ingredients..", 5000, false, true, {}, {}, {}, {}, function() -- Done
            ClearPedTasks(ped)
            DetachEntity(CarryPackage, true, true)
            DeleteObject(CarryPackage)
            CarryPackage = nil
            -- update ingredients
            TriggerServerEvent('prp-labs:server:AddIngredients', data.lab, data.task)
            TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, false)
        end, function() -- cancel
            ClearPedTasks(ped)
            DetachEntity(CarryPackage, true, true)
            DeleteObject(CarryPackage)
            CarryPackage = nil
            TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, false)
        end)
    else
        ProjectRP.Functions.Notify("Maybe you should first grab some ingredients!", "error", 2500)
    end
end)

RegisterNetEvent('prp-labs:client:SetTemp', function(data)
    -- SET BUSY
    TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, true)

    local input = exports['prp-input']:ShowInput({
        header = "Set "..Locales[data.lab].parameter,
        submitText = "Enter",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'temperature',
                text = Locales[data.lab].unit
            }
        }
    })
    if input then
        if not input.temperature then 
            -- UNSET BUSY
            TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, false)
            return 
        end
        local temp = tonumber(input.temperature)
        if temp <= 0 or temp >= 100 then
            -- UNSET BUSY
            TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, false)
            ProjectRP.Functions.Notify('Invalid '..Locales[data.lab].parameter..'.. (1 to 100)', 'error', 2500)
            return
        end
        -- UNSET BUSY
        TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, false)
        TriggerServerEvent('prp-labs:server:SetTemperature', data.lab, data.task, temp)
    else
        -- UNSET BUSY
        TriggerServerEvent('prp-labs:server:UpdateTasks', data.lab, data.task, false)
    end
end)

RegisterNetEvent('prp-labs:client:UpdateStock', function(lab, amount)
    Config.Labs[lab].ingredients.stock = amount
end)

RegisterNetEvent('prp-labs:client:UpdateIngredients', function(lab, bool)
    Config.Labs[lab].ingredients.busy = bool
end)

RegisterNetEvent('prp-labs:client:UpdateTasks', function(lab, task, bool)
    Config.Labs[lab].tasks[task].busy = bool
end)

RegisterNetEvent('prp-labs:client:SetTemperature', function(lab, task, temp)
    Config.Labs[lab].tasks[task].temperature = temp
end)

RegisterNetEvent('prp-labs:client:SetTaskStarted', function(lab, task, bool)
    Config.Labs[lab].tasks[task].started = bool
end)

RegisterNetEvent('prp-labs:client:SetTaskCompleted', function(lab, task, bool)
    Config.Labs[lab].tasks[task].completed = bool
end)

RegisterNetEvent('prp-labs:client:AddIngredients', function(lab, task, amount)
    Config.Labs[lab].tasks[task].ingredients.current = amount
end)

RegisterNetEvent('prp-labs:client:FinishLab', function(lab)
    for k, v in pairs(Config.Labs[lab].tasks) do
        v.busy = false
        v.completed = false
        v.started = false
        v.ingredients.current = 0
        v.timeremaining = v.duration
        v.temperature = 80
    end
end)

RegisterNetEvent('prp-labs:client:CureBusyState', function(lab, state)
    Config.Labs[lab].curing.busy = state
end)

RegisterNetEvent('prp-labs:client:CureStartedState', function(lab, state)
    Config.Labs[lab].curing.started = state
end)

RegisterNetEvent('prp-labs:client:CureCompletedState', function(lab, state)
    Config.Labs[lab].curing.completed = state
end)

RegisterNetEvent('prp-labs:client:SetPurity', function(lab, purity)
    Config.Labs[lab].curing.purity = purity
end)

RegisterNetEvent('prp-labs:client:AddCureBatch', function(data)
    if Config.Labs[data.lab].curing.busy then
        ProjectRP.Functions.Notify('Someone is already using this!', 'error', 2500)
        return
    elseif Config.Labs[data.lab].curing.started then
        ProjectRP.Functions.Notify('The process has already started!', 'error', 2500)
        return
    else
        -- SET BUSY
        TriggerServerEvent('prp-labs:client:CureBusyState', data.lab, true)
        local ped = PlayerPedId()
        -- ANIMATION
        -- ...
        ProjectRP.Functions.Progressbar("pickup_reycle_package", "Adding Batch..", 500, false, true, {}, {}, {}, {}, function() -- Done
            ClearPedTasks(ped)
            TriggerServerEvent('prp-labs:server:AddCureBatch', data.lab)
            -- SET NOT BUSY
            TriggerServerEvent('prp-labs:client:CureBusyState', data.lab, false)
        end, function() -- cancel
            ClearPedTasks(ped)
            TriggerServerEvent('prp-labs:client:CureBusyState', data.lab, false)
        end)
    end
end)

RegisterNetEvent('prp-labs:client:TakeCureBatch', function(data)
    if Config.Labs[data.lab].curing.busy then
        ProjectRP.Functions.Notify('Someone is already using this!', 'error', 2500)
        return
    else
        -- SET BUSY
        TriggerServerEvent('prp-labs:client:CureBusyState', data.lab, true)
        local ped = PlayerPedId()
        -- ANIMATION
        -- ...
        ProjectRP.Functions.Progressbar("pickup_reycle_package", "Taking Batch..", 500, false, true, {}, {}, {}, {}, function() -- Done
            ClearPedTasks(ped)
            TriggerServerEvent('prp-labs:server:TakeCureBatch', data.lab)
            -- SET NOT BUSY
            TriggerServerEvent('prp-labs:client:CureBusyState', data.lab, false)
        end, function() -- cancel
            ClearPedTasks(ped)
            TriggerServerEvent('prp-labs:client:CureBusyState', data.lab, false)
        end)
    end
end)

RegisterNetEvent('prp-labs:client:MakeMethBags', function()
    ProjectRP.Functions.Progressbar("makeMethBags", "Making smaller meth bags..", 12000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('prp-labs:server:MakeMethBags')
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        ProjectRP.Functions.Notify("Canceled..", "error")
    end)
end)

RegisterNetEvent('prp-labs:client:MakeCokeBags', function()
    ProjectRP.Functions.Progressbar("makeCokeBags", "Making smaller coke bags..", 12000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('prp-labs:server:MakeCokeBags')
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        ProjectRP.Functions.Notify("Canceled..", "error")
    end)
end)

RegisterNetEvent('prp-labs:client:MakeWeedBags', function()
    ProjectRP.Functions.Progressbar("makeWeedBags", "Making smaller weed bags..", 12000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('prp-labs:server:MakeWeedBags')
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        ProjectRP.Functions.Notify("Canceled..", "error")
    end)
end)