fx_version 'cerulean'
game 'gta5'

description 'prp-Taxes'
version '1.0.0'

server_script {
    'server/main.lua',
}
client_script {
    'client/main.lua',
}
shared_scripts {
    'config.lua',
    '@prp-core/import.lua',
}