Config = {}

Config.Icons = { --Icons for jobs in the menu. Use job name(Case sensitive). Can use FontAwsome or Bootstrap Icons
    ['police'] = 'bi bi-shield-shaded',
    ['ambulance'] = 'fas fa-ambulance',
    ['tow'] = 'bi bi-truck-flatbed',
    ['taxi'] = 'fas fa-taxi',
    ['lawyer'] = 'bi bi-briefcase',
    ['judge'] = 'fas fa-gavel',
    ['realestate'] = 'bi bi-house',
    ['cardealer'] = 'fas fa-car',
    ['mechanic'] = 'bi bi-tools',
    ['reporter'] = 'bi bi-newspaper',
    ['trucker'] = 'fas fa-truck-moving',
    ['garbage'] = 'fas fa-recycle',
}

Config.DefaultIcon = "fas fa-briefcase" --The default icon shown if the job isn't defined above

Config.BlackListedJobs = { --jobs that won't automatically be added to the multijob menu. EG Can use cityhall jobs if you want them to go to city hall each time
    'unemployed',
    'recycle',
}

Config.Keybind = "F3" --Keybind used to open the menu