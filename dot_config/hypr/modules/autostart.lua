-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function () 
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)
local gamemode = require("modules.vars.gamemode")
local hyprland_session_target = "hyprland-session.target"
local xdg_autostart_target = "xdg-desktop-autostart.target"
local systemd_session_targets = hyprland_session_target .. " " .. xdg_autostart_target
local devices_func = require("modules.devices")

hl.on("hyprland.start", function ()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("systemctl --user start " .. hyprland_session_target)

  if gamemode then
    hl.exec_cmd("com.heroicgameslauncher.hgl")
  end

  devices_func.persist_touchpad_state()
end)

hl.on("hyprland.shutdown", function()
  hl.exec_cmd("systemctl --user stop " .. systemd_session_targets)
end)
