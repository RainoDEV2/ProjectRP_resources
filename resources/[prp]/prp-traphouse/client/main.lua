local isLoggedIn = false
local PlayerData = {}
local ClosestTraphouse = nil
local InsideTraphouse = false
local CurrentTraphouse = nil
local TraphouseObj = {}
local POIOffsets = nil
local IsKeyHolder = false
local IsHouseOwner = false
local InTraphouseRange = false
local CodeNPC = nil
local IsRobbingNPC = false


local gangNpcMap = {
	["vagos"] = {
		"g_m_y_mexgang_01",
		"g_m_y_mexgoon_01",
		"g_m_y_mexgoon_02",
		"g_m_y_mexgoon_03",
		"g_m_y_pologoon_01",
		"g_m_y_pologoon_02"
	},
	["marabunta"] = {
		"g_m_y_salvagoon_01",
		"g_m_y_salvagoon_02",
		"g_m_y_salvagoon_03",
		"g_m_y_strpunk_01",
		"g_m_y_strpunk_02"
	},
	["aztecas"] = {
		"g_m_y_salvagoon_01",
		"g_m_y_salvagoon_02",
		"g_m_y_salvagoon_03",
		"g_m_y_strpunk_01",
		"g_m_y_strpunk_02"
	},
	["ballas"] = {
		"g_m_y_ballaeast_01",
		"g_m_y_ballaorig_01",
		"g_m_y_ballasout_01"
	},
	["gsf"] = {
		"g_m_y_famca_01",
		"g_m_y_famdnf_01",
		"g_m_y_famfor_01"
	}
}

local gang2rel = {
	["vagos"] = "AMBIENT_GANG_MEXICAN",
	["marabunta"] = "AMBIENT_GANG_SALVA",
	["aztecas"] = "AMBIENT_GANG_SALVA",
	["ballas"] = "AMBIENT_GANG_BALLAS",
	["gsf"] = "AMBIENT_GANG_FAMILY"
}

-- Code

Citizen.CreateThread(function()
    while true do
        
        if isLoggedIn then
            SetClosestTraphouse()
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    if ProjectRP.Functions.GetPlayerData() ~= nil then
        isLoggedIn = true
        PlayerData = ProjectRP.Functions.GetPlayerData()
        ProjectRP.Functions.TriggerCallback('prp-traphouse:server:GetTraphousesData', function(trappies)
            Config.TrapHouses = trappies
        end)
    end
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded')
AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = ProjectRP.Functions.GetPlayerData()
    ProjectRP.Functions.TriggerCallback('prp-traphouse:server:GetTraphousesData', function(trappies)
        Config.TrapHouses = trappies
    end)
end)



function SetClosestTraphouse()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, traphouse in pairs(Config.TrapHouses) do
        if current ~= nil then
            if #(pos - Config.TrapHouses[id].coords.enter) < dist then
                current = id
                dist = #(pos - Config.TrapHouses[id].coords.enter)
            end
        else
            dist = #(pos - Config.TrapHouses[id].coords.enter)
            current = id
        end
    end
    ClosestTraphouse = current
    IsKeyHolder = HasKey(PlayerData.citizenid)
    IsHouseOwner = IsOwner(PlayerData.citizenid)
end

function HasKey(CitizenId)
    local haskey = false
    if ClosestTraphouse ~= nil then
        if Config.TrapHouses[ClosestTraphouse].keyholders ~= nil and next(Config.TrapHouses[ClosestTraphouse].keyholders) ~= nil then
            for _, data in pairs(Config.TrapHouses[ClosestTraphouse].keyholders) do
                if data.citizenid == CitizenId then
                    haskey = true
                end
            end
        end
    end
    return haskey
end

function IsOwner(CitizenId)
    local retval = false
    if ClosestTraphouse ~= nil then
        if Config.TrapHouses[ClosestTraphouse].keyholders ~= nil and next(Config.TrapHouses[ClosestTraphouse].keyholders) ~= nil then
            for _, data in pairs(Config.TrapHouses[ClosestTraphouse].keyholders) do
                if data.citizenid == CitizenId then
                    if data.owner then
                        retval = true
                    else
                        retval = false
                    end
                end
            end
        end
    end
    return retval
end

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

RegisterNetEvent('prp-traphouse:client:EnterTraphouse')
AddEventHandler('prp-traphouse:client:EnterTraphouse', function(code)
    if ClosestTraphouse ~= nil then
        if InTraphouseRange then
            local data = Config.TrapHouses[ClosestTraphouse]
            if not IsKeyHolder then
                SendNUIMessage({
                    action = "open"
                })
                SetNuiFocus(true, true)
            else
                EnterTraphouse(data)
            end
        end
    end
end)

RegisterNUICallback('PinpadClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
    ProjectRP.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('EnterPincode', function(d)
    local data = Config.TrapHouses[ClosestTraphouse]
    if tonumber(d.pin) == data.pincode then
        EnterTraphouse(data)
    else
        ProjectRP.Functions.Notify('This Code Is Incorrect', 'error')
    end
end)

local CanRob = true

function RobTimeout(timeout)
    SetTimeout(timeout, function()
        CanRob = true
    end)
end

local RobbingTime = 3
local TraphouseRobbingNPC = 3500

Citizen.CreateThread(function()
    while true do

        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
        if targetPed ~= 0 and not IsPedAPlayer(targetPed) then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if ClosestTraphouse ~= nil then
                local data = Config.TrapHouses[ClosestTraphouse]
                local dist = #(pos - data.coords["enter"])
                if dist < 200 then
                    TraphouseRobbingNPC = 3
                    if aiming then
                        local pcoords = GetEntityCoords(targetPed)
                        local peddist = #(pos - pcoords)
                        if peddist < 4 then
                            InDistance = true
                            if not IsRobbingNPC and CanRob then
                                if IsPedInAnyVehicle(targetPed) then
                                    TaskLeaveVehicle(targetPed, GetVehiclePedIsIn(targetPed), 1)
                                end
                                Citizen.Wait(500)
                                InDistance = true

                                local dict = 'random@mugging3'
                                RequestAnimDict(dict)
                                while not HasAnimDictLoaded(dict) do
                                    Citizen.Wait(10)
                                end

                                SetEveryoneIgnorePlayer(PlayerId(), true)
                                TaskStandStill(targetPed, RobbingTime * 1000)
                                FreezeEntityPosition(targetPed, true)
                                SetBlockingOfNonTemporaryEvents(targetPed, true)
                                TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 2.0, -2, 15.0, 1, 0, 0, 0, 0)
                                for i = 1, RobbingTime / 2, 1 do
                                    PlayAmbientSpeech1(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                                    Citizen.Wait(2000)
                                end
                                FreezeEntityPosition(targetPed, true)
                                IsRobbingNPC = true
                                SetTimeout(RobbingTime, function()
                                    IsRobbingNPC = false
                                    RobTimeout(math.random(30000, 60000))
                                    if not IsEntityDead(targetPed) then
                                        if CanRob then
                                            if InDistance then
                                                SetEveryoneIgnorePlayer(PlayerId(), false)
                                                SetBlockingOfNonTemporaryEvents(targetPed, false)
                                                FreezeEntityPosition(targetPed, false)
                                                ClearPedTasks(targetPed)
                                                AddShockingEventAtPosition(99, GetEntityCoords(targetPed), 0.5)
                                                TriggerServerEvent('RobNpc')
                                                TriggerEvent("Project-traphouse:luckRob", targetPed)
                                                CanRob = false
                                            end
                                        end
                                    end
                                end)
                            end
                        else
                            if InDistance then
                                InDistance = false
                            end
                        end
                    end
                end
            else
                TraphouseRobbingNPC = 1000
            end
        end
        Citizen.Wait(TraphouseRobbingNPC)
    end
end)

local traphousesleep = 3500

Citizen.CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false

        if ClosestTraphouse ~= nil then
            local data = Config.TrapHouses[ClosestTraphouse]
            if InsideTraphouse then
                traphousesleep = 3
                local ExitDistance = #(pos - vector3(data.coords["enter"].x + POIOffsets.exit.x, data.coords["enter"].y + POIOffsets.exit.y, data.coords["enter"].z - Config.MinZOffset + POIOffsets.exit.z))
                if ExitDistance < 20 then
                    inRange = true
                    if ExitDistance < 1 then
                        DrawText3Ds(data.coords["enter"].x + POIOffsets.exit.x, data.coords["enter"].y + POIOffsets.exit.y, data.coords["enter"].z - Config.MinZOffset + POIOffsets.exit.z, '~b~E~w~ - Leave')
                        if IsControlJustPressed(0, 38) then
                            LeaveTraphouse(data)
                        end
                    end
                end

                local InteractDistance = #(pos - vector3(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z))
                if InteractDistance < 20 then
                    inRange = true
                    if InteractDistance < 1 then
                        if not IsKeyHolder then
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z + 0.2, '~g~H~s~ to Sell Items')
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z, '~b~E~w~ - Take Over (~g~$5000~w~)')
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z - 0.2, '~g~F~s~ to see reputation')
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent('prp-traphouse:server:TakeoverHouse', CurrentTraphouse)
                            end
                            if IsControlJustPressed(0, 74) then
                                local TraphouseInventory = {}
                                TraphouseInventory.label = "traphouse_"..CurrentTraphouse
                                TraphouseInventory.items = data.inventory
                                TraphouseInventory.slots = 2
                                TriggerServerEvent("inventory:server:OpenInventory", "traphouse", CurrentTraphouse, TraphouseInventory)
                            end
                        else
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z + 0.2, '~g~H~s~ to Sell Items')
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z, '~b~E~w~ - Take Cash (~g~$'..data.money..'~w~)')
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z - 0.2, '~g~F~s~ to see reputation')
                            if IsHouseOwner then
                                DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z - 0.4, '~b~/multikeys~w~ [id] - To Give Keys')
                                
                                if IsControlJustPressed(0, 47) then
                                    ProjectRP.Functions.Notify('Pincode: '..data.pincode)
                                end
                            end
                                
                            if IsControlJustReleased(0, 23) then
                                local _next = math.floor(data.reputation) + 1
                                local progress = (data.reputation - math.floor(data.reputation)) * 100
                                progress = string.format("%.2f %%", progress)
                                if _next > 100 then progress = 'MAXED' end
                                local bonus = math.min(100, (2 * math.floor(data.reputation)))
                                ProjectRP.Functions.Notify('Reputation: '.. math.floor(data.reputation) .. " (" .. progress .. "). Current bonus: " .. bonus .. "%")
                            end

                            if IsControlJustPressed(0, 74) then
                                local TraphouseInventory = {}
                                TraphouseInventory.label = "traphouse_"..CurrentTraphouse
                                TraphouseInventory.items = data.inventory
                                TraphouseInventory.slots = 2
                                TriggerServerEvent("inventory:server:OpenInventory", "traphouse", CurrentTraphouse, TraphouseInventory)
                            end
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent("prp-traphouse:server:TakeMoney", CurrentTraphouse)
                            end
                        end
                    end
                end
            else
                local EnterDistance = #(pos - data.coords["enter"])
                if EnterDistance < 20 then
                    traphousesleep = 3
                    inRange = true
                    if EnterDistance < 1 then
                        InTraphouseRange = true
                    else
                        if InTraphouseRange then
                            InTraphouseRange = false
                        end
                    end
                end
            end
        else
            traphousesleep = 2000
        end

        Citizen.Wait(traphousesleep)
    end
end)

function EnterTraphouse(data)
    local coords = { x = data.coords["enter"].x, y = data.coords["enter"].y, z= data.coords["enter"].z - Config.MinZOffset}
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    data = exports['prp-interior']:CreateTrevorsShell(coords)
    TraphouseObj = data[1]
    POIOffsets = data[2]
    CurrentTraphouse = ClosestTraphouse
    InsideTraphouse = true
    TriggerEvent('prp-weathersync:client:DisableSync')
    FreezeEntityPosition(TraphouseObj, true)
end

function LeaveTraphouse(data)
    local ped = PlayerPedId()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    exports['prp-interior']:DespawnInterior(TraphouseObj, function()
        TriggerEvent('prp-weathersync:client:EnableSync')
        DoScreenFadeIn(250)
        SetEntityCoords(ped, data.coords["enter"].x, data.coords["enter"].y, data.coords["enter"].z + 0.5)
        SetEntityHeading(ped, 107.71)
        TraphouseObj = nil
        POIOffsets = nil
        CurrentTraphouse = nil
        InsideTraphouse = false
    end)
end

RegisterNetEvent('prp-traphouse:client:TakeoverHouse')
AddEventHandler('prp-traphouse:client:TakeoverHouse', function(TraphouseId)
    local ped = PlayerPedId()

    ProjectRP.Functions.Progressbar("takeover_traphouse", "Taking Over", (60 * 2) * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("traphouse:takeover:notify",TraphouseId)
        TriggerServerEvent('prp-traphouse:server:AddHouseKeyHolder', PlayerData.citizenid, TraphouseId, true)
    end, function()
        ProjectRP.Functions.Notify("Acquisitions Canceled", "error")
    end)
end)

function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
        if data.citizenid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse)
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            if #Config.TrapHouses[Traphouse].keyholders == 0 then
                Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                    citizenid = CitizenId,
                    owner = true,
                }
            else
                Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                    citizenid = CitizenId,
                    owner = false,
                }
            end
            ProjectRP.Functions.Notify(CitizenId..' Has Been Added To The Traphouse!')
        else
            ProjectRP.Functions.Notify(CitizenId..' This Person Already Has Keys')
        end
    else
        ProjectRP.Functions.Notify('You Can Give Up To 6 People Access To The Trap House!')
    end
    IsKeyHolder = HasKey(CitizenId)
    IsHouseOwner = IsOwner(CitizenId)
end

RegisterNetEvent('prp-traphouse:client:SyncData')
AddEventHandler('prp-traphouse:client:SyncData', function(k, data)
    Config.TrapHouses[k] = data
    -- print("sync data")
    IsKeyHolder = HasKey(PlayerData.citizenid)
    IsHouseOwner = IsOwner(PlayerData.citizenid)
end)


RegisterNetEvent("Axel:Is:sEXYa:ASADA")
AddEventHandler("Axel:Is:sEXYa:ASADA", function(shit)

    if shit == PlayerData.gang.name then
        ProjectRP.Functions.Notify('Boss, Somebody is taking over our traphouse!')
    end
end)

local cooldown = false



AddEventHandler("Project-traphouse:luckRob", function(ped)
    local pos = GetEntityCoords(PlayerPedId(), true)
            local data = Config.TrapHouses[ClosestTraphouse]
            local dist = #(pos - data.coords["enter"])

            if dist < 50 then
                local rand = math.random() + math.random(0, 100)
                if Config.TrapHouses[ClosestTraphouse].reputation <= 25 then
                    if rand > 0.25 then
                        return
                    end
                elseif Config.TrapHouses[ClosestTraphouse].reputation <= 50 then
                    if rand > 0.5 then
                        return
                    end
                elseif Config.TrapHouses[ClosestTraphouse].reputation <= 75 then
                    if rand > 0.75 then
                        return
                    end
                elseif Config.TrapHouses[ClosestTraphouse].reputation <= 100 then
                    if rand > 1 then
                        return
                    end
                end
    
                if cooldown then
                    return
                end

                Citizen.CreateThread(function()
                    cooldown = true
                    if Config.TrapHouses[ClosestTraphouse].reputation <= 25 then
                        Citizen.Wait(15000)
                    elseif Config.TrapHouses[ClosestTraphouse].reputation <= 50 then
                        Citizen.Wait(10000)
                    elseif Config.TrapHouses[ClosestTraphouse].reputation <= 75 then
                        Citizen.Wait(5000)
                    elseif Config.TrapHouses[ClosestTraphouse].reputation <= 100 then
                        Citizen.Wait(5000)
                    end
    
                    cooldown = false
                end)


                -- print(GetHashKey(gang2rel[Config.TrapHouses[ClosestTraphouse].gang]).. " - " ..GetPedRelationshipGroupHash(ped))
                -- local Chance = math.random(1, 10)
                -- local odd = math.random(1, 10)
            
                -- if Chance == odd then
                    if GetPedRelationshipGroupHash(ped) == GetHashKey(gang2rel[Config.TrapHouses[ClosestTraphouse].gang]) then
                        print("get pin")
                        ProjectRP.Functions.Notify('Alright, the pin is '..Config.TrapHouses[ClosestTraphouse].pincode)

                        Citizen.Wait(500)
                        AddShockingEventAtPosition(99, GetEntityCoords(ped), 0.5)
                        Citizen.Wait(30000)
                        if DoesEntityExist(ped) then
                            DeleteEntity(ped)
                        end
                    -- end
                end
            end
end)



function isGangModel(gang, model)
	for k, v in pairs(gangNpcMap[gang]) do
		if model == GetHashKey(v) then
			return true
		end
	end
end

function findNPC(x,y,z,gang)
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    local pedfound = false
    repeat
        local pos = GetEntityCoords(ped)
		local distance = #(pos - vector3(x,y,z))
        if distance < 40.0 and (distanceFrom == nil or distance < distanceFrom) and isGangModel(gang, GetEntityModel(ped)) then
            if IsEntityDead(ped) then
                DeleteEntity(ped)
            else
                pedfound = true
            end
        end
        success, ped = FindNextPed(handle)
    until not success or pedfound
    	EndFindPed(handle)
    return pedfound
end


Citizen.CreateThread(function()
	while true do

		for k, v in pairs(Config.TrapHouses) do
			local dist = #(GetEntityCoords(PlayerPedId()) - v.coords["enter"])
			if dist < 30 then
                x,y,z = table.unpack(v.coords["enter"])
				local hasNpc = findNPC(x, y, z, v.gang)
				if not hasNpc then

					local model = gangNpcMap[v.gang][math.random(#gangNpcMap[v.gang])]
					RequestModel(GetHashKey(model))
					while not HasModelLoaded(GetHashKey(model)) do
						Citizen.Wait(1)
					end

					local npc = CreatePed(4, GetHashKey(model), v.coords["enter"], 262.5998, true, true)
					--SetBlockingOfNonTemporaryEvents(npc, true)
					SetEntityHeading(npc, 262.5998)
					-- SetEntityCoords(npc, GetEntityCoords(npc) + GetEntityForwardVector(npc) * math.random(-5, 5))
					-- SetEntityHeading(npc, 10 + 180.0 + math.random(-40.0, 40.0))
					-- SetEntityCoords(npc, GetEntityCoords(npc) + GetEntityForwardVector(npc) * math.random(0, 5))

					SetPedRelationshipGroupDefaultHash(npc, GetHashKey(gang2rel[v.gang]))
					SetPedRelationshipGroupHash(npc, GetHashKey(gang2rel[v.gang]))

					local finalCoords = GetEntityCoords(npc)

					TaskWanderInArea(npc, finalCoords.x, finalCoords.y, finalCoords.z, 30.0, 5.0, 4.0)
				end
			end
		end

		Citizen.Wait(60 * 15 * 1000)
	end
end)