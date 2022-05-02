fx_version 'cerulean'

game 'gta5'
lua54 'yes'

description 'Keybased labs for ProjectRP'

dependencies {
    'prp-target'
}

client_scripts {
    'client/cl_*.lua'
}

shared_script {
    'shared/sh_*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/sv_druglabs.lua',
    'server/sv_moneywash.lua',
    'server/sv_weaponbunker.lua'
}