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
hl.on("hyprland.start", function () 
  hl.exec_cmd("waybar")
  hl.exec_cmd("ibus start --type=wayland")
  hl.exec_cmd("copyq --start-server")
  hl.exec_cmd("com.heroicgameslauncher.hgl")
  hl.exec_cmd("hyprpaper")

  hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
end)