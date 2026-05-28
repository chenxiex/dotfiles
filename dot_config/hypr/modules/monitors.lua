------------------
---- MONITORS ----
------------------

local display = require("modules.vars.display")
local gamemode = require("modules.vars.gamemode")

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
if gamemode then
    hl.monitor({
        output   = display.external,
        mode     = "preferred",
        position = "auto",
        scale    = display.scale,
        bitdepth = 10,
        cm = "srgb",
    })
    hl.monitor({
        output   = display.internal,
        mode     = "preferred",
        position = "auto-center-down",
        scale    = display.scale,
        cm = "edid",
        vrr = 1,
    })
    hl.monitor({
        output = "",
        disabled = true,
    })
else
    require("monitors")
end