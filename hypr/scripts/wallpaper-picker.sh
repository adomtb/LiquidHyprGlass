#!/usr/bin/env bash
# Sélecteur de fond d'écran avec prévisualisation dans rofi.
#
# - Génère (et met en cache) une miniature par image du dossier
# - Ouvre rofi en grille avec les miniatures en icônes
# - Applique le choix via waypaper, qui pilote hyprpaper et relance
#   matugen grâce à son post_command
#
# Dépendances : rofi, imagemagick (magick), waypaper

set -euo pipefail

WALL_DIR="${WALLPAPER_DIR:-}"
[ -n "$WALL_DIR" ] || WALL_DIR="$HOME/Images/fond d'écran pc"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
THEME="$HOME/.config/rofi/wallpaper.rasi"
THUMB_SIZE="500x500"

notify() { command -v notify-send >/dev/null && notify-send -a "Wallpaper" "$@"; }

mkdir -p "$CACHE_DIR"

# --- Collecte des images (niveau supérieur du dossier uniquement) ----------
mapfile -d '' -t images < <(
    find "$WALL_DIR" -maxdepth 1 -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
           -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.gif' \) \
        -print0 | sort -z
)

if [ "${#images[@]}" -eq 0 ]; then
    notify "Aucune image trouvée dans $WALL_DIR"
    exit 1
fi

# --- Génération des miniatures manquantes ou périmées ---------------------
gen_thumb() {
    local img="$1" hash thumb
    hash=$(printf '%s' "$img" | sha1sum | cut -d' ' -f1)
    thumb="$CACHE_DIR/$hash.png"
    if [ ! -f "$thumb" ] || [ "$img" -nt "$thumb" ]; then
        magick "$img[0]" -auto-orient -strip \
            -thumbnail "${THUMB_SIZE}^" \
            -background none -gravity center -extent "$THUMB_SIZE" \
            "$thumb" 2>/dev/null || true
    fi
}
export -f gen_thumb
export CACHE_DIR THUMB_SIZE

printf '%s\0' "${images[@]}" \
    | xargs -0 -P "$(nproc)" -I{} bash -c 'gen_thumb "$@"' _ {}

# --- Construction du menu rofi ------------------------------------------
menu() {
    local img hash name
    for img in "${images[@]}"; do
        hash=$(printf '%s' "$img" | sha1sum | cut -d' ' -f1)
        name=$(basename "$img")
        printf '%s\0icon\x1f%s\n' "${name%.*}" "$CACHE_DIR/$hash.png"
    done
}

idx=$(menu | rofi -dmenu -i -format 'i' -p "Fond d'écran" -theme "$THEME") || exit 0

[[ "$idx" =~ ^[0-9]+$ ]] || exit 0
selected="${images[$idx]}"

# --- Application ------------------------------------------------------------
waypaper --wallpaper "$selected"
notify "Fond d'écran : $(basename "${selected%.*}")"
