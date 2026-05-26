local gamemode = require("modules.vars.gamemode")
local display

display = {
    external = gamemode and "DP-5" or "DP-3",
    internal = "eDP-1",
    scale = 1.6,
}
return display