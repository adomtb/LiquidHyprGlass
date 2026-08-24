hl.on("hyprland.start", function()
    hl.exec_cmd("wayle panel start")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypr-dock")
    hl.exec_cmd("hyprpm reload -n")
    hl.timer(function()
    	hl.exec_cmd("waypaper --restore")
    end, { timeout = 500, type = "oneshot" })


end)
