local ProjectRP = exports['prp-core']:GetCoreObject()
local PlayerGang = ProjectRP.Functions.GetPlayerData().gang
local shownGangMenu = false

-- UTIL
local function CloseMenuFullGang()
    exports['prp-menu']:closeMenu()
    exports['prp-core']:HideText()
    shownGangMenu = false
end

local function comma_valueGang(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

--//Events
AddEventHandler('onResourceStart', function(resource)--if you restart the resource
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerGang = ProjectRP.Functions.GetPlayerData().gang
    end
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerGang = ProjectRP.Functions.GetPlayerData().gang
end)

RegisterNetEvent('ProjectRP:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang
end)

RegisterNetEvent('prp-gangmenu:client:Stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "boss_" .. PlayerGang.name, {
        maxweight = 4000000,
        slots = 100,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "boss_" .. PlayerGang.name)
end)

RegisterNetEvent('prp-gangmenu:client:Warbobe', function()
    TriggerEvent('prp-clothing:client:openOutfitMenu')
end)

RegisterNetEvent('prp-gangmenu:client:OpenMenu', function()
    shownGangMenu = true
    local gangMenu = {
        {
            header = "Gang Management  - " .. string.upper(PlayerGang.label),
            isMenuHeader = true,
        },
        {
            header = "📋 Manage Gang Members",
            txt = "Recruit or Fire Gang Members",
            params = {
                event = "prp-gangmenu:client:ManageGang",
            }
        },
        {
            header = "💛 Recruit Members",
            txt = "Hire Gang Members",
            params = {
                event = "prp-gangmenu:client:HireMembers",
            }
        },
        {
            header = "🗄️ Storage Access",
            txt = "Open Gang Stash",
            params = {
                event = "prp-gangmenu:client:Stash",
            }
        },
        {
            header = "🚪 Outfits",
            txt = "Change Clothes",
            params = {
                event = "prp-gangmenu:client:Warbobe",
            }
        },
        {
            header = "💰 Money Management",
            txt = "Check your Gang Balance",
            params = {
                event = "prp-gangmenu:client:SocietyMenu",
            }
        },
        {
            header = "Exit",
            params = {
                event = "prp-menu:closeMenu",
            }
        },
    }
    exports['prp-menu']:openMenu(gangMenu)
end)

RegisterNetEvent('prp-gangmenu:client:ManageGang', function()
    local GangMembersMenu = {
        {
            header = "Manage Gang Members - " .. string.upper(PlayerGang.label),
            isMenuHeader = true,
        },
    }
    ProjectRP.Functions.TriggerCallback('prp-gangmenu:server:GetEmployees', function(cb)
        for _, v in pairs(cb) do
            GangMembersMenu[#GangMembersMenu + 1] = {
                header = v.name,
                txt = v.grade.name,
                params = {
                    event = "prp-gangmenu:lient:ManageMember",
                    args = {
                        player = v,
                        work = PlayerGang
                    }
                }
            }
        end
        GangMembersMenu[#GangMembersMenu + 1] = {
            header = "< Return",
            params = {
                event = "prp-gangmenu:client:OpenMenu",
            }
        }
        exports['prp-menu']:openMenu(GangMembersMenu)
    end, PlayerGang.name)
end)

RegisterNetEvent('prp-gangmenu:lient:ManageMember', function(data)
    local MemberMenu = {
        {
            header = "Manage " .. data.player.name .. " - " .. string.upper(PlayerGang.label),
            isMenuHeader = true,
        },
    }
    for k, v in pairs(ProjectRP.Shared.Gangs[data.work.name].grades) do
        MemberMenu[#MemberMenu + 1] = {
            header = v.name,
            txt = "Grade: " .. k,
            params = {
                isServer = true,
                event = "prp-gangmenu:server:GradeUpdate",
                args = {
                    cid = data.player.empSource,
                    grade = tonumber(k),
                    gradename = v.name
                }
            }
        }
    end
    MemberMenu[#MemberMenu + 1] = {
        header = "Fire",
        params = {
            isServer = true,
            event = "prp-gangmenu:server:FireMember",
            args = data.player.empSource
        }
    }
    MemberMenu[#MemberMenu + 1] = {
        header = "< Return",
        params = {
            event = "prp-gangmenu:client:ManageGang",
        }
    }
    exports['prp-menu']:openMenu(MemberMenu)
end)

RegisterNetEvent('prp-gangmenu:client:HireMembers', function()
    local HireMembersMenu = {
        {
            header = "Hire Gang Members - " .. string.upper(PlayerGang.label),
            isMenuHeader = true,
        },
    }
    ProjectRP.Functions.TriggerCallback('prp-gangmenu:getplayers', function(players)
        for _, v in pairs(players) do
            if v and v ~= PlayerId() then
                HireMembersMenu[#HireMembersMenu + 1] = {
                    header = v.name,
                    txt = "Citizen ID: " .. v.citizenid .. " - ID: " .. v.sourceplayer,
                    params = {
                        isServer = true,
                        event = "prp-gangmenu:server:HireMember",
                        args = v.sourceplayer
                    }
                }
            end
        end
        HireMembersMenu[#HireMembersMenu + 1] = {
            header = "< Return",
            params = {
                event = "prp-gangmenu:client:OpenMenu",
            }
        }
        exports['prp-menu']:openMenu(HireMembersMenu)
    end)
end)

RegisterNetEvent('prp-gangmenu:client:SocietyMenu', function()
    ProjectRP.Functions.TriggerCallback('prp-gangmenu:server:GetAccount', function(cb)
        local SocietyMenu = {
            {
                header = "Balance: $" .. comma_valueGang(cb) .. " - " .. string.upper(PlayerGang.label),
                isMenuHeader = true,
            },
            {
                header = "💸 Deposit",
                txt = "Deposit Money",
                params = {
                    event = "prp-gangmenu:client:SocietyDeposit",
                    args = comma_valueGang(cb)
                }
            },
            {
                header = "💸 Withdraw",
                txt = "Withdraw Money",
                params = {
                    event = "prp-gangmenu:client:SocietyWithdraw",
                    args = comma_valueGang(cb)
                }
            },
            {
                header = "< Return",
                params = {
                    event = "prp-gangmenu:client:OpenMenu",
                }
            },
        }
        exports['prp-menu']:openMenu(SocietyMenu)
    end, PlayerGang.name)
end)

RegisterNetEvent('prp-gangmenu:client:SocietyDeposit', function(saldoattuale)
    local deposit = exports['prp-input']:ShowInput({
        header = "Deposit Money <br> Available Balance: $" .. saldoattuale,
        submitText = "Confirm",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'Amount'
            }
        }
    })
    if deposit then
        if not deposit.amount then return end
        TriggerServerEvent("prp-gangmenu:server:depositMoney", tonumber(deposit.amount))
    end
end)

RegisterNetEvent('prp-gangmenu:client:SocietyWithdraw', function(saldoattuale)
    local withdraw = exports['prp-input']:ShowInput({
        header = "Withdraw Money <br> Available Balance: $" .. saldoattuale,
        submitText = "Confirm",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = '$'
            }
        }
    })
    if withdraw then
        if not withdraw.amount then return end
        TriggerServerEvent("prp-gangmenu:server:withdrawMoney", tonumber(withdraw.amount))
    end
end)

-- MAIN THREAD

CreateThread(function()
    if Config.UseTarget then
        for gang, zones in pairs(Config.GangMenuZones) do
            for index, data in ipairs(zones) do
                exports['prp-target']:AddBoxZone(gang.."-GangMenu"..index, data.coords, data.length, data.width, {
                    name = gang.."-GangMenu"..index,
                    heading = data.heading,
                    -- debugPoly = true,
                    minZ = data.minZ,
                    maxZ = data.maxZ,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "prp-gangmenu:client:OpenMenu",
                            icon = "fas fa-sign-in-alt",
                            label = "Gang Menu",
                            canInteract = function() return gang == PlayerGang.name and PlayerGang.isboss end,
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        while true do
            local wait = 2500
            local pos = GetEntityCoords(PlayerPedId())
            local inRangeGang = false
            local nearGangmenu = false
            if PlayerGang then
                wait = 0
                for k, menus in pairs(Config.GangMenus) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerGang.name and PlayerGang.isboss then
                            if #(pos - coords) < 5.0 then
                                inRangeGang = true
                                if #(pos - coords) <= 1.5 then
                                    nearGangmenu = true
                                    if not shownGangMenu then
                                        exports['prp-core']:DrawText('[E] Open Gang Management', 'left')
                                    end

                                    if IsControlJustReleased(0, 38) then
                                        exports['prp-core']:HideText()
                                        TriggerEvent("prp-gangmenu:client:OpenMenu")
                                    end
                                end

                                if not nearGangmenu and shownGangMenu then
                                    CloseMenuFullGang()
                                    shownGangMenu = false
                                end
                            end
                        end
                    end
                end
                if not inRangeGang then
                    Wait(1500)
                    if shownGangMenu then
                        CloseMenuFullGang()
                        shownGangMenu = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)
