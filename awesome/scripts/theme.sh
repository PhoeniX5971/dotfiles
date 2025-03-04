#!/bin/bash

# Paths to the necessary files
COLOR_FILE="$HOME/.cache/material/colors.json"
THEME_FILE="$HOME/.config/awesome/theme/theme.lua"

# Check if the color file exists
if [ ! -f "$COLOR_FILE" ]; then
	echo "Color file does not exist: $COLOR_FILE"
	exit 1
fi

# Extract colors from the JSON file
declare -A colors
while read -r key value; do
	colors[$key]=$value
done < <(jq -r '.colors | to_entries[] | "\(.key) \(.value)"' "$COLOR_FILE")

# Function to lighten a color
lighten_color() {
	local color="$1"
	local amount="$2"
	printf "#%02x%02x%02x" \
		$(((0x${color:1:2} + amount > 255) ? 255 : (0x${color:1:2} + amount))) \
		$(((0x${color:3:2} + amount > 255) ? 255 : (0x${color:3:2} + amount))) \
		$(((0x${color:5:2} + amount > 255) ? 255 : (0x${color:5:2} + amount)))
}

# Update colors in the theme file
tmpfile=$(mktemp)

while IFS= read -r line; do
	if [[ $line =~ theme\.bg_normal ]]; then
		normal_color="${colors[background]}"
		focus_color=$(lighten_color "${colors[background]}" 30)
		echo "theme.bg_normal = \"${normal_color}\"" >>"$tmpfile"
		echo "theme.bg_focus = \"${focus_color}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.bg_focus ]]; then
		# Skip this line as bg_focus will be handled in bg_normal block
		continue
	elif [[ $line =~ theme\.bg_urgent ]]; then
		echo "theme.bg_urgent = \"${colors[error]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.fg_normal ]]; then
		echo "theme.fg_normal = \"${colors[onBackground]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.fg_focus ]]; then
		echo "theme.fg_focus = \"${colors[onSurface]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.fg_urgent ]]; then
		echo "theme.fg_urgent = \"${colors[onError]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.tasklist_bg_focus ]]; then
		echo "theme.tasklist_bg_focus = \"${focus_color}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.tasklist_bg_urgent ]]; then
		echo "theme.tasklist_bg_urgent = \"${focus_color}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.tasklist_fg_normal ]]; then
		echo "theme.tasklist_fg_normal = \"${colors[onBackground]}25\"" >>"$tmpfile"
	elif [[ $line =~ theme\.tasklist_fg_focus ]]; then
		echo "theme.tasklist_fg_focus = \"${colors[onBackground]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.tasklist_fg_urgent ]]; then
		echo "theme.tasklist_fg_urgent = \"${colors[error]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.tasklist_fg_minimize ]]; then
		echo "theme.tasklist_fg_minimize = \"${colors[onBackground]}25\"" >>"$tmpfile"
	elif [[ $line =~ theme\.taglist_fg_focus ]]; then
		echo "theme.taglist_fg_focus = \"${colors[onBackground]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.taglist_fg_empty ]]; then
		echo "theme.taglist_fg_empty = \"${colors[onBackground]}25\"" >>"$tmpfile"
	elif [[ $line =~ theme\.taglist_bg_focus ]]; then
		echo "theme.taglist_bg_focus = \"${colors[secondary_paletteKeyColor]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.taglist_bg_occupied ]]; then
		echo "theme.taglist_bg_occupied = \"${focus_color}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.taglist_bg_empty ]]; then
		echo "theme.taglist_bg_empty = \"${focus_color}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.taglist_bg_urgent ]]; then
		echo "theme.taglist_bg_urgent = \"${colors[error]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.bg_systray ]]; then
		echo "theme.bg_systray = \"${focus_color}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.border_color_normal ]]; then
		echo "theme.border_color_normal = \"${colors[background]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.border_color_active ]]; then
		echo "theme.border_color_active = \"${colors[primary]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.border_color_marked ]]; then
		echo "theme.border_color_marked = \"${colors[background]}\"" >>"$tmpfile"
	elif [[ $line =~ theme\.battery ]]; then
		echo "theme.battery = \"${colors[onBackground]}\"" >>"$tmpfile"
	else
		echo "$line" >>"$tmpfile"
	fi
done <"$THEME_FILE"

mv "$tmpfile" "$THEME_FILE"

echo "Colors updated in theme.lua"
