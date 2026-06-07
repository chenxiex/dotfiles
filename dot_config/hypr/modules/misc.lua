-- unscale XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})

-- disable auto hdr
hl.config({
    render = {
        cm_auto_hdr = 0,
    }
})

-- Performance tweaks
hl.config({
    decoration = {
        blur = {
            enabled = false
        },
    }
})

-- Fix some popup windows disappearing when they lose focus.
hl.config({
    input = {
        follow_mouse = 2,
        float_switch_override_focus = 0,
    },
})

-- Focus on activate
hl.config({
    misc = {
        focus_on_activate = true
    }
})

-- Group bar configuration
hl.config({
    group = {
        groupbar = {
            gradients = true,
            font_size = 15,
        }
    }
})