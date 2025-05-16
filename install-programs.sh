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

# Separate packages into two lists: pacman and yay
PACMAN_PACKAGES=()
YAY_PACKAGES=()

while IFS= read -r package || [[ -n "$package" ]]; do
    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^# ]] && continue

    if sudo pacman -Si "$package" &>/dev/null; then
        PACMAN_PACKAGES+=("$package")
    else
        YAY_PACKAGES+=("$package")
    fi
done < "$PACKAGE_FILE"

# Install all pacman packages in one go
if [[ ${#PACMAN_PACKAGES[@]} -gt 0 ]]; then
    echo "Installing packages from Arch official repositories: ${PACMAN_PACKAGES[*]}"
    sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"
else
    echo "No packages to install from Arch official repositories."
fi

# Install all yay packages in one go
if [[ ${#YAY_PACKAGES[@]} -gt 0 ]]; then
    echo "Installing packages from AUR using yay: ${YAY_PACKAGES[*]}"
    yay -S --noconfirm "${YAY_PACKAGES[@]}"
else
    echo "No packages to install from AUR."
fi

echo "All packages processed."

