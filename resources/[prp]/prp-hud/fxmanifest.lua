fx_version 'cerulean'
game 'gta5'

description 'prp-hud'
version '2.1.0'

shared_scripts {
    'locales/en.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'
lua54 'yes'

ui_page 'html/index.html'

files {
	'html/*',
	'html/index.html',
	'html/styles.css',
	'html/responsive.css',
	'html/app.js',
}
