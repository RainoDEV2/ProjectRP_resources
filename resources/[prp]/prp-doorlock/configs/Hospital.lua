-- critical care created by Milos
Config.DoorList['critical care'] = {
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 159.99993896484, objCoords = vec3(348.065552, -574.419434, 29.048290)},
        {objName = -1143010057, objYaw = 340.00003051758, objCoords = vec3(350.510254, -575.310791, 29.048290)}
    },
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    doorType = 'double',
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- lower front desk created by Milos
Config.DoorList['lower front desk'] = {
    distance = 2,
    doorRate = 1.0,
    doorType = 'door',
    objCoords = vec3(340.367310, -587.272278, 28.918690),
    objName = -770740285,
    objYaw = 250.00004577637,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    fixText = false,
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- morgue created by Milos
Config.DoorList['morgue'] = {
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 250.00004577637, objCoords = vec3(327.309662, -588.841858, 29.048290)},
        {objName = -1143010057, objYaw = 69.999992370605, objCoords = vec3(328.202576, -586.398315, 29.048290)}
    },
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    doorType = 'double',
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- double door garage created by Milos
Config.DoorList['double door garage'] = {
    distance = 2,
    doors = {
        {objName = -2023754432, objYaw = 204.97253417969, objCoords = vec3(321.098877, -560.092163, 29.045158)},
        {objName = -2023754432, objYaw = 24.816186904907, objCoords = vec3(318.743530, -561.184937, 29.043869)}
    },
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    doorType = 'double',
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- garage door 1 created by Milos
Config.DoorList['garage door 1'] = {
    distance = 10,
    doorRate = 1.0,
    doorType = 'garage',
    objCoords = vec3(339.239624, -564.924988, 30.101749),
    objName = -1196921358,
    objYaw = 159.93878173828,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    fixText = false,
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- garage door 2 created by Milos
Config.DoorList['garage door 2'] = {
    distance = 10,
    doorRate = 1.0,
    doorType = 'garage',
    objCoords = vec3(328.085785, -560.855469, 30.117950),
    objName = 1482782641,
    objYaw = 160.0612487793,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    fixText = false,
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- morgue door2 created by Milos
Config.DoorList['morgue door2'] = {
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 250.00004577637, objCoords = vec3(318.879242, -571.622559, 29.047279)},
        {objName = -1143010057, objYaw = 69.999992370605, objCoords = vec3(319.772186, -569.179138, 29.047279)}
    },
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    doorType = 'double',
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- main staircase created by Milos
Config.DoorList['main staircase'] = {
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 340.00003051758, objCoords = vec3(334.290039, -577.531006, 29.048290)},
        {objName = -1143010057, objYaw = 159.99993896484, objCoords = vec3(331.845306, -576.639648, 29.048290)}
    },
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioRemote = true,
    doorType = 'double',
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- main locker room created by Milos
Config.DoorList['main locker room'] = {
    doorType = 'door',
    doorRate = 1.0,
    objCoords = vec3(311.857971, -599.006775, 43.312836),
    audioRemote = true,
    distance = 2,
    fixText = false,
    objYaw = 71.658546447754,
    objName = -770740285,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- main locker room2 created by Milos
Config.DoorList['main locker room2'] = {
    doorType = 'door',
    doorRate = 1.0,
    objCoords = vec3(310.241425, -603.639160, 43.312836),
    audioRemote = true,
    distance = 2,
    fixText = false,
    objYaw = 250.00003051758,
    objName = -770740285,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- surgery door 1 created by Milos
Config.DoorList['surgery door 1'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 159.99992370605, objCoords = vec3(313.053131, -579.812805, 43.431892)},
        {objName = -1143010057, objYaw = 340.00003051758, objCoords = vec3(315.498230, -580.701843, 43.431892)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- surgery door 2 created by Milos
Config.DoorList['surgery door 2'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 69.999961853027, objCoords = vec3(332.484894, -571.685364, 43.432426)},
        {objName = -1143010057, objYaw = 249.99993896484, objCoords = vec3(331.595703, -574.129883, 43.432426)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- ward door 1 created by Milos
Config.DoorList['ward door 1'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 69.999961853027, objCoords = vec3(338.286530, -582.964966, 43.432426)},
        {objName = -1143010057, objYaw = 249.99990844727, objCoords = vec3(337.397339, -585.409546, 43.432426)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- ward door 2 created by Milos
Config.DoorList['ward door 2'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 160.00009155273, objCoords = vec3(340.716919, -587.539978, 43.431892)},
        {objName = -1143010057, objYaw = 340.00003051758, objCoords = vec3(343.160950, -588.429749, 43.431892)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- security room door 1 created by Milos
Config.DoorList['security room door 1'] = {
    doorType = 'door',
    doorRate = 1.0,
    objCoords = vec3(342.628540, -579.917053, 43.302299),
    audioRemote = true,
    distance = 2,
    fixText = false,
    objYaw = 69.999992370605,
    objName = -770740285,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- wards door 3 created by Milos
Config.DoorList['wards door 3'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 249.99993896484, objCoords = vec3(358.567352, -583.947510, 43.432426)},
        {objName = -1143010057, objYaw = 69.999961853027, objCoords = vec3(359.456512, -581.502930, 43.432426)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- lab and records created by Milos
Config.DoorList['lab and records'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -770740285, objYaw = 340.00003051758, objCoords = vec3(320.846710, -587.622437, 48.244530)},
        {objName = -770740285, objYaw = 159.99993896484, objCoords = vec3(318.681915, -586.839539, 48.244530)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- Offices door 1 created by Milos
Config.DoorList['Offices door 1'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = -1143010057, objYaw = 69.999961853027, objCoords = vec3(338.269257, -582.960144, 48.374123)},
        {objName = -1143010057, objYaw = 250.00003051758, objCoords = vec3(337.379211, -585.403809, 48.374123)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- training class room created by Milos
Config.DoorList['training class room'] = {
    audioRemote = true,
    distance = 2,
    doors = {
        {objName = 1647181300, objYaw = 340.00003051758, objCoords = vec3(331.763611, -577.048462, 48.382904)},
        {objName = 1647181300, objYaw = 160.00006103516, objCoords = vec3(334.208344, -577.931396, 48.374908)}
    },
    doorType = 'double',
    doorRate = 1.0,
    authorizedJobs = { ['ambulance'] = 0, ['police'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}
