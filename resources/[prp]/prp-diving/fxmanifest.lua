fx_version 'cerulean'
game 'gta5'

description 'prp-Diving'
version '1.0.0'

shared_script 'config.lua'

server_scripts {
	'server/main.lua',
    'server/diving.lua'
}

client_scripts {
    'client/main.lua',
    'client/boatshop.lua',
    'client/diving.lua',
    'client/garage.lua',
    'client/gui.lua',
    'client/shop.lua'
}