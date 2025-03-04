local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local theme = {}

theme.font = "DM Mono Bold 14"

theme.bg_normal = "#0d0e34"
theme.bg_focus = "#2b2c52"
theme.bg_urgent = "#ffb4ab"

theme.fg_normal = "#e1e0ff"
theme.fg_focus = "#e1e0ff"
theme.fg_urgent = "#690005"

theme.tasklist_bg_focus = "#2b2c52"
theme.tasklist_bg_urgent = "#2b2c52"
theme.tasklist_fg_normal = "#e1e0ff25"
theme.tasklist_fg_focus = "#e1e0ff"
theme.tasklist_fg_urgent = "#ffb4ab"
theme.tasklist_fg_minimize = "#e1e0ff25"
theme.tasklist_font_minimized = "JetBrains Mono NF Italic Bold 13"
theme.tasklist_plain_task_name = true

theme.taglist_fg_focus = "#e1e0ff"
theme.taglist_fg_empty = "#e1e0ff25"
theme.taglist_bg_focus = "#686cd2"
theme.taglist_bg_occupied = "#2b2c52"
theme.taglist_bg_empty = "#2b2c52"
theme.taglist_bg_urgent = "#ffb4ab"

theme.bg_systray = "#2b2c52"
theme.systray_icon_spacing = 8

theme.useless_gap = dpi(8)
theme.border_width = dpi(4)
theme.border_color_normal = "#0d0e34"
theme.border_color_active = "#c0c1ff"
theme.border_color_marked = "#0d0e34"
theme.tooltip_opacity = 0

theme.battery = "#e1e0ff"
theme.battery = "#e1e0ff"
theme.battery = "#e1e0ff"
theme.battery = "#e1e0ff"

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "theme/wallpaper.jpg"

gears.wallpaper.maximized(theme.wallpaper)

return theme
