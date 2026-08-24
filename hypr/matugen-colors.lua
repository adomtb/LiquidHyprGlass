-- Applique les couleurs matugen en dernier, après le fichier géré par
-- HyprMod (hyprland-gui.lua), qui sinon écrase col.active_border /
-- col.inactive_border avec ses propres valeurs codées en dur.
local colors = require("colors")

hl.config({
    general = {
        col = {
            active_border   = colors.active_border,
            inactive_border = colors.inactive_border,
        },
    },
    decoration = {
        shadow = {
            color = colors.shadow_color,
        },
    },
    misc = {
        background_color = colors.background,
    },
})
