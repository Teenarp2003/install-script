#!/bin/bash

set -e

# Ensure required tools are installed
if ! command -v git &>/dev/null; then
    echo "Error: 'git' is required but not installed. Install it using 'sudo pacman -S git'."
    exit 1
fi

if ! command -v makepkg &>/dev/null; then
    echo "Error: 'base-devel' is required but not installed. Install it using 'sudo pacman -S base-devel'."
    exit 1
fi

# Set up a temporary working directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Clone the yay repository from AUR
echo "Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git
cd yay

# Build and install yay
echo "Building yay..."
makepkg -si --noconfirm

# Clean up
cd ~
rm -rf "$TMP_DIR"

echo "✅ yay has been installed successfully!"
