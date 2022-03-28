fx_version 'cerulean'
game 'gta5'

description 'prp-VehicleSales'
version '1.1.0'

ui_page 'html/ui.html'

shared_scripts { 
	'@prp-core/import.lua',
	'config.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'

files {
	'html/reset.css',
	'html/logo.svg',
	'html/ui.css',
	'html/ui.html',
	'html/vue.min.js',
	'html/ui.js',
}
