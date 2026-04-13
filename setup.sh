
#!/bin/bash

DOTS="$HOME/dots-files"
HYPR_SRC="$DOTS/hypr"
HYPR_DST="$HOME/.config/hypr"
STARSHIP_SRC="$DOTS/starship/starship.toml"
STARSHIP_DST="$HOME/.config/starship.toml"
ZSH_SRC="$DOTS/zsh-conf/dots-zshrc"
ZSH_DST="$HOME/.zshrc"
BG_SRC="$DOTS/backgrounds"
BG_DST="$HOME/.config/omarchy/themes/blackturq/backgrounds"

# loading bar animation
loading_bar() {
    local pid=$!
    local width=30
    local progress=0

    printf "["
    while kill -0 $pid 2>/dev/null; do
        if (( progress < width )); then
            printf "█"
            progress=$((progress + 1))
        else
            printf "\r["
            progress=0
        fi
        sleep 0.1
    done

    while (( progress < width )); do
        printf "█"
        progress=$((progress + 1))
    done

    printf "] ✓\n"
}

confirm_and_copy() {
    local SRC="$1"
    local DST="$2"

    if [[ ! -f "$SRC" ]]; then
        echo "file not found: $SRC"
        return
    fi

    if [[ "$AUTO_YES" == "true" ]]; then
        (
            mkdir -p "$(dirname "$DST")"
            cp -f "$SRC" "$DST"
        ) & loading_bar
        return
    fi

    echo "replace $(basename "$DST") ? (y/n/yes)"
    read -r OPT

    if [[ "$OPT" == "yes" ]]; then
        AUTO_YES="true"
        (
            mkdir -p "$(dirname "$DST")"
            cp -f "$SRC" "$DST"
        ) & loading_bar
    elif [[ "$OPT" == "y" ]]; then
        (
            mkdir -p "$(dirname "$DST")"
            cp -f "$SRC" "$DST"
        ) & loading_bar
    else
        echo "skipped."
    fi
}

echo "███████████████████████████████████" 
echo "  █████Dotfiles Setup Script█████  "
echo "███████████████████████████████████"
echo ""

echo "Acessing directory..."
sleep 0.5

# Hyprland configs
for file in "$HYPR_SRC"/*; do
    BASENAME=$(basename "$file")
    confirm_and_copy "$file" "$HYPR_DST/$BASENAME"
done

# Starship
confirm_and_copy "$STARSHIP_SRC" "$STARSHIP_DST"

# ZSH
confirm_and_copy "$ZSH_SRC" "$ZSH_DST"

# Background
for file in "$BG_SRC"/*; do
    BASENAME=$(basename "$file")
    confirm_and_copy "$file" "$BG_DST/$BASENAME"
done

echo ""
echo "all tasks finished."




































































































