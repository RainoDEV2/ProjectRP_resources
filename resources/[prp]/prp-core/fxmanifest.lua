fx_version 'cerulean'
game 'gta5'

description 'prp-Core'
version '1.0.0'

shared_scripts {
	'import.lua',
	'config.lua',
	'shared.lua',
	'vehicles.lua',
}

client_scripts {
	'client/main.lua',
	'client/functions.lua',
	'client/loops.lua',
	'client/events.lua',
	'client/drawtext.lua'
}

server_scripts {
	'server/main.lua',
	'server/functions.lua',
	'server/player.lua',
	'server/events.lua',
	'server/commands.lua',
	'server/debug.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/*.js'
}

dependencies {
	'oxmysql',
	'progressbar',
	'connectqueue'
}

lua54 'yes'