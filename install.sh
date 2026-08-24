#!/usr/bin/env bash
#
# install.sh — reinstalle la stack hyprglass (Hyprland + wayle + hypr-dock +
# kitty + zsh + rofi + waybar + matugen + ...) sur une installation Arch
# Linux fraîche, à partir de ce repo.
#
# Usage :
#   git clone <url-du-repo> ~/liquid_hyprglass
#   cd ~/liquid_hyprglass
#   ./install.sh
#
# Le script est idempotent : le relancer ne casse rien s'il a déjà tourné.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(id -u)" -eq 0 ]; then
    echo "Ne pas lancer ce script en root — il utilise sudo au besoin." >&2
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    echo "Ce script est prévu pour Arch Linux (pacman introuvable)." >&2
    exit 1
fi

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }

# ---------------------------------------------------------------------------
# 1. Dépôts pacman (chaotic-aur + gh0stzk-dotfiles)
# ---------------------------------------------------------------------------
log "Configuration des dépôts pacman"

if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm \
        'https://cdn-mirror.chaotic.cf/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
        'https://cdn-mirror.chaotic.cf/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    sudo tee -a /etc/pacman.conf >/dev/null <<'EOF'

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
else
    echo "chaotic-aur déjà configuré, on passe."
fi

if ! grep -q '^\[gh0stzk-dotfiles\]' /etc/pacman.conf; then
    sudo tee -a /etc/pacman.conf >/dev/null <<'EOF'

[gh0stzk-dotfiles]
SigLevel = Optional TrustAll
Server = http://gh0stzk.github.io/pkgs/x86_64
EOF
else
    echo "gh0stzk-dotfiles déjà configuré, on passe."
fi

sudo pacman -Syu --noconfirm

# ---------------------------------------------------------------------------
# 2. yay (helper AUR)
# ---------------------------------------------------------------------------
log "Installation de yay"

sudo pacman -S --needed --noconfirm base-devel git

if ! command -v yay >/dev/null 2>&1; then
    tmpdir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
else
    echo "yay déjà installé, on passe."
fi

# ---------------------------------------------------------------------------
# 3. Paquets de la stack hyprglass
# ---------------------------------------------------------------------------
log "Installation des paquets"

PACKAGES=(
    # Compositeur
    hyprland
    hyprpaper

    # Barre / dock / réglages / lanceur (yay résout aussi les dépendances
    # python-hyprland-* de hyprmod automatiquement)
    wayle-bin
    hypr-dock
    hyprmod
    rofi
    waybar

    # Terminal / shell
    kitty
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    fzf-tab-git
    fzf
    eza
    bat
    fastfetch

    # Wallpaper / couleurs dynamiques
    waypaper-git
    matugen

    # Captures d'écran / enregistrement
    hyprshot
    satty
    wf-recorder

    # Médias / contrôle système
    playerctl
    brightnessctl
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    networkmanager
    bluez
    bluez-utils

    # Notifications / presse-papiers
    dunst
    libnotify
    clipcat
    wl-clipboard
    xclip

    # Applications
    nautilus
    firefox
    geany
    ncmpcpp

    # Polices
    noto-fonts
    noto-fonts-emoji
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    ttf-terminus-nerd
    ttf-ubuntu-mono-nerd
    otf-atkinsonhyperlegiblemono-nerd
    ttf-dejavu
    ttf-inconsolata
    ttf-twemoji

    # Build du plugin hyprglass via hyprpm
    cmake
    meson
    ninja
    cpio
    pkgconf
)

yay -S --needed --noconfirm "${PACKAGES[@]}"

# ---------------------------------------------------------------------------
# 4. Plugin hyprglass (via hyprpm)
# ---------------------------------------------------------------------------
log "Installation du plugin hyprglass"

hyprpm update
if ! hyprpm list 2>/dev/null | grep -q hyprglass; then
    hyprpm add https://github.com/hyprnux/hyprglass
fi
hyprpm enable hyprglass

# ---------------------------------------------------------------------------
# 5. Déploiement de la config (symlinks vers ce repo)
# ---------------------------------------------------------------------------
log "Déploiement de la config dans ~/.config"

link_dir() {
    local name="$1"
    local target="$HOME/.config/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
        echo "Config existante déplacée -> $target.bak.*"
    fi
    ln -sfn "$REPO_DIR/$name" "$target"
    echo "$name -> $target"
}

for dir in hypr hypr-dock kitty matugen rofi waybar wayle waypaper fastfetch; do
    link_dir "$dir"
done

mkdir -p "$HOME/.local/bin" "$HOME/.local/share"

if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
fi
ln -sfn "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sfn "$REPO_DIR/zsh/colorscript" "$HOME/.local/bin/colorscript"
ln -sfn "$REPO_DIR/zsh/asciiart" "$HOME/.local/share/asciiart"

mkdir -p "$HOME/.config/zsh"

# ---------------------------------------------------------------------------
# 6. Shell par défaut et services
# ---------------------------------------------------------------------------
log "zsh comme shell par défaut"
sudo chsh -s /usr/bin/zsh "$USER"

log "Activation des services système"
sudo systemctl enable --now NetworkManager bluetooth

log "Terminé."
cat <<'EOF'

Prochaines étapes manuelles :
  - Se déconnecter / redémarrer, puis choisir la session "Hyprland" au login.
  - Adapter la ville météo dans wayle/config.toml (placeholder: "Paris").
  - Lancer `waypaper` pour choisir un fond d'écran (matugen régénère les couleurs).

EOF
