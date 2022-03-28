local ProjectRP = exports['prp-core']:GetCoreObject()
-- Drawtext -
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
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


Citizen.CreateThread(function()
    local PlayerData = ProjectRP.Functions.GetPlayerData()
    while true do
        local sleep = 100
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerData.job.name == "tequilala" then
                for k, v in pairs(Config.Locations["duty"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 5 then
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            if onDuty then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Get off duty")
                            else
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~r~E~w~ - Get on duty")
                            end
                            if IsControlJustReleased(0, 38) then
                                onDuty = not onDuty
                                TriggerServerEvent("prp-menu:TequilalaDutyMenu")
                            end
                        elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                            sleep = 5
                            DrawText3D(v.x, v.y, v.z, "on/off duty")
                        end
                    end
                end

                for k, v in pairs(Config.Locations["pumps"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if onDuty then
                            if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Pour Beer")
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("prp-menu:TequilalaBeerMenu")
                                end
                            elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "Pour Beer")
                            end  
                        end
                    end
                end

                for k, v in pairs(Config.Locations["mixer"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if onDuty then
                            if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Mix Drinks")
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("prp-menu:TequilalaMixerMenu")
                                end
                            elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "Mix Drinks")
                            end  
                        end
                    end
                end

                for k, v in pairs(Config.Locations["fridge"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if onDuty then
                            if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Open Fridge")
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("prp-menu:TequilalaMenu")
                                end
                            elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "Open Fridge")
                            end  
                        end
                    end
                end

                -- Uncomment if you want to include a storage
                
                --[[for k, v in pairs(Config.Locations["storage"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if onDuty then
                            if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Open Storage")
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("prp-tequilalajob:Storage")
                                end
                            elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "Open Storage")
                            end  
                        end
                    end
                end]]

                for k, v in pairs(Config.Locations["cashregister"]) do
                    if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if onDuty then
                            if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Cash Register")
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("prp-tequilalajob:bill")
                                end
                            elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                                sleep = 5
                                DrawText3D(v.x, v.y, v.z, "Cash Register")
                            end  
                        end
                    end
                end
            else
                Citizen.Wait(2000)
            end
            
            for k, v in pairs(Config.Locations["tray1"]) do
                if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            sleep = 5
                            DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Tray")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("prp-tequilalajob:Tray1")
                            end
                        elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                            sleep = 5
                            DrawText3D(v.x, v.y, v.z, "Tray")
                        end  
                end
            end

            -- Uncomment if you have a MLO/MAP that includes the upstairs bar

            --[[for k, v in pairs(Config.Locations["tray2"]) do
                if #(pos - vector3(v.x, v.y, v.z)) < 4.5 then
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            sleep = 5
                            DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  Tray")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("prp-tequilalajob:Tray2")
                            end
                        elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                            sleep = 5
                            DrawText3D(v.x, v.y, v.z, "Tray")
                        end  
                end
            end]]
        end
        Citizen.Wait(sleep)
    end
end)

-- prp-menu --

RegisterNetEvent('prp-menu:TequilalaMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Fridge |",
            isMenuHeader = true
        },
        { 
            header = "• Order Items",
            txt = "Buy items from the shop!",
            params = {
                event = "prp-tequilalajob:shop"
            }
        },
        { 
            header = "• Open Fridge",
            txt = "See what you have in storage",
            params = { 
                event = "prp-tequilalajob:Storage2"
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('prp-menu:TequilalaBeerMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Beer Menu |",
            isMenuHeader = true
        },
        { 
            header = "• A.M. Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:am-beer"
            }
        },
        { 
            header = "• Logger Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:logger-beer"
            }
        },
        { 
            header = "• Stronzo Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:stronzo-beer"
            }
        },
        { 
            header = "• Dusche Beer",
            txt = "Pint Glass",
            params = {
                event = "prp-tequilalajob:dusche-beer"
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('prp-menu:TequilalaMixerMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Mixer Menu |",
            isMenuHeader = true
        },
        { 
            header = "• Sunny Cocktail",
            txt = "Cocktail Glass",
            params = {
                event = "prp-tequilalajob:sunny-cocktail"
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('prp-menu:TequilalaDutyMenu', function(data)
    exports['prp-menu']:openMenu({
        { 
            header = "| Clocking in/Off work |",
            isMenuHeader = true
        },
        { 
            header = "• Sign In/Off",
            txt = "",
            params = {
                event = "prp-tequilalajob:Duty",
            }
        },
        {
            header = "• Close Menu",
            txt = "", 
            params = { 
                event = "prp-menu:client:closeMenu"
            }
        },
    })
end)

local function closeMenuFull()
    exports['prp-menu']:closeMenu()
end

-- Register Stuff --
RegisterNetEvent("prp-tequilalajob:bill", function()
    local dialog = exports['prp-input']:ShowInput({
        header = "Till",
        submitText = "Bill Person",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'id',
                text = 'paypal id'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = '$ amount!'
            }
        }
    })
    if dialog then
        if not dialog.id or not dialog.amount then return end
        TriggerServerEvent("prp-tequilalajob:bill:player", dialog.id, dialog.amount)
    end
end)