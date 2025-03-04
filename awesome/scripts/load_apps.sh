#!/bin/bash

# Output file where the app list will be saved
output_file=~/.config/awesome/launcher/apps.txt

# Clear the output file before appending new data
>"$output_file"

# Loop through all .desktop files in /usr/share/applications
for desktop_file in /usr/share/applications/*.desktop; do
	# Extract the application name (app_name) from the .desktop file
	app_name=$(grep -m 1 "Name=" "$desktop_file" | cut -d= -f2)

	# Extract the launch path (Exec) from the .desktop file
	launch_path=$(grep -m 1 "Exec=" "$desktop_file" | cut -d= -f2)

	# Extract the icon path (Icon) from the .desktop file
	icon_name=$(grep -m 1 "Icon=" "$desktop_file" | cut -d= -f2)

	# If the icon is not an absolute path, look for it in the default icon paths
	if [[ ! "$icon_name" =~ ^/ ]]; then
		icon_path="/usr/share/icons/hicolor/48x48/apps/$icon_name.png"
	else
		icon_path="$icon_name"
	fi

	# Write the extracted data to the output file in the specified format
	echo "$icon_path, $launch_path, $app_name" >>"$output_file"
done

echo "App list has been saved to $output_file."
