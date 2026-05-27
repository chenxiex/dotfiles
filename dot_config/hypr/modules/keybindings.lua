---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("modules.vars.programs")
local display = require("modules.vars.display")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Programs
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(programs.menu))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(programs.clipboard))
hl.bind(mainMod .. " + SHIFT + F23", hl.dsp.exec_cmd(programs.browser))

-- Window management
local closeWindowBind = hl.bind("ALT + F4", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + up", hl.dsp.window.fullscreen({ mode = "maximized", action = "set"}))
hl.bind(mainMod .. " + down", hl.dsp.window.fullscreen({ mode = "maximized", action = "unset" }))
hl.bind(mainMod .. " + left", hl.dsp.window.move({direction = "left"}))
hl.bind(mainMod .. " + right", hl.dsp.window.move({direction = "right"}))
hl.bind(mainMod .. " + SHIFT + F",
    function()
        local mon = hl.get_active_monitor()
        if not mon then return end
        local monitor_w = mon.width * (1 / display.scale)
        local monitor_h = mon.height * (1 / display.scale)
        hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "set" }))
        hl.dispatch(hl.dsp.window.float({ action = "on" }))
        hl.dispatch(hl.dsp.window.center({}))
        hl.dispatch(hl.dsp.window.move({ x = 0, y = 0 }))
        hl.dispatch(hl.dsp.window.resize({ x = monitor_w * 1, y = monitor_h * 1 }))
        hl.dispatch(hl.dsp.window.set_prop({ prop = "border_size", value = 0 }))
        hl.dispatch(hl.dsp.window.set_prop({ prop = "rounding", value = 0 }))
    end
)

-- Move focus with mainMod + H/J/K/L
hl.bind(mainMod .. " + ALT + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = "r~" .. i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "r~" .. i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move focus and windows between workspaces with mainMod + CTRL/SHIFT + left/right
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ workspace = "r-1" }))

-- Move focus and windows between monitors with mainMod + CTRL/SHIFT + H/J/K/L
hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.focus({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.focus({ monitor = "d" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ monitor = "d" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Power management
local function dpms(param)
    hl.timer(
        function()
            hl.dispatch(hl.dsp.dpms(param))
        end, { timeout = 500, type = "oneshot" }
    )
end
hl.bind("CTRL + ALT + W", function()
    dpms({ action = "on" })
end, { locked = true })
hl.bind("CTRL + ALT + S", function()
	hl.dispatch(hl.dsp.exec_cmd("hyprlock"))
    dpms({ action = "off", monitor = display.external })
end, { locked = true })

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))