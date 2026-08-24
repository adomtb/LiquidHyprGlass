



-- Empêcher les fenêtres de se maximiser toutes seules
hl.window_rule({
    name          = "suppress-maximize",
    match         = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix drag XWayland
hl.window_rule({
    name        = "fix-xwayland-drag",
    match       = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})


-- Fenêtres de dialogue Thunar (renommage, copie, etc.)
hl.window_rule({
    name  = "thunar-dialogs",
    match = { 
        class = "^thunar$",
        title = "^(Renommer|Rename|Copier|Copy|Déplacer|Move|Supprimer|Delete).*",
    },
    float = true,
    move  = "960 540",
})

hl.window_rule({ match = { class = "^app.zen_browser.zen$" }, tag = "+hyprglass_disabled" })

-- Désactiver la transparence pour Zen Browser
hl.window_rule({
    name    = "zen-no-transparency",
    match   = { class = "^app.zen_browser.zen$" },
    opacity = "1.0 1.0 override",
})

-- Baisser la transparence de VS Code (plus opaque que le réglage global)
hl.window_rule({
    name    = "vscode-less-transparency",
    match   = { class = "^code$" },
    opacity = "0.97 0.92 override",
})


hl.window_rule({
    name  = "waypaper-float",
    match = { class = "^(waypaper)$" },
    float = true,
    move  = "900 450",
    size  = "800 500",
    
})


-- Blur sur waybar
hl.layer_rule({
    name      = "waybar-blur",
    match     = { namespace = "^waybar$" },
    blur      = true,
    
})

-- rules.lua
hl.layer_rule({
    name  = "wayle-blur",
    match = { namespace = "^wayle-bar-.*$" },
    blur  = true,
})

-- Blur sur rofi
hl.layer_rule({
    name  = "rofi-blur",
    match = { namespace = "^rofi$" },
    blur  = true,
})

hl.layer_rule({ name = "dock-blur",   match = { namespace = "^hypr-dock$" },  blur = true })
hl.layer_rule({ name = "dock-blur2",  match = { namespace = "^dock-popup$" }, blur = true })
