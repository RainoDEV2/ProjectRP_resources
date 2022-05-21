DetectorConfig = {}

-- display polyzones (green boxes)
DetectorConfig.DebugPoly = false 

-- common trade ped location & ped hash
DetectorConfig.CommonPedLocation = vector4(-1154.11, -1990.46, 13.16, 316.86)
DetectorConfig.CommonPed = 'mp_m_forgery_01'

-- rare trade ped location & ped hash
DetectorConfig.RarePedLocation = vector4(-2085.17, -1017.98, 12.78, 74.19)
DetectorConfig.RarePed = 'mp_m_weapexp_01'

-- the amount of time it takes to detect items. (progressbar)
DetectorConfig.DetectTime = math.random(6000, 10000)

-- if doesnt land on common or rare you get nothing.
-- 70% chance of receiving common item.
DetectorConfig.CommonChance = 70

-- 5% chance of receiving rare item.
DetectorConfig.RareChance = 95

-- The amount of common items received when detected.
DetectorConfig.CommonAmount = math.random(2,4)

-- The amount of rare items received when detected.
DetectorConfig.RareAmount = 1

-- %6 chance of overheating.
DetectorConfig.OverheatChance = 6

-- how long the detecter gets overheated for
DetectorConfig.OverheatTime = math.random(30000, 50000) 

-- list of common items detectable
DetectorConfig.CommonItems = {
    'metaltrash',
    'irontrash',
    'bulletcasings',
    'aluminumcan',
    'steeltrash',
    'brokenknife',
    'brokendetector',
    'brokenphone',
    'housekeys',
}

-- list of rare items detectable
DetectorConfig.RareItems = {
    'burriedtreasure',
    'treasurekey',
    'antiquecoin',
    'goldennugget',
    'goldcoin',
    'ancientcoin',
    'ww2relic',
    'brokengameboy',
    'pocketwatch',
}

-- metal detection zones
DetectorConfig.DetectZones = {
    [1] = {
        label = "PierBeach",
        zones = {
            vector2(-1215.8862304688, -1763.9927978516),
            vector2(-1261.4217529297, -1830.6840820312),
            vector2(-1612.1901855469, -1141.1480712891),
            vector2(-1586.1876220703, -1071.6724853516),
            vector2(-1422.1868896484, -1110.5142822266),
            vector2(-1405.5825195312, -1395.3377685547),
            vector2(-1323.0729980469, -1605.9655761719)
        },
    },
    [2] = {
        label = "PierBeach2",
        zones = {
            vector2(-1679.6752929688, -981.88470458984),
            vector2(-1679.6752929688, -981.88470458984),
            vector2(-1717.31640625, -1063.8728027344),
            vector2(-2113.6811523438, -554.88806152344),
            vector2(-2057.0686035156, -503.62591552734),
            vector2(-1848.9615478516, -657.43768310547),
            vector2(-1752.3885498047, -741.12536621094),
            vector2(-1729.9864501953, -918.60015869141)
        },
    },
    [3] = {
        label = "Golf Course",
        zones = {
            vector2(-1075.5496826172, -145.32153320312),
            vector2(-1324.7716064453, 23.515180587769),
            vector2(-1338.4162597656, 183.1936340332),
            vector2(-1109.5949707031, 219.35273742676),
            vector2(-975.8134765625, -25.266059875488)
        },
    },
}
