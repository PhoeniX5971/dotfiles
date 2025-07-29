local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- Start polkit authentication agent
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
awful.spawn.with_shell("nm-applet")

-- Bind Caps to Esc
awful.spawn.with_shell("setsid setxkbmap -option caps:escape >/dev/null 2>&1 &")

-- Start picom (with your config file)
awful.spawn.with_shell("picom")

-- Start xfce4 power manager
awful.spawn.with_shell("xfce4-power-manager")

awful.spawn.with_shell("parcellite")

-- Update betterlockscreen wallpaper
awful.spawn.with_shell("betterlockscreen -u ~/.cache/current_wallpaper.png")

-- For different screen sizes
awful.screen.connect_for_each_screen(function(s)
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end)
