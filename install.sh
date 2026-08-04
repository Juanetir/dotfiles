#!/bin/bash

set -e

echo "Installing packages..."

sudo pacman -Syu --needed $(cat packages.txt)

echo "Creating config directories..."

mkdir -p ~/.config

ln -sf ~/dotfiles/hypr ~/.config/hypr
ln -sf ~/dotfiles/waybar ~/.config/waybar
ln -sf ~/dotfiles/kitty ~/.config/kitty
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/mako ~/.config/mako

echo "Enabling services..."

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

echo "Installation finished!"