

-- bookshelf created by Parker
Config.DoorList['bookshelf'] = {
    authorizedGangs = { ['celestial'] = 0 },
    doorType = 'door',
    fixText = false,
    distance = 1,
    objCoords = vec3(403.953217, 248.795425, 92.185333),
    objName = -957944942,
    doorRate = 1.0,
    objYaw = 164.07965087891,
    locked = true,
    audioRemote = false,
    audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
}

-- Front Door created by Quackers
Config.DoorList['Front Door'] = {
    distance = 2,
    objName = -1989765534,
    objYaw = 165.6577911377,
    objCoords = vec3(355.692291, 301.018585, 104.202202),
    doorRate = 1.0,
    doorType = 'door',
    fixText = false,
    audioRemote = false,
    authorizedJobs = { ['galaxy'] = 0 },
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
}

-- VIP Area created by Quackers
Config.DoorList['VIP Area'] = {
    distance = 2,
    objName = -1119680854,
    objYaw = 305.59243774414,
    objCoords = vec3(393.943939, 274.673065, 95.152100),
    doorRate = 1.0,
    doorType = 'door',
    fixText = false,
    audioRemote = false,
    authorizedJobs = { ['galaxy'] = 0 },
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
}

-- Boss Area created by Quackers
Config.DoorList['Boss Area'] = {
    distance = 2,
    objName = -1555108147,
    objYaw = 74.592529296875,
    objCoords = vec3(377.781036, 267.767212, 95.139931),
    doorRate = 1.0,
    doorType = 'door',
    fixText = false,
    audioRemote = false,
    authorizedJobs = { ['galaxy'] = 0 },
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
}

-- Upstairs Bar created by Quackers
Config.DoorList['Upstairs Bar'] = {
    distance = 2,
    objName = 1695461688,
    objYaw = 74.592529296875,
    objCoords = vec3(354.450012, 273.708649, 94.356087),
    doorRate = 1.0,
    doorType = 'door',
    fixText = false,
    audioRemote = false,
    authorizedJobs = { ['galaxy'] = 0 },
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
}

-- Security Room created by Quackers
Config.DoorList['Security Room'] = {
    distance = 2,
    objName = 1695461688,
    objYaw = 344.59246826172,
    objCoords = vec3(380.155396, 266.634979, 91.355125),
    doorRate = 1.0,
    doorType = 'door',
    fixText = false,
    audioRemote = false,
    authorizedJobs = { ['galaxy'] = 0 },
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
}

-- X Room created by Quackers
Config.DoorList['X Room'] = {
    doorType = 'double',
    distance = 2,
    doors = {
        {objName = 390840000, objYaw = 74.592529296875, objCoords = vec3(390.173004, 254.886536, 92.219200)},
        {objName = 390840000, objYaw = 254.59246826172, objCoords = vec3(390.864136, 257.391602, 92.219200)}
    },
    authorizedJobs = { ['galaxy'] = 0 },
    doorRate = 1.0,
    audioRemote = false,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
}