name "Mining"
author "Jimathy"
description "Mining Script By InfinityDevs"
fx_version "cerulean"
game "gta5"

this_is_a_map 'yes'

dependencies {
	'prp-menu',
    'prp-target',
}

client_scripts {
    'client.lua',
    'config.lua',
}

server_script {
    'server.lua',
    'config.lua',
}