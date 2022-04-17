resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

files {
    'data/**/handling.meta',
    'data/**/vehicles.meta',
    'data/**/carvariations.meta',
    'data/**/carcols.meta',
    'data/**/vehiclelayouts_cw2019.meta',
    'data/**/vehiclelayouts.meta',
    'data/**/vehicle_names.lua',
}

data_file 'VEHICLE_LAYOUTS_FILE'     'data/**/ vehiclelayouts_cw2019.meta'
data_file 'HANDLING_FILE'            'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE'    'data/**/vehicles.meta'
data_file 'CARCOLS_FILE'             'data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE'   'data/**/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE'     'data/**/vehiclelayouts.meta'

client_script {
    'vehicle_names.lua'
}