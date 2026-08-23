hl.gesture({
    fingers = 4, direction = "pinch", action = function() hl.exec_cmd("dms ipc call spotlight toggle") end
})
hl.gesture({
    fingers = 4, direction = "up", action = function() hl.exec_cmd("dms ipc call hypr toggleOverview") end
})
