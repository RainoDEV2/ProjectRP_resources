PRPConfig = {}

PRPConfig.MaxPlayers = GetConvarInt('sv_maxclients', 64) -- Gets max players from config file, default 64
PRPConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
PRPConfig.UpdateInterval = 5
PRPConfig.UpdateSalary = 15 -- how often to update player data in minutes
PRPConfig.StatusInterval = 5000 -- how often to check hunger/thirst status in ms

PRPConfig.Money = {}
PRPConfig.Money.MoneyTypes = { ['cash'] = 500, ['bank'] = 5000, ['crypto'] = 0 } -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
PRPConfig.Money.DontAllowMinus = { 'cash', 'crypto' } -- Money that is not allowed going in minus
PRPConfig.Money.PayCheckTimeOut = 10 -- The time in minutes that it will give the paycheck

PRPConfig.Player = {}
PRPConfig.Player.MaxWeight = 120000 -- Max weight a player can carry (currently 120kg, written in grams)
PRPConfig.Player.MaxInvSlots = 41 -- Max inventory slots for a player
PRPConfig.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
PRPConfig.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
PRPConfig.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}

PRPConfig.Server = {} -- General server config
PRPConfig.Server.closed = false -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
PRPConfig.Server.closedReason = "Server Closed" -- Reason message to display when people can't join the server
PRPConfig.Server.uptime = 0 -- Time the server has been up.
PRPConfig.Server.whitelist = false -- Enable or disable whitelist on the server
PRPConfig.Server.discord = "https://discord.gg/cmtqfbwZcG" -- Discord invite link
PRPConfig.Server.PermissionList = {} -- permission list

PRPConfig.Notify = {}

PRPConfig.Notify.NotificationStyling = {
    group = false, -- Allow notifications to stack with a badge instead of repeating
    position = "right", -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
    progress = true -- Display Progress Bar
}

-- These are how you define different notification variants
-- The "color" key is background of the notification
-- The "icon" key is the css-icon code, this project uses `Material Icons` & `Font Awesome`
PRPConfig.Notify.VariantDefinitions = {
    success = {
        classes = 'success',
        icon = 'done'
    },
    primary = {
        classes = 'primary',
        icon = 'info'
    },
    error = {
        classes = 'error',
        icon = 'dangerous'
    },
    police = {
        classes = 'police',
        icon = 'local_police'
    },
    ambulance = {
        classes = 'ambulance',
        icon = 'fas fa-ambulance'
    }
}
