hl.config({
    input = {
        kb_layout    = "fr",
        kb_variant   = "azerty",
        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
            tap_to_click   = true,
        },
    },
})

-- Geste trackpad 3 doigts horizontal = changer workspace
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
