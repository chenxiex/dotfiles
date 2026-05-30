-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local display = require("modules.vars.display")
local gamemode = require("modules.vars.gamemode")

--- hidpi
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
hl.env("QT_SCALE_FACTOR", display.scale)
hl.env("GDK_SCALE", math.floor(display.scale+0.5))

--- Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

--- DMS
hl.env("DMS_DANKBAR_LAYER", "bottom")

--- Theming
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME_QT6", "qt6ct")

--- For games
if gamemode then
    hl.env("AQ_DRM_DEVICES", "/dev/dri/nvidia-egpu:/dev/dri/intel-igpu")
    hl.env("WAYLANDDRV_PRIMARY_MONITOR", display.external)
    hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "")
else
    hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu")
    hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/50_mesa.json")
end

--- Input method
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")

--- GSK_RENDERER
hl.env("GSK_RENDERER", "opengl")

--- Programs
hl.env("TERMINAL", "kitty")
