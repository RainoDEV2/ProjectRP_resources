name "Recycle"
author "Jimathy"
description "Recycling Script By Jimathy"
fx_version "cerulean"
game "gta5"

dependencies {
	'prp-menu',
    'prp-target',
}

file 'gen_w_am_metaldetector.ytyp'

client_scripts {
    'client/metaldetector.lua',
    'client/recycle.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua'
}

server_scripts {
    'server/metaldetector.lua',
    'server/recycle.lua',
}

shared_scripts { 
    'shared/recycle_config.lua',
    'shared/metaldetector_config.lua'
}
