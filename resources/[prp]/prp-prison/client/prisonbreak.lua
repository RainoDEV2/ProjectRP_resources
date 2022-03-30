local currentGate = 0
local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false

local Gates = {
    [1] = {
        gatekey = 13,
        coords = vector3(1845.99, 2604.7, 45.58),
        hit = false,
    },
    [2] = {
        gatekey = 14,
        coords = vector3(1819.47, 2604.67, 45.56),
        hit = false,
    },
    [3] = {
        gatekey = 15,
        coords = vector3(1804.74, 2616.311, 45.61),
        hit = false,
    }
}

-- Functions

local function OnHackDone(success)
    if success then
        TriggerServerEvent("prison:server:SetGateHit", currentGate)
		TriggerServerEvent('prp-doorlock:server:updateState', Gates[currentGate].gatekey, false)
		TriggerEvent('mhacking:hide')
    else
        TriggerServerEvent("prison:server:SecurityLockdown")
		TriggerEvent('mhacking:hide')
	end
end

-- Events

RegisterNetEvent('electronickit:UseElectronickit', function()
    if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then
        ProjectRP.Functions.TriggerCallback('ProjectRP:HasItem', function(result)
            if result then
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                ProjectRP.Functions.Progressbar("hack_gate", "Electronic kit plug in..", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 18), OnHackDone)
                end, function() -- Cancel
                    StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    ProjectRP.Functions.Notify("Cancelled..", "error")
                end)
            else
                ProjectRP.Functions.Notify("You're missing an item..", "error")
            end
        end, "gatecrack")
    end
end)

RegisterNetEvent('prison:client:SetLockDown', function(isLockdown)
    securityLockdown = isLockdown
    if securityLockdown and inJail then
        TriggerEvent("chatMessage", "HOSTAGE", "error", "Highest security level is active, stay with the cell blocks!")
    end
end)

RegisterNetEvent('prison:client:PrisonBreakAlert', function()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'},
        coords = coords,
        title = '10-98 - Prison Outbreak',
        message = 'Someone is attempting to escape Boilingbroke Penitentiary',
        flash = 0,
        unique_id = tostring(math.random(0000000,9999999)),
        blip = {
            sprite = 431,
            scale = 1.2,
            colour = 3,
            flashes = false,
            text = '911 - Prison outbreak',
            time = (5*60*1000),
            sound = 1,
        }
    })

    local BreakBlip = AddBlipForCoord(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)
    TriggerServerEvent('prison:server:JailAlarm')
	SetBlipSprite(BreakBlip , 161)
	SetBlipScale(BreakBlip , 3.0)
	SetBlipColour(BreakBlip, 3)
	PulseBlip(BreakBlip)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Wait(100)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Wait((1000 * 60 * 5))
    RemoveBlip(BreakBlip)
end)

RegisterNetEvent('prison:client:SetGateHit', function(key, isHit)
    Gates[key].hit = isHit
end)

RegisterNetEvent('prison:client:JailAlarm', function(toggle)
    if toggle then
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, "prison_alarm")

        CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Wait(100)
            end
            StartAlarm("PRISON_ALARMS", true)
        end)
    else
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, "prison_alarm")

        CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Wait(100)
            end
            StopAllAlarms(true)
        end)
    end
end)

-- Threads

CreateThread(function()
    Wait(500)
    requiredItems = {
        [1] = {name = ProjectRP.Shared.Items["electronickit"]["name"], image = ProjectRP.Shared.Items["electronickit"]["image"]},
        [2] = {name = ProjectRP.Shared.Items["gatecrack"]["name"], image = ProjectRP.Shared.Items["gatecrack"]["image"]},
    }
    while true do
        Wait(5)
        inRange = false
        currentGate = 0
        if LocalPlayer.state.isLoggedIn then
            if PlayerJob.name ~= "police" then
                local pos = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Gates) do
                    local dist =  #(pos - Gates[k].coords)
                    if (dist < 1.5) then
                        currentGate = k
                        inRange = true
                        if securityLockdown then
                            DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "~r~SYSTEM LOCKDOWN")
                        elseif Gates[k].hit then
                            DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "SYSTEM BREACH")
                        elseif not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if not inRange then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                    Wait(1000)
                end
            else
                Wait(1000)
            end
        else
            Wait(5000)
        end
    end
end)

CreateThread(function()
	while true do
		Wait(7)
		local pos = GetEntityCoords(PlayerPedId(), true)
        if #(pos - vector3(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)) > 200 and inJail then
			inJail = false
            jailTime = 0
            RemoveBlip(currentBlip)
            RemoveBlip(CellsBlip)
            CellsBlip = nil
            RemoveBlip(TimeBlip)
            TimeBlip = nil
            RemoveBlip(ShopBlip)
            ShopBlip = nil
            TriggerServerEvent("prison:server:SecurityLockdown")
            TriggerEvent('prison:client:PrisonBreakAlert')
            TriggerServerEvent("prison:server:SetJailStatus", 0)
            TriggerServerEvent("ProjectRP:Server:SetMetaData", "jailitems", {})
            ProjectRP.Functions.Notify("You escaped... Get the hell out of here.!", "error")
		end
	end
end)