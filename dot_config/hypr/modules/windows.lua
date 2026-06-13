----------------
---- WINDOWS----
----------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

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

-- Fix blur border for XWayland windows. 
hl.window_rule({
    name = "xwayland",
    match = {
        xwayland = true,
    },

    no_blur = true,
})

local function app_tags(match, tags)
	for _,tag in ipairs(tags) do
		hl.window_rule({ match = match, tag = "+" .. tag})
	end
end

app_tags({ xdg_tag = [[^proton-game$]] }, {"float-fullscreen",})
app_tags({ class = [[^QQ$]] }, {"float"})
app_tags({ class = [[^wechat$]] }, {"float"})
app_tags({ class = [[^v2rayN$]] }, {"float"})
app_tags({ class = [[^com.vysp3r.ProtonPlus$]] }, {"float"})
app_tags({ class = [[^org.gnome.Software$]]}, {"float"})
app_tags({ class = [[^eudic$]]}, {"float"})
app_tags({ class = [[^io.missioncenter.MissionCenter$]]}, {"float"})
app_tags({ class = [[^qqmusic$]]}, {"float"})

-- rules for apps

-- Open Orpheus
hl.window_rule({
    name = "open-orpheus",
    match = {
        class = [[^open-orpheus$]],
    },

    float = true,
})

-- Bitwarden
app_tags({ class = [[^Bitwarden$]]}, {"float"})
app_tags({ class = [[.*-nngceckbapebfimnlniiiahkandclblb-Default$]]}, {"float"}) -- Bitwarden browser extension popup

--Betterbird
local betterbird_class = [[^eu.betterbird.Betterbird$]]
app_tags({ class = betterbird_class, initial_title = [[.*Betterbird$]] }, {"background"})
app_tags({ class = betterbird_class, initial_title = [[^日历提醒$]] }, {"float"})

-- v2rayN
hl.window_rule({
    name = "v2rayN",
    match = {
        class = [[^v2rayN$]],
    },

    size = {"monitor_w*0.5", "monitor_h*0.5"},
})

-- Zotero
local zotero_class = [[^org.zotero.Zotero$]]
app_tags({ class = zotero_class }, {"float"})
hl.window_rule({
    name = "zotero-main",
    match = {
        class = zotero_class,
        title = [[.*Zotero$]],
    },

    tag = "-float",
    group = "set",
})

--rules for tags
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

hl.window_rule({
    name = "background",
    match = {
        tag = "background",
    },

    workspace = "special:background silent",
    no_initial_focus = true,
    group = "set"
})

hl.window_rule({
    name = "float",
    match = {
        tag = "float",
    },

    float = true,
	center = true,
})