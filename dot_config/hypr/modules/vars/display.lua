local gamemode = require("modules.vars.gamemode")
local display

display = {
    external = gamemode and "DP-5" or "",
    internal = "eDP-1",
    scale = 1.6,
}
return display