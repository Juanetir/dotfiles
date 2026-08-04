#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating configuration directories..."

mkdir -p "$HOME/.config"

for dir in hypr waybar kitty nvim mako; do
    ln -sfn "$SCRIPT_DIR/$dir" "$HOME/.config/$dir"
done

mkdir -p "$HOME/Pictures"
ln -sfn "$SCRIPT_DIR/wallpapers" "$HOME/Pictures/Wallpapers"

echo "Enabling services..."

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

echo "Done!"