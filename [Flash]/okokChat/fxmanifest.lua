fx_version 'adamant'

game 'gta5'

author 'My#2886'
description 'okokChat'

ui_page 'web/ui.html'

files {
	'web/*.*',
}

shared_script 'config.lua'

client_scripts {
	'chat.lua',
	'ooc.lua',
}

server_scripts {
	'server.lua',
	'commands.lua',
}