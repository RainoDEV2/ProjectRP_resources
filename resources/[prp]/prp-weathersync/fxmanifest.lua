fx_version 'bodacious'
game 'gta5'

description 'vSyncRevamped'
version '1.0.2'

shared_scripts { 
	'@prp-core/import.lua',
	'config.lua',
	'locale.lua',
	'locales/*.lua'
}

server_scripts {
	'server/server.lua'
}

client_scripts {
	'client/client.lua'
}
