fx_version 'cerulean'
game 'gta5'

description 'PRP-Prison'
version '1.0.0'

shared_scripts {
	'config.lua'
}

client_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/main.lua',
	'client/jobs.lua',
	'client/prisonbreak.lua'
}

server_script 'server/main.lua'

lua54 'yes'