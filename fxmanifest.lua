fx_version 'cerulean'
game 'gta5'

author 'knox'
description 'S6LA Notification System'
version 'v1'
github 'https://github.com/vexify1337'

shared_scripts {
    'shared/config.lua',
    'shared/bridge.lua'
}

client_scripts {
    'core/client/client.lua'
}

server_scripts {
    'core/server/server.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/assets/**/*',
    'nui/sound.mp3',
    'nui/sound2.mp3'
}

lua54 'yes'

