--------------------
---- WORKSPACES ----
--------------------

-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local display = require("modules.vars.display")

-- Group workspace for monitors
local function bind_workspace_range(first, last, monitor, default_ws)
    for ws = first, last do
        hl.workspace_rule({
            workspace = tostring(ws),
            monitor = monitor,
            persistent = true,
            default = (ws == default_ws),
        })
    end
end

bind_workspace_range(1, 5, display.external, 1)