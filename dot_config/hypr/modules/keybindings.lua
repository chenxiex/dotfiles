---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("modules.vars.programs")
local devices_func = require("modules.devices")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local pseudoFullscreenStates = {}

local function get_window_key(win)
    local key = win.stable_id or win.address
    if not key then return nil end
    return tostring(key)
end

local function get_xy(value)
    if type(value) ~= "table" then return nil end
    return {
        x = value.x or value[1] or 0,
        y = value.y or value[2] or 0,
    }
end

local function get_window_state(win)
    return {
        floating = win.floating == true,
        fullscreen = win.fullscreen or 0,
        fullscreen_client = win.fullscreen_client or 0,
        at = get_xy(win.at),
        size = get_xy(win.size),
    }
end

local function is_pseudo_fullscreen(state)
    return state.fullscreen == 0 and state.fullscreen_client == 2
end

local function set_pseudo_fullscreen()
    local mon = hl.get_active_monitor()
    if not mon then return end
    local monitor_w = mon.width * (1 / mon.scale)
    local monitor_h = mon.height * (1 / mon.scale)
    local monitor_x = mon.x
    local monitor_y = mon.y
    hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "set" }))
    hl.dispatch(hl.dsp.window.float({ action = "on" }))
    hl.dispatch(hl.dsp.window.set_prop({ prop = "border_size", value = 0 }))
    hl.dispatch(hl.dsp.window.set_prop({ prop = "rounding", value = 0 }))
    for _ = 1, 3 do
        hl.dispatch(hl.dsp.window.move({ x = monitor_x, y = monitor_y }))
        hl.dispatch(hl.dsp.window.resize({ x = monitor_w * 1, y = monitor_h * 1 }))
    end
end

local function restore_from_pseudo_fullscreen(state)
    local border_size = hl.get_config("general.border_size")
    local rounding = hl.get_config("decoration.rounding")

    hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "unset" }))
    hl.dispatch(hl.dsp.window.set_prop({ prop = "border_size", value = border_size }))
    hl.dispatch(hl.dsp.window.set_prop({ prop = "rounding", value = rounding }))

    if not state then
        hl.dispatch(hl.dsp.window.float({ action = "off" }))
        return
    end

    if state.floating then
        hl.dispatch(hl.dsp.window.float({ action = "on" }))
        if state.at then
            hl.dispatch(hl.dsp.window.move({ x = state.at.x, y = state.at.y }))
        end
        if state.size then
            hl.dispatch(hl.dsp.window.resize({ x = state.size.x, y = state.size.y }))
        end
    else
        hl.dispatch(hl.dsp.window.float({ action = "off" }))
    end

    if state.fullscreen ~= 0 or state.fullscreen_client ~= 0 then
        hl.dispatch(hl.dsp.window.fullscreen_state({
            internal = state.fullscreen,
            client = state.fullscreen_client,
            action = "set",
        }))
    end
end

-- Programs
hl.bind(mainMod .. " + SHIFT + F23", hl.dsp.exec_cmd(programs.browser))

-- Window management
hl.bind(mainMod .. " + ALT + F",
    function()
        local win = hl.get_active_window()
        if not win then return end

        local key = get_window_key(win)
        if not key then return end
        local state = get_window_state(win)

        if is_pseudo_fullscreen(state) then
            restore_from_pseudo_fullscreen(pseudoFullscreenStates[key])
            pseudoFullscreenStates[key] = nil
        else
            pseudoFullscreenStates[key] = state
            set_pseudo_fullscreen()
        end
    end
)

-- Groups
-- hl.bind("ALT + TAB", hl.dsp.group.next())
-- hl.bind("ALT + SHIFT + TAB", hl.dsp.group.prev())

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Devices
hl.bind("SUPER + CTRL + SHIFT + ALT + SPACE", devices_func.toggle_touchpad)

-- Power management
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd("dms dpms on"), { locked = true })
hl.bind("CTRL + ALT + S", function()
    hl.dispatch(hl.dsp.exec_cmd(programs.lock))
    hl.dispatch(hl.dsp.exec_cmd("dms dpms off"))
end, { locked = true })
