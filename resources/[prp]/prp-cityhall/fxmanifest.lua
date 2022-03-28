fx_version 'cerulean'
game 'gta5'

description 'prp-CityHall'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts { 
	'@prp-core/import.lua',
	'config.lua'
}

server_script 'server/main.lua'
client_script 'client/main.lua'

files {
    'html/*.js',
    'html/*.html',
    'html/*.css'
}