-- events.lua

-- Notifier quand Firefox s'ouvre
hl.on("window.open", function(w)
    if w.class == "firefox" then
        hl.notification.create({
            text    = "Firefox est lancé !",
            timeout = 3000,  -- ms
            color   = "rgb(89b4fa)",
        })
    end
end)


-- Apps qui doivent être toujours 100% opaques
local opaque_apps = {
    ["app.zen_browser.zen"] = true,
    firefox  = true,
    mpv      = true,
    vlc      = true,
}

hl.on("window.active", function(w)
    if opaque_apps[w.class] then
        -- Pleine opacité pour ces apps
        hl.exec_cmd("hyprctl setprop address:" .. w.address .. " alpha 1.0")
    end
end)




-- Fonction utilitaire pour envoyer des notifs
local function notif(titre, message, urgence)
    urgence = urgence or "normal"  -- valeur par défaut
    hl.exec_cmd(
        "notify-send '" .. titre .. "' '" .. message .. "' -u " .. urgence
    )
end

-- Notification au démarrage
hl.on("hyprland.start", function()
    hl.timer(function()
        notif("Hyprland", "Configuration chargée ✓", "low")
    end, { timeout = 2000, type = "oneshot" })
end)


