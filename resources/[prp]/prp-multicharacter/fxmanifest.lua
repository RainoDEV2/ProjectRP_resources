fx_version 'cerulean'
game 'gta5'

description 'prp-Multicharacter'
version '1.0.0'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/script.js',
	'html/in_files/*.png',
}

dependencies {
    'prp-core',
    'prp-spawn'
}