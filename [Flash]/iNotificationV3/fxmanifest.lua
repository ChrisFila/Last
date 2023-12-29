author 'iMax'

description 'iNotification V3'

fx_version 'adamant'

game 'gta5'

version '3.0.0'

client_scripts {

    "/client/class/*.js",
    "/client/*.js",

}


files {
    "ui/assets/fonts/*.ttf",
    "ui/assets/images/*.*",
    "ui/css/*.css",
    "ui/css/Style.css.map",
    "ui/css/*.scss",
    "ui/js/*.js",
    "ui/index.html",
}

exports {
    "Notification",
    "HelpNotification"
}
ui_page 'ui/index.html'
