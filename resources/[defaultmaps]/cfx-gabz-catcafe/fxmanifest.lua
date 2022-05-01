fx_version 'cerulean'
games { 'gta5' }

author 'Gabz'
description 'CatCafe'
version '4.0.0s'

this_is_a_map 'yes'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd',
    'catcafe.lua',
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_catcafe.xml'

files {
    'gabz_catcafe.xml',
}
