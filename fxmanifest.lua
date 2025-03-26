fx_version 'cerulean'
game 'gta5'

author 'Br3ndino'
description 'Cheese Making Script for FiveM'
version '0.0.1'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'qb-target', -- If using qb-target for interactions
    'ox_lib' -- Optional, if you're using ox-lib for crafting menus
}

-- Ensuring that the resource is only loaded if necessary
-- for example, if ox_lib or qb-target are used in this script