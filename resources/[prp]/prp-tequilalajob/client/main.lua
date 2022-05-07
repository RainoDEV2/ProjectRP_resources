local ProjectRP = exports['prp-core']:GetCoreObject()
isLoggedIn = true
PlayerJob = {}

local onDuty = false

function DrawText3Ds(x, y, z, text)
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


RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    ProjectRP.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "tequilala" then
                TriggerServerEvent("ProjectRP:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('ProjectRP:Client:SetDuty')
AddEventHandler('ProjectRP:Client:SetDuty', function(duty)
    onDuty = duty
end)

Citizen.CreateThread(function() 
    tequilala = AddBlipForCoord(-564.81, 274.56, 83.02)
    SetBlipSprite(tequilala, 93)
    SetBlipDisplay(tequilala, 4)
    SetBlipScale  (tequilala, 0.5)
    SetBlipAsShortRange(tequilala, true)
    SetBlipColour(tequilala, 28)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("tequilala")
    EndTextCommandSetBlipName(tequilala)
end)

RegisterNetEvent("prp-tequilalajob:Duty")
AddEventHandler("prp-tequilalajob:Duty", function()
    TriggerServerEvent("ProjectRP:ToggleDuty")
end)

RegisterNetEvent("prp-tequilalajob:Tray1")
AddEventHandler("prp-tequilalajob:Tray1", function()
    TriggerEvent("inventory:client:SetCurrentStash", "pickuptequilala1")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pickuptequilala1", {
        maxweight = 20000,
        slots = 5,
    })
end)

RegisterNetEvent("prp-tequilalajob:Tray2")
AddEventHandler("prp-tequilalajob:Tray2", function()
    TriggerEvent("inventory:client:SetCurrentStash", "pickuptequilala2")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pickuptequilala2", {
        maxweight = 20000,
        slots = 5,
    })
end)

RegisterNetEvent("prp-tequilalajob:Storage")
AddEventHandler("prp-tequilalajob:Storage", function()
    TriggerEvent("inventory:client:SetCurrentStash", "tequilalastash")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "tequilalastash", {
        maxweight = 750000,
        slots = 40,
    })
end)

RegisterNetEvent("prp-tequilalajob:Storage2")
AddEventHandler("prp-tequilalajob:Storage2", function()
    TriggerEvent("inventory:client:SetCurrentStash", "tequilalafridge")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "tequilalafridge", {
        maxweight = 750000,
        slots = 40,
    })
end)

-- Drink Creations
RegisterNetEvent("prp-tequilalajob:am-beer")
AddEventHandler("prp-tequilalajob:am-beer", function()
    if onDuty then
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
        if HasItem then
           MakeAM()
        else
            ProjectRP.Functions.Notify("You don't have a Pint Glass..", "error")
        end
      end, 'pintglass')
    else
        ProjectRP.Functions.Notify("You must be Clocked into work", "error")
    end
end)

RegisterNetEvent("prp-tequilalajob:logger-beer")
AddEventHandler("prp-tequilalajob:logger-beer", function()
    if onDuty then
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
        if HasItem then
           MakeLoggerr()
        else
            ProjectRP.Functions.Notify("You don't have a Pint Glass..", "error")
        end
      end, 'pintglass')
    else
        ProjectRP.Functions.Notify("You must be Clocked into work", "error")
    end
end)

RegisterNetEvent("prp-tequilalajob:stronzo-beer")
AddEventHandler("prp-tequilalajob:stronzo-beer", function()
    if onDuty then
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
        if HasItem then
           MakeStronzo()
        else
            ProjectRP.Functions.Notify("You don't have a Pint Glass..", "error")
        end
      end, 'pintglass')
    else
        ProjectRP.Functions.Notify("You must be Clocked into work", "error")
    end
end)

RegisterNetEvent("prp-tequilalajob:dusche-beer")
AddEventHandler("prp-tequilalajob:dusche-beer", function()
    if onDuty then
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
        if HasItem then
           MakeDusche()
        else
            ProjectRP.Functions.Notify("You don't have a Pint Glass..", "error")
        end
      end, 'pintglass')
    else
        ProjectRP.Functions.Notify("You must be Clocked into work", "error")
    end
end)

RegisterNetEvent("prp-tequilalajob:sunny-cocktail")
AddEventHandler("prp-tequilalajob:sunny-cocktail", function()
    if onDuty then
    ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
        if HasItem then
           MakeSunny()
        else
            ProjectRP.Functions.Notify("You don't have a Cocktail Glass..", "error")
        end
      end, 'cocktailglass')
    else
        ProjectRP.Functions.Notify("You must be Clocked into work", "error")
    end
end)

-- Functions --
function MakeAM()
    TriggerServerEvent('ProjectRP:Server:RemoveItem', "pintglass", 1)
    ProjectRP.Functions.Progressbar("pickup", "Pouring Pint...", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },{
        animDict = "amb@world_human_drinking_fat@coffee@female@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_pint_glass_tall",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    } 
)
    Citizen.Wait(4000)
    TriggerServerEvent('ProjectRP:Server:AddItem', "am-beer", 1)
    --TriggerEvent("inventory:client:ItemBox", ProjectRP.Shared.Items["am-beer"], "add")
    ProjectRP.Functions.Notify("You poured a pint", "success")
end  


function MakeLogger()
    TriggerServerEvent('ProjectRP:Server:RemoveItem', "pintglass", 1)
    ProjectRP.Functions.Progressbar("pickup", "Pouring Pint...", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },{
        animDict = "amb@world_human_drinking_fat@coffee@female@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_pint_glass_tall",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    } 
)
    Citizen.Wait(4000)
    TriggerServerEvent('ProjectRP:Server:AddItem', "logger-beer", 1)
    --TriggerEvent("inventory:client:ItemBox", ProjectRP.Shared.Items["logger-beer"], "add")
    ProjectRP.Functions.Notify("You poured a pint", "success")
end

function MakeStronzo()
    TriggerServerEvent('ProjectRP:Server:RemoveItem', "pintglass", 1)
    ProjectRP.Functions.Progressbar("pickup", "Mixing Cocktail...", 8000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },{
        animDict = "amb@world_human_drinking_fat@coffee@female@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_pint_glass_tall",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    } 
)
    Citizen.Wait(6000)
    TriggerServerEvent('ProjectRP:Server:AddItem', "stronzo-beer", 1)
    --TriggerEvent("inventory:client:ItemBox", ProjectRP.Shared.Items["stronzo-beer"], "add")
    ProjectRP.Functions.Notify("You made a cocktail", "success")
end

function MakeDusche()
    TriggerServerEvent('ProjectRP:Server:RemoveItem', "pintglass", 1)
    ProjectRP.Functions.Progressbar("pickup", "Mixing Cocktail...", 8000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },{
        animDict = "amb@world_human_drinking_fat@coffee@female@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_pint_glass_tall",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    } 
)
    Citizen.Wait(6000)
    TriggerServerEvent('ProjectRP:Server:AddItem', "dusche-beer", 1)
    --TriggerEvent("inventory:client:ItemBox", ProjectRP.Shared.Items["dusche-beer"], "add")
    ProjectRP.Functions.Notify("You made a cocktail", "success")
end

function MakeSunny()
    TriggerServerEvent('ProjectRP:Server:RemoveItem', "cocktailglass", 1)
    ProjectRP.Functions.Progressbar("pickup", "Mixing Cocktail...", 8000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },{
        animDict = "anim@amb@clubhouse@bar@drink@one",
        anim = "one_bartender",
        flags = 8,
    }, {
        model = "prop_shot_glass",
        bone = 60309,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    }, {
        model = "prop_cs_whiskey_bottle",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    } 
)
    Citizen.Wait(6000)
    TriggerServerEvent('ProjectRP:Server:AddItem', "sunny-cocktail", 1)
    --TriggerEvent("inventory:client:ItemBox", ProjectRP.Shared.Items["sunny-cocktail"], "add")
    ProjectRP.Functions.Notify("You made a cocktail", "success")
end


-- Shop --   
RegisterNetEvent("prp-tequilalajob:shop")
AddEventHandler("prp-tequilalajob:shop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "tequilala", Config.Items)
end)


--- GALAXY CODE
RegisterNetEvent('prp-galaxy:client:openShop')
AddEventHandler('prp-galaxy:client:openShop', function()
    local ShopItems = {}
    ShopItems.label = "Galaxy"
    ShopItems.items = Config.GalaxyItems
    ShopItems.slots = #Config.GalaxyItems
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Galaxy"..math.random(1, 99), ShopItems)
end)

RegisterNetEvent("prp-galaxy:ToggleDuty")
AddEventHandler("prp-galaxy:ToggleDuty", function()
    TriggerServerEvent("ProjectRP:ToggleDuty")
end)
