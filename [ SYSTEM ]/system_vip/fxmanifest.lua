

fx_version 'adamant'
game 'gta5'

ui_page "index.html"

files {"index.html"}

client_scripts {"unique.lua"}

server_scripts {"@vrp/lib/utils.lua", "unique.lua", "server.js"}

client_script "c_gcninject.lua"
server_script "s_gcninject.lua"              