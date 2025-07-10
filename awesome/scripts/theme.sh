#!/bin/bash

# Paths
THEME_FILE="$HOME/.config/awesome/theme/theme.lua"
WAL_COLORS="$HOME/.cache/wal/colors.sh"

# Ensure the Pywal colors file exists
if [ ! -f "$WAL_COLORS" ]; then
	echo "Pywal colors file not found: $WAL_COLORS"
	exit 1
fi

# Source Pywal colors
source "$WAL_COLORS"

# Assign Pywal colors to theme variables
bg_normal="$background"
bg_focus="$color1"
bg_urgent="$color2"

fg_normal="$foreground"
fg_focus="$color5"
fg_urgent="$color1"

tasklist_fg_normal="${foreground}25"
tasklist_fg_focus="$foreground"
tasklist_fg_urgent="$color3"

taglist_fg_empty="${foreground}25"
taglist_fg_focus="$fg_focus"
taglist_fg_occupied="$fg_normal"
taglist_fg_urgent="$fg_urgent"
taglist_bg_focus="#00000000"    # Transparent background for taglist focus
taglist_bg_occupied="#00000000" # Transparent background for taglist occupied
taglist_bg_empty="#00000000"    # Transparent background for taglist empty
taglist_bg_urgent="$color3"     # Keep taglist urgent background as normal

border_color_active="$color2"

# Write new theme.lua
cat >"$THEME_FILE" <<EOF
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local config = require("config")

local theme = {}

theme.font = "DM Mono Bold " .. 14 * config.dpi_multiplier

theme.bg_normal = "$bg_normal"
theme.bg_focus = "$bg_focus"
theme.bg_urgent = "$bg_urgent"

theme.fg_normal = "$fg_normal"
theme.fg_focus = "$fg_focus"
theme.fg_urgent = "$fg_urgent"

theme.tasklist_bg_focus = "$bg_normal"
theme.tasklist_bg_urgent = "$bg_normal"
theme.tasklist_fg_normal = "$tasklist_fg_normal"
theme.tasklist_fg_focus = "$tasklist_fg_focus"
theme.tasklist_fg_urgent = "$tasklist_fg_urgent"
theme.tasklist_fg_minimize = "$tasklist_fg_normal"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold " .. 13 * config.dpi_multiplier
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "$taglist_fg_focus"
theme.taglist_fg_empty = "$taglist_fg_empty"
theme.taglist_fg_occupied = "$taglist_fg_occupied"
theme.taglist_fg_urgent = "$taglist_fg_urgent"
theme.taglist_bg_focus = "$taglist_bg_focus"
theme.taglist_bg_occupied = "$taglist_bg_occupied"
theme.taglist_bg_empty = "$taglist_bg_empty"
theme.taglist_bg_urgent = "$taglist_bg_urgent"

theme.bg_systray = "$bg_focus"
theme.systray_icon_spacing = dpi(8) * config.dpi_multiplier

theme.useless_gap = dpi(8) * config.dpi_multiplier
theme.border_width = dpi(2) * config.dpi_multiplier
theme.border_color_normal = "$bg_normal"
theme.border_color_active = "$border_color_active"
theme.border_color_marked = "$bg_normal"
theme.tooltip_opacity = 0

theme.battery = "$fg_normal"
theme.battery_green = "#00ff00"
theme.battery_yellow = "#ffff00"
theme.battery_red = "#ff0000"

theme.hotkeys_font = "DM Mono Bold " .. 14 * config.dpi_multiplier
theme.hotkeys_description_font = "DM Mono Bold " .. 14 * config.dpi_multiplier
theme.hotkeys_border_color = theme.border_color_active

theme.layout_fairh = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/fairhw.png"
theme.layout_fairv = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/fairvw.png"
theme.layout_floating = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/floatingw.png"
theme.layout_magnifier = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/magnifierw.png"
theme.layout_max = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/maxw.png"
theme.layout_fullscreen = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/fullscreenw.png"
theme.layout_tilebottom = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/tilebottomw.png"
theme.layout_tileleft = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/tileleftw.png"
theme.layout_tile = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/tilew.png"
theme.layout_tiletop = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/tiletopw.png"
theme.layout_spiral = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/spiralw.png"
theme.layout_dwindle = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/dwindlew.png"
theme.layout_cornernw = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/cornernww.png"
theme.layout_cornerne = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/cornernew.png"
theme.layout_cornersw = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/cornersww.png"
theme.layout_cornerse = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/cornersew.png"
theme.layout_grid = gears.filesystem.get_configuration_dir() .. "theme/default/layouts/gridw.png"

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "theme/wallpaper.jpg"

gears.wallpaper.maximized(theme.wallpaper)

return theme
EOF

echo "Updated AwesomeWM theme with Pywal colors."

# Restart AwesomeWM
awesome-client 'awesome.restart()'
