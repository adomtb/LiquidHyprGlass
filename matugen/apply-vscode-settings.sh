#!/usr/bin/env bash
# Merges the matugen-generated "premium" colors into VS Code's settings.json,
# scoped under the "[Matugen Dynamic Theme]" key so they only apply when that
# theme is selected. This never touches any other setting (theme choice,
# font, other per-theme color overrides like "[Vira*]", etc.) and never does
# a blind overwrite of the file.

set -euo pipefail

generated="$HOME/.config/matugen/generated/vscode-premium-colors.json"
settings="$HOME/.config/Code/User/settings.json"

[ -f "$generated" ] || exit 0
[ -f "$settings" ] || exit 0

tmp="$(mktemp)"
jq --slurpfile gen "$generated" '
  .["workbench.colorCustomizations"]["[Matugen Dynamic Theme]"] = $gen[0].colorCustomizations
  | .["editor.tokenColorCustomizations"]["[Matugen Dynamic Theme]"] = $gen[0].tokenColorCustomizations
' "$settings" > "$tmp" && mv "$tmp" "$settings"
