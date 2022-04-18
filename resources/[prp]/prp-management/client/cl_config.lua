-- Zones for Menues
Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use prp-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)

Config.BossMenus = {
    ['police'] = {
        vector3(461.44, -986.2, 30.7),
    },
    ['ambulance'] = {
        vector3(361.58, -588.23, 47.32),
    },
    ['realestate'] = {
        vector3(-124.786, -641.486, 168.820),
    },
    ['taxi'] = {
        vector3(895.76, -164.9, 74.17),
    },
    ['cardealer'] = {
        vector3(-32.0, -1114.2, 26.4),
    },
    ['pizza'] = {
        vector3(289.05, -989.53, 29.43),
    },
    ['burger'] = {
        vector3(-1177.11, -896.44, 13.98),
    },
    ['vu'] = {
        vector3(93.57, -1292.3, 29.27),
    },
    ['tequilala'] = {
        vector3(-573.11, 286.41, 79.18),
    },
    ['recycling'] = {
        vector3(993.67, -3102.85, -39.0),
    },
    ['mechanic'] = {
        vector3(-347.41, -133.48, 39.01),
    },
}

Config.BossMenuZones = {
    ['police'] = {
        { coords = vector3(461.44, -986.2, 30.7), length = 0.35, width = 0.45, heading = 351.0, minZ = 30.58, maxZ = 30.68 } ,
    },
    ['ambulance'] = {
        { coords = vector3(361.58, -588.23, 47.32), length = 1.2, width = 0.6, heading = 341.0, minZ = 43.13, maxZ = 43.73 },
    },
    ['realestate'] = {
        { coords = vector3(-124.786, -641.486, 168.820), length = 0.6, width = 1.0, heading = 25.0, minZ = 83.943, maxZ = 84.74 },
    },
    ['taxi'] = {
        { coords = vector3(895.76, -164.9, 74.17), length = 1.0, width = 3.4, heading = 327.0, minZ = 73.17, maxZ = 74.57 },
    },
    ['cardealer'] = {
        { coords = vector3(-32.0, -1114.2, 26.4), length = 2.4, width = 1.05, heading = 340.0, minZ = 27.07, maxZ = 27.67 },
    },
    ['pizza'] = {
        { coords = vector3(289.05, -989.53, 29.43), length = 2.4, width = 1.05, heading = 340.0, minZ = 27.07, maxZ = 27.67 },
    },
    ['burger'] = {
        { coords = vector3(-1177.11, -896.44, 13.98), length = 2.4, width = 1.05, heading = 340.0, minZ = 27.07, maxZ = 27.67 },
    },
    ['vu'] = {
        { coords = vector3(93.57, -1292.3, 29.27), length = 2.4, width = 1.05, heading = 340.0, minZ = 27.07, maxZ = 27.67 },
    },
    ['tequilala'] = {
        { coords = vector3(-573.11, 286.41, 79.18), length = 2.4, width = 1.05, heading = 340.0, minZ = 27.07, maxZ = 27.67 },
    },
    ['recycling'] = {
        { coords = vector3(993.67, -3102.85, -39.0), length = 2.4, width = 1.05, heading = 340.0, minZ = 27.07, maxZ = 27.67 },
    },
    ['mechanic'] = {
        { coords = vector3(-347.41, -133.48, 39.01), length = 1.15, width = 2.6, heading = 353.0, minZ = 43.59, maxZ = 44.99 },
    },
}

Config.GangMenus = {
    ['lostmc'] = {
        vector3(0, 0, 0),
    },
    ['ballas'] = {
        vector3(110.33, -1967.71, 21.33),
    },
    ['vagos'] = {
        vector3(350.02, -2031.86, 22.39),
    },
    ['cartel'] = {
        vector3(1396.63, 1159.01, 114.33),
    },
    ['families'] = {
        vector3(-150.26, -1588.07, 35.03),
    },
    ['triads'] = {
        vector3(0, 0, 0),
    },
    ['celestial'] = {
        vector3(0, 0, 0),
    },
    ['flowersociety'] = {
        vector3(0, 0, 0),
    },
}

Config.GangMenuZones = {
    -- ['gangname'] = {
    --     { coords = vector3(0.0, 0.0, 0.0), length = 0.0, width = 0.0, heading = 0.0, minZ = 0.0, maxZ = 0.0 },
    -- },
}
