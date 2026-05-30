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
        new_render_scheduling = true,
    }
})

-- Performance tweaks
hl.config({
    decoration = {
        blur = {
            enabled = false
        },
        shadow = {
            enabled = false
        }
    }
})