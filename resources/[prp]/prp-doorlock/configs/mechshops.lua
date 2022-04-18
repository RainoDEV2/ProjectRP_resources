-- bennyspdm created by Parker
Config.DoorList['bennyspdm'] = {
    objYaw = 69.999923706055,
    distance = 5,
    locked = false,
    audioRemote = false,
    authorizedJobs = { ['mechanic'] = 0 },
    fixText = false,
    objName = -427498890,
    doorRate = 1.0,
    doorType = 'garage',
    objCoords = vec3(-44.188396, -1043.553833, 27.801605),
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- bennyssouth created by Parker
Config.DoorList['mechanic'] = {
    objYaw = 0.0,
    distance = 5,
    locked = true,
    audioRemote = false,
    authorizedJobs = { ['mechanic'] = 4 },
    fixText = false,
    objName = -427498890,
    doorRate = 1.0,
    doorType = 'garage',
    objCoords = vec3(-205.682831, -1310.682617, 30.295719),
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- lscustoms1 created by Parker
Config.DoorList['lscustoms1'] = {
    distance = 5,
    locked = true,
    objCoords = vec3(-356.090485, -134.771423, 40.012955),
    audioRemote = false,
    fixText = false,
    objYaw = 249.99995422363,
    doorRate = 1.0,
    objName = -550347177,
    doorType = 'garage',
    authorizedJobs = { ['realestate'] = 0 },
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}