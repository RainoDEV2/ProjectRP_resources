fx_version 'cerulean'
game 'gta5'

description 'prp-Scoreboard'
version '1.0.0'

ui_page 'html/ui.html'

shared_scripts { 
	'@prp-core/import.lua',
	'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

files {
    'html/*'
}