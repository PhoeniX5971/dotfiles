local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local config = require("config")

local theme = {}

theme.font = "DM Mono Bold " .. 14 * config.dpi_multiplier

theme.bg_normal = "#000002"
theme.bg_focus = "#0B52A4"
theme.bg_urgent = "#3F74B7"

theme.fg_normal = "#c6e6ee"
theme.fg_focus = "#5DB0E4"
theme.fg_urgent = "#0B52A4"

theme.tasklist_bg_focus = "#000002"
theme.tasklist_bg_urgent = "#000002"
theme.tasklist_fg_normal = "#c6e6ee25"
theme.tasklist_fg_focus = "#c6e6ee"
theme.tasklist_fg_urgent = "#0A6CD4"
theme.tasklist_fg_minimize = "#c6e6ee25"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold " .. 13 * config.dpi_multiplier
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "#5DB0E4"
theme.taglist_fg_empty = "#c6e6ee25"
theme.taglist_fg_occupied = "#c6e6ee"
theme.taglist_fg_urgent = "#0B52A4"
theme.taglist_bg_focus = "#00000000"
theme.taglist_bg_occupied = "#00000000"
theme.taglist_bg_empty = "#00000000"
theme.taglist_bg_urgent = "#0A6CD4"

theme.bg_systray = "#0B52A4"
theme.systray_icon_spacing = dpi(8) * config.dpi_multiplier

theme.useless_gap = dpi(8) * config.dpi_multiplier
theme.border_width = dpi(2) * config.dpi_multiplier
theme.border_color_normal = "#000002"
theme.border_color_active = "#0A6CD4"
theme.border_color_marked = "#000002"
theme.tooltip_opacity = 0

theme.battery = "#c6e6ee"
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
