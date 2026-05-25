local gamemode = require("modules.vars.gamemode")
local display

if gamemode then
    display = {
        external = "DP-5",
        internal = "eDP-1",
        scale = 2,
    }
else
    display = {
        external = "DP-3",
        internal = "eDP-1",
        scale = 2,
    }
end
return display