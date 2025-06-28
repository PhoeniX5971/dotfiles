#!/bin/bash

# Check if a wallpaper path is provided
if [ -z "$1" ]; then
	echo "Usage: $0 /path/to/wallpaper"
	exit 1
fi

# Variables
NEW_WALLPAPER="$1"
THEME_DIR="$HOME/.config/awesome/theme"
SCRIPT_DIR="$HOME/.config/awesome/scripts"
DOTFILES_HYPR_DIR="$HOME/.config/awesome"

# Find the current wallpaper file (assumes a single wallpaper file exists)
CURRENT_WALLPAPER=$(find "$THEME_DIR" -type f -name 'wallpaper.*')

# Exit if no wallpaper is found
if [ -z "$CURRENT_WALLPAPER" ]; then
	echo "No existing wallpaper found in $THEME_DIR."
	exit 1
fi

# Extract the extension of the current wallpaper
EXTENSION="${CURRENT_WALLPAPER##*.}"

# Remove the old wallpaper
rm "$CURRENT_WALLPAPER"
echo "Removed old wallpaper: $CURRENT_WALLPAPER"

# Copy the new wallpaper to the theme directory with the same extension
NEW_WALLPAPER_PATH="$THEME_DIR/wallpaper.$EXTENSION"
cp "$NEW_WALLPAPER" "$NEW_WALLPAPER_PATH"
echo "New wallpaper set: $NEW_WALLPAPER_PATH"

# Apply the new wallpaper using waypaper
waypaper --wallpaper "$NEW_WALLPAPER"
echo "Waypaper command executed."

# Apply the new wallpaper using the python script
python3 "$DOTFILES_HYPR_DIR/scripts/wallpaper.py" --image "$NEW_WALLPAPER"
echo "Hyprland wallpaper script executed."

# Run the AwesomeWM theme script
bash "$SCRIPT_DIR/theme.sh"
echo "AwesomeWM theme script executed."

awesome-client 'awesome.restart()'
