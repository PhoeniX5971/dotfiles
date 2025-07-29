local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local config = require("config")

local theme = {}

theme.font = "DM Mono Bold " .. 14 * config.dpi_multiplier

theme.bg_normal = "#201f21"
theme.bg_focus = "#5BABEB"
theme.bg_urgent = "#5FCBFD"

theme.fg_normal = "#dee8f1"
theme.fg_focus = "#C2BAC8"
theme.fg_urgent = "#5BABEB"

theme.tasklist_bg_focus = "#201f21"
theme.tasklist_bg_urgent = "#201f21"
theme.tasklist_fg_normal = "#dee8f125"
theme.tasklist_fg_focus = "#dee8f1"
theme.tasklist_fg_urgent = "#9098A8"
theme.tasklist_fg_minimize = "#dee8f125"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold " .. 13 * config.dpi_multiplier
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "#C2BAC8"
theme.taglist_fg_empty = "#dee8f125"
theme.taglist_fg_occupied = "#dee8f1"
theme.taglist_fg_urgent = "#5BABEB"
theme.taglist_bg_focus = "#00000000"
theme.taglist_bg_occupied = "#00000000"
theme.taglist_bg_empty = "#00000000"
theme.taglist_bg_urgent = "#9098A8"

theme.bg_systray = "#5BABEB"
theme.systray_icon_spacing = dpi(8) * config.dpi_multiplier

theme.useless_gap = dpi(8) * config.dpi_multiplier
theme.border_width = dpi(2) * config.dpi_multiplier
theme.border_color_normal = "#201f21"
theme.border_color_active = "#5FCBFD"
theme.border_color_marked = "#201f21"
theme.tooltip_opacity = 0

theme.battery = "#dee8f1"
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
