fx_version 'cerulean'
game 'gta5'

description 'prp-Houses'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'

client_scripts {
	'client/main.lua',
	'client/gui.lua',
	'client/decorate.lua'
}

server_script 'server/main.lua'

files {
	'html/index.html',
	'html/reset.css',
	'html/style.css',
	'html/script.js',
	'html/img/dynasty8-logo.png'
}

dependencies {
	'prp-core',
	'prp-interior',
	'prp-clothing',
	'prp-weathersync'
}