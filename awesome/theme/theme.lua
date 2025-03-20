local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local theme = {}

theme.font = "DM Mono Bold 14"

theme.bg_normal = "#131313"
theme.bg_focus = "#313131"
theme.bg_urgent = "#ffb4ab"

theme.fg_normal = "#e2e2e2"
theme.fg_focus = "#e2e2e2"
theme.fg_urgent = "#690005"

theme.tasklist_bg_focus = "#313131"
theme.tasklist_bg_urgent = "#313131"
theme.tasklist_fg_normal = "#e2e2e225"
theme.tasklist_fg_focus = "#e2e2e2"
theme.tasklist_fg_urgent = "#ffb4ab"
theme.tasklist_fg_minimize = "#e2e2e225"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold 13"
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "#e2e2e2"
theme.taglist_fg_empty = "#e2e2e225"
theme.taglist_bg_focus = "#070707"
theme.taglist_bg_occupied = "#313131"
theme.taglist_bg_empty = "#313131"
theme.taglist_bg_urgent = "#ffb4ab"

theme.bg_systray = "#313131"
theme.systray_icon_spacing = 8

theme.useless_gap = dpi(8)
theme.border_width = dpi(4)
theme.border_color_normal = "#131313"
theme.border_color_active = "#ffffff"
theme.border_color_marked = "#131313"
theme.tooltip_opacity = 0

theme.battery = "#e2e2e2"
theme.battery = "#e2e2e2"
theme.battery = "#e2e2e2"
theme.battery = "#e2e2e2"

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "theme/wallpaper.jpg"

gears.wallpaper.maximized(theme.wallpaper)

return theme
