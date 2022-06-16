-- Variables

local ProjectRP = exports['prp-core']:GetCoreObject()
local currentZone = nil
local PlayerData = {}
local nextToBooth = false

-- Handlers

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	PlayerData = ProjectRP.Functions.GetPlayerData()
end)

AddEventHandler('ProjectRP:Client:OnPlayerLoaded', function()
    PlayerData = ProjectRP.Functions.GetPlayerData()
end)

RegisterNetEvent('ProjectRP:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('ProjectRP:Client:OnPlayerUnload', function()
    PlayerData = {}
end)


-- Static Header

local musicHeader = {
    {
        header = 'Play some music!',
        params = {
            event = 'prp-djbooth:client:playMusic'
        }
    }
}

-- Main Menu

function createMusicMenu()
    musicMenu = {
        {
            isHeader = true,
            header = '💿 | DJ Booth'
        },
        {
            header = '🎶 | Play a song',
            txt = 'Enter a youtube URL',
            params = {
                event = 'prp-djbooth:client:musicMenu',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '⏸️ | Pause Music',
            txt = 'Pause currently playing music',
            params = {
                isServer = true,
                event = 'prp-djbooth:server:pauseMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '▶️ | Resume Music',
            txt = 'Resume playing paused music',
            params = {
                isServer = true,
                event = 'prp-djbooth:server:resumeMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '🔈 | Change Volume',
            txt = 'Resume playing paused music',
            params = {
                event = 'prp-djbooth:client:changeVolume',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '❌ | Turn off music',
            txt = 'Stop the music & choose a new song',
            params = {
                isServer = true,
                event = 'prp-djbooth:server:stopMusic',
                args = {
                    zoneName = currentZone
                }
            }
        }
    }
end

-- DJ Booths

local vanilla = BoxZone:Create(Config.Locations['vanilla'].coords, 1, 1, { name="vanilla", heading=0 })
vanilla:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['vanilla'].job then
        currentZone = 'vanilla'
        exports['prp-core']:DrawText('E - DJ Booth', 'left')
    else
        currentZone = nil
        exports['prp-menu']:closeMenu()
        exports['prp-core']:HideText()
    end
end)

local galaxy1 = BoxZone:Create(Config.Locations['galaxy1'].coords, 1, 1, { name="galaxy1", heading=0 })
galaxy1:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['galaxy1'].job then
        currentZone = 'galaxy1'
        exports['prp-core']:DrawText('E - DJ Booth', 'left')
    else
        currentZone = nil
        exports['prp-menu']:closeMenu()
        exports['prp-core']:HideText()
    end
end)

local galaxy2 = BoxZone:Create(Config.Locations['galaxy2'].coords, 1, 1, { name="galaxy2", heading=0 })
galaxy2:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['galaxy2'].job then
        currentZone = 'galaxy2'
        exports['prp-core']:DrawText('E - DJ Booth', 'left')
    else
        currentZone = nil
        exports['prp-menu']:closeMenu()
        exports['prp-core']:HideText()
    end
end)

local casinoRoof = BoxZone:Create(Config.Locations['casinoRoof'].coords, 1, 1, { name="casinoRoof", heading=0 })
casinoRoof:onPlayerInOut(function(isPointInside)
    if isPointInside then
        currentZone = 'casinoRoof'
        exports['prp-core']:DrawText('E - DJ Booth', 'left')
    else
        currentZone = nil
        exports['prp-menu']:closeMenu()
        exports['prp-core']:HideText()
    end
end)

CreateThread(function()
    while true do
        Wait(3)
        if currentZone ~= nil then
            if IsControlJustReleased(0, 38) then
                TriggerEvent("prp-djbooth:client:playMusic")
            end
        end
    end
end)

local djbooths = {}
CreateThread(function()
    -- casinoRoof
    RequestModel(GetHashKey("v_club_vu_deckcase"))
    while not HasModelLoaded(GetHashKey("v_club_vu_deckcase")) do Citizen.Wait(2) end
    djbooths[#djbooths+1] = CreateObject(GetHashKey("v_club_vu_deckcase"), 937.75, 19.74, 112.02, false, false, false)
    SetEntityHeading(djbooths[#djbooths], 239.6)
    FreezeEntityPosition(djbooths[#djbooths], true)
end)

-- Events

RegisterNetEvent('prp-djbooth:client:playMusic', function()
    createMusicMenu()
    exports['prp-menu']:openMenu(musicMenu)
end)

RegisterNetEvent('prp-djbooth:client:musicMenu', function()
    local dialog = exports['prp-input']:ShowInput({
        header = 'Song Selection',
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            }
        }
    })
    if dialog then
        if not dialog.song then return end
        TriggerServerEvent('prp-djbooth:server:playMusic', dialog.song, currentZone)
    end
end)

RegisterNetEvent('prp-djbooth:client:changeVolume', function()
    local dialog = exports['prp-input']:ShowInput({
        header = 'Music Volume',
        submitText = "Submit",
        inputs = {
            {
                type = 'text', -- number doesn't accept decimals??
                isRequired = true,
                name = 'volume',
                text = 'Min: 0.01 - Max: 1'
            }
        }
    })
    if dialog then
        if not dialog.volume then return end
        TriggerServerEvent('prp-djbooth:server:changeVolume', dialog.volume, currentZone)
    end
end)