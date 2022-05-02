RegisterNetEvent('prp-labs:weaponbunker:OpenRifleMenu', function()
    exports['prp-menu']:openMenu({
        {
            header = "< Rifle Menu",
            txt = "ESC or click to close",
            params = {
                event = "prp-menu:closeMenu",
            }
        },
        {
            header = "AK-47",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_assaultrifle"].item1]["label"]..": "..Config.CraftingCost["weapon_assaultrifle"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_assaultrifle"].item2]["label"]..": "..Config.CraftingCost["weapon_assaultrifle"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_assaultrifle"].item3]["label"]..": "..Config.CraftingCost["weapon_assaultrifle"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftWeapon",
                args = {
                    weapon = "weapon_assaultrifle",
                }
            }
        },
        -- {
        --     header = "Special Carbine",
        --     txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_specialcarbine"].item1]["label"]..": "..Config.CraftingCost["weapon_specialcarbine"].cost1.." | ".. 
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_specialcarbine"].item2]["label"]..": "..Config.CraftingCost["weapon_specialcarbine"].cost2.." | "..
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_specialcarbine"].item3]["label"]..": "..Config.CraftingCost["weapon_specialcarbine"].cost3,
        --     params = {
        --         event = "prp-labs:weaponbunker:CraftWeapon",
        --         args = {
        --             weapon = "weapon_specialcarbine",
        --         }
        --     }
        -- },
        -- {
        --     header = "Advanced Rifle",
        --     txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_advancedrifle"].item1]["label"]..": "..Config.CraftingCost["weapon_advancedrifle"].cost1.." | ".. 
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_advancedrifle"].item2]["label"]..": "..Config.CraftingCost["weapon_advancedrifle"].cost2.." | "..
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_advancedrifle"].item3]["label"]..": "..Config.CraftingCost["weapon_advancedrifle"].cost3,
        --     params = {
        --         event = "prp-labs:weaponbunker:CraftWeapon",
        --         args = {
        --             weapon = "weapon_advancedrifle",
        --         }
        --     }
        -- }
    })
end)

RegisterNetEvent('prp-labs:weaponbunker:OpenSmgMenu', function()
    exports['prp-menu']:openMenu({
        {
            header = "< SMG Menu",
            txt = "ESC or click to close",
            params = {
                event = "prp-menu:closeMenu",
            }
        },
        {
            header = "Mini Uzi",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_microsmg"].item1]["label"]..": "..Config.CraftingCost["weapon_microsmg"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_microsmg"].item2]["label"]..": "..Config.CraftingCost["weapon_microsmg"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_microsmg"].item3]["label"]..": "..Config.CraftingCost["weapon_microsmg"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftWeapon",
                args = {
                    weapon = "weapon_microsmg",
                }
            }
        },
        -- {
        --     header = "Assault SMG",
        --     txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_assaultsmg"].item1]["label"]..": "..Config.CraftingCost["weapon_assaultsmg"].cost1.." | ".. 
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_assaultsmg"].item2]["label"]..": "..Config.CraftingCost["weapon_assaultsmg"].cost2.." | "..
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_assaultsmg"].item3]["label"]..": "..Config.CraftingCost["weapon_assaultsmg"].cost3,
        --     params = {
        --         event = "prp-labs:weaponbunker:CraftWeapon",
        --         args = {
        --             weapon = "weapon_assaultsmg",
        --         }
        --     }
        -- },
        -- {
        --     header = "Mini SMG",
        --     txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_minismg"].item1]["label"]..": "..Config.CraftingCost["weapon_minismg"].cost1.." | ".. 
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_minismg"].item2]["label"]..": "..Config.CraftingCost["weapon_minismg"].cost2.." | "..
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_minismg"].item3]["label"]..": "..Config.CraftingCost["weapon_minismg"].cost3,
        --     params = {
        --         event = "prp-labs:weaponbunker:CraftWeapon",
        --         args = {
        --             weapon = "weapon_minismg",
        --         }
        --     }
        -- },
        {
            header = "Tec-9",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_machinepistol"].item1]["label"]..": "..Config.CraftingCost["weapon_machinepistol"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_machinepistol"].item2]["label"]..": "..Config.CraftingCost["weapon_machinepistol"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_machinepistol"].item3]["label"]..": "..Config.CraftingCost["weapon_machinepistol"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftWeapon",
                args = {
                    weapon = "weapon_machinepistol",
                }
            }
        }
    })
end)

RegisterNetEvent('prp-labs:weaponbunker:OpenPistolMenu', function()
    exports['prp-menu']:openMenu({
        {
            header = "< Pistol Menu",
            txt = "ESC or click to close",
            params = {
                event = "prp-menu:closeMenu",
            }
        },
        {
            header = "Colt M1911",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_pistol"].item1]["label"]..": "..Config.CraftingCost["weapon_pistol"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_pistol"].item2]["label"]..": "..Config.CraftingCost["weapon_pistol"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_pistol"].item3]["label"]..": "..Config.CraftingCost["weapon_pistol"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftWeapon",
                args = {
                    weapon = "weapon_pistol",
                }
            }
        },
        {
            header = "USP-45",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_heavypistol"].item1]["label"]..": "..Config.CraftingCost["weapon_heavypistol"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_heavypistol"].item2]["label"]..": "..Config.CraftingCost["weapon_heavypistol"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["weapon_heavypistol"].item3]["label"]..": "..Config.CraftingCost["weapon_heavypistol"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftWeapon",
                args = {
                    weapon = "weapon_heavypistol",
                }
            }
        },
        -- {
        --     header = "Pistol 50.Cal",
        --     txt =   ProjectRP.Shared.Items[Config.CraftingCost["weapon_pistol50"].item1]["label"]..": "..Config.CraftingCost["weapon_pistol50"].cost1.." | ".. 
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_pistol50"].item2]["label"]..": "..Config.CraftingCost["weapon_pistol50"].cost2.." | "..
        --             ProjectRP.Shared.Items[Config.CraftingCost["weapon_pistol50"].item3]["label"]..": "..Config.CraftingCost["weapon_pistol50"].cost3,
        --     params = {
        --         event = "prp-labs:weaponbunker:CraftWeapon",
        --         args = {
        --             weapon = "weapon_pistol50",
        --         }
        --     }
        -- }
    })
end)

RegisterNetEvent('prp-labs:weaponbunker:OpenAmmoMenu', function()
    exports['prp-menu']:openMenu({
        {
            header = "< Ammo Menu",
            txt = "ESC or click to close",
            params = {
                event = "prp-menu:closeMenu",
            }
        },
        {
            header = "Pistol Ammo x10",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["pistol_ammo"].item1]["label"]..": "..Config.CraftingCost["pistol_ammo"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["pistol_ammo"].item2]["label"]..": "..Config.CraftingCost["pistol_ammo"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["pistol_ammo"].item3]["label"]..": "..Config.CraftingCost["pistol_ammo"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftAmmo",
                args = {
                    ammo = "pistol_ammo",
                }
            }
        },
        {
            header = "SMG Ammo x10",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["smg_ammo"].item1]["label"]..": "..Config.CraftingCost["smg_ammo"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["smg_ammo"].item2]["label"]..": "..Config.CraftingCost["smg_ammo"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["smg_ammo"].item3]["label"]..": "..Config.CraftingCost["smg_ammo"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftAmmo",
                args = {
                    ammo = "smg_ammo",
                }
            }
        },
        {
            header = "Rifle Ammo x10",
            txt =   ProjectRP.Shared.Items[Config.CraftingCost["rifle_ammo"].item1]["label"]..": "..Config.CraftingCost["rifle_ammo"].cost1.." | ".. 
                    ProjectRP.Shared.Items[Config.CraftingCost["rifle_ammo"].item2]["label"]..": "..Config.CraftingCost["rifle_ammo"].cost2.." | "..
                    ProjectRP.Shared.Items[Config.CraftingCost["rifle_ammo"].item3]["label"]..": "..Config.CraftingCost["rifle_ammo"].cost3,
            params = {
                event = "prp-labs:weaponbunker:CraftAmmo",
                args = {
                    ammo = "rifle_ammo",
                }
            }
        },
        -- {
        --     header = "LMG Ammo x10",
        --     txt =   ProjectRP.Shared.Items[Config.CraftingCost["mg_ammo"].item1]["label"]..": "..Config.CraftingCost["mg_ammo"].cost1.." | ".. 
        --             ProjectRP.Shared.Items[Config.CraftingCost["mg_ammo"].item2]["label"]..": "..Config.CraftingCost["mg_ammo"].cost2.." | "..
        --             ProjectRP.Shared.Items[Config.CraftingCost["mg_ammo"].item3]["label"]..": "..Config.CraftingCost["mg_ammo"].cost3,
        --     params = {
        --         event = "prp-labs:weaponbunker:CraftAmmo",
        --         args = {
        --             ammo = "mg_ammo",
        --         }
        --     }
        -- }
    })
end)

RegisterNetEvent('prp-labs:weaponbunker:OpenStash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "weaponbunker_stash", {
        maxweight = 4000000,
        slots = 80,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "weaponbunker_stash")
end)

RegisterNetEvent('prp-labs:weaponbunker:CraftWeapon', function(data)
    ProjectRP.Functions.Progressbar("CraftWeapon", "Crafting...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('prp-labs:server:craftItem',data.weapon)
    end, function() -- Cancel
        ProjectRP.Functions.Notify("Cancelled..", "error")
    end)
end)

RegisterNetEvent('prp-labs:weaponbunker:CraftAmmo', function(data)
    ProjectRP.Functions.Progressbar("CraftWeapon", "Crafting...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('prp-labs:server:craftAmmo',data.ammo)
    end, function() -- Cancel
        ProjectRP.Functions.Notify("Cancelled..", "error")
    end)
end)

CreateThread(function()
    exports["prp-target"]:AddBoxZone("gunentrance", Config.Labs.gunbunker.entrance.xyz, 0.8, 1.4, {
        name = "gunentrance",
        heading = Config.Labs.gunbunker.entrance.w,
        debugPoly = false,
        minZ = 143.20,
        maxZ = 145.20,
        }, {
            options = {
            {
                action = function()
                    enterKeyLab("gunbunker")
                end,
                icon = "fas fa-user-secret",
                label = "Enter",
                canInteract = function()
                    if Config.Labs.gunbunker.locked then return false end
                    return true
                end,
            },
            {
                action = function()
                    LockUnlock("gunbunker")
                end,
                icon = "fas fa-key",
                label = "Lock/Unlock Door",
                item = "gunkey"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddBoxZone("gunexit", Config.Labs.gunbunker.exit.xyz, 0.7, 1.6, {
        name = "gunexit",
        heading = Config.Labs.gunbunker.exit.w,
        debugPoly = false,
        minZ = -98.00,
        maxZ = -95.00,
        }, {
            options = {
            {
                action = function()
                    Exitlab("gunbunker")
                end,
                icon = "fas fa-user-secret",
                label = "Exit",
                canInteract = function()
                    if Config.Labs.gunbunker.locked then return false end
                    return true
                end,
            },
            {
                action = function()
                    LockUnlock("gunbunker")
                end,
                icon = "fas fa-key",
                label = "Lock/Unlock Door",
                item = "gunkey"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddCircleZone("gunammo", Config.Labs.gunbunker.locations.ammo, 1.5, {
        name = "gunammo",
        useZ = true,
        debugPoly = false
        }, {
            options = {
            {
                type = "client",
                event = "prp-labs:weaponbunker:OpenAmmoMenu",
                icon = "fas fa-user-secret",
                label = "Craft Ammo"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddCircleZone("gunpistol", Config.Labs.gunbunker.locations.pistol, 1.5, {
        name = "gunpistol",
        useZ = true,
        debugPoly = false
        }, {
            options = {
            {
                type = "client",
                event = "prp-labs:weaponbunker:OpenPistolMenu",
                icon = "fas fa-user-secret",
                label = "Craft Pistol"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddCircleZone("gunsmg", Config.Labs.gunbunker.locations.smg, 1.5, {
        name = "gunsmg",
        useZ = true,
        debugPoly = false
        }, {
            options = {
            {
                type = "client",
                event = "prp-labs:weaponbunker:OpenSmgMenu",
                icon = "fas fa-user-secret",
                label = "Craft SMG"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddCircleZone("gunrifle", Config.Labs.gunbunker.locations.rifle, 1.5, {
        name = "gunrifle",
        useZ = true,
        debugPoly = false
        }, {
            options = {
            {
                type = "client",
                event = "prp-labs:weaponbunker:OpenRifleMenu",
                icon = "fas fa-user-secret",
                label = "Craft Rifle"
            }
        },
        distance = 1.5
    })
    exports["prp-target"]:AddCircleZone("gunstash", Config.Labs.gunbunker.locations.weaponstash, 1.5, {
        name = "gunstash",
        useZ = true,
        debugPoly = false
        }, {
            options = {
            {
                type = "client",
                event = "prp-labs:weaponbunker:OpenStash",
                icon = "fas fa-archive",
                label = "Open Stash"
            }
        },
        distance = 1.5
    })
end)