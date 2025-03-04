#!/bin/bash

# Set the directory containing wallpapers
wallpaper_dir="$HOME/Pictures/wallpaper"

# Set the output file
output_file="$HOME/.config/awesome/launcher/walls.txt"

# Find all image files (jpg, png, jpeg, gif, bmp) in the wallpaper directory
# Adjust the extensions if you have other formats
find "$wallpaper_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) >"$output_file"

# Confirm the output
if [ -f "$output_file" ]; then
	echo "List of wallpapers saved to $output_file"
else
	echo "Failed to create the wallpaper list."
fi
