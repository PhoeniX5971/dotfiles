local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local theme = {}

theme.font = "DM Mono Bold 14"

theme.bg_normal = "#0a0a0a"
theme.bg_focus = "#778476"
theme.bg_urgent = "#80877D"

theme.fg_normal = "#e4eae2"
theme.fg_focus = "#BAC7BC"
theme.fg_urgent = "#778476"

theme.tasklist_bg_focus = "#0a0a0a"
theme.tasklist_bg_urgent = "#0a0a0a"
theme.tasklist_fg_normal = "#e4eae225"
theme.tasklist_fg_focus = "#e4eae2"
theme.tasklist_fg_urgent = "#778484"
theme.tasklist_fg_minimize = "#e4eae225"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold 13"
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "#BAC7BC"
theme.taglist_fg_empty = "#e4eae225"
theme.taglist_fg_occupied = "#e4eae2"
theme.taglist_fg_urgent = "#778476"
theme.taglist_bg_focus = "#00000000"
theme.taglist_bg_occupied = "#00000000"
theme.taglist_bg_empty = "#00000000"
theme.taglist_bg_urgent = "#778484"

theme.bg_systray = "#778476"
theme.systray_icon_spacing = 8

theme.useless_gap = dpi(8)
theme.border_width = dpi(4)
theme.border_color_normal = "#0a0a0a"
theme.border_color_active = "#80877D"
theme.border_color_marked = "#0a0a0a"
theme.tooltip_opacity = 0

theme.battery = "#e4eae2"
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
