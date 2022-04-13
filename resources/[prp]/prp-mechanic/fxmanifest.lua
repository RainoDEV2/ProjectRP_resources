name "PRP-Mechanic"
author "Jimathy"
version "v2.2.1"
description "Mechanic Script By Jimathy"
fx_version "cerulean"
game "gta5"

dependencies {
	'prp-menu',
	'prp-input',
}

shared_scripts {
	'config.lua',
	'client/functions.lua',	
	'locales/*.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

lua54 'yes'

escrow_ignore {
	'*.lua*',
	'client/*.lua*',
	'server/*.lua*',
	'locales/*.lua*',
}
dependency '/assetpacks'