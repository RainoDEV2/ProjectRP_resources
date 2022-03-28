fx_version 'cerulean'
game 'gta5'

description 'prp-fuel'
version '1.3'
author 'github.com/loljoshie'

client_scripts {
    '@PolyZone/client.lua',
	'client/client.lua',
	'client/utils.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
	'@prp-core/shared/locale.lua',
	'shared/config.lua',
}

exports {
	'GetFuel',
	'SetFuel'
}

lua54 'yes'