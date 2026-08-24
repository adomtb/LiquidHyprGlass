-- Variables d'environnement
hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,

        resize_on_border = true,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 0.90,
        inactive_opacity = 0.82,

        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 3,
        },

        blur = {
            enabled  = 0,
            size     = 5,
            passes   = 5,
            vibrancy = 5,
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

-- Courbes Bézier personnalisées
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

-- Animations
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "almostLinear", style = "popin 87%" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
-- Courbe dédiée aux workspaces : snappy mais fluide
hl.curve("workspaceSnap", { type = "bezier", points = { {0.13, 0.99}, {0.22, 1} } })

hl.animation({ leaf = "workspaces",    enabled = true, speed = 5, bezier = "workspaceSnap", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 5, bezier = "workspaceSnap", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, bezier = "workspaceSnap", style = "slide" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })

-- Layouts
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})

hl.config({
    xwayland = { force_zero_scaling = true },
})
