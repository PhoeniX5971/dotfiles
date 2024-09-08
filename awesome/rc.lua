pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "An error occured" .. (startup and " during startup." or "."),
		message = message,
	})
end)

awful.spawn.with_shell("~/.config/awesome/autostart.sh")
beautiful.init("~/.config/awesome/theme/theme.lua")

require("config")
require("ui")
require("user")
require("scripts")
