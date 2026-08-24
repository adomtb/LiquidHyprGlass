local mod = "SUPER"

-- Programmes
local terminal   = "kitty"
local browser    = "firefox"
local filemanager = "nautilus"
local launcher   = "rofi -show drun"

-- Applications
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(filemanager))
hl.bind(mod .. " + d",      hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + W", hl.dsp.exec_cmd("waypaper"))


-- Screenshots
hl.bind("PRINT",              hl.dsp.exec_cmd("hyprshot -m output -o ~/Images/Screenshots"))            -- écran entier
hl.bind(mod .." + c" ,      hl.dsp.exec_cmd("hyprshot -m region -o ~/Images/Screenshots"))             -- sélection de zone
hl.bind(mod .. " + PRINT",    hl.dsp.exec_cmd("hyprshot -m window -o ~/Images/Screenshots"))             -- fenêtre active
hl.bind("SHIFT + CTRL + PRINT", hl.dsp.exec_cmd(
    "hyprshot -m region --raw | satty --filename - --output-filename ~/Images/Screenshots/$(date +%Y%m%d-%H%M%S).png"
))                                                                                                        -- sélection + annotation directe



--record
hl.bind(mod .. " + R", hl.dsp.exec_cmd(
    "wf-recorder -f ~/Videos/$(date +%Y%m%d-%H%M%S).mp4"
))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("killall -SIGINT wf-recorder"))



-- Verrouiller manuellement
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Quitter
hl.bind(mod .. " + M",      hl.dsp.exit())


-- Sélecteur de fenêtres ouvertes
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("rofi -show window"))

-- Fenêtres
hl.bind(mod .. " + A",      hl.dsp.window.close())
hl.bind(mod .. " + space",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + P",      hl.dsp.window.pseudo())


-- Focus directionnel
hl.bind(mod .. " + left",   hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right",  hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",     hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",   hl.dsp.focus({ direction = "down" }))

-- Déplacer fenêtres
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Workspaces 1 à 10 (boucle Lua !)

-- Touches AZERTY pour les workspaces (clavier 60%)
local workspace_keys = {
    "ampersand",   -- & = workspace 1
    "eacute",      -- é = workspace 2
    "quotedbl",    -- " = workspace 3
    "apostrophe",  -- ' = workspace 4
    "parenleft",   -- ( = workspace 5
}

for i, key in ipairs(workspace_keys) do
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end


-- Souris
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Scroll workspaces avec molette
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Volume (wpctl, puisque tu es déjà sur pipewire/wireplumber avec wayle)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Luminosité
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Lecture média (playerctl, pour piloter n'importe quel lecteur ouvert : Zen, Spotify, mpv...)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


