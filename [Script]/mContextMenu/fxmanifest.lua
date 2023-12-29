fx_version "adamant"
game "gta5"
lua54 "on"
client_scripts {
	"imput-nui/client.lua",
    'build.lua',
    "config.lua",
	"contextmenu/Drawables/*.lua",
	"contextmenu/Menu/*.lua",
	"contextmenu/*.lua",
	"event/client.lua",
	"client/*.lua",
	'menu/*.lua',
}

shared_scripts {
    "perm.lua",
}

server_scripts {
	"event/server.lua",
}

ui_page "imput-nui/ui/ui.html"

files {
	"imput-nui/ui/*.css",
	"imput-nui/ui/*.js",
	"imput-nui/ui/*.html"
}


exports {
	"Show",
	"ShowSync",
	"IsVisible",
	"Hide"
}

escrow_ignore {
	"perm.lua",
	"menu/*lua",
	"client/*.lua",
	"exemple.lua",
}