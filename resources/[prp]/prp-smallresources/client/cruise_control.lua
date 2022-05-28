local LastCCVehicle = nil
local CurrentCCMetersPerSecond = nil
local CurrentCCKmh = nil
local SpeedDiffTolerance = (0.5/3.6)
local LastFrameSpeed = nil
local LastForcedRpm = nil

local LastIdealPedalPressure = 0.0
local IncreasePressure = false
local LastVehicleHealth = nil

function GetConfigCorrectSpeed(speed)
    return speed * 1.609
end

local wait = 100
Citizen.CreateThread(function()
    while true do
        Wait(wait)

        local ped = PlayerPedId()
        local pedVeh = GetVehiclePedIsIn(ped)

        if LastCCVehicle then
            if pedVeh ~= LastCCVehicle then
                UnsetCruiseControl()
            else
                if IsControlJustPressed(0, 72) or IsControlJustPressed(0, 76) then -- brake or handbrake
                    UnsetCruiseControl()
                else
                    local engineHealth = GetVehicleEngineHealth(pedVeh)

                    if LastVehicleHealth and ((LastVehicleHealth - engineHealth) > 10) then
                        UnsetCruiseControl()
                    else
                        LastVehicleHealth = engineHealth

                        local curSpeed = GetEntitySpeed(pedVeh)

                        local diff = CurrentCCMetersPerSecond - curSpeed

                        if diff > SpeedDiffTolerance then -- car is slower then required
                            local pedalPressure = 0.95

                            if IsSteering(pedVeh) then
                                pedalPressure = 0.4
                            end

                            if IncreasePressure then
                                LastIdealPedalPressure = LastIdealPedalPressure + 0.025
                                IncreasePressure = false
                            end

                            SetControlNormal(0, 71, pedalPressure)
                        elseif diff > -(4*SpeedDiffTolerance) then -- when speed is met
                            ApplyIdealPedalPressure()
                        else
                            LastIdealPedalPressure = 0.2
                        end
                    end
                end
            end
        end

        LastForcedRpm = newLastForcedRpm
    end
end)

function ApplyIdealPedalPressure()
    if not IncreasePressure then
        IncreasePressure = true
    end
    SetControlNormal(0, 71, LastIdealPedalPressure)
end

function IsSteering(veh)
    return GetVehicleSteeringAngle(veh) > 10.0
end

function IsCruiseControlOn()
    return not not LastCCVehicle
end

function SetCruiseControl(kmh)
    wait = 0

    ResetCurrentVehicleMaxSpeed()
    local mpsSpeed = KmhToMps(kmh)

    local veh = GetVehiclePedIsIn(PlayerPedId())

    LastCCVehicle = veh
    CurrentCCMetersPerSecond = mpsSpeed
    CurrentCCKmh = kmh
end

function ResetCurrentVehicleMaxSpeed()
    if LastSpeedLimitedVehicle then
        ResetVehicleMaxSpeed(LastSpeedLimitedVehicle)
    else
        ResetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId()))
    end
end

function ResetVehicleMaxSpeed(veh)
    local maxSpeed = GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel")
    SetVehicleMaxSpeed(veh, maxSpeed)
    LastSpeedLimitedVehicle = nil
    CurrentMaxSpeedMetersPerSecond = nil
    CurrentMaxSpeedKmh = nil
    LastForcedRpm = nil
end

function UnsetCruiseControl()
    wait = 100

    LastCCVehicle = nil
    CurrentCCMetersPerSecond = nil
    CurrentCCKmh = nil
    LastVehicleHealth = nil
end

function KmhToMps(kmh)
    return kmh * (1/3.6)
end

function MpsToKmh(mps)
    return mps * 3.6
end

function MpsToMph(mps)
    return MpsToKmh(mps) * (1/1.609)
end

local function GetVehicleSpeed() return GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) end

RegisterCommand('cruise', function()
    speed = MpsToMph(GetVehicleSpeed())
    SetCruiseControl(GetConfigCorrectSpeed(speed))
end, false)

RegisterKeyMapping('cruise', 'Toggle Cruise Control', 'keyboard', 'F7')
