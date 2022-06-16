Config = {}

Config.DefaultVolume = 0.1 -- Accepted values are 0.01 - 1

Config.Locations = {
    ['vanilla'] = {
        ['job'] = 'vu', -- Required job to use booth
        ['radius'] = 30, -- The radius of the sound from the booth
        ['coords'] = vector3(120.52, -1281.5, 29.48), -- Where the booth is located
        ['playing'] = false
    },
    ['galaxy1'] = {
        ['job'] = 'galaxy', -- Required job to use booth
        ['radius'] = 25, -- The radius of the sound from the booth
        ['coords'] = vector3(375.52, 275.86, 92.4), -- Where the booth is located
        ['playing'] = false
    },
    ['galaxy2'] = {
        ['job'] = 'galaxy', -- Required job to use booth
        ['radius'] = 25, -- The radius of the sound from the booth
        ['coords'] = vector3(399.15, 269.11, 92.05), -- Where the booth is located
        ['playing'] = false
    },
    ['casinoRoof'] = {
        ['job'] = nil,
        ['radius'] = 45, -- The radius of the sound from the booth
        ['coords'] = vector3(937.35, 20.15, 112.55), -- Where the booth is located
        ['playing'] = false
    },
}
