fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'rdr3'

author 'RMS and Phil Mcracken'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_scripts {
    'config.lua',
}

dependencies {
    'rsg-core',
    'rsg-target',
}