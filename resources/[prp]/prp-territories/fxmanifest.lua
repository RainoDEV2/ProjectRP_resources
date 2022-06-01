fx_version 'cerulean'
game 'gta5'

shared_scripts { 
	'shared/*.lua',
	'@prp-core/shared/locale.lua',
	'locales/en.lua', --change language here
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/CircleZone.lua',
	'client/main.lua',
	'client/warmenu.lua',
	'client/fonts.lua',
	'client/determinant.lua',
	'client/raycast.lua',
	'client/spray.lua',
	'client/spray_rotation.lua',
	'client/control.lua',
	'client/remove.lua',
	'client/time.lua',
	'client/cancellable_progress.lua',
}

server_scripts {
	'server/main.lua',
    '@oxmysql/lib/MySQL.lua',
	'server/spray.lua',
	'server/remove.lua',
}
