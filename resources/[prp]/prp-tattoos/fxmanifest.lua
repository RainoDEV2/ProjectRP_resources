fx_version 'cerulean'

game 'gta5'

description 'Mx Tattoos'

version '2.0'

ui_page 'html/index.html'

shared_script { 
    '@prp-core/shared.lua'
}

server_scripts {
    'server/*'
}

client_scripts {
    'client/*'
}

files {
	'html/index.html',
	'html/css/*.css',
	'html/js/*.js',
	'html/img/*.png',
}

dependency 'prp-core'