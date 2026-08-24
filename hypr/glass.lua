if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    local function tint(c, alpha)
        return tonumber(c:match("%x%x%x%x%x%x"), 16) * 256
            + math.floor(alpha * 255 + 0.5)
    end

    hg.config({
        default_theme = "dark",
        default_preset = "glass",
        tint_color = 0x8899aa22,

        brightness = 0.2,
        dark = { brightness = 0.82 },
        light = { adaptive_boost = 0.5 },

        layers = { enabled = true },
    })

    -- Layer surfaces: each call whitelists the namespace and configures it
    hg.layer("waybar", { preset = "subtle", mask_threshold = 0.05 })
    hg.layer("swaync")
    hg.layer("quickshell:bezel", { preset = "ui", mask_threshold = 0.3 })
    hg.layer("debug-panel", { exclude = true })
    -- glass.lua
    hg.layer("wayle-bar-eDP-1",     { preset = "subtle", mask_threshold = 0.05 })
    hg.layer("wayle-bar-HDMI-A-1",  { preset = "subtle", mask_threshold = 0.05 })
    hg.layer("hypr-dock",  { preset = "subtle", mask_threshold = 0.05 })
    hg.layer("dock-popup", { preset = "subtle", mask_threshold = 0.05 })
    hg.layer("rofi", { preset = "glass" })
    -- Presets
    hg.preset("clear", {
        glass_opacity = 0.3,
        blur_strength = 1.5,
        dark = { brightness = 0.7 },
        light = { brightness = 1.2 },
    })

    hg.preset("glass", {
        glass_opacity = 2,
        blur_strength = 3,
        blur_iterations = 0,
        chromatic_aberration = 0.8,
        fresnel_strength = 0.8,
        edge_thickness = 0.08,
        tint_color = tint("1e1e2e", 0.1),
        lens_distortion = 2,
        brightness = 1,
        contrast = 1.1,
        saturation = 1,
        vibrancy = 0.8,
        vibrancy_darkness = 1,
        adaptive_boost = 0.5,
    })

    hg.preset("contrasted", {
        inherits = "high_contrast",
        contrast = 1.2,
        adaptive_dim = 1.5,
        dark = { tint_color = 0x02142aa9 },
    })

end

