-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local gamemode = require("modules.vars.gamemode")

--- hidpi
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")

--- Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("SDL_VIDEO_DRIVER", "wayland")

--- DMS
hl.env("DMS_DANKBAR_LAYER", "bottom")

--- Theming
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_QPA_PLATFORMTHEME_QT6", "gtk3")

--- For games
if gamemode then
    hl.env("AQ_DRM_DEVICES", "/dev/dri/nvidia-egpu:/dev/dri/intel-igpu")
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("WAYLANDDRV_PRIMARY_MONITOR", "DP-5")
else
    hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu")
end

--- Input method
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")

--- GSK_RENDERER
hl.env("GSK_RENDERER", "opengl")

--- Programs
hl.env("TERMINAL", "kitty")
