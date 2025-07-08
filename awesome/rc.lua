-- ~/.config/awesome/rc.lua
-- Load libraries
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
require("awful.autofocus")

--[[
	Error handling:
	This will run if an error is encountered and
	send a notification specifying what happened.
	It's best to put this at the start of the file.
--]]
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "An error occured" .. (startup and " during startup." or "."),
		message = message,
	})
end)

-- Set variables
terminal = "kitty"
modkey = "Mod4"

-- Load files
require("bind")
require("rule")
require("ui")
require("theme")
require("autostart")

--[[
	Layouts:
	This specifies the layouts available to the user.
	To see more layouts, read the docs on awful.layout.
--]]
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile, -- Default tiling (master on left, slaves on right)
		awful.layout.suit.tile.left, -- Master on right, slaves on left
		awful.layout.suit.tile.bottom, -- Master on top, slaves on bottom
		awful.layout.suit.tile.top, -- Master on bottom, slaves on top
		awful.layout.suit.fair, -- Fair layout (equal sizes, vertical)
		awful.layout.suit.fair.horizontal, -- Fair layout (equal sizes, horizontal)
		awful.layout.suit.spiral, -- Spiral layout (like Fibonacci)
		awful.layout.suit.spiral.dwindle, -- Dwindling spiral (more compact)
		awful.layout.suit.magnifier, -- Magnifier layout (big focused window)
	})
end)

--[[
	Tags:
	This specifies the tags available to the user.
	These will be added to each connected screen
	and set the layout to the first in the layout table.
--]]
screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, s, awful.layout.layouts[1])
end)

--[[
	Sloppy focus:
	This will focus clients when your mouse hovers over them.
--]]
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

--[[
	Tiling fix:
	This puts new windows at the bottom of the stack
	instead of replacing the master window.
--]]
client.connect_signal("manage", function(c)
	if not awesome.startup then
		awful.client.setslave(c)
	end
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("manage", function(c)
	c.shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, dpi(8)) -- Apply rounded corners to clients
	end
end)
