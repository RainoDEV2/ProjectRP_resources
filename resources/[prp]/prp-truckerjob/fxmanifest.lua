fx_version 'cerulean'
game 'gta5'

description 'prp-TruckerJob'
version '1.0.0'

shared_scripts { 
	'@prp-core/import.lua',
	'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/gui.lua'
}

server_script 'server/main.lua'