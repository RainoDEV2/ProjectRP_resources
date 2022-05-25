fx_version 'cerulean'
game 'gta5'

description 'prp-Skillbar'
version '1.0.0'

ui_page "html/index.html"
shared_script '@prp-core/import.lua'
client_script 'client/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

exports {
    'GetSkillbarObject'
}

dependencies {
    'prp-core'
}
