fx_version "cerulean"
game "gta5"
version "2.0.4"
lua54 "yes"

shared_script "config/*.lua"
client_script {
    "client/**.lua"
}
server_script {
    "@mysql-async/lib/MySQL.lua",
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
    "escrow/server.lua"
}

dependency {
    "loaf_lib"
    -- "VehicleDeformation" -- https://github.com/Kiminaze/VehicleDeformation
}

escrow_ignore {
    "config/*.lua",
    
    "client/*.lua",
    "client/**.lua",

    "server/*.lua",
}
dependency '/assetpacks'