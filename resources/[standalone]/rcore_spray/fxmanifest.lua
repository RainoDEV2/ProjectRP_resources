fx_version 'bodacious'
game 'gta5'

description 'rcore spray'

client_scripts {
	'config.lua',
	'client/warmenu.lua',
	'client/fonts.lua',
	'client/determinant.lua',
	'client/raycast.lua',
	'client/client.lua',
	'client/spray_rotation.lua',
	'client/control.lua',
	'client/remove.lua',
	'client/time.lua',
	'client/cancellable_progress.lua',
}

server_scripts {
	'config.lua',
    '@oxmysql/lib/MySQL.lua',
	'server/server.lua',
	'server/remove.lua',
}
