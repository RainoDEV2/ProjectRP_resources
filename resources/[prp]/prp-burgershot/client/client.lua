local CurrentWorkObject = {}
local LoggedIn = false
local InRange = false
-- local ProjectRP = nil

ProjectRP = exports["prp-core"]:GetCoreObject()
RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
      Citizen.Wait(450)
      LoggedIn = true
      PlayerData = ProjectRP.Functions.GetPlayerData()
    end)
end)

RegisterNetEvent("ProjectRP:Client:OnJobUpdate")
AddEventHandler("ProjectRP:Client:OnJobUpdate", function(JobInfo)
	PlayerData.job = JobInfo
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload')
AddEventHandler('ProjectRP:Client:OnPlayerUnload', function()
	RemoveWorkObjects()
  LoggedIn = false
end)

-- Code

-- // Loops \\ --

-- Citizen.CreateThread(function()
--   while true do
--       Citizen.Wait(4)
--       if LoggedIn then
--           local PlayerCoords = GetEntityCoords(PlayerPedId())
--           local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, -1193.70, -892.50, 13.99, true)
--           InRange = false
--           if Distance < 40.0 then
--               InRange = true
--               if not Config.EntitysSpawned then
--                   Config.EntitysSpawned = true
--                   SpawnWorkObjects()
--               end
--           end
--           if not InRange then
--               if Config.EntitysSpawned then
--                 Config.EntitysSpawned = false
--                 RemoveWorkObjects()
--               end
--               -- CheckDuty()
--               Citizen.Wait(1500)
--           end
--       end
--   end
-- end)

Citizen.CreateThread(function() 
  burgershot = AddBlipForCoord(-1197.32, -897.655, 13.995)
  SetBlipSprite (burgershot, 106)
  SetBlipDisplay(burgershot, 4)
  SetBlipScale  (burgershot, 0.5)
  SetBlipAsShortRange(burgershot, true)
  SetBlipColour(burgershot, 75)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentSubstringPlayerName("Burgershot")
  EndTextCommandSetBlipName(burgershot)
end)


CreateThread(function()
  while true do
    Citizen.Wait(4)
      local plyPed = PlayerPedId()
      local plyCoords = GetEntityCoords(plyPed)
      local letSleep = true

      if LoggedIn then

      if PlayerData.job.name == 'burger' then
      local boss = Config.Locations['boss']
        if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, boss.x, boss.y, boss.z, true) < 10) and PlayerData.job.isboss then
          letSleep = false
          DrawMarker(2, boss.x, boss.y, boss.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
          if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, boss.x, boss.y, boss.z, true) < 1.5) then
            ProjectRP.Functions.DrawText3D(boss.x, boss.y, boss.z, "~p~E~w~ - Boss menu")
            if IsControlJustReleased(0, 38) then
              TriggerServerEvent("prp-bossmenu:server:openMenu")
            end
          end  
        end
      end
      if letSleep then
        Wait(3000)
      end
    end
  end
end)

-- // Events \\ --

RegisterNetEvent('prp-burgershot:client:refresh:props')
AddEventHandler('prp-burgershot:client:refresh:props', function()
  if InRange and Config.EntitysSpawned then
    RemoveWorkObjects()
    Citizen.SetTimeout(1000, function()
      SpawnWorkObjects()
    end)
  end
end)

RegisterNetEvent('prp-burgershot:client:open:payment')
AddEventHandler('prp-burgershot:client:open:payment', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenPayment', payments = Config.ActivePayments})
end)

RegisterNetEvent('prp-burgershot:client:open:register')
AddEventHandler('prp-burgershot:client:open:register', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenRegister'})
end)

RegisterNetEvent('prp-burgershot:client:sync:register')
AddEventHandler('prp-burgershot:client:sync:register', function(RegisterConfig)
  Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('prp-burgershot:client:open:box')
AddEventHandler('prp-burgershot:client:open:box', function(BoxId)
  TriggerServerEvent("inventory:server:OpenInventory", "stash", "Box", {
    maxweight = 4000000,
    slots = 5,
})
TriggerEvent("inventory:client:SetCurrentStash", "Box")
end)

RegisterNetEvent('prp-burgershot:client:open:cold:storage')
AddEventHandler('prp-burgershot:client:open:cold:storage', function()
  TriggerServerEvent("inventory:server:OpenInventory", "stash", "Storage", {
    maxweight = 4000000,
    slots = 500,
})
TriggerEvent("inventory:client:SetCurrentStash", "Storage")
end)

RegisterNetEvent('prp-burgershot:client:open:hot:storage')
AddEventHandler('prp-burgershot:client:open:hot:storage', function()
  TriggerServerEvent("inventory:server:OpenInventory", "stash", "Storage", {
    maxweight = 4000000,
    slots = 500,
})
TriggerEvent("inventory:client:SetCurrentStash", "Storage")
end)

RegisterNetEvent('prp-burgershot:client:open:tray')
AddEventHandler('prp-burgershot:client:open:tray', function(Numbers)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "Tray", {
      maxweight = 4000000,
      slots = 5,
  })
  TriggerEvent("inventory:client:SetCurrentStash", "Tray")
end)

RegisterNetEvent('prp-burgershot:client:create:burgerbleeder')
AddEventHandler('prp-burgershot:client:create:burgerbleeder', function(BurgerType)
  ProjectRP.Functions.TriggerCallback('prp-burgershot:server:has:burger:items', function(HasBurgerItems)
    if HasBurgerItems then
      MakeBurgerBleeder()
    else
      ProjectRP.Functions.Notify("You're missing ingredients to make this burger..", "error")
    end
  end)
end)

RegisterNetEvent('prp-burgershot:client:create:burger-heartstopper')
AddEventHandler('prp-burgershot:client:create:burger-heartstopper', function(BurgerType)
  ProjectRP.Functions.TriggerCallback('prp-burgershot:server:has:burger:items', function(HasBurgerItems)
    if HasBurgerItems then
      MakeBurgerHeart()
    else
      ProjectRP.Functions.Notify("You're missing ingredients needed to make this burger..", "error")
    end
  end)
end)

RegisterNetEvent('prp-burgershot:client:create:burger-moneyshot')
AddEventHandler('prp-burgershot:client:create:burger-moneyshot', function(BurgerType)
  ProjectRP.Functions.TriggerCallback('prp-burgershot:server:has:burger:items', function(HasBurgerItems)
    if HasBurgerItems then
      MakeBurgerMoneyshot()
    else
      ProjectRP.Functions.Notify("You're missing ingredients needed to make this burger..", "error")
    end
  end)
end)

RegisterNetEvent('prp-burgershot:client:create:burger-torpedo')
AddEventHandler('prp-burgershot:client:create:burger-torpedo', function(BurgerType)
  ProjectRP.Functions.TriggerCallback('prp-burgershot:server:has:burger:items', function(HasBurgerItems)
    if HasBurgerItems then
      MakeBurgerTorpedo()
    else
      ProjectRP.Functions.Notify("You're missing ingredients needed to make this burger..", "error")
    end
  end)
end)

RegisterNetEvent('prp-burgershot:client:create:soda')
AddEventHandler('prp-burgershot:client:create:soda', function()
  MakeDrinkSoda()
end)

RegisterNetEvent('prp-burgershot:client:create:coffee')
AddEventHandler('prp-burgershot:client:create:coffee', function()
  MakeDrinkCoffee()
end)

RegisterNetEvent('prp-burgershot:client:create:meat1')
AddEventHandler('prp-burgershot:client:create:meat1', function()
  ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
    if HasItem then
      MakePatty1()
    else
      ProjectRP.Functions.Notify("You're missing potatoes..", "error")
    end
  end, 'huntingcarcass1')
end)

RegisterNetEvent('prp-burgershot:client:create:meat2')
AddEventHandler('prp-burgershot:client:create:meat2', function()
  ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
    if HasItem then
      MakePatty2()
    else
      ProjectRP.Functions.Notify("You're missing potatoes..", "error")
    end
  end, 'huntingcarcass2')
end)

RegisterNetEvent('prp-burgershot:client:create:meat3')
AddEventHandler('prp-burgershot:client:create:meat3', function()
  ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
    if HasItem then
      MakePatty3()
    else
      ProjectRP.Functions.Notify("You're missing potatoes..", "error")
    end
  end, 'huntingcarcass3')
end)

RegisterNetEvent('prp-burgershot:client:bake:fries')
AddEventHandler('prp-burgershot:client:bake:fries', function()
  ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
    if HasItem then
        MakeFries()
    else
      ProjectRP.Functions.Notify("You're missing potatoes..", "error")
    end
  end, 'burger-potato')
end)

RegisterNetEvent('prp-burgershot:client:bake:meat')
AddEventHandler('prp-burgershot:client:bake:meat', function()
  ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(HasItem)
    if HasItem then
        MakePatty()
    else
      ProjectRP.Functions.Notify("You're missing meat..", "error")
    end
  end, 'burger-raw')
end)

-- // functions \\ --

function SpawnWorkObjects()
  for k, v in pairs(Config.WorkProps) do
    exports['prp-smallresources']:RequestModelHash(v['Prop'])
    WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
    SetEntityHeading(WorkObject, v['Coords']['H'])
    if v['PlaceOnGround'] then
      PlaceObjectOnGroundProperly(WorkObject)
    end
    if not v['ShowItem'] then
      SetEntityVisible(WorkObject, false)
    end
    SetModelAsNoLongerNeeded(WorkObject)
    FreezeEntityPosition(WorkObject, true)
    SetEntityInvincible(WorkObject, true)
    table.insert(CurrentWorkObject, WorkObject)
    Citizen.Wait(50)
  end
end

function MakeBurgerBleeder()
  Citizen.SetTimeout(750, function()
    TriggerEvent('prp-inventory:client:set:busy', true)
    exports['prp-smallresources']:RequestAnimationDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
    ProjectRP.Functions.Progressbar("open-brick", "Creating burger..", 7500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    }, {}, {}, {}, function() -- Done
      TriggerServerEvent('prp-burgershot:server:finish:burgerbleeder')
      TriggerEvent('prp-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end, function()
      TriggerEvent('prp-inventory:client:set:busy', false)
      ProjectRP.Functions.Notify("Cancelled..", "error")
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end)
  end)
end

function MakeBurgerHeart()
  Citizen.SetTimeout(750, function()
    TriggerEvent('prp-inventory:client:set:busy', true)
    exports['prp-smallresources']:RequestAnimationDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
    ProjectRP.Functions.Progressbar("open-brick", "Creating burger..", 7500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    }, {}, {}, {}, function() -- Done
      TriggerServerEvent('prp-burgershot:server:finish:burger-heartstopper')
      TriggerEvent('prp-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end, function()
      TriggerEvent('prp-inventory:client:set:busy', false)
      ProjectRP.Functions.Notify("Cancelled..", "error")
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end)
  end)
end

function MakeBurgerMoneyshot()
  Citizen.SetTimeout(750, function()
    TriggerEvent('prp-inventory:client:set:busy', true)
    exports['prp-smallresources']:RequestAnimationDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
    ProjectRP.Functions.Progressbar("open-brick", "Creating burger..", 7500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    }, {}, {}, {}, function() -- Done
      TriggerServerEvent('prp-burgershot:server:finish:burger-moneyshot')
      TriggerEvent('prp-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end, function()
      TriggerEvent('prp-inventory:client:set:busy', false)
      ProjectRP.Functions.Notify("Cancelled..", "error")
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end)
  end)
end

function MakeBurgerTorpedo()
  Citizen.SetTimeout(750, function()
    TriggerEvent('prp-inventory:client:set:busy', true)
    exports['prp-smallresources']:RequestAnimationDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
    ProjectRP.Functions.Progressbar("open-brick", "Creating burger..", 7500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    }, {}, {}, {}, function() -- Done
      TriggerServerEvent('prp-burgershot:server:finish:burger-torpedo')
      TriggerEvent('prp-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end, function()
      TriggerEvent('prp-inventory:client:set:busy', false)
      ProjectRP.Functions.Notify("Cancelled..", "error")
      StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end)
  end)
end

function MakeFries()
  TriggerEvent('prp-inventory:client:set:busy', true)
  TriggerEvent("prp-sound:client:play", "baking", 0.7)
  exports['prp-smallresources']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  ProjectRP.Functions.Progressbar("open-brick", "Baking Fries..", 6500, false, true, {
    disableMovement = true,
    disableCarMovement = false,
    disableMouse = false,
    disableCombat = true,
  }, {}, {
    model = "prop_cs_fork",
    bone = 28422,
    coords = { x = -0.005, y = 0.00, z = 0.00 },
    rotation = { x = 175.0, y = 160.0, z = 0.0 },
  }, {}, function() -- Done
    TriggerServerEvent('prp-burgershot:server:finish:fries')
    TriggerEvent('prp-inventory:client:set:busy', false)
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
    TriggerEvent('prp-inventory:client:set:busy', false)
    ProjectRP.Functions.Notify("Cancelled..", "error")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakePatty1()
  TriggerEvent('prp-inventory:client:set:busy', true)
  TriggerEvent("prp-sound:client:play", "baking", 0.7)
  exports['prp-smallresources']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  ProjectRP.Functions.Progressbar("open-brick", "Baking Meat..", 6500, false, true, {
    disableMovement = true,
    disableCarMovement = false,
    disableMouse = false,
    disableCombat = true,
  }, {}, {
    model = "prop_cs_fork",
    bone = 28422,
    coords = { x = -0.005, y = 0.00, z = 0.00},
    rotation = { x = 175.0, y = 160.0, z = 0.0},
  }, {}, function() -- Done
    TriggerServerEvent('prp-burgershot:server:finish:patty1')
    TriggerEvent('prp-inventory:client:set:busy', false)
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
    TriggerEvent('prp-inventory:client:set:busy', false)
    ProjectRP.Functions.Notify("Cancelled..", "error")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakePatty2()
  TriggerEvent('prp-inventory:client:set:busy', true)
  TriggerEvent("prp-sound:client:play", "baking", 0.7)
  exports['prp-smallresources']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  ProjectRP.Functions.Progressbar("open-brick", "Baking Meat..", 6500, false, true, {
    disableMovement = true,
    disableCarMovement = false,
    disableMouse = false,
    disableCombat = true,
  }, {}, {
    model = "prop_cs_fork",
    bone = 28422,
    coords = { x = -0.005, y = 0.00, z = 0.00},
    rotation = { x = 175.0, y = 160.0, z = 0.0},
  }, {}, function() -- Done
    TriggerServerEvent('prp-burgershot:server:finish:patty2')
    TriggerEvent('prp-inventory:client:set:busy', false)
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
    TriggerEvent('prp-inventory:client:set:busy', false)
    ProjectRP.Functions.Notify("Cancelled..", "error")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakePatty3()
  TriggerEvent('prp-inventory:client:set:busy', true)
  TriggerEvent("prp-sound:client:play", "baking", 0.7)
  exports['prp-smallresources']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  ProjectRP.Functions.Progressbar("open-brick", "Baking Meat..", 6500, false, true, {
    disableMovement = true,
    disableCarMovement = false,
    disableMouse = false,
    disableCombat = true,
  }, {}, {
    model = "prop_cs_fork",
    bone = 28422,
    coords = { x = -0.005, y = 0.00, z = 0.00},
    rotation = { x = 175.0, y = 160.0, z = 0.0},
  }, {}, function() -- Done
    TriggerServerEvent('prp-burgershot:server:finish:patty3')
    TriggerEvent('prp-inventory:client:set:busy', false)
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
    TriggerEvent('prp-inventory:client:set:busy', false)
    ProjectRP.Functions.Notify("Cancelled..", "error")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakeDrinkSoda()
  TriggerEvent('prp-inventory:client:set:busy', true)
  TriggerEvent("prp-sound:client:play", "pour-drink", 0.4)
  exports['prp-smallresources']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
  TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
  ProjectRP.Functions.Progressbar("open-brick", "Tapping Drinks..", 6500, false, true, {
    disableMovement = true,
    disableCarMovement = false,
    disableMouse = false,
    disableCombat = true,
  }, {}, {}, {}, function() -- Done
    TriggerServerEvent('prp-burgershot:server:finish:drinksoda')
    TriggerEvent('prp-inventory:client:set:busy', false)
    StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end, function()
    TriggerEvent('prp-inventory:client:set:busy', false)
    ProjectRP.Functions.Notify("Cancelled..", "error")
    StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end)
end

function MakeDrinkCoffee()
  TriggerEvent('prp-inventory:client:set:busy', true)
  TriggerEvent("prp-sound:client:play", "pour-drink", 0.4)
  exports['prp-smallresources']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
  TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
  ProjectRP.Functions.Progressbar("open-brick", "Tapping Drinks..", 6500, false, true, {
    disableMovement = true,
    disableCarMovement = false,
    disableMouse = false,
    disableCombat = true,
  }, {}, {}, {}, function() -- Done
    TriggerServerEvent('prp-burgershot:server:finish:drinkcoffee')
    TriggerEvent('prp-inventory:client:set:busy', false)
    StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end, function()
    TriggerEvent('prp-inventory:client:set:busy', false)
    ProjectRP.Functions.Notify("Cancelled..", "error")
    StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end)
end

function CheckDuty()
  if ProjectRP.Functions.GetPlayerData().job.name =='burger' and ProjectRP.Functions.GetPlayerData().job.onduty then
    TriggerServerEvent('ProjectRP:ToggleDuty')
    ProjectRP.Functions.Notify("You are too far away from your work while you are clocked in!", "error")
  end
end

function RemoveWorkObjects()
  for k, v in pairs(CurrentWorkObject) do
    DeleteEntity(v)
  end
end

function GetActiveRegister()
  return Config.ActivePayments
end

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorClick', function()
  PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('AddPrice', function(data)
  TriggerServerEvent('prp-burgershot:server:add:to:register', data.Price, data.Note)
end)

RegisterNUICallback('PayReceipt', function(data)
  TriggerServerEvent('prp-burgershot:server:pay:receipt', data.Price, data.Note, data.Id)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)

RegisterNetEvent('prp-burgershot:client:open:shop')
AddEventHandler('prp-burgershot:client:open:shop', function()
    local ShopItems = {}
    ShopItems.label = "Burgershot Storage"
    ShopItems.items = Config.bgshotitems
    ShopItems.slots = #Config.bgshotitems
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Burgershot_"..math.random(1, 99), ShopItems)
end)