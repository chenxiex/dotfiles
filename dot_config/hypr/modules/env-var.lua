-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local display = require("modules.vars.display")
local gamemode = require("modules.vars.gamemode")

--- hidpi
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", math.floor(display.scale+0.5))
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")

--- For games
if gamemode then
    hl.env("AQ_DRM_DEVICES", "/dev/dri/nvidia-egpu:/dev/dri/intel-igpu")
else
    hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu")
end

-- For wine wayland
hl.env("WAYLANDDRV_PRIMARY_MONITOR", display.external)

--- Input method
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")

--- GSK_RENDERER
hl.env("GSK_RENDERER", "opengl")