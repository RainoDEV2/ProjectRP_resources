local ProjectRP = exports['prp-core']:GetCoreObject()

local Races = {}
local InRace = false
local RaceId = 0
local ShowCountDown = false
local RaceCount = 5

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if Races ~= nil then
            -- No race yet
            local pos = GetEntityCoords(PlayerPedId(), true)
            if RaceId == 0 then
                for k, race in pairs(Races) do
                    if Races[k] ~= nil then
                        if #(pos - vector3(Races[k].startx, Races[k].starty, Races[k].startz)) < 15.0 and not Races[k].started then
                            DrawText3Ds(Races[k].startx, Races[k].starty, Races[k].startz, "[~g~H~w~] To Join The Race (~g~$"..Races[k].amount..",-~w~)")
                            if IsControlJustReleased(0, 74) then
                                TriggerServerEvent("prp-streetraces:JoinRace", k)
                            end
                        end
                    end

                end
            end
            -- Not started in race yet
            if RaceId ~= 0 and not InRace then
                if #(pos - vector3(Races[RaceId].startx, Races[RaceId].starty, Races[RaceId].startz)) < 15.0 and not Races[RaceId].started then
                    DrawText3Ds(Races[RaceId].startx, Races[RaceId].starty, Races[RaceId].startz, "Race Will Start Soon")
                end
            end
            -- In race and started
            if RaceId ~= 0 and InRace then
                if #(pos - vector3(Races[RaceId].endx, Races[RaceId].endy, pos.z)) < 250.0 and Races[RaceId].started then
                    DrawText3Ds(Races[RaceId].endx, Races[RaceId].endy, pos.z + 0.98, "FINISH")
                    if #(pos - vector3(Races[RaceId].endx, Races[RaceId].endy, pos.z)) < 15.0 then
                        TriggerServerEvent("prp-streetraces:RaceWon", RaceId)
                        InRace = false
                    end
                end
            end

            if ShowCountDown then
                if #(pos - vector3(Races[RaceId].startx, Races[RaceId].starty, Races[RaceId].startz)) < 15.0 and Races[RaceId].started then
                    DrawText3Ds(Races[RaceId].startx, Races[RaceId].starty, Races[RaceId].startz, "Race start in ~g~"..RaceCount)
                end
            end
        end
    end
end)

RegisterNetEvent('prp-streetraces:StartRace')
AddEventHandler('prp-streetraces:StartRace', function(race)
    if RaceId ~= 0 and RaceId == race then
        SetNewWaypoint(Races[RaceId].endx, Races[RaceId].endy)
        InRace = true
        RaceCountDown()
    end
end)

RegisterNetEvent('prp-streetraces:RaceDone')
AddEventHandler('prp-streetraces:RaceDone', function(race, winner)
    if RaceId ~= 0 and RaceId == race then
        RaceId = 0
        InRace = false
        ProjectRP.Functions.Notify("Race Is Over! The Winner Is "..winner.. "!")
    end
end)

RegisterNetEvent('prp-streetraces:StopRace')
AddEventHandler('prp-streetraces:StopRace', function()
    RaceId = 0
    InRace = false
end)

RegisterNetEvent('prp-streetraces:CreateRace')
AddEventHandler('prp-streetraces:CreateRace', function(amount)
    local pos = GetEntityCoords(PlayerPedId(), true)
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local c = GetBlipInfoIdCoord(WaypointHandle, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())
        unusedBool, groundZ = GetGroundZFor_3dCoord(c[1], c[2], 99999.0, 1)
        if #(pos - vector3(c[1], c[2], groundZ)) > 500.0 then
            local race = {
                creator = nil,
                started = false,
                startx = pos.x,
                starty = pos.y,
                startz = pos.z,
                endx = c[1],
                endy = c[2],
                endz = groundZ,
                amount = amount,
                pot = amount,
                joined = {}
            }
            TriggerServerEvent("prp-streetraces:NewRace", race)
            ProjectRP.Functions.Notify("Race Made For $"..amount.."", "success")
        else
            ProjectRP.Functions.Notify("End Position Is Too Close", "error")
        end
    else
        ProjectRP.Functions.Notify("You Need To Drop A Marker", "error")
    end
end)

RegisterNetEvent('prp-streetraces:SetRace')
AddEventHandler('prp-streetraces:SetRace', function(RaceTable)
    Races = RaceTable
end)

RegisterNetEvent('prp-streetraces:SetRaceId')
AddEventHandler('prp-streetraces:SetRaceId', function(race)
    RaceId = race
    SetNewWaypoint(Races[RaceId].endx, Races[RaceId].endy)
end)

function RaceCountDown()
    ShowCountDown = true
    while RaceCount ~= 0 do
        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), true)
        PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
        ProjectRP.Functions.Notify(RaceCount, 'primary', 800)
        Citizen.Wait(1000)
        RaceCount = RaceCount - 1
    end
    ShowCountDown = false
    RaceCount = 5
    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), false)
    ProjectRP.Functions.Notify("GOOOOOOOOO!!!")
end

