fx_version 'cerulean'
game 'gta5'

description 'prp-Apartments'
version '1.0.0'

shared_script 'config.lua'

server_script 'server/main.lua'

client_scripts {
	'client/main.lua',
	'client/gui.lua'
}

dependencies {
	'prp-core',
	'prp-interior',
	'prp-clothing',
	'prp-weathersync'
}

lua54 'yes'