#!/bin/bash
# This script sets up the environment by calling the install-programs.sh script.

# Function to check the success of the last command
check_success() {
    if [[ $? -ne 0 ]]; then
        echo "Error: $1"
        exit 1
    fi
}

# Ensure the install-programs.sh script exists
if [[ ! -f "./install-programs.sh" ]]; then
    echo "Error: install-programs.sh script not found in the current directory."
    exit 1
fi

# Ensure a package list file exists
PACKAGE_LIST_FILE="./package-list.txt"
if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Error: package-list.txt file not found in the current directory."
    exit 1
fi

# Call the install-programs.sh script with the package list file
echo "Running install-programs.sh with $PACKAGE_LIST_FILE..."
bash ./install-programs.sh "$PACKAGE_LIST_FILE"
check_success "install-programs.sh encountered an issue."

# Clone the Git repository
CONFIG_PATH="$HOME/.config"
TEMP_CLONE_DIR="./dotfiles-temp"

if [[ -d "$CONFIG_PATH" ]]; then
    echo "The directory $CONFIG_PATH already exists."
    echo "Cloning the repository into a temporary folder and moving its contents into $CONFIG_PATH..."
    git clone https://github.com/Teenarp2003/dotfiles.git "$TEMP_CLONE_DIR"
    check_success "Failed to clone the Git repository into the temporary folder."

    # Move contents into ~/.config
    cp -r "$TEMP_CLONE_DIR/"* "$CONFIG_PATH"
    check_success "Failed to move the repository contents into $CONFIG_PATH."

    # Clean up the temporary folder
    rm -rf "$TEMP_CLONE_DIR"
    echo "Temporary folder cleaned up."
else
    echo "Cloning Git repository directly into $CONFIG_PATH..."
    git clone https://github.com/Teenarp2003/dotfiles.git "$CONFIG_PATH"
    check_success "Failed to clone the Git repository."
fi

echo "Setup completed successfully."