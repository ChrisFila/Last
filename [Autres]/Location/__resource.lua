resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "client.lua",
    "config.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua",
    "config.lua"
}

ui_page "ui/index.html"
files {
    'ui/index.html',
    'ui/index.js',
    'ui/index.css',
    'ui/reset.css',
    'ui/Bolgart.ttf',
    'img/*.png'
}
