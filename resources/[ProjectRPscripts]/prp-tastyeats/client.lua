local ProjectRP = exports['prp-core']:GetCoreObject()
local PlayerData = {}
experience = 0
Level = nil
block = false

onDuty = false
hasCar = false
inGarageMenu = false
WorkVeh = nil
inOrderMenu = false
Restaurant = nil
HookiesBusy, TacoBombBusy, CluckinBellBusy, PizzaThisBusy, BurgerShotBusy = false, false, false, false, false
TakedOrder = false
DeliveryPlace = nil
ComingToCustomer = false
HaveBagInHand = false
hasKnockedDoor = false
CustomerComingDoor = false
RandomText = nil
EndText = false

Citizen.CreateThread(function()
	while ProjectRP == nil do
		TriggerEvent('ProjectRP:GetObject', function(obj) ProjectRP = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerData = ProjectRP.Functions.GetPlayerData()
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate')
AddEventHandler('ProjectRP:Client:OnJobUpdate', function()
	PlayerData.job = ProjectRP.Functions.GetPlayerData().job
end)


Citizen.CreateThread(function()

    BaseBlip = AddBlipForCoord(icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z)
    SetBlipSprite(BaseBlip, icfg.TastyEats["Base"].JobStart.Blip.Sprite)
    SetBlipDisplay(BaseBlip, 4)
    SetBlipScale(BaseBlip, icfg.TastyEats["Base"].JobStart.Blip.Scale)
    SetBlipAsShortRange(BaseBlip, true)
    SetBlipColour(BaseBlip, icfg.TastyEats["Base"].JobStart.Blip.Color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(icfg.TastyEats["Base"].JobStart.Blip.Label)
    EndTextCommandSetBlipName(BaseBlip)

    local HookiesPed = GetHashKey(icfg.TastyEats["Restaurant"][1].ped)
    RequestModel(HookiesPed)
    while not HasModelLoaded(HookiesPed) do
        Citizen.Wait(1)
    end
    HookiesNPC = CreatePed(1, HookiesPed, icfg.TastyEats["Restaurant"][1].x, icfg.TastyEats["Restaurant"][1].y, icfg.TastyEats["Restaurant"][1].z - 0.98, icfg.TastyEats["Restaurant"][1].h, false, true)
    SetBlockingOfNonTemporaryEvents(HookiesNPC, true)
    SetPedDiesWhenInjured(HookiesNPC, false)
    SetPedCanPlayAmbientAnims(HookiesNPC, true)
    SetPedCanRagdollFromPlayerImpact(HookiesNPC, false)
    SetEntityInvincible(HookiesNPC, true)
    FreezeEntityPosition(HookiesNPC, true)

    HookiesBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][1].x, icfg.TastyEats["Restaurant"][1].y, icfg.TastyEats["Restaurant"][1].z, false, true, true)
    AttachEntityToEntity(HookiesBag, HookiesNPC, GetPedBoneIndex(HookiesNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)

    local TacoBombPed = GetHashKey(icfg.TastyEats["Restaurant"][2].ped)
    RequestModel(TacoBombPed)
    while not HasModelLoaded(TacoBombPed) do
        Citizen.Wait(1)
    end
    TacoBombNPC = CreatePed(1, TacoBombPed, icfg.TastyEats["Restaurant"][2].x, icfg.TastyEats["Restaurant"][2].y, icfg.TastyEats["Restaurant"][2].z - 0.98, icfg.TastyEats["Restaurant"][2].h, false, true)
    SetBlockingOfNonTemporaryEvents(TacoBombNPC, true)
    SetPedDiesWhenInjured(TacoBombNPC, false)
    SetPedCanPlayAmbientAnims(TacoBombNPC, true)
    SetPedCanRagdollFromPlayerImpact(TacoBombNPC, false)
    SetEntityInvincible(TacoBombNPC, true)
    FreezeEntityPosition(TacoBombNPC, true)

    TacoBombBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][2].x, icfg.TastyEats["Restaurant"][2].y, icfg.TastyEats["Restaurant"][2].z, false, true, true)
    AttachEntityToEntity(TacoBombBag, TacoBombNPC, GetPedBoneIndex(TacoBombNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)

    local CluckinBellPed = GetHashKey(icfg.TastyEats["Restaurant"][3].ped)
    RequestModel(CluckinBellPed)
    while not HasModelLoaded(CluckinBellPed) do
        Citizen.Wait(1)
    end
    CluckinBellNPC = CreatePed(1, CluckinBellPed, icfg.TastyEats["Restaurant"][3].x, icfg.TastyEats["Restaurant"][3].y, icfg.TastyEats["Restaurant"][3].z - 0.98, icfg.TastyEats["Restaurant"][3].h, false, true)
    SetBlockingOfNonTemporaryEvents(CluckinBellNPC, true)
    SetPedDiesWhenInjured(CluckinBellNPC, false)
    SetPedCanPlayAmbientAnims(CluckinBellNPC, true)
    SetPedCanRagdollFromPlayerImpact(CluckinBellNPC, false)
    SetEntityInvincible(CluckinBellNPC, true)
    FreezeEntityPosition(CluckinBellNPC, true)

    CluckinBellBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][3].x, icfg.TastyEats["Restaurant"][3].y, icfg.TastyEats["Restaurant"][3].z, false, true, true)
    AttachEntityToEntity(CluckinBellBag, CluckinBellNPC, GetPedBoneIndex(CluckinBellNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)

    local PizzaThisPed = GetHashKey(icfg.TastyEats["Restaurant"][4].ped)
    RequestModel(PizzaThisPed)
    while not HasModelLoaded(PizzaThisPed) do
        Citizen.Wait(1)
    end
    PizzaThisNPC = CreatePed(1, PizzaThisPed, icfg.TastyEats["Restaurant"][4].x, icfg.TastyEats["Restaurant"][4].y, icfg.TastyEats["Restaurant"][4].z - 0.98, icfg.TastyEats["Restaurant"][4].h, false, true)
    SetBlockingOfNonTemporaryEvents(PizzaThisNPC, true)
    SetPedDiesWhenInjured(PizzaThisNPC, false)
    SetPedCanPlayAmbientAnims(PizzaThisNPC, true)
    SetPedCanRagdollFromPlayerImpact(PizzaThisNPC, false)
    SetEntityInvincible(PizzaThisNPC, true)
    FreezeEntityPosition(PizzaThisNPC, true)

    PizzaThisBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][4].x, icfg.TastyEats["Restaurant"][4].y, icfg.TastyEats["Restaurant"][4].z, false, true, true)
    AttachEntityToEntity(PizzaThisBag, PizzaThisNPC, GetPedBoneIndex(PizzaThisNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)

    local BurgerShotPed = GetHashKey(icfg.TastyEats["Restaurant"][5].ped)
    RequestModel(BurgerShotPed)
    while not HasModelLoaded(BurgerShotPed) do
        Citizen.Wait(1)
    end
    BurgerShotNPC = CreatePed(1, BurgerShotPed, icfg.TastyEats["Restaurant"][5].x, icfg.TastyEats["Restaurant"][5].y, icfg.TastyEats["Restaurant"][5].z - 0.98, icfg.TastyEats["Restaurant"][5].h, false, true)
    SetBlockingOfNonTemporaryEvents(BurgerShotNPC, true)
    SetPedDiesWhenInjured(BurgerShotNPC, false)
    SetPedCanPlayAmbientAnims(BurgerShotNPC, true)
    SetPedCanRagdollFromPlayerImpact(BurgerShotNPC, false)
    SetEntityInvincible(BurgerShotNPC, true)
    FreezeEntityPosition(BurgerShotNPC, true)

    BurgerShotBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][5].x, icfg.TastyEats["Restaurant"][5].y, icfg.TastyEats["Restaurant"][5].z, false, true, true)
    AttachEntityToEntity(BurgerShotBag, BurgerShotNPC, GetPedBoneIndex(BurgerShotNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)

    while true do

        local refresh = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

            if PlayerData.job ~= nil and PlayerData.job.name == 'tastyeats' then
            
                SetBlipAlpha(BaseBlip, 1000)

                if (#(coords - vector3(icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z)) < 0.6) then

                    refresh = 4

                    if inOrderMenu then
                        
                        inOrderMenu = false

                    end

                    if not onDuty then

                        DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to Start Work")
                        DrawMarker(25, icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 36, 214, 45, 100, false, true, 2, false, false, false, false)

                        if IsControlJustReleased(0, Keys["E"]) and not block then

                            block = true
                            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
                            Citizen.Wait(2200)
                            PlayerData = ProjectRP.Functions.GetPlayerData()
							if PlayerData.charinfo.gender == 0 then 
								SetPedComponentVariation(ped, 3,icfg.TastyEats["Clothes"].Male['arms'], 0, 0) --arms
								SetPedComponentVariation(ped, 8,icfg.TastyEats["Clothes"].Male['tshirt_1'],icfg.TastyEats["Clothes"].Male['tshirt_2'], 0) --t-shirt
								SetPedComponentVariation(ped, 11,icfg.TastyEats["Clothes"].Male['torso_1'],icfg.TastyEats["Clothes"].Male['torso_2'], 0) --torso2
								SetPedComponentVariation(ped, 9,icfg.TastyEats["Clothes"].Male['bproof_1'],icfg.TastyEats["Clothes"].Male['bproof_2'], 0) --vest
								SetPedComponentVariation(ped, 10,icfg.TastyEats["Clothes"].Male['decals_1'],icfg.TastyEats["Clothes"].Male['decals_2'], 0) --decals
								SetPedComponentVariation(ped, 7,icfg.TastyEats["Clothes"].Male['chain_1'],icfg.TastyEats["Clothes"].Male['chain_2'], 0) --accessory
								SetPedComponentVariation(ped, 4,icfg.TastyEats["Clothes"].Male['pants_1'],icfg.TastyEats["Clothes"].Male['pants_2'], 0) -- pants
								SetPedComponentVariation(ped, 6,icfg.TastyEats["Clothes"].Male['shoes_1'],icfg.TastyEats["Clothes"].Male['shoes_2'], 0) --shoes
								SetPedPropIndex(ped, 0,icfg.TastyEats["Clothes"].Male['helmet_1'],icfg.TastyEats["Clothes"].Male['helmet_2'], true) --hat
								SetPedPropIndex(ped, 2,icfg.TastyEats["Clothes"].Male['ears_1'],icfg.TastyEats["Clothes"].Male['ears_2'], true) --ear
							else
								SetPedComponentVariation(ped, 3, icfg.TastyEats["Clothes"].Female['arms'], 0, 0) --arms
								SetPedComponentVariation(ped, 8, icfg.TastyEats["Clothes"].Female['tshirt_1'], icfg.TastyEats["Clothes"].Female['tshirt_2'], 0) --t-shirt
								SetPedComponentVariation(ped, 11, icfg.TastyEats["Clothes"].Female['torso_1'], icfg.TastyEats["Clothes"].Female['torso_2'], 0) --torso2
								SetPedComponentVariation(ped, 9, icfg.TastyEats["Clothes"].Female['bproof_1'], icfg.TastyEats["Clothes"].Female['bproof_2'], 0) --vest
								SetPedComponentVariation(ped, 10, icfg.TastyEats["Clothes"].Female['decals_1'], icfg.TastyEats["Clothes"].Female['decals_2'], 0) --decals
								SetPedComponentVariation(ped, 7, icfg.TastyEats["Clothes"].Female['chain_1'], icfg.TastyEats["Clothes"].Female['chain_2'], 0) --accessory
								SetPedComponentVariation(ped, 4, icfg.TastyEats["Clothes"].Female['pants_1'], icfg.TastyEats["Clothes"].Female['pants_2'], 0) -- pants
								SetPedComponentVariation(ped, 6, icfg.TastyEats["Clothes"].Female['shoes_1'], icfg.TastyEats["Clothes"].Female['shoes_2'], 0) --shoes
								SetPedPropIndex(ped, 0, icfg.TastyEats["Clothes"].Female['helmet_1'], icfg.TastyEats["Clothes"].Female['helmet_2'], true) --hat
								SetPedPropIndex(ped, 2, icfg.TastyEats["Clothes"].Female['ears_1'], icfg.TastyEats["Clothes"].Female['ears_2'], true) --ear
							end	

                            ClearPedTasks(ped)
                            ProjectRP.Functions.TriggerCallback('prp-tastyeats:getexperience', function(exp)
                                experience = exp
                            end, PlayerData)
                            Citizen.Wait(150)
                            if experience >= icfg.Levels.Level5.MinPoints then
                                Level = 5
                            elseif experience >= icfg.Levels.Level4.MinPoints and experience <= icfg.Levels.Level4.MaxPoints then
                                Level = 4
                            elseif experience >= icfg.Levels.Level3.MinPoints and experience <= icfg.Levels.Level3.MaxPoints then
                                Level = 3
                            elseif experience >= icfg.Levels.Level2.MinPoints and experience <= icfg.Levels.Level2.MaxPoints then
                                Level = 2
                            elseif experience >= icfg.Levels.Level1.MinPoints and experience <= icfg.Levels.Level1.MaxPoints then
                                Level = 1
                            end
                            TriggerEvent('chat:addMessage', {args = {'^5Tasty Eats', 'Current Level: ' ..Level}})
                            TriggerEvent('chat:addMessage', {args = {'^5Tasty Eats', 'Current Points: ' ..experience}})

                            GarageBlip = AddBlipForCoord(icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2.x, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2.y, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2.z)
                            SetBlipSprite(GarageBlip, icfg.TastyEats["Base"].Garage.Blip.Sprite)
                            SetBlipDisplay(GarageBlip, 4)
                            SetBlipScale(GarageBlip, icfg.TastyEats["Base"].Garage.Blip.Scale)
                            SetBlipAsShortRange(GarageBlip, true)
                            SetBlipColour(GarageBlip, icfg.TastyEats["Base"].Garage.Blip.Color)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentSubstringPlayerName(icfg.TastyEats["Base"].Garage.Blip.Label)
                            EndTextCommandSetBlipName(GarageBlip)

                            onDuty = true
                            block = false

                            
                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You started Work, come to Garage and take Company Vehicle", timeout = 3500})

                        end

                    elseif onDuty then

                        DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~r~E~s~] to Finish Work")
                        DrawMarker(25, icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 191, 31, 31, 100, false, true, 2, false, false, false, false)

                        if IsControlJustReleased(0, Keys["E"]) and not block then

                            if Restaurant == nil then

                                block = true
                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
                                Citizen.Wait(2200)
                                TriggerServerEvent("prp-clothes:loadPlayerSkin")
                                ClearPedTasks(ped)
                                Level = nil
                                experience = 0

                                RemoveBlip(GarageBlip)

                                onDuty = false
                                block = false

                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You finished Work", timeout = 3500})

                            elseif Restaurant ~= nil then

                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Cancel Order in Management Menu!", timeout = 2500})

                            end

                        end

                    end

                elseif (#(coords - vector3(icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z)) < 6.0) then

                    refresh = 4
                    DrawEmoji3D(icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z + 0.5, "🦺")
                    DrawMarker(25, icfg.TastyEats["Base"].JobStart.Coords.x, icfg.TastyEats["Base"].JobStart.Coords.y, icfg.TastyEats["Base"].JobStart.Coords.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 82, 82, 82, 100, false, true, 2, false, false, false, false)

                end





                if onDuty then

                    if not hasCar then

                        if (#(coords - vector3(icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.x, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.y, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.z)) < 0.6) then

                            refresh = 4
                            DrawMarker(25, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.x, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.y, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 36, 214, 45, 100, false, true, 2, false, false, false, false)

                            if inOrderMenu then
                        
                                inOrderMenu = false
        
                            end

                            if not inGarageMenu then

                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to Open Garage Menu")

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    block = true
                                    FreezeEntityPosition(ped, true)
                                    inGarageMenu = true

                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Press <b>[ESC]</b> or <b>[BACKSPACE]</b> to close the Garage Menu", timeout = 3500})

                                end

                            elseif inGarageMenu then

                                DrawText3DMenu(coords.x, coords.y, coords.z + 1.2, "[~g~Q~s~] Parking Space #1\n[~g~E~s~] Parking Space #2\n[~g~Y~s~] Parking Space #3")
                                DrawMarker(11, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1.x, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1.y, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1.z + 0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 36, 214, 45, 100, false, true, 2, false, false, false, false)
                                DrawMarker(12, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2.x, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2.y, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2.z + 0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 36, 214, 45, 100, false, true, 2, false, false, false, false)
                                DrawMarker(13, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3.x, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3.y, icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3.z + 0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 36, 214, 45, 100, false, true, 2, false, false, false, false)

                                if IsControlJustReleased(0, Keys["BACKSPACE"]) or IsControlJustReleased(0, Keys["ESC"]) then

                                    FreezeEntityPosition(ped, false)
                                    inGarageMenu = false
                                    block = false

                                elseif IsControlJustReleased(0, Keys["Q"]) then

                                    ProjectRP.Functions.TriggerCallback('prp-tastyeats:checkMoney', function(hasMoney)

                                        if hasMoney then

                                            if Level == 5 then

                                                SpawnCar('is350mod', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1, 'TE5')

                                            elseif Level == 4 then

                                                SpawnCar('veln', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1, 'TE4')

                                            elseif Level == 3 then

                                                SpawnCar('golfmk6', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1, 'TE3')

                                            elseif Level == 2 then

                                                SpawnCar('prius', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1, 'TE2')

                                            elseif Level == 1 then

                                                SpawnCar('m3e36', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint1, 'TE1')
                                                
                                            end

                                            
                                            FreezeEntityPosition(ped, false)
                                            inGarageMenu = false
                                            hasCar = true
                                            block = false

                                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You paid " ..icfg.DepositForVehiclePrice.. "$ for Deposit Vehicle", timeout = 2000})

                                        elseif not hasMoney then

                                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You don't have enough Money to pay for the Vehicle Deposit! Expense: " ..icfg.DepositForVehiclePrice.. "$", timeout = 2000})

                                        end

                                    end)

                                elseif IsControlJustReleased(0, Keys["E"]) then

                                    ProjectRP.Functions.TriggerCallback('prp-tastyeats:checkMoney', function(hasMoney)

                                        if hasMoney then

                                            if Level == 5 then

                                                SpawnCar('is350mod', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2, 'TE5')
                                            
                                            elseif Level == 4 then
                                            
                                                SpawnCar('veln', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2, 'TE4')
                                            
                                            elseif Level == 3 then
                                            
                                                SpawnCar('golfmk6', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2, 'TE3')
                                            
                                            elseif Level == 2 then
                                            
                                                SpawnCar('prius', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2, 'TE2')
                                            
                                            elseif Level == 1 then
                                            
                                                SpawnCar('m3e36', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint2, 'TE1')
                                                
                                            end
                                            
                                            FreezeEntityPosition(ped, false)
                                            inGarageMenu = false
                                            hasCar = true
                                            block = false

                                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You paid " ..icfg.DepositForVehiclePrice.. "$ for Deposit Vehicle", timeout = 2000})

                                        elseif not hasMoney then

                                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You don't have enough Money to pay for the Vehicle Deposit! Expense: " ..icfg.DepositForVehiclePrice.. "$", timeout = 2000})

                                        end

                                    end)

                                elseif IsControlJustReleased(0, Keys["Y"]) then

                                    ProjectRP.Functions.TriggerCallback('prp-tastyeats:checkMoney', function(hasMoney)

                                        if hasMoney then

                                            if Level == 5 then

                                                SpawnCar('is350mod', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3, 'TE5')
                                            
                                            elseif Level == 4 then
                                            
                                                SpawnCar('veln', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3, 'TE4')
                                            
                                            elseif Level == 3 then
                                            
                                                SpawnCar('golfmk6', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3, 'TE3')
                                            
                                            elseif Level == 2 then
                                            
                                                SpawnCar('prius', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3, 'TE2')
                                            
                                            elseif Level == 1 then
                                            
                                                SpawnCar('m3e36', icfg.TastyEats["Base"].Garage.Coords.SpawnPoint3, 'TE1')
                                                
                                            end

                                            FreezeEntityPosition(ped, false)
                                            inGarageMenu = false
                                            hasCar = true
                                            block = false

                                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You paid " ..icfg.DepositForVehiclePrice.. "$ for Deposit Vehicle", timeout = 2000})

                                        elseif not hasMoney then

                                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You don't have enough Money to pay for the Vehicle Deposit! Expense: " ..icfg.DepositForVehiclePrice.. "$", timeout = 2000})

                                        end

                                    end)

                                end

                            end

                        elseif (#(coords - vector3(icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.x, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.y, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.z)) < 6.0) then

                            refresh = 4
                            DrawEmoji3D(icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.x, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.y, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.z + 0.5, "🚗")
                            DrawMarker(25, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.x, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.y, icfg.TastyEats["Base"].Garage.Coords.TakeVehicle.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 82, 82, 82, 100, false, true, 2, false, false, false, false)

                        end

                    elseif hasCar then

                        if IsPedInAnyVehicle(ped, false) then

                            if (#(coords - vector3(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.z)) < 1.6) then

                                if inOrderMenu then
                        
                                    inOrderMenu = false
            
                                end

                                refresh = 4
                                DrawText3D(coords.x, coords.y, coords.z + 1.2, "Press [~r~E~s~] to Return Vehicle")
                                DrawMarker(25, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.z - 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 191, 31, 31, 100, false, true, 2, false, false, false, false)

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    local veh = GetVehiclePedIsIn(ped, true)

                                    if veh == WorkVeh then

                                        block = true
                                        ProjectRP.Functions.DeleteVehicle(WorkVeh)
                                        WorkVeh, hasCar = nil, false
                                        TriggerServerEvent("prp-tastyeats:returnVehicle")
                                        block = false

                                        exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>" ..icfg.DepositForVehiclePrice.. "$ has been returned to your Bank Account", timeout = 2000})

                                    else

                                        exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>This is not the Vehicle for which you have paid a Deposit", timeout = 2000})
                                        
                                    end

                                end

                            elseif (#(coords - vector3(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.z)) < 10.0) then

                                refresh = 4
                                DrawEmoji3D(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.z + 1.5, "🚗")
                                DrawMarker(25, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.z - 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 82, 82, 82, 100, false, true, 2, false, false, false, false)

                            end

                        end

                    end





                    if not inOrderMenu then

                        refresh = 4

                        if IsControlJustReleased(0, Keys["DEL"]) then

                            inOrderMenu = true

                        end

                    elseif inOrderMenu then

                        refresh = 4
                        DrawText3D(coords.x, coords.y, coords.z + 1.0, "[~g~Q~s~] - Search Order | [~r~Y~s~] Cancel Order")                        

                        if IsControlJustReleased(0, Keys["DEL"]) then

                            inOrderMenu = false

                        elseif IsControlJustReleased(0, Keys["Q"]) then

                            if Level == 5 then

                                SearchingOrderTime = math.random(icfg.Levels.Level5.MinOrderSearch, icfg.Levels.Level5.MaxOrderSearch)
                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Estimated waiting time: " ..MathGroupDigits(SearchingOrderTime).. " seconds.", timeout = 5000})

                            elseif Level == 4 then

                                SearchingOrderTime = math.random(icfg.Levels.Level4.MinOrderSearch, icfg.Levels.Level4.MaxOrderSearch)
                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Estimated waiting time: " ..MathGroupDigits(SearchingOrderTime).. " seconds.", timeout = 5000})

                            elseif Level == 3 then

                                SearchingOrderTime = math.random(icfg.Levels.Level3.MinOrderSearch, icfg.Levels.Level3.MaxOrderSearch)
                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Estimated waiting time: " ..MathGroupDigits(SearchingOrderTime).. " seconds.", timeout = 5000})

                            elseif Level == 2 then

                                SearchingOrderTime = math.random(icfg.Levels.Level2.MinOrderSearch, icfg.Levels.Level2.MaxOrderSearch)
                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Estimated waiting time: " ..MathGroupDigits(SearchingOrderTime).. " seconds.", timeout = 5000})

                            elseif Level == 1 then

                                SearchingOrderTime = math.random(icfg.Levels.Level1.MinOrderSearch, icfg.Levels.Level1.MaxOrderSearch)
                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Estimated waiting time: " ..MathGroupDigits(SearchingOrderTime).. " seconds.", timeout = 5000})

                            end

                            Citizen.Wait(SearchingOrderTime)
                            inOrderMenu = false
                            Restaurant = icfg.TastyEats["Restaurant"][math.random(1, #icfg.TastyEats["Restaurant"])]
                            SetNewWaypoint(Restaurant.x, Restaurant.y)
                            
                            RestaurantBlip = AddBlipForCoord(Restaurant.x, Restaurant.y, Restaurant.z)
                            SetBlipSprite(RestaurantBlip, 164)
                            SetBlipDisplay(RestaurantBlip, 4)
                            SetBlipScale(RestaurantBlip, 0.6)
                            SetBlipAsShortRange(RestaurantBlip, false)
                            SetBlipColour(RestaurantBlip, 43)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentSubstringPlayerName("[~g~Tasty Eats~s~] " ..Restaurant.name.. " Restaurant")
                            EndTextCommandSetBlipName(RestaurantBlip)

                            exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>An Order has been found for a " ..Restaurant.name.. " Restaurant. Drive there to pick up Food", timeout = 5000})

                        elseif IsControlJustReleased(0, Keys["Y"]) then

                            if Restaurant ~= nil then

                                Restaurant = nil
                                RemoveBlip(Restaurant)

                                if DeliveryPlace ~= nil then

                                    RemoveBlip(DeliveryBlip)
                                    DeliveryPlace = nil
                                    TakedOrder = false
                                    DeliveryPlace = nil
                                    ComingToCustomer = false
                                    HaveBagInHand = false
                                    hasKnockedDoor = false
                                    CustomerComingDoor = false
                                    EndText = false

                                end

                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Order canceled", timeout = 2000})

                            elseif Restaurant == nil then

                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You don't have any Order!", timeout = 2000})

                            end

                        end

                    end

                end

            else

                SetBlipAlpha(BaseBlip, 0)

            end

            if Restaurant ~= nil then

                if (#(coords - vector3(Restaurant.x, Restaurant.y, Restaurant.z)) < 0.8) then

                    refresh = 4

                    if inOrderMenu then
                        
                        inOrderMenu = false

                    end

                    if Restaurant.name == "Hookies" then

                        if HookiesBusy then

                            DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "~b~" ..Restaurant.name.. " Worker~s~ is Busy at the moment")

                        elseif not HookiesBusy then

                            if not TakedOrder then

                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to receive Order")

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    block = true
                                    TriggerServerEvent('prp-tastyeats:SynchroHookiesFood')
                                    TakedOrder = true
                                    SetEntityCoords(ped, -2194.53, 4290.52, 49.17 - 0.96)
                                    SetEntityHeading(ped, 243.49)
                                    RequestAnimDict('mp_common')
                                    while not HasAnimDictLoaded('mp_common') do
                                      Citizen.Wait(0)
                                    end
                                    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                    Citizen.Wait(750)
                                    bagPed = CreateObject(GetHashKey("prop_ld_handbag_s"), coords.x, coords.y, coords.z,  true,  true, true)
                                    AttachEntityToEntity(bagPed, ped, GetPedBoneIndex(ped, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                    Citizen.Wait(750)
                                    ClearPedTasks(ped)
                                    block = false

                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Place the Order on the Passenger Seat in your vehicle", timeout = 5000})

                                end

                            elseif TakedOrder and DeliveryPlace == nil then

                                DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "Put the bag with the Order on the Passenger Seat")

                            end

                        end

                    elseif Restaurant.name == "Taco Bomb" then

                        if TacoBombBusy then

                            DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "~b~" ..Restaurant.name.. " Worker~s~ is Busy at the moment")

                        elseif not TacoBombBusy then

                            if not TakedOrder then

                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to receive Order")

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    block = true
                                    TriggerServerEvent('prp-tastyeats:SynchroTacoBombFood')
                                    TakedOrder = true
                                    SetEntityCoords(ped, -1552.10, -440.51, 40.52 - 0.96)
                                    SetEntityHeading(ped, 50.26)
                                    RequestAnimDict('mp_common')
                                    while not HasAnimDictLoaded('mp_common') do
                                      Citizen.Wait(0)
                                    end
                                    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                    Citizen.Wait(750)
                                    bagPed = CreateObject(GetHashKey("prop_ld_handbag_s"), coords.x, coords.y, coords.z,  true,  true, true)
                                    AttachEntityToEntity(bagPed, ped, GetPedBoneIndex(ped, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                    Citizen.Wait(750)
                                    ClearPedTasks(ped)
                                    block = false

                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Place the Order on the Passenger Seat in your vehicle", timeout = 5000})

                                end

                            elseif TakedOrder and DeliveryPlace == nil then

                                DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "Put the bag with the Order on the Passenger Seat")

                            end

                        end

                    elseif Restaurant.name == "Cluckin Bell" then

                        if CluckinBellBusy then

                            DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "~b~" ..Restaurant.name.. " Worker~s~ is Busy at the moment")

                        elseif not CluckinBellBusy then

                            if not TakedOrder then

                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to receive Order")

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    block = true
                                    TriggerServerEvent('prp-tastyeats:SynchroCluckinBellFood')
                                    TakedOrder = true
                                    SetEntityCoords(ped, -180.14, -1428.56, 31.31 - 0.96)
                                    SetEntityHeading(ped, 121.90)
                                    RequestAnimDict('mp_common')
                                    while not HasAnimDictLoaded('mp_common') do
                                      Citizen.Wait(0)
                                    end
                                    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                    Citizen.Wait(750)
                                    bagPed = CreateObject(GetHashKey("prop_ld_handbag_s"), coords.x, coords.y, coords.z,  true,  true, true)
                                    AttachEntityToEntity(bagPed, ped, GetPedBoneIndex(ped, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                    Citizen.Wait(750)
                                    ClearPedTasks(ped)
                                    block = false

                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Place the Order on the Passenger Seat in your vehicle", timeout = 5000})

                                end

                            elseif TakedOrder and DeliveryPlace == nil then

                                DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "Put the bag with the Order on the Passenger Seat")

                            end

                        end

                    elseif Restaurant.name == "Pizza This" then

                        if PizzaThisBusy then

                            DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "~b~" ..Restaurant.name.. " Worker~s~ is Busy at the moment")

                        elseif not PizzaThisBusy then

                            if not TakedOrder then

                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to receive Order")

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    block = true
                                    TriggerServerEvent('prp-tastyeats:SynchroPizzaThisFood')
                                    TakedOrder = true
                                    SetEntityCoords(ped, 538.07, 100.58, 96.50 - 0.96)
                                    SetEntityHeading(ped, 341.74)
                                    RequestAnimDict('mp_common')
                                    while not HasAnimDictLoaded('mp_common') do
                                      Citizen.Wait(0)
                                    end
                                    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                    Citizen.Wait(750)
                                    bagPed = CreateObject(GetHashKey("prop_ld_handbag_s"), coords.x, coords.y, coords.z,  true,  true, true)
                                    AttachEntityToEntity(bagPed, ped, GetPedBoneIndex(ped, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                    Citizen.Wait(750)
                                    ClearPedTasks(ped)
                                    block = false

                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Place the Order on the Passenger Seat in your vehicle", timeout = 5000})

                                end

                            elseif TakedOrder and DeliveryPlace == nil then

                                DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "Put the bag with the Order on the Passenger Seat")

                            end

                        end

                    elseif Restaurant.name == "Burger Shot" then

                        if BurgerShotBusy then

                            DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "~b~" ..Restaurant.name.. " Worker~s~ is Busy at the moment")

                        elseif not BurgerShotBusy then

                            if not TakedOrder then

                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [~g~E~s~] to receive Order")

                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                    block = true
                                    TriggerServerEvent('prp-tastyeats:SynchroBurgerShotFood')
                                    TakedOrder = true
                                    SetEntityCoords(ped, -1182.08, -883.19, 13.79 - 0.96)
                                    SetEntityHeading(ped, 122.42)
                                    RequestAnimDict('mp_common')
                                    while not HasAnimDictLoaded('mp_common') do
                                      Citizen.Wait(0)
                                    end
                                    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                    Citizen.Wait(750)
                                    bagPed = CreateObject(GetHashKey("prop_ld_handbag_s"), coords.x, coords.y, coords.z,  true,  true, true)
                                    AttachEntityToEntity(bagPed, ped, GetPedBoneIndex(ped, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                    Citizen.Wait(750)
                                    ClearPedTasks(ped)
                                    block = false

                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Place the Order on the Passenger Seat in your vehicle", timeout = 5000})

                                end

                            elseif TakedOrder and DeliveryPlace == nil then

                                DrawText3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.0, "Put the bag with the Order on the Passenger Seat")

                            end

                        end

                    end

                elseif (#(coords - vector3(Restaurant.x, Restaurant.y, Restaurant.z)) < 6.0) then

                    refresh = 4
                    DrawEmoji3D(Restaurant.x, Restaurant.y, Restaurant.z + 1.3, Restaurant.emoji)

                end

                if WorkVeh ~= nil then

                    if TakedOrder and DeliveryPlace == nil then

                        refresh = 4
                        vehcoords = GetWorldPositionOfEntityBone(WorkVeh, GetEntityBoneIndexByName(WorkVeh, 'window_rf'))

                        if (#(coords - vector3(vehcoords.x, vehcoords.y, vehcoords.z)) < 0.8) then

                            if inOrderMenu then
                        
                                inOrderMenu = false
        
                            end

                            DrawText3D(vehcoords.x, vehcoords.y, vehcoords.z + 0.1, "Press [~g~E~s~] to put away Bag with Food")

                            if IsControlJustReleased(0, Keys["E"]) and not block then

                                block = true
                                SetVehicleDoorOpen(WorkVeh, 1, false, true)
                                Citizen.Wait(250)
                                RequestAnimDict('anim@heists@money_grab@briefcase')
                                while not HasAnimDictLoaded('anim@heists@money_grab@briefcase') do
                                  Citizen.Wait(0)
                                end
                                TaskPlayAnim(ped, 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 2, 0, false, false, false)
                                Citizen.Wait(700)
                                ClearPedTasks(ped)
                                Citizen.Wait(250)
                                SetVehicleDoorShut(WorkVeh, 1, true)
                                DeleteObject(bagPed)

                                DeliveryPlace = icfg.TastyEats["DeliveryPlace"][math.random(1, #icfg.TastyEats["DeliveryPlace"])]
                                SetNewWaypoint(DeliveryPlace.x, DeliveryPlace.y)
                                ComingToCustomer = true
                                street = GetStreetNameAtCoord(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z)
                                street2 = GetStreetNameFromHashKey(street)
                                DeliveryBlip = AddBlipForCoord(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z)
                                SetBlipSprite(DeliveryBlip, 162)
                                SetBlipDisplay(DeliveryBlip, 4)
                                SetBlipScale(DeliveryBlip, 0.6)
                                SetBlipAsShortRange(DeliveryBlip, false)
                                SetBlipColour(DeliveryBlip, 43)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName('[~g~Tasty Eats~s~] ~b~' ..street2.. '~s~')
                                EndTextCommandSetBlipName(DeliveryBlip)
                                block = false

                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Customer GPS location has been marked on the map. Drive to " ..street2.. " street.", timeout = 5000})

                            end

                        end

                    end

                    while ComingToCustomer do

                        local refresh = 500
                        local ped = PlayerPedId()
                        local coords = GetEntityCoords(ped)

                            if (#(coords - vector3(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z)) < 80.0) then

                                ComingToCustomer = false
                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You are close to the Delivery Point, Park the Vehicle and Deliver the Food", timeout = 5000})
            
                            end

                        Citizen.Wait(refresh)

                    end

                    if DeliveryPlace ~= nil then

                        if not IsPedInAnyVehicle(ped, false) then

                            if not HaveBagInHand then

                                if (#(coords - vector3(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z)) < 50) then

                                    refresh = 4
                                    vehcoords = GetWorldPositionOfEntityBone(WorkVeh, GetEntityBoneIndexByName(WorkVeh, 'window_rf'))

                                    if (#(coords - vector3(vehcoords.x, vehcoords.y, vehcoords.z)) < 0.8) then

                                        if inOrderMenu then
                        
                                            inOrderMenu = false
                    
                                        end

                                        DrawText3D(vehcoords.x, vehcoords.y, vehcoords.z + 0.1, "Press [~r~E~s~] to take Bag with Food")

                                        if IsControlJustReleased(0, Keys["E"]) and not block then

                                            block = true
                                            SetVehicleDoorOpen(WorkVeh, 1, false, true)
                                            Citizen.Wait(250)
                                            RequestAnimDict('anim@heists@money_grab@briefcase')
                                            while not HasAnimDictLoaded('anim@heists@money_grab@briefcase') do
                                              Citizen.Wait(0)
                                            end
                                            TaskPlayAnim(ped, 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 2, 0, false, false, false)
                                            Citizen.Wait(350)
                                            bagPed = CreateObject(GetHashKey("prop_ld_handbag_s"), coords.x, coords.y, coords.z,  true,  true, true)
                                            AttachEntityToEntity(bagPed, ped, GetPedBoneIndex(ped, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                            Citizen.Wait(350)
                                            ClearPedTasks(ped)
                                            Citizen.Wait(250)
                                            SetVehicleDoorShut(WorkVeh, 1, true)
                                            HaveBagInHand = true
                                            block = false

                                        end

                                    end

                                end

                            elseif HaveBagInHand then

                                if (#(coords - vector3(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z)) < 0.6) then

                                    refresh = 4

                                    if inOrderMenu then
                        
                                        inOrderMenu = false
                
                                    end

                                    if not hasKnockedDoor then

                                        DrawText3D(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z + 0.5, "Press [~g~E~s~] to Knock on the Door")
                                        DrawMarker(25, DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 36, 214, 45, 100, false, true, 2, false, false, false, false)

                                        if IsControlJustReleased(0, Keys["E"]) and not block then

                                            block = true
                                            SetEntityCoords(ped, DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z - 0.96)
                                            SetEntityHeading(ped, DeliveryPlace.h)
                                            RequestAnimDict('timetable@jimmy@doorknock@')
                                            while not HasAnimDictLoaded('timetable@jimmy@doorknock@') do
                                              Citizen.Wait(0)
                                            end
                                            TaskPlayAnim(ped, 'timetable@jimmy@doorknock@', 'knockdoor_idle', 8.0, -8.0, -1, 2, 0, false, false, false)
                                            Citizen.Wait(2500)
                                            ClearPedTasks(ped)
                                            hasKnockedDoor = true
                                            CustomerComingDoor = true
                                            FreezeEntityPosition(ped, true)
        
                                            Citizen.CreateThread(function()

                                                Citizen.Wait(icfg.CustomerComingToDoor)
                                                RequestAnimDict('anim@heists@money_grab@briefcase')
                                                while not HasAnimDictLoaded('anim@heists@money_grab@briefcase') do
                                                  Citizen.Wait(0)
                                                end
                                                TaskPlayAnim(ped, 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 2, 0, false, false, false)
                                                Citizen.Wait(700)
                                                ClearPedTasks(ped)
                                                Citizen.Wait(450)
                                                DeleteObject(bagPed)
                                                
                                                local Customer = GetHashKey(icfg.TastyEats["Peds"][math.random(1, #icfg.TastyEats["Peds"])].ped)
                                                RequestModel(Customer)
                                                while not HasModelLoaded(Customer) do
                                                    Citizen.Wait(1)
                                                end
                                                CustomerNPC = CreatePed(1, Customer, DeliveryPlace.px, DeliveryPlace.py, DeliveryPlace.pz - 0.98, DeliveryPlace.ph, true, true)
                                                SetBlockingOfNonTemporaryEvents(CustomerNPC, true)
                                                SetPedDiesWhenInjured(CustomerNPC, false)
                                                SetPedCanPlayAmbientAnims(CustomerNPC, true)
                                                SetPedCanRagdollFromPlayerImpact(CustomerNPC, false)
                                                SetEntityInvincible(CustomerNPC, true)
                                                FreezeEntityPosition(CustomerNPC, true)

                                                RandomText = icfg.TastyEats["RandomText"][math.random(1, #icfg.TastyEats["RandomText"])]
                                                CustomerComingDoor = false
                                                block = false

                                            end)
        
                                        end

                                    elseif hasKnockedDoor then

                                        if CustomerComingDoor then

                                            DrawText3D(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z + 0.5, "~b~Customer~s~ going to Door...")

                                        elseif not CustomerComingDoor then

                                            PEDcoords = GetEntityCoords(CustomerNPC)

                                            if not EndText then

                                                DrawText3D(PEDcoords.x, PEDcoords.y, PEDcoords.z + 1.0, RandomText.NPCText)
                                                DrawText3D(coords.x, coords.y, coords.z + 1.0, RandomText.YourText)

                                                if IsControlJustReleased(0, Keys["E"]) and not block then

                                                    block = true
                                                    RequestAnimDict('mp_common')
                                                    while not HasAnimDictLoaded('mp_common') do
                                                      Citizen.Wait(0)
                                                    end
                                                    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                                    RequestAnimDict('mp_common')
                                                    while not HasAnimDictLoaded('mp_common') do
                                                      Citizen.Wait(0)
                                                    end
                                                    TaskPlayAnim(CustomerNPC, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                                    Citizen.Wait(1500)
                                                    ClearPedTasks(ped)
                                                    ClearPedTasks(CustomerNPC)
                                                    RequestAnimDict('anim@heists@money_grab@briefcase')
                                                    while not HasAnimDictLoaded('anim@heists@money_grab@briefcase') do
                                                      Citizen.Wait(0)
                                                    end
                                                    TaskPlayAnim(CustomerNPC, 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 2, 0, false, false, false)
                                                    Citizen.Wait(700)
                                                    ClearPedTasks(CustomerNPC)
                                                    CustomerBag = CreateObject(GetHashKey("prop_ld_handbag_s"), PEDcoords.x, PEDcoords.y, PEDcoords.z,  true,  true, true)
                                                    AttachEntityToEntity(CustomerBag, CustomerNPC, GetPedBoneIndex(CustomerNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)

                                                    Citizen.CreateThread(function()

                                                        EndText = true
                                                        Citizen.Wait(3500)
                                                        EndText = false
                                                        FreezeEntityPosition(ped, false)
                                                        ProjectRP.Functions.TriggerCallback('prp-tastyeats:Payout', function(money)
                                                            experience = experience + 1
                                                            Citizen.Wait(500)

                                                            if Level == 5 then

                                                                exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! You currently have " ..experience.. " points!", timeout = 5000})

                                                            elseif Level == 4 then

                                                                if experience == icfg.Levels.Level5.MinPoints then

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! Congratulations, you have reached Level 5! Your Earnings and Trust have increased. Pick up a new Company Vehicle from Base!", timeout = 7500})
                                                                    SetNewWaypoint(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y)
                                                                    Level = 5

                                                                else

                                                                    NextLevel = icfg.Levels.Level5.MinPoints - experience

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! You currently have " ..experience.. " points and you missing " ..NextLevel.. " points to Level 5!", timeout = 5000})

                                                                end

                                                            elseif Level == 3 then

                                                                if experience == icfg.Levels.Level4.MinPoints then

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! Congratulations, you have reached Level 4! Your Earnings and Trust have increased. Pick up a new Company Vehicle from Base!", timeout = 7500})
                                                                    SetNewWaypoint(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y)
                                                                    Level = 4

                                                                else

                                                                    NextLevel = icfg.Levels.Level4.MinPoints - experience

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! You currently have " ..experience.. " points and you missing " ..NextLevel.. " points to Level 4!", timeout = 5000})

                                                                end

                                                            elseif Level == 2 then

                                                                if experience == icfg.Levels.Level3.MinPoints then

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! Congratulations, you have reached Level 3! Your Earnings and Trust have increased. Pick up a new Company Vehicle from Base!", timeout = 7500})
                                                                    SetNewWaypoint(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y)
                                                                    Level = 3

                                                                else

                                                                    NextLevel = icfg.Levels.Level3.MinPoints - experience

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! You currently have " ..experience.. " points and you missing " ..NextLevel.. " points to Level 3!", timeout = 5000})

                                                                end

                                                            elseif Level == 1 then

                                                                if experience == icfg.Levels.Level2.MinPoints then

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! Congratulations, you have reached Level 2! Your Earnings and Trust have increased. Pick up a new Company Vehicle from Base!", timeout = 7500})
                                                                    SetNewWaypoint(icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.x, icfg.TastyEats["Base"].Garage.Coords.ReturnVehicle.y)
                                                                    Level = 2

                                                                else

                                                                    NextLevel = icfg.Levels.Level2.MinPoints - experience

                                                                    exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>You have earned " ..money.. "$! You currently have " ..experience.. " points and you missing " ..NextLevel.. " points to Level 2!", timeout = 5000})

                                                                end

                                                            end

                                                        end, PlayerData, Level)
                                                        hasKnockedDoor = false
                                                        HaveBagInHand = false
                                                        RemoveBlip(DeliveryBlip)
                                                        DeliveryPlace = nil
                                                        TakedOrder = false
                                                        RemoveBlip(RestaurantBlip)
                                                        Restaurant = nil
                                                        DeleteObject(CustomerBag)
                                                        DeletePed(CustomerNPC)
                                                        block = false

                                                    end)

                                                end

                                            elseif EndText then

                                                DrawText3D(PEDcoords.x, PEDcoords.y, PEDcoords.z + 1.0, RandomText.NPCText2)

                                            end

                                        end

                                    end

                                elseif (#(coords - vector3(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z)) < 6.0) then

                                    refresh = 4
                                    DrawEmoji3D(DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z + 0.5, "🙋‍♂️")
                                    DrawMarker(25, DeliveryPlace.x, DeliveryPlace.y, DeliveryPlace.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 82, 82, 82, 100, false, true, 2, false, false, false, false)

                                end

                            end

                        end
                        
                    end

                end

            end

        Citizen.Wait(refresh)
    end
end)

--#######################

function MathGroupDigits(value)

    local symbol = ','
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1' .. symbol):reverse())..right

end

--#######################


RegisterNetEvent('prp-tastyeats:GetHookiesFood')
AddEventHandler('prp-tastyeats:GetHookiesFood', function()

    HookiesBusy = true
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(HookiesNPC, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
    Citizen.Wait(750)
    DeleteObject(HookiesBag)
    Citizen.Wait(750)
    ClearPedTasks(HookiesNPC)
    Citizen.Wait(2500)
    HookiesBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][1].x, icfg.TastyEats["Restaurant"][1].y, icfg.TastyEats["Restaurant"][1].z, false, true, true)
    AttachEntityToEntity(HookiesBag, HookiesNPC, GetPedBoneIndex(HookiesNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
    HookiesBusy = false

end)

RegisterNetEvent('prp-tastyeats:GetTacoBombFood')
AddEventHandler('prp-tastyeats:GetTacoBombFood', function()

    TacoBombBusy = true
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(TacoBombNPC, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
    Citizen.Wait(750)
    DeleteObject(TacoBombBag)
    Citizen.Wait(750)
    ClearPedTasks(TacoBombNPC)
    Citizen.Wait(2500)
    TacoBombBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][2].x, icfg.TastyEats["Restaurant"][2].y, icfg.TastyEats["Restaurant"][2].z, false, true, true)
    AttachEntityToEntity(TacoBombBag, TacoBombNPC, GetPedBoneIndex(TacoBombNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
    TacoBombBusy = false

end)

RegisterNetEvent('prp-tastyeats:GetCluckinBellFood')
AddEventHandler('prp-tastyeats:GetCluckinBellFood', function()

    CluckinBellBusy = true
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(CluckinBellNPC, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
    Citizen.Wait(750)
    DeleteObject(CluckinBellBag)
    Citizen.Wait(750)
    ClearPedTasks(CluckinBellNPC)
    Citizen.Wait(2500)
    CluckinBellBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][3].x, icfg.TastyEats["Restaurant"][3].y, icfg.TastyEats["Restaurant"][3].z, false, true, true)
    AttachEntityToEntity(CluckinBellBag, CluckinBellNPC, GetPedBoneIndex(CluckinBellNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
    CluckinBellBusy = false

end)

RegisterNetEvent('prp-tastyeats:GetPizzaThisFood')
AddEventHandler('prp-tastyeats:GetPizzaThisFood', function()

    PizzaThisBusy = true
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(PizzaThisNPC, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
    Citizen.Wait(750)
    DeleteObject(PizzaThisBag)
    Citizen.Wait(750)
    ClearPedTasks(PizzaThisNPC)
    Citizen.Wait(2500)
    PizzaThisBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][4].x, icfg.TastyEats["Restaurant"][4].y, icfg.TastyEats["Restaurant"][4].z, false, true, true)
    AttachEntityToEntity(PizzaThisBag, PizzaThisNPC, GetPedBoneIndex(PizzaThisNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
    PizzaThisBusy = false

end)

RegisterNetEvent('prp-tastyeats:GetBurgerShotFood')
AddEventHandler('prp-tastyeats:GetBurgerShotFood', function()

    BurgerShotBusy = true
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(BurgerShotNPC, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
    Citizen.Wait(750)
    DeleteObject(BurgerShotBag)
    Citizen.Wait(750)
    ClearPedTasks(BurgerShotNPC)
    Citizen.Wait(2500)
    BurgerShotBag = CreateObject(GetHashKey("prop_ld_handbag_s"), icfg.TastyEats["Restaurant"][5].x, icfg.TastyEats["Restaurant"][5].y, icfg.TastyEats["Restaurant"][5].z, false, true, true)
    AttachEntityToEntity(BurgerShotBag, BurgerShotNPC, GetPedBoneIndex(BurgerShotNPC, 28422), 0.47, 0.02, 0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
    BurgerShotBusy = false

end)

function SpawnCar(car, coords, plate)

    ProjectRP.Functions.SpawnVehicle(car, function(veh)
        
        SetEntityHeading(veh, h)
        SetVehicleLivery(veh, 1)
        SetVehicleDirtLevel(veh, 0.0)     
        SetVehicleNumberPlateText(veh, plate..tostring(math.random(1000, 9999)))
        SetVehicleEngineOn(veh, true, false)
        Plate = GetVehicleNumberPlateText(vehicle)
		TriggerEvent("vehiclekeys:client:SetOwner", ProjectRP.Functions.GetPlate(veh))	
        exports.pNotify:SendNotification({text = "<b>Tasty Eats</b></br></br>Press <b>[DEL]</b> to Open/Close Order Management Menu", timeout = 2500})
        WorkVeh = veh
       
    end, coords)

end

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
    DrawRect(0.0, 0.0+0.0125, 0.025+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DrawEmoji3D(x, y, z, text)
	SetTextScale(0.6, 0.6)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawText3DMenu(x, y, z, text)
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
    DrawRect(0.0, 0.0325, -0.14+ factor, 0.08, 0, 0, 0, 75)
    ClearDrawOrigin()
end