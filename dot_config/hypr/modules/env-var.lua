-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local display = require("modules.vars.display")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GDK_SCALE", display.scale)

hl.env("AQ_DRM_DEVICES", "/dev/dri/nvidia-egpu:/dev/dri/intel-igpu")

hl.env("XMODIFIERS", "@im=ibus")

-- For wine wayland
hl.env("WAYLANDDRV_PRIMARY_MONITOR", display.external)