#!/bin/bash

# Ensure the script is run with a package list file
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <package-list-file>"
    exit 1
fi

PACKAGE_FILE="package-list.txt"

# Check if file exists
if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: File '$PACKAGE_FILE' not found."
    exit 1
fi

# Ensure yay is installed
if ! command -v yay &>/dev/null; then
    echo "'yay' not found. Attempting to install yay..."
    if [[ -f "./install-yay.sh" ]]; then
        bash ./install-yay.sh
        if ! command -v yay &>/dev/null; then
            echo "Error: Failed to install yay. Please install it manually."
            exit 1
        fi
    else
        echo "Error: 'install-yay.sh' script not found. Cannot proceed."
        exit 1
    fi
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

