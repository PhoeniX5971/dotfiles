local awful = require("awful")

-- Start polkit authentication agent
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

-- Start picom (with your config file)
awful.spawn.with_shell("picom")
