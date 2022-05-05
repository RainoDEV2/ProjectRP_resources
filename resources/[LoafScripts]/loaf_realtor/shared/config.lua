Config = {
    Framework = "prp",
    JobName = "rea",
    CreateGrade = 1, -- minimum grade to create houses
    MenuAlign = "bottom-right", -- esx_menu_default alignment

    UseRPName = true, -- should the transfer & bill menu show the in-game name?

    MinPrice = 20000, -- minimum price for a property
    CreatePercent = 0, -- set to 0 or false to disable. % of the price will be removed from the realtor society wallet when creating a house

    AllowRemoveOwned = false, -- allow realtors to remove a house someone owns?
    AllowSelf = true, -- allow realtors to sell & transfer houses to themselves?

    Command = "reamenu", -- the command to open the job menu (where you can add a house)
    Keybind = {
        Enabled = false, -- should the script register a keybind?
        Mapper = "KEYBOARD", -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/
        Parameter = "F6"
    },

    Teleport = {
        vector4(-198.30014038086, -575.40997314453, 40.489864349365, 71.06999206543),
        vector4(-141.67323303223, -617.73034667969, 168.82054138184, 275.59158325195),
    },

    BossActions = vector3(-125.89316558838, -641.09680175781, 168.83529663086),
}