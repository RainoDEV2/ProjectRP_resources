fx_version 'cerulean'
game 'gta5'

description 'prp-Spawn'
version '1.0.0'

shared_scripts {
	'@prp-houses/config.lua',
	'@prp-apartments/config.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

server_script 'server.lua'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/reset.css'
}

dependencies {
	'prp-core',
	'prp-houses',
	'prp-interior',
	'prp-apartments'
}