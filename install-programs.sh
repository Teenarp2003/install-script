#!/bin/bash

# Ensure the script is run with a package list file
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <package-list-file>"
    exit 1
fi

PACKAGE_FILE="$1"

# Check if file exists
if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: File '$PACKAGE_FILE' not found."
    exit 1
fi

# Ensure yay is installed
if ! command -v yay &>/dev/null; then
    echo "Error: 'yay' not found. Please install yay first."
    exit 1
fi

# Read package list and install
while IFS= read -r package || [[ -n "$package" ]]; do
    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^# ]] && continue

    echo "Attempting to install: $package"

    # Try pacman first
    if sudo pacman -Si "$package" &>/dev/null; then
        sudo pacman -S --noconfirm "$package"
    else
        echo "Not in pacman repos, trying yay (AUR)..."
        yay -S --noconfirm "$package"
    fi
done < "$PACKAGE_FILE"
echo "All packages processed."

