client_script "@GroveRP-errorlog/client/cl_errorlog.lua"

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'index.html'

files {
  "index.html",
  "scripts.js",
  "css/style.css",
  "@GroveRP-inventory/nui/icons/*.png"
}
client_script {
  "client.lua",
}


server_script "server.lua"

exports {
  "Toast",
  "NotifyHelp",
  "StateHelp",
  "AddDialog"
}