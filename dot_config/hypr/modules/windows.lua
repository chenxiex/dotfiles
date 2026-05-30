----------------
---- WINDOWS----
----------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local display = require("modules.vars.display")

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

local function app_tags(match, tags)
	for _,tag in ipairs(tags) do
		hl.window_rule({ match = match, tag = "+" .. tag})
	end
end

app_tags({ xdg_tag = [[^proton-game$]] }, {"float-fullscreen",})
app_tags({ class = [[^eu.betterbird.Betterbird$]], initial_title = [[^Betterbird$]] }, {"background"})
app_tags({ class = [[^QQ$]] }, {"float"})
app_tags({ class = [[^wechat$]] }, {"float"})
app_tags({ class = [[^v2rayN$]] }, {"float"})
app_tags({ class = [[^com.vysp3r.ProtonPlus$]] }, {"float"})
app_tags({ class = [[^org.gnome.Software$]]}, {"float"})
app_tags({ class = [[^Bitwarden$]]}, {"float"})

hl.window_rule({
	name = "float-fullscreen",
	match = {
		tag = "float-fullscreen",
	},

	float = true,
	fullscreen_state = "0 2",
	move = {0,0},
	size = {"(monitor_w*1)", "(monitor_h*1)"},
	border_size = 0,
    rounding = 0,
})

local background_workspace = {"background"}
for _, name in ipairs(background_workspace) do
    hl.window_rule({
        name = name,
        match = {
            tag = name,
        },

        workspace = "special:" .. name .. " silent",
        no_initial_focus = true,
        group = "set"
    })
end

hl.window_rule({
    name = "float",
    match = {
        tag = "float",
    },

    float = true,
	center = true,
})

-- Fix blur border for XWayland windows. 
hl.window_rule({
    name = "xwayland",
    match = {
        xwayland = true,
    },

    no_blur = true,
})
