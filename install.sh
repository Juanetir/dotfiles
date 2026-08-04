#!/bin/bash

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Do not run as root."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing packages..."

for file in "$SCRIPT_DIR"/packages/*.txt; do
    echo "Installing $(basename "$file")..."
    sudo pacman -S --needed - < "$file"
done

echo "Running post-install..."

bash "$SCRIPT_DIR/post-install.sh"

echo "Installation complete!"