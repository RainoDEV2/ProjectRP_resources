fx_version 'cerulean'
game 'gta5'

description 'prp-Jobs'
version '1.0.0'

shared_scripts { 
	'@prp-core/import.lua',
	'config.lua'
}

client_script 'client/*.lua'
server_script 'server/*.lua'
