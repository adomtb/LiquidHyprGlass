-- Moniteur principal (auto-détection)


hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.config({
    xwayland = { force_zero_scaling = true },
})
