-- Point d'entrée Hyprland
-- Ce fichier ne fait qu'orchestrer les modules

require("monitors")
require("appearance")
require("input")
require("keybinds")
require("autostart")
require("rules")
require("events")
require("glass")

-- HyprMod managed settings
require("hyprland-gui")

-- Couleurs matugen (doit rester après hyprland-gui pour avoir le dernier mot)
require("matugen-colors")
