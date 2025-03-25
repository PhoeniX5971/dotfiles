local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local theme = {}

theme.font = "DM Mono Bold 14"

theme.bg_normal = "#1b1633"
theme.bg_focus = "#675BA9"
theme.bg_urgent = "#6A64D4"

theme.fg_normal = "#c6c6ea"
theme.fg_focus = "#7689E2"
theme.fg_urgent = "#675BA9"

theme.tasklist_bg_focus = "#1b1633"
theme.tasklist_bg_urgent = "#1b1633"
theme.tasklist_fg_normal = "#c6c6ea25"
theme.tasklist_fg_focus = "#c6c6ea"
theme.tasklist_fg_urgent = "#8D6BA7"
theme.tasklist_fg_minimize = "#c6c6ea25"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold 13"
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "#7689E2"
theme.taglist_fg_empty = "#c6c6ea25"
theme.taglist_fg_occupied = "#c6c6ea"
theme.taglist_fg_urgent = "#675BA9"
theme.taglist_bg_focus = "#00000000"
theme.taglist_bg_occupied = "#00000000"
theme.taglist_bg_empty = "#00000000"
theme.taglist_bg_urgent = "#8D6BA7"

theme.bg_systray = "#675BA9"
theme.systray_icon_spacing = 8

theme.useless_gap = dpi(8)
theme.border_width = dpi(4)
theme.border_color_normal = "#1b1633"
theme.border_color_active = "#6A64D4"
theme.border_color_marked = "#1b1633"
theme.tooltip_opacity = 0

theme.battery = "#c6c6ea"
theme.battery_green = "#00ff00"
theme.battery_yellow = "#ffff00"
theme.battery_red = "#ff0000"

theme.hotkeys_font = "DM Mono 14"
theme.hotkeys_description_font = "DM Mono 12"

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
