----------------
---- WINDOWS----
----------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local display = require("modules.var.display")

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({ match = { xdg_tag = [[^proton-game$]] }, tag = "+float-fullscreen" })

hl.window_rule({
	name = "float-fullscreen",
	match = {
		tag = "float-fullscreen",
	},

	float = true,
	fullscreen_state = "0 2",
	center = true,
	move = {0,0},
	size = {"(monitor_w*1)", "(monitor_h*1)"},
	border_size = 0,
    rounding = 0,
})

hl.window_rule({
	name = "external",
	match = {
		tag = "external",
	},

	monitor = display.external,
})