-- To Set This Up visit https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686

-- CreateThread(function()
--     while true do
--         -- This is the Application ID (Replace this with you own)
-- 	SetDiscordAppId(911807488247099452)

--         -- Here you will have to put the image name for the "large" icon.
-- 	SetDiscordRichPresenceAsset('infinity_logo')
        
--         -- (11-11-2018) New Natives:

--         -- Here you can add hover text for the "large" icon.
--         SetDiscordRichPresenceAssetText('Professional FiveM Framework!')
       
--         -- Here you will have to put the image name for the "small" icon.
--         SetDiscordRichPresenceAssetSmall('small_infinity')

--         -- Here you can add hover text for the "small" icon.
--         SetDiscordRichPresenceAssetSmallText('Join our socials!')

--         ProjectRP.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
--             SetRichPresence('Players: '..result..'/64')
--         end)

--         -- (26-02-2021) New Native:

--         --[[ 
--             Here you can add buttons that will display in your Discord Status,
--             First paramater is the button index (0 or 1), second is the title and 
--             last is the url (this has to start with "fivem://connect/" or "https://") 
--         ]]--
--         SetDiscordRichPresenceAction(0, "Join Our Discord!", "https://discord.gg/75JEkeDy4v")
--         SetDiscordRichPresenceAction(1, "Website !", "fivem://connect/localhost:30120")

--         -- It updates every minute just in case.
-- 	Wait(60000)
--     end
-- end)
