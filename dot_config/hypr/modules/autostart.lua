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
hl.on("hyprland.start", function () 
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("copyq --start-server")
  hl.exec_cmd("/usr/bin/fcitx5")
  hl.exec_cmd("systemctl --user start hyprland-session.target")

  hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')

  if gamemode then
    hl.exec_cmd("com.heroicgameslauncher.hgl")
  end
end)