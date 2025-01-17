fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'G.A.S.T. Development - andrejkm'

description 'Ped Menu script for ped spawning',

version 'v1.0.0'

shared_script {
    '@es_extended/imports.lua', 
    '@ox_lib/init.lua',  
    'config.lua',
    'locales/locales.lua'
}

client_script 'client/*.lua'

server_script 'server/*.lua'
