fx_version 'bodacious'

game 'gta5'

description 'GKSPHONE'
version '1.2 FIX 5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/css/*.css',
	'html/js/*.js',
	'html/static/config/config.json',
	-- Coque
	'html/static/img/newtheme/lock/*.png',
	'html/static/img/newtheme/menu/*.png',
	'html/static/img/newtheme/message/*.png',
    -- TEST
	'html/static/img/**/*.jpg',
	'html/static/img/**/*.png',
	'html/static/img/**/*.svg',
	'html/static/sound/*.ogg',
	'html/static/sound/*.mp3',
}

client_script {
	"@mFramework/locale.lua",
	"locales/en.lua",
	"locales/fr.lua",
	"config.lua",
	'html/js/client.js',
	"client/animation.lua",
	"client/client.lua",
	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
	"client/twitter.lua",
	"client/yellow.lua",
	"client/fatura.lua",
	"client/instagram.lua",
	"client/valet.lua",
	"client/client2.lua",
	"client/youtube.lua"
}

server_script {
	"@mysql-async/lib/MySQL.lua",
	"@mFramework/locale.lua",
	"locales/en.lua",
	"locales/fr.lua",
	"config.lua",
	'html/js/config.js',
	'html/js/server.js',
	"server/server.lua",
	"server/app_tchat.lua",
	"server/twitter.lua",
    "server/yellow.lua",
	"server/bank.lua",
	"server/fatura.lua",
	"server/instagram.lua",
	"server/valet.lua",
	"server/server2.lua"
}
