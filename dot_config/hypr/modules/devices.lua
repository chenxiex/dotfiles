local devices = {
    touchpad = "elan07ed:00-04f3:32ed-touchpad",
}
local devices_func = {}

devices_func.get_touchpad_state = function()
    local f = io.open(os.getenv("HOME") .. "/.local/state/touchpad_enabled", "r")
    if f then
        local state = f:read("*all")
        f:close()
        return state == "true"
    else
        return nil
    end
end
devices_func.set_touchpad_state = function(enabled)
    hl.device({ name = devices.touchpad, enabled = enabled })
    local f = io.open(os.getenv("HOME") .. "/.local/state/touchpad_enabled", "w")
    if f then
        f:write(enabled and "true" or "false")
        f:close()
    end
end
devices_func.toggle_touchpad = function()
    local state = devices_func.get_touchpad_state()
    if state == true then
        devices_func.set_touchpad_state(false)
    else
        devices_func.set_touchpad_state(true)
    end
end
devices_func.persist_touchpad_state = function()
    local state = devices_func.get_touchpad_state()
    if state ~= nil then
        devices_func.set_touchpad_state(state)
    else
        devices_func.set_touchpad_state(true)
    end
end

return devices_func
