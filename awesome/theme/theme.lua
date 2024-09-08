local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local user = require("user")
local colorsheme = require("theme.colors." .. user.color)

local theme = {}

theme.font = "JetBrainsMono Nerd Font 11"
theme.useless_gap = 5

-- icons --

theme.notification_wifi_icon = "~/.config/awesome/theme/icons/wifi.svg"
theme.battery_icon = "~/.config/awesome/theme/icons/battery.svg"
theme.profile_image = "~/.config/awesome/theme/icons/profile_img.svg"
theme.notification_icon = "~/.config/awesome/theme/icons/bell.svg"
theme.notification_icon_error = "~/.config/awesome/theme/icons/alert.svg"
theme.notification_icon_screenshot = "~/.config/awesome/theme/icons/camera.svg"
theme.no_song = user.home .. ".config/awesome/theme/icons/nosong.jpg"

-- colors --

theme.bg = colorsheme.bg
theme.bg_alt = colorsheme.bg_alt
theme.bg_urgent = colorsheme.bg_urgent
theme.fg_alt = colorsheme.fg_alt
theme.fg = colorsheme.fg

theme.green = colorsheme.green
theme.yellow = colorsheme.yellow
theme.blue = colorsheme.blue
theme.cyan = colorsheme.cyan
theme.red = colorsheme.red
theme.orange = colorsheme.orange
theme.violet = colorsheme.violet
theme.accent2 = colorsheme.accent2
theme.accent = colorsheme.accent

-- tray --

theme.bg_systray = theme.bg_alt
theme.systray_icon_spacing = 6

-- titlebar --

theme.titlebar_bg_normal = theme.bg_alt
theme.titlebar_fg_normal = theme.fg
theme.titlebar_bg_focus = theme.bg_alt
theme.titlebar_fg_focus = theme.fg
theme.titlebar_bg_urgent = theme.bg_alt
theme.titlebar_fg_urgent = theme.fg

-- borders --

theme.border_width = 2
theme.border_color_normal = theme.bg_urgent
theme.border_color_active = theme.accent

-- default vars --

theme.bg_normal = theme.bg
theme.fg_normal = theme.fg

-- notification --

theme.notification_spacing = theme.useless_gap * 4 + theme.border_width * 2

-- tasklist --

theme.tasklist_bg_normal = theme.bg_alt
theme.tasklist_bg_focus = theme.accent
theme.tasklist_bg_urgent = theme.fg
theme.tasklist_bg_minimize = theme.bg_alt

-- taglist --

theme.taglist_bg_focus = theme.accent
theme.taglist_fg_focus = theme.bg
theme.taglist_bg_urgent = theme.fg_alt
theme.taglist_fg_urgent = theme.fg
theme.taglist_bg_occupied = theme.accent2
theme.taglist_fg_occupied = theme.fg
theme.taglist_bg_empty = theme.bg_alt
theme.taglist_fg_empty = theme.fg
theme.taglist_bg_volatile = theme.bg_alt
theme.taglist_fg_volatile = theme.fg

-- bling --

theme.playerctl_player = { "%any" }
theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1

-- tooltips --

theme.tooltip_bg = theme.bg
theme.tooltip_fg = theme.fg
theme.tooltip_border_width = theme.border_width
theme.bat_icon_charge = gears.color.recolor_image(user.home .. ".config/awesome/theme/icons/battery.svg", theme.green)
theme.bat_icon_low = gears.color.recolor_image(user.home .. ".config/awesome/theme/icons/battery.svg", theme.yellow)
theme.bat_icon_crit = gears.color.recolor_image(user.home .. ".config/awesome/theme/icons/battery.svg", theme.red)

theme.cursor_theme = "/home/phoenix/.icons/miku-cursor-linux"

return theme
