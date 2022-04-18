fx_version 'cerulean'
game 'gta5'

description 'prp-burgershot'

ui_page {'html/index.html'}

client_scripts {
    'config.lua',
    'client/client.lua',
}

server_scripts {
    'config.lua',
    'server/server.lua'
}

exports {
    'GetActiveRegister',
}

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js',
}