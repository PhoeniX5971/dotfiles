local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- Start polkit authentication agent
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
awful.spawn.with_shell("nm-applet")

-- Bind Caps to Esc
awful.spawn.with_shell("setxkbmap -option caps:escape")

-- Start picom (with your config file)
awful.spawn.with_shell("picom")

-- Put this in rc.lua or call from Lua prompt
awful.screen.connect_for_each_screen(function(s)
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end)
